import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'theme_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ShellTokens.accent,
      brightness: Brightness.dark,
      primary: ShellTokens.accent,
      secondary: ShellTokens.accentMuted,
      onPrimary: ShellTokens.chromeBase,
      surface: ShellTokens.chromeSurface,
      onSurface: ShellTokens.textPrimary,
      error: SemanticTokens.error,
    ),
    scaffoldBackgroundColor: ContentTokens.background,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: ShellTokens.chromeBase,
      foregroundColor: ShellTokens.textPrimary,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: ContentTokens.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: ContentTokens.border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ShellTokens.chromeSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ShellTokens.chromeBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ShellTokens.chromeBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ShellTokens.accent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: const TextStyle(color: ShellTokens.textDisabled),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ShellTokens.accent,
        foregroundColor: ShellTokens.chromeBase,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ShellTokens.textPrimary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ShellTokens.chromeSurface,
      contentTextStyle: const TextStyle(color: ShellTokens.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    dividerTheme: const DividerThemeData(
      color: ShellTokens.chromeBorder,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  );
}
