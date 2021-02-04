import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_ring/models/user.dart';

import 'database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult reslt = await _auth.signInAnonymously();
      FirebaseUser user = reslt.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password

  Future registerWithEmailandPassword(
      String email,
      String password,
      String name,
      double rating,
      int dtasks,
      bool acc_activated,
      String avatarUrl,
      String phone_number) async {
    try {
      //creating new user in Auth service
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //assigning new user for FirebaseUser
      FirebaseUser user = authResult.user;

      //create a new user document for signed up user
      //calling DatabaseService function to create new user in userCollection
      await DatabaseService(
        uid: user.uid,
      ).updateUserData(
        name,
        rating,
        dtasks,
        acc_activated,
        phone_number,
        avatarUrl,
      );
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
