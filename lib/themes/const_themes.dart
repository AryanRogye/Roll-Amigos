import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class constThemes {
  constThemes._();

  //__________________________________________________________
  //THIS IS THE MAIN THEME OF THE APP
  //__________________________________________________________
  static const linGrad = LinearGradient(
    colors: [
      Colors.black,
      Color.fromARGB(255, 14, 14, 14),
    ],
    begin: Alignment.topCenter,
    end: Alignment.centerLeft,
    // begin: Alignment.centerRight,
    // end: Alignment.centerLeft,
  );

  static const modelGrad = LinearGradient(
    colors: [
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 205, 205, 205),
      Color.fromARGB(255, 165, 165, 165),
    ],
    begin: Alignment.topCenter,
    end: Alignment.centerLeft,
  );

  //__________________________________________________________
  //THIS IS THE MAIN THEME OF THE SIGN IN/REGISTER PAGE
  //__________________________________________________________
  static var myBoxDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 23, 23, 23),
    border: Border.all(color: const Color.fromARGB(255, 0, 166, 255)),
    borderRadius: BorderRadius.circular(13),
  );

  //__________________________________________________________
  //THIS IS THE MAIN THEME OF THE HINT TEXT FOR SIGN IN/REGISTER PAGE
  //__________________________________________________________
  static var hintTextTheme = getWorkSansFont(
    const Color.fromARGB(255, 128, 128, 128),
    18,
    FontWeight.normal,
  );

  //__________________________________________________________
  //THIS IS THE MAIN THEME OF THE TEXT ON THE SCREEN
  //__________________________________________________________
  static TextStyle getWorkSansFont(
      Color color, double size, FontWeight fontweight) {
    return GoogleFonts.workSans(
      color: color,
      fontSize: size,
      fontWeight: fontweight,
    );
  }
}
