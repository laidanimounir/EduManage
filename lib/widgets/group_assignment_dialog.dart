import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../repositories/enrollment_repository.dart';
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
  late final SubjectGroupRepository _groupRepo;
  late final EnrollmentRepository _enrollRepo;
  List<SubjectGroup> _groups = [];
  Set<String> _selectedGroupIds = {};
  Set<String> _alreadyEnrolledIds = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _groupRepo = SubjectGroupRepository(widget.database);
    _enrollRepo = EnrollmentRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    final groups = await _groupRepo.getAll();
    final enrollments = await _enrollRepo.getActiveEnrollments(widget.studentId);
    final enrolledIds = enrollments.map((e) => e.subjectGroupId).toSet();
    if (mounted) {
      setState(() {
        _groups = groups;
        _alreadyEnrolledIds = enrolledIds;
        _selectedGroupIds = Set.from(enrolledIds);
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final deviceId = await DeviceId.get();

    for (final gid in _selectedGroupIds) {
      if (!_alreadyEnrolledIds.contains(gid)) {
        final id = UuidHelper.generate();
        await _enrollRepo.create(EnrollmentsCompanion(
          id: Value(id),
          studentId: Value(widget.studentId),
          subjectGroupId: Value(gid),
          status: const Value('active'),
          deviceId: Value(deviceId),
        ));
      }
    }

    final toDrop = _alreadyEnrolledIds.difference(_selectedGroupIds);
    for (final gid in toDrop) {
      final existing = await _enrollRepo.getByStudent(widget.studentId);
      for (final e in existing) {
        if (e.subjectGroupId == gid && e.status == 'active') {
          await _enrollRepo.updateStatus(e.id, 'dropped');
        }
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
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
                  Text(widget.l10n.enrollInGroups,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
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
                  : _groups.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Text(widget.l10n.noGroupsAvailable,
                              style: const TextStyle(color: ShellTokens.textDisabled, fontSize: 13)),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(8),
                          children: _groups.map((g) {
                            final checked = _selectedGroupIds.contains(g.id);
                            final alreadyEnrolled = _alreadyEnrolledIds.contains(g.id);
                            return CheckboxListTile(
                              value: checked,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _selectedGroupIds.add(g.id);
                                  } else {
                                    _selectedGroupIds.remove(g.id);
                                  }
                                });
                              },
                              activeColor: ShellTokens.accent,
                              checkColor: ShellTokens.chromeBase,
                              title: Text(g.nameAr,
                                style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
                              subtitle: Text(g.schoolLevel,
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
                  Text(
                    '${_selectedGroupIds.length} ${widget.l10n.groups.toLowerCase()}',
                    style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary),
                  ),
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
