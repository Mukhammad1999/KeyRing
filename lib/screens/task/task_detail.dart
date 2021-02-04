import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/services/database.dart';
import 'package:provider/provider.dart';

class TaskDetail extends StatefulWidget {
  final Task task;
  @override
  _TaskDetailState createState() => _TaskDetailState();

  TaskDetail({this.task});
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/HomeBg.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 18.0, left: 10, right: 10, bottom: 0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 19.0, left: 10, right: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.task.title,
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                          Text(
                            widget.task.description,
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                          Text(
                            widget.task.award.toString(),
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                          Text(
                            widget.task.title,
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 150,
                    bottom: 0,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        dynamic result = await DatabaseService(uid: user.uid)
                            .addToStackList(widget.task.id, widget.task.author);
                        if (result == null) {
                          print('added');
                        } else {
                          print(result);
                        }
                      },
                      child: Text('Приступить'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
