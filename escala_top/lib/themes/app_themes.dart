import 'package:flutter/material.dart';

class AppThemes {
  // Tema Claro
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      background: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Tema Escuro
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[800],
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey[800]!,
      secondary: Colors.blueGrey[600]!,
      background: Colors.grey[900]!,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[800],
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Tema Tático (Verde-oliva com preto)
  static ThemeData tacticalTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF556B2F), // Verde-oliva
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF556B2F), // Verde-oliva
      secondary: Color(0xFF6B8E23), // Verde-oliva mais claro
      background: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF556B2F),
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF556B2F),
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Tema Azul
  static ThemeData blueTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue[700],
    colorScheme: ColorScheme.light(
      primary: Colors.blue[700]!,
      secondary: Colors.blue[500]!,
      background: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Tema Rosa
  static ThemeData pinkTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.pink,
    colorScheme: ColorScheme.light(
      primary: Colors.pink,
      secondary: Colors.pinkAccent,
      background: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.pink,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.pink[900], fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
