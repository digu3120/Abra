import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'PolySans',
  primaryColor: const Color(0xFFE70001),
  primaryColorLight: const Color(0xFFF0F4F8),
  primaryColorDark: const Color(0xFFE70001),
  secondaryHeaderColor: const Color(0xFF758493),

  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFFA4A4A4),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF8FAFC),
  shadowColor:  const Color(0xFFE6E5E5),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(
      0xFFE70001))),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFE70001),
    secondary: Color(0xFF171C51),
    tertiary: Color(0xFFd35221),
    onSecondaryContainer: Color(0xFF02AA05),
    error: Color(0xFFf76767),
    onPrimary: Color(0xFFF8FAFC)
  ).copyWith(surface: const Color(0xffFCFCFC)),
);