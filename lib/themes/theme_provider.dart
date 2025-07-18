import 'package:final_yueting/themes/dark_mode.dart';
import 'package:final_yueting/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  
  ThemeData _themeData = lightMode;

 
  ThemeData get themeData => _themeData;


  bool get isDarkMode => _themeData == darkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    
    notifyListeners();
    _saveThemeToPrefs();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
   Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeData == darkMode);
  }
}
