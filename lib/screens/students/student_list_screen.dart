import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/group_assignment_dialog.dart';
import '../../repositories/school_level_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/transaction_service.dart';

class StudentListScreen extends StatefulWidget {
  final AppDatabase database;

  const StudentListScreen({super.key, required this.database});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late final StudentRepository _repo;
  late final EnrollmentRepository _enrollRepo;

  List<Student> _rows = [];
  int _total = 0;
  int _page = 0;
  static const int _pageSize = 20;
  bool _loading = true;

  final _searchCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  final _barcodeFocus = FocusNode();
  bool _barcodePaused = false;

  String _statusFilter = 'all';
  String _searchQuery = '';
  Set<String> _selectedIds = {};
  Set<String> _enrolledIds = {};
  Set<String> _feePaidIds = {};
  String? _sortColumn;
  bool _sortAsc = true;

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    _enrollRepo = EnrollmentRepository(widget.database);
    _fetchPage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_barcodePaused) _barcodeFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _barcodeCtrl.dispose();
    _barcodeFocus.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    try {
      final result = await _repo.fetchPage(
        offset: _page * _pageSize,
        limit: _pageSize,
        statusFilter: _statusFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      final enrollments = await _enrollRepo.getAll();
      final enrolledIds = enrollments
          .where((e) => e.status == 'active')
          .map((e) => e.studentId)
          .toSet();
      final feePaidIds = <String>{};
      for (final s in result.students) {
        final paid = await widget.database.isRegistrationFeePaid(s.id);
        if (paid) feePaidIds.add(s.id);
      }
      if (mounted) {
        setState(() {
          _rows = result.students;
          _total = result.total;
          _enrolledIds = enrolledIds;
          _feePaidIds = feePaidIds;
          _loading = false;
          
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String v) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = v;
      _page = 0;
      _fetchPage();
    });
  }

  void _onBarcodeSubmit(String v) {
    if (v.trim().isEmpty) return;
    _searchQuery = v.trim();
    _searchCtrl.text = v.trim();
    _page = 0;
    _barcodeCtrl.clear();
    _fetchPage();
  }

  void _onStatusFilterChanged(String filter) {
    setState(() => _statusFilter = filter);
    _page = 0;
    _selectedIds.clear();
    _fetchPage();
  }

  void _clearFilters() {
    _searchCtrl.clear();
    _searchQuery = '';
    _statusFilter = 'all';
    _page = 0;
    _selectedIds.clear();
    _fetchPage();
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == _rows.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = _rows.map((r) => r.id).toSet();
      }
    });
  }

  void _restoreBarcodeFocus() {
    if (!_barcodePaused) _barcodeFocus.requestFocus();
  }

  void _openDetail(Student s) {
    _barcodePaused = true;
    showDialog(
      context: context,
      builder: (_) => _StudentDetailDialog(
        database: widget.database,
        student: s,
        l10n: AppLocalizations.of(context),
      ),
    ).then((_) {
      _barcodePaused = false;
      _restoreBarcodeFocus();
      _fetchPage();
    });
  }

  void _openEdit(Student s) async {
    _barcodePaused = true;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _StudentEditDialog(
        database: widget.database,
        student: s,
        l10n: AppLocalizations.of(context),
      ),
    );
    _barcodePaused = false;
    _restoreBarcodeFocus();
    if (result == true) _fetchPage();
  }

  void _openCreate() async {
    _barcodePaused = true;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _StudentEditDialog(
        database: widget.database,
        l10n: AppLocalizations.of(context),
      ),
    );
    _barcodePaused = false;
    _restoreBarcodeFocus();
    if (result == true) _fetchPage();
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
          if (hasSelection)
            _buildSelectionBar(l10n),
          _buildToolbar(l10n, hasFilters),
          Expanded(child: _buildBody(l10n)),
          if (!_loading && _total > 0)
            _buildPaginationBar(l10n, totalPages),
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
      child: Row(
        children: [
          Text(
            '${_selectedIds.length} ${l10n.selected}',
            style: const TextStyle(
              color: ShellTokens.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _toggleSelectAll,
            icon: Icon(
              _selectedIds.length == _rows.length
                  ? PhosphorIcons.arrowLeft
                  : PhosphorIcons.squaresFour,
              size: 16,
            ),
            label: Text(_selectedIds.length == _rows.length ? l10n.clearSelection : l10n.selectAll),
            style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.identificationCard, size: 16),
            label: Text(l10n.generateCards),
            style: FilledButton.styleFrom(
              backgroundColor: ShellTokens.accent,
              foregroundColor: ShellTokens.chromeBase,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n, bool hasFilters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
                    decoration: InputDecoration(
                      hintText: l10n.search,
                      hintStyle: const TextStyle(color: ShellTokens.textDisabled, fontSize: 13),
                      prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary),
                      suffixIcon: hasFilters
                          ? IconButton(
                              icon: const Icon(PhosphorIcons.arrowLeft, size: 14, color: ShellTokens.textSecondary),
                              onPressed: _clearFilters,
                              tooltip: l10n.clearFilters,
                            )
                          : null,
                      filled: true,
                      fillColor: ShellTokens.chromeSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: ShellTokens.chromeBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: ShellTokens.chromeBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: ShellTokens.accent),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 180,
                height: 34,
                child: TextField(
                  controller: _barcodeCtrl,
                  focusNode: _barcodeFocus,
                  style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary),
                  decoration: InputDecoration(
                    hintText: '📷 Barcode',
                    hintStyle: const TextStyle(color: ShellTokens.textDisabled, fontSize: 11),
                    filled: true,
                    fillColor: ShellTokens.chromeBase,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: ShellTokens.accent.withValues(alpha: 0.5)),
                    ),
                  ),
                  onSubmitted: _onBarcodeSubmit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            child: Row(
              children: [
                _buildFilterChip(l10n.all, 'all'),
                _buildFilterChip(l10n.active, 'active'),
                _buildFilterChip(l10n.inactive, 'inactive'),
                _buildFilterChip(l10n.graduated, 'graduated'),
                _buildFilterChip(l10n.archived, 'archived'),
                const SizedBox(width: 8),
                _buildExportButton(l10n.exportPdf, PhosphorIcons.file, _exportPdf, false),
                const SizedBox(width: 4),
                _buildExportButton(l10n.exportExcel, PhosphorIcons.table, _exportExcel, false),
                const SizedBox(width: 4),
                _buildExportButton(l10n.emailReport, PhosphorIcons.envelope, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon), backgroundColor: ShellTokens.chromeSurface),
                  );
                }, true),
                const Spacer(),
                IconButton(
                  icon: const Icon(PhosphorIcons.plus, size: 18, color: ShellTokens.accent),
                  onPressed: _openCreate,
                  tooltip: l10n.add,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(String label, IconData icon, VoidCallback onTap, bool disabled) {
    return Material(
      color: ShellTokens.chromeSurface,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: ShellTokens.textSecondary),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context);
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (ctx) => [
        pw.Header(text: l10n.students, level: 1),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(fontSize: 7),
          headers: [l10n.code, l10n.firstName, l10n.lastName, l10n.schoolLevel, l10n.phone],
          data: _rows.map((s) => [
            s.code,
            '${s.firstNameAr} ${s.firstNameFr ?? ''}',
            '${s.lastNameAr} ${s.lastNameFr ?? ''}',
            s.schoolLevel ?? '',
            s.phone ?? '',
          ]).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportExcel() async {
    final l10n = AppLocalizations.of(context);
    final excel = Excel.createExcel();
    final sheet = excel['Students'];
    sheet.appendRow([
      TextCellValue(l10n.code),
      TextCellValue(l10n.firstName),
      TextCellValue(l10n.lastName),
      TextCellValue(l10n.schoolLevel),
      TextCellValue(l10n.phone),
    ]);
    for (final s in _rows) {
      sheet.appendRow([
        TextCellValue(s.code),
        TextCellValue('${s.firstNameAr} ${s.firstNameFr ?? ''}'),
        TextCellValue('${s.lastNameAr} ${s.lastNameFr ?? ''}'),
        TextCellValue(s.schoolLevel ?? ''),
        TextCellValue(s.phone ?? ''),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/students_export.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.exportExcel}: ${file.path}'), backgroundColor: ShellTokens.chromeSurface),
      );
    }
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _statusFilter == value;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => _onStatusFilterChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(1.2),
        6: FlexColumnWidth(1),
        7: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder(
        horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5),
      ),
      children: [
        _buildHeaderRow(l10n),
        ..._rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)),
      ],
    );
  }

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(
      decoration: const BoxDecoration(
        color: ShellTokens.chromeSurface,
        border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      children: [
        _buildHeaderCell(PhosphorIcons.checkSquare, null, l10n),
        _buildHeaderCell(null, l10n.columnName, l10n),
        _buildHeaderCell(null, l10n.columnSurname, l10n),
        _buildHeaderCell(null, l10n.columnAddress, l10n),
        _buildHeaderCell(null, l10n.columnLevel, l10n),
        _buildHeaderCell(null, l10n.columnStatus, l10n),
        _buildHeaderCell(null, l10n.columnRegistrationDate, l10n),
        _buildHeaderCell(PhosphorIcons.gear, null, l10n),
      ],
    );
  }

  Widget _buildHeaderCell(IconData? icon, String? label, AppLocalizations l10n) {
    return GestureDetector(
      onTap: label != null ? () => _onSort(label) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              InkWell(
                onTap: _toggleSelectAll,
                child: Icon(icon, size: 14, color: ShellTokens.textSecondary),
              )
            else ...[
              Text(
                label ?? '',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ShellTokens.textDisabled,
                  letterSpacing: 0.3,
                ),
              ),
              if (_sortColumn == label)
                Icon(
                  _sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10,
                  color: ShellTokens.textSecondary,
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAsc = !_sortAsc;
      } else {
        _sortColumn = column;
        _sortAsc = true;
      }
      _rows.sort((a, b) {
        int cmp;
        switch (column) {
          case 'Name':
            cmp = a.firstNameAr.compareTo(b.firstNameAr);
          case 'Surname':
            cmp = a.lastNameAr.compareTo(b.lastNameAr);
          default:
            return 0;
        }
        return _sortAsc ? cmp : -cmp;
      });
    });
  }

  TableRow _buildDataRow(Student s, int index, AppLocalizations l10n) {
    final isEnrolled = _enrolledIds.contains(s.id);
    final isFeePaid = _feePaidIds.contains(s.id);
    final hasFee = true;
    final isSelected = _selectedIds.contains(s.id);
    final isEven = index.isEven;

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected
            ? ShellTokens.accentMuted.withValues(alpha: 0.3)
            : !isEnrolled
                ? const Color(0xFF2B2416).withValues(alpha: 0.4)
                : isEven
                    ? Colors.transparent
                    : ShellTokens.chromeBase.withValues(alpha: 0.3),
      ),
      children: [
        _buildCheckCell(s, isSelected),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildNameCellContent(s, isEnrolled, isFeePaid, hasFee, l10n),
        ),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildTextCell('${s.lastNameAr}\n${s.lastNameFr ?? ''}'),
        ),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildTextCell(s.address ?? '—'),
        ),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildTextCell(_levelLabel(s.schoolLevel, l10n)),
        ),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildStatusCell(s, l10n),
        ),
        GestureDetector(
          onTap: () => _openDetail(s),
          child: _buildTextCell(_formatDate(s.registrationDate)),
        ),
        _buildActionsCell(s),
      ],
    );
  }

  Widget _buildCheckCell(Student s, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIds.remove(s.id);
          } else {
            _selectedIds.add(s.id);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isSelected ? ShellTokens.accent : ShellTokens.chromeBorder,
              width: 1.5,
            ),
            color: isSelected ? ShellTokens.accent : Colors.transparent,
          ),
          child: isSelected
              ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase)
              : null,
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2E18),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF5C4626)),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextCell(String text) {
    return GestureDetector(
      onTap: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildNameCellContent(Student s, bool isEnrolled, bool isFeePaid, bool hasFee, AppLocalizations l10n) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.firstNameAr,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (s.firstNameFr != null && s.firstNameFr!.isNotEmpty)
                    Text(
                      s.firstNameFr!,
                      style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (!isFeePaid && hasFee)
              _buildBadge(l10n.feeUnpaid, const Color(0xFFC2823A)),
            if (!isEnrolled)
              _buildBadge(l10n.notEnrolled, const Color(0xFFC2823A)),
          ],
        ),
      );
  }

  Widget _buildStatusCell(Student s, AppLocalizations l10n) {
    final color = s.status == 'active'
        ? SemanticTokens.success
        : s.status == 'inactive'
            ? SemanticTokens.warning
            : ShellTokens.textDisabled;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _statusLabel(s.status, l10n),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCell(Student s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(PhosphorIcons.pencilSimple, size: 14, color: ShellTokens.textSecondary),
            onPressed: () => _openEdit(s),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: AppLocalizations.of(context).edit,
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.archive, size: 14, color: ShellTokens.textSecondary),
            onPressed: () => _confirmArchive(s),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: AppLocalizations.of(context).archive,
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.usersThree, size: 14, color: ShellTokens.textSecondary),
            onPressed: () => _openGroups(s),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: AppLocalizations.of(context).enrollInGroups,
          ),
        ],
      ),
    );
  }

  void _openGroups(Student s) async {
    _barcodePaused = true;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => GroupAssignmentDialog(
        database: widget.database,
        studentId: s.id,
        l10n: AppLocalizations.of(context),
      ),
    );
    _barcodePaused = false;
    _restoreBarcodeFocus();
    if (result == true) _fetchPage();
  }

  Future<void> _confirmArchive(Student s) async {
    final l10n = AppLocalizations.of(context);
    final hasTxns = s.status != 'active' || _enrolledIds.contains(s.id);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: Text(l10n.archive, style: const TextStyle(color: ShellTokens.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.archiveConfirm, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 13)),
            if (hasTxns) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.archiveWarning,
                      style: const TextStyle(color: SemanticTokens.warning, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel, style: const TextStyle(color: ShellTokens.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.archive, style: const TextStyle(color: SemanticTokens.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (s.isArchived) {
        await _repo.restore(s.id);
      } else {
        await _repo.archive(s.id);
      }
      _fetchPage();
    }
  }

  Widget _buildPaginationBar(AppLocalizations l10n, int totalPages) {
    final first = _page * _pageSize + 1;
    final last = (_page * _pageSize + _rows.length).clamp(0, _total);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: ShellTokens.chromeSurface,
        border: Border(top: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Row(
        children: [
          Text(
            l10n.showingResults('$first', '$last', '$_total'),
            style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(PhosphorIcons.caretLeft, size: 14),
            onPressed: _page > 0 ? () { _page--; _fetchPage(); } : null,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            color: ShellTokens.textSecondary,
          ),
          Text(
            '${_page + 1}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary),
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.caretRight, size: 14),
            onPressed: _page < totalPages - 1 ? () { _page++; _fetchPage(); } : null,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            color: ShellTokens.textSecondary,
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'active': return l10n.active;
      case 'inactive': return l10n.inactive;
      case 'graduated': return l10n.graduated;
      default: return status;
    }
  }

  String _levelLabel(String? level, AppLocalizations l10n) {
    switch (level) {
      case 'primary': return l10n.schoolLevelPrimary;
      case 'middle': return l10n.schoolLevelMiddle;
      case 'secondary': return l10n.schoolLevelSecondary;
      default: return level ?? '—';
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _StudentDetailDialog extends StatelessWidget {
  final AppDatabase database;
  final Student student;
  final AppLocalizations l10n;

  const _StudentDetailDialog({
    required this.database,
    required this.student,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: ShellTokens.accentMuted,
                    child: Text(student.firstNameAr[0], style: const TextStyle(color: ShellTokens.textPrimary, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${student.firstNameAr} ${student.lastNameAr}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                        Text(student.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(PhosphorIcons.x, size: 18, color: ShellTokens.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(l10n.personalInfo),
                    const SizedBox(height: 8),
                    _infoRow(l10n.firstName, '${student.firstNameAr} / ${student.firstNameFr ?? '—'}'),
                    _infoRow(l10n.lastName, '${student.lastNameAr} / ${student.lastNameFr ?? '—'}'),
                    _infoRow(l10n.phone, student.phone ?? '—'),
                    _infoRow(l10n.address, student.address ?? '—'),
                    _infoRow(l10n.gender, student.gender == 'male' ? l10n.male : student.gender == 'female' ? l10n.female : '—'),
                    _infoRow(l10n.birthDate, _fmtDate(student.birthDate)),
                    _infoRow(l10n.birthPlace, student.birthPlace ?? '—'),
                    _infoRow(l10n.schoolLevel, _levelLabel(student.schoolLevel, l10n)),
                    const SizedBox(height: 16),
                    _sectionHeader(l10n.financialStatus),
                    const SizedBox(height: 8),
                    _FinancialSummary(database: database, studentId: student.id, l10n: l10n),
                    const SizedBox(height: 16),
                    _sectionHeader(l10n.enrollments),
                    const SizedBox(height: 8),
                    _EnrollmentList(database: database, studentId: student.id, l10n: l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3));
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
        ],
      ),
    );
  }

  String _fmtDate(DateTime? dt) => dt == null ? '—' : '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  String _levelLabel(String? level, AppLocalizations l10n) {
    switch (level) {
      case 'primary': return l10n.schoolLevelPrimary;
      case 'middle': return l10n.schoolLevelMiddle;
      case 'secondary': return l10n.schoolLevelSecondary;
      default: return level ?? '—';
    }
  }
}

class _FinancialSummary extends StatefulWidget {
  final AppDatabase database;
  final String studentId;
  final AppLocalizations l10n;

  const _FinancialSummary({required this.database, required this.studentId, required this.l10n});

  @override
  State<_FinancialSummary> createState() => _FinancialSummaryState();
}

class _FinancialSummaryState extends State<_FinancialSummary> {
  double _charged = 0;
  double _paid = 0;
  double _balance = 0;
  bool _feePaid = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r1 = await widget.database.getStudentTotalCharged(widget.studentId);
    final r2 = await widget.database.getStudentTotalPaid(widget.studentId);
    final r3 = await widget.database.getStudentBalance(widget.studentId);
    final r4 = await widget.database.isRegistrationFeePaid(widget.studentId);
    if (mounted) setState(() { _charged = r1; _paid = r2; _balance = r3; _feePaid = r4; _loading = false; });
  }

  Future<void> _markFeePaid() async {
    final prefs = await SharedPreferences.getInstance();
    final amount = prefs.getDouble('registration_fee_amount') ?? 2000.0;
    final txService = TransactionService(widget.database);
    await txService.createRegistrationFeePayment(studentId: widget.studentId, amount: amount);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 40, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    return Column(
      children: [
        _finRow(widget.l10n.totalCharged, _charged, ShellTokens.textPrimary),
        _finRow(widget.l10n.totalPaid, _paid, SemanticTokens.success),
        const Divider(height: 16, color: ShellTokens.chromeBorder),
        _finRow(widget.l10n.balance, _balance, _balance > 0 ? SemanticTokens.error : SemanticTokens.success, bold: true),
        const Divider(height: 16, color: ShellTokens.chromeBorder),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.l10n.registrationFee, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
              if (_feePaid)
                Text(widget.l10n.feePaid, style: const TextStyle(fontSize: 11, color: SemanticTokens.success, fontWeight: FontWeight.w600))
              else
                TextButton(
                  onPressed: _markFeePaid,
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: Size.zero),
                  child: Text(widget.l10n.markAsPaid, style: const TextStyle(fontSize: 10, color: ShellTokens.accent)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _finRow(String label, double amount, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
          Text('${amount.toStringAsFixed(0)} DA',
            style: TextStyle(fontSize: 11, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: color)),
        ],
      ),
    );
  }
}

class _EnrollmentList extends StatefulWidget {
  final AppDatabase database;
  final String studentId;
  final AppLocalizations l10n;

  const _EnrollmentList({required this.database, required this.studentId, required this.l10n});

  @override
  State<_EnrollmentList> createState() => _EnrollmentListState();
}

class _EnrollmentListState extends State<_EnrollmentList> {
  List<Enrollment> _enrollments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = EnrollmentRepository(widget.database);
    final all = await repo.getByStudent(widget.studentId);
    if (mounted) setState(() { _enrollments = all; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 20, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_enrollments.isEmpty) return Text(widget.l10n.noEnrollments, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled));

    final activeCount = _enrollments.where((e) => e.status == 'active').length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            widget.l10n.enrollmentCount('$activeCount'),
            style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled),
          ),
        ),
        ..._enrollments.map((e) => _EnrollmentRow(
          enrollment: e,
          database: widget.database,
          l10n: widget.l10n,
        )),
      ],
    );
  }
}

class _EnrollmentRow extends StatefulWidget {
  final Enrollment enrollment;
  final AppDatabase database;
  final AppLocalizations l10n;

  const _EnrollmentRow({required this.enrollment, required this.database, required this.l10n});

  @override
  State<_EnrollmentRow> createState() => _EnrollmentRowState();
}

class _EnrollmentRowState extends State<_EnrollmentRow> {
  String _groupName = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final group = await SubjectGroupRepository(widget.database).getById(widget.enrollment.subjectGroupId);
    if (mounted) setState(() => _groupName = group?.nameAr ?? widget.enrollment.subjectGroupId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: widget.enrollment.status == 'active' ? SemanticTokens.success : ShellTokens.textDisabled,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(_groupName, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
          Text(widget.enrollment.status, style: TextStyle(fontSize: 10, color: widget.enrollment.status == 'active' ? SemanticTokens.success : ShellTokens.textDisabled)),
        ],
      ),
    );
  }
}

class _StudentEditDialog extends StatefulWidget {
  final AppDatabase database;
  final Student? student;
  final AppLocalizations l10n;

  const _StudentEditDialog({required this.database, this.student, required this.l10n});

  @override
  State<_StudentEditDialog> createState() => _StudentEditDialogState();
}

class _StudentEditDialogState extends State<_StudentEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final StudentRepository _repo;
  bool _saving = false;

  late TextEditingController _codeCtrl;
  late TextEditingController _firstNameArCtrl;
  late TextEditingController _lastNameArCtrl;
  late TextEditingController _firstNameFrCtrl;
  late TextEditingController _lastNameFrCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _birthPlaceCtrl;
  String _gender = 'male';
  String _status = 'active';
  String? _schoolLevel;
  DateTime? _birthDate;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    final s = widget.student;
    _isEdit = s != null;
    _codeCtrl = TextEditingController(text: s?.code ?? '');
    _firstNameArCtrl = TextEditingController(text: s?.firstNameAr ?? '');
    _lastNameArCtrl = TextEditingController(text: s?.lastNameAr ?? '');
    _firstNameFrCtrl = TextEditingController(text: s?.firstNameFr ?? '');
    _lastNameFrCtrl = TextEditingController(text: s?.lastNameFr ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _addressCtrl = TextEditingController(text: s?.address ?? '');
    _birthPlaceCtrl = TextEditingController(text: s?.birthPlace ?? '');
    if (s != null) {
      _gender = s.gender ?? 'male';
      _status = s.status;
      _schoolLevel = s.schoolLevel;
      _birthDate = s.birthDate;
    } else {
      _repo.generateCode().then((c) { if (mounted) _codeCtrl.text = c; });
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _firstNameArCtrl.dispose();
    _lastNameArCtrl.dispose();
    _firstNameFrCtrl.dispose();
    _lastNameFrCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _birthPlaceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      String? photoPath;
      if (_photo != null) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final saved = await _photo!.copy('${dir.path}/$fileName');
        photoPath = saved.path;
      }
      final entry = StudentsCompanion(
        code: Value(_codeCtrl.text.trim()),
        firstNameAr: Value(_firstNameArCtrl.text.trim()),
        lastNameAr: Value(_lastNameArCtrl.text.trim()),
        firstNameFr: Value(_firstNameFrCtrl.text.trim().isEmpty ? null : _firstNameFrCtrl.text.trim()),
        lastNameFr: Value(_lastNameFrCtrl.text.trim().isEmpty ? null : _lastNameFrCtrl.text.trim()),
        phone: Value(_phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim()),
        address: Value(_addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim()),
        gender: Value(_gender),
        status: Value(_status),
        schoolLevel: Value(_schoolLevel),
        birthDate: Value(_birthDate),
        birthPlace: Value(_birthPlaceCtrl.text.trim().isEmpty ? null : _birthPlaceCtrl.text.trim()),
        photoPath: Value(photoPath),
      );
      if (_isEdit) {
        await _repo.update(widget.student!.id, entry);
      } else {
        await _repo.create(entry);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 700),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
                child: Row(
                  children: [
                    Text(_isEdit ? l10n.editStudent : l10n.add, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                    const Spacer(),
                    IconButton(icon: const Icon(PhosphorIcons.x, size: 18, color: ShellTokens.textSecondary), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionDivider(l10n.personalInfo),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _pickPhoto,
                            child: Container(
                              width: 72, height: 88,
                              decoration: BoxDecoration(
                                color: ShellTokens.chromeBase,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: ShellTokens.chromeBorder),
                              ),
                              child: _photo != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.file(_photo!, width: 72, height: 88, fit: BoxFit.cover),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(PhosphorIcons.camera, size: 18, color: ShellTokens.textDisabled),
                                        const SizedBox(height: 2),
                                        Text(l10n.takePhoto.substring(0, 4), style: const TextStyle(fontSize: 8, color: ShellTokens.textDisabled)),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _textField(_codeCtrl, required: true, readOnly: _isEdit),
                                const SizedBox(height: 8),
                                _textField(_firstNameArCtrl, required: true, hint: '${l10n.firstName} AR'),
                                const SizedBox(height: 8),
                                _textField(_firstNameFrCtrl, hint: '${l10n.firstName} FR'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _textField(_lastNameArCtrl, required: true, hint: '${l10n.lastName} AR')),
                          const SizedBox(width: 8),
                          Expanded(child: _textField(_lastNameFrCtrl, hint: '${l10n.lastName} FR')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _sectionDivider(l10n.phone),
                      const SizedBox(height: 8),
                      _textField(_phoneCtrl),
                      const SizedBox(height: 8),
                      _textField(_addressCtrl, maxLines: 2, hint: l10n.address),
                      const SizedBox(height: 14),
                      _sectionDivider(l10n.schoolLevel),
                      const SizedBox(height: 8),
                      _schoolLevelAutocomplete(l10n),
                      const SizedBox(height: 14),
                      _sectionDivider('${l10n.gender} / ${l10n.birthDate}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _dropdown(
                              value: _gender,
                              items: [
                                DropdownMenuItem(value: 'male', child: Text(l10n.male, style: const TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'female', child: Text(l10n.female, style: const TextStyle(fontSize: 12))),
                              ],
                              onChanged: (v) => setState(() => _gender = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _dateField(l10n),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _textField(_birthPlaceCtrl, hint: l10n.birthPlace),
                      if (_isEdit) ...[
                        const SizedBox(height: 8),
                        _dropdown(
                          value: _status,
                          items: [
                            DropdownMenuItem(value: 'active', child: Text(l10n.active, style: const TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 'inactive', child: Text(l10n.inactive, style: const TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 'graduated', child: Text(l10n.graduated, style: const TextStyle(fontSize: 12))),
                          ],
                          onChanged: (v) => setState(() => _status = v!),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _saving ? null : _save,
                          style: FilledButton.styleFrom(
                            backgroundColor: ShellTokens.accent,
                            foregroundColor: ShellTokens.chromeBase,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(_isEdit ? l10n.update : l10n.create),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  File? _photo;
  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 400);
    if (image != null) setState(() => _photo = File(image.path));
  }

  Widget _sectionDivider(String text) {
    return Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.5));
  }

  Widget _dateField(AppLocalizations l10n) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: _birthDate ?? DateTime(2010, 1, 1),
          firstDate: DateTime(1990),
          lastDate: DateTime.now(),
          locale: Localizations.localeOf(context),
        );
        if (d != null) setState(() => _birthDate = d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: ShellTokens.chromeBase,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ShellTokens.chromeBorder),
        ),
        child: Text(
          _birthDate != null ? _fmtDate(_birthDate!) : l10n.birthDate,
          style: TextStyle(fontSize: 12, color: _birthDate != null ? ShellTokens.textPrimary : ShellTokens.textDisabled),
        ),
      ),
    );
  }

  Widget _schoolLevelAutocomplete(AppLocalizations l10n) {
    final repo = SchoolLevelRepository(widget.database);
    return FutureBuilder<List<SchoolLevel>>(
      future: repo.searchByName(''),
      builder: (ctx, snap) {
        final levels = snap.data ?? [];
        final items = <DropdownMenuItem<String?>>[
          DropdownMenuItem(value: null, child: Text(l10n.noData, style: const TextStyle(fontSize: 12, color: ShellTokens.textDisabled))),
          ...levels.map((l) => DropdownMenuItem(value: l.name, child: Text(l.name, style: const TextStyle(fontSize: 12)))),
          const DropdownMenuItem(value: '__new__', child: Row(children: [Icon(PhosphorIcons.plus, size: 12, color: ShellTokens.accent), SizedBox(width: 4), Text('New...', style: TextStyle(fontSize: 12, color: ShellTokens.accent))])),
        ];
        return _dropdown(
          value: _schoolLevel,
          items: items,
          onChanged: (v) async {
            if (v == '__new__') {
              final ctrl = TextEditingController();
              final name = await showDialog<String>(context: context, builder: (c) => AlertDialog(
                backgroundColor: ShellTokens.chromeSurface,
                title: Text(l10n.add, style: const TextStyle(fontSize: 14, color: ShellTokens.textPrimary)),
                content: TextField(controller: ctrl, autofocus: true, style: const TextStyle(color: ShellTokens.textPrimary)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.cancel)),
                  TextButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: Text(l10n.add)),
                ],
              ));
              if (name != null && name.isNotEmpty) {
                await repo.create(name);
                setState(() => _schoolLevel = name);
              }
            } else {
              setState(() => _schoolLevel = v);
            }
          },
        );
      },
    );
  }

  Widget _textField(TextEditingController ctrl, {bool required = false, bool readOnly = false, int maxLines = 1, String? hint}) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: ShellTokens.chromeBase,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
        errorStyle: const TextStyle(fontSize: 10),
      ),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? widget.l10n.fieldRequired : null : null,
    );
  }

  Widget _dropdown({required String? value, required List<DropdownMenuItem<String?>> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String?>(
      value: value,
      items: items,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: ShellTokens.chromeBase,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
      ),
    );
  }

  String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
