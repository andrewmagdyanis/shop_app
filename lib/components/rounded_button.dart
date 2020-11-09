import 'dart:ui';

import '../logic/sizes_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double widthRatio;
  final double heightRatio;
  final double textFont;

  RoundedButton(
      {Key key,
      this.text,
      this.press,
      this.color = Colors.blue,
      this.textColor = Colors.white,
      this.textFont,
      this.widthRatio = 0.5,
      this.heightRatio = 0.08})
      : super(key: key);

  //final Size size = window.physicalSize;

  @override
  Widget build(BuildContext context) {
    double mytextFont = (textFont==null) ? displayHeight(context) * heightRatio * 0.42: textFont;
    return Container(
      margin: EdgeInsets.symmetric(vertical: displayHeight(context) / 140),
      width: displayWidth(context) * widthRatio,
      height: displayHeight(context) * heightRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(displayHeight(context) / 45),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: displayHeight(context) * heightRatio / 5, horizontal: 5),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: mytextFont),
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
