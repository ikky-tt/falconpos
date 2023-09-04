
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../function/function.dart';
import 'color_schemes.g.dart';
import 'textshow.dart';

class Themes {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'prompt',
    colorScheme: lightColorScheme,
    textTheme: _text,
    appBarTheme:  AppBarTheme(
      backgroundColor:Color(0xFF0061A4),
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF001D36), // foreground (text) color
      ),
    ),

  );
  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'prompt',
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    textTheme: _text,
    appBarTheme:  AppBarTheme(
      backgroundColor:Colors.black26,
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF001D36), // foreground (text) color
      ),
    ),
  );

  static const TextTheme _text =  TextTheme(

    titleMedium:  TextStyle(fontSize: 16),
    titleLarge:  TextStyle(fontSize: 16),
    titleSmall:  TextStyle(fontSize: 14),
    displayLarge:  TextStyle(fontSize: 24),
    displayMedium: TextStyle(fontSize: 16),
    displaySmall:  TextStyle(fontSize: 14),
    headlineLarge: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
    headlineMedium:TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
  );

}
