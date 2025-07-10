import 'package:flutter/material.dart';

final lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade800
  )
);

final darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300
  )
);