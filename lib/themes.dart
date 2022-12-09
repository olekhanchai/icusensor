import 'package:flutter/material.dart';
import 'package:icusensor/constants.dart';

class MyThemes {
  static final primary = Colors.blue;
  // static final primaryColor = Colors.blue.shade300;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColorDark: primaryColor,
    accentColor: Colors.blue,
    colorScheme: ColorScheme.dark(primary: primary),
    dividerColor: Colors.white,
    textTheme: const TextTheme().apply(bodyColor: Colors.white),
    //  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: Colors.white),
    canvasColor: Color(0xFF2A2D3E),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
    textTheme: const TextTheme().apply(bodyColor: Colors.white),
    //  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: Colors.white),
    canvasColor: Color.fromARGB(255, 166, 212, 231),
  );

  static final stdTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: bgColor,
    textTheme: const TextTheme().apply(bodyColor: Colors.white),
    //  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: Colors.white),
    canvasColor: secondaryColor,
  );
}
