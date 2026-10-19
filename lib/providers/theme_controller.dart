import 'package:flutter/material.dart';

/// Holds the app-wide [ThemeMode]. Toggled from the drawer's "Dark mode"
/// switch. The singular `config/theme.dart` supplies the actual themes.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void setDark(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
  }

  void toggle() => setDark(!isDark);
}
