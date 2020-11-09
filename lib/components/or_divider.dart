import 'dart:ui';

import '../logic/sizes_helpers.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';

class OrDivider extends StatelessWidget {
  final String text;


  OrDivider({
    Key key,
    this.text='OR',

  }) : super(key: key);
  //final Size size = window.physicalSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
      width: displayWidth(context) * 0.85,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              text,
              style: TextStyle(
                fontSize: displayWidth(context)/20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 4,
      ),
    );
  }
}
