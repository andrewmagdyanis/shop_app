import 'dart:ui';

import '../logic/checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/social_icon.dart';
import '../services/auth_service.dart';
import '../components/dialogs.dart';
import '../reduxElements/actions/actions.dart';
import '../reduxElements/models/models.dart';

class SocialIconsRow extends StatelessWidget {
  final String text;

   SocialIconsRow({
    Key key,
    this.text = 'OR',
  }) : super(key: key);
  //final Size size = window.physicalSize;

  @override
  Widget build(BuildContext context) {
    AuthServices authServicesClient = AuthServices(context: context);
    Dialogs dialogsClient = Dialogs();
    Checker checker = Checker();
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SocialIcon(
            //iconName: 'Facebook',
            iconSrc: "assets/icons/facebook.svg",
            press: () {
              checker.internetChecks(context).then((internet) {
                if (internet == true) {
                  Future<dynamic> user = authServicesClient.facebookLogin();
                  user.then((value) {
                    checker.loginChecks(context, value);
                    StoreProvider.of<AppState>(context).dispatch(UserInfoUpdate(userState: value));
                    //AppBuilder.of(context).rebuild();
                  });
                  Navigator.of(context).pushNamed('loading');
                }
              });
            },
          ),
          SocialIcon(
            //iconName: 'Twitter',
              iconSrc: "assets/icons/twitter.svg",
              press: () {
                checker.internetChecks(context).then((internet) {
                  if (internet == true) {
                    Navigator.of(context).pushNamed('loading');
                    Future<dynamic> user = authServicesClient.facebookLogin();
                    user.then((value) {
                      checker.loginChecks(context, value);
                      StoreProvider.of<AppState>(context).dispatch(UserInfoUpdate(userState: value));
                      //AppBuilder.of(context).rebuild();
                    });
                  }
                });
              }),
          SocialIcon(
            //iconName: 'Google',
              iconSrc: "assets/icons/google-plus.svg",
              press: () {
                checker.internetChecks(context).then((internet) {
                  if (internet == true) {
                    Navigator.of(context).pushNamed('loading');
                    Future<dynamic> user = authServicesClient.googleLogin();
                    user.then((value) {
                      checker.loginChecks(context, value);
                      StoreProvider.of<AppState>(context).dispatch(UserInfoUpdate(userState: value));
                      //AppBuilder.of(context).rebuild();
                    });
                  }
                });
              }),
        ],
      ),
    );
  }
}
