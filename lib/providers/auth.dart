import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null && _expDate != null && _expDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _auth(String email, String password, String autType) async {
    final url = 'https://identitytoolkit.googleapis'
        '.com/v1/accounts:$autType?key=AIzaSyCsUrzojgoQUEfByMzaouYulzWTt7YUvkI';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        //there is an error
        print(data['error'].toString());
        throw Exception(data['error']['message'].toString());
      }

      _token = data['idToken'];
      _userId = data['localId'];
      _expDate = DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));


      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(
          'userData',
          json.encode({
            'token': _token,
            'userId': _userId,
            'expDate': _expDate.toIso8601String(),
          }));
      _autoLogout();
      notifyListeners();
    } catch (e) {
      print('Error in auth: ' + e.toString());
      throw e;
    }


  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance().catchError((e) {
      print('Shared pref error');
      print(e);
    });
    if (!pref.containsKey('userData') ) {
      print('return false because of null userData');
      return false;
    }
    final userData = json.decode(pref.getString('userData')) as Map<String, dynamic>;
    print(userData);
    print(DateTime.now());

    final expDate = DateTime.parse(userData['expDate']);
    if (expDate.isBefore(DateTime.now())) {
      print('return false because of expired token');
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expDate = expDate;
    notifyListeners();
    _autoLogout();
    print('return true');
    return true;
  }

  Future<void> signUp(String email, String password) async {
    await _auth(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    await _auth(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    //await pref.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToAutoLogout = _expDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToAutoLogout), logout);
  }
}
