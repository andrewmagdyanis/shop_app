import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/search_state.dart';
import '../models/user_state.dart';
import 'mode_state.dart';

@immutable
class AppState {
  final ModeState modeState;
  final UserState userState;
  final SearchState searchState;

  AppState({
    this.modeState,
    this.userState,
    this.searchState,

  });

  dynamic toJson() => {
        'darkMode': modeState,
        'userState': userState,
        'searchState': searchState,

      };

  static AppState fromJson(dynamic json) {
    return json != null
        ? AppState(
            userState: UserState.fromJson(json),
            modeState: ModeState.fromJson(json),
            searchState: SearchState.fromJson(json),
          )
        : {};
  }

  AppState.fromMap(Map<String, dynamic> map)
      : assert(map["darkMode"] != null),
        assert(map["userState"] != null),
        modeState = map["darkMode"],
        userState = map["userState"],
        searchState = map["searchState"];


  Map<String, dynamic> toMap() {
    return {
      "userState": this.userState.toMap(),
      "modeState": this.modeState.toMap(),
      "searchState":  this.searchState.toMap(),
    };
  }

  @override
  String toString() {
    return 'AppState: ${JsonEncoder.withIndent(' ').convert(this)}';
  }
}
