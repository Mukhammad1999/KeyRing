import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/screens/task/task_detail.dart';
import 'package:key_ring/services/database.dart';
import 'package:key_ring/services/database.dart';
import 'package:provider/provider.dart';

class TaskLisk extends StatefulWidget {
  @override
  _TaskLiskState createState() => _TaskLiskState();
}

class _TaskLiskState extends State<TaskLisk>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final tasks = Provider.of<List<Task>>(context) ?? [];
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {})
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    Task task = tasks[index];
                    print(task.dueDate.toString());
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TaskDetail(
                                    task: task,
                                  ))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 18.0),
                              child: Container(
                                height: 210,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: Colors.grey[900],
                                  //       spreadRadius: 3,
                                  //       blurRadius: 5,
                                  //       offset: Offset(0, 6))
                                  // ],
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        task.title.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        task.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            color: Colors.white54),
                                      ),
                                      Text(
                                        task.dueDate.toUtc().toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            color: Colors.white54),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${task.award.replaceAll(",", " ")} USZ',
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700]),
                                          ),
                                          Text(task.author),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 128),
                                        child: Divider(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              top: 200,
                              left: 150,
                              child: user.uid != task.uid
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: FlatButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        onPressed: () async {
                                          dynamic result =
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .addToStackList(
                                                      task.id, task.author);
                                          if (result == null) {
                                            print('added');
                                          } else {
                                            print(result);
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          'Приступить',
                                          style: GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    )
                                  : Text(''),
                            )
                          ],
                          overflow: Overflow.visible,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
