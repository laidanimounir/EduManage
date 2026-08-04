import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_empty_state.dart';
import '../../utils/device_id.dart';

class SpecialCasesScreen extends StatefulWidget {
  final AppDatabase database;
  final String createdByUserId;
  const SpecialCasesScreen({super.key, required this.database, required this.createdByUserId});
  @override
  State<SpecialCasesScreen> createState() => _SpecialCasesScreenState();
}

class _SpecialCasesScreenState extends State<SpecialCasesScreen> {
  List<SpecialCase> _cases = [];
  Map<String, String> _studentNames = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<String> _studentName(String studentId) async {
    if (_studentNames.containsKey(studentId)) return _studentNames[studentId]!;
    final s = await (widget.database.select(widget.database.students)
      ..where((t) => t.id.equals(studentId))).getSingleOrNull();
    final name = s == null ? studentId : '${s.firstNameAr} ${s.lastNameAr}';
    _studentNames[studentId] = name;
    return name;
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final cases = await (widget.database.select(widget.database.specialCases)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
      if (mounted) setState(() { _cases = cases; _loading = false; _error = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load special cases: $e'; });
    }
  }

  void _openCreate() {
    showDialog(
      context: context,
      builder: (_) => _SpecialCaseEditDialog(database: widget.database, currentUserId: widget.createdByUserId),
    ).then((_) { try { _load(); } catch (_) {} });
  }

  void _openEdit(SpecialCase c) {
    showDialog(
      context: context,
      builder: (_) => _SpecialCaseEditDialog(database: widget.database, currentUserId: widget.createdByUserId, specialCase: c),
    ).then((_) { try { _load(); } catch (_) {} });
  }

  Future<void> _revoke(SpecialCase c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: const Text('Revoke Exemption', style: TextStyle(color: ShellTokens.textPrimary)),
        content: const Text('Deactivate this special case? It will no longer apply to new charges.',
            style: TextStyle(color: ShellTokens.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revoke', style: TextStyle(color: SemanticTokens.error))),
        ],
      ),
    );
    if (confirmed == true) {
      await (widget.database.update(widget.database.specialCases)..where((t) => t.id.equals(c.id)))
        .write(SpecialCasesCompanion(isActive: const Value(false)));
      await widget.database.into(widget.database.auditLog).insert(AuditLogCompanion(
        userId: Value(widget.createdByUserId),
        action: const Value('special_case_revoked'),
        entityType: const Value('special_case'),
        entityId: Value(c.id),
        details: Value('Student: ${c.studentId}, Case: ${c.reason}'),
      ));
      await _load();
    }
  }

  String _caseSummary(SpecialCase c) {
    if (c.caseType == 'full') return 'Full exemption';
    if (c.discountPercent != null) return 'Partial — ${c.discountPercent!.toStringAsFixed(0)}%';
    if (c.discountFixed != null) return 'Partial — ${c.discountFixed!.toStringAsFixed(0)} DA';
    return 'Partial exemption';
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: ContentTokens.background,
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(PhosphorIcons.warning, size: 32, color: SemanticTokens.warning),
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: ShellTokens.textSecondary)),
          const SizedBox(height: 12),
          TextButton(onPressed: _load, child: const Text('Retry')),
        ])),
      );
    }
    if (_loading) return const AppLoading();
    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(children: [
            const Text('Special Cases', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            const Spacer(),
            IconButton(icon: const Icon(PhosphorIcons.plus, size: 18, color: ShellTokens.accent),
              onPressed: _openCreate, padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
          ]),
        ),
        Expanded(
          child: _cases.isEmpty
              ? AppEmptyState(icon: PhosphorIcons.info, message: 'No special cases')
              : ListView.builder(
                  itemCount: _cases.length,
                  itemBuilder: (_, i) {
                    final c = _cases[i];
                    return FutureBuilder<String>(
                      future: _studentName(c.studentId),
                      builder: (_, snap) {
                        final name = snap.data ?? c.studentId;
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          color: ShellTokens.chromeSurface,
                          child: ListTile(
                            enabled: c.isActive,
                            leading: Icon(c.isActive
                                ? PhosphorIcons.checkCircle
                                : PhosphorIcons.archive, size: 20,
                              color: c.isActive ? SemanticTokens.success : ShellTokens.textDisabled),
                            title: Text('$name${c.isActive ? '' : ' (revoked)'}',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: ShellTokens.textPrimary, fontSize: 13)),
                            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${_caseSummary(c)} — ${c.reason}',
                                style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                              if (c.reviewDate != null)
                                Text('Review: ${c.reviewDate!.toString().substring(0, 10)}',
                                  style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
                            ]),
                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 14, color: ShellTokens.textSecondary),
                                onPressed: () => _openEdit(c), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                              if (c.isActive)
                                IconButton(icon: const Icon(PhosphorIcons.archive, size: 14, color: SemanticTokens.error),
                                  onPressed: () => _revoke(c), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                            ]),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

class _SpecialCaseEditDialog extends StatefulWidget {
  final AppDatabase database;
  final String currentUserId;
  final SpecialCase? specialCase;
  const _SpecialCaseEditDialog({required this.database, required this.currentUserId, this.specialCase});
  @override
  State<_SpecialCaseEditDialog> createState() => _SpecialCaseEditDialogState();
}

class _SpecialCaseEditDialogState extends State<_SpecialCaseEditDialog> {
  String? _selectedStudentId;
  String _caseType = 'full';
  String _discountType = 'percentage';
  final _discountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  DateTime? _reviewDate;
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  List<String> _scheduleLines = [];
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  static const _dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    _reasonCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredStudents = _students;
        return;
      }
      _filteredStudents = _students.where((s) {
        return s.firstNameAr.toLowerCase().contains(q) ||
               s.lastNameAr.toLowerCase().contains(q) ||
               (s.firstNameFr?.toLowerCase().contains(q) ?? false) ||
               (s.lastNameFr?.toLowerCase().contains(q) ?? false) ||
               s.code.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _selectStudent(Student s) {
    setState(() => _selectedStudentId = s.id);
    _loadSchedule(s.id);
  }

  Future<void> _loadSchedule(String studentId) async {
    final schedule = await widget.database.getStudentSessionSchedule(studentId);
    if (!mounted) return;
    final lines = <String>[];
    for (final s in schedule) {
      final dow = _dayNames.length > (s['day_of_week'] as int) ? _dayNames[s['day_of_week'] as int] : 'Day ${s['day_of_week']}';
      final st = s['start_time'] as DateTime;
      final et = s['end_time'] as DateTime;
      lines.add('${s['group_name']} — $dow ${st.hour}:${st.minute.toString().padLeft(2, '0')}–${et.hour}:${et.minute.toString().padLeft(2, '0')}');
    }
    setState(() => _scheduleLines = lines.isEmpty ? ['No enrolled sessions'] : lines);
  }

  Future<void> _load() async {
    try {
      final list = await widget.database.select(widget.database.students).get();
      final c = widget.specialCase;
      if (c != null) {
        _selectedStudentId = c.studentId;
        _caseType = c.caseType;
        if (c.discountPercent != null) {
          _discountCtrl.text = c.discountPercent!.toStringAsFixed(0);
          _discountType = 'percentage';
        } else if (c.discountFixed != null) {
          _discountCtrl.text = c.discountFixed!.toStringAsFixed(0);
          _discountType = 'fixed';
        }
        _reasonCtrl.text = c.reason;
        _reviewDate = c.reviewDate;
      }
      if (mounted) {
        setState(() { _students = list; _filteredStudents = list; _loading = false; _loadError = null; });
        if (_selectedStudentId != null) _loadSchedule(_selectedStudentId!);
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _loadError = 'Failed to load students: $e'; });
    }
  }

  Future<void> _pickReviewDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _reviewDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _reviewDate = picked);
  }

  Future<void> _save() async {
    final studentId = _selectedStudentId;
    if (studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a student')));
      return;
    }
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reason is required')));
      return;
    }
    setState(() => _saving = true);
    try {
      final double? percent = _caseType == 'partial' && _discountType == 'percentage'
          ? double.tryParse(_discountCtrl.text)
          : null;
      final double? fixed = _caseType == 'partial' && _discountType == 'fixed'
          ? double.tryParse(_discountCtrl.text)
          : null;

      await widget.database.transaction(() async {
        if (widget.specialCase != null) {
            await (widget.database.update(widget.database.specialCases)..where((t) => t.id.equals(widget.specialCase!.id)))
              .write(SpecialCasesCompanion(
                studentId: Value(studentId),
                caseType: Value(_caseType),
                discountPercent: Value(percent),
                discountFixed: Value(fixed),
                reason: Value(_reasonCtrl.text.trim()),
                approvedByUserId: Value(widget.currentUserId),
                reviewDate: Value(_reviewDate),
              ));
          } else {
            final id = 'sc_${DateTime.now().millisecondsSinceEpoch}';
            await widget.database.into(widget.database.specialCases).insert(SpecialCasesCompanion(
              id: Value(id),
              studentId: Value(studentId),
              caseType: Value(_caseType),
              discountPercent: Value(percent),
              discountFixed: Value(fixed),
              reason: Value(_reasonCtrl.text.trim()),
              approvedByUserId: Value(widget.currentUserId),
              reviewDate: Value(_reviewDate),
              deviceId: Value(await DeviceId.get()),
            ));
            await widget.database.into(widget.database.auditLog).insert(AuditLogCompanion(
              userId: Value(widget.currentUserId),
              action: const Value('special_case_created_updated'),
              entityType: const Value('special_case'),
              entityId: Value(id),
              details: Value('Student: $studentId, Case: $_caseType, Reason: ${_reasonCtrl.text.trim()}'),
            ));
          }
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.specialCase != null;
    return ShellDialog(
      maxWidth: 500, maxHeight: 650, title: isEdit ? 'Edit Special Case' : 'Create Special Case',
      body: _loadError != null
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(PhosphorIcons.warning, size: 28, color: SemanticTokens.warning),
              const SizedBox(height: 8),
              Text(_loadError!, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 12)),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ]))
          : _loading
              ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
              : ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 34,
                      child: TextField(
                        controller: _searchCtrl,
                        style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search by name or code...',
                          hintStyle: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled),
                          prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 14, color: ShellTokens.textSecondary),
                          filled: true,
                          fillColor: ShellTokens.chromeBase,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
                          isDense: true,
                        ),
                        onChanged: _filter,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${_filteredStudents.length} of ${_students.length} students',
                      style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 150,
                      child: _filteredStudents.isEmpty
                          ? const Center(child: Text('No students match', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled)))
                          : ListView.builder(
                              itemCount: _filteredStudents.length,
                              itemBuilder: (_, i) {
                                final s = _filteredStudents[i];
                                final selected = s.id == _selectedStudentId;
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: ShellTokens.accentMuted,
                                    child: Text(s.firstNameAr.isNotEmpty ? s.firstNameAr[0] : '?',
                                      style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                  title: Text('${s.firstNameAr} ${s.lastNameAr}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ShellTokens.textPrimary)),
                                  subtitle: Text(s.code, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
                                  trailing: selected ? const Icon(PhosphorIcons.checkCircle, size: 14, color: ShellTokens.accent) : null,
                                  selected: selected,
                                  onTap: () => _selectStudent(s),
                                );
                              },
                            ),
                    ),
                    if (_selectedStudentId != null) ...[
                      const SizedBox(height: 10),
                      const ShellSectionHeader(text: 'Student Schedule', withBorder: false),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ShellTokens.chromeBase,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ShellTokens.chromeBorder),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          for (final i in _scheduleLines.asMap().entries) ...[
                            Text(_scheduleLines[i.key], style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
                            if (i.key < _scheduleLines.length - 1) const SizedBox(height: 3),
                          ],
                        ]),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'full', label: Text('Full', style: TextStyle(fontSize: 11))),
                            ButtonSegment(value: 'partial', label: Text('Partial', style: TextStyle(fontSize: 11))),
                          ],
                          selected: {_caseType},
                          onSelectionChanged: (s) => setState(() => _caseType = s.first),
                          style: SegmentedButton.styleFrom(selectedBackgroundColor: ShellTokens.accent.withValues(alpha: 0.15)),
                        ),
                      ),
                    ]),
                    if (_caseType == 'partial') ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: TextField(
                          controller: _discountCtrl, keyboardType: TextInputType.number,
                          decoration: ShellInputDecoration.textField(hintText: _discountType == 'percentage' ? 'Discount %' : 'Fixed DA'),
                          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                        )),
                        const SizedBox(width: 8),
                        DropdownButtonFormField<String>(
                          value: _discountType,
                          decoration: ShellInputDecoration.dropdown(),
                          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                          items: const [
                            DropdownMenuItem(value: 'percentage', child: Text('%', style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 'fixed', child: Text('DA', style: TextStyle(fontSize: 12))),
                          ],
                          onChanged: (v) => setState(() => _discountType = v!),
                        ),
                      ]),
                    ],
                    const SizedBox(height: 14),
                    const ShellSectionHeader(text: 'Exemption Details', withBorder: false),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reasonCtrl,
                      maxLines: 3,
                      decoration: ShellInputDecoration.textField(hintText: 'Reason (required)'),
                      style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: TextButton.icon(
                        onPressed: _pickReviewDate,
                        icon: const Icon(PhosphorIcons.calendar, size: 16, color: ShellTokens.textSecondary),
                        label: Text(_reviewDate == null
                            ? 'Set review date (optional)'
                            : 'Review: ${_reviewDate.toString().substring(0, 10)}',
                          style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                      )),
                      if (_reviewDate != null)
                        IconButton(
                          icon: const Icon(PhosphorIcons.x, size: 16, color: ShellTokens.textDisabled),
                          onPressed: () => setState(() => _reviewDate = null),
                        ),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: _saving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase))
                          : Text(isEdit ? 'Save Case' : 'Create Case', style: TextStyle(fontSize: 13, color: ShellTokens.chromeBase, fontWeight: FontWeight.w600)),
                    )),
                  ],
                ),
    );
  }
}