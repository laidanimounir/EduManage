import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/settings_repository.dart';
import '../../constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  final AppDatabase database;

  const SettingsScreen({super.key, required this.database});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsRepository _settingsRepo;
  int _sessionTimeout = AppConstants.defaultSessionTimeoutMinutes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _settingsRepo = SettingsRepository(widget.database);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final timeoutStr = await _settingsRepo.get('session_timeout_minutes');
    if (timeoutStr != null) {
      final parsed = int.tryParse(timeoutStr);
      if (parsed != null) _sessionTimeout = parsed;
    }
    setState(() => _loading = false);
  }

  Future<void> _saveSessionTimeout(int minutes) async {
    await _settingsRepo.set('session_timeout_minutes', minutes.toString());
    setState(() => _sessionTimeout = minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 12),
                      Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? l10n.arabic
                            : l10n.francais,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sessionTimeout, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: _sessionTimeout.toDouble(),
                          min: 5,
                          max: 120,
                          divisions: 23,
                          label: '$_sessionTimeout ${l10n.minutes}',
                          onChanged: (v) => _saveSessionTimeout(v.round()),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '$_sessionTimeout ${l10n.minutes}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.about, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.appName),
                    subtitle: Text('${l10n.version}: 1.0.0'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
