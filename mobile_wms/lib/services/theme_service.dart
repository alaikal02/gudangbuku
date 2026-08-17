import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ========== DARK THEME ==========
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    useMaterial3: true,
    primaryColor: const Color(0xFF1E1E2E),
    scaffoldBackgroundColor: const Color(0xFF181825),
    colorScheme: const ColorScheme.dark(
      primary: Colors.cyanAccent,
      secondary: Colors.greenAccent,
      surface: Color(0xFF1E1E2E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E2E),
      elevation: 0,
    ),
    cardColor: const Color(0xFF1E1E2E),
    dividerColor: const Color(0xFF2A2A3D),
  );

  // ========== LIGHT THEME ==========
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    useMaterial3: true,
    primaryColor: const Color(0xFF4A90D9),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4A90D9),
      secondary: Color(0xFF2ECC71),
      surface: Colors.white,
      onSurface: Color(0xFF2D3436),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF2D3436)),
      titleTextStyle: TextStyle(
        color: Color(0xFF2D3436),
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Roboto',
      ),
    ),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE0E0E0),
  );
}
