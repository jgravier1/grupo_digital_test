import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF1976D2);

  // Esquemas de colores
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  );

  
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      centerTitle: true,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightColorScheme.surface,
      indicatorColor: lightColorScheme.primary.withOpacity(0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: lightColorScheme.primary);
        }
        return IconThemeData(color: lightColorScheme.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: lightColorScheme.primary,
            fontWeight: FontWeight.bold,
          );
        }
        return TextStyle(color: lightColorScheme.onSurfaceVariant);
      }),
    ),
  );

  
}
