import 'package:google_maps_flutter/google_maps_flutter.dart';

class Task {
  final String title;
  final String id;
  final String award;
  final String uid;
  final bool accepted;
  final bool completed;
  final String description;
  final DateTime dueDate;
  final String lat;
  final String long;
  final String author;

  Task(
      {this.id,
      this.title,
      this.description,
      this.accepted,
      this.uid,
      this.completed,
      this.author,
      this.award,
      this.dueDate,
      this.lat,
      this.long});
}
