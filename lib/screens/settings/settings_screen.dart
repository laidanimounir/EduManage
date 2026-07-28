import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/settings_repository.dart';
import '../../constants/app_constants.dart';
import '../../constants/theme_tokens.dart';

class SettingsScreen extends StatefulWidget {
  final AppDatabase database;

  const SettingsScreen({super.key, required this.database});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsRepository _settingsRepo;
  int _sessionTimeout = AppConstants.defaultSessionTimeoutMinutes;
  double _registrationFeeAmount = 2000;
  List<int> _agingBuckets = [30, 60, 90];
  int _undoWindowMinutes = 10;
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
    final prefs = await SharedPreferences.getInstance();
    _registrationFeeAmount = prefs.getDouble('registration_fee_amount') ?? 2000.0;
    final ag1 = prefs.getInt('aging_bucket_1') ?? 30;
    final ag2 = prefs.getInt('aging_bucket_2') ?? 60;
    final ag3 = prefs.getInt('aging_bucket_3') ?? 90;
    _agingBuckets = [ag1, ag2, ag3];
    _undoWindowMinutes = prefs.getInt('undo_window_minutes') ?? 10;
    setState(() => _loading = false);
  }

  Future<void> _saveAgingBucket(int index, int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('aging_bucket_${index + 1}', days);
    setState(() => _agingBuckets[index] = days);
  }

  Future<void> _saveSessionTimeout(int minutes) async {
    await _settingsRepo.set('session_timeout_minutes', minutes.toString());
    setState(() => _sessionTimeout = minutes);
  }

  Widget _agingField(int index, String label, Color color) {
    return Expanded(
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: _agingBuckets[index].toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
          style: TextStyle(fontSize: 12, color: color),
          onChanged: (v) {
            final d = int.tryParse(v) ?? _agingBuckets[index];
            if (d > 0) _saveAgingBucket(index, d);
          },
        ),
      ]),
    );
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
                  Text(l10n.registrationFee, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(l10n.registrationFeeDescription, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('DA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: _registrationFeeAmount.toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(isDense: true),
                          onChanged: (v) async {
                            final amount = double.tryParse(v) ?? 2000.0;
                            if (amount > 0) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setDouble('registration_fee_amount', amount);
                              setState(() => _registrationFeeAmount = amount);
                            }
                          },
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
                  const Text('Debt Aging Buckets (Days)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Colors indicate how long a debt has been outstanding',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _agingField(0, 'Green', const Color(0xFF27AE60)),
                    const SizedBox(width: 8),
                    _agingField(1, 'Amber', SemanticTokens.warning),
                    const SizedBox(width: 8),
                    _agingField(2, 'Red', SemanticTokens.error),
                  ]),
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
                  const Text('Undo Window (Minutes)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('How long after check-in the undo button remains visible',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: _undoWindowMinutes.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                        onChanged: (v) async {
                          final mins = int.tryParse(v) ?? 10;
                          if (mins >= 0) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('undo_window_minutes', mins);
                            setState(() => _undoWindowMinutes = mins);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('minutes', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ]),
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
