import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'constants/app_theme.dart';
import 'constants/app_constants.dart';
import 'database/app_database.dart';
import 'database/database_provider.dart';
import 'database/database_initializer.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';
import 'widgets/language_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = DatabaseProvider();
  await provider.initialize();
  await DatabaseInitializer.initialize(provider);

  final savedLocale = await LanguageSwitcher.loadSavedLocale();

  runApp(EduManageApp(
    initialLocale: savedLocale,
    databaseProvider: provider,
  ));
}

class EduManageApp extends StatefulWidget {
  final Locale initialLocale;
  final DatabaseProvider databaseProvider;

  const EduManageApp({
    super.key,
    required this.initialLocale,
    required this.databaseProvider,
  });

  @override
  State<EduManageApp> createState() => _EduManageAppState();

  static _EduManageAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_EduManageAppState>();
  }
}

class _EduManageAppState extends State<EduManageApp> {
  late Locale _locale;
  User? _currentUser;

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

  void _onLoginSuccess(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  void logout() {
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: _currentUser != null
          ? MainShell(
              database: widget.databaseProvider.database,
              userId: _currentUser!.id,
              userRole: _currentUser!.role,
              userName: _currentUser!.username,
              firstName: _currentUser!.firstName,
              lastName: _currentUser!.lastName,
            )
          : LoginScreen(
              database: widget.databaseProvider.database,
              onLoginSuccess: _onLoginSuccess,
              onLocaleChanged: changeLocale,
            ),
    );
  }
}
