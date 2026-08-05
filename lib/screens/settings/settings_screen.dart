import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../utils/date_helper.dart';

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
  final _feeAmountCtrl = TextEditingController();
  final _feeFormKey = GlobalKey<FormState>();
  bool _feeSaving = false;
  List<int> _agingBuckets = [30, 60, 90];
  int _undoWindowMinutes = 10;
  Map<int, DayOperatingHours> _hours = {};
  bool _hoursSaving = false;
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
    _feeAmountCtrl.text = _registrationFeeAmount.toStringAsFixed(0);
    final ag1 = prefs.getInt('aging_bucket_1') ?? 30;
    final ag2 = prefs.getInt('aging_bucket_2') ?? 60;
    final ag3 = prefs.getInt('aging_bucket_3') ?? 90;
    _agingBuckets = [ag1, ag2, ag3];
    _undoWindowMinutes = prefs.getInt('undo_window_minutes') ?? 10;
    _hours = await _settingsRepo.getOperatingHours();
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _feeAmountCtrl.dispose();
    super.dispose();
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

  Widget _buildOperatingHoursCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('School Operating Hours', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Used to suggest free slots when scheduling sessions. A day marked closed is treated as fully unavailable.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            for (var day = 1; day <= 7; day++) _buildHoursRow(day),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _hoursSaving ? null : _suggestOperatingHours,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Auto-suggest from existing sessions', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 4),
            const Text('These are suggestions to review, not saved until you press Save below.',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hoursSaving ? null : _saveHours,
                icon: const Icon(Icons.save_outlined, size: 16),
                label: Text(_hoursSaving ? 'Saving...' : 'Save Operating Hours', style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursRow(int day) {
    final hours = _hours[day] ?? DayOperatingHours.defaultDay;
    final disabled = hours.closed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
          width: 72,
          child: Text(
            DateHelper.formatDayOfWeek(day, Localizations.localeOf(context).languageCode),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: _timeButton(disabled ? '--:--' : _fmtTime(hours.openMinutes), disabled, () => _pickTime(day, true))),
        const SizedBox(width: 6),
        const Text('—', style: TextStyle(color: ShellTokens.textDisabled)),
        const SizedBox(width: 6),
        Expanded(child: _timeButton(disabled ? '--:--' : _fmtTime(hours.closeMinutes), disabled, () => _pickTime(day, false))),
        const SizedBox(width: 4),
        Switch(value: hours.closed, onChanged: (_) => _toggleClosed(day), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        IconButton(
          icon: const Icon(Icons.copy, size: 15, color: ShellTokens.textSecondary),
          tooltip: 'Copy to other days',
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          padding: EdgeInsets.zero,
          onPressed: () => _copyDayToOthers(day),
        ),
      ]),
    );
  }

  Widget _timeButton(String text, bool disabled, VoidCallback onTap) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        decoration: BoxDecoration(
          color: ShellTokens.chromeBase,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: disabled ? ShellTokens.chromeBorder : ShellTokens.accent),
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: disabled ? ShellTokens.textDisabled : ShellTokens.textPrimary)),
      ),
    );
  }

  String _fmtTime(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime(int day, bool isOpen) async {
    final hours = _hours[day] ?? DayOperatingHours.defaultDay;
    final minutes = isOpen ? hours.openMinutes : hours.closeMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      final updated = Map<int, DayOperatingHours>.from(_hours);
      updated[day] = DayOperatingHours(
        closed: hours.closed,
        openMinutes: isOpen ? picked.hour * 60 + picked.minute : hours.openMinutes,
        closeMinutes: isOpen ? hours.closeMinutes : picked.hour * 60 + picked.minute,
      );
      _hours = updated;
    });
  }

  void _toggleClosed(int day) {
    final hours = _hours[day] ?? DayOperatingHours.defaultDay;
    setState(() {
      final updated = Map<int, DayOperatingHours>.from(_hours);
      updated[day] = DayOperatingHours(closed: !hours.closed, openMinutes: hours.openMinutes, closeMinutes: hours.closeMinutes);
      _hours = updated;
    });
  }

  Future<void> _copyDayToOthers(int day) async {
    final source = _hours[day] ?? DayOperatingHours.defaultDay;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: const Text('Copy to all other days?'),
        content: const Text('This replaces the operating hours of every other day of the week with this day\u2019s values.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Copy')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      final updated = Map<int, DayOperatingHours>.from(_hours);
      for (var d = 1; d <= 7; d++) {
        if (d != day) updated[d] = source;
      }
      _hours = updated;
    });
  }

  Future<void> _suggestOperatingHours() async {
    final suggestion = await SessionRepository(widget.database).suggestOperatingHours();
    if (!mounted) return;
    setState(() {
      final updated = Map<int, DayOperatingHours>.from(_hours);
      suggestion.forEach((day, range) {
        updated[day] = DayOperatingHours(closed: false, openMinutes: range.openMinutes, closeMinutes: range.closeMinutes);
      });
      _hours = updated;
    });
  }

  Future<void> _saveHours() async {
    setState(() => _hoursSaving = true);
    await _settingsRepo.setOperatingHours(_hours);
    if (!mounted) return;
    setState(() => _hoursSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Operating hours saved'),
      backgroundColor: ShellTokens.chromeSurface,
    ));
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
                  Form(
                    key: _feeFormKey,
                    child: Row(
                      children: [
                        const Text('DA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _feeAmountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(isDense: true),
                            validator: (v) {
                              final parsed = double.tryParse(v ?? '');
                              if (parsed == null || parsed <= 0) return '\u0642\u064A\u0645\u0629 \u063A\u064A\u0631 \u0635\u0627\u0644\u062D\u0629';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _feeSaving ? null : () async {
                            if (!_feeFormKey.currentState!.validate()) return;
                            setState(() => _feeSaving = true);
                            final amount = double.tryParse(_feeAmountCtrl.text) ?? 2000.0;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setDouble('registration_fee_amount', amount);
                            setState(() { _registrationFeeAmount = amount; _feeSaving = false; });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('\u062A\u0645 \u062D\u0641\u0638 \u0627\u0644\u0642\u064A\u0645\u0629'), backgroundColor: ShellTokens.accentMuted),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase),
                          child: Text('\u062D\u0641\u0638'),
                        ),
                      ],
                    ),
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
          _buildOperatingHoursCard(),
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
