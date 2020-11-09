import 'dart:ui';

import '../logic/sizes_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/text_field_container.dart';
import '../components/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  @override
  _RoundedPasswordFieldState createState() {
    return _RoundedPasswordFieldState();
  }

  final ValueChanged<String> onChanged;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final bool errorFlag;
  final String errorText;

  const RoundedPasswordField({
    Key key,
    this.hintText = 'Password',
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.errorFlag = false,
  }) : super(key: key);
}
//final Size size = window.physicalSize;

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool visableFlag = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextFieldContainer(
          child: Center(
            child: TextFormField(
              autovalidate: true,
              obscureText: visableFlag,
              onFieldSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                errorText: widget.errorText,
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.subtitle2,
                contentPadding: EdgeInsets.only(bottom: displayHeight(context)*0.01,),

                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                suffixIcon: null,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Positioned(
          width: displayWidth(context)*0.18,
          height: displayHeight(context)*0.09,
          right: displayWidth(context)*0.05,
          top: displayHeight(context)*0.007,

          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(topRight: Radius.circular(displayHeight(context)/30),
              bottomRight: Radius.circular(displayHeight(context)/30)),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              focusColor: Colors.red,
              splashColor: Colors.red,
              onTap: () {
                setState(() {
                  visableFlag ^= true;
                  print(visableFlag);
                });
              },
              onTapCancel: (){
                setState(() {
                  visableFlag = true;
                });
              },
              child: Icon(
                Icons.visibility,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
