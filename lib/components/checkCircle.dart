import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//this functions will put check circle on the pic that its name
// is on the List of clicked images names
Widget checkCircleVisability(int index, String currentImageName,
    List<dynamic> listOfImages,
    List<dynamic> listOfClickedImagesName) {
  if (currentImageName == listOfImages[index].assetName ||
      listOfClickedImagesName.contains(listOfImages[index].assetName))
    return (Positioned(
        left: 130,
        top: 70,
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
        )));
  else
    return (Visibility(
      visible: false,
      child: Icon(
        Icons.check_circle_outline,
        color: Colors.black,
      ),
    ));
}