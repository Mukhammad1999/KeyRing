import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:key_ring/models/task.dart';
import 'package:key_ring/models/taskstack.dart';
import 'package:key_ring/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference taskCollection =
      Firestore.instance.collection('tasks');
  final CollectionReference userCollection =
      Firestore.instance.collection('user');
  final CollectionReference stackCollection =
      Firestore.instance.collection('taskStack');

  Future updateUserData(String name, double rating, int dtasks,
      bool acc_activated, String avatarUrl, String phone_number) async {
    await userCollection.document(uid).setData({
      'name': name,
      'rating': rating,
      'tasks_done': dtasks,
      'acc_activated': acc_activated,
      'avatarUrl': avatarUrl,
      'phone_number': phone_number
    });
  }

  Future updateTaskData(
      String title,
      String uid,
      String description,
      String price,
      bool accepted,
      bool completed,
      DateTime dueDate,
      LatLng position) async {
    String author = "";
    await userCollection
        .document(uid)
        .get()
        .then((value) => author = value['name']);
    await taskCollection.document().setData({
      'title': title,
      'description': description,
      'price': price,
      'uid': uid,
      'accepted': accepted,
      'completed': completed,
      'author': author,
      'created_at': DateTime.now(),
      'dueDate': dueDate.toUtc(),
      'position': position.toJson(),
    });
    return await userCollection
        .document(uid)
        .updateData({"tasks_announced": FieldValue.increment(1)});
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        dtasks: snapshot.data['tasks_done'],
        rating: snapshot.data['rating'],
        acc_activated: snapshot.data['acc_activated'],
        phone_number: snapshot.data['phone_number'],
        tasks_announced: snapshot.data['tasks_announced'] ?? 0);
  }

  Task _taskFromDocumentSnapshot(DocumentSnapshot e) {
    return Task(
      id: e.documentID.toString() ?? " ",
      title: e.data['title'] ?? " ",
      author: e.data['author'] ?? " ",
      uid: e.data['uid'] ?? "",
      completed: e.data['completed'],
      description: e.data['description'],
      dueDate: e.data['dueDate'].toDate() ?? " ",
      lat: e.data['position'[0]].toString() ?? "",
      long: e.data['position'[1]].toString() ?? "",
      award: e.data['price'],
    );
  }

  List<Task> _taskFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents
          .map((e) => Task(
                id: e.documentID.toString() ?? " ",
                title: e.data['title'] ?? " ",
                author: e.data['author'] ?? " ",
                uid: e.data['uid'] ?? "",
                completed: e.data['completed'],
                description: e.data['description'],
                dueDate: e.data['dueDate'].toDate() ?? " ",
                lat: e.data['position'[0]].toString() ?? "",
                long: e.data['position'[1]].toString() ?? "",
                award: e.data['price'],
              ))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<Task>> get tasks {
    return taskCollection.snapshots().map(_taskFromSnapshot);
  }

  Stream<List<Task>> get myTaskStack {
    return taskCollection
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map(_taskFromSnapshot);
  }

  Future addToStackList(String taskId, String author) async {
    try {
      if (uid != author) {
        return await stackCollection.document(taskId).setData({
          "wantersUid": FieldValue.arrayUnion([uid])
        }, merge: true);
      } else {
        print('you shall not pass');
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Task> showTaskDetail(String taskId) {
    try {
      return taskCollection
          .document(taskId)
          .snapshots()
          .map(_taskFromDocumentSnapshot);
    } catch (e) {
      return null;
    }
  }
}
