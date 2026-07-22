import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSwitcher({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  static const String _prefsKey = 'selected_language';
  static const Locale defaultLocale = Locale('ar');

  static Future<Locale> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_prefsKey) ?? defaultLocale.languageCode;
    return Locale(langCode);
  }

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = currentLocale.languageCode == 'ar';

    return SegmentedButton<String>(
      segments: [
        ButtonSegment<String>(
          value: 'ar',
          label: Text(l10n.arabic),
        ),
        ButtonSegment<String>(
          value: 'fr',
          label: Text(l10n.francais),
        ),
      ],
      selected: {currentLocale.languageCode},
      onSelectionChanged: (selection) async {
        final locale = Locale(selection.first);
        await saveLocale(locale);
        onLocaleChanged(locale);
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white70;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white.withValues(alpha: 0.25);
            }
            return Colors.transparent;
          },
        ),
      ),
    );
  }
}
