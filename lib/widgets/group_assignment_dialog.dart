import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/subject_repository.dart';
import '../repositories/subject_group_repository.dart';
import '../utils/device_id.dart';
import '../widgets/shell_input_decoration.dart';

class GroupAssignmentDialog extends StatefulWidget {
  final AppDatabase database;
  final String studentId;
  final AppLocalizations l10n;

  const GroupAssignmentDialog({
    super.key,
    required this.database,
    required this.studentId,
    required this.l10n,
  });

  @override
  State<GroupAssignmentDialog> createState() => _GroupAssignmentDialogState();
}

class _GroupData {
  _GroupData(this.group, this.sessions, this.enrollCount);
  final SubjectGroup group;
  final List<Session> sessions;
  final int enrollCount;
}

class _SubjectData {
  _SubjectData(this.subject, this.groups);
  final Subject subject;
  final List<_GroupData> groups;
}

class _GroupAssignmentDialogState extends State<GroupAssignmentDialog> {
  late final EnrollmentRepository _enrollRepo;
  List<_SubjectData> _subjects = [];
  Set<String> _selectedSessionIds = {};
  Set<String> _alreadyEnrolledIds = {};
  String? _currentSubjectId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _enrollRepo = EnrollmentRepository(widget.database);
    _load();
  }

  static const _days = ['', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  Future<void> _load() async {
    final allSessions = await (widget.database.select(widget.database.sessions)
      ..where((t) => t.isActive.equals(true) & t.isArchived.equals(false)))
        .get();

    final groupRepo = SubjectGroupRepository(widget.database);
    final subjectRepo = SubjectRepository(widget.database);

    final allGroups = await groupRepo.getAll();
    final groupsById = <String, SubjectGroup>{
      for (final g in allGroups) g.id: g,
    };
    final archivedGroupIds = allGroups.where((g) => g.isArchived).map((g) => g.id).toSet();

    // Sessions grouped by subject_group (only those belonging to a non-archived group).
    final sessionsByGroup = <String, List<Session>>{};
    for (final s in allSessions) {
      final g = groupsById[s.subjectGroupId];
      if (g != null && !archivedGroupIds.contains(g.id)) {
        sessionsByGroup.putIfAbsent(s.subjectGroupId, () => []).add(s);
      }
    }

    // Resolve subjects for each group (prefer subject_id, fall back to subjectAr match).
    final subjects = await subjectRepo.getAllActive();
    final subjectById = <String, Subject>{for (final s in subjects) s.id: s};
    final subjectByAr = <String, Subject>{
      for (final s in subjects) if (s.nameAr.isNotEmpty) s.nameAr: s,
    };

    Subject? subjectOf(SubjectGroup g) {
      if (g.subjectId != null && subjectById.containsKey(g.subjectId)) {
        return subjectById[g.subjectId];
      }
      return subjectByAr[g.subjectAr];
    }

    final groupsBySubject = <String, List<_GroupData>>{};
    for (final g in allGroups) {
      if (g.isArchived) continue;
      final sessions = sessionsByGroup[g.id];
      if (sessions == null || sessions.isEmpty) continue;
      final subj = subjectOf(g);
      if (subj == null) continue;
      final enrollCount = await groupRepo.activeEnrollmentCount(g.id);
      groupsBySubject.putIfAbsent(subj.id, () => []).add(_GroupData(g, sessions, enrollCount));
    }

    final subjectData = <_SubjectData>[];
    for (final s in subjects) {
      final gs = groupsBySubject[s.id];
      if (gs == null || gs.isEmpty) continue;
      subjectData.add(_SubjectData(s, gs));
    }

    final enrollments = await _enrollRepo.getActiveEnrollments(widget.studentId);
    final enrolledIds = enrollments.map((e) => e.sessionId).toSet();

    if (mounted) {
      setState(() {
        _subjects = subjectData;
        _alreadyEnrolledIds = enrolledIds;
        // Preselect the first subject for the two-step drill-down, keeping
        // already-enrolled selections pre-checked.
        _currentSubjectId = subjectData.isNotEmpty ? subjectData.first.subject.id : null;
        _selectedSessionIds = Set.from(enrolledIds);
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final deviceId = await DeviceId.get();

    for (final sid in _selectedSessionIds) {
      if (!_alreadyEnrolledIds.contains(sid)) {
        final sess = _sessionById(sid);
        if (sess == null) continue;
        await _enrollRepo.create(EnrollmentsCompanion(
          studentId: Value(widget.studentId),
          sessionId: Value(sid),
          subjectGroupId: Value(sess.subjectGroupId),
          status: const Value('active'),
          deviceId: Value(deviceId),
        ));
      }
    }

    final toDrop = _alreadyEnrolledIds.difference(_selectedSessionIds);
    for (final sid in toDrop) {
      final existing = await _enrollRepo.getByStudent(widget.studentId);
      for (final e in existing) {
        if (e.sessionId == sid && e.status == 'active') {
          await _enrollRepo.updateStatus(e.id, 'dropped');
        }
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  Session? _sessionById(String id) {
    for (final sd in _subjects) {
      for (final gd in sd.groups) {
        for (final s in gd.sessions) {
          if (s.id == id) return s;
        }
      }
    }
    return null;
  }

  String _dayLabel(Session s) => '${_days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}–${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}';

  bool _isDuplicateGroupSelection(_GroupData gd) {
    var count = 0;
    for (final s in gd.sessions) {
      if (_selectedSessionIds.contains(s.id) || _alreadyEnrolledIds.contains(s.id)) count++;
    }
    return count > 1;
  }

  bool _isFull(_GroupData gd) =>
      gd.group.capacity != null && gd.enrollCount >= gd.group.capacity!;

  Future<void> _onSessionToggle(_GroupData gd, Session s, bool? v) async {
    if (v != true) {
      setState(() => _selectedSessionIds.remove(s.id));
      return;
    }
    if (!_isFull(gd)) {
      setState(() => _selectedSessionIds.add(s.id));
      return;
    }

    // Group is at/over capacity — reuse the capacity flow used by the
    // standalone Enrollment screen and group detail dialog.
    final l10n = widget.l10n;
    final action = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: const Text('القسم ممتلئ', style: TextStyle(color: ShellTokens.textPrimary)),
      content: Text('Active enrollments (${gd.enrollCount}) equals capacity (${gd.group.capacity}). Increase capacity, add to waitlist, or cancel.', style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.pop(ctx, 'waitlist'), child: const Text('Add to Waitlist', style: TextStyle(color: ShellTokens.accent))),
        TextButton(onPressed: () => Navigator.pop(ctx, 'increase'), child: const Text('Increase Capacity', style: TextStyle(color: ShellTokens.accent))),
      ],
    ));
    if (!mounted) return;

    if (action == 'increase') {
      final groupRepo = SubjectGroupRepository(widget.database);
      final ctrl = TextEditingController(text: '${gd.group.capacity! + 1}');
      final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: const Text('تعيين سعة جديدة', style: TextStyle(color: ShellTokens.textPrimary)),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, style: const TextStyle(color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField()),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
      ));
      if (ok == true && mounted) {
        await groupRepo.update(gd.group.id, SubjectGroupsCompanion(capacity: Value(int.tryParse(ctrl.text))));
        setState(() => _selectedSessionIds.add(s.id));
      }
    } else if (action == 'waitlist' && mounted) {
      await _enrollRepo.addToWaitlist(widget.studentId, gd.group.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت الإضافة إلى قائمة الانتظار')));
    }
  }

  String _level(String l) {
    final l10n = widget.l10n;
    return switch (l) {
      'primary' => l10n.schoolLevelPrimary,
      'middle' => l10n.schoolLevelMiddle,
      'secondary' => l10n.schoolLevelSecondary,
      _ => l,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
              ),
              child: Row(
                children: [
                  if (_currentSubjectId != null)
                    IconButton(
                      icon: const Icon(PhosphorIcons.arrowLeft, size: 18, color: ShellTokens.textSecondary),
                      onPressed: _loading ? null : () => setState(() => _currentSubjectId = null),
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      padding: EdgeInsets.zero,
                    ),
                  Expanded(
                    child: Text(
                      _currentSubjectId == null ? 'تسجيل في الحصص' : _subjects.firstWhere((s) => s.subject.id == _currentSubjectId, orElse: () => _subjects.first).subject.nameAr,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(PhosphorIcons.x, size: 18, color: ShellTokens.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)),
                      ),
                    )
                  : _subjects.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text('لا توجد حصص متاحة',
                              style: TextStyle(color: ShellTokens.textDisabled, fontSize: 13)),
                          ),
                        )
                      : _currentSubjectId == null
                          ? ListView(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              children: _subjects.map((sd) => _SubjectRow(
                                data: sd,
                                selectedCount: sd.groups.fold<int>(0, (acc, gd) => acc + gd.sessions.where((s) => _selectedSessionIds.contains(s.id)).length),
                                onTap: () => setState(() => _currentSubjectId = sd.subject.id),
                              )).toList(),
                            )
                          : _buildSubjectDetail(),
            ),
            const Divider(height: 1, color: ShellTokens.chromeBorder),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text('${_selectedSessionIds.length} مختار',
                    style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(widget.l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: ShellTokens.accent,
                      foregroundColor: ShellTokens.chromeBase,
                    ),
                    child: Text(widget.l10n.save),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectDetail() {
    final sd = _subjects.firstWhere((s) => s.subject.id == _currentSubjectId,
        orElse: () => _subjects.first);
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (final gd in sd.groups) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 2),
            child: Row(children: [
              Expanded(child: Text(gd.group.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ShellTokens.textPrimary))),
              if (_isFull(gd))
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: SemanticTokens.error.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('Full', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: SemanticTokens.error)),
                ),
              Text(_level(gd.group.schoolLevel), style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            ]),
          ),
          if (_isDuplicateGroupSelection(gd)) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: SemanticTokens.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: SemanticTokens.warning.withValues(alpha: 0.4))),
                child: Row(children: [
                  const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning),
                  const SizedBox(width: 8),
                  Expanded(child: Text('يتم تسجيل الطالب في أكثر من حصة لنفس القسم — قد يؤدي هذا إلى ازدواج في الفوترة', style: const TextStyle(fontSize: 11, color: SemanticTokens.warning))),
                ]),
              ),
            ),
          ],
          for (final s in gd.sessions)
            CheckboxListTile(
              value: _selectedSessionIds.contains(s.id),
              onChanged: (v) => _onSessionToggle(gd, s, v),
              activeColor: ShellTokens.accent,
              checkColor: ShellTokens.chromeBase,
              title: Text(_dayLabel(s), style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
              secondary: _alreadyEnrolledIds.contains(s.id)
                  ? const Icon(PhosphorIcons.checkCircle, size: 16, color: SemanticTokens.success)
                  : null,
              dense: true,
              contentPadding: const EdgeInsetsDirectional.only(start: 8, end: 12),
            ),
        ],
      ],
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final _SubjectData data;
  final int selectedCount;
  final VoidCallback onTap;
  const _SubjectRow({required this.data, required this.selectedCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final totalSessions = data.groups.fold<int>(0, (acc, gd) => acc + gd.sessions.length);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(children: [
          const Icon(PhosphorIcons.notebook, size: 18, color: ShellTokens.accent),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.subject.nameAr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            if (data.subject.nameFr != null && data.subject.nameFr!.isNotEmpty)
              Text(data.subject.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            const SizedBox(height: 2),
            Text('${data.groups.length} قسم · $totalSessions حصة', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
          ])),
          const SizedBox(width: 8),
          if (selectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: ShellTokens.accent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: Text('$selectedCount', style: const TextStyle(fontSize: 10, color: ShellTokens.accent, fontWeight: FontWeight.w700)),
            ),
          const SizedBox(width: 4),
          const Icon(PhosphorIcons.caretRight, size: 14, color: ShellTokens.textDisabled),
        ]),
      ),
    );
  }
}