import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/HomeBg.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
