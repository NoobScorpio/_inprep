import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> toogleLightMode(context) async {
  AdaptiveThemeMode theme = await AdaptiveTheme.getThemeMode();
  if (theme.isDark) {
    AdaptiveTheme.of(context).setLight();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', false);
  }
}
