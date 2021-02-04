import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_ring/models/user.dart';
import 'package:key_ring/services/auth.dart';
import 'package:key_ring/shared/loading.dart';

class ImageUploader extends StatefulWidget {
  final File file;

  ImageUploader({Key key, this.file}) : super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://ninja-brew-crew-b9185.appspot.com');
  StorageUploadTask _uploadTask;
  void _startUpload() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    String filepath = 'images/${uid}.png';
    setState(() {
      _uploadTask = storage.ref().child(filepath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _uploadTask == null
        ? Container(
            child: CircleAvatar(),
          )
        : Loading();
  }
}
