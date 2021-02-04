import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/services/database.dart';
import 'package:key_ring/shared/loading.dart';
import 'package:provider/provider.dart';

class MyTaskDetail extends StatefulWidget {
  final String taskId;
  MyTaskDetail({this.taskId});
  @override
  _MyTaskDetailState createState() => _MyTaskDetailState();
}

class _MyTaskDetailState extends State<MyTaskDetail> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Task>(
        stream: DatabaseService(uid: user.uid).showTaskDetail(widget.taskId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Task task = snapshot.data;
            return SafeArea(
                child: Column(
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                )
              ],
            ));
          } else {
            return Loading();
          }
        });
  }
}
