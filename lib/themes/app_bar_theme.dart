import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    backgroundColor: Color.fromARGB(255, 172, 172, 172),
    foregroundColor: Color.fromARGB(255, 0, 0, 0),
    iconTheme: IconThemeData(color: Colors.black),
  );

  static const darkAppBarTheme = AppBarTheme(
    backgroundColor: Color.fromARGB(255, 32, 32, 32),
    foregroundColor: Color.fromARGB(255, 255, 255, 255),
    iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
  );
}
