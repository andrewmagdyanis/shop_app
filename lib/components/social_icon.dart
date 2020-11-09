import 'dart:ui';

import '../components/constants.dart';
import '../logic/sizes_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  final String iconName;
  SocialIcon({
    Key key,
    this.iconSrc,
    this.press,
    this.iconName,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = displayHeight(context);
    double w = displayWidth(context);
    List <Widget> list = [
      SvgPicture.asset(
        iconSrc,
        color: kPrimaryColor,
        height: w*h / 6400,
        width: w*h / 6400,
      ),
       // text
    ];
    iconName != null?  list.add(Text(iconName)): null;
    return Padding(
      padding:  EdgeInsets.only(right: w*h/20000,left: w*h/20000),
      child: Center(
        child: SizedBox.fromSize(
          size: Size(w*h / 4000, w*h / 4000), // button width
          // and height
          child: ClipOval(
            child: Material(
              color: kPrimaryLightColor, // button color
              child: InkWell(
                splashColor: kPrimaryColor, // splash color
                onTap: press, // button pressed
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );


    return Padding(
      padding:  EdgeInsets.only(right: displayWidth(context)/30,left: displayWidth(context)/30),
      child: InkWell(
        customBorder: CircleBorder(),
        splashColor: Colors.red,
        highlightColor: Colors.red,
        hoverColor: Colors.red,
        focusColor: Colors.red,
        onTap: press,
        child: Container(
          padding: EdgeInsets.all(displayHeight(context) / 70),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: kPrimaryLightColor,
            border: Border.all(
              width: 2,
              color: kPrimaryLightColor,
            ),
            shape: BoxShape.circle,
          ),

          child: SvgPicture.asset(
            iconSrc,
            color: kPrimaryColor,
            height: displayHeight(context) / 18,
            width: displayHeight(context) / 18,
          ),
        ),
      ),
    );
  }
}
