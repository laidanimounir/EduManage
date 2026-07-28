import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/audit_log_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/student_repository.dart';
import '../../utils/date_helper.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_pagination_bar.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class SessionListScreen extends StatefulWidget {
  final AppDatabase database;
  const SessionListScreen({super.key, required this.database});
  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  late final SessionRepository _repo;
  late final TeacherRepository _teacherRepo;
  late final SubjectGroupRepository _groupRepo;
  late final ClassroomRepository _classroomRepo;
  List<Session> _rows = [];
  int _total = 0;
  int _page = 0;
  int _pageSize = 20;
  bool _loading = true;
  String _statusFilter = 'all';
  int _dayFilter = 0;
  String _sortColumn = '';
  bool _sortAsc = true;
  Set<String> _selectedIds = {};
  Map<String, String> _teacherNameCache = {};
  Map<String, String> _groupNameCache = {};
  Map<String, String> _classroomNameCache = {};
  Set<String> _liveNowIds = {};
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo = SessionRepository(widget.database);
    _teacherRepo = TeacherRepository(widget.database);
    _groupRepo = SubjectGroupRepository(widget.database);
    _classroomRepo = ClassroomRepository(widget.database);
    _fetchPage();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    final result = await _repo.fetchPage(offset: _page * _pageSize, limit: _pageSize, statusFilter: _statusFilter, dayFilter: _dayFilter > 0 ? _dayFilter : null);
    _teacherNameCache.clear(); _groupNameCache.clear(); _classroomNameCache.clear(); _liveNowIds.clear();
    if (mounted) setState(() { _rows = result.sessions; _total = result.total; _loading = false; });
    _preloadNames();
    _preloadLiveStatus();
  }

  void _onStatusFilterChanged(String v) { _statusFilter = v; _page = 0; _fetchPage(); }

  Future<void> _preloadNames() async {
    for (final s in _rows) {
      if (!_teacherNameCache.containsKey(s.teacherId)) {
        final t = await _teacherRepo.getById(s.teacherId);
        _teacherNameCache[s.teacherId] = t != null ? '${t.firstNameAr} ${t.lastNameAr}' : s.teacherId;
      }
      if (!_groupNameCache.containsKey(s.subjectGroupId)) {
        final g = await _groupRepo.getById(s.subjectGroupId);
        _groupNameCache[s.subjectGroupId] = g?.nameAr ?? s.subjectGroupId;
      }
      if (!_classroomNameCache.containsKey(s.classroomId)) {
        final c = await _classroomRepo.getById(s.classroomId);
        _classroomNameCache[s.classroomId] = c?.nameAr ?? s.classroomId;
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _preloadLiveStatus() async {
    final now = DateTime.now();
    for (final s in _rows) {
      if (await widget.database.isSessionHappeningNow(s.id, now)) {
        _liveNowIds.add(s.id);
      }
    }
    if (mounted) setState(() {});
  }

  void _toggleSelectAll() {
    setState(() { if (_selectedIds.length == _rows.length) { _selectedIds.clear(); } else { _selectedIds = _rows.map((s) => s.id).toSet(); } });
  }

  void _openEdit(Session? s) async {
    final result = await showDialog<bool>(context: context, builder: (_) => _SessionEditDialog(database: widget.database, session: s, l10n: AppLocalizations.of(context)));
    if (result == true) _fetchPage();
  }

  void _openDetail(Session s) {
    showDialog(context: context, builder: (_) => _SessionDetailDialog(database: widget.database, session: s, l10n: AppLocalizations.of(context)));
  }

  Future<void> _confirmArchive(Session s) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: Text(s.isArchived ? l10n.restoreSession : l10n.archiveSession, style: const TextStyle(color: ShellTokens.textPrimary)),
      content: Text(l10n.archiveSessionConfirm, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: SemanticTokens.error))),
      ],
    ));
    if (confirmed == true) {
      if (s.isArchived) { await _repo.restore(s.id); } else { await _repo.archive(s.id); }
      _fetchPage();
    }
  }

  Future<void> _cancelSessionOccurrence(Session s) async {
    final l10n = AppLocalizations.of(context);
    DateTime selectedDate = DateTime.now();
    final reasonCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: Text(l10n.sessionCancellation, style: const TextStyle(color: ShellTokens.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text(_groupNameCache[s.subjectGroupId] ?? s.subjectGroupId, style: const TextStyle(color: ShellTokens.textPrimary)),
          subtitle: Text('${DateHelper.formatDayOfWeek(s.dayOfWeek, Localizations.localeOf(context).languageCode)} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11)),
        ),
        ListTile(
          title: Text(l10n.selectDate),
          subtitle: Text('${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
          trailing: const Icon(PhosphorIcons.calendar, size: 16, color: ShellTokens.textSecondary),
          onTap: () async {
            final d = await showDatePicker(context: ctx, initialDate: selectedDate, firstDate: DateTime(2024), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (d != null) setSt(() => selectedDate = d);
          },
        ),
        TextFormField(controller: reasonCtrl, decoration: ShellInputDecoration.textField(hintText: l10n.reason), style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm, style: const TextStyle(color: SemanticTokens.error))),
      ],
    )));

    if (confirmed == true) {
      final txService = TransactionService(widget.database);
      final reversedCount = await txService.reverseCancelledSessionCharges(sessionId: s.id, date: selectedDate);

      await widget.database.into(widget.database.cancellations).insert(CancellationsCompanion(
        id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
        sessionId: Value(s.id),
        cancelDate: Value(selectedDate),
        reason: Value(reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim()),
        deviceId: Value('system'),
      ));

      final groupName = _groupNameCache[s.subjectGroupId] ?? s.subjectGroupId;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.sessionCancelledNotice(groupName, '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}') + (reversedCount.isNotEmpty ? ' (${reversedCount.length} reversals)' : '')),
          backgroundColor: ShellTokens.chromeSurface,
        ));
      }
      _fetchPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalPages = (_total / _pageSize).ceil();
    final hasSelection = _selectedIds.isNotEmpty;

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(children: [
        if (hasSelection) _buildSelectionBar(l10n),
        _buildToolbar(l10n),
        Expanded(child: _buildBody(l10n)),
        if (!_loading && _total > 0) _buildPaginationBar(l10n, totalPages),
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
      child: Column(children: [
        Row(children: [
          Expanded(child: SizedBox(height: 34, child: TextField(
            controller: _searchCtrl, style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
            decoration: ShellInputDecoration.textField(hintText: l10n.search, prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary), fillColor: ShellTokens.chromeSurface),
            onChanged: (_) {},
          ))),
          const SizedBox(width: 8),
          SizedBox(height: 34, child: FilledButton.icon(onPressed: () => _openEdit(null), icon: const Icon(PhosphorIcons.plus, size: 14), label: Text(l10n.add, style: const TextStyle(fontSize: 12)), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)))),
        ]),
        const SizedBox(height: 8),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () => _onStatusFilterChanged('all')),
          ShellFilterChip(label: l10n.activeSessions, selected: _statusFilter == 'active', onTap: () => _onStatusFilterChanged('active')),
          ShellFilterChip(label: l10n.inactiveSessions, selected: _statusFilter == 'inactive', onTap: () => _onStatusFilterChanged('inactive')),
          ShellFilterChip(label: l10n.archivedSessions, selected: _statusFilter == 'archived', onTap: () => _onStatusFilterChanged('archived')),
        ])),
        const SizedBox(height: 4),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          ShellFilterChip(label: l10n.all, selected: _dayFilter == 0, onTap: () { _dayFilter = 0; _page = 0; _fetchPage(); }),
          ...List.generate(7, (i) => ShellFilterChip(label: DateHelper.formatDayOfWeek(i + 1, Localizations.localeOf(context).languageCode).substring(0, 4), selected: _dayFilter == i + 1, onTap: () { _dayFilter = i + 1; _page = 0; _fetchPage(); })),
        ])),
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
    1: FlexColumnWidth(1.5),
    2: FlexColumnWidth(1.5),
    3: FlexColumnWidth(1.5),
    4: FlexColumnWidth(1),
    5: FlexColumnWidth(0.8),
    6: FlexColumnWidth(0.8),
    7: IntrinsicColumnWidth(),
  };

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))), children: [
      _buildHeaderCell(PhosphorIcons.checkSquare, null),
      _buildHeaderCell(null, l10n.time),
      _buildHeaderCell(null, l10n.groupName),
      _buildHeaderCell(null, l10n.teacher),
      _buildHeaderCell(null, l10n.classroom),
      _buildHeaderCell(null, l10n.monthlyPrice),
      _buildHeaderCell(null, l10n.status),
      _buildHeaderCell(PhosphorIcons.gear, null),
    ]);
  }

  Widget _buildHeaderCell(IconData? icon, String? label) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary))
      else Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
    ]));
  }

  TableRow _buildDataRow(Session s, int index, AppLocalizations l10n) {
    final isSelected = _selectedIds.contains(s.id);
    final isEven = index.isEven;
    final isLive = _liveNowIds.contains(s.id);

    return TableRow(decoration: BoxDecoration(color: isSelected ? ShellTokens.accentMuted.withValues(alpha: 0.3) : isLive ? SemanticTokens.success.withValues(alpha: 0.08) : isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3)), children: [
      _buildCheckCell(s, isSelected),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: _buildTextCell('${DateHelper.formatDayOfWeek(s.dayOfWeek, Localizations.localeOf(context).languageCode)} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}')),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: _buildTextCell('${_groupNameCache[s.subjectGroupId] ?? ''}')),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: _buildTextCell(_teacherNameCache[s.teacherId] ?? '')),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: _buildTextCell(_classroomNameCache[s.classroomId] ?? '')),
      GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque, child: _buildTextCell('${s.monthlyPrice.toStringAsFixed(0)} DA')),
      Row(mainAxisSize: MainAxisSize.min, children: [if (isLive) ShellBadge(label: l10n.liveNow.replaceAll('● ', ''), color: SemanticTokens.success), if (!s.isActive) ShellBadge(label: l10n.inactive, color: const Color(0xFFC2823A)), if (s.isArchived) ShellBadge(label: l10n.archived, color: ShellTokens.textDisabled)]),
      _buildActionsCell(s),
    ]);
  }

  Widget _buildCheckCell(Session s, bool isSelected) {
    return GestureDetector(onTap: () => setState(() { if (isSelected) { _selectedIds.remove(s.id); } else { _selectedIds.add(s.id); } }), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), child: Container(width: 14, height: 14, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: isSelected ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: isSelected ? ShellTokens.accent : Colors.transparent), child: isSelected ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null)));
  }

  Widget _buildTextCell(String text) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text(text, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis));

  Widget _buildActionsCell(Session s) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(s), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
      IconButton(icon: const Icon(PhosphorIcons.x, size: 13), onPressed: () => _cancelSessionOccurrence(s), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: SemanticTokens.warning, tooltip: 'Cancel'),
      IconButton(icon: Icon(s.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 13), onPressed: () => _confirmArchive(s), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: s.isArchived ? ShellTokens.accent : ShellTokens.textSecondary),
    ]);
  }

  Widget _buildPaginationBar(AppLocalizations l10n, int totalPages) {
    final first = _page * _pageSize + 1;
    final last = (_page * _pageSize + _rows.length).clamp(0, _total);
    return ShellPaginationBar(page: _page, pageSize: _pageSize, rowCount: _rows.length, total: _total, onPrevious: () { _page--; _fetchPage(); }, onNext: () { _page++; _fetchPage(); }, showingResultsText: l10n.showingResults('$first', '$last', '$_total'));
  }
}

class _SessionEditDialog extends StatefulWidget {
  final AppDatabase database;
  final Session? session;
  final AppLocalizations l10n;
  const _SessionEditDialog({required this.database, this.session, required this.l10n});
  @override
  State<_SessionEditDialog> createState() => _SessionEditDialogState();
}

class _SessionEditDialogState extends State<_SessionEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final SessionRepository _repo;
  bool _saving = false;
  bool _isEdit = false;

  List<SubjectGroup> _groups = [];
  List<Teacher> _teachers = [];
  List<Classroom> _classrooms = [];
  String? _groupId, _teacherId, _classroomId;
  int _dayOfWeek = 1;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 11, minute: 0);
  final _monthlyPriceCtrl = TextEditingController(text: '5000');
  final _sessionsCountCtrl = TextEditingController(text: '8');
  String _salaryMode = 'default';
  final _overridePctCtrl = TextEditingController();
  final _overrideFixedCtrl = TextEditingController();
  List<Session> _conflicts = [];
  Teacher? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    _repo = SessionRepository(widget.database);
    _isEdit = widget.session != null;
    _loadData();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadData() async {
    final groupRepo = SubjectGroupRepository(widget.database);
    final teacherRepo = TeacherRepository(widget.database);
    final classroomRepo = ClassroomRepository(widget.database);
    _groups = (await groupRepo.getAll()).where((g) => !g.isArchived).toList();
    _teachers = await teacherRepo.getAll();
    _classrooms = (await classroomRepo.getAll()).where((c) => !c.isArchived).toList();
    if (mounted) setState(() {});
  }

  Future<void> _loadExisting() async {
    final s = widget.session!;
    _groupId = s.subjectGroupId;
    _teacherId = s.teacherId;
    _classroomId = s.classroomId;
    _dayOfWeek = s.dayOfWeek;
    _startTime = TimeOfDay.fromDateTime(s.startTime);
    _endTime = TimeOfDay.fromDateTime(s.endTime);
    _monthlyPriceCtrl.text = s.monthlyPrice.toString();
    _sessionsCountCtrl.text = s.sessionsPerMonth.toString();
    _salaryMode = (s.teacherSharePct != null || s.teacherFixedAmount != null) ? 'override' : 'default';
    if (s.teacherSharePct != null) _overridePctCtrl.text = s.teacherSharePct!.toString();
    if (s.teacherFixedAmount != null) _overrideFixedCtrl.text = s.teacherFixedAmount!.toString();
    _selectedTeacher = _teachers.cast<Teacher?>().firstWhere((t) => t?.id == s.teacherId, orElse: () => null);
    _checkConflicts();
  }

  Future<void> _onTeacherChanged(String? id) async {
    _teacherId = id;
    _selectedTeacher = _teachers.cast<Teacher?>().firstWhere((t) => t?.id == id, orElse: () => null);
    _checkConflicts();
  }

  Future<void> _checkConflicts() async {
    if (_dayOfWeek == 0) return;
    final startDt = DateTime(2026, 1, 1, _startTime.hour, _startTime.minute);
    final endDt = DateTime(2026, 1, 1, _endTime.hour, _endTime.minute);
    final conflicts = await _repo.getOverlappingSessions(_dayOfWeek, startDt, endDt, excludeId: widget.session?.id);
    _conflicts = conflicts;
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_groupId == null || _teacherId == null || _classroomId == null) return;

    setState(() => _saving = true);
    try {
      final startDt = DateTime(2026, 1, 1, _startTime.hour, _startTime.minute);
      final endDt = DateTime(2026, 1, 1, _endTime.hour, _endTime.minute);

      double? sharePct, fixedAmount;
      if (_salaryMode == 'override') {
        if (_selectedTeacher?.salaryType == 'percentage') {
          sharePct = double.tryParse(_overridePctCtrl.text) ?? _selectedTeacher?.teacherSharePct;
        } else {
          fixedAmount = double.tryParse(_overrideFixedCtrl.text) ?? _selectedTeacher?.teacherFixedAmount;
        }
      }

      final entry = SessionsCompanion(
        subjectGroupId: Value(_groupId!), teacherId: Value(_teacherId!), classroomId: Value(_classroomId!),
        dayOfWeek: Value(_dayOfWeek), startTime: Value(startDt), endTime: Value(endDt),
        monthlyPrice: Value(double.tryParse(_monthlyPriceCtrl.text) ?? 0),
        sessionsPerMonth: Value(int.tryParse(_sessionsCountCtrl.text) ?? 8),
        teacherSharePct: Value(sharePct), teacherFixedAmount: Value(fixedAmount),
      );

      if (_isEdit) { await _repo.update(widget.session!.id, entry); } else { await _repo.create(entry); }
      if (mounted) Navigator.pop(context, true);
    } on StateError catch (e) {
      final l10n = widget.l10n;
      final msg = e.message == 'CONFLICT_TEACHER' ? l10n.conflictTeacher : e.message == 'CONFLICT_CLASSROOM' ? l10n.conflictClassroom : e.toString();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: ShellTokens.chromeSurface));
      setState(() => _saving = false);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() { _monthlyPriceCtrl.dispose(); _sessionsCountCtrl.dispose(); _overridePctCtrl.dispose(); _overrideFixedCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final teacherConflict = _conflicts.any((c) => c.teacherId == _teacherId);
    final classroomConflict = _conflicts.any((c) => c.classroomId == _classroomId);
    final groupConflict = _conflicts.any((c) => c.subjectGroupId == _groupId);
    final teacherDefaultRate = _selectedTeacher != null
        ? (_selectedTeacher!.salaryType == 'percentage' ? '${_selectedTeacher!.teacherSharePct}%' : '${_selectedTeacher!.teacherFixedAmount} DA')
        : '—';

    return ShellDialog(
      maxWidth: 600, maxHeight: 750, title: _isEdit ? l10n.edit : l10n.add,
      body: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: l10n.groupName),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _groupId, items: _groups.map((g) => DropdownMenuItem(value: g.id, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(g.nameAr, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)), Text('${g.subjectAr} · ${g.schoolLevel}', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled))]))).toList(),
          onChanged: (v) => setState(() => _groupId = v), decoration: ShellInputDecoration.dropdown(),
        ),
        const SizedBox(height: 12),
        ShellSectionHeader(text: l10n.teacher),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _teacherId, items: _teachers.map((t) => DropdownMenuItem(value: t.id, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('${t.firstNameAr} ${t.lastNameAr}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)), Text('${t.salaryType == 'percentage' ? '${t.teacherSharePct}%' : '${t.teacherFixedAmount} DA'}', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled))]))).toList(),
          onChanged: _onTeacherChanged, decoration: ShellInputDecoration.dropdown(),
        ),
        const SizedBox(height: 12),
        ShellSectionHeader(text: l10n.classroom),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _classroomId, items: _classrooms.map((r) => DropdownMenuItem(value: r.id, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(r.nameAr, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)), if (r.capacity != null) Text('Capacity: ${r.capacity}', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled))]))).toList(),
          onChanged: (v) => setState(() => _classroomId = v), decoration: ShellInputDecoration.dropdown(),
        ),
        const SizedBox(height: 12),
        ShellSectionHeader(text: l10n.dayOfWeek),
        const SizedBox(height: 6),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: List.generate(7, (i) => Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: ChoiceChip(
          label: Text(DateHelper.formatDayOfWeek(i + 1, Localizations.localeOf(context).languageCode).substring(0, 4), style: TextStyle(fontSize: 11, color: _dayOfWeek == i + 1 ? ShellTokens.chromeBase : ShellTokens.textPrimary)),
          selected: _dayOfWeek == i + 1, onSelected: (_) { _dayOfWeek = i + 1; _checkConflicts(); setState(() {}); },
          selectedColor: ShellTokens.accent, backgroundColor: ShellTokens.chromeBase, side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ))))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _timeField(_startTime, l10n.startTime, (t) { _startTime = t; _checkConflicts(); })),
          const SizedBox(width: 12),
          Expanded(child: _timeField(_endTime, l10n.endTime, (t) { _endTime = t; _checkConflicts(); })),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextFormField(controller: _monthlyPriceCtrl, decoration: ShellInputDecoration.textField(hintText: l10n.monthlyPrice), keyboardType: TextInputType.number, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))),
          const SizedBox(width: 12),
          Expanded(child: TextFormField(controller: _sessionsCountCtrl, decoration: ShellInputDecoration.textField(hintText: l10n.sessionsPerMonth), keyboardType: TextInputType.number, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))),
        ]),
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.teacherShare),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: RadioListTile<String>(title: Text(l10n.teacherDefaultRate(teacherDefaultRate), style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)), value: 'default', groupValue: _salaryMode, onChanged: (v) => setState(() => _salaryMode = v!), contentPadding: EdgeInsets.zero, dense: true, activeColor: ShellTokens.accent)),
          Expanded(child: RadioListTile<String>(title: Text(l10n.overrideRate, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)), value: 'override', groupValue: _salaryMode, onChanged: (v) => setState(() => _salaryMode = v!), contentPadding: EdgeInsets.zero, dense: true, activeColor: ShellTokens.accent)),
        ]),
        if (_salaryMode == 'override') ...[
          const SizedBox(height: 6),
          if (_selectedTeacher?.salaryType == 'percentage')
            TextFormField(controller: _overridePctCtrl, decoration: ShellInputDecoration.textField(hintText: '%'), keyboardType: TextInputType.number, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))
          else
            TextFormField(controller: _overrideFixedCtrl, decoration: ShellInputDecoration.textField(hintText: 'DA'), keyboardType: TextInputType.number, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        ],
        if (teacherConflict || classroomConflict || groupConflict) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: SemanticTokens.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: SemanticTokens.error.withValues(alpha: 0.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (teacherConflict) Text(l10n.conflictTeacher, style: const TextStyle(fontSize: 11, color: SemanticTokens.error)),
              if (classroomConflict) Text(l10n.conflictClassroom, style: const TextStyle(fontSize: 11, color: SemanticTokens.error)),
              if (!teacherConflict && !classroomConflict && groupConflict) Text(l10n.conflictGroupWarning, style: const TextStyle(fontSize: 11, color: SemanticTokens.warning)),
            ]),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: _saving ? null : _save, style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)), child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create))),
      ])),
    );
  }

  Widget _timeField(TimeOfDay value, String label, ValueChanged<TimeOfDay> onChanged) {
    return GestureDetector(
      onTap: () async { final t = await showTimePicker(context: context, initialTime: value); if (t != null) { onChanged(t); setState(() {}); } },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(color: ShellTokens.chromeBase, borderRadius: BorderRadius.circular(6), border: Border.all(color: ShellTokens.chromeBorder)),
        child: Row(children: [
          Expanded(child: Text('${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))),
          Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
          const SizedBox(width: 4),
          const Icon(PhosphorIcons.clock, size: 14, color: ShellTokens.textSecondary),
        ]),
      ),
    );
  }
}

class _SessionDetailDialog extends StatefulWidget {
  final AppDatabase database;
  final Session session;
  final AppLocalizations l10n;
  const _SessionDetailDialog({required this.database, required this.session, required this.l10n});
  @override
  State<_SessionDetailDialog> createState() => _SessionDetailDialogState();
}

class _SessionDetailDialogState extends State<_SessionDetailDialog> {
  List<Map<String, dynamic>> _attendanceHistory = [];
  List<Enrollment> _enrollments = [];
  String _groupName = '';
  String _teacherName = '';
  String _roomName = '';
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final group = await SubjectGroupRepository(widget.database).getById(widget.session.subjectGroupId);
    final teacher = await TeacherRepository(widget.database).getById(widget.session.teacherId);
    final room = await ClassroomRepository(widget.database).getById(widget.session.classroomId);
    final enrollments = await EnrollmentRepository(widget.database).getBySubjectGroup(widget.session.subjectGroupId);
    final history = await widget.database.getSessionAttendanceHistory(widget.session.id);
    if (mounted) setState(() {
      _groupName = group?.nameAr ?? widget.session.subjectGroupId;
      _teacherName = teacher != null ? '${teacher.firstNameAr} ${teacher.lastNameAr}' : widget.session.teacherId;
      _roomName = room?.nameAr ?? widget.session.classroomId;
      _enrollments = enrollments;
      _attendanceHistory = history;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    if (_loading) return const Dialog(child: SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: ShellTokens.accent))));
    final s = widget.session;

    return ShellDialog(
      maxWidth: 520,
      title: _groupName,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: l10n.personalInfo),
        const SizedBox(height: 8),
        _infoRow(l10n.dayOfWeek, DateHelper.formatDayOfWeek(s.dayOfWeek, Localizations.localeOf(context).languageCode)),
        _infoRow(l10n.time, '${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')} - ${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}'),
        _infoRow(l10n.teacher, _teacherName),
        _infoRow(l10n.classroom, _roomName),
        _infoRow(l10n.monthlyPrice, '${s.monthlyPrice.toStringAsFixed(0)} DA'),
        _infoRow(l10n.sessionsPerMonth, '${s.sessionsPerMonth}'),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.enrolledStudents),
        const SizedBox(height: 8),
        if (_enrollments.isEmpty)
          Text(l10n.noEnrollments, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))
        else
          ..._enrollments.map((e) => _EnrolledStudentRow(enrollment: e, database: widget.database)),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.sessionAttendanceHistory),
        const SizedBox(height: 8),
        if (_attendanceHistory.isEmpty)
          Text(l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))
        else
          ..._attendanceHistory.take(20).map((a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              Expanded(child: Text(a['student_first_name'] != null ? '${a['student_first_name']} ${a['student_last_name']} (${a['student_code']})' : '${a['person_type']}', style: const TextStyle(fontSize: 10, color: ShellTokens.textPrimary))),
              Text(_fmtDate(a['attendance_date'] as DateTime), style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary)),
              if ((a['is_cancelled'] as int?) == 1)
                ShellBadge(label: l10n.cancelled, color: SemanticTokens.warning),
              if ((a['is_school_closed'] as int?) == 1)
                ShellBadge(label: l10n.schoolClosed, color: SemanticTokens.error),
            ]),
          )),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
      ]),
    );
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _EnrolledStudentRow extends StatefulWidget {
  final Enrollment enrollment;
  final AppDatabase database;
  const _EnrolledStudentRow({required this.enrollment, required this.database});
  @override
  State<_EnrolledStudentRow> createState() => _EnrolledStudentRowState();
}

class _EnrolledStudentRowState extends State<_EnrolledStudentRow> {
  String _studentName = '';
  String _code = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final repo = StudentRepository(widget.database);
    final s = await repo.getById(widget.enrollment.studentId);
    if (mounted && s != null) setState(() { _studentName = '${s.firstNameAr} ${s.lastNameAr}'; _code = s.code; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.enrollment.status == 'active' ? SemanticTokens.success : ShellTokens.textDisabled, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(_studentName.isEmpty ? widget.enrollment.studentId : _studentName, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
        if (_code.isNotEmpty) Text(_code, style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary)),
      ]),
    );
  }
}
