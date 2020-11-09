import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class ModeState {
  final bool enableDarkMode;

  ModeState({
    this.enableDarkMode,
  });

  dynamic toJson() => {
        'darkMode': enableDarkMode.toString(),
      };

  static fromJson(json) {
    return (json != null) ? ModeState(enableDarkMode: json["darkMode"]) : {};
  }

  ModeState.fromMap(Map<String, dynamic> map)
      : assert(map["darkMode"] != null),
        enableDarkMode = map["darkMode"];

  Map<String, dynamic> toMap() {
    return toJson();
  }

  @override
  String toString() {
    return 'ModeState : ${JsonEncoder.withIndent(' ').convert(this)}';
  }
}
