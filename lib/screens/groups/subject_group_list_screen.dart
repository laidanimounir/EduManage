import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_pagination_bar.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class SubjectGroupListScreen extends StatefulWidget {
  final AppDatabase database;
  const SubjectGroupListScreen({super.key, required this.database});
  @override
  State<SubjectGroupListScreen> createState() => _SubjectGroupListScreenState();
}

class _SubjectGroupListScreenState extends State<SubjectGroupListScreen> {
  late final SubjectGroupRepository _repo;
  List<SubjectGroup> _rows = [];
  int _total = 0;
  int _page = 0;
  int _pageSize = 20;
  bool _loading = true;
  String _statusFilter = 'all';
  Set<String> _selectedIds = {};
  Map<String, int> _sessionCounts = {};
  Map<String, int> _enrollmentCounts = {};
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _repo = SubjectGroupRepository(widget.database); _fetchPage(); }
  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    final all = await _repo.getAll();
    _rows = all;
    _total = all.length;
    _sessionCounts.clear();
    _enrollmentCounts.clear();
    if (mounted) setState(() => _loading = false);
    _preloadCounts();
  }

  Future<void> _preloadCounts() async {
    for (final g in _rows) {
      final sessions = await _repo.getSessions(g.id);
      final enrollments = await _repo.getStudents(g.id);
      _sessionCounts[g.id] = sessions.where((s) => s.isActive && !s.isArchived).length;
      _enrollmentCounts[g.id] = enrollments.where((e) => e.status == 'active').length;
    }
    if (mounted) setState(() {});
  }

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == _rows.length) { _selectedIds.clear(); } else { _selectedIds = _rows.map((g) => g.id).toSet(); } });
  }

  void _openEdit(SubjectGroup? g) async {
    final result = await showDialog<bool>(context: context, builder: (_) => _GroupEditDialog(database: widget.database, group: g, l10n: AppLocalizations.of(context)));
    if (result == true) _fetchPage();
  }

  void _openDetail(SubjectGroup g) {
    showDialog(context: context, builder: (_) => _GroupDetailDialog(database: widget.database, group: g, l10n: AppLocalizations.of(context)));
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
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 8, bottom: 8),
      decoration: const BoxDecoration(color: ShellTokens.accentMuted, border: Border(bottom: BorderSide(color: ShellTokens.accent))),
      child: Row(children: [
        Text('${_selectedIds.length} ${l10n.selected}', style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        const Spacer(),
        TextButton.icon(onPressed: _toggleSelectAll, icon: Icon(_selectedIds.length == _rows.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16), label: Text(_selectedIds.length == _rows.length ? l10n.clearSelection : l10n.selectAll), style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary)),
      ]),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(children: [
        Expanded(child: SizedBox(height: 34, child: TextField(
          controller: _searchCtrl, style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
          decoration: ShellInputDecoration.textField(hintText: l10n.search, prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary), fillColor: ShellTokens.chromeSurface),
        ))),
        const SizedBox(width: 8),
        SizedBox(height: 34, child: FilledButton.icon(onPressed: () => _openEdit(null), icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.add, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
      ]),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    return Column(children: [
      Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)), children: [_buildHeaderRow(l10n)]),
      Expanded(child: SingleChildScrollView(child: Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)), children: _rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)).toList()))),
    ]);
  }

  Map<int, TableColumnWidth> _columnWidths() => const {
    0: FixedColumnWidth(44),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(1.2),
    4: FlexColumnWidth(1),
    5: FlexColumnWidth(1),
    6: IntrinsicColumnWidth(),
  };

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
      _buildHeaderCell(PhosphorIcons.checkSquare, null),
      _buildHeaderCell(null, l10n.name),
      _buildHeaderCell(null, l10n.subject),
      _buildHeaderCell(null, l10n.schoolLevel),
      _buildHeaderCell(null, l10n.sessions),
      _buildHeaderCell(null, l10n.enrollments),
      _buildHeaderCell(PhosphorIcons.gear, null),
    ]);
  }

  Widget _buildHeaderCell(IconData? icon, String? label) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary))
      else Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
    ]));
  }

  TableRow _buildDataRow(SubjectGroup g, int index, AppLocalizations l10n) {
    final isSelected = _selectedIds.contains(g.id);
    final isEven = index.isEven;
    return TableRow(decoration: BoxDecoration(color: isSelected ? ShellTokens.accentMuted.withValues(alpha: 0.3) : isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      _buildCheckCell(g, isSelected),
      GestureDetector(onTap: () => _openDetail(g), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(g.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), if (g.nameFr != null && g.nameFr!.isNotEmpty) Text(g.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))]))),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _buildTextCell('${g.subjectAr}${g.subjectFr != null && g.subjectFr!.isNotEmpty ? ' / ${g.subjectFr}' : ''}')),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _buildTextCell(_levelLabel(g.schoolLevel, l10n))),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _buildTextCell('${_sessionCounts[g.id] ?? 0}')),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _buildTextCell('${_enrollmentCounts[g.id] ?? 0}')),
      _buildActionsCell(g),
    ]);
  }

  Widget _buildCheckCell(SubjectGroup g, bool isSelected) {
    return GestureDetector(onTap: () => setState(() { if (isSelected) { _selectedIds.remove(g.id); } else { _selectedIds.add(g.id); } }), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: isSelected ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: isSelected ? ShellTokens.accent : Colors.transparent), child: isSelected ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null)));
  }

  Widget _buildTextCell(String text) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text(text, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis));

  Widget _buildActionsCell(SubjectGroup g) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(g), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
    ]);
  }

  String _levelLabel(String level, AppLocalizations l10n) {
    return switch (level) { 'primary' => l10n.schoolLevelPrimary, 'middle' => l10n.schoolLevelMiddle, 'secondary' => l10n.schoolLevelSecondary, _ => level };
  }
}

class _GroupDetailDialog extends StatelessWidget {
  final AppDatabase database;
  final SubjectGroup group;
  final AppLocalizations l10n;
  const _GroupDetailDialog({required this.database, required this.group, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 520, title: group.nameAr,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: l10n.personalInfo),
        const SizedBox(height: 8),
        _infoRow(l10n.name, '${group.nameAr} / ${group.nameFr ?? '—'}'),
        _infoRow(l10n.subject, '${group.subjectAr} / ${group.subjectFr ?? '—'}'),
        _infoRow(l10n.schoolLevel, _levelLabel(group.schoolLevel, l10n)),
        if (group.description != null && group.description!.isNotEmpty) _infoRow(l10n.description, group.description!),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.sessions),
        const SizedBox(height: 8),
        _SessionList(database: database, groupId: group.id, l10n: l10n),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.enrollments),
        const SizedBox(height: 8),
        _EnrollmentCountWidget(database: database, groupId: group.id, l10n: l10n),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))), Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)))]));
  }

  String _levelLabel(String level, AppLocalizations l10n) {
    return switch (level) { 'primary' => l10n.schoolLevelPrimary, 'middle' => l10n.schoolLevelMiddle, 'secondary' => l10n.schoolLevelSecondary, _ => level };
  }
}

class _SessionList extends StatefulWidget {
  final AppDatabase database; final String groupId; final AppLocalizations l10n;
  const _SessionList({required this.database, required this.groupId, required this.l10n});
  @override
  State<_SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<_SessionList> {
  List<Session> _sessions = []; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { _sessions = await SubjectGroupRepository(widget.database).getSessions(widget.groupId); if (mounted) setState(() => _loading = false); }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_sessions.isEmpty) return Text(widget.l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    final days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(children: _sessions.where((s) => s.isActive && !s.isArchived).map((s) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text('${days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
    ]))).toList());
  }
}

class _EnrollmentCountWidget extends StatefulWidget {
  final AppDatabase database; final String groupId; final AppLocalizations l10n;
  const _EnrollmentCountWidget({required this.database, required this.groupId, required this.l10n});
  @override
  State<_EnrollmentCountWidget> createState() => _EnrollmentCountWidgetState();
}

class _EnrollmentCountWidgetState extends State<_EnrollmentCountWidget> {
  int _count = 0; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async { final e = await SubjectGroupRepository(widget.database).getStudents(widget.groupId); if (mounted) setState(() { _count = e.where((x) => x.status == 'active').length; _loading = false; }); }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    return Text('${widget.l10n.enrolledStudents}: $_count', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary));
  }
}

class _GroupEditDialog extends StatefulWidget {
  final AppDatabase database; final SubjectGroup? group; final AppLocalizations l10n;
  const _GroupEditDialog({required this.database, this.group, required this.l10n});
  @override
  State<_GroupEditDialog> createState() => _GroupEditDialogState();
}

class _GroupEditDialogState extends State<_GroupEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final SubjectGroupRepository _repo;
  bool _saving = false; bool _isEdit = false;
  late TextEditingController _nameArCtrl, _nameFrCtrl, _subjectArCtrl, _subjectFrCtrl, _descCtrl;
  String _schoolLevel = 'primary';

  @override
  void initState() {
    super.initState(); _repo = SubjectGroupRepository(widget.database); _isEdit = widget.group != null;
    final g = widget.group;
    _nameArCtrl = TextEditingController(text: g?.nameAr ?? ''); _nameFrCtrl = TextEditingController(text: g?.nameFr ?? '');
    _subjectArCtrl = TextEditingController(text: g?.subjectAr ?? ''); _subjectFrCtrl = TextEditingController(text: g?.subjectFr ?? '');
    _descCtrl = TextEditingController(text: g?.description ?? '');
    if (g != null) _schoolLevel = g.schoolLevel;
  }

  @override
  void dispose() { _nameArCtrl.dispose(); _nameFrCtrl.dispose(); _subjectArCtrl.dispose(); _subjectFrCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final entry = SubjectGroupsCompanion(nameAr: Value(_nameArCtrl.text.trim()), nameFr: Value(_nameFrCtrl.text.trim().isEmpty ? null : _nameFrCtrl.text.trim()), subjectAr: Value(_subjectArCtrl.text.trim()), subjectFr: Value(_subjectFrCtrl.text.trim().isEmpty ? null : _subjectFrCtrl.text.trim()), schoolLevel: Value(_schoolLevel), description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()));
      if (_isEdit) { await _repo.update(widget.group!.id, entry); } else { await _repo.create(entry); }
      if (mounted) Navigator.pop(context, true);
    } catch (_) { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShellDialog(
      maxWidth: 520, title: _isEdit ? l10n.edit : l10n.add,
      body: Form(key: _formKey, child: Column(children: [
        _tf(_nameArCtrl, required: true, hint: '${l10n.name} AR'),
        const SizedBox(height: 8),
        _tf(_nameFrCtrl, hint: '${l10n.name} FR'),
        const SizedBox(height: 8),
        _tf(_subjectArCtrl, required: true, hint: '${l10n.subject} AR'),
        const SizedBox(height: 8),
        _tf(_subjectFrCtrl, hint: '${l10n.subject} FR'),
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.schoolLevel),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(value: _schoolLevel, items: ['primary', 'middle', 'secondary'].map((v) => DropdownMenuItem(value: v, child: Text(_lev(v, l10n), style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => _schoolLevel = v!), decoration: ShellInputDecoration.dropdown()),
        const SizedBox(height: 14),
        _tf(_descCtrl, maxLines: 2, hint: l10n.description),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: _saving ? null : _save, style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create))),
      ])),
    );
  }

  Widget _tf(TextEditingController ctrl, {bool required = false, int maxLines = 1, String? hint}) {
    return TextFormField(controller: ctrl, maxLines: maxLines, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField(hintText: hint), validator: required ? (v) => (v == null || v.trim().isEmpty) ? widget.l10n.fieldRequired : null : null);
  }

  String _lev(String v, AppLocalizations l10n) => switch (v) { 'primary' => l10n.schoolLevelPrimary, 'middle' => l10n.schoolLevelMiddle, 'secondary' => l10n.schoolLevelSecondary, _ => v };
}
