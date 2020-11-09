import '../components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAsIcon extends StatelessWidget {
  final double size;
  final Color color;
  final Function press;

  LogoAsIcon({
    this.size,
    this.color,
    this.press,
  });

  @override
    Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: press,
        splashColor: kPrimaryLightColor,
        child: (Padding(
          padding: EdgeInsets.only(left: 2, right: 2),
          child: Container(
            //height: size,
            child: SvgPicture.asset(
              'assets/icons/comicerLogos/comicerLeftLogo512.svg',
              height: size,
              allowDrawingOutsideViewBox: false,
              color: color,
            ),
          ),

          /*
        ImageIcon(
          AssetImage('assets/icons/comicerLogos/comicerLeftLogo512.png'),
          color:color ,
          size: size,
        ),
            */
        )),
      ),
    );
  }
}
