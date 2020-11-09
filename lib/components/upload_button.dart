import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class UploadButton extends StatelessWidget {
  final Function press;
   UploadButton({
    this.press,
    Key key,
  }) : super(key: key);

  Widget _uploadButtonBuilder() {
    return (Builder(builder: (context) {
      return RaisedButton(child: Text("Upload"), onPressed: press);
    }));
  }
  //final Size size = window.physicalSize;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
