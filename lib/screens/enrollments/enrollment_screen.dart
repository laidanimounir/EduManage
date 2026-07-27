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
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class EnrollmentScreen extends StatefulWidget {
  final AppDatabase database;
  const EnrollmentScreen({super.key, required this.database});
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
  Set<String> _selectedIds = {};
  Map<String, String> _studentNames = {};
  Map<String, String> _groupNames = {};

  @override
  void initState() { super.initState(); _enrollRepo = EnrollmentRepository(widget.database); _studentRepo = StudentRepository(widget.database); _groupRepo = SubjectGroupRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _enrollments = await _enrollRepo.getAll(); _students = await _studentRepo.getAll(); _groups = await _groupRepo.getAll(); _studentNames.clear(); _groupNames.clear(); for (final s in _students) { _studentNames[s.id] = '${s.firstNameAr} ${s.lastNameAr}'; } for (final g in _groups) { _groupNames[g.id] = g.nameAr; } _selectedIds.clear(); if (mounted) setState(() => _loading = false); }

  List<Enrollment> get filtered => _enrollments.where((e) => _statusFilter == 'all' || e.status == _statusFilter).toList();

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == filtered.length) { _selectedIds.clear(); } else { _selectedIds = filtered.map((e) => e.id).toSet(); } });
  }

  Future<void> _bulkSetStatus(String status) async {
    for (final id in _selectedIds.toList()) { await _enrollRepo.updateStatus(id, status); }
    _load();
  }

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
            if (ok == true) { await groupRepo.update(groupId!, SubjectGroupsCompanion(capacity: Value(int.tryParse(newCapCtrl.text)))); await _enrollRepo.create(EnrollmentsCompanion(studentId: Value(studentId!), subjectGroupId: Value(groupId!))); _load(); }
          } else if (action == 'waitlist') {
            await _enrollRepo.addToWaitlist(studentId!, groupId!); _load();
          }
        }
      } else {
        await _enrollRepo.create(EnrollmentsCompanion(studentId: Value(studentId!), subjectGroupId: Value(groupId!)));
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
            if (ok == true) { await groupRepo.update(toGroupId!, SubjectGroupsCompanion(capacity: Value(int.tryParse(newCapCtrl.text)))); await _enrollRepo.transferEnrollment(studentId: e.studentId, fromGroupId: e.subjectGroupId, toGroupId: toGroupId!); _load(); }
          }
        }
      } else {
        await _enrollRepo.transferEnrollment(studentId: e.studentId, fromGroupId: e.subjectGroupId, toGroupId: toGroupId!);
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
      TextButton.icon(onPressed: _toggleSelectAll, icon: Icon(_selectedIds.length == filtered.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16), label: Text(_selectedIds.length == filtered.length ? l10n.clearSelection : l10n.selectAll), style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary)),
    ]));
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    return Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), child: Row(children: [
      Expanded(child: Row(children: [
        ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () { _statusFilter = 'all'; setState(() {}); }),
        ShellFilterChip(label: l10n.active, selected: _statusFilter == 'active', onTap: () { _statusFilter = 'active'; setState(() {}); }),
        ShellFilterChip(label: l10n.inactive, selected: _statusFilter == 'inactive', onTap: () { _statusFilter = 'inactive'; setState(() {}); }),
      ])),
      SizedBox(height: 34, child: FilledButton.icon(onPressed: _showAddDialog, icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.enrollStudent, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
    ]));
  }

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
