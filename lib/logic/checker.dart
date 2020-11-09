import '../reduxElements/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import '../components/dialogs.dart';
import 'package:flutter/services.dart';

class Checker {
  Dialogs dialogs;

  Checker() {
    dialogs = Dialogs();
  }

  Future<bool> internetChecks(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      dialogs.showErrorDialog(context, errorStatement: 'please, check the internet connectivity');
      return false;
    }
  }

  void loginChecks(BuildContext context, dynamic value) {
    if (value.runtimeType != PlatformException) {
      if (value != null) {
        print('runtime value od value: '+ value.runtimeType.toString());
        if (value.runtimeType.toString()== 'UserState') {
          //value = value.firebaseUser;
          print('user state type checks');
          Navigator.popUntil(context, (route) {
            //pops the routes until this fn returns true
            return (Navigator.canPop(context) == false);
          });
          Navigator.of(context).popAndPushNamed('topNode');
        } else {
          dialogs.showErrorDialog(context, errorStatement: 'user id is null');
        }
      } else {
        dialogs.showErrorDialog(context, errorStatement: 'returned user is null');
      }
    } else {
      print('platform error: ' + value.toString());
      dialogs.showErrorDialog(context, errorStatement: value.toString());
    }
  }
}
