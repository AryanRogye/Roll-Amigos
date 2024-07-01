import 'package:dice_pt2/themes/app_bar_theme.dart';
import 'package:dice_pt2/themes/textTheme.dart';
import 'package:flutter/material.dart';

class TSystemTheme {
  TSystemTheme._();

  static final baseTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 181, 181, 181),
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 49, 49, 49),
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
  );
}
