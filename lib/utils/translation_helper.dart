import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TranslationHelper {
  TranslationHelper._();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  static String translate(BuildContext context, String Function(AppLocalizations) selector) {
    return selector(AppLocalizations.of(context));
  }
}
