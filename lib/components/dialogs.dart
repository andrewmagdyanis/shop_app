import 'dart:ui';

import '../components/logoIcon.dart';
import '../logic/sizes_helpers.dart';
import '../reduxElements/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
import 'package:flutter/painting.dart';
import '../components/rounded_button.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Dialogs {
  final String dialogText;
  final bool barrierDismissibleFlag;

  Dialogs({
    Key key,
    this.dialogText = 'Loading',
    this.barrierDismissibleFlag = false,
  });

  //Size size = window.physicalSize;

  showsSimpleDialog(BuildContext context,
      {String dialogText = 'simple dialog', Color color = Colors.white70}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: color,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        )
      ],
      content: new Row(
        children: [
          Flexible(child: Container(margin: EdgeInsets.only(left: 5), child: Text(dialogText))),
        ],
      ),
    );
    showDialog(
      barrierDismissible: barrierDismissibleFlag,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context,
      {String dialogText = 'Loading', Color color = Colors.white70}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: color,
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text(dialogText)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: barrierDismissibleFlag,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorDialog(BuildContext context,
      {String errorStatement = 'error',
      Color color = Colors.white70,
      String closeReturnPageName = '/',
      numberOfPops = 1}) {
    AlertDialog alert = AlertDialog(
      title: Text('Error'),
      backgroundColor: color,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (closeReturnPageName == '/') {
              // if no given route
              for (int i = 0; i < numberOfPops; i++) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).popUntil((route) {
                return route.isFirst;
              });
              Navigator.pushNamed(context, closeReturnPageName);
            }

            /*
            Navigator.of(context).popUntil((route) {
              return Navigator.canPop(context) == false;
            });
            Navigator.pushReplacementNamed(context, closeReturnPageName);
          */
          },
          child: Text('Close'),
        )
      ],
      content: new Row(
        children: [
          //Icon(Icons.error),
          Flexible(
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  errorStatement,
                  maxLines: 10,
                  softWrap: true,
                  style: TextStyle(color: Colors.red),
                )),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: barrierDismissibleFlag,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: displayHeight(context),
          width: displayWidth(context),
          child: alert,
        );
      },
    );
  }

  showFullScreenDialog(BuildContext context,
      {String dialogText = 'dialogText', Color textColor, Color backgroundColor}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: backgroundColor,
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                dialogText,
                style: TextStyle(color: textColor, fontSize: 14),
              )),
        ],
      ),
    );
    showGeneralDialog(
      barrierDismissible: barrierDismissibleFlag,
      context: context,
      transitionDuration: Duration(seconds: 1),
      pageBuilder:
          (BuildContext context, Animation<double> animation, Animation<double> animation2) {
        return Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: backgroundColor,
            child: (Text('hereeee')),
          ),
        );
      },
    );
  }

  showOnWillUpDialog(BuildContext context,
      {String title = '',
      String content = '',
      Color textColor,
      Color backgroundColor,
      Widget button1,
      Widget button2}) {
    bool modeState = StoreProvider.of<AppState>(context).state.modeState.enableDarkMode;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        title: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: LogoAsIcon(
                  size: 45,
                  color: (modeState) ? (Colors.white) : blue900,
                ),
              ),
              new Text(
                'Are you leaving?',
                softWrap: true,
              ),
            ],
          ),
        ),
        content: Container(
          child: new Text(
            'Hope to hear your laugh again ',
            softWrap: true,
          ),
        ),
        actions: <Widget>[
          Center(
            child: new RoundedButton(
              color: Colors.red,
              press: () => Navigator.of(context).pop(true),
              text: 'Yes',
              heightRatio: 0.06,
              widthRatio: 0.35,
            ),
          ),
          Center(
            child: new RoundedButton(
              color: kPrimaryColor,
              press: () => Navigator.of(context).pop(false),
              text: 'No',
              heightRatio: 0.06,
              widthRatio: 0.35,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showCustomDialog(context,
      {String txt1,
      String txt2,
      String actionText1,
      String actionText2,
      Function action1,
      Function action2}) {
    bool modeState = StoreProvider.of<AppState>(context).state.modeState.enableDarkMode;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        title: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: LogoAsIcon(
                  size: 45,
                  color: (modeState) ? (Colors.white) : blue900,
                ),
              ),
              Text(
                txt1,
                softWrap: true,
              ),
            ],
          ),
        ),
        content: Container(
          child: Text(
            txt2,
            softWrap: true,
          ),
        ),
        actions: <Widget>[
          Center(
            child: RoundedButton(
              color: Colors.red,
              press: () => action1,
              text: actionText1,
              heightRatio: 0.06,
              widthRatio: 0.35,
            ),
          ),
          Center(
            child: new RoundedButton(
              color: kPrimaryColor,
              press: () => action2,
              text: actionText2,
              heightRatio: 0.06,
              widthRatio: 0.35,
            ),
          ),
        ],
      ),
    );
  }
}
