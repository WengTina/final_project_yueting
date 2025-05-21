import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 212, 212, 237),
    tertiary: const Color.fromARGB(31, 93, 31, 86),
    
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
  ),
);
