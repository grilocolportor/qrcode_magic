import 'package:flutter/material.dart';
import 'package:qrcode_magic/utils/ColorUtils.dart';

var appTheme = ThemeData(
  fontFamily: 'Poppins',
  primarySwatch: createMaterialColor(Color.fromARGB(255, 250, 220, 53)),
  inputDecorationTheme:
      const InputDecorationTheme(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
  textTheme: const TextTheme(
    headline3: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF464646), decoration: TextDecoration.none),
    bodyText1: TextStyle(fontSize: 15, color: Color(0xFF666666)),
    bodyText2: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF252525)),
  ),
);
