import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/subject_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';
import '../groups/subject_group_list_screen.dart' show GroupEditDialog;

class SubjectListScreen extends StatefulWidget {
  final AppDatabase database;
  const SubjectListScreen({super.key, required this.database});
  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  late final SubjectRepository _repo;
  late final SubjectGroupRepository _groupRepo;
  List<Subject> _rows = [];
  List<SubjectGroup> _allGroups = [];
  bool _loading = true;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _repo = SubjectRepository(widget.database);
    _groupRepo = SubjectGroupRepository(widget.database);
    _fetchPage();
  }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    final subjects = await _repo.getAll();
    final groups = await _groupRepo.getAll();
    if (mounted) setState(() { _rows = subjects; _allGroups = groups; _loading = false; });
  }

  List<Subject> get filtered => _rows.where((s) {
    if (_statusFilter == 'archived') return s.isArchived;
    if (_statusFilter == 'active') return !s.isArchived;
    return true;
  }).toList();

  int _activeGroupCount(Subject s) => _allGroups.where((g) => g.subjectId == s.id && !g.isArchived).length;

  Future<void> _openEdit(Subject? s) async {
    final result = await showDialog<bool>(context: context, builder: (_) => _SubjectEditDialog(database: widget.database, subject: s, l10n: AppLocalizations.of(context)));
    if (result == true) _fetchPage();
  }

  void _openDetail(Subject s) {
    showDialog(context: context, builder: (_) => _SubjectDetailDialog(database: widget.database, subject: s, groupRepo: _groupRepo, l10n: AppLocalizations.of(context))).then((_) { try { _fetchPage(); } catch (_) {} });
  }

  Future<void> _confirmArchive(Subject s) async {
    final l10n = AppLocalizations.of(context);
    final activeCount = _activeGroupCount(s);
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: Text(s.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: ShellTokens.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.isArchived ? l10n.restore : 'Archive this subject?', style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
        if (activeCount > 0 && !s.isArchived) ...[
          const SizedBox(height: 8),
          Row(children: [const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning), const SizedBox(width: 8), Expanded(child: Text('This subject still has $activeCount active group(s).', style: const TextStyle(color: SemanticTokens.warning, fontSize: 12)))]),
        ],
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: SemanticTokens.error)))],
    ));
    if (confirmed == true) { if (s.isArchived) { await _repo.restore(s.id); } else { await _repo.archive(s.id); } _fetchPage(); }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = filtered;
    return Scaffold(backgroundColor: ContentTokens.background, body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), child: Row(children: [
        Expanded(child: Row(children: [
          ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () { _statusFilter = 'all'; setState(() {}); }),
          ShellFilterChip(label: l10n.active, selected: _statusFilter == 'active', onTap: () { _statusFilter = 'active'; setState(() {}); }),
          ShellFilterChip(label: l10n.archived, selected: _statusFilter == 'archived', onTap: () { _statusFilter = 'archived'; setState(() {}); }),
        ])),
        SizedBox(height: 34, child: FilledButton.icon(onPressed: () => _openEdit(null), icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.add, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
      ])),
      Expanded(child: _buildBody(l10n, rows)),
    ]));
  }

  Widget _buildBody(AppLocalizations l10n, List<Subject> rows) {
    if (_loading) return const AppLoading();
    const widths = {0: FixedColumnWidth(44), 1: FlexColumnWidth(3), 2: FlexColumnWidth(1.2), 3: IntrinsicColumnWidth()};
    return Column(children: [
      Table(columnWidths: widths, defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)), children: [TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Icon(PhosphorIcons.checkSquare, size: 14, color: ShellTokens.textSecondary)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Text(l10n.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Text(l10n.groups, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Icon(PhosphorIcons.gear, size: 14, color: ShellTokens.textSecondary)),
      ])]),
      Expanded(child: SingleChildScrollView(child: Table(columnWidths: widths, defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)), children: rows.asMap().entries.map((e) => _dataRow(e.value, e.key)).toList()))),
    ]);
  }

  TableRow _dataRow(Subject s, int index) {
    final even = index.isEven;
    return TableRow(decoration: BoxDecoration(color: s.isArchived ? ShellTokens.chromeBase.withValues(alpha: 0.5) : even ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: ShellTokens.textDisabled, width: 1.5), color: Colors.transparent))),
      GestureDetector(onTap: () => _openDetail(s), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(s.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), if (s.nameFr != null && s.nameFr!.isNotEmpty) Text(s.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))]))),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text('${_activeGroupCount(s)}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)))),
      Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(s), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
        IconButton(icon: Icon(s.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 13), onPressed: () => _confirmArchive(s), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: s.isArchived ? ShellTokens.accent : ShellTokens.textSecondary),
      ]),
    ]);
  }
}

class _SubjectEditDialog extends StatefulWidget {
  final AppDatabase database; final Subject? subject; final AppLocalizations l10n;
  const _SubjectEditDialog({required this.database, this.subject, required this.l10n});
  @override
  State<_SubjectEditDialog> createState() => _SubjectEditDialogState();
}
class _SubjectEditDialogState extends State<_SubjectEditDialog> {
  late final GlobalKey<FormState> _formKey;
  late final SubjectRepository _repo; bool _saving = false; bool get _isEdit => widget.subject != null;
  late TextEditingController _arCtrl, _frCtrl;
  @override
  void initState() {
    super.initState(); _formKey = GlobalKey<FormState>(); _repo = SubjectRepository(widget.database);
    _arCtrl = TextEditingController(text: widget.subject?.nameAr ?? ''); _frCtrl = TextEditingController(text: widget.subject?.nameFr ?? '');
  }
  @override
  void dispose() { _arCtrl.dispose(); _frCtrl.dispose(); super.dispose(); }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return; setState(() => _saving = true);
    try {
      final ar = _arCtrl.text.trim(); final fr = _frCtrl.text.trim();
      if (_isEdit) {
        await _repo.update(widget.subject!.id, SubjectsCompanion(nameAr: Value(ar), nameFr: Value(fr.isEmpty ? null : fr)));
      } else {
        await _repo.create(nameAr: ar, nameFr: fr.isEmpty ? null : fr);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) { if (mounted) setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShellDialog(maxWidth: 440, title: _isEdit ? l10n.edit : l10n.add, body: Form(key: _formKey, child: Column(children: [
      TextFormField(controller: _arCtrl, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField(hintText: '${l10n.name} AR'), validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null),
      const SizedBox(height: 8),
      TextFormField(controller: _frCtrl, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField(hintText: '${l10n.name} FR')),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: _saving ? null : _save, style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create))),
    ])));
  }
}

class _SubjectDetailDialog extends StatefulWidget {
  final AppDatabase database; final Subject subject; final SubjectGroupRepository groupRepo; final AppLocalizations l10n;
  const _SubjectDetailDialog({required this.database, required this.subject, required this.groupRepo, required this.l10n});
  @override
  State<_SubjectDetailDialog> createState() => _SubjectDetailDialogState();
}
class _SubjectDetailDialogState extends State<_SubjectDetailDialog> {
  late final SubjectGroupRepository _groupRepo;
  List<SubjectGroup> _groups = []; Map<String, int> _sessionCounts = {}; bool _loading = true;
  @override
  void initState() { super.initState(); _groupRepo = SubjectGroupRepository(widget.database); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await widget.groupRepo.getAll();
    final mine = all.where((g) => g.subjectId == widget.subject.id).where((g) => g.isArchived == false).toList();
    final counts = <String, int>{};
    for (final g in mine) {
      final sessions = await _groupRepo.getSessions(g.id);
      counts[g.id] = sessions.where((s) => s.isActive && !s.isArchived).length;
    }
    if (mounted) setState(() { _groups = mine; _sessionCounts = counts; _loading = false; });
  }
  Future<void> _addGroup() async {
    final result = await showDialog<bool>(context: context, builder: (_) => GroupEditDialog(database: widget.database, group: null, l10n: widget.l10n, lockedSubject: widget.subject));
    if (result == true) _load();
  }
  String _lev(String l) => switch (l) { 'primary' => widget.l10n.schoolLevelPrimary, 'middle' => widget.l10n.schoolLevelMiddle, 'secondary' => widget.l10n.schoolLevelSecondary, _ => l };
  @override
  Widget build(BuildContext context) {
    final s = widget.subject; final l10n = widget.l10n;
    return ShellDialog(maxWidth: 520, title: s.nameAr, body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text('${s.nameAr} / ${s.nameFr ?? '—'}', style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary))),
        if (s.isArchived) ShellBadge(label: 'Archived', color: ShellTokens.textDisabled),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: ShellSectionHeader(text: l10n.groups)),
        SizedBox(height: 30, child: FilledButton.icon(onPressed: _addGroup, icon: const Icon(PhosphorIcons.plus, size: 13), label: const Text('+ إضافة قسم جديد لهذه المادة', style: TextStyle(fontSize: 10)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 10)))),
      ]),
      const SizedBox(height: 8),
      if (_loading) const SizedBox(height: 40, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))))
      else if (_groups.isEmpty) Text(l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))
      else Column(children: _groups.map((g) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(g.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), if (g.nameFr != null && g.nameFr!.isNotEmpty) Text(g.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))])),
        const SizedBox(width: 12),
        Text(_lev(g.schoolLevel), style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
        const SizedBox(width: 12),
        Text('${_sessionCounts[g.id] ?? 0} ${l10n.sessions}', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
      ]))).toList()),
      const SizedBox(height: 16),
    ]));
  }
}