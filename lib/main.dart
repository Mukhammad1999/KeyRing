import 'package:flutter/material.dart';
import 'package:key_ring/services/auth.dart';
import 'package:key_ring/wrapper.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber,
          accentColor: Colors.grey[700],
        ),
        home: Wrapper(),
      ),
    );
  }
}
