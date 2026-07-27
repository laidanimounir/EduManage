import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/classroom_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class ClassroomListScreen extends StatefulWidget {
  final AppDatabase database;
  const ClassroomListScreen({super.key, required this.database});
  @override
  State<ClassroomListScreen> createState() => _ClassroomListScreenState();
}

class _ClassroomListScreenState extends State<ClassroomListScreen> {
  late final ClassroomRepository _repo;
  List<Classroom> _rows = [];
  bool _loading = true;
  Set<String> _selectedIds = {};
  Map<String, int> _sessionCounts = {};

  @override
  void initState() { super.initState(); _repo = ClassroomRepository(widget.database); _fetchPage(); }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    _rows = await _repo.getAll();
    _sessionCounts.clear();
    if (mounted) setState(() => _loading = false);
    _preloadCounts();
  }

  Future<void> _preloadCounts() async {
    final sessionRepo = SessionRepository(widget.database);
    for (final r in _rows) {
      final sessions = await sessionRepo.getByClassroom(r.id);
      _sessionCounts[r.id] = sessions.where((s) => s.isActive && !s.isArchived).length;
    }
    if (mounted) setState(() {});
  }

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == _rows.length) { _selectedIds.clear(); } else { _selectedIds = _rows.map((r) => r.id).toSet(); } });
  }

  void _openEdit(Classroom? r) async {
    final result = await showDialog<bool>(context: context, builder: (_) => _RoomEditDialog(database: widget.database, room: r, l10n: AppLocalizations.of(context)));
    if (result == true) _fetchPage();
  }

  void _openDetail(Classroom r) {
    showDialog(context: context, builder: (_) => _RoomDetailDialog(database: widget.database, room: r, l10n: AppLocalizations.of(context)));
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
      TextButton.icon(onPressed: _toggleSelectAll, icon: Icon(_selectedIds.length == _rows.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16), label: Text(_selectedIds.length == _rows.length ? l10n.clearSelection : l10n.selectAll), style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary)),
    ]));
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    return Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 6), child: Row(children: [
      Expanded(child: SizedBox(height: 34, child: FilledButton.icon(onPressed: () => _openEdit(null), icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.add, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12))))),
    ]));
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    return Column(children: [
      Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)), children: [_buildHeaderRow(l10n)]),
      Expanded(child: SingleChildScrollView(child: Table(columnWidths: _columnWidths(), defaultVerticalAlignment: TableCellVerticalAlignment.middle, border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)), children: _rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)).toList()))),
    ]);
  }

  Map<int, TableColumnWidth> _columnWidths() => const {
    0: FixedColumnWidth(44), 1: FlexColumnWidth(2), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: IntrinsicColumnWidth(),
  };

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
      _buildHeaderCell(PhosphorIcons.checkSquare, null), _buildHeaderCell(null, l10n.name), _buildHeaderCell(null, l10n.floor), _buildHeaderCell(null, l10n.capacity), _buildHeaderCell(null, l10n.sessions), _buildHeaderCell(PhosphorIcons.gear, null),
    ]);
  }

  Widget _buildHeaderCell(IconData? icon, String? label) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary))
      else Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
    ]));
  }

  TableRow _buildDataRow(Classroom r, int index, AppLocalizations l10n) {
    final isSelected = _selectedIds.contains(r.id);
    final isEven = index.isEven;
    final capacityPct = r.capacity != null && r.capacity! > 0 && (_sessionCounts[r.id] ?? 0) > 0 ? '${(_sessionCounts[r.id]! * 100 ~/ r.capacity!).clamp(0, 999)}%' : '—';
    return TableRow(decoration: BoxDecoration(color: isSelected ? ShellTokens.accentMuted.withValues(alpha: 0.3) : isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      _buildCheckCell(r, isSelected),
      GestureDetector(onTap: () => _openDetail(r), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(r.nameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), if (r.nameFr != null && r.nameFr!.isNotEmpty) Text(r.nameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))]))),
      GestureDetector(onTap: () => _openDetail(r), behavior: HitTestBehavior.opaque, child: _buildTextCell(r.floor?.toString() ?? '—')),
      GestureDetector(onTap: () => _openDetail(r), behavior: HitTestBehavior.opaque, child: _buildTextCell('${r.capacity?.toString() ?? '—'}${r.capacity != null ? ' $capacityPct' : ''}')),
      GestureDetector(onTap: () => _openDetail(r), behavior: HitTestBehavior.opaque, child: _buildTextCell('${_sessionCounts[r.id] ?? 0}')),
      _buildActionsCell(r),
    ]);
  }

  Widget _buildCheckCell(Classroom r, bool isSelected) {
    return GestureDetector(onTap: () => setState(() { if (isSelected) { _selectedIds.remove(r.id); } else { _selectedIds.add(r.id); } }), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: isSelected ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: isSelected ? ShellTokens.accent : Colors.transparent), child: isSelected ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null)));
  }

  Widget _buildTextCell(String text) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text(text, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis));

  Widget _buildActionsCell(Classroom r) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(r), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
    ]);
  }
}

class _RoomDetailDialog extends StatelessWidget {
  final AppDatabase database; final Classroom room; final AppLocalizations l10n;
  const _RoomDetailDialog({required this.database, required this.room, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 520, title: room.nameAr,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: l10n.personalInfo),
        const SizedBox(height: 8),
        _infoRow(l10n.name, '${room.nameAr} / ${room.nameFr ?? '—'}'),
        _infoRow(l10n.floor, room.floor?.toString() ?? '—'),
        _infoRow(l10n.capacity, room.capacity?.toString() ?? '—'),
        if (room.notes != null && room.notes!.isNotEmpty) _infoRow(l10n.note, room.notes!),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.sessions),
        const SizedBox(height: 8),
        _RoomSessionList(database: database, roomId: room.id, l10n: l10n),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))), Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)))]));
  }
}

class _RoomSessionList extends StatefulWidget {
  final AppDatabase database; final String roomId; final AppLocalizations l10n;
  const _RoomSessionList({required this.database, required this.roomId, required this.l10n});
  @override
  State<_RoomSessionList> createState() => _RoomSessionListState();
}

class _RoomSessionListState extends State<_RoomSessionList> {
  List<Session> _sessions = []; Map<String, String> _groupNames = {}; bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    _sessions = await SessionRepository(widget.database).getByClassroom(widget.roomId);
    final groupRepo = SubjectGroupRepository(widget.database);
    for (final s in _sessions) {
      if (!_groupNames.containsKey(s.subjectGroupId)) {
        final g = await groupRepo.getById(s.subjectGroupId);
        _groupNames[s.subjectGroupId] = g?.nameAr ?? s.subjectGroupId;
      }
    }
    if (mounted) setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    final active = _sessions.where((s) => s.isActive && !s.isArchived).toList();
    if (active.isEmpty) return Text(widget.l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    final days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(children: active.map((s) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text('${_groupNames[s.subjectGroupId] ?? ''} · ${days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
    ]))).toList());
  }
}

class _RoomEditDialog extends StatefulWidget {
  final AppDatabase database; final Classroom? room; final AppLocalizations l10n;
  const _RoomEditDialog({required this.database, this.room, required this.l10n});
  @override
  State<_RoomEditDialog> createState() => _RoomEditDialogState();
}

class _RoomEditDialogState extends State<_RoomEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final ClassroomRepository _repo; bool _saving = false; bool _isEdit = false;
  late TextEditingController _nameArCtrl, _nameFrCtrl, _floorCtrl, _capacityCtrl, _notesCtrl;

  @override
  void initState() {
    super.initState(); _repo = ClassroomRepository(widget.database); _isEdit = widget.room != null;
    final r = widget.room;
    _nameArCtrl = TextEditingController(text: r?.nameAr ?? ''); _nameFrCtrl = TextEditingController(text: r?.nameFr ?? '');
    _floorCtrl = TextEditingController(text: r?.floor?.toString() ?? ''); _capacityCtrl = TextEditingController(text: r?.capacity?.toString() ?? '');
    _notesCtrl = TextEditingController(text: r?.notes ?? '');
  }

  @override
  void dispose() { _nameArCtrl.dispose(); _nameFrCtrl.dispose(); _floorCtrl.dispose(); _capacityCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return; setState(() => _saving = true);
    try {
      final entry = ClassroomsCompanion(nameAr: Value(_nameArCtrl.text.trim()), nameFr: Value(_nameFrCtrl.text.trim().isEmpty ? null : _nameFrCtrl.text.trim()), floor: Value(int.tryParse(_floorCtrl.text)), capacity: Value(int.tryParse(_capacityCtrl.text)), notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()));
      if (_isEdit) { await _repo.update(widget.room!.id, entry); } else { await _repo.create(entry); }
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
        _tf(_floorCtrl, hint: l10n.floor),
        const SizedBox(height: 8),
        _tf(_capacityCtrl, hint: l10n.capacity),
        const SizedBox(height: 8),
        _tf(_notesCtrl, maxLines: 2, hint: l10n.note),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: _saving ? null : _save, style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create))),
      ])),
    );
  }

  Widget _tf(TextEditingController ctrl, {bool required = false, int maxLines = 1, String? hint}) {
    return TextFormField(controller: ctrl, maxLines: maxLines, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary), decoration: ShellInputDecoration.textField(hintText: hint), validator: required ? (v) => (v == null || v.trim().isEmpty) ? widget.l10n.fieldRequired : null : null);
  }
}
