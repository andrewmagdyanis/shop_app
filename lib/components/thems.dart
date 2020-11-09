import 'dart:io';

import '../components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
export '../main.dart';

class Themes {
  final Size size;
  final double aspectRatio;

  Themes({
    this.size,
    this.aspectRatio,
  });

  ThemeData themeDataProvider(String themeName) {
    double h = size.height / aspectRatio;
    double w = size.width / aspectRatio;
    double s = h * w;
    //print('H: '+h.toString());
    //print('W: '+w.toString());

    bool darkFlag = false;
    Color color = purple900;
    Brightness brightness = Brightness.light;
    if (themeName == 'dark') {
      darkFlag = true;
      color = Colors.white;
      brightness = Brightness.dark;
    }
    ThemeData themeData = ThemeData(
      fontFamily: 'Anton',
      brightness: brightness,
      primaryColorBrightness: brightness,
      accentColorBrightness: brightness,
      colorScheme: (darkFlag) ? ColorScheme.dark() : ColorScheme.light(),
      primarySwatch: (darkFlag) ? Colors.orange : Colors.blue,
      primaryColor: (darkFlag) ? orang900 : blue900,
      bottomAppBarColor: (darkFlag) ? orang900 : blue900,
      buttonColor: (darkFlag) ? orang900 : blue900,
      errorColor: Colors.red,
      buttonBarTheme: ButtonBarThemeData(
        mainAxisSize: MainAxisSize.max,
        buttonTextTheme: ButtonTextTheme.primary,
      ),

      indicatorColor: color,
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      }),

      accentIconTheme: IconThemeData(color: color),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 20,
        textStyle: TextStyle(fontSize: s * 0.00007, fontWeight: FontWeight.w500, color: color),
        //color: Colors.blueGrey,
      ),
      scaffoldBackgroundColor: backgroundColor,

      backgroundColor: backgroundColor,
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
      appBarTheme: AppBarTheme(
          centerTitle: true,
          brightness: brightness,
          elevation: 0.8,
          color: appBarColor,
          shadowColor: blue900,
          iconTheme: IconThemeData(color: color, size: s * 0.00009),
          textTheme: TextTheme(
              headline6:
                  TextStyle(fontSize: s * 0.00009, fontWeight: FontWeight.bold, color: color)),
          actionsIconTheme: IconThemeData(color: color) //,size: 20),
          ),
      primaryIconTheme: IconThemeData(color: color),
      //buttonBarTheme: ButtonBarThemeData() ,
      //bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.green),
      //bottomSheetTheme: BottomSheetThemeData(),
      //navigationRailTheme: NavigationRailThemeData(backgroundColor: Colors.green),
      //tabBarTheme: TabBarTheme(),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          color: darkFlag ? Colors.grey[700] : Colors.grey[300],
          clipBehavior: Clip.hardEdge),

      tabBarTheme: TabBarTheme(
        unselectedLabelColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        labelColor: color,
        indicator: BoxDecoration(
          border: Border(bottom: BorderSide(width: s * 0.000008, color: color)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
        titleTextStyle: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: color,
        unselectedItemColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        selectedLabelStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        selectedIconTheme: IconThemeData(
          size: 25,
          color: color,
        ),
        unselectedIconTheme: IconThemeData(
          size: 22,
          color: Colors.blueGrey,
        ),
      ),
      iconTheme: IconThemeData(
        size: 22,
        color: color,
      ),
      buttonTheme: ButtonThemeData(buttonColor: color, alignedDropdown: true, minWidth: 25),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: darkFlag ? Colors.black : white,
          backgroundColor: color,
          hoverColor: Colors.greenAccent),

      textTheme: TextTheme(
        headline1: TextStyle(fontSize: s * 0.00022, fontWeight: FontWeight.bold, color: color),
        headline2: TextStyle(fontSize: s * 0.00018, fontWeight: FontWeight.bold, color: color),
        headline3: TextStyle(fontSize: s * 0.00015, fontWeight: FontWeight.bold, color: color),
        headline4: TextStyle(fontSize: s * 0.00012, fontWeight: FontWeight.bold, color: color),
        headline5: TextStyle(fontSize: s * 0.0001, fontWeight: FontWeight.bold, color: color),
        headline6: TextStyle(
            fontSize: s * 0.000085,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: color),
        bodyText1: TextStyle(fontSize: s * 0.00008, fontWeight: FontWeight.bold, color: color),
        bodyText2: TextStyle(fontSize: s * 0.000075, fontWeight: FontWeight.bold, color: color),
        button: TextStyle(fontSize: s * 0.00008, fontWeight: FontWeight.bold, color: color),
        subtitle1: TextStyle(fontSize: s * 0.00007, fontWeight: FontWeight.bold, color: color),
        subtitle2:
            TextStyle(fontSize: s * 0.000065, fontWeight: FontWeight.bold, color: kPrimaryColor),
      ),
    );
/*
    ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
      primarySwatch: Colors.indigo,
      primaryColor: Colors.indigo,
      bottomAppBarColor: Colors.indigo,
      buttonColor: Colors.indigo[800],
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        elevation: 0.0,
        color: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white70, size: 30),
        textTheme: TextTheme(
            headline6: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white70)),
        actionsIconTheme: IconThemeData(color: Colors.white70, size: 30),
      ),

      //buttonBarTheme: ButtonBarThemeData() ,
      //bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.green),
      //bottomSheetTheme: BottomSheetThemeData(),
      //navigationRailTheme: NavigationRailThemeData(backgroundColor: Colors.green),
      //tabBarTheme: TabBarTheme(),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        titleTextStyle: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        selectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        unselectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.grey,
        ),
      ),

      buttonTheme:
          ButtonThemeData(buttonColor: Colors.deepOrange, alignedDropdown: true, minWidth: 30),
      cardColor: Colors.grey[800],

      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepOrange,
          hoverColor: Colors.greenAccent),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0),
      ),
    );

    if (themeName == 'dark') {
      return dark;
    } else {
      return light;
    }

 */
    return themeData;
  }
}
