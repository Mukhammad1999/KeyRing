import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:key_ring/services/auth.dart';
import 'package:key_ring/shared/loading.dart';
import 'dart:io';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
];

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int currentStep = 0;
  bool complete = false;
  static String email = '';
  static String password = '';
  static String name = '';
  static String phone_number = '';
  static String imgUrl = '';

  next() {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  List<Step> steps = [
    Step(
      isActive: true,
      title: Text(
        'Первый шаг',
        style: GoogleFonts.nunito(
          color: Colors.white,
        ),
      ),
      content: Form(
        key: formKeys[0],
        child: Column(
          children: <Widget>[
            Text(
              'Для начала введи email и пароль. Они нужны, чтобы проходить авторизацию',
              style: GoogleFonts.nunito(
                color: Colors.grey[400],
              ),
            ),
            TextFormField(
              onChanged: (value) {
                return email = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'Введите мыло для начала' : null,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Email',
                hoverColor: Colors.amber,
              ),
            ),
            TextFormField(
              onChanged: (value) {
                return password = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'Введите пароль для начала' : null,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: Icon(Icons.vpn_key),
                hintText: 'Пароль',
                hoverColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    ),
    Step(
      title: Text('Что-то важное'),
      content: Form(
        key: formKeys[1],
        child: Column(
          children: <Widget>[
            Text(
              'Введи свое Имя и  номер телефона, естественно',
              style: GoogleFonts.nunito(
                color: Colors.grey[400],
              ),
            ),
            TextFormField(
              onChanged: (value) {
                return name = value;
              },
              validator: (value) => value.isEmpty ? 'Введите имя!' : null,
              decoration: InputDecoration(
                  hintText: 'Имя',
                  icon: Icon(Icons.person),
                  focusColor: Colors.amber),
            ),
            TextFormField(
              onChanged: (value) {
                return phone_number = value;
              },
              validator: (value) =>
                  value.isEmpty ? 'Введите номер телефона!' : null,
              decoration: InputDecoration(
                  hintText: 'Номер телефона', icon: Icon(Icons.phone)),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            extendBody: true,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/background.png',
                      ),
                      fit: BoxFit.cover),
                ),
                child: Column(
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
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[700],
                        ),
                        child: Stepper(
                            steps: steps,
                            currentStep: currentStep,
                            onStepContinue: () {
                              if (currentStep != steps.length - 1) {
                                goTo(currentStep + 1);
                              }
                            },
                            onStepTapped: (value) => goTo(value),
                            onStepCancel: () {
                              if (currentStep != 0) {
                                goTo(currentStep - 1);
                              }
                            },
                            controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) {
                              if (currentStep == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.amber,
                                        child: Text('Далее'),
                                        textColor: Colors.white,
                                        onPressed: () {
                                          if (formKeys[currentStep]
                                              .currentState
                                              .validate()) {
                                            onStepContinue();
                                          }
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Назад'),
                                        onPressed: onStepCancel,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (currentStep == 1) {
                                return Row(
                                  children: <Widget>[
                                    FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          if (formKeys[currentStep]
                                              .currentState
                                              .validate()) {
                                            loading = true;
                                            _auth.registerWithEmailandPassword(
                                                email,
                                                password,
                                                name,
                                                0,
                                                0,
                                                false,
                                                phone_number,
                                                '');
                                          }
                                        },
                                        child: Text(
                                          'Стать частью сообщества',
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                          ),
                                        )),
                                    FlatButton(
                                        onPressed: onStepCancel,
                                        child: Text('Назад'))
                                  ],
                                );
                              }
                            }),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          'Есть Аккаунт?Так зайди в него!',
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
