import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/session_repository.dart';
import '../../utils/device_id.dart';
import '../../utils/uuid_helper.dart';

class CancellationScreen extends StatefulWidget {
  final AppDatabase database;
  const CancellationScreen({super.key, required this.database});
  @override
  State<CancellationScreen> createState() => _CancellationScreenState();
}

class _CancellationScreenState extends State<CancellationScreen> {
  late final SessionRepository _sessionRepo;
  List<Session> _activeSessions = [];
  List<Cancellation> _upcomingCancellations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _sessionRepo = SessionRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    _activeSessions = await _sessionRepo.getActiveAtTime(now);
    _upcomingCancellations = await _getUpcomingCancellations();
    setState(() => _loading = false);
  }

  Future<List<Cancellation>> _getUpcomingCancellations() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return (widget.database.select(widget.database.cancellations)
      ..where((t) => t.cancelDate.isBiggerOrEqualValue(todayStart))
      ..orderBy([(t) => OrderingTerm.asc(t.cancelDate)]))
        .get();
  }

  Future<void> _createCancellation(
      Session session, DateTime date, String reason) async {
    final l10n = AppLocalizations.of(context);
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await widget.database.into(widget.database.cancellations).insert(
          CancellationsCompanion(
            id: Value(id),
            sessionId: Value(session.id),
            cancelDate: Value(date),
            reason: Value(reason),
            deviceId: Value(deviceId),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.cancellationCreated)),
    );
    _load();
  }

  Future<void> _reactivateCancellation(String cancellationId) async {
    await (widget.database.delete(widget.database.cancellations)
      ..where((t) => t.id.equals(cancellationId)))
        .go();
    _load();
  }

  Future<void> _showCancelDialog(Session session) async {
    final l10n = AppLocalizations.of(context);
    final reasonCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.sessionCancellation),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    '${l10n.session}: ${session.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: Text(l10n.selectDate),
                  subtitle: Text(
                    '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
                TextField(
                  controller: reasonCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.reason,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await _createCancellation(session, selectedDate, reasonCtrl.text);
    }
  }

  String _sessionLabel(Session s) {
    final days = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    return '${days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime d) {
    return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
  }

  Future<bool> _confirmReactivate(Cancellation c) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.reactivate),
        content: Text(l10n.confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionCancellation)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.noActiveSessions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_activeSessions.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noActiveSessions),
                    ),
                  )
                else
                  ..._activeSessions.map(
                    (s) => Card(
                      child: ListTile(
                        title: Text(s.id),
                        subtitle: Text(_sessionLabel(s)),
                        trailing: TextButton.icon(
                          icon: const Icon(Icons.cancel_outlined),
                          label: Text(l10n.cancel),
                          onPressed: () => _showCancelDialog(s),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  l10n.upcomingCancellations,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_upcomingCancellations.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noData),
                    ),
                  )
                else
                  ..._upcomingCancellations.map(
                    (c) => Card(
                      child: ListTile(
                        title: Text('${l10n.session}: ${c.sessionId}'),
                        subtitle: Text(
                          '${l10n.cancelledOn} ${_formatDate(c.cancelDate)}'
                          '${c.reason != null ? ' - ${c.reason}' : ''}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.restore, color: Colors.green),
                          tooltip: l10n.reactivate,
                          onPressed: () async {
                            if (await _confirmReactivate(c)) {
                              await _reactivateCancellation(c.id);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
