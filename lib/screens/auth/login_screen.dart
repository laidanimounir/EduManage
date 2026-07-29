import 'dart:async';
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/language_switcher.dart';
import '../../constants/theme_tokens.dart';

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
  final _usernameFocus = FocusNode();
  bool _loading = false;
  String? _errorMessage;
  Locale? _locale;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _leftSlide;
  late final Animation<Offset> _rightSlide;
  bool _exiting = false;
  User? _pendingUser;

  bool _obscurePassword = true;

  int _failedAttempts = 0;
  DateTime? _lockoutUntil;
  Timer? _lockoutTimer;
  int _lockoutSeconds = 0;

  @override
  void initState() {
    super.initState();
    _userRepo = UserRepository(widget.database);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
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

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context);
  }

  bool get _isLockedOut {
    if (_lockoutUntil == null) return false;
    if (DateTime.now().isAfter(_lockoutUntil!)) {
      _clearLockout();
      return false;
    }
    return true;
  }

  void _startLockout() {
    _lockoutUntil = DateTime.now().add(const Duration(seconds: 45));
    _lockoutSeconds = 45;
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_lockoutUntil == null) return;
      final remaining = _lockoutUntil!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _clearLockout();
        if (mounted) setState(() {});
        return;
      }
      setState(() => _lockoutSeconds = remaining);
    });
    if (mounted) setState(() => _lockoutSeconds = 45);
  }

  void _clearLockout() {
    _lockoutUntil = null;
    _lockoutTimer?.cancel();
    _lockoutTimer = null;
    _lockoutSeconds = 0;
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_isLockedOut) return;

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
        _failedAttempts = 0;
        _clearLockout();
        _pendingUser = user;
        _usernameFocus.unfocus();
        setState(() => _exiting = true);
        _controller.reverse();
      } else {
        _failedAttempts++;
        if (_failedAttempts >= 5) {
          _startLockout();
          setState(() => _errorMessage = l10n.invalidCredentials);
        } else {
          setState(() => _errorMessage = l10n.invalidCredentials);
        }
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
    final formDisabled = _loading || _exiting || _isLockedOut;

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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(children: [
            Expanded(
              child: SlideTransition(
                position: _leftSlide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _usernameCtrl,
                                focusNode: _usernameFocus,
                                autofocus: true,
                                enabled: !formDisabled,
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
                                enabled: !formDisabled,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: l10n.password,
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      size: 20,
                                      color: ShellTokens.textSecondary,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: formDisabled ? null : (_) => _login(),
                                validator: (v) =>
                                    (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                              ),
                              const SizedBox(height: 12),
                              if (_isLockedOut)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC2823A).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFC2823A).withValues(alpha: 0.3)),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.timer, size: 16, color: Color(0xFFC2823A)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(
                                      'Too many attempts. Try again in ${_lockoutSeconds}s',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFFC2823A), fontWeight: FontWeight.w500),
                                    )),
                                  ]),
                                )
                              else if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(children: [
                                    const Icon(Icons.error_outline, size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                    )),
                                  ]),
                                ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 48,
                                child: _GradientLoginButton(
                                  loading: _loading,
                                  disabled: formDisabled,
                                  onPressed: _login,
                                  label: l10n.login,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0F3D3E), Color(0xFF145C5C)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SlideTransition(
                position: _rightSlide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ShellTokens.chromeSurface, Color(0xFF0A2A1E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.school, size: 120, color: ShellTokens.accent),
                            const SizedBox(height: 24),
                            Text(
                              l10n.appName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ShellTokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.login,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ShellTokens.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameFocus.dispose();
    _controller.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }
}

class _GradientLoginButton extends StatefulWidget {
  final bool loading;
  final bool disabled;
  final VoidCallback onPressed;
  final String label;
  final LinearGradient gradient;

  const _GradientLoginButton({
    required this.loading,
    required this.disabled,
    required this.onPressed,
    required this.label,
    required this.gradient,
  });

  @override
  State<_GradientLoginButton> createState() => _GradientLoginButtonState();
}

class _GradientLoginButtonState extends State<_GradientLoginButton> {
  bool _hovered = false;
  bool _pressed = false;

  Color _brighten(Color c, double factor) {
    return Color.fromARGB(
      (c.a * 255).round(),
      (c.r * 255 + (255 - c.r * 255) * factor).round().clamp(0, 255),
      (c.g * 255 + (255 - c.g * 255) * factor).round().clamp(0, 255),
      (c.b * 255 + (255 - c.b * 255) * factor).round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _pressed
        ? [widget.gradient.colors[0], _brighten(widget.gradient.colors[1], 0.08)]
        : _hovered
            ? [_brighten(widget.gradient.colors[0], 0.06), _brighten(widget.gradient.colors[1], 0.1)]
            : widget.gradient.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTapDown: widget.disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: widget.disabled ? null : (_) { setState(() => _pressed = false); widget.onPressed(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors[0], colors[1]],
              begin: widget.gradient.begin,
              end: widget.gradient.end,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
