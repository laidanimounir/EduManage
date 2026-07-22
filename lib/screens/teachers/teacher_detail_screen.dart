import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import 'teacher_form_screen.dart';

class TeacherDetailScreen extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  const TeacherDetailScreen({super.key, required this.database, required this.teacherId});
  @override
  State<TeacherDetailScreen> createState() => _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
  Teacher? _t;
  List<Session> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _t = await TeacherRepository(widget.database).getById(widget.teacherId);
    _sessions = await SessionRepository(widget.database).getByTeacher(widget.teacherId);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) return Scaffold(appBar: AppBar(title: Text(l10n.details)), body: const Center(child: CircularProgressIndicator()));
    if (_t == null) return Scaffold(appBar: AppBar(title: Text(l10n.details)), body: Center(child: Text(l10n.noData)));

    final t = _t!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${t.firstNameAr} ${t.lastNameAr}'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherFormScreen(database: widget.database, teacherId: t.id)));
            _load();
          }),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.personalInfo, style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          _row(l10n.code, t.code), _row(l10n.firstName, '${t.firstNameAr} / ${t.firstNameFr ?? ''}'),
          _row(l10n.phone, t.phone ?? '--'), _row(l10n.email, t.email ?? '--'),
          _row(l10n.salaryType, t.salaryType == 'percentage' ? l10n.percentage : l10n.fixed),
          if (t.salaryType == 'percentage') _row(l10n.teacherShare, '${t.teacherSharePct}%'),
          if (t.salaryType == 'fixed') _row(l10n.teacherFixedAmount, '${t.teacherFixedAmount}'),
        ]))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.sessions, style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          if (_sessions.isEmpty) Text(l10n.noData) else ..._sessions.map((s) => ListTile(title: Text('${l10n.session} ${s.dayOfWeek}'), subtitle: Text('${s.startTime.hour}:${s.startTime.minute} - ${s.endTime.hour}:${s.endTime.minute}'))),
        ]))),
      ]),
    );
  }

  Widget _row(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))), Expanded(child: Text(value))]));
}
