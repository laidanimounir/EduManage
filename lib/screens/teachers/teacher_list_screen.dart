import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/teacher_subject_group_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/audit_log_repository.dart';
import '../../repositories/session_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_pagination_bar.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';

class TeacherListScreen extends StatefulWidget {
  final AppDatabase database;
  const TeacherListScreen({super.key, required this.database});
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  late final TeacherRepository _repo;
  late final TeacherSubjectGroupRepository _junctionRepo;
  late final SubjectGroupRepository _groupRepo;
  List<Teacher> _rows = [];
  int _total = 0;
  int _page = 0;
  int _pageSize = 20;
  bool _loading = true;
  String _statusFilter = 'all';
  String _searchQuery = '';
  String _sortColumn = '';
  bool _sortAsc = true;
  Set<String> _selectedIds = {};
  Map<String, List<TeacherSubjectGroup>> _junctionCache = {};
  Map<String, String> _subjectNamesCache = {};
  Map<String, bool> _overdueCache = {};
  Set<String> _teachingNowIds = {};
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo = TeacherRepository(widget.database);
    _junctionRepo = TeacherSubjectGroupRepository(widget.database);
    _groupRepo = SubjectGroupRepository(widget.database);
    _fetchPage();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    final result = await _repo.fetchPage(
      offset: _page * _pageSize,
      limit: _pageSize,
      statusFilter: _statusFilter,
      searchQuery: _searchQuery,
    );
    _junctionCache.clear();
    _subjectNamesCache.clear();
    _overdueCache.clear();
    if (mounted) setState(() { _rows = result.teachers; _total = result.total; _loading = false; });
    _preloadSubjectNames();
    _preloadOverdueStatus();
    _preloadTeachingNow();
  }

  void _onStatusFilterChanged(String v) { _statusFilter = v; _page = 0; _fetchPage(); }
  void _onSearchChanged(String v) { _searchQuery = v; _page = 0; _fetchPage(); }
  void _clearFilters() { _searchCtrl.clear(); _searchQuery = ''; _statusFilter = 'all'; _page = 0; _fetchPage(); }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == _rows.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = _rows.map((t) => t.id).toSet();
      }
    });
  }

  void _openDetail(Teacher t) {
    showDialog(
      context: context,
      builder: (_) => _TeacherDetailDialog(
        database: widget.database,
        teacher: t,
        l10n: AppLocalizations.of(context),
      ),
    ).then((_) => _fetchPage());
  }

  void _openEdit(Teacher? t) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _TeacherEditDialog(
        database: widget.database,
        teacher: t,
        l10n: AppLocalizations.of(context),
      ),
    );
    if (result == true) _fetchPage();
  }

  Future<void> _confirmArchive(Teacher t) async {
    final l10n = AppLocalizations.of(context);
    final hasTxns = await widget.database.hasTeacherTransactions(t.id);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: Text(l10n.archiveTeacher, style: const TextStyle(color: ShellTokens.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.archiveTeacherConfirm, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
            if (hasTxns) ...[
              const SizedBox(height: 10),
              Row(children: [
                const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.archiveTeacherWarning, style: const TextStyle(color: SemanticTokens.warning, fontSize: 12))),
              ]),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.archive, style: const TextStyle(color: SemanticTokens.error))),
        ],
      ),
    );
    if (confirmed == true) {
      if (t.isArchived) {
        await _repo.restore(t.id);
      } else {
        await _repo.archive(t.id);
        final auditRepo = AuditLogRepository(widget.database);
        await auditRepo.create(AuditLogCompanion(
          userId: const Value('system'),
          action: const Value('teacher_archived'),
          entityType: const Value('teacher'),
          entityId: Value(t.id),
          details: Value('Archived teacher: ${t.firstNameAr} ${t.lastNameAr}'),
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
    final hasFilters = _searchQuery.isNotEmpty || _statusFilter != 'all';

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(
        children: [
          if (hasSelection) _buildSelectionBar(l10n),
          _buildToolbar(l10n, hasFilters),
          Expanded(child: _buildBody(l10n)),
          if (!_loading && _total > 0) _buildPaginationBar(l10n, totalPages),
        ],
      ),
    );
  }

  Widget _buildSelectionBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 8, bottom: 8),
      decoration: const BoxDecoration(
        color: ShellTokens.accentMuted,
        border: Border(bottom: BorderSide(color: ShellTokens.accent)),
      ),
      child: Row(children: [
        Text('${_selectedIds.length} ${l10n.selected}', style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        const Spacer(),
        TextButton.icon(
          onPressed: _toggleSelectAll,
          icon: Icon(_selectedIds.length == _rows.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16),
          label: Text(_selectedIds.length == _rows.length ? l10n.clearSelection : l10n.selectAll),
          style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary),
        ),
      ]),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n, bool hasFilters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(children: [
        Row(children: [
          Expanded(child: SizedBox(height: 34, child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
            decoration: ShellInputDecoration.textField(
              hintText: l10n.search,
              prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary),
              suffixIcon: hasFilters ? IconButton(
                icon: const Icon(PhosphorIcons.arrowLeft, size: 14, color: ShellTokens.textSecondary),
                onPressed: _clearFilters, tooltip: l10n.clearFilters,
              ) : null,
              fillColor: ShellTokens.chromeSurface,
            ),
            onChanged: _onSearchChanged,
          ))),
          const SizedBox(width: 8),
          SizedBox(height: 34, child: FilledButton.icon(
            onPressed: () => _openEdit(null),
            icon: const Icon(PhosphorIcons.plus, size: 14),
            label: Text(l10n.add, style: const TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 12)),
          )),
          const SizedBox(width: 6),
          SizedBox(height: 34, child: IconButton(
            icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary),
            onPressed: () => _exportPdf(l10n),
            tooltip: l10n.exportPdf,
            style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          )),
          const SizedBox(width: 4),
          SizedBox(height: 34, child: IconButton(
            icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary),
            onPressed: () => _exportExcel(l10n),
            tooltip: l10n.exportExcel,
            style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          )),
        ]),
        const SizedBox(height: 8),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          ShellFilterChip(label: l10n.all, selected: _statusFilter == 'all', onTap: () => _onStatusFilterChanged('all')),
          ShellFilterChip(label: l10n.active, selected: _statusFilter == 'active', onTap: () => _onStatusFilterChanged('active')),
          ShellFilterChip(label: l10n.ended, selected: _statusFilter == 'ended', onTap: () => _onStatusFilterChanged('ended')),
          ShellFilterChip(label: l10n.archived, selected: _statusFilter == 'archived', onTap: () => _onStatusFilterChanged('archived')),
        ])),
      ]),
    );
  }

  void _exportPdf(AppLocalizations l10n) {}
  void _exportExcel(AppLocalizations l10n) {}

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    return Column(children: [
      Table(
        columnWidths: _columnWidths(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)),
        children: [_buildHeaderRow(l10n)],
      ),
      Expanded(child: SingleChildScrollView(child: Table(
        columnWidths: _columnWidths(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)),
        children: _rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)).toList(),
      ))),
    ]);
  }

  Map<int, TableColumnWidth> _columnWidths() => const {
    0: FixedColumnWidth(44),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(1),
    3: FlexColumnWidth(1),
    4: FlexColumnWidth(1.2),
    5: FlexColumnWidth(1.2),
    6: IntrinsicColumnWidth(),
  };

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(
      decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
      children: [
        _buildHeaderCell(PhosphorIcons.checkSquare, null, l10n),
        _buildHeaderCell(null, l10n.columnName, l10n),
        _buildHeaderCell(null, l10n.code, l10n),
        _buildHeaderCell(null, l10n.columnSalary, l10n),
        _buildHeaderCell(null, l10n.columnSubjects, l10n),
        _buildHeaderCell(null, l10n.columnPayoutStatus, l10n),
        _buildHeaderCell(PhosphorIcons.gear, null, l10n),
      ],
    );
  }

  Widget _buildHeaderCell(IconData? icon, String? label, AppLocalizations l10n) {
    return GestureDetector(
      onTap: label != null ? () => _onSort(label) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null)
            InkWell(onTap: _toggleSelectAll, child: Icon(icon, size: 14, color: ShellTokens.textSecondary))
          else ...[
            Text(label ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
            if (_sortColumn == label)
              Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: ShellTokens.textSecondary),
          ],
        ]),
      ),
    );
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) { _sortAsc = !_sortAsc; } else { _sortColumn = column; _sortAsc = true; }
      _rows.sort((a, b) {
        int cmp = switch (column) {
          _ => a.firstNameAr.compareTo(b.firstNameAr),
        };
        return _sortAsc ? cmp : -cmp;
      });
    });
  }

  TableRow _buildDataRow(Teacher t, int index, AppLocalizations l10n) {
    final isSelected = _selectedIds.contains(t.id);
    final isEven = index.isEven;
    final ended = t.employmentEndDate != null;
    final overdue = _overdueCache[t.id] ?? false;
    final isTeachingNow = _teachingNowIds.contains(t.id);

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected ? ShellTokens.accentMuted.withValues(alpha: 0.3)
            : isTeachingNow ? SemanticTokens.success.withValues(alpha: 0.08)
            : ended ? SemanticTokens.warning.withValues(alpha: 0.06)
            : isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3),
      ),
      children: [
        _buildCheckCell(t, isSelected),
        GestureDetector(onTap: () => _openDetail(t), child: _buildNameCellContent(t, overdue, isTeachingNow, l10n)),
        GestureDetector(onTap: () => _openDetail(t), behavior: HitTestBehavior.opaque, child: _buildTextCell(t.code)),
        GestureDetector(onTap: () => _openDetail(t), behavior: HitTestBehavior.opaque, child: _buildTextCell(_salaryLabel(t.salaryType, l10n))),
        GestureDetector(onTap: () => _openDetail(t), behavior: HitTestBehavior.opaque, child: _buildTextCell(_subjectNamesCache[t.id] ?? '...')),
        GestureDetector(onTap: () => _openDetail(t), behavior: HitTestBehavior.opaque, child: isTeachingNow ? ShellBadge(label: l10n.liveNow.replaceAll('● ', ''), color: SemanticTokens.success) : overdue ? ShellBadge(label: l10n.overdue, color: const Color(0xFFC2823A)) : const SizedBox.shrink()),
        _buildActionsCell(t),
      ],
    );
  }

  Widget _buildCheckCell(Teacher t, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() { if (isSelected) { _selectedIds.remove(t.id); } else { _selectedIds.add(t.id); } }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Container(
          width: 14, height: 14,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), border: Border.all(color: isSelected ? ShellTokens.accent : ShellTokens.textDisabled, width: 1.5), color: isSelected ? ShellTokens.accent : Colors.transparent),
          child: isSelected ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null,
        ),
      ),
    );
  }

  Widget _buildTextCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(text, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildNameCellContent(Teacher t, bool overdue, bool isTeachingNow, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(t.firstNameAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          if (t.firstNameFr != null && t.firstNameFr!.isNotEmpty)
            Text(t.firstNameFr!, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
        if (t.employmentEndDate != null)
          ShellBadge(label: l10n.ended, color: const Color(0xFFC2823A)),
      ]),
    );
  }

  Widget _buildActionsCell(Teacher t) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
      IconButton(icon: Icon(t.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 13), onPressed: () => _confirmArchive(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: t.isArchived ? ShellTokens.accent : ShellTokens.textSecondary),
    ]);
  }

  Future<void> _preloadSubjectNames() async {
    for (final t in _rows) {
      final junctions = _junctionCache[t.id] ?? await _junctionRepo.getByTeacher(t.id);
      _junctionCache[t.id] = junctions;
      if (junctions.isEmpty) {
        _subjectNamesCache[t.id] = '—';
        continue;
      }
      final names = <String>[];
      for (final j in junctions) {
        final g = await _groupRepo.getById(j.subjectGroupId);
        if (g != null) names.add(g.nameAr);
      }
      _subjectNamesCache[t.id] = names.isEmpty ? '—' : names.join(', ');
    }
    if (mounted) setState(() {});
  }

  Future<void> _preloadOverdueStatus() async {
    for (final t in _rows) {
      if (t.overdueThresholdDays == null) { _overdueCache[t.id] = false; continue; }
      final lastPayout = await widget.database.getTeacherLastPayoutDate(t.id);
      if (lastPayout == null) { _overdueCache[t.id] = true; continue; }
      final daysSince = DateTime.now().difference(lastPayout).inDays;
      _overdueCache[t.id] = daysSince > t.overdueThresholdDays!;
    }
    if (mounted) setState(() {});
  }

  Future<void> _preloadTeachingNow() async {
    final now = DateTime.now();
    for (final t in _rows) {
      final sessions = await SessionRepository(widget.database).getByTeacher(t.id);
      for (final s in sessions) {
        if (await widget.database.isSessionHappeningNow(s.id, now)) {
          _teachingNowIds.add(t.id);
          break;
        }
      }
    }
    if (mounted) setState(() {});
  }

  String _salaryLabel(String salaryType, AppLocalizations l10n) {
    return salaryType == 'percentage' ? l10n.salaryTypePercentage : l10n.salaryTypeFixed;
  }

  Widget _buildPaginationBar(AppLocalizations l10n, int totalPages) {
    final first = _page * _pageSize + 1;
    final last = (_page * _pageSize + _rows.length).clamp(0, _total);
    return ShellPaginationBar(
      page: _page,
      pageSize: _pageSize,
      rowCount: _rows.length,
      total: _total,
      onPrevious: () { _page--; _fetchPage(); },
      onNext: () { _page++; _fetchPage(); },
      showingResultsText: l10n.showingResults('$first', '$last', '$_total'),
    );
  }
}

class _TeacherDetailDialog extends StatelessWidget {
  final AppDatabase database;
  final Teacher teacher;
  final AppLocalizations l10n;
  const _TeacherDetailDialog({required this.database, required this.teacher, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 520,
      title: '${teacher.firstNameAr} ${teacher.lastNameAr}',
      onClose: () => Navigator.pop(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildAvatar(),
        const SizedBox(height: 12),
        ShellSectionHeader(text: l10n.personalInfo),
        const SizedBox(height: 8),
        _infoRow(l10n.code, teacher.code),
        _infoRow(l10n.firstName, '${teacher.firstNameAr} / ${teacher.firstNameFr ?? '—'}'),
        _infoRow(l10n.lastName, '${teacher.lastNameAr} / ${teacher.lastNameFr ?? '—'}'),
        _infoRow(l10n.phone, teacher.phone ?? '—'),
        _infoRow(l10n.email, teacher.email ?? '—'),
        _infoRow(l10n.idCard, teacher.idCard ?? '—'),
        _infoRow(l10n.gender, teacher.gender == 'male' ? l10n.male : teacher.gender == 'female' ? l10n.female : '—'),
        _infoRow(l10n.salaryType, teacher.salaryType == 'percentage' ? l10n.salaryTypePercentage : l10n.salaryTypeFixed),
        _infoRow(l10n.employmentStartDate, teacher.employmentStartDate != null ? _fmtDate(teacher.employmentStartDate!) : '—'),
        _infoRow(l10n.employmentEndDate, teacher.employmentEndDate != null ? _fmtDate(teacher.employmentEndDate!) : '—'),
        if (teacher.overdueThresholdDays != null) _infoRow(l10n.overdueThresholdDays, '${teacher.overdueThresholdDays}'),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.teacherSubjects),
        const SizedBox(height: 8),
        _SubjectList(database: database, teacherId: teacher.id, l10n: l10n),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.teacherFinancialStatus),
        const SizedBox(height: 8),
        _TeacherFinancialSummary(database: database, teacherId: teacher.id, l10n: l10n),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.perSessionEarnings),
        const SizedBox(height: 8),
        _PerSessionEarningsList(database: database, teacherId: teacher.id, l10n: l10n),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.teacherPayoutHistory),
        const SizedBox(height: 8),
        _PayoutHistoryList(database: database, teacherId: teacher.id, l10n: l10n),
        const SizedBox(height: 16),
        ShellSectionHeader(text: l10n.salaryChangeHistory),
        const SizedBox(height: 8),
        _SalaryHistoryList(database: database, teacherId: teacher.id, l10n: l10n),
      ]),
      actions: Row(children: [
        IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 16), color: ShellTokens.textSecondary, onPressed: () {
          Navigator.pop(context);
          showDialog(context: context, builder: (_) => _TeacherEditDialog(database: database, teacher: teacher, l10n: l10n));
        }),
        const Spacer(),
        TextButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
              backgroundColor: ShellTokens.chromeSurface,
              title: Text(teacher.isArchived ? l10n.restoreTeacher : l10n.archiveTeacher, style: const TextStyle(color: ShellTokens.textPrimary)),
              content: Text(teacher.isArchived ? l10n.archiveTeacherConfirm : l10n.archiveTeacherConfirm, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
                TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(teacher.isArchived ? l10n.restore : l10n.archive, style: const TextStyle(color: SemanticTokens.error))),
              ],
            ));
            if (confirmed == true) {
              final repo = TeacherRepository(database);
              final auditRepo = AuditLogRepository(database);
              if (teacher.isArchived) {
                await repo.restore(teacher.id);
              } else {
                await repo.archive(teacher.id);
                await auditRepo.create(AuditLogCompanion(
                  userId: const Value('system'),
                  action: const Value('teacher_archived'),
                  entityType: const Value('teacher'),
                  entityId: Value(teacher.id),
                  details: Value('Archived teacher: ${teacher.firstNameAr} ${teacher.lastNameAr}'),
                ));
              }
              if (context.mounted) Navigator.pop(context);
            }
          },
          icon: Icon(teacher.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 14, color: teacher.isArchived ? ShellTokens.accent : SemanticTokens.error),
          label: Text(teacher.isArchived ? l10n.restoreTeacher : l10n.archiveTeacher, style: TextStyle(fontSize: 11, color: teacher.isArchived ? ShellTokens.accent : SemanticTokens.error)),
        ),
      ]),
    );
  }

  Widget _buildAvatar() {
    if (teacher.photoPath != null && teacher.photoPath!.isNotEmpty) {
      return ClipOval(child: Image.file(File(teacher.photoPath!), width: 44, height: 44, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _defaultAvatar()));
    }
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return CircleAvatar(radius: 22, backgroundColor: ShellTokens.accentMuted, child: Text(teacher.firstNameAr[0], style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)));
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
      ]),
    );
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _SubjectList extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  const _SubjectList({required this.database, required this.teacherId, required this.l10n});
  @override
  State<_SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<_SubjectList> {
  List<SubjectGroup> _groups = [];
  Map<String, List<Session>> _groupSessions = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final repo = TeacherSubjectGroupRepository(widget.database);
    final assigned = await repo.getAssignedGroups(widget.teacherId);
    final sessionRepo = SessionRepository(widget.database);
    final sessions = await sessionRepo.getByTeacher(widget.teacherId);
    final groupSessionMap = <String, List<Session>>{};
    for (final s in sessions) {
      groupSessionMap.putIfAbsent(s.subjectGroupId, () => []).add(s);
    }
    if (mounted) setState(() { _groups = assigned; _groupSessions = groupSessionMap; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_groups.isEmpty) return Text(widget.l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    final days = ['', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return Column(children: _groups.map((g) {
      final groupSessions = _groupSessions[g.id] ?? [];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(g.nameAr, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            Text(_levelLabel(g.schoolLevel, widget.l10n), style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
          ]),
          if (groupSessions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(children: groupSessions.map((s) => Text(
                '${days[s.dayOfWeek]} ${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled),
              )).toList()),
            ),
        ]),
      );
    }).toList());
  }

  String _levelLabel(String? level, AppLocalizations l10n) {
    return switch (level) {
      'primary' => l10n.schoolLevelPrimary,
      'middle' => l10n.schoolLevelMiddle,
      'secondary' => l10n.schoolLevelSecondary,
      _ => level ?? '—',
    };
  }
}

class _TeacherFinancialSummary extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  const _TeacherFinancialSummary({required this.database, required this.teacherId, required this.l10n});
  @override
  State<_TeacherFinancialSummary> createState() => _TeacherFinancialSummaryState();
}

class _TeacherFinancialSummaryState extends State<_TeacherFinancialSummary> {
  double _earned = 0;
  double _paid = 0;
  double _balance = 0;
  int _attendanceCount = 0;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final e = await widget.database.getTeacherTotalEarned(widget.teacherId);
    final p = await widget.database.getTeacherTotalPaid(widget.teacherId);
    final a = await widget.database.getTeacherAttendanceCount(widget.teacherId);
    if (mounted) setState(() { _earned = e; _paid = p; _balance = e - p; _attendanceCount = a; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 40, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    return Column(children: [
      _finRow(widget.l10n.teacherTotalEarned, _earned, ShellTokens.textPrimary),
      _finRow(widget.l10n.totalPaid, _paid, SemanticTokens.success),
      const Divider(height: 16, color: ShellTokens.chromeBorder),
      _finRow(widget.l10n.teacherBalance, _balance, _balance > 0 ? SemanticTokens.error : SemanticTokens.success, bold: true),
      const SizedBox(height: 6),
      _finRow(widget.l10n.teacherAttendanceCount, _attendanceCount.toDouble(), ShellTokens.textSecondary),
    ]);
  }

  Widget _finRow(String label, double amount, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
        Text(label.contains('Count') ? '$amount' : '${amount.toStringAsFixed(0)} DA', style: TextStyle(fontSize: 11, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: color)),
      ]),
    );
  }
}

class _PerSessionEarningsList extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  const _PerSessionEarningsList({required this.database, required this.teacherId, required this.l10n});
  @override
  State<_PerSessionEarningsList> createState() => _PerSessionEarningsListState();
}

class _PerSessionEarningsListState extends State<_PerSessionEarningsList> {
  List<Map<String, dynamic>> _earnings = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    _earnings = await widget.database.getTeacherSessionEarnings(widget.teacherId);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_earnings.isEmpty) return Text(widget.l10n.noData, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));

    final days = ['', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return Column(children: _earnings.map((e) {
      final day = days[e['day_of_week'] as int? ?? 0];
      final h = (e['start_time'] as DateTime).hour;
      final m = (e['start_time'] as DateTime).minute.toString().padLeft(2, '0');
      final att = e['attendance_count'] ?? 0;
      final paid = (e['paid'] as double?) ?? 0.0;
      final deducted = (e['deducted'] as double?) ?? 0.0;
      final monthPrice = (e['monthly_price'] as double?) ?? 0.0;
      final sessionsPerMonth = (e['sessions_per_month'] as int?) ?? 1;
      final perSessionPrice = sessionsPerMonth > 0 ? monthPrice / sessionsPerMonth : 0.0;
      final sharePct = e['teacher_share_pct'] as double?;
      final fixedAmt = e['teacher_fixed_amount'] as double?;
      final rateStr = fixedAmt != null ? '${fixedAmt.toStringAsFixed(0)} DA' : sharePct != null ? '${sharePct.toStringAsFixed(0)}%' : 'def';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e['group_name'] ?? ''}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
            Text('$day $h:$m · Rate: $rateStr · $att @{widget.l10n.attendance.toLowerCase()} · ${perSessionPrice.toStringAsFixed(0)}/session', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${paid.toStringAsFixed(0)} DA', style: const TextStyle(fontSize: 11, color: SemanticTokens.success, fontWeight: FontWeight.w600)),
            if (deducted > 0) Text('-${deducted.toStringAsFixed(0)} DA', style: const TextStyle(fontSize: 9, color: SemanticTokens.error)),
          ]),
        ]),
      );
    }).toList());
  }
}

class _PayoutHistoryList extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  const _PayoutHistoryList({required this.database, required this.teacherId, required this.l10n});
  @override
  State<_PayoutHistoryList> createState() => _PayoutHistoryListState();
}

class _PayoutHistoryListState extends State<_PayoutHistoryList> {
  List<Transaction> _txns = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    _txns = await widget.database.getTeacherPayoutHistory(widget.teacherId);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    return Column(children: [
      if (_txns.isNotEmpty) ..._txns.take(10).map((tx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(_fmtDate(tx.transactionDate), style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))),
          Text('${tx.amount.toStringAsFixed(0)} DA', style: const TextStyle(fontSize: 11, color: SemanticTokens.success, fontWeight: FontWeight.w600)),
        ]),
      )),
      if (_txns.isEmpty) Text(widget.l10n.noTeacherPayouts, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled)),
      const SizedBox(height: 8),
      FilledButton.icon(
        onPressed: () => _payNow(),
        icon: const Icon(PhosphorIcons.currencyCircleDollar, size: 14),
        label: Text(widget.l10n.payTeacher, style: const TextStyle(fontSize: 12)),
        style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
      ),
    ]);
  }

  Future<void> _payNow() async {
    final sessions = await SessionRepository(widget.database).getByTeacher(widget.teacherId);
    final activeSessions = sessions.where((s) => s.isActive).toList();
    if (activeSessions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.noTeacherSessions), backgroundColor: ShellTokens.chromeSurface));
      return;
    }

    if (!mounted) return;
    final result = await showDialog<_PayNowResult>(
      context: context,
      builder: (ctx) => _PayNowDialog(
        database: widget.database,
        teacherId: widget.teacherId,
        sessions: activeSessions,
        l10n: widget.l10n,
      ),
    );

    if (result != null && result.confirmed && mounted) {
      final txService = TransactionService(widget.database);
      int successCount = 0;
      int skippedCount = 0;
      for (final s in result.selectedSessions) {
        try {
          await txService.createTeacherPayout(
            teacherId: widget.teacherId,
            sessionId: s.id,
            date: result.date,
          );
          successCount++;
        } on StateError {
          skippedCount++;
        } catch (_) {
          skippedCount++;
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payout recorded for $successCount session(s)${skippedCount > 0 ? ' ($skippedCount skipped)' : ''}'),
          backgroundColor: ShellTokens.chromeSurface));
      }
      _load();
    }
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _PayNowResult {
  final bool confirmed;
  final List<Session> selectedSessions;
  final DateTime date;
  const _PayNowResult({required this.confirmed, required this.selectedSessions, required this.date});
}

class _PayNowDialog extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final List<Session> sessions;
  final AppLocalizations l10n;

  const _PayNowDialog({
    required this.database,
    required this.teacherId,
    required this.sessions,
    required this.l10n,
  });

  @override
  State<_PayNowDialog> createState() => _PayNowDialogState();
}

class _PayNowDialogState extends State<_PayNowDialog> {
  Set<String> _selectedIds = {};
  DateTime _date = DateTime.now();
  Map<String, int> _attendanceCounts = {};
  Map<String, double> _amounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.sessions.map((s) => s.id).toSet();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final dateStart = DateTime(_date.year, _date.month, _date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    for (final s in widget.sessions) {
      final result = await widget.database.customSelect(
        'SELECT COUNT(*) AS cnt FROM attendance WHERE session_id = ? AND person_type = \'student\' AND attendance_date >= ? AND attendance_date < ?',
        variables: [Variable.withString(s.id), Variable.withDateTime(dateStart), Variable.withDateTime(dateEnd)],
      ).getSingle();
      _attendanceCounts[s.id] = result.read<int>('cnt');

      final teacher = await TeacherRepository(widget.database).getById(widget.teacherId);
      double amount = 0;
      final effFixed = s.teacherFixedAmount ?? teacher?.teacherFixedAmount;
      final effShare = s.teacherSharePct ?? teacher?.teacherSharePct;
      final salaryType = (s.teacherFixedAmount != null || s.teacherSharePct != null)
          ? (s.teacherFixedAmount != null ? 'fixed' : 'percentage')
          : teacher?.salaryType ?? 'percentage';

      if (effFixed != null && salaryType == 'fixed') {
        amount = effFixed;
      } else if (effShare != null && s.sessionsPerMonth > 0) {
        final perSession = s.monthlyPrice / s.sessionsPerMonth;
        amount = perSession * effShare / 100 * result.read<int>('cnt');
      }
      _amounts[s.id] = amount;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _changeDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() { _date = d; _loading = true; });
      _loadCounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _selectedIds.fold<double>(0, (sum, id) => sum + (_amounts[id] ?? 0));
    return ShellDialog(
      maxWidth: 520, maxHeight: 600, title: widget.l10n.payTeacher,
      body: _loading
          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${widget.l10n.date}: ', style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
          GestureDetector(
            onTap: _changeDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: ShellTokens.chromeBase, borderRadius: BorderRadius.circular(4), border: Border.all(color: ShellTokens.chromeBorder)),
              child: Text('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        ShellSectionHeader(text: widget.l10n.sessions, withBorder: true),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sessions.length,
            itemBuilder: (_, i) {
              final s = widget.sessions[i];
              final selected = _selectedIds.contains(s.id);
              final count = _attendanceCounts[s.id] ?? 0;
              final amount = _amounts[s.id] ?? 0;
              return CheckboxListTile(
                value: selected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) { _selectedIds.add(s.id); } else { _selectedIds.remove(s.id); }
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(_sessionLabel(s), style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                subtitle: Text('$count ${widget.l10n.students} — ${amount.toStringAsFixed(0)} DA',
                  style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
                activeColor: ShellTokens.accent,
                checkColor: ShellTokens.chromeBase,
              );
            },
          ),
        ),
        const Divider(color: ShellTokens.chromeBorder),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Text('${widget.l10n.totalPaid}: ', style: const TextStyle(fontSize: 13, color: ShellTokens.textSecondary)),
            Text('${total.toStringAsFixed(0)} DA',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SemanticTokens.success)),
          ]),
        ),
      ]),
      actions: Row(children: [
        Expanded(child: TextButton(
          onPressed: () => Navigator.pop(context, _PayNowResult(confirmed: false, selectedSessions: [], date: _date)),
          child: Text(widget.l10n.cancel, style: const TextStyle(color: ShellTokens.textSecondary)),
        )),
        const SizedBox(width: 8),
        Expanded(child: FilledButton(
          onPressed: _selectedIds.isEmpty ? null : () => Navigator.pop(context, _PayNowResult(
            confirmed: true,
            selectedSessions: widget.sessions.where((s) => _selectedIds.contains(s.id)).toList(),
            date: _date,
          )),
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase),
          child: Text(widget.l10n.confirm),
        )),
      ]),
    );
  }

  String _sessionLabel(Session s) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final day = days[s.dayOfWeek - 1];
    final startH = s.startTime.hour.toString().padLeft(2, '0');
    final startM = s.startTime.minute.toString().padLeft(2, '0');
    final endH = s.endTime.hour.toString().padLeft(2, '0');
    final endM = s.endTime.minute.toString().padLeft(2, '0');
    return '$day $startH:$startM–$endH:$endM';
  }
}



class _SalaryHistoryList extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  const _SalaryHistoryList({required this.database, required this.teacherId, required this.l10n});
  @override
  State<_SalaryHistoryList> createState() => _SalaryHistoryListState();
}

class _SalaryHistoryListState extends State<_SalaryHistoryList> {
  List<AuditLogData> _logs = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final repo = AuditLogRepository(widget.database);
    final logs = await repo.getByEntity('teacher', widget.teacherId);
    if (mounted) setState(() { _logs = logs.where((l) => l.action == 'teacher_salary_changed').toList(); _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_logs.isEmpty) return Text(widget.l10n.noSalaryChanges, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));
    return Column(children: _logs.take(5).map((l) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(_fmtDate(l.timestamp), style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary))),
        Expanded(child: Text(l.details ?? '', style: const TextStyle(fontSize: 10, color: ShellTokens.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]),
    )).toList());
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _TeacherEditDialog extends StatefulWidget {
  final AppDatabase database;
  final Teacher? teacher;
  final AppLocalizations l10n;
  const _TeacherEditDialog({required this.database, this.teacher, required this.l10n});
  @override
  State<_TeacherEditDialog> createState() => _TeacherEditDialogState();
}

class _TeacherEditDialogState extends State<_TeacherEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TeacherRepository _repo;
  late final TeacherSubjectGroupRepository _junctionRepo;
  bool _saving = false;
  bool _isEdit = false;
  File? _photo;

  late TextEditingController _codeCtrl, _firstNameArCtrl, _lastNameArCtrl, _firstNameFrCtrl, _lastNameFrCtrl;
  late TextEditingController _phoneCtrl, _addressCtrl, _emailCtrl, _idCardCtrl;
  late TextEditingController _sharePctCtrl, _fixedAmountCtrl, _overdueThresholdCtrl;
  String _gender = 'male';
  String _salaryType = 'percentage';
  DateTime? _startDate, _endDate;
  Set<String> _assignedGroupIds = {};

  @override
  void initState() {
    super.initState();
    _repo = TeacherRepository(widget.database);
    _junctionRepo = TeacherSubjectGroupRepository(widget.database);
    final t = widget.teacher;
    _isEdit = t != null;
    _codeCtrl = TextEditingController(text: t?.code ?? '');
    _firstNameArCtrl = TextEditingController(text: t?.firstNameAr ?? '');
    _lastNameArCtrl = TextEditingController(text: t?.lastNameAr ?? '');
    _firstNameFrCtrl = TextEditingController(text: t?.firstNameFr ?? '');
    _lastNameFrCtrl = TextEditingController(text: t?.lastNameFr ?? '');
    _phoneCtrl = TextEditingController(text: t?.phone ?? '');
    _addressCtrl = TextEditingController(text: t?.address ?? '');
    _emailCtrl = TextEditingController(text: t?.email ?? '');
    _idCardCtrl = TextEditingController(text: t?.idCard ?? '');
    _sharePctCtrl = TextEditingController(text: t?.teacherSharePct?.toString() ?? '70');
    _fixedAmountCtrl = TextEditingController(text: t?.teacherFixedAmount?.toString() ?? '');
    _overdueThresholdCtrl = TextEditingController(text: t?.overdueThresholdDays?.toString() ?? '');
    if (t != null) {
      _gender = t.gender ?? 'male';
      _salaryType = t.salaryType;
      _startDate = t.employmentStartDate;
      _endDate = t.employmentEndDate;
      if (t.photoPath != null) _photo = File(t.photoPath!);
      _loadAssignments();
    } else {
      _repo.generateCode().then((c) { if (mounted) _codeCtrl.text = c; });
    }
  }

  Future<void> _loadAssignments() async {
    final junctions = await _junctionRepo.getByTeacher(widget.teacher!.id);
    if (mounted) setState(() => _assignedGroupIds = junctions.map((j) => j.subjectGroupId).toSet());
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 400);
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  @override
  void dispose() {
    _codeCtrl.dispose(); _firstNameArCtrl.dispose(); _lastNameArCtrl.dispose();
    _firstNameFrCtrl.dispose(); _lastNameFrCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _emailCtrl.dispose(); _idCardCtrl.dispose();
    _sharePctCtrl.dispose(); _fixedAmountCtrl.dispose(); _overdueThresholdCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      String? photoPath;
      if (_photo != null) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'teacher_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final saved = await _photo!.copy('${dir.path}/$fileName');
        photoPath = saved.path;
      }
      final overdueDays = _overdueThresholdCtrl.text.trim().isEmpty ? null : int.tryParse(_overdueThresholdCtrl.text.trim());

      final entry = TeachersCompanion(
        code: Value(_codeCtrl.text.trim()),
        firstNameAr: Value(_firstNameArCtrl.text.trim()),
        lastNameAr: Value(_lastNameArCtrl.text.trim()),
        firstNameFr: Value(_firstNameFrCtrl.text.trim().isEmpty ? null : _firstNameFrCtrl.text.trim()),
        lastNameFr: Value(_lastNameFrCtrl.text.trim().isEmpty ? null : _lastNameFrCtrl.text.trim()),
        phone: Value(_phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim()),
        address: Value(_addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim()),
        email: Value(_emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim()),
        idCard: Value(_idCardCtrl.text.trim().isEmpty ? null : _idCardCtrl.text.trim()),
        gender: Value(_gender),
        salaryType: Value(_salaryType),
        teacherSharePct: Value(_salaryType == 'percentage' ? double.tryParse(_sharePctCtrl.text) : null),
        teacherFixedAmount: Value(_salaryType == 'fixed' ? double.tryParse(_fixedAmountCtrl.text) : null),
        employmentStartDate: Value(_startDate),
        employmentEndDate: Value(_endDate),
        overdueThresholdDays: Value(overdueDays),
        photoPath: Value(photoPath),
      );

      String teacherId;
      if (_isEdit) {
        teacherId = widget.teacher!.id;
        await _repo.update(teacherId, entry);

        if (widget.teacher!.salaryType != _salaryType ||
            widget.teacher!.teacherSharePct != (_salaryType == 'percentage' ? double.tryParse(_sharePctCtrl.text) : null) ||
            widget.teacher!.teacherFixedAmount != (_salaryType == 'fixed' ? double.tryParse(_fixedAmountCtrl.text) : null)) {
          final auditRepo = AuditLogRepository(widget.database);
          await auditRepo.create(AuditLogCompanion(
            userId: const Value('system'),
            action: const Value('teacher_salary_changed'),
            entityType: const Value('teacher'),
            entityId: Value(teacherId),
            details: Value('${widget.teacher!.salaryType}→$_salaryType, pct:${widget.teacher!.teacherSharePct}→${_salaryType == 'percentage' ? _sharePctCtrl.text : 'null'}, fixed:${widget.teacher!.teacherFixedAmount}→${_salaryType == 'fixed' ? _fixedAmountCtrl.text : 'null'}'),
          ));
        }
      } else {
        teacherId = await _repo.create(entry);
      }

      await _junctionRepo.setAssignments(teacherId, _assignedGroupIds.toList());

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShellDialog(
      maxWidth: 580,
      maxHeight: 700,
      title: _isEdit ? l10n.editTeacher : l10n.add,
      body: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: _pickPhoto,
            child: Container(
              width: 72, height: 88,
              decoration: BoxDecoration(color: ShellTokens.chromeBase, borderRadius: BorderRadius.circular(6), border: Border.all(color: ShellTokens.chromeBorder)),
              child: _photo != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.file(_photo!, width: 72, height: 88, fit: BoxFit.cover))
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(PhosphorIcons.camera, size: 18, color: ShellTokens.textDisabled),
                      const SizedBox(height: 2),
                      Text(l10n.takePhoto.substring(0, 4), style: const TextStyle(fontSize: 8, color: ShellTokens.textDisabled)),
                    ]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(children: [
            _textField(_codeCtrl, required: true, readOnly: _isEdit),
            const SizedBox(height: 8),
            _textField(_firstNameArCtrl, required: true, hint: '${l10n.firstName} AR'),
            const SizedBox(height: 8),
            _textField(_firstNameFrCtrl, hint: '${l10n.firstName} FR'),
          ])),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _textField(_lastNameArCtrl, required: true, hint: '${l10n.lastName} AR')),
          const SizedBox(width: 8),
          Expanded(child: _textField(_lastNameFrCtrl, hint: '${l10n.lastName} FR')),
        ]),
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.gender, withBorder: false),
        const SizedBox(height: 8),
        _dropdown<String?>(
          value: _gender,
          items: [
            DropdownMenuItem(value: 'male', child: Text(l10n.male, style: const TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'female', child: Text(l10n.female, style: const TextStyle(fontSize: 12))),
          ],
          onChanged: (v) => setState(() => _gender = v!),
        ),
        const SizedBox(height: 8),
        _textField(_phoneCtrl, hint: l10n.phone),
        const SizedBox(height: 8),
        _textField(_emailCtrl, hint: l10n.email),
        const SizedBox(height: 8),
        _textField(_idCardCtrl, hint: l10n.idCard),
        const SizedBox(height: 8),
        _textField(_addressCtrl, maxLines: 2, hint: l10n.address),
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.salaryType, withBorder: false),
        const SizedBox(height: 8),
        _dropdown<String?>(
          value: _salaryType,
          items: [
            DropdownMenuItem(value: 'percentage', child: Text(l10n.salaryTypePercentage, style: const TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'fixed', child: Text(l10n.salaryTypeFixed, style: const TextStyle(fontSize: 12))),
          ],
          onChanged: (v) => setState(() => _salaryType = v!),
        ),
        if (_salaryType == 'percentage') ...[
          const SizedBox(height: 8),
          _textField(_sharePctCtrl, hint: l10n.teacherShare),
        ],
        if (_salaryType == 'fixed') ...[
          const SizedBox(height: 8),
          _textField(_fixedAmountCtrl, hint: l10n.teacherFixedAmount),
        ],
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.teacherSubjectAssignment, withBorder: false),
        const SizedBox(height: 8),
        _SubjectGroupMultiSelect(database: widget.database, selectedIds: _assignedGroupIds, onChanged: (ids) => setState(() => _assignedGroupIds = ids)),
        const SizedBox(height: 14),
        ShellSectionHeader(text: '${l10n.employmentStartDate} / ${l10n.employmentEndDate}', withBorder: false),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _dateField(_startDate, l10n.employmentStartDate, (d) => setState(() => _startDate = d))),
          const SizedBox(width: 8),
          Expanded(child: _dateField(_endDate, l10n.employmentEndDate, (d) => setState(() => _endDate = d))),
        ]),
        const SizedBox(height: 14),
        ShellSectionHeader(text: l10n.overdueThresholdDays, withBorder: false),
        const SizedBox(height: 4),
        Text(l10n.overdueThresholdDescription, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
        const SizedBox(height: 6),
        _textField(_overdueThresholdCtrl, hint: l10n.overdueThresholdDays),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_isEdit ? l10n.update : l10n.create),
        )),
      ])),
    );
  }

  Widget _textField(TextEditingController ctrl, {bool required = false, bool readOnly = false, int maxLines = 1, String? hint}) {
    return TextFormField(
      controller: ctrl, readOnly: readOnly, maxLines: maxLines,
      style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
      decoration: ShellInputDecoration.textField(hintText: hint),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? widget.l10n.fieldRequired : null : null,
    );
  }

  Widget _dropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return DropdownButtonFormField<T>(
      value: value, items: items, onChanged: onChanged,
      style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
      decoration: ShellInputDecoration.dropdown(),
    );
  }

  Widget _dateField(DateTime? value, String label, ValueChanged<DateTime> onChanged) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime(2024, 1, 1), firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (d != null) onChanged(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(color: ShellTokens.chromeBase, borderRadius: BorderRadius.circular(6), border: Border.all(color: ShellTokens.chromeBorder)),
        child: Row(children: [
          Expanded(child: Text(
            value != null ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}' : label,
            style: TextStyle(fontSize: 12, color: value != null ? ShellTokens.textPrimary : ShellTokens.textDisabled),
          )),
          const Icon(PhosphorIcons.calendar, size: 14, color: ShellTokens.textSecondary),
        ]),
      ),
    );
  }
}

class _SubjectGroupMultiSelect extends StatefulWidget {
  final AppDatabase database;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  const _SubjectGroupMultiSelect({required this.database, required this.selectedIds, required this.onChanged});
  @override
  State<_SubjectGroupMultiSelect> createState() => _SubjectGroupMultiSelectState();
}

class _SubjectGroupMultiSelectState extends State<_SubjectGroupMultiSelect> {
  List<SubjectGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    _groups = await SubjectGroupRepository(widget.database).getAll();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    return Wrap(spacing: 6, runSpacing: 4, children: _groups.map((g) => FilterChip(
      label: Text(g.nameAr, style: TextStyle(fontSize: 11, color: widget.selectedIds.contains(g.id) ? ShellTokens.chromeBase : ShellTokens.textPrimary)),
      selected: widget.selectedIds.contains(g.id),
      onSelected: (v) {
        final updated = Set<String>.from(widget.selectedIds);
        if (v) { updated.add(g.id); } else { updated.remove(g.id); }
        widget.onChanged(updated);
      },
      selectedColor: ShellTokens.accent,
      backgroundColor: ShellTokens.chromeBase,
      checkmarkColor: ShellTokens.chromeBase,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    )).toList());
  }
}
