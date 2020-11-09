import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class UserState {
  String userId;
  String userName;
  String profilePictureUrl;
  String phoneNumber;
  String email;
  String authProvider;
  DateTime creationTime;
  DateTime lastSignInTime;
  bool loggedIn;

  //FirebaseUser firebaseUser;

  //default constructor:
  UserState.defaultConstructor({
    this.userId,
    this.userName,
    this.profilePictureUrl,
    this.phoneNumber,
    this.email,
    this.authProvider,
    this.creationTime,
    this.lastSignInTime,
    this.loggedIn,
  });

  //initializer constructor:
  UserState(FirebaseUser firebaseUser, {String authProvider, String firstName,String lastName}) {
    this.userId = firebaseUser.uid;
    this.userName = (authProvider=='email-password')?firstName+' '+lastName:firebaseUser
        .displayName??'Null';
    this.profilePictureUrl = firebaseUser.photoUrl??'null';
    this.phoneNumber = firebaseUser.phoneNumber;
    this.email = firebaseUser.email;
    this.authProvider = authProvider;
    this.creationTime = firebaseUser.metadata.creationTime;
    this.lastSignInTime = firebaseUser.metadata.lastSignInTime;
    this.loggedIn = true;
  }

  dynamic toJson() => {
        'userId': userId,
        'userName': userName,
        'profilePictureUrl': profilePictureUrl,
        'phoneNumber': phoneNumber,
        'email': email,
        'authProvider': authProvider,
        'creationTime': creationTime.toString(),
        'lastSignInTime': lastSignInTime.toString(),
        'loggedIn': loggedIn ? 1 : 0,
      };

  static fromJson(json) {
    return (json != null)
        ? UserState.defaultConstructor(
            userId: json["userId"],
            userName: json["userName"],
            profilePictureUrl: json["profilePictureUrl"],
            phoneNumber: json["phoneNumber"],
            email: json["email"],
            authProvider: json["authProvider"],
            creationTime: json["creationTime"],
            lastSignInTime: json["lastSignInTime"],
            loggedIn: json["loggedIn"] == 1 ? true : false,
          )
        : {};
  }

  UserState.fromMap(Map<String, dynamic> map)
      : assert(map["userId"] != null),
        assert(map["userName"] != null),
        assert(map["authProvider"] != null),
        assert(map["creationTime"] != null),
        assert(map["lastSignInTime"] != null),
        assert(map["loggedIn"] != null),
        userId = map["userId"],
        userName = map["userName"],
        profilePictureUrl = map["profilePictureUrl"],
        phoneNumber = map["phoneNumber"],
        email = map["email"],
        authProvider = map["authProvider"],
        creationTime = map["creationTime"] is String
            ? DateTime.parse(map["creationTime"])
            : map["creationTime"],
        lastSignInTime = map["lastSignInTime"] is String
            ? DateTime.parse(map["lastSignInTime"])
            : map["lastSignInTime"],
        loggedIn = map["loggedIn"] == 1 ? true : false;

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "profilePictureUrl": profilePictureUrl,
      "phoneNumber": phoneNumber,
      "email": email,
      "authProvider": authProvider,
      "creationTime": creationTime.toString(),
      "lastSignInTime": lastSignInTime.toString(),
      "loggedIn": loggedIn ? 1 : 0,
    };
  }

  UserState copyWith(
      {bool loggedIn,
      String userId,
      String userName,
      String profilePictureUrl,
      String phoneNumber,
      String email,
      String authProvider,
      DateTime creationTime,
      DateTime lastSignInTime}) {
    return UserState.defaultConstructor(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      authProvider: authProvider ?? this.authProvider,
      loggedIn: loggedIn ?? this.loggedIn,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      creationTime: creationTime ?? this.creationTime,
    );
  }

  @override
  String toString() {
    return 'UserState: ${JsonEncoder.withIndent(' ').convert(this)}';
  }
}
