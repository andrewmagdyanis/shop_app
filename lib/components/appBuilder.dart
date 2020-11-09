import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// App Builder
class AppBuilder extends StatefulWidget {
  const AppBuilder({Key key, this.builder}) : super(key: key);
  final Function(BuildContext) builder;

  @override
  AppBuilderState createState() => new AppBuilderState();

  static AppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}
