import 'package:flutter/material.dart';

const appGreen = Color(0xff90C8AC);
const oldGreen = Color(0xff73A9AD);
const youngGreen = Color(0xffC4DFAA);
const youngGreen2 = Color(0xff96E696);
const whiteOld = Color(0xffF5F0BB);
const white = Color(0xeffefefef);
const oldDrkGreen = Color(0xff105A2D);
const oldDrkGreen2 = Color(0xff385F48);

ThemeData themeLight = ThemeData(
    brightness: Brightness.light,
    tabBarTheme:
        TabBarTheme(labelColor: oldGreen, unselectedLabelColor: whiteOld),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: oldDrkGreen2),
    primaryColor: appGreen,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: oldDrkGreen, elevation: 4),
    listTileTheme: ListTileThemeData(textColor: oldDrkGreen2),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: oldDrkGreen2),
      bodyText2: TextStyle(color: oldDrkGreen2),
    ));

ThemeData themeDark = ThemeData(
    tabBarTheme: TabBarTheme(
        labelColor: oldGreen,
        unselectedLabelColor: oldGreen,
        indicator:
            BoxDecoration(border: Border(bottom: BorderSide(color: oldGreen)))),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: whiteOld),
    brightness: Brightness.dark,
    primaryColor: oldDrkGreen2,
    scaffoldBackgroundColor: oldDrkGreen2,
    appBarTheme: AppBarTheme(backgroundColor: oldDrkGreen2, elevation: 0),
    listTileTheme: ListTileThemeData(textColor: whiteOld),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: whiteOld),
      bodyText2: TextStyle(color: white),
    ));
