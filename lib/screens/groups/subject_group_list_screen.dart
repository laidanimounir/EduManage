import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/student_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
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
  late final EnrollmentRepository _enrollRepo;
  List<SubjectGroup> _rows = [];
  bool _loading = true;
  String _statusFilter = 'all';
  Set<String> _selectedIds = {};
  Map<String, int> _sessionCounts = {};
  Map<String, int> _enrollmentCounts = {};

  @override
  void initState() { super.initState(); _repo = SubjectGroupRepository(widget.database); _enrollRepo = EnrollmentRepository(widget.database); _fetchPage(); }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    final all = await _repo.getAll();
    _rows = all;
    _sessionCounts.clear(); _enrollmentCounts.clear();
    if (mounted) setState(() => _loading = false);
    _preloadCounts();
  }

  List<SubjectGroup> get filtered => _rows.where((g) {
    if (_statusFilter == 'archived') return g.isArchived;
    if (_statusFilter == 'active') return !g.isArchived;
    return true;
  }).toList();

  Future<void> _preloadCounts() async {
    for (final g in _rows) {
      final sessions = await _repo.getSessions(g.id);
      _sessionCounts[g.id] = sessions.where((s) => s.isActive && !s.isArchived).length;
      _enrollmentCounts[g.id] = await _repo.activeEnrollmentCount(g.id);
    }
    if (mounted) setState(() {});
  }

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == filtered.length) { _selectedIds.clear(); } else { _selectedIds = filtered.map((g) => g.id).toSet(); } });
  }

  void _openEdit(SubjectGroup? g) async {
    final result = await showDialog<bool>(context: context, builder: (_) => _GroupEditDialog(database: widget.database, group: g, l10n: AppLocalizations.of(context)));
    if (result == true) _fetchPage();
  }

  void _openDetail(SubjectGroup g) {
    showDialog(context: context, builder: (_) => _GroupDetailDialog(database: widget.database, group: g, l10n: AppLocalizations.of(context))).then((_) => _fetchPage());
  }

  Future<void> _confirmArchive(SubjectGroup g) async {
    final l10n = AppLocalizations.of(context);
    final hasActive = await _repo.hasActiveSessionsOrEnrollments(g.id);
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: Text(g.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: ShellTokens.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(g.isArchived ? '${l10n.restore}' : 'Archive this group?', style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
        if (hasActive && !g.isArchived) ...[
          const SizedBox(height: 8),
          Row(children: [const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning), const SizedBox(width: 8), Expanded(child: Text('This group has active sessions or enrollments.', style: const TextStyle(color: SemanticTokens.warning, fontSize: 12)))]),
        ],
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(g.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: SemanticTokens.error)))],
    ));
    if (confirmed == true) { if (g.isArchived) { await _repo.restore(g.id); } else { await _repo.archive(g.id); } _fetchPage(); }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = filtered;
    return Scaffold(backgroundColor: ContentTokens.background, body: Column(children: [
      _buildToolbar(l10n),
      Expanded(child: _buildBody(l10n)),
    ]));
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    return Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), child: Column(children: [
      Row(children: [
        Expanded(child: Row(children: [
          ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () { _statusFilter = 'all'; setState(() {}); }),
          ShellFilterChip(label: l10n.active, selected: _statusFilter == 'active', onTap: () { _statusFilter = 'active'; setState(() {}); }),
          ShellFilterChip(label: l10n.archived, selected: _statusFilter == 'archived', onTap: () { _statusFilter = 'archived'; setState(() {}); }),
        ])),
        SizedBox(height: 34, child: FilledButton.icon(onPressed: () => _openEdit(null), icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.add, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
      ]),
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

  Map<int, TableColumnWidth> _columnWidths() => const {0: FixedColumnWidth(44), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1.2), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1), 6: FlexColumnWidth(0.8), 7: IntrinsicColumnWidth()};

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
      _hdr(PhosphorIcons.checkSquare, null), _hdr(null, l10n.name), _hdr(null, l10n.subject), _hdr(null, l10n.schoolLevel), _hdr(null, l10n.capacity), _hdr(null, l10n.sessions), _hdr(null, l10n.enrollments), _hdr(PhosphorIcons.gear, null),
    ]);
  }
  Widget _hdr(IconData? icon, String? label) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [if (icon != null) InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary)) else Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3))]));

  TableRow _buildDataRow(SubjectGroup g, int index, AppLocalizations l10n) {
    final isSel = _selectedIds.contains(g.id);
    final even = index.isEven;
    final capText = g.capacity != null ? '${_enrollmentCounts[g.id] ?? 0}/${g.capacity}' : '${_enrollmentCounts[g.id] ?? 0}';
    final isFull = g.capacity != null && (_enrollmentCounts[g.id] ?? 0) >= g.capacity!;
    return TableRow(decoration: BoxDecoration(color: isSel ? ShellTokens.accentMuted.withValues(alpha: 0.3) : g.isArchived ? ShellTokens.chromeBase.withValues(alpha: 0.5) : even ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      _chk(g, isSel),
      GestureDetector(onTap: () => _openDetail(g), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(g.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), if (g.nameFr != null && g.nameFr!.isNotEmpty) Text(g.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))]))),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _txt('${g.subjectAr}${g.subjectFr != null && g.subjectFr!.isNotEmpty ? ' / ${g.subjectFr}' : ''}')),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _txt(_lev(g.schoolLevel, l10n))),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _txt(capText)),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: _txt('${_sessionCounts[g.id] ?? 0}')),
      GestureDetector(onTap: () => _openDetail(g), behavior: HitTestBehavior.opaque, child: isFull ? ShellBadge(label: 'Full', color: SemanticTokens.error) : _txt('${_enrollmentCounts[g.id] ?? 0}')),
      _act(g),
    ]);
  }
  Widget _chk(SubjectGroup g, bool sel) => GestureDetector(onTap: () => setState(() { if (sel) { _selectedIds.remove(g.id); } else { _selectedIds.add(g.id); } }), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: sel ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: sel ? ShellTokens.accent : Colors.transparent), child: sel ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null)));
  Widget _txt(String t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text(t, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis));
  Widget _act(SubjectGroup g) => Row(mainAxisSize: MainAxisSize.min, children: [
    IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(g), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
    IconButton(icon: Icon(g.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 13), onPressed: () => _confirmArchive(g), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: g.isArchived ? ShellTokens.accent : ShellTokens.textSecondary),
  ]);
  String _lev(String l, AppLocalizations l10n) => switch (l) { 'primary' => l10n.schoolLevelPrimary, 'middle' => l10n.schoolLevelMiddle, 'secondary' => l10n.schoolLevelSecondary, _ => l };
}

class _GroupDetailDialog extends StatelessWidget {
  final AppDatabase database; final SubjectGroup group; final AppLocalizations l10n;
  const _GroupDetailDialog({required this.database, required this.group, required this.l10n});
  @override
  Widget build(BuildContext context) {
    return ShellDialog(maxWidth: 520, title: group.nameAr, body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ShellSectionHeader(text: l10n.personalInfo), const SizedBox(height: 8),
      _ir(l10n.name, '${group.nameAr} / ${group.nameFr ?? '—'}'),
      _ir(l10n.subject, '${group.subjectAr} / ${group.subjectFr ?? '—'}'),
      _ir(l10n.schoolLevel, _lev(group.schoolLevel)),
      _ir(l10n.capacity, group.capacity?.toString() ?? '—'),
      const SizedBox(height: 16),
      ShellSectionHeader(text: l10n.sessions), const SizedBox(height: 8),
      _SessionList(database: database, groupId: group.id, l10n: l10n),
      const SizedBox(height: 16),
      ShellSectionHeader(text: l10n.enrollments), const SizedBox(height: 8),
      _EnrollmentListWidget(database: database, groupId: group.id, l10n: l10n),
      const SizedBox(height: 16),
      ShellSectionHeader(text: 'Waitlist'), const SizedBox(height: 8),
      _WaitlistWidget(database: database, groupId: group.id, groupCapacity: group.capacity, l10n: l10n),
    ]));
  }
  Widget _ir(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 120, child: Text(l, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))), Expanded(child: Text(v, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)))]));
  String _lev(String l) => switch (l) { 'primary' => l10n.schoolLevelPrimary, 'middle' => l10n.schoolLevelMiddle, 'secondary' => l10n.schoolLevelSecondary, _ => l };
}

class _EnrollmentListWidget extends StatefulWidget {
  final AppDatabase database; final String groupId; final AppLocalizations l10n;
  const _EnrollmentListWidget({required this.database, required this.groupId, required this.l10n});
  @override
  State<_EnrollmentListWidget> createState() => _EnrollmentListWidgetState();
}
class _EnrollmentListWidgetState extends State<_EnrollmentListWidget> {
  List<Enrollment> _enrollments = []; Map<String, String> _names = {}; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final repo = SubjectGroupRepository(widget.database); _enrollments = await repo.getStudents(widget.groupId);
    final studentRepo = StudentRepository(widget.database);
    for (final e in _enrollments) {
      if (!_names.containsKey(e.studentId)) { final s = await studentRepo.getById(e.studentId); _names[e.studentId] = s != null ? '${s.firstNameAr} ${s.lastNameAr}' : e.studentId; }
    }
    if (mounted) setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    final active = _enrollments.where((e) => !e.isTransferred).toList();
    if (active.isEmpty) return Text(widget.l10n.noEnrollments, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    return Column(children: active.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: e.status == 'active' ? SemanticTokens.success : e.status == 'transferred_out' ? ShellTokens.textDisabled : SemanticTokens.warning, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Expanded(child: Text(_names[e.studentId] ?? e.studentId, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
      if (e.isTransferred) ShellBadge(label: 'Transferred', color: ShellTokens.textDisabled),
      IconButton(icon: const Icon(PhosphorIcons.x, size: 12), onPressed: () async {
        final enrollRepo = EnrollmentRepository(widget.database);
        await enrollRepo.updateStatus(e.id, 'inactive');
        _load();
      }, constraints: const BoxConstraints(minWidth: 22, minHeight: 22), padding: EdgeInsets.zero, color: SemanticTokens.warning),
    ]))).toList());
  }
}

class _WaitlistWidget extends StatefulWidget {
  final AppDatabase database; final String groupId; final int? groupCapacity; final AppLocalizations l10n;
  const _WaitlistWidget({required this.database, required this.groupId, this.groupCapacity, required this.l10n});
  @override
  State<_WaitlistWidget> createState() => _WaitlistWidgetState();
}
class _WaitlistWidgetState extends State<_WaitlistWidget> {
  List<EnrollmentWaitlistData> _waitlist = []; Map<String, String> _names = {}; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final enrollRepo = EnrollmentRepository(widget.database);
    _waitlist = await enrollRepo.getWaitlist(widget.groupId);
    final studentRepo = StudentRepository(widget.database);
    for (final w in _waitlist) {
      if (!_names.containsKey(w.studentId)) { final s = await studentRepo.getById(w.studentId); _names[w.studentId] = s != null ? '${s.firstNameAr} ${s.lastNameAr}' : w.studentId; }
    }
    if (mounted) setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_waitlist.isEmpty) return Text('No students waiting', style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    return Column(children: [
      Text('${_waitlist.length} waiting', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
      const SizedBox(height: 4),
      ..._waitlist.map((w) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
        const Icon(PhosphorIcons.clock, size: 10, color: ShellTokens.textDisabled),
        const SizedBox(width: 6),
        Expanded(child: Text(_names[w.studentId] ?? w.studentId, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
        Text('${w.requestedAt.year}-${w.requestedAt.month.toString().padLeft(2, '0')}-${w.requestedAt.day.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
        const SizedBox(width: 6),
        SizedBox(height: 22, child: TextButton(onPressed: () => _moveToActive(w), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6), minimumSize: Size.zero), child: Text('Move to active', style: const TextStyle(fontSize: 9, color: ShellTokens.accent)))),
      ]))),
    ]);
  }
  Future<void> _moveToActive(EnrollmentWaitlistData w) async {
    final enrollRepo = EnrollmentRepository(widget.database);
    final groupRepo = SubjectGroupRepository(widget.database);
    final g = await groupRepo.getById(widget.groupId);
    final count = await groupRepo.activeEnrollmentCount(widget.groupId);
    if (g?.capacity != null && count >= g!.capacity!) {
      final l10n = widget.l10n;
      if (context.mounted) {
        final action = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
          backgroundColor: ShellTokens.chromeSurface,
          title: Text('Group is full', style: const TextStyle(color: ShellTokens.textPrimary)),
          content: Text('Active enrollments ($count) equals capacity (${g.capacity}). Increase capacity or leave on waitlist.', style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n.cancel)),
            TextButton(onPressed: () => Navigator.pop(ctx, 'increase'), child: Text('Increase Capacity', style: const TextStyle(color: ShellTokens.accent))),
          ],
        ));
        if (action == 'increase') {
          final newCapCtrl = TextEditingController(text: '${g.capacity! + 1}');
          final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
            backgroundColor: ShellTokens.chromeSurface,
            title: Text('Set new capacity', style: const TextStyle(color: ShellTokens.textPrimary)),
            content: TextField(controller: newCapCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField()),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
          ));
          if (ok == true) {
            await groupRepo.update(widget.groupId, SubjectGroupsCompanion(capacity: Value(int.tryParse(newCapCtrl.text))));
          }
        }
      }
      final newCount2 = await groupRepo.activeEnrollmentCount(widget.groupId);
      final g3 = await groupRepo.getById(widget.groupId);
      if (g3?.capacity != null && newCount2 >= g3!.capacity!) return;
    }
    await enrollRepo.create(EnrollmentsCompanion(studentId: Value(w.studentId), subjectGroupId: Value(widget.groupId)));
    await enrollRepo.removeFromWaitlist(w.id);
    _load();
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
    return Column(children: _sessions.where((s) => s.isActive && !s.isArchived).map((s) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)), const SizedBox(width: 8), Text('${days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))]))).toList());
  }
}

class _GroupEditDialog extends StatefulWidget {
  final AppDatabase database; final SubjectGroup? group; final AppLocalizations l10n;
  const _GroupEditDialog({required this.database, this.group, required this.l10n});
  @override
  State<_GroupEditDialog> createState() => _GroupEditDialogState();
}
class _GroupEditDialogState extends State<_GroupEditDialog> {
  late final GlobalKey<FormState> _formKey;
  late final SubjectGroupRepository _repo; bool _saving = false; bool _isEdit = false;
  late TextEditingController _nameArCtrl, _nameFrCtrl, _subjectArCtrl, _subjectFrCtrl, _descCtrl, _capacityCtrl;
  String _schoolLevel = 'primary';

  @override
  void initState() {
    super.initState(); _formKey = GlobalKey<FormState>(); _repo = SubjectGroupRepository(widget.database); _isEdit = widget.group != null;
    final g = widget.group;
    _nameArCtrl = TextEditingController(text: g?.nameAr ?? ''); _nameFrCtrl = TextEditingController(text: g?.nameFr ?? '');
    _subjectArCtrl = TextEditingController(text: g?.subjectAr ?? ''); _subjectFrCtrl = TextEditingController(text: g?.subjectFr ?? '');
    _descCtrl = TextEditingController(text: g?.description ?? ''); _capacityCtrl = TextEditingController(text: g?.capacity?.toString() ?? '');
    if (g != null) _schoolLevel = g.schoolLevel;
  }
  @override
  void dispose() { _nameArCtrl.dispose(); _nameFrCtrl.dispose(); _subjectArCtrl.dispose(); _subjectFrCtrl.dispose(); _descCtrl.dispose(); _capacityCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return; setState(() => _saving = true);
    try {
      final entry = SubjectGroupsCompanion(nameAr: Value(_nameArCtrl.text.trim()), nameFr: Value(_nameFrCtrl.text.trim().isEmpty ? null : _nameFrCtrl.text.trim()), subjectAr: Value(_subjectArCtrl.text.trim()), subjectFr: Value(_subjectFrCtrl.text.trim().isEmpty ? null : _subjectFrCtrl.text.trim()), schoolLevel: Value(_schoolLevel), description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()), capacity: Value(int.tryParse(_capacityCtrl.text)));
      if (_isEdit) { await _repo.update(widget.group!.id, entry); } else { await _repo.create(entry); }
      if (mounted) Navigator.pop(context, true);
    } catch (_) { if (mounted) setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShellDialog(maxWidth: 520, title: _isEdit ? l10n.edit : l10n.add, body: Form(key: _formKey, child: Column(children: [
      _tf(_nameArCtrl, required: true, hint: '${l10n.name} AR'), const SizedBox(height: 8),
      _tf(_nameFrCtrl, hint: '${l10n.name} FR'), const SizedBox(height: 8),
      _tf(_subjectArCtrl, required: true, hint: '${l10n.subject} AR'), const SizedBox(height: 8),
      _tf(_subjectFrCtrl, hint: '${l10n.subject} FR'), const SizedBox(height: 14),
      ShellSectionHeader(text: l10n.schoolLevel), const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: _schoolLevel, items: ['primary', 'middle', 'secondary'].map((v) => DropdownMenuItem(value: v, child: Text(_lev(v), style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => _schoolLevel = v!), decoration: ShellInputDecoration.dropdown()),
      const SizedBox(height: 14),
      _tf(_capacityCtrl, hint: '${l10n.capacity} (empty = unlimited)'), const SizedBox(height: 14),
      _tf(_descCtrl, maxLines: 2, hint: l10n.description),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: _saving ? null : _save, style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create))),
    ])));
  }
  Widget _tf(TextEditingController ctrl, {bool required = false, int maxLines = 1, String? hint}) => TextFormField(controller: ctrl, maxLines: maxLines, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField(hintText: hint), validator: required ? (v) => (v == null || v.trim().isEmpty) ? widget.l10n.fieldRequired : null : null);
  String _lev(String v) => switch (v) { 'primary' => widget.l10n.schoolLevelPrimary, 'middle' => widget.l10n.schoolLevelMiddle, 'secondary' => widget.l10n.schoolLevelSecondary, _ => v };
}
