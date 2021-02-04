import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Auth _auth = Auth();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF303960),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(
                      'assets/logo-1.png',
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'RING',
                        style: GoogleFonts.nunito(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'АССОЦИАЦИЯ\nДОБРЫХ ЛЮДЕЙ',
                        style: GoogleFonts.nunito(
                          color: Color(0xFF81FFF7),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[700],
                ),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {},
                        onChanged: (value) {
                          setState(() {
                            return email = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Email', icon: Icon(Icons.email)),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            return password = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Password', icon: Icon(Icons.lock)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.facebook,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.google,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.instagram,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {}),
                        ],
                      ),
                      FlatButton(
                        onPressed: () async {
                          dynamic result = await _auth
                              .signInWithEmailandPassword(email, password);
                          if (result == null) {
                            print('youve got an error!');
                          }
                        },
                        color: Colors.transparent,
                        child: Text(
                          'ВОЙТИ',
                          style: GoogleFonts.nunito(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    widget.toggleView();
                  },
                  child: Text(
                    'Нету Аккаунта? Так давай создадим!',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
