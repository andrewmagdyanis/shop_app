import '../components/constants.dart';
import '../logic/sizes_helpers.dart';
import 'package:flutter/material.dart';

class ClickableIcon extends StatelessWidget {
  final double size;
  final Color color;
  final Function press;
  final IconData iconData;

  ClickableIcon({
    this.size=30,
    this.color,
    this.press,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryLightColor,
      onTap: press,
      child: Padding(
        padding:  EdgeInsets.only(right:displayWidth(context)*0.025,
            left:displayWidth(context)*0.025 ),
        child: Container(
          height: size,
          child: (Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            child: Icon(iconData,size: size*0.8,),
          )),
        ),
      ),
    );
  }
}
