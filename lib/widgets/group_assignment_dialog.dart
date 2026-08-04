import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/subject_group_repository.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';

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

class _GroupAssignmentDialogState extends State<GroupAssignmentDialog> {
  late final EnrollmentRepository _enrollRepo;
  List<Session> _sessions = [];
  Map<String, SubjectGroup> _groupMap = {};
  Set<String> _selectedSessionIds = {};
  Set<String> _alreadyEnrolledIds = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _enrollRepo = EnrollmentRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    final allSessions = await (widget.database.select(widget.database.sessions)
      ..where((t) => t.isActive.equals(true) & t.isArchived.equals(false)))
        .get();
    final groupRepo = SubjectGroupRepository(widget.database);
    for (final s in allSessions) {
      if (!_groupMap.containsKey(s.subjectGroupId)) {
        final g = await groupRepo.getById(s.subjectGroupId);
        if (g != null && !g.isArchived) _groupMap[s.subjectGroupId] = g;
      }
    }
    final activeSessions = allSessions.where((s) => _groupMap.containsKey(s.subjectGroupId)).toList();

    final enrollments = await _enrollRepo.getActiveEnrollments(widget.studentId);
    final enrolledIds = enrollments.map((e) => e.sessionId).toSet();

    if (mounted) {
      setState(() {
        _sessions = activeSessions;
        _alreadyEnrolledIds = enrolledIds;
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
        final sess = _sessions.firstWhere((s) => s.id == sid);
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

  static const _days = ['', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

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
                  const Text('تسجيل في الحصص',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                  const Spacer(),
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
                  : _sessions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text('لا توجد حصص متاحة',
                              style: TextStyle(color: ShellTokens.textDisabled, fontSize: 13)),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(8),
                          children: _sessions.map((s) {
                            final checked = _selectedSessionIds.contains(s.id);
                            final alreadyEnrolled = _alreadyEnrolledIds.contains(s.id);
                            final group = _groupMap[s.subjectGroupId];
                            final day = _days[s.dayOfWeek];
                            return CheckboxListTile(
                              value: checked,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _selectedSessionIds.add(s.id);
                                  } else {
                                    _selectedSessionIds.remove(s.id);
                                  }
                                });
                              },
                              activeColor: ShellTokens.accent,
                              checkColor: ShellTokens.chromeBase,
                              title: Text(group?.nameAr ?? '',
                                style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
                              subtitle: Text('$day ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}–${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                              secondary: alreadyEnrolled
                                  ? const Icon(PhosphorIcons.checkCircle, size: 16, color: SemanticTokens.success)
                                  : null,
                              dense: true,
                              contentPadding: const EdgeInsetsDirectional.only(start: 8, end: 12),
                            );
                          }).toList(),
                        ),
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
}
