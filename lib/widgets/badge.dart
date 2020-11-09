import 'dart:ui';

import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int value;

  const Badge({
    Key key,
    this.child,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.directional(
          top: 6,start: 28,
          textDirection: TextDirection.ltr,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Center(child: Text(value.toString(),style: TextStyle(color: Colors.white,
                fontSize: 12),),),
          ),
        ),

      ],
    );
  }
}
