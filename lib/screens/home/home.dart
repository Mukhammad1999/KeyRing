import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/screens/home/addtask.dart';
import 'package:key_ring/screens/task/task_list.dart';
import 'package:key_ring/screens/home/user_page.dart';
import 'package:key_ring/services/auth.dart';
import 'package:key_ring/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Auth _auth = Auth();
  Animation<double> animation;
  var _bottomnavIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.add,
    Icons.verified_user,
  ];

  static List<Widget> widget_list = <Widget>[
    TaskLisk(),
    AddTask(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Task>>.value(
      value: DatabaseService().tasks,
      child: Scaffold(
        extendBody: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/HomeBg.png'), fit: BoxFit.cover),
          ),
          child: widget_list.elementAt(_bottomnavIndex),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _bottomnavIndex,
          activeColor: Theme.of(context).primaryColor,
          splashColor: Colors.white,
          inactiveColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.transparent,
          notchAndCornersAnimation: animation,
          onTap: (index) {
            setState(() {
              _bottomnavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
