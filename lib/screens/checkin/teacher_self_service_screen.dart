import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/subject_group_repository.dart';
import '../../widgets/app_loading.dart';

class TeacherSelfServiceScreen extends StatefulWidget {
  final AppDatabase database;
  final String? currentUserId;
  const TeacherSelfServiceScreen({super.key, required this.database, this.currentUserId});
  @override
  State<TeacherSelfServiceScreen> createState() => _TeacherSelfServiceScreenState();
}

class _TeacherSelfServiceScreenState extends State<TeacherSelfServiceScreen> {
  List<Map<String, dynamic>> _teachers = [];
  String? _selectedTeacherId;
  String? _selectedTeacherName;
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _loadTeachers(); }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _loadTeachers() async {
    final all = await TeacherRepository(widget.database).fetchPage(offset: 0, limit: 100);
    if (mounted) setState(() { _teachers = all.teachers.where((t) => !t.isArchived).map((t) => {'id': t.id, 'name': '${t.firstNameAr} ${t.lastNameAr}', 'code': t.code}).toList(); _loading = false; });
  }

  void _selectTeacher(String id, String name) {
    setState(() { _selectedTeacherId = id; _selectedTeacherName = name; });
    _loadSessions(id);
  }

  Future<void> _loadSessions(String teacherId) async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final today = now.weekday;
    final rows = await widget.database.customSelect(
      'SELECT s.id, s.subject_group_id, s.classroom_id, s.start_time, s.end_time, sg.name_ar AS group_name, c.name_ar AS classroom_name, '
      '(SELECT COUNT(*) FROM attendance a WHERE a.session_id = s.id AND a.attendance_date >= ? AND a.attendance_date < ? AND a.student_id IS NOT NULL AND a.status = \'present\') AS checked_in, '
      '(SELECT COUNT(*) FROM enrollments e WHERE e.subject_group_id = s.subject_group_id AND e.status = \'active\' AND e.is_transferred = 0) AS total_enrolled '
      'FROM sessions s JOIN subject_groups sg ON s.subject_group_id = sg.id LEFT JOIN classrooms c ON s.classroom_id = c.id '
      'WHERE s.teacher_id = ? AND s.day_of_week = ? AND s.is_active = 1 AND s.is_archived = 0 ORDER BY s.start_time',
      variables: [Variable.withDateTime(DateTime(now.year, now.month, now.day)), Variable.withDateTime(DateTime(now.year, now.month, now.day + 1)), Variable.withString(teacherId), Variable.withInt(today)],
    ).map((r) => {
      'id': r.read<String>('id'), 'subject_group_id': r.read<String>('subject_group_id'), 'classroom_id': r.read<String>('classroom_id'),
      'start_time': r.read<DateTime>('start_time'), 'end_time': r.read<DateTime>('end_time'),
      'group_name': r.read<String>('group_name'), 'classroom_name': r.read<String>('classroom_name'),
      'checked_in': r.read<int>('checked_in'), 'total_enrolled': r.read<int>('total_enrolled'),
    }).get();
    if (mounted) setState(() { _sessions = rows; _loading = false; });
  }

  Future<void> _getRoster(Map<String, dynamic> session) async {
    final date = DateTime.now();
    final roster = await widget.database.getSessionRoster(session['id'] as String, date);
    if (!mounted) return;
    showDialog(context: context, builder: (_) => _SimpleRosterDialog(database: widget.database, session: session, roster: roster, currentUserId: widget.currentUserId, onChanged: () => _loadSessions(_selectedTeacherId!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: _loading && _selectedTeacherId == null
          ? const AppLoading()
          : Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
                child: Column(children: [
                  if (_selectedTeacherId == null) ...[
                    SizedBox(height: 38, child: TextField(
                      controller: _searchCtrl, autofocus: true,
                      style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search teacher...', prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary),
                        filled: true, fillColor: ShellTokens.chromeBase, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                      ),
                      onChanged: (q) {
                        if (q.trim().isEmpty) { setState(() => _loading = false); return; }
                        setState(() => _loading = true);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          final filtered = _teachers.where((t) => t['name']!.toLowerCase().contains(q.toLowerCase()) || t['code']!.toLowerCase().contains(q.toLowerCase())).toList();
                          if (mounted) setState(() { _teachers = filtered; _loading = false; });
                        });
                      },
                    )),
                    const SizedBox(height: 6),
                    Flexible(child: ListView.builder(shrinkWrap: true, itemCount: _teachers.take(20).length, itemBuilder: (_, i) {
                      final t = _teachers[i];
                      return ListTile(dense: true, title: Text(t['name']!, style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)), subtitle: Text(t['code']!, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)), onTap: () => _selectTeacher(t['id']!, t['name']!));
                    })),
                  ] else ...[
                    Row(children: [
                      IconButton(icon: const Icon(PhosphorIcons.arrowLeft, size: 16, color: ShellTokens.textSecondary), onPressed: () => setState(() { _selectedTeacherId = null; _selectedTeacherName = null; _sessions = []; }), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                      Text(_selectedTeacherName!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                    ]),
                  ],
                ]),
              ),
              Expanded(
                child: _selectedTeacherId == null
                    ? const Center(child: Text('Select a teacher to view their sessions', style: TextStyle(fontSize: 12, color: ShellTokens.textDisabled)))
                    : _loading
                        ? const AppLoading()
                        : _sessions.isEmpty
                            ? const Center(child: Text('No sessions today', style: TextStyle(fontSize: 12, color: ShellTokens.textDisabled)))
                            : ListView(padding: const EdgeInsets.all(12), children: _sessions.map((s) => Card(
                                color: ShellTokens.chromeSurface,
                                child: ListTile(
                                  title: Text(s['group_name'] ?? '', style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
                                  subtitle: Text('${s['checked_in']}/${s['total_enrolled']} checked in \u00b7 ${s['classroom_name'] ?? ''}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                                  trailing: FilledButton.icon(
                                    icon: const Icon(PhosphorIcons.usersThree, size: 14),
                                    label: const Text('Roster', style: TextStyle(fontSize: 11)),
                                    onPressed: () => _getRoster(s),
                                    style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                  ),
                                ),
                              )).toList()),
              ),
            ]),
    );
  }
}

class _SimpleRosterDialog extends StatefulWidget {
  final AppDatabase database;
  final Map<String, dynamic> session;
  final List<Map<String, dynamic>> roster;
  final String? currentUserId;
  final VoidCallback onChanged;
  const _SimpleRosterDialog({required this.database, required this.session, required this.roster, this.currentUserId, required this.onChanged});
  @override
  State<_SimpleRosterDialog> createState() => _SimpleRosterDialogState();
}

class _SimpleRosterDialogState extends State<_SimpleRosterDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), child: Row(children: [
            Expanded(child: Text(widget.session['group_name'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary))),
            IconButton(icon: const Icon(PhosphorIcons.x, size: 16, color: ShellTokens.textSecondary), onPressed: () => Navigator.pop(context)),
          ])),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true, itemCount: widget.roster.length,
              itemBuilder: (_, i) {
                final r = widget.roster[i];
                final status = r['status'] as String?;
                final isPresent = status == 'present';
                return ListTile(
                  dense: true,
                  leading: Icon(isPresent ? PhosphorIcons.checkCircle : PhosphorIcons.clock, size: 18, color: isPresent ? SemanticTokens.success : ShellTokens.textDisabled),
                  title: Text('${r['first_name_ar'] ?? ''} ${r['last_name_ar'] ?? ''}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                  subtitle: Text(isPresent ? 'Checked in' : 'Not yet', style: TextStyle(fontSize: 10, color: isPresent ? SemanticTokens.success : ShellTokens.textDisabled)),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
