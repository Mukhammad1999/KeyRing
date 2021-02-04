import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/services/database.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    Key key,
  }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  GoogleMapController mapController;
  DateTime _dateTime;
  List<Marker> markers = [];
  var taskPosition;
  final taskFormkey = GlobalKey<FormState>();
  var currentlocation;
  bool mapToggle = false;
  bool loading = false;

  static String title = '';
  static String description = '';
  static String award;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       IconButton(
          //         onPressed: () {},
          //         icon: Icon(
          //           Icons.menu,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //       IconButton(
          //         onPressed: () {},
          //         icon: Icon(
          //           Icons.search,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 19),
              child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).accentColor,
                ),
                child: Form(
                  key: taskFormkey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Добавьте свое задание!',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value.isEmpty
                            ? 'Задание без заголовка выглядит скучно. Введите Заголовок:)'
                            : null,
                        onChanged: (value) {
                          return title = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Заголовок',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) => value.isEmpty
                            ? 'Задание без описания...хммм..креативно... '
                            : null,
                        onChanged: (value) {
                          return description = value;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Описание',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsFormatter()],
                        decoration: InputDecoration(
                          hintText: 'Вознаграждение',
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Альтруисты вперед!' : null,
                        onChanged: (value) {
                          return award = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Выберите Дедлайн задания!'),
                          IconButton(
                              icon: Icon(
                                Icons.date_range,
                                size: 50,
                              ),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime(2222))
                                    .then((value) {
                                  setState(() {
                                    _dateTime = value;
                                    print(_dateTime.toString());
                                  });
                                });
                              }),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Добавьте точку на карте!',
                            ),
                            FlatButton(
                              onPressed: () async {
                                await _loadMap();
                                showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setMapState) {
                                        return mapToggle
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.8,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: GoogleMap(
                                                  onTap: (tappedPoint) {
                                                    setMapState(() {
                                                      markers = [];
                                                      markers.add(Marker(
                                                          markerId: MarkerId(
                                                              tappedPoint
                                                                  .toString()),
                                                          position:
                                                              tappedPoint));
                                                      taskPosition =
                                                          tappedPoint;
                                                      print(currentlocation);
                                                    });
                                                  },
                                                  markers: Set.from(markers),
                                                  onMapCreated: (controller) {
                                                    setState(() {
                                                      mapController =
                                                          controller;
                                                    });
                                                  },
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    zoom: 10,
                                                    target: LatLng(
                                                        currentlocation
                                                            .latitude,
                                                        currentlocation
                                                            .longitude),
                                                  ),
                                                ))
                                            : SpinKitFadingCircle(
                                                color: Colors.white,
                                              );
                                      });
                                    });
                              },
                              child: Row(
                                children: <Widget>[
                                  Text('Add Location'),
                                  Icon(Icons.location_on)
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {},
                              child: Row(
                                children: <Widget>[
                                  Text('Прикрепить файл'),
                                  Icon(Icons.file_upload)
                                ],
                              ),
                            ),
                            FlatButton(
                              hoverColor: Colors.green,
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                if (taskFormkey.currentState.validate()) {
                                  final FirebaseUser user =
                                      await auth.currentUser();
                                  final uid = user.uid;
                                  await DatabaseService(uid: uid)
                                      .updateTaskData(
                                          title,
                                          uid,
                                          description,
                                          award,
                                          false,
                                          false,
                                          _dateTime,
                                          taskPosition);
                                } else {}
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Опубликовать'),
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _loadMap() async {
    await Geolocator().getCurrentPosition().then((value) {
      setState(() {
        currentlocation = value;
        mapToggle = true;
      });
    });
  }
}
