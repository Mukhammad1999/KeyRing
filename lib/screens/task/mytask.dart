import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/screens/task/mytaskDetailChange.dart';
import 'package:key_ring/services/database.dart';
import 'package:key_ring/shared/loading.dart';
import 'package:provider/provider.dart';

class MyTaskList extends StatefulWidget {
  final List myTaskStack;
  MyTaskList({this.myTaskStack});
  @override
  _MyTaskListState createState() => _MyTaskListState();
}

class _MyTaskListState extends State<MyTaskList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text(
            'Мои объявления',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView.builder(
                    itemCount: widget.myTaskStack.length,
                    itemBuilder: (context, index) {
                      Task singleTask = widget.myTaskStack[index];

                      return GestureDetector(
                        onTap: () {
                          print(singleTask.author);
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 20),
                              child: Container(
                                alignment: Alignment.center,
                                height: 120,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      singleTask.title.toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 90),
                                      child: Divider(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          singleTask.award
                                                  .replaceAll(",", " ") +
                                              " UZS",
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.green[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            singleTask.dueDate
                                                .toUtc()
                                                .toLocal()
                                                .toString(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 120,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Colors.blueGrey,
                                      onPressed: () {},
                                      child: Text(
                                        'Изменить',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: Colors.red,
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MyTaskDetail(
                                                      taskId: singleTask.id,
                                                    )));
                                      },
                                      child: Text('Удалить',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
