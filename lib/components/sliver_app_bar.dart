import '../logic/sizes_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/clickable_icon.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/logoIcon.dart';
import '../reduxElements/models/models.dart';
import '../components/appBuilder.dart';
import '../reduxElements/actions/actions.dart';

import 'constants.dart';

class CustomSliverAppBar extends PreferredSize {
  double toolBarHeight;
  final bool settingsAppear;
  final bool logoAppear;
  final bool modeAppear;
  final String appBarTitle;
  final bool enableDarkMode;
  final bool sliverAppBarIncluded;
  final List<Widget> appBarColumnWidgets;
  final Widget flexibleAreaWidget;
  final bool snap;
  final bool floating;
  final bool pinned;
  final bool stretch;
  final Widget bottomWidget;
  final Color backGroundColor;
  final Border shape;
  final double elevation;
  final bool forcedElevated;
  bool toolBarIncluded;

  CustomSliverAppBar({
    this.toolBarHeight = 50,
    this.logoAppear = true,
    this.modeAppear = true,
    this.settingsAppear = false,
    this.appBarTitle = 'title',
    this.enableDarkMode = false,
    this.appBarColumnWidgets,
    this.sliverAppBarIncluded = true,
    this.snap = false,
    this.floating = true,
    this.pinned = false,
    this.stretch = false,
    this.toolBarIncluded = true,
    this.forcedElevated,
    this.flexibleAreaWidget,
    this.bottomWidget,
    this.backGroundColor,
    this.shape,
    this.elevation,
  }) ;

  @override
  Size get preferredSize {
    if (toolBarHeight < 70) {
      return Size.fromHeight(70);
    } else {
      return Size.fromHeight(toolBarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //onStretchTrigger: ()async{
      //    print('Stretch');
      // },
      shadowColor: Colors.grey,
      forceElevated: forcedElevated,
      elevation: elevation,
      shape: shape,
      floating: floating,
      pinned: pinned,
      stretch: stretch,
      snap: snap,

      toolbarHeight: toolBarIncluded ? toolBarHeight : 0,
      backgroundColor: backGroundColor,
      title: Text(
        appBarTitle,
        style: TextStyle(fontSize: toolBarHeight * 0.5),
      ),
      leading: (logoAppear)
          ? Center(
              child: LogoAsIcon(
                size: toolBarHeight * 0.8,
                color: (enableDarkMode) ? white : blue900,
                press: () {
                  Navigator.of(context).popAndPushNamed('home');
                },
              ),
            )
          : null,
      flexibleSpace: flexibleAreaWidget,
      bottom: bottomWidget,
      actions: <Widget>[
        (modeAppear)
            ? ClickableIcon(
                size: toolBarHeight * 0.68,
                press: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      DarkModeUpdate(modeState: ModeState(enableDarkMode: !enableDarkMode)));
                  AppBuilder.of(context).rebuild();
                },
                iconData: (!enableDarkMode) ? Icons.brightness_3 : Icons.wb_sunny,
              )
            : Container(),
        (settingsAppear)
            ? ClickableIcon(
                size: toolBarHeight * 0.68,
                press: () {
                  Navigator.of(context).pushNamed('settings');
                },
                iconData: Icons.settings)
            : Container(),
      ],
    );
  }
}
