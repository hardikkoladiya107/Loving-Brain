import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
);

final lightColorScheme = ColorScheme.light(
  primary: Color(0xFF0D47A1),
  secondary: Color(0xFFFFA000),
  surface: Colors.white,
  error: Color(0xFFD32F2F),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.black87,
  onError: Colors.white,
);

final darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF90CAF9),
  secondary: Color(0xFFFFCC80),
  surface: Color(0xFF1E1E1E),
  error: Color(0xFFEF9A9A),
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onError: Colors.black,
);
