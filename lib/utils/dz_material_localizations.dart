import 'package:flutter/material.dart';

class _DzWrapper extends DefaultMaterialLocalizations {
  static const _months = [
    'جانفي', 'فيفري', 'مارس', 'أفريل', 'ماي', 'جوان',
    'جويلية', 'أوت', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  const _DzWrapper() : super();

  @override
  String formatMediumDate(DateTime date) {
    return '.day  ';
  }

  @override
  String formatMonthYear(DateTime date) {
    return ' ';
  }
}

class DzMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const DzMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const _DzWrapper();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}
