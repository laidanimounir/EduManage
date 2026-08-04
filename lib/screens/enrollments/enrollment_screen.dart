import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/audit_log_repository.dart';
import '../../utils/device_id.dart';
import '../../utils/uuid_helper.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class EnrollmentScreen extends StatefulWidget {
  final AppDatabase database;
  final String currentUserId;
  const EnrollmentScreen({super.key, required this.database, this.currentUserId = ''});
  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  late final EnrollmentRepository _enrollRepo;
  late final StudentRepository _studentRepo;
  late final SubjectGroupRepository _groupRepo;
  List<Enrollment> _enrollments = [];
  List<Student> _students = [];
  List<SubjectGroup> _groups = [];
  bool _loading = true;
  String _statusFilter = 'all';
  String? _levelFilter;
  String? _groupFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  Map<String, String> _studentLevels = {};
  Set<String> _levelOptions = {};
  Set<String> _selectedIds = {};
  Map<String, String> _studentNames = {};
  Map<String, String> _groupNames = {};

  @override
  void initState() { super.initState(); _enrollRepo = EnrollmentRepository(widget.database); _studentRepo = StudentRepository(widget.database); _groupRepo = SubjectGroupRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _enrollments = await _enrollRepo.getAll(); _students = await _studentRepo.getAll(); _groups = await _groupRepo.getAll(); _studentNames.clear(); _groupNames.clear(); for (final s in _students) { _studentNames[s.id] = '${s.firstNameAr} ${s.lastNameAr}'; _studentLevels[s.id] = s.schoolLevel ?? ''; } _levelOptions = _students.map((s) => s.schoolLevel ?? '').where((l) => l.isNotEmpty).toSet(); for (final g in _groups) { _groupNames[g.id] = g.nameAr; } _selectedIds.clear(); if (mounted) setState(() => _loading = false); }

  List<Enrollment> get filtered => _enrollments.where((e) {
    if (_statusFilter != 'all' && e.status != _statusFilter) return false;
    if (_levelFilter != null && _studentLevels[e.studentId] != _levelFilter) return false;
    if (_groupFilter != null && e.subjectGroupId != _groupFilter) return false;
    if (_dateFrom != null && e.enrollmentDate.isBefore(_dateFrom!)) return false;
    if (_dateTo != null && e.enrollmentDate.isAfter(_dateTo!.add(const Duration(days: 1)))) return false;
    return true;
  }).toList();

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == filtered.length) { _selectedIds.clear(); } else { _selectedIds = filtered.map((e) => e.id).toSet(); } });
  }

  Future<void> _bulkSetStatus(String status) async {
    for (final id in _selectedIds.toList()) { await _enrollRepo.updateStatus(id, status); }
    _load();
  }

  Future<void> _showBulkSpecialCaseDialog() async {
    final studentIds = _selectedEnrollmentRows().map((e) => e.studentId).toSet().toList();
    if (studentIds.isEmpty) return;
    final result = await showDialog<_BulkSpecialCaseData>(
      context: context,
      builder: (ctx) => _BulkSpecialCaseDialog(
        studentCount: studentIds.length,
        currentUserId: widget.currentUserId,
      ),
    );
    if (result == null || !mounted) return;

    int created = 0;
    int skipped = 0;
    for (final studentId in studentIds) {
      final active = await widget.database.getActiveSpecialCase(studentId);
      if (active != null) { skipped++; continue; }
      final id = 'sc_bulk_${UuidHelper.generate()}';
      await widget.database.into(widget.database.specialCases).insert(SpecialCasesCompanion(
        id: Value(id),
        studentId: Value(studentId),
        caseType: Value(result.caseType),
        discountPercent: Value(result.discountPercent),
        discountFixed: Value(result.discountFixed),
        reason: Value(result.reason),
        approvedByUserId: Value(widget.currentUserId.isEmpty ? null : widget.currentUserId),
        reviewDate: Value(result.reviewDate),
        deviceId: Value(await DeviceId.get()),
      ));
      if (widget.currentUserId.isNotEmpty) {
        await AuditLogRepository(widget.database).create(AuditLogCompanion(
          userId: Value(widget.currentUserId),
          action: const Value('special_case_created_updated'),
          entityType: const Value('special_case'),
          entityId: Value(id),
          details: Value('Student: $studentId, Case: ${result.caseType}, Reason: ${result.reason}'),
        ));
      }
      created++;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(skipped > 0
            ? '$created special case(s) created, $skipped skipped (already active)'
            : '$created special case(s) created'),
        backgroundColor: ShellTokens.chromeSurface,
      ));
    }
  }

  List<Enrollment> _selectedEnrollmentRows() =>
      _enrollments.where((e) => _selectedIds.contains(e.id)).toList();

  void _showAddDialog() async {
    final l10n = AppLocalizations.of(context);
    String? studentId, groupId;
    final result = await showDialog<String>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => ShellDialog(
      maxWidth: 450, title: l10n.enrollStudent,
      body: Column(children: [
        DropdownButtonFormField<String>(value: studentId, decoration: ShellInputDecoration.dropdown(hintText: l10n.students), items: _students.map((s) => DropdownMenuItem(value: s.id, child: Text('${s.firstNameAr} ${s.lastNameAr} (${s.code})', style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setSt(() => studentId = v)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: groupId, decoration: ShellInputDecoration.dropdown(hintText: l10n.groups), items: _groups.where((g) => !g.isArchived).map((g) => DropdownMenuItem(value: g.id, child: Text(g.nameAr, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setSt(() => groupId = v)),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(ctx, 'enroll'), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: Text(l10n.enrollStudent))),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.pop(ctx, 'waitlist'), style: OutlinedButton.styleFrom(foregroundColor: ShellTokens.accent, side: const BorderSide(color: ShellTokens.accent), padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text('Add to Waitlist', style: TextStyle(fontSize: 12)))),
      ]),
    )));
    if (result != null && studentId != null && groupId != null) {
      if (result == 'waitlist') {
        await _enrollRepo.addToWaitlist(studentId!, groupId!);
        if (!mounted) return;
        _load();
        return;
      }
      final groupRepo = SubjectGroupRepository(widget.database);
      final g = await groupRepo.getById(groupId!);
      final count = await groupRepo.activeEnrollmentCount(groupId!);
      if (g?.capacity != null && count >= g!.capacity!) {
        if (context.mounted) {
          final action = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
            backgroundColor: ShellTokens.chromeSurface,
            title: Text('Group is full ($count/${g.capacity})', style: const TextStyle(color: ShellTokens.textPrimary)),
            content: const Text('Choose an action:', style: TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n.cancel)),
              TextButton(onPressed: () => Navigator.pop(ctx, 'increase'), child: Text('Increase Capacity', style: const TextStyle(color: ShellTokens.accent))),
              TextButton(onPressed: () => Navigator.pop(ctx, 'waitlist'), child: const Text('Add to Waitlist', style: TextStyle(color: ShellTokens.accent))),
            ],
          ));
          if (action == 'increase') {
            final newCapCtrl = TextEditingController(text: '${g.capacity! + 1}');
            final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
              backgroundColor: ShellTokens.chromeSurface, title: Text('Set new capacity', style: const TextStyle(color: ShellTokens.textPrimary)),
              content: TextField(controller: newCapCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField()),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
            ));
            if (ok == true) { await groupRepo.update(groupId!, SubjectGroupsCompanion(capacity: Value(int.tryParse(newCapCtrl.text)))); await _enrollRepo.create(EnrollmentsCompanion(studentId: Value(studentId!), subjectGroupId: Value(groupId!))); if (!mounted) return; _load(); }
          } else if (action == 'waitlist') {
            await _enrollRepo.addToWaitlist(studentId!, groupId!); if (!mounted) return; _load();
          }
        }
      } else {
        await _enrollRepo.create(EnrollmentsCompanion(studentId: Value(studentId!), subjectGroupId: Value(groupId!)));
        if (!mounted) return;
        _load();
      }
    }
  }

  void _showTransferDialog(Enrollment e) async {
    final l10n = AppLocalizations.of(context);
    String? toGroupId;
    final result = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => ShellDialog(
      maxWidth: 450, title: 'Transfer Student',
      body: Column(children: [
        Text('From: ${_groupNames[e.subjectGroupId] ?? e.subjectGroupId}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: toGroupId, decoration: ShellInputDecoration.dropdown(hintText: 'Destination group'), items: _groups.where((g) => !g.isArchived && g.id != e.subjectGroupId).map((g) => DropdownMenuItem(value: g.id, child: Text(g.nameAr, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setSt(() => toGroupId = v)),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(ctx, true), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text('Transfer'))),
      ]),
    )));
    if (result == true && toGroupId != null) {
      final groupRepo = SubjectGroupRepository(widget.database);
      final g = await groupRepo.getById(toGroupId!);
      final count = await groupRepo.activeEnrollmentCount(toGroupId!);
      if (g?.capacity != null && count >= g!.capacity!) {
        if (context.mounted) {
          final action = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
            backgroundColor: ShellTokens.chromeSurface,
            title: Text('Destination group is full ($count/${g.capacity})', style: const TextStyle(color: ShellTokens.textPrimary)),
            content: const Text('Choose action:', style: TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n.cancel)),
              TextButton(onPressed: () => Navigator.pop(ctx, 'increase'), child: Text('Increase Capacity', style: const TextStyle(color: ShellTokens.accent))),
              TextButton(onPressed: () => Navigator.pop(ctx, 'waitlist'), child: const Text('Cancel Transfer', style: TextStyle(color: SemanticTokens.error))),
            ],
          ));
          if (action == 'increase') {
            final newCapCtrl = TextEditingController(text: '${g.capacity! + 1}');
            final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
              backgroundColor: ShellTokens.chromeSurface, title: Text('Set new capacity', style: const TextStyle(color: ShellTokens.textPrimary)),
              content: TextField(controller: newCapCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField()),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
            ));
            if (ok == true) { await groupRepo.update(toGroupId!, SubjectGroupsCompanion(capacity: Value(int.tryParse(newCapCtrl.text)))); await _enrollRepo.transferEnrollment(studentId: e.studentId, fromGroupId: e.subjectGroupId, toGroupId: toGroupId!); if (!mounted) return; _load(); }
          }
        }
      } else {
        await _enrollRepo.transferEnrollment(studentId: e.studentId, fromGroupId: e.subjectGroupId, toGroupId: toGroupId!);
        if (!mounted) return;
        _load();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasSelection = _selectedIds.isNotEmpty;

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(children: [
        if (hasSelection) _buildSelectionBar(l10n),
        _buildToolbar(l10n),
        Expanded(child: _buildBody(l10n)),
      ]),
    );
  }

  Widget _buildSelectionBar(AppLocalizations l10n) {
    return Container(padding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 8, bottom: 8), decoration: const BoxDecoration(color: ShellTokens.accentMuted, border: Border(bottom: BorderSide(color: ShellTokens.accent))), child: Row(children: [
      Text('${_selectedIds.length} ${l10n.selected}', style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      const Spacer(),
      TextButton(onPressed: () => _bulkSetStatus('active'), child: Text(l10n.active, style: const TextStyle(fontSize: 11, color: SemanticTokens.success))),
      TextButton(onPressed: () => _bulkSetStatus('inactive'), child: Text(l10n.dropEnrollment, style: const TextStyle(fontSize: 11, color: SemanticTokens.error))),
      TextButton(onPressed: _selectedIds.isNotEmpty ? _showBulkSpecialCaseDialog : null, child: const Text('Apply Special Case', style: TextStyle(fontSize: 11, color: SemanticTokens.success))),
      TextButton.icon(onPressed: _toggleSelectAll, icon: Icon(_selectedIds.length == filtered.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16), label: Text(_selectedIds.length == filtered.length ? l10n.clearSelection : l10n.selectAll), style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary)),
    ]));
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    final hasAdvanced = _levelFilter != null || _groupFilter != null || _dateFrom != null || _dateTo != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(children: [
        Row(children: [
          Expanded(child: Row(children: [
            ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () { _statusFilter = 'all'; setState(() {}); }),
            ShellFilterChip(label: l10n.active, selected: _statusFilter == 'active', onTap: () { _statusFilter = 'active'; setState(() {}); }),
            ShellFilterChip(label: l10n.inactive, selected: _statusFilter == 'inactive', onTap: () { _statusFilter = 'inactive'; setState(() {}); }),
          ])),
          SizedBox(height: 34, child: FilledButton.icon(onPressed: _showAddDialog, icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.enrollStudent, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _buildLevelFilter(l10n)),
          const SizedBox(width: 6),
          Expanded(child: _buildGroupFilter()),
          const SizedBox(width: 6),
          _buildDateButton(_dateFrom == null ? 'From' : _fmtDate(_dateFrom!), onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: _dateFrom ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2035));
            if (picked != null) setState(() => _dateFrom = picked);
          }),
          const SizedBox(width: 4),
          _buildDateButton(_dateTo == null ? 'To' : _fmtDate(_dateTo!), onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: _dateTo ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2035));
            if (picked != null) setState(() => _dateTo = picked);
          }),
          if (hasAdvanced) TextButton(onPressed: () { setState(() { _levelFilter = null; _groupFilter = null; _dateFrom = null; _dateTo = null; }); }, child: const Text('Clear', style: TextStyle(fontSize: 10, color: ShellTokens.accent))),
        ]),
      ]),
    );
  }

  Widget _buildLevelFilter(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      value: _levelFilter,
      isExpanded: true,
      decoration: ShellInputDecoration.dropdown(hintText: 'Level'),
      style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary),
      items: [
        for (final l in _levelOptions.toList()..sort())
          DropdownMenuItem(value: l, child: Text(_levelLabel(l, l10n), style: const TextStyle(fontSize: 11))),
      ],
      onChanged: (v) => setState(() => _levelFilter = v),
    );
  }

  Widget _buildGroupFilter() {
    return DropdownButtonFormField<String>(
      value: _groupFilter,
      isExpanded: true,
      decoration: _inputDropdown('Group'),
      style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary),
      items: _groups.where((g) => !g.isArchived).map((g) => DropdownMenuItem(value: g.id, child: Text(g.nameAr, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: (v) => setState(() => _groupFilter = v),
    );
  }

  Widget _buildDateButton(String label, {required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(PhosphorIcons.calendar, size: 12, color: ShellTokens.textSecondary),
      label: Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ShellTokens.chromeBorder),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(0, 34),
      ),
    );
  }

  InputDecoration _inputDropdown(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
      );

  String _levelLabel(String level, AppLocalizations l10n) {
    switch (level) {
      case 'primary': return l10n.schoolLevelPrimary;
      case 'middle': return l10n.schoolLevelMiddle;
      case 'secondary': return l10n.schoolLevelSecondary;
      default: return level;
    }
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    final rows = filtered;
    return Column(children: [
      Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)), children: [_buildHeaderRow(l10n)]),
      Expanded(child: SingleChildScrollView(child: Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)), children: rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)).toList()))),
    ]);
  }

  Map<int, TableColumnWidth> _columnWidths() => const {
    0: FixedColumnWidth(44), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1.5), 4: FlexColumnWidth(1), 5: IntrinsicColumnWidth(),
  };

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
      _hdrCell(PhosphorIcons.checkSquare, null), _hdrCell(null, l10n.student), _hdrCell(null, l10n.groups), _hdrCell(null, l10n.date), _hdrCell(null, l10n.status), _hdrCell(PhosphorIcons.gear, null),
    ]);
  }
  Widget _hdrCell(IconData? icon, String? label) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [
    if (icon != null) InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary)) else Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
  ]));

  TableRow _buildDataRow(Enrollment e, int index, AppLocalizations l10n) {
    final isSel = _selectedIds.contains(e.id);
    final even = index.isEven;
    return TableRow(decoration: BoxDecoration(color: isSel ? ShellTokens.accentMuted.withValues(alpha: 0.3) : even ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      _chkCell(e, isSel),
      _txtCell(_studentNames[e.studentId] ?? e.studentId),
      _txtCell(_groupNames[e.subjectGroupId] ?? e.subjectGroupId),
      _txtCell('${e.enrollmentDate.year}-${e.enrollmentDate.month.toString().padLeft(2, '0')}-${e.enrollmentDate.day.toString().padLeft(2, '0')}'),
      Row(children: [e.status == 'active' ? ShellBadge(label: l10n.active, color: SemanticTokens.success) : ShellBadge(label: l10n.inactive, color: const Color(0xFFC2823A))]),
      Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(PhosphorIcons.arrowsLeftRight, size: 12), onPressed: () => _showTransferDialog(e), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary, tooltip: 'Transfer'),
        IconButton(icon: Icon(e.status == 'active' ? PhosphorIcons.x : PhosphorIcons.checkCircle, size: 13), onPressed: () async { await _enrollRepo.updateStatus(e.id, e.status == 'active' ? 'inactive' : 'active'); _load(); }, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: e.status == 'active' ? SemanticTokens.warning : SemanticTokens.success),
      ]),
    ]);
  }

  Widget _chkCell(Enrollment e, bool sel) => GestureDetector(onTap: () => setState(() { if (sel) { _selectedIds.remove(e.id); } else { _selectedIds.add(e.id); } }), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: sel ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: sel ? ShellTokens.accent : Colors.transparent), child: sel ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null)));
  Widget _txtCell(String t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis));
}

class _BulkSpecialCaseData {
  final String caseType;
  final double? discountPercent;
  final double? discountFixed;
  final String reason;
  final DateTime? reviewDate;
  const _BulkSpecialCaseData({
    required this.caseType,
    this.discountPercent,
    this.discountFixed,
    required this.reason,
    this.reviewDate,
  });
}

class _BulkSpecialCaseDialog extends StatefulWidget {
  final int studentCount;
  final String currentUserId;
  const _BulkSpecialCaseDialog({required this.studentCount, this.currentUserId = ''});
  @override
  State<_BulkSpecialCaseDialog> createState() => _BulkSpecialCaseDialogState();
}

class _BulkSpecialCaseDialogState extends State<_BulkSpecialCaseDialog> {
  String _caseType = 'full';
  final _discountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  DateTime? _reviewDate;
  String _discountMode = 'percentage';

  @override
  void dispose() {
    _discountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
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

  void _submit() {
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reason is required')));
      return;
    }
    final double? percent = _caseType == 'partial' && _discountMode == 'percentage'
        ? double.tryParse(_discountCtrl.text)
        : null;
    final double? fixed = _caseType == 'partial' && _discountMode == 'fixed'
        ? double.tryParse(_discountCtrl.text)
        : null;
    Navigator.pop(context, _BulkSpecialCaseData(
      caseType: _caseType,
      discountPercent: percent,
      discountFixed: fixed,
      reason: _reasonCtrl.text.trim(),
      reviewDate: _reviewDate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 500, maxHeight: 520, title: 'Apply Special Case to ${widget.studentCount}',
      body: ListView(shrinkWrap: true, children: [
        Text('This will create one special case record per selected student. Students with an active case are skipped.',
            style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'full', label: Text('Full', style: TextStyle(fontSize: 11))),
              ButtonSegment(value: 'partial', label: Text('Partial', style: TextStyle(fontSize: 11))),
            ],
            selected: {_caseType},
            onSelectionChanged: (s) => setState(() => _caseType = s.first),
            style: SegmentedButton.styleFrom(selectedBackgroundColor: ShellTokens.accent.withValues(alpha: 0.15)),
          )),
        ]),
        if (_caseType == 'partial') ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(
              controller: _discountCtrl, keyboardType: TextInputType.number,
              decoration: ShellInputDecoration.textField(hintText: _discountMode == 'percentage' ? 'Discount %' : 'Fixed DA'),
              style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
            )),
            const SizedBox(width: 8),
            DropdownButtonFormField<String>(
              value: _discountMode,
              decoration: ShellInputDecoration.dropdown(),
              style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
              items: const [
                DropdownMenuItem(value: 'percentage', child: Text('%', style: TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'fixed', child: Text('DA', style: TextStyle(fontSize: 12))),
              ],
              onChanged: (v) => setState(() => _discountMode = v!),
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
            IconButton(icon: const Icon(PhosphorIcons.x, size: 16, color: ShellTokens.textDisabled),
              onPressed: () => setState(() => _reviewDate = null)),
        ]),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: Text('Apply to ${widget.studentCount} student(s)', style: const TextStyle(fontSize: 13, color: ShellTokens.chromeBase, fontWeight: FontWeight.w600)),
        )),
      ]),
    );
  }
}
