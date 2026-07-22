import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../utils/date_helper.dart';
import 'package:drift/drift.dart' hide Column;

class SessionListScreen extends StatefulWidget {
  final AppDatabase database;
  const SessionListScreen({super.key, required this.database});
  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  late final SessionRepository _repo;
  List<Session> _sessions = [];
  bool _loading = true;
  int _selectedDay = 0;

  @override
  void initState() { super.initState(); _repo = SessionRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _sessions = await _repo.getAll(); setState(() => _loading = false); }

  Future<void> _showForm({String? id}) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    List<SubjectGroup> groups = await SubjectGroupRepository(widget.database).getAll();
    List<Teacher> teachers = await TeacherRepository(widget.database).getAll();
    List<Classroom> rooms = await ClassroomRepository(widget.database).getAll();
    String? groupId; String? teacherId; String? roomId; int dayOfWeek = 1;
    final monthlyPriceCtrl = TextEditingController(); final sessionsCountCtrl = TextEditingController(text: '8');
    final sharePctCtrl = TextEditingController(text: '70'); final fixedAmountCtrl = TextEditingController();
    String salaryType = 'percentage';
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 11, minute: 0);

    if (id != null) {
      final s = await _repo.getById(id); if (s != null) {
        groupId = s.subjectGroupId; teacherId = s.teacherId; roomId = s.classroomId;
        dayOfWeek = s.dayOfWeek;
        monthlyPriceCtrl.text = s.monthlyPrice.toString(); sessionsCountCtrl.text = s.sessionsPerMonth.toString();
        sharePctCtrl.text = s.teacherSharePct?.toString() ?? '70';
        fixedAmountCtrl.text = s.teacherFixedAmount?.toString() ?? '';
        salaryType = s.teacherSharePct != null ? 'percentage' : 'fixed';
        startTime = TimeOfDay.fromDateTime(s.startTime); endTime = TimeOfDay.fromDateTime(s.endTime);
      }
    }

    final ok = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      title: Text(id != null ? l10n.edit : l10n.add),
      content: SizedBox(width: 400, child: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(value: groupId, decoration: InputDecoration(labelText: l10n.groups), items: groups.map((g) => DropdownMenuItem(value: g.id, child: Text(g.nameAr))).toList(), onChanged: (v) => setSt(() => groupId = v)),
        DropdownButtonFormField<String>(value: teacherId, decoration: InputDecoration(labelText: l10n.teacher), items: teachers.map((t) => DropdownMenuItem(value: t.id, child: Text('${t.firstNameAr} ${t.lastNameAr}'))).toList(), onChanged: (v) => setSt(() => teacherId = v)),
        DropdownButtonFormField<String>(value: roomId, decoration: InputDecoration(labelText: l10n.classrooms), items: rooms.map((r) => DropdownMenuItem(value: r.id, child: Text(r.nameAr))).toList(), onChanged: (v) => setSt(() => roomId = v)),
        DropdownButtonFormField<int>(value: dayOfWeek, decoration: InputDecoration(labelText: l10n.dayOfWeek), items: List.generate(7, (i) => DropdownMenuItem(value: i + 1, child: Text(DateHelper.formatDayOfWeek(i + 1, 'ar')))), onChanged: (v) => setSt(() => dayOfWeek = v!)),
        ListTile(title: Text(l10n.startTime), subtitle: Text(startTime.format(ctx)), onTap: () async { final t = await showTimePicker(context: context, initialTime: startTime); if (t != null) setSt(() => startTime = t); }),
        ListTile(title: Text(l10n.endTime), subtitle: Text(endTime.format(ctx)), onTap: () async { final t = await showTimePicker(context: context, initialTime: endTime); if (t != null) setSt(() => endTime = t); }),
        TextFormField(controller: monthlyPriceCtrl, decoration: InputDecoration(labelText: l10n.monthlyPrice), keyboardType: TextInputType.number),
        TextFormField(controller: sessionsCountCtrl, decoration: InputDecoration(labelText: l10n.sessionsPerMonth), keyboardType: TextInputType.number),
        DropdownButtonFormField<String>(value: salaryType, decoration: InputDecoration(labelText: l10n.salaryType), items: [DropdownMenuItem(value: 'percentage', child: Text(l10n.percentage)), DropdownMenuItem(value: 'fixed', child: Text(l10n.fixed))], onChanged: (v) => setSt(() => salaryType = v!)),
        if (salaryType == 'percentage') TextFormField(controller: sharePctCtrl, decoration: InputDecoration(labelText: l10n.teacherShare), keyboardType: TextInputType.number),
        if (salaryType == 'fixed') TextFormField(controller: fixedAmountCtrl, decoration: InputDecoration(labelText: l10n.teacherFixedAmount), keyboardType: TextInputType.number),
      ])))),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
    )));
    if (ok == true && groupId != null && teacherId != null && roomId != null) {
      final startDt = DateTime(2026, 1, 1, startTime.hour, startTime.minute);
      final endDt = DateTime(2026, 1, 1, endTime.hour, endTime.minute);
      final c = SessionsCompanion(subjectGroupId: Value(groupId!), teacherId: Value(teacherId!), classroomId: Value(roomId!), dayOfWeek: Value(dayOfWeek), startTime: Value(startDt), endTime: Value(endDt), monthlyPrice: Value(double.tryParse(monthlyPriceCtrl.text) ?? 0), sessionsPerMonth: Value(int.tryParse(sessionsCountCtrl.text) ?? 8), teacherSharePct: Value(salaryType == 'percentage' ? double.tryParse(sharePctCtrl.text) : null), teacherFixedAmount: Value(salaryType == 'fixed' ? double.tryParse(fixedAmountCtrl.text) : null));
      if (id != null) { await _repo.update(id, c); } else { await _repo.create(c); }
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _selectedDay == 0 ? _sessions : _sessions.where((s) => s.dayOfWeek == _selectedDay).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessions)),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: Column(children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), child: Row(children: [
          FilterChip(label: Text(l10n.all), selected: _selectedDay == 0, onSelected: (_) => setState(() => _selectedDay = 0)),
          ...List.generate(7, (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: FilterChip(label: Text(DateHelper.formatDayOfWeek(i + 1, 'ar').substring(0, 4)), selected: _selectedDay == i + 1, onSelected: (_) => setState(() => _selectedDay = i + 1)))),
        ])),
        Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) : filtered.isEmpty ? Center(child: Text(l10n.noData)) : ListView.builder(itemCount: filtered.length, itemBuilder: (_, i) {
          final s = filtered[i];
          final perSession = s.sessionsPerMonth > 0 ? (s.monthlyPrice / s.sessionsPerMonth).toStringAsFixed(0) : '0';
          return Card(child: ListTile(
            leading: CircleAvatar(child: Text(DateHelper.formatDayOfWeek(s.dayOfWeek, 'ar').substring(0, 1))),
            title: Text('${DateHelper.formatDayOfWeek(s.dayOfWeek, 'ar')} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')} - ${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}'),
            subtitle: Text('${l10n.perSessionPrice}: $perSession  |  ${l10n.monthlyPrice}: ${s.monthlyPrice}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showForm(id: s.id)),
              IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () async {
                final c = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: Text(l10n.confirmDelete), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete))]));
                if (c == true) { await _repo.delete(s.id); _load(); }
              }),
            ]),
          ));
        })),
      ]),
    );
  }
}
