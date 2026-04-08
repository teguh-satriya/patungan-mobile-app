import 'package:flutter/material.dart';

class AppTheme {
  static const Color seed = Color(0xFF8E24AA);

  static ThemeData light() {
    final cs = ColorScheme.fromSeed(seedColor: seed);
    final custom = cs.copyWith(
      primary: cs.primary,
      secondary: cs.secondary,
      error: cs.error,
    );

    return ThemeData(
      colorScheme: custom,
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: custom.primary, foregroundColor: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: custom.primary),
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    final custom = cs.copyWith(
      primary: cs.primary,
      secondary: cs.secondary,
      error: cs.error,
    );

    return ThemeData(
      colorScheme: custom,
      brightness: Brightness.dark,
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: custom.primary, foregroundColor: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: custom.primary),
    );
  }
}

extension AppThemeColors on BuildContext {
  Color get appPrimary => Theme.of(this).colorScheme.primary;
  Color get appSecondary => Theme.of(this).colorScheme.secondary;
  Color get appSuccess => const Color(0xFF4CAF50);
  Color get appDanger => const Color(0xFFF44336);
  Color get appWarning => const Color(0xFFFFC107);
  Color get appInfo => const Color(0xFF2196F3);
  Color get appAccent => Theme.of(this).colorScheme.secondary;
}
