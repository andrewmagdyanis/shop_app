import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class SearchState {
  final List<dynamic> filteredList;
  final List<dynamic> list;

  final String filter;
  final bool returnAll;

  /*
  factory SearchState(List list, String filter, List filteredList) {
    return SearchState.defaultConstructor(
      list: list,
      filter: filter,
      filteredList: filteredList,
    );
  }
*/
  SearchState({
    this.filteredList,
    this.list,
    this.filter,
    this.returnAll=false,

  });

  SearchState copyWith({
    List<dynamic> filteredList,
    List<dynamic> list,
    String filter,
    bool returnALl
  }) {
    return SearchState(
      filteredList: filteredList ?? this.filteredList,
      list: list ?? this.filteredList,
      filter: filter ?? this.filter,
      returnAll:  returnALl?? this.returnAll,

    );
  }

  dynamic toJson() => {
        'filteredList': filteredList.length.toString(),
        'list': filteredList..length.toString(),
        'filter': filter.toString(),
        'returnAll': returnAll.toString()
  };

  static fromJson(json) {
    return (json != null)
        ? SearchState(
            filteredList: json["filteredList"], filter: json['filter'], list: json["list"]
    ,returnAll: json["returnAll"]
    )
        : {};
  }

  SearchState.fromMap(Map<String, dynamic> map)
      : assert(map["filteredList"] != null),
        filteredList = map["filteredList"],
        filter = map["filter"],
        list = map["list"],
        returnAll = map["returnAll"]

  ;

  Map<String, dynamic> toMap() {
    return toJson();
  }

  @override
  String toString() {
    try {
      return 'SearchState : ${JsonEncoder.withIndent(' ').convert(this)}';
    }
    catch(e){
      print(e);
    }
    return 'SearchState';
    }
}
