import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'constants/app_theme.dart';
import 'constants/app_constants.dart';
import 'widgets/language_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLocale = await LanguageSwitcher.loadSavedLocale();
  runApp(EduManageApp(initialLocale: savedLocale));
}

class EduManageApp extends StatefulWidget {
  final Locale initialLocale;

  const EduManageApp({super.key, required this.initialLocale});

  @override
  State<EduManageApp> createState() => _EduManageAppState();

  static _EduManageAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_EduManageAppState>();
  }
}

class _EduManageAppState extends State<EduManageApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const Scaffold(
        body: Center(
          child: Text('EduManage'),
        ),
      ),
    );
  }
}
