import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/screens/task/mytask.dart';
import 'package:key_ring/services/auth.dart';
import 'package:key_ring/services/database.dart';
import 'package:key_ring/shared/loading.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final myTaskStack = Provider.of<List<Task>>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await _auth.signOut();
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await _auth.signOut();
                            })
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyTaskList(
                              myTaskStack: myTaskStack,
                            ),
                          ));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      backgroundImage: AssetImage(
                        'assets/person.png',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 158.0),
                    child: Divider(
                      color: Colors.white,
                      height: 20,
                    ),
                  ),
                  Text(
                    'Имя',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.name,
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Телефон',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.phone_number,
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Заданий выполнено',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.dtasks.toString(),
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Объявлений',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.tasks_announced.toString(),
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Рейтинг',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.rating.toString(),
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Статус Аккаунта',
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  Text(
                    userData.acc_activated
                        ? 'Прошел проверку'
                        : 'Не подтвержден',
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  Text(
                    userData.acc_activated
                        ? 'asd'
                        : '*Аккаунт будет подтвержден после выполнения 10 заданий',
                    style: GoogleFonts.lato(color: Colors.red),
                  ),
                ],
              ),
            );
          } else {
            return //Loading();
                FlatButton(
                    onPressed: () {
                      _auth.signOut();
                    },
                    child: Text('sign out'));
          }
        });
  }
}
