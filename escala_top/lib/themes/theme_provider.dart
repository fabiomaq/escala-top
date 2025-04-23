import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.tacticalTheme; // Tema padrão: tático
  String _currentThemeName = 'tactical';

  ThemeData get currentTheme => _currentTheme;
  String get currentThemeName => _currentThemeName;

  void setTheme(String themeName) {
    switch (themeName) {
      case 'light':
        _currentTheme = AppThemes.lightTheme;
        _currentThemeName = 'light';
        break;
      case 'dark':
        _currentTheme = AppThemes.darkTheme;
        _currentThemeName = 'dark';
        break;
      case 'tactical':
        _currentTheme = AppThemes.tacticalTheme;
        _currentThemeName = 'tactical';
        break;
      case 'blue':
        _currentTheme = AppThemes.blueTheme;
        _currentThemeName = 'blue';
        break;
      case 'pink':
        _currentTheme = AppThemes.pinkTheme;
        _currentThemeName = 'pink';
        break;
      default:
        _currentTheme = AppThemes.tacticalTheme;
        _currentThemeName = 'tactical';
    }
    notifyListeners();
  }
}
