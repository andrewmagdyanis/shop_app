

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center ,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Loading...')),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );


  }

}