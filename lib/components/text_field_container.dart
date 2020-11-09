import 'dart:ui';

import '../components/constants.dart';
import '../logic/sizes_helpers.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
   TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);
  //final Size size = window.physicalSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: displayHeight(context)/140,horizontal: displayWidth(context)/20),
      padding: EdgeInsets.symmetric(horizontal: displayWidth(context)/20, vertical: displayHeight(context)/90),
      width: displayWidth(context) * 0.8,
      height: displayHeight(context)*0.09,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(displayHeight(context)/30),
      ),
      child: child,
    );
  }
}
