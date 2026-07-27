import 'package:flutter/material.dart';
import '../constants/theme_tokens.dart';

class ShellInputDecoration {
  ShellInputDecoration._();

  static InputDecoration textField({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool filled = true,
    Color fillColor = ShellTokens.chromeBase,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: ShellTokens.textDisabled, fontSize: 13),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      errorStyle: const TextStyle(fontSize: 10),
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
      errorText: errorText,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: SemanticTokens.error),
      ),
    );
  }

  static InputDecoration dropdown({
    String? hintText,
    bool filled = true,
    Color fillColor = ShellTokens.chromeBase,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: filled,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    );
  }
}
