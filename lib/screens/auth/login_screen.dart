import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/language_switcher.dart';

class LoginScreen extends StatefulWidget {
  final AppDatabase database;
  final void Function(User user)? onLoginSuccess;
  final ValueChanged<Locale>? onLocaleChanged;

  const LoginScreen({
    super.key,
    required this.database,
    this.onLoginSuccess,
    this.onLocaleChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late final UserRepository _userRepo;
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;
  Locale? _locale;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _leftSlide;
  late final Animation<Offset> _rightSlide;
  bool _exiting = false;
  User? _pendingUser;

  @override
  void initState() {
    super.initState();
    _userRepo = UserRepository(widget.database);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _leftSlide = Tween<Offset>(begin: const Offset(-0.3, 0.0), end: Offset.zero).animate(curve);
    _rightSlide = Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero).animate(curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && _exiting) {
        final user = _pendingUser;
        if (user != null) {
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!(user);
          } else {
            Navigator.pop(context, user);
          }
        }
      }
    });

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context);
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final user = await _userRepo.validateCredentials(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );

      if (!mounted) return;

      if (user != null) {
        _pendingUser = user;
        setState(() => _exiting = true);
        _controller.reverse();
      } else {
        setState(() => _errorMessage = l10n.invalidCredentials);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          if (widget.onLocaleChanged != null && _locale != null)
            LanguageSwitcher(
              currentLocale: _locale!,
              onLocaleChanged: widget.onLocaleChanged!,
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlideTransition(
                      position: _rightSlide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: Column(children: [
                          Icon(Icons.school, size: 80, color: Theme.of(context).primaryColor),
                          const SizedBox(height: 16),
                          Text(
                            l10n.appName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _leftSlide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: Column(children: [
                          TextFormField(
                            controller: _usernameCtrl,
                            decoration: InputDecoration(
                              labelText: l10n.username,
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordCtrl,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_loading || _exiting) ? null : (_) => _login(),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                          ),
                          const SizedBox(height: 8),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: (_loading || _exiting) ? null : _login,
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(l10n.login),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }
}
