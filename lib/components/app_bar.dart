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

class CustomAppBar extends PreferredSize {
  final double height;
  final double iconSize;
  final bool settingsAppear;
  final bool logoAppear;
  final bool modeAppear;
  final String appBarTitle;
  final bool enableDarkMode;
  final bool normalAppBarIncluded;
  final List<Widget> appBarColumnWidgets;
  final bool tabBarFlag;

  CustomAppBar({
    this.height = 50,
    this.iconSize = 25,
    this.logoAppear = true,
    this.modeAppear = true,
    this.settingsAppear = false,
    this.appBarTitle = 'title',
    this.enableDarkMode = false,
    this.appBarColumnWidgets,
    this.normalAppBarIncluded = true,
    this.tabBarFlag = false,
  });

  @override
  Size get preferredSize {
    if (height < 70) {
      return Size.fromHeight(70);
    } else {
      return Size.fromHeight(height);
    }
  }

  List<Widget> listProvider(BuildContext context) {
    List<Widget> appBarColumnList = [
      (normalAppBarIncluded)
          ? SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              title: Text(appBarTitle),
              leading: (logoAppear)
                  ? Center(
                      child: LogoAsIcon(
                        size: iconSize,
                        color: (enableDarkMode) ? white : blue900,
                        press: () {
                          Navigator.of(context).popAndPushNamed('home');
                        },
                      ),
                    )
                  : null,
              flexibleSpace: Center(
                  child: LogoAsIcon(
                      size: displayHeight(context) * .035,
                      color: (enableDarkMode) ? white : blue900)),
              automaticallyImplyLeading: true,
              excludeHeaderSemantics: true,
              actions: <Widget>[
                (modeAppear)
                    ? ClickableIcon(
                        press: () {
                          StoreProvider.of<AppState>(context).dispatch(DarkModeUpdate(
                              modeState: ModeState(enableDarkMode: !enableDarkMode)));
                          AppBuilder.of(context).rebuild();
                        },
                        iconData: (!enableDarkMode) ? Icons.brightness_3 : Icons.wb_sunny,
                      )
                    : Container(),
                (settingsAppear)
                    ? ClickableIcon(
                        press: () {
                          Navigator.of(context).pushNamed('settings');
                        },
                        iconData: Icons.settings)
                    : Container(),
              ],
            )
          : Container(),
      SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _SliverAppBarDelegate(
            tabBarFlag
                ? TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.home),
                        text: "Home",
                      ),
                      Tab(
                        icon: Icon(Icons.search),
                        text: "Search",
                      ),
                      Tab(
                        icon: Icon(Icons.create),
                        text: "Design",
                      ),
                      Tab(
                        icon: Icon(Icons.trending_up),
                        text: "Trend",
                      ),
                      Tab(
                        icon: Icon(Icons.settings),
                        text: "Settings",
                      ),
                    ],
                  )
                : TabBar(),
          ))
    ];

    return appBarColumnList;
  }

  @override
  Widget build(BuildContext context) {
    /*
    return AppBar(
      title: Text(appBarTitle),
      leading: (logoAppear)
          ? LogoAsIcon(
        size: iconSize,
        color: (enableDarkMode) ? white : blue900,
        press: () {
          Navigator.of(context).popAndPushNamed('home');
        },
      )
          : null,
      flexibleSpace: LogoAsIcon(
          size: 25, color: (enableDarkMode) ? white : blue900),
      automaticallyImplyLeading: true,
      excludeHeaderSemantics: true,
      bottom: tabBarFlag
          ? TabBar(
        isScrollable: true,
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: "Home",
          ),
          Tab(
            icon: Icon(Icons.search),
            text: "Search",
          ),
          Tab(
            icon: Icon(Icons.create),
            text: "Design",
          ),
          Tab(
            icon: Icon(Icons.trending_up),
            text: "Trend",
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: "Settings",
          ),
        ],
      )
          : TabBar(),
      actions: <Widget>[
        (modeAppear)
            ? ClickableIcon(
          press: () {
            StoreProvider.of<AppState>(context).dispatch(DarkModeUpdate(
                modeState: ModeState(enableDarkMode: !enableDarkMode)));
            AppBuilder.of(context).rebuild();
          },
          iconData: (!enableDarkMode) ? Icons.brightness_3 : Icons.wb_sunny,
        )
            : Container(),
        (settingsAppear)
            ? ClickableIcon(
            press: () {
              Navigator.of(context).pushNamed('settings');
            },
            iconData: Icons.settings)
            : Container(),
      ],
    );
    */

    List<Widget> appBarColumnList = [
      (normalAppBarIncluded)
          ? AppBar(
        toolbarHeight: displayHeight(context)*0.07,
              title: Text(appBarTitle),
              leading: (logoAppear)
                  ? Center(
                      child: LogoAsIcon(
                        size: iconSize,
                        color: (enableDarkMode) ? white : blue900,
                        press: () {
                          Navigator.of(context).popAndPushNamed('home');
                        },
                      ),
                    )
                  : null,
              flexibleSpace: Center(
                  child: LogoAsIcon(
                      size: displayHeight(context) * .035,
                      color: (enableDarkMode) ? white : blue900)),
              automaticallyImplyLeading: true,
              excludeHeaderSemantics: true,
              actions: <Widget>[
                (modeAppear)
                    ? ClickableIcon(
                        press: () {
                          StoreProvider.of<AppState>(context).dispatch(DarkModeUpdate(
                              modeState: ModeState(enableDarkMode: !enableDarkMode)));
                          AppBuilder.of(context).rebuild();
                        },
                        iconData: (!enableDarkMode) ? Icons.brightness_3 : Icons.wb_sunny,
                      )
                    : Container(),
                (settingsAppear)
                    ? ClickableIcon(
                        press: () {
                          Navigator.of(context).pushNamed('settings');
                        },
                        iconData: Icons.settings)
                    : Container(),
              ],
            )
          : Container(),
      tabBarFlag
          ? Container(
        //height: displayHeight(context)*0.09,
        decoration: BoxDecoration(
          border: Border.all(width: 2,color: Colors.transparent),
        ),
              child: TabBar(
                indicatorWeight: 2,
                isScrollable: true,
                labelPadding: EdgeInsets.only(left:displayWidth(context)*0.045,
                right: displayWidth(context)*0.045) ,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                    text: "Home",
                  ),
                  Tab(
                    icon: Icon(Icons.search),
                    text: "Search",
                  ),
                  Tab(
                    icon: Icon(Icons.create),
                    text: "Design",
                  ),
                  Tab(
                    icon: Icon(Icons.trending_up),
                    text: "Trend",
                  ),
                  Tab(
                    icon: Icon(Icons.settings),
                    text: "Settings",
                  ),
                ],
              ),
            )
          : Container(),
    ];
    if (appBarColumnWidgets != null) {
      for (int i = 0; i < appBarColumnWidgets.length; i++) {
        appBarColumnList.add(appBarColumnWidgets[i]);
      }
    }

    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2)
        ),
        child: Column(children: appBarColumnList,
        mainAxisAlignment: MainAxisAlignment.start,));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
