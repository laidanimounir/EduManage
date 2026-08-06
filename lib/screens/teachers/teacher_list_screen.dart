import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:excel/excel.dart' hide Border;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../constants/app_constants.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/teacher_subject_group_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/audit_log_repository.dart';
import '../../repositories/session_repository.dart';
import '../../utils/pdf_generator.dart';
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
    ).then((_) { try { _fetchPage(); } catch (_) {} });
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
    final unpaidAttendance = await widget.database.getTeacherUnpaidAttendanceCount(t.id);
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
            if (unpaidAttendance > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: SemanticTokens.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: SemanticTokens.error.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  const Icon(PhosphorIcons.warning, size: 16, color: SemanticTokens.error),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '$unpaidAttendance Ø­ØµØ© ØºÙŠØ± Ù…Ø¯ÙÙˆØ¹Ø© Ø§Ù„Ù…Ø³ØªØ­Ù‚Ø§Øª Ù„Ù‡Ø°Ø§ Ø§Ù„Ø£Ø³ØªØ§Ø°',
                    style: const TextStyle(color: SemanticTokens.error, fontSize: 12, fontWeight: FontWeight.w500),
                  )),
                ]),
              ),
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

  void _exportPdf(AppLocalizations l10n) async {
    if (_rows.isEmpty) return;
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (_) => [
        pw.Header(text: l10n.teachers, level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 7),
          headers: [l10n.code, l10n.firstName, l10n.lastName, l10n.phone, 'Email', l10n.columnSalary, l10n.columnSubjects],
          data: _rows.map((t) => [
            t.code,
            '${t.firstNameAr} ${t.firstNameFr ?? ''}',
            '${t.lastNameAr} ${t.lastNameFr ?? ''}',
            t.phone ?? '',
            t.email ?? '',
            _salaryLabel(t.salaryType, l10n),
            _subjectNamesCache[t.id] ?? '',
          ]).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  void _exportExcel(AppLocalizations l10n) async {
    if (_rows.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel[l10n.teachers];
    sheet.appendRow([TextCellValue(l10n.code), TextCellValue(l10n.firstName), TextCellValue(l10n.lastName), TextCellValue(l10n.phone), TextCellValue('Email'), TextCellValue(l10n.columnSalary), TextCellValue(l10n.columnSubjects)]);
    for (final t in _rows) {
      sheet.appendRow([
        TextCellValue(t.code),
        TextCellValue('${t.firstNameAr} ${t.firstNameFr ?? ''}'),
        TextCellValue('${t.lastNameAr} ${t.lastNameFr ?? ''}'),
        TextCellValue(t.phone ?? ''),
        TextCellValue(t.email ?? ''),
        TextCellValue(_salaryLabel(t.salaryType, l10n)),
        TextCellValue(_subjectNamesCache[t.id] ?? ''),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/teachers_export.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.exportExcel}: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }

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
        int cmp;
        switch (column) {
          case 'Ø§Ù„Ø§Ø³Ù…': cmp = a.firstNameAr.compareTo(b.firstNameAr);
          case 'Ø§Ù„Ø±Ù…Ø²': cmp = a.code.compareTo(b.code);
          case 'Ø§Ù„Ø±Ø§ØªØ¨': cmp = a.salaryType.compareTo(b.salaryType);
          case 'Ø§Ù„Ø¯ÙØ¹': cmp = (_overdueCache[a.id] == true ? 1 : 0).compareTo(_overdueCache[b.id] == true ? 1 : 0);
          case 'Ø§Ù„Ù…ÙˆØ§Ø¯': cmp = (_subjectNamesCache[a.id] ?? '').compareTo(_subjectNamesCache[b.id] ?? '');
          default: return 0;
        }
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
        GestureDetector(onTap: () => _openDetail(t), behavior: HitTestBehavior.opaque, child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (isTeachingNow) _statusChip('Ø§Ù„Ø¢Ù†', SemanticTokens.success, SemanticTokens.success.withValues(alpha: 0.12)),
            if (isTeachingNow && overdue) const SizedBox(width: 4),
            if (overdue) _statusChip('Ù…ØªØ£Ø®Ø±', const Color(0xFFC2823A), const Color(0xFF3D2E18)),
          ])),
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

  void _openTeachingInfo(Teacher t) {
    showDialog(context: context, builder: (_) => _TeacherTeachingInfoDialog(
      database: widget.database, teacherId: t.id,
      teacherName: '${t.firstNameAr} ${t.lastNameAr}',
    ));
  }

  void _openPayment(Teacher t) {
    showDialog(context: context, builder: (_) => _TeacherPaymentDialog(
      database: widget.database, teacherId: t.id,
      teacherName: '${t.firstNameAr} ${t.lastNameAr}',
    )).then((_) => _preloadOverdueStatus());
  }

  Widget _statusChip(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(3)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _buildActionsCell(Teacher t) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(icon: const Icon(PhosphorIcons.info, size: 13), onPressed: () => _openTeachingInfo(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.accent, tooltip: 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªØ¯Ø±ÙŠØ³'),
      IconButton(icon: const Icon(PhosphorIcons.currencyCircleDollar, size: 13), onPressed: () => _openPayment(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: SemanticTokens.success, tooltip: 'Ø§Ù„Ø¯ÙØ¹'),
      IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 13), onPressed: () => _openEdit(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: ShellTokens.textSecondary),
      IconButton(icon: Icon(t.isArchived ? PhosphorIcons.arrowRight : PhosphorIcons.archive, size: 13), onPressed: () => _confirmArchive(t), constraints: const BoxConstraints(minWidth: 28, minHeight: 28), padding: EdgeInsets.zero, color: t.isArchived ? ShellTokens.accent : ShellTokens.textSecondary),
    ]);
  }

  Future<void> _preloadSubjectNames() async {
    for (final t in _rows) {
      final junctions = _junctionCache[t.id] ?? await _junctionRepo.getByTeacher(t.id);
      _junctionCache[t.id] = junctions;
      if (junctions.isEmpty) {
        _subjectNamesCache[t.id] = 'â€”';
        continue;
      }
      final names = <String>[];
      for (final j in junctions) {
        final g = await _groupRepo.getById(j.subjectGroupId);
        if (g != null) names.add(g.nameAr);
      }
      _subjectNamesCache[t.id] = names.isEmpty ? 'â€”' : names.join(', ');
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
        _infoRow(l10n.firstName, '${teacher.firstNameAr} / ${teacher.firstNameFr ?? 'â€”'}'),
        _infoRow(l10n.lastName, '${teacher.lastNameAr} / ${teacher.lastNameFr ?? 'â€”'}'),
        _infoRow(l10n.phone, teacher.phone ?? 'â€”'),
        _infoRow(l10n.email, teacher.email ?? 'â€”'),
        _infoRow(l10n.idCard, teacher.idCard ?? 'â€”'),
        _infoRow(l10n.gender, teacher.gender == 'male' ? l10n.male : teacher.gender == 'female' ? l10n.female : 'â€”'),
        _infoRow(l10n.salaryType, teacher.salaryType == 'percentage' ? l10n.salaryTypePercentage : l10n.salaryTypeFixed),
        _infoRow(l10n.employmentStartDate, teacher.employmentStartDate != null ? _fmtDate(teacher.employmentStartDate!) : 'â€”'),
        _infoRow(l10n.employmentEndDate, teacher.employmentEndDate != null ? _fmtDate(teacher.employmentEndDate!) : 'â€”'),
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
        ShellSectionHeader(text: l10n.teacherPayoutHistory),
        const SizedBox(height: 8),
        _PayoutHistoryList(database: database, teacherId: teacher.id, l10n: l10n, teacherName: '${teacher.firstNameAr} ${teacher.lastNameAr}'),
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
        IconButton(
          icon: const Icon(PhosphorIcons.info, size: 16), color: ShellTokens.accent,
          onPressed: () {
            Navigator.pop(context);
            showDialog(context: context, builder: (_) => _TeacherTeachingInfoDialog(
              database: database, teacherId: teacher.id,
              teacherName: '${teacher.firstNameAr} ${teacher.lastNameAr}',
            ));
          },
          tooltip: 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªØ¯Ø±ÙŠØ³',
        ),
        IconButton(
          icon: const Icon(PhosphorIcons.file, size: 16), color: ShellTokens.accent,
          onPressed: () async {
            try {
              final path = await PdfGenerator.generateTeacherStatement(database: database, teacherId: teacher.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Statement saved: $path'), backgroundColor: ShellTokens.chromeSurface));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }
          },
          tooltip: 'Print Statement',
        ),
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
    final days = ['', 'Ø§Ù„Ø§Ø«Ù†ÙŠÙ†', 'Ø§Ù„Ø«Ù„Ø§Ø«Ø§Ø¡', 'Ø§Ù„Ø£Ø±Ø¨Ø¹Ø§Ø¡', 'Ø§Ù„Ø®Ù…ÙŠØ³', 'Ø§Ù„Ø¬Ù…Ø¹Ø©', 'Ø§Ù„Ø³Ø¨Øª', 'Ø§Ù„Ø£Ø­Ø¯'];
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
      _ => level ?? 'â€”',
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

class _PayoutHistoryList extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final AppLocalizations l10n;
  final String teacherName;
  const _PayoutHistoryList({required this.database, required this.teacherId, required this.l10n, required this.teacherName});
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
        label: const Text('Ø§Ù„Ø¯ÙØ¹', style: TextStyle(fontSize: 12)),
        style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
      ),
    ]);
  }

  Future<void> _payNow() async {
    if (!mounted) return;
    final result = await showDialog<_TeacherPaymentResult>(
      context: context,
      builder: (ctx) => _TeacherPaymentDialog(
        database: widget.database,
        teacherId: widget.teacherId,
        teacherName: widget.teacherName,
      ),
    );
    if (result != null && result.confirmed && mounted) {
      _load();
    }
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
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
  late final GlobalKey<FormState> _formKey;
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
    _formKey = GlobalKey<FormState>();
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
      _repo.generateCode().then((c) { try { if (mounted) _codeCtrl.text = c; } catch (_) {} });
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
            details: Value('${widget.teacher!.salaryType}â†’$_salaryType, pct:${widget.teacher!.teacherSharePct}â†’${_salaryType == 'percentage' ? _sharePctCtrl.text : 'null'}, fixed:${widget.teacher!.teacherFixedAmount}â†’${_salaryType == 'fixed' ? _fixedAmountCtrl.text : 'null'}'),
          ));
        }
      } else {
        teacherId = await _repo.create(entry);
      }

      await _junctionRepo.setAssignments(teacherId, _assignedGroupIds.toList());

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('\u062E\u0637\u0623 \u0641\u064A \u0627\u0644\u062D\u0641\u0638: $e'),
          backgroundColor: ShellTokens.chromeSurface));
      }
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
    _groups = (await SubjectGroupRepository(widget.database).getAll()).where((g) => !g.isArchived).toList();
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

class _TeacherTeachingInfoDialog extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final String teacherName;
  const _TeacherTeachingInfoDialog({required this.database, required this.teacherId, required this.teacherName});
  @override
  State<_TeacherTeachingInfoDialog> createState() => _TeacherTeachingInfoDialogState();
}

class _TeacherTeachingInfoDialogState extends State<_TeacherTeachingInfoDialog> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    _sessions = await widget.database.getTeacherTeachingInfo(widget.teacherId);
    if (mounted) setState(() => _loading = false);
  }

  String _effectiveRate(Map<String, dynamic> s) {
    final sessionFixed = s['session_fixed_amount'] as double?;
    final sessionPct = s['session_share_pct'] as double?;
    if (sessionFixed != null) return 'Ù…Ø¨Ù„Øº Ø«Ø§Ø¨Øª ${sessionFixed.toStringAsFixed(0)} Ø¯Ø¬';
    if (sessionPct != null) return 'Ù†Ø³Ø¨Ø© ${sessionPct.toStringAsFixed(0)}%';
    final defaultFixed = s['teacher_default_fixed'] as double?;
    final defaultPct = s['teacher_default_pct'] as double?;
    final defaultType = s['teacher_salary_type'] as String;
    if (defaultType == 'fixed' && defaultFixed != null) return 'Ù…Ø¨Ù„Øº Ø«Ø§Ø¨Øª ${defaultFixed.toStringAsFixed(0)} Ø¯Ø¬ (Ø§ÙØªØ±Ø§Ø¶ÙŠ)';
    if (defaultPct != null) return 'Ù†Ø³Ø¨Ø© ${defaultPct.toStringAsFixed(0)}% (Ø§ÙØªØ±Ø§Ø¶ÙŠ)';
    return 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯';
  }

  String _levelLabel(String? level) {
    return switch (level) {
      'primary' => 'Ø§Ø¨ØªØ¯Ø§Ø¦ÙŠ',
      'middle' => 'Ù…ØªÙˆØ³Ø·',
      'secondary' => 'Ø«Ø§Ù†ÙˆÙŠ',
      _ => level ?? 'â€”',
    };
  }

  @override
  Widget build(BuildContext context) {
    final days = ['', 'Ø§Ù„Ø§Ø«Ù†ÙŠÙ†', 'Ø§Ù„Ø«Ù„Ø§Ø«Ø§Ø¡', 'Ø§Ù„Ø£Ø±Ø¨Ø¹Ø§Ø¡', 'Ø§Ù„Ø®Ù…ÙŠØ³', 'Ø§Ù„Ø¬Ù…Ø¹Ø©', 'Ø§Ù„Ø³Ø¨Øª', 'Ø§Ù„Ø£Ø­Ø¯'];
    return ShellDialog(
      maxWidth: 520, maxHeight: 600,
      title: 'Ù…Ø¹Ù„ÙˆÙ…Ø§Øª Ø§Ù„ØªØ¯Ø±ÙŠØ³ â€” ${widget.teacherName}',
      body: _loading
          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
          : _sessions.isEmpty
              ? const Center(child: Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø­ØµØµ Ù†Ø´Ø·Ø© Ù„Ù‡Ø°Ø§ Ø§Ù„Ø£Ø³ØªØ§Ø°', style: TextStyle(fontSize: 13, color: ShellTokens.textDisabled)))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _sessions.length,
                  itemBuilder: (_, i) {
                    final s = _sessions[i];
                    final day = days[s['day_of_week'] as int];
                    final start = s['start_time'] as DateTime;
                    final end = s['end_time'] as DateTime;
                    final enrolled = s['enrolled'] as int;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: ShellTokens.chromeBase,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(s['group_name'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: ShellTokens.accentMuted, borderRadius: BorderRadius.circular(10)),
                              child: Text(_levelLabel(s['school_level']), style: const TextStyle(fontSize: 10, color: ShellTokens.textPrimary)),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          _teachRow('Ø§Ù„ÙŠÙˆÙ… ÙˆØ§Ù„ØªÙˆÙ‚ÙŠØª', '$day ${start.hour}:${start.minute.toString().padLeft(2, '0')}â€“${end.hour}:${end.minute.toString().padLeft(2, '0')}'),
                          const SizedBox(height: 4),
                          _teachRow('Ø§Ù„Ø·Ù„Ø§Ø¨ Ø§Ù„Ù…Ø³Ø¬Ù„ÙŠÙ†', '$enrolled Ø·Ø§Ù„Ø¨'),
                          const SizedBox(height: 4),
                          _teachRow('Ø§Ù„Ø£Ø¬Ø±Ø©', _effectiveRate(s)),
                        ]),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _teachRow(String label, String value) {
    return Row(children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))),
    ]);
  }
}

class _TeacherPaymentResult {
  final bool confirmed;
  final List<_PaymentItem> items;
  _TeacherPaymentResult({required this.confirmed, required this.items});
}

class _PaymentItem {
  final String sessionId;
  final DateTime attendanceDate;
  final int attendanceCount;
  final double amount;
  _PaymentItem({required this.sessionId, required this.attendanceDate, required this.attendanceCount, required this.amount});
}

class _TeacherPaymentDialog extends StatefulWidget {
  final AppDatabase database;
  final String teacherId;
  final String teacherName;
  const _TeacherPaymentDialog({required this.database, required this.teacherId, required this.teacherName});
  @override
  State<_TeacherPaymentDialog> createState() => _TeacherPaymentDialogState();
}

class _TeacherPaymentDialogState extends State<_TeacherPaymentDialog> {
  List<Map<String, dynamic>> _unpaid = [];
  List<Map<String, dynamic>> _displayed = [];
  List<Transaction> _recentPayouts = [];
  bool _loading = true;
  bool _isPartial = false;
  bool _paying = false;
  String? _error;
  String? _payError;
  String _method = 'cash';
  final _partialCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  @override
  void dispose() { _partialCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      final raw = await widget.database.getTeacherUnpaidAttendance(widget.teacherId);
      final filtered = raw.where((r) => _calcRemaining(r) > 0).toList();
      if (mounted) setState(() { _unpaid = raw; _displayed = filtered; _loading = false; _error = null; });
      _loadRecentPayouts();
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _loadRecentPayouts() async {
    final db = widget.database;
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(hours: 48));
    final payouts = await (db.select(db.transactions)
      ..where((t) => t.teacherId.equals(widget.teacherId) & t.type.equals('teacher_payout'))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
    final reversals = await (db.select(db.transactions)
      ..where((t) => t.teacherId.equals(widget.teacherId) & t.type.equals('reversal')))
        .get();
    final reversedIds = reversals.where((r) => r.referenceTransactionId != null).map((r) => r.referenceTransactionId!).toSet();
    _recentPayouts = payouts.where((t) => t.transactionDate.isAfter(cutoff) && t.referenceTransactionId == null && !reversedIds.contains(t.id)).toList();
    if (mounted) setState(() {});
  }

  Future<void> _undoPayout(Transaction t) async {
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: ShellTokens.chromeSurface,
      title: const Text('\u062A\u0623\u0643\u064A\u062F \u0627\u0644\u062A\u0631\u0627\u062C\u0639', style: TextStyle(color: ShellTokens.textPrimary, fontSize: 14)),
      content: Text('\u0633\u064A\u062A\u0645 \u0625\u0646\u0634\u0627\u0621 \u0639\u0645\u0644\u064A\u0629 \u0639\u0643\u0633 \u0644\u0644\u062F\u0641\u0639\u0629 \u0628\u0642\u064A\u0645\u0629 ${t.amount.toStringAsFixed(0)} \u062F\u062C\u060C \u0647\u0644 \u0623\u0646\u062A \u0645\u062A\u0623\u0643\u062F\u061F', style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('\u0625\u0644\u063A\u0627\u0621', style: TextStyle(color: ShellTokens.textSecondary))), FilledButton(onPressed: () => Navigator.pop(ctx, true), style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent), child: const Text('\u062A\u0623\u0643\u064A\u062F'))],
    ));
    if (confirmed != true) return;
    try {
      final txService = TransactionService(widget.database);
      await txService.createReversal(referenceTransactionId: t.id, note: '\u062A\u0631\u0627\u062C\u0639 \u0639\u0646 \u0627\u0644\u062F\u0641\u0639');
      await _load();
      await _loadRecentPayouts();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('\u062E\u0637\u0623 \u0641\u064A \u0627\u0644\u062A\u0631\u0627\u062C\u0639: $e'),
          backgroundColor: ShellTokens.chromeSurface));
      }
    }
  }

  double _calcFullAmount(Map<String, dynamic> row) {
    final frozenRate = row['frozen_rate'] as String?;
    if (frozenRate != null && frozenRate.isNotEmpty && frozenRate != 'none') {
      return _calcFromRateSnapshot(frozenRate, row);
    }
    final sessionFixed = row['session_fixed_amount'] as double?;
    final sessionPct = row['session_share_pct'] as double?;
    final defaultFixed = row['teacher_default_fixed'] as double?;
    final defaultPct = row['teacher_default_pct'] as double?;
    final salaryType = row['teacher_salary_type'] as String;
    final attendance = row['attendance_count'] as int;
    final monthlyPrice = row['monthly_price'] as double;
    final sessionsPerMonth = row['sessions_per_month'] as int;

    final effFixed = sessionFixed ?? defaultFixed;
    final effPct = sessionPct ?? defaultPct;
    final effType = (sessionFixed != null || sessionPct != null)
        ? (sessionFixed != null ? 'fixed' : 'percentage')
        : salaryType;

    if (effFixed != null && effType == 'fixed') return effFixed;
    if (effPct != null && sessionsPerMonth > 0) {
      final perSession = monthlyPrice / sessionsPerMonth;
      return perSession * effPct / 100 * attendance;
    }
    return 0;
  }

  double _calcFromRateSnapshot(String snapshot, Map<String, dynamic> row) {
    if (snapshot.startsWith('fixed:')) {
      return double.tryParse(snapshot.substring(6)) ?? 0;
    }
    if (snapshot.startsWith('pct:')) {
      final parts = snapshot.split(',');
      if (parts.length < 4) return 0;
      final pct = double.tryParse(parts[0].substring(4)) ?? 0;
      final base = double.tryParse(parts[1].split(':').last) ?? 0;
      final sessions = int.tryParse(parts[2].split(':').last) ?? 1;
      if (sessions <= 0) return 0;
      final attendance = row['attendance_count'] as int;
      final perSession = base / sessions;
      return perSession * pct / 100 * attendance;
    }
    return 0;
  }

  double _calcRemaining(Map<String, dynamic> row) {
    final full = _calcFullAmount(row);
    final paid = (row['already_paid'] as double?) ?? 0;
    return (full - paid).clamp(0, full);
  }

  String _rateLabel(Map<String, dynamic> row) {
    final sessionFixed = row['session_fixed_amount'] as double?;
    final sessionPct = row['session_share_pct'] as double?;
    final defaultFixed = row['teacher_default_fixed'] as double?;
    final defaultPct = row['teacher_default_pct'] as double?;
    final salaryType = row['teacher_salary_type'] as String;

    if (sessionFixed != null) return '${sessionFixed.toStringAsFixed(0)} Ø¯Ø¬';
    if (sessionPct != null) return '${sessionPct.toStringAsFixed(0)}%';
    if (salaryType == 'fixed' && defaultFixed != null) return '${defaultFixed.toStringAsFixed(0)} Ø¯Ø¬';
    if (defaultPct != null) return '${defaultPct.toStringAsFixed(0)}%';
    return 'â€”';
  }

  String _rateSnapshotStr(Map<String, dynamic> row) {
    final attendance = row['attendance_count'] as int;
    final monthlyPrice = row['monthly_price'] as double;
    final sessionsPerMonth = row['sessions_per_month'] as int;
    final sessionFixed = row['session_fixed_amount'] as double?;
    final sessionPct = row['session_share_pct'] as double?;
    final defaultFixed = row['teacher_default_fixed'] as double?;
    final defaultPct = row['teacher_default_pct'] as double?;
    final salaryType = row['teacher_salary_type'] as String;

    final effFixed = sessionFixed ?? defaultFixed;
    final effPct = sessionPct ?? defaultPct;
    final effType = (sessionFixed != null || sessionPct != null)
        ? (sessionFixed != null ? 'fixed' : 'percentage')
        : salaryType;

    if (effFixed != null && effType == 'fixed') return 'fixed:${effFixed.toStringAsFixed(0)}';
    if (effPct != null) return 'pct:${effPct.toStringAsFixed(1)},base:${monthlyPrice.toStringAsFixed(0)},sessions:$sessionsPerMonth,students:$attendance';
    return 'none';
  }

  double get _grandTotal => _displayed.fold(0, (sum, r) => sum + _calcRemaining(r));

  Future<void> _pay() async {
    if (_isPartial) {
      final v = double.tryParse(_partialCtrl.text.trim());
      if (v == null || v <= 0) { setState(() => _payError = 'Ø§Ù„Ù…Ø¨Ù„Øº ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† Ø£ÙƒØ¨Ø± Ù…Ù† ØµÙØ±'); return; }
      if (v > _grandTotal) { setState(() => _payError = 'Ø§Ù„Ù…Ø¨Ù„Øº Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø£Ù† ÙŠØªØ¬Ø§ÙˆØ² Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø³ØªØ­Ù‚'); return; }
    }

    setState(() { _paying = true; _payError = null; });
    final txService = TransactionService(widget.database);
    try {
      if (_isPartial) {
        final amount = double.parse(_partialCtrl.text.trim());
        double remaining = amount;
        final paid = <String>[];
        double totalPaid = 0;
        for (final r in _displayed) {
          if (remaining <= 0) break;
          final owed = _calcRemaining(r);
          if (owed <= 0) continue;
          final payNow = remaining >= owed ? owed : remaining;
          if (payNow <= 0) continue;
          await txService.createTeacherPayoutOverride(
            teacherId: widget.teacherId,
            sessionId: r['session_id'] as String,
            amount: payNow,
            rateSnapshotStr: '${_rateSnapshotStr(r)},partial:${payNow.toStringAsFixed(0)}',
            date: r['attendance_date'] as DateTime,
            paymentMethod: _method,
            note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
          );
          paid.add('${r['group_name']} (${_fmtDate(r['attendance_date'] as DateTime)}): ${payNow.toStringAsFixed(0)} Ø¯Ø¬');
          totalPaid += payNow;
          remaining -= payNow;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ØªÙ… Ø§Ù„Ø¯ÙØ¹ Ø§Ù„Ø¬Ø²Ø¦ÙŠ: ${totalPaid.toStringAsFixed(0)} Ø¯Ø¬'),
            backgroundColor: ShellTokens.chromeSurface));
        }
      } else {
        int success = 0;
        final failedNames = <String>[];
        for (final r in _displayed) {
          try {
            await txService.createTeacherPayoutOverride(
              teacherId: widget.teacherId,
              sessionId: r['session_id'] as String,
              amount: _calcRemaining(r),
              rateSnapshotStr: _rateSnapshotStr(r),
              date: r['attendance_date'] as DateTime,
              paymentMethod: _method,
              note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
            );

            success++;
          } catch (e) { failedNames.add('${r['group_name']} (${_fmtDate(r['attendance_date'] as DateTime)}): $e'); }
        }
        if (mounted) {
          final msg = 'ØªÙ… Ø§Ù„Ø¯ÙØ¹: $success Ø­ØµØ©';
          if (failedNames.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$msg\nÙØ´Ù„: ${failedNames.join(', ')}'),
              backgroundColor: SemanticTokens.warning, duration: const Duration(seconds: 6)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg),
              backgroundColor: ShellTokens.chromeSurface));
          }
        }
      }
      if (mounted) {
        Navigator.pop(context, _TeacherPaymentResult(confirmed: true, items: []));
      }
    } catch (e) {
      if (mounted) setState(() { _paying = false; _payError = e.toString(); });
    }
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final days = ['', 'Ø§Ù„Ø§Ø«Ù†ÙŠÙ†', 'Ø§Ù„Ø«Ù„Ø§Ø«Ø§Ø¡', 'Ø§Ù„Ø£Ø±Ø¨Ø¹Ø§Ø¡', 'Ø§Ù„Ø®Ù…ÙŠØ³', 'Ø§Ù„Ø¬Ù…Ø¹Ø©', 'Ø§Ù„Ø³Ø¨Øª', 'Ø§Ù„Ø£Ø­Ø¯'];
    return ShellDialog(
      maxWidth: 550, maxHeight: 650,
      title: 'Ø§Ù„Ø¯ÙØ¹ â€” ${widget.teacherName}',
      body: _loading
          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
          : _error != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(PhosphorIcons.warning, size: 24, color: SemanticTokens.error),
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(fontSize: 12, color: SemanticTokens.error)),
                ]))
              : _displayed.isEmpty
                  ? const Center(child: Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ø­ØµØµ ØºÙŠØ± Ù…Ø¯ÙÙˆØ¹Ø©', style: TextStyle(fontSize: 14, color: ShellTokens.textDisabled)))
                  : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Ø§Ù„Ù…Ø³ØªØ­Ù‚Ø§Øª ØºÙŠØ± Ø§Ù„Ù…Ø¯ÙÙˆØ¹Ø© (Ø§Ù„Ø­ØµØµ Ø§Ù„Ù…Ù†ØªÙ‡ÙŠØ©)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _displayed.length,
                          itemBuilder: (_, i) {
                            final r = _displayed[i];
                            final remaining = _calcRemaining(r);
                            final full = _calcFullAmount(r);
                            final alreadyPaid = (r['already_paid'] as double?) ?? 0;
                            final attDate = r['attendance_date'] as DateTime;
                            final day = days[r['day_of_week'] as int];
                            final start = r['start_time'] as DateTime;
                            final end = r['end_time'] as DateTime;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              color: ShellTokens.chromeBase,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: ShellTokens.accent, shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(r['group_name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary))),
                                  ]),
                                  const SizedBox(height: 8),
                                  _payRow('Ø§Ù„ØªØ§Ø±ÙŠØ®', _fmtDate(attDate)),
                                  const SizedBox(height: 3),
                                  _payRow('Ø§Ù„ÙŠÙˆÙ… ÙˆØ§Ù„ØªÙˆÙ‚ÙŠØª', '$day ${start.hour}:${start.minute.toString().padLeft(2, '0')}â€“${end.hour}:${end.minute.toString().padLeft(2, '0')}'),
                                  const SizedBox(height: 3),
                                  _payRow('Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø§Ø¨', '${r['attendance_count']}'),
                                  const SizedBox(height: 3),
                                  _payRow('Ø§Ù„Ø£Ø¬Ø±Ø©', _rateLabel(r)),
                                  const SizedBox(height: 3),
                                  if (alreadyPaid > 0)
                                    _payRow('Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ù…Ø¯ÙÙˆØ¹ Ø³Ø§Ø¨Ù‚Ø§Ù‹', '${alreadyPaid.toStringAsFixed(0)} Ø¯Ø¬'),
                                  const SizedBox(height: 3),
                                  _payRow('Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ù…Ø³ØªØ­Ù‚', '${remaining.toStringAsFixed(0)} Ø¯Ø¬${alreadyPaid > 0 ? ' (Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ: ${full.toStringAsFixed(0)})' : ''}'),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(color: ShellTokens.chromeBorder, height: 24),
                      Row(children: [
                        const Text('Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø³ØªØ­Ù‚', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ShellTokens.textPrimary)),
                        const Spacer(),
                        Text('${_grandTotal.toStringAsFixed(0)} Ø¯Ø¬', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SemanticTokens.success)),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        const Text('Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„Ø¯ÙØ¹', style: TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _method,
                            isDense: true,
                            items: ['cash', 'card', 'bank_transfer', 'mobile_payment'].map((m) =>
                              DropdownMenuItem(value: m, child: Text(_methodLabel(m), style: const TextStyle(fontSize: 11)))).toList(),
                            onChanged: (v) => setState(() => _method = v!),
                            style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary),
                            decoration: InputDecoration(
                              filled: true, fillColor: ShellTokens.chromeBase,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Text('Ø¯ÙØ¹ Ø¬Ø²Ø¦ÙŠ', style: TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
                        Switch(value: _isPartial, onChanged: (v) => setState(() { _isPartial = v; _payError = null; })),
                      ]),
                      if (_isPartial) ...[
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 38,
                          child: TextField(
                            controller: _partialCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Ø£Ø¯Ø®Ù„ Ø§Ù„Ù…Ø¨Ù„Øº (Ø§Ù„Ø£Ù‚ØµÙ‰: ${_grandTotal.toStringAsFixed(0)} Ø¯Ø¬)',
                              isDense: true,
                              filled: true,
                              fillColor: ShellTokens.chromeBase,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                            ),
                          ),
                        ),
                      ],
                      if (_payError != null) ...[
                        const SizedBox(height: 8),
                        Text(_payError!, style: const TextStyle(fontSize: 12, color: SemanticTokens.error)),
                      ],
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 34,
                        child: TextField(
                          controller: _noteCtrl,
                          style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary),
                          decoration: const InputDecoration(
                            hintText: '\u0645\u0644\u0627\u062D\u0638\u0629',
                            filled: true, fillColor: ShellTokens.chromeBase,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide(color: ShellTokens.chromeBorder)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(width: double.infinity, child: FilledButton(
                        onPressed: _paying ? null : _pay,
                        style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: _paying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase))
                            : Text(_isPartial ? 'تأكيد الدفع الجزئي' : 'دفع كامل المبلغ', style: const TextStyle(fontSize: 14)),
                      )),
                      if (_recentPayouts.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('المدفوعات الأخيرة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                        const SizedBox(height: 6),
                        ..._recentPayouts.map((t) {
                          final hoursSince = DateTime.now().difference(t.transactionDate).inHours;
                          final canUndo = hoursSince < 48;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(children: [
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${t.amount.toStringAsFixed(0)} دج', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
                                Text('${t.transactionDate.year}-${t.transactionDate.month.toString().padLeft(2,'0')}-${t.transactionDate.day.toString().padLeft(2,'0')} ${t.transactionDate.hour.toString().padLeft(2,'0')}:${t.transactionDate.minute.toString().padLeft(2,'0')}', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
                              ])),
                              if (canUndo)
                                TextButton(onPressed: () => _undoPayout(t), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero), child: const Text('تراجع', style: TextStyle(fontSize: 10, color: SemanticTokens.error))),
                            ]),
                          );
                        }),
                      ],
                    ]),
    );
  }

  String _methodLabel(String m) {
    switch (m) {
      case 'card': return '\u0634\u064A\u0643';
      case 'bank_transfer': return '\u062A\u062D\u0648\u064A\u0644';
      case 'mobile_payment': return '\u062F\u0641\u0639 \u062C\u0648\u0627\u0644';
      default: return '\u0646\u0642\u062F\u064A';
    }
  }

  Widget _payRow(String label, String value) {
    return Row(children: [
      SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary))),
    ]);
  }
}
