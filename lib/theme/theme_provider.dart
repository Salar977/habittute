import 'package:flutter/material.dart';
import 'package:habittute/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  // default theme setting
  ThemeData _themeData = lightMode;

  // getter for themedata
  ThemeData get themeData => _themeData;

  // bool is current theme dark mode
  bool get isDarkMode => themeData == darkMode;

  // setter for themedata
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toogle theme
  void toogleTheme() {
    if(_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}