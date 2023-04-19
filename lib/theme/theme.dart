
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../function/function.dart';
import 'textshow.dart';

class Themes {
  static final light = ThemeData(
      useMaterial3: true,
    appBarTheme:  AppBarTheme(
        backgroundColor: HexColor('3ea3d4'),

        elevation: 3,
        titleTextStyle: textBodyMedium.copyWith(color: Colors.black26)
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(

      color: HexColor('a4bfd2'),),
    primaryColor: HexColor('3ea3d4'),
    brightness: Brightness.light,
    indicatorColor: Colors.black,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor:Colors.white,
    fontFamily: 'sarabun',
    iconTheme: const IconThemeData(
        color: Colors.black54,

    ),

    primaryIconTheme: const IconThemeData(
        color: Colors.black26,

    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: InputBorder.none,

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
            elevation: 5,
            backgroundColor: HexColor('5BA1CF'),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: kIsWeb?textBodyMedium.copyWith():textBodyMedium.copyWith(

            ))
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(
            primary: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            side:  BorderSide(color: HexColor('1d4f90'), width: 2),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            textStyle: textBodyMedium.copyWith(

            ))),
    textTheme: TextTheme(
      headline1: headingStyle,
      headline2: textBodyMedium.copyWith(
        fontSize: 15.0,
        color: Colors.black,
      ),
      bodyText1: textBody.copyWith(
        fontWeight: FontWeight.normal

      ),
      bodyText2: textBodySmall,

    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static final dark = ThemeData(
    primaryColor: HexColor('0077b6'),
    brightness: Brightness.dark,
    textTheme: TextTheme(
      headline1: textBody.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color:  Colors.white,
      ),
      headline2: textBody.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyText1: textBody.copyWith(
        fontSize: 16.0,
        color: Colors.white,
      ),
      bodyText2: textBody.copyWith(
        fontSize: 14.0,
        color: Colors.white,
      ),
      button: textBody.copyWith(
        fontSize: 12.0,
        color: Colors.white,
      ),
      caption: textBody.copyWith(
        fontSize: 14.0,
        color: Colors.white,
      ),
      subtitle1: textBody.copyWith(
        fontSize: 16.0,
        color: Colors.white,
      ),
    ),
    indicatorColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: HexColor('0077b6'),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: textBody.copyWith(
              fontSize: 16.0,
              color: Colors.blueGrey,
            ))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(

            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            side:  BorderSide(color:HexColor('0077b6'), width: 2),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            primary: Colors.white,
            textStyle: textBody.copyWith(
              fontSize: 16.0,


            ))),

  );
}
