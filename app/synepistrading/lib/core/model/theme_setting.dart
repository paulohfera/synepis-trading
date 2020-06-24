import 'package:flutter/material.dart';

import '../themes.dart';

enum ThemeOptions { DARK, LIGHT }

class ThemeSetting {
  ThemeOptions theme;

  ThemeSetting(this.theme);

  String getDisplayName(BuildContext context) {
    switch (theme) {
      case ThemeOptions.LIGHT:
        return "Light";
      default:
        return "Dark";
    }
  }

  BaseTheme getTheme() {
    switch (theme) {
      case ThemeOptions.LIGHT:
        return LighTheme();
      default:
        return DarkTheme();
    }
  }

  // For saving to shared prefs
  int getIndex() {
    return theme.index;
  }
}
