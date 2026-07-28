import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' hide Border;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/school_level_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_pagination_bar.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_empty_state.dart';
import '../../constants/app_constants.dart';
import '../payments/student_history_dialog.dart';
import '../payments/unified_payment_screen.dart';

class StudentBalancesScreen extends StatefulWidget {
  final AppDatabase database;

  const StudentBalancesScreen({super.key, required this.database});

  @override
  State<StudentBalancesScreen> createState() => _StudentBalancesScreenState();
}

class _StudentBalancesScreenState extends State<StudentBalancesScreen> {
  late final StudentRepository _studentRepo;
  List<Map<String, dynamic>> _rows = [];
  int _total = 0;
  int _page = 0;
  static const int _pageSize = 20;
  bool _loading = true;

  String _statusFilter = 'all';
  String _levelFilter = 'all';
  String _groupFilter = 'all';
  String _searchQuery = '';
  String? _sortColumn;
  bool _sortAsc = false;

  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;
  List<_SelectOption> _levels = [];
  List<_SelectOption> _groups = [];

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _loadFilters();
    _fetchPage();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadFilters() async {
    final schoolRepo = SchoolLevelRepository(widget.database);
    final groupRepo = SubjectGroupRepository(widget.database);
    final results = await Future.wait([
      schoolRepo.getAll(),
      groupRepo.getAll(),
    ]);
    if (mounted) {
      setState(() {
        _levels = (results[0] as List)
            .map((l) => _SelectOption((l as dynamic).name, (l as dynamic).name))
            .toList();
        _groups = (results[1] as List<SubjectGroup>)
            .map((g) => _SelectOption(g.nameAr, g.id))
            .toList();
      });
    }
  }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    try {
      final sortMap = {'name': 'name', 'debt': 'debt', 'code': 'code'};
      final result = await widget.database.getStudentBalancesPage(
        offset: _page * _pageSize,
        limit: _pageSize,
        statusFilter: _statusFilter,
        schoolLevel: _levelFilter,
        groupId: _groupFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        sortField: _sortColumn != null ? sortMap[_sortColumn] : 'debt',
        sortAsc: _sortAsc,
      );
      if (mounted) {
        setState(() {
          _rows = (result['entries'] as List).cast<Map<String, dynamic>>();
          _total = result['total'] as int;
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

  void _clearFilters() {
    _searchCtrl.clear();
    _searchQuery = '';
    _statusFilter = 'all';
    _levelFilter = 'all';
    _groupFilter = 'all';
    _page = 0;
    _fetchPage();
  }

  void _openDetail(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (_) => _StudentBalanceDetailDialog(
        database: widget.database,
        studentId: entry['studentId'] as String,
        studentName: '${entry['firstName']} ${entry['lastName']}',
        studentCode: entry['code'] as String,
        balance: entry['balance'] as double,
        totalCharged: entry['totalCharged'] as double,
        totalPaid: entry['totalPaid'] as double,
      ),
    ).then((_) => _fetchPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalPages = (_total / _pageSize).ceil();
    final hasFilters = _searchQuery.isNotEmpty || _statusFilter != 'all' || _levelFilter != 'all' || _groupFilter != 'all';

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(
        children: [
          _buildToolbar(l10n, hasFilters),
          Expanded(child: _buildBody(l10n)),
          if (!_loading && _total > 0)
            _buildPagination(l10n, totalPages),
        ],
      ),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n, bool hasFilters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(
        children: [
          Row(children: [
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
                            onPressed: _clearFilters, tooltip: l10n.clearFilters)
                        : null,
                    filled: true, fillColor: ShellTokens.chromeSurface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
            ),
            const SizedBox(width: 6),
            _buildDropdown(l10n.schoolLevel, _levelFilter, [_SelectOption(l10n.all, 'all'), ..._levels],
                (v) { setState(() => _levelFilter = v); _page = 0; _fetchPage(); }),
            const SizedBox(width: 6),
            _buildDropdown(l10n.groups, _groupFilter, [const _SelectOption('All', 'all'), ..._groups],
                (v) { setState(() => _groupFilter = v); _page = 0; _fetchPage(); }),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            child: Row(children: [
              _buildFilterChip(l10n.all, 'all'),
              _buildFilterChip(l10n.debt, 'owing'),
              _buildFilterChip(l10n.balance, 'settled'),
              _buildFilterChip('Credit', 'credit'),
              const SizedBox(width: 8),
              _buildExportBtn(l10n.exportExcel, PhosphorIcons.table),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<_SelectOption> options, ValueChanged<String> onChanged) {
    return SizedBox(
      width: 140, height: 34,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: ShellInputDecoration.dropdown(),
        style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary),
        items: options.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _statusFilter == value;
    return ShellFilterChip(label: label, selected: selected, onTap: () {
      setState(() { _statusFilter = selected ? 'all' : value; _page = 0; });
      _fetchPage();
    });
  }

  Widget _buildExportBtn(String label, IconData icon) {
    return Material(
      color: ShellTokens.chromeSurface, borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () => _exportExcel(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 13, color: ShellTokens.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
          ]),
        ),
      ),
    );
  }

  Future<void> _exportExcel() async {
    final l10n = AppLocalizations.of(context);
    final excel = Excel.createExcel();
    final sheet = excel[l10n.outstandingDebts];
    sheet.appendRow([TextCellValue(l10n.code), TextCellValue(l10n.name), TextCellValue(l10n.schoolLevel), TextCellValue(l10n.totalCharged), TextCellValue(l10n.totalPaid), TextCellValue(l10n.remaining)]);
    for (final r in _rows) {
      sheet.appendRow([
        TextCellValue((r['code'] as String?) ?? ''),
        TextCellValue('${r['firstName']} ${r['lastName']}'),
        TextCellValue((r['schoolLevel'] as String?) ?? ''),
        TextCellValue((r['totalCharged'] as num).toStringAsFixed(0)),
        TextCellValue((r['totalPaid'] as num).toStringAsFixed(0)),
        TextCellValue((r['balance'] as num).toStringAsFixed(0)),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/outstanding_debts.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${l10n.exportExcel}: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
    }
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    if (_rows.isEmpty) return AppEmptyState(icon: PhosphorIcons.wallet, message: l10n.noData);
    return Column(children: [
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1.2), 2: FlexColumnWidth(1.2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)),
        children: [_buildHeaderRow(l10n)],
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Table(
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1.2), 2: FlexColumnWidth(1.2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)),
            children: _rows.asMap().entries.map((e) => _buildDataRow(e.value, e.key, l10n)).toList(),
          ),
        ),
      ),
    ]);
  }

  TableRow _buildHeaderRow(AppLocalizations l10n) {
    return TableRow(
      decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
      children: [
        _headerCell(l10n.columnName, 'name'),
        _headerCell(l10n.schoolLevel, null),
        _headerCell(l10n.totalCharged, null),
        _headerCell(l10n.totalPaid, null),
        _headerCell(l10n.remaining, 'debt'),
        _headerCell(l10n.code, 'code'),
      ],
    );
  }

  Widget _headerCell(String label, String? sortKey) {
    return GestureDetector(
      onTap: sortKey != null ? () {
        setState(() {
          if (_sortColumn == sortKey) { _sortAsc = !_sortAsc; } else { _sortColumn = sortKey; _sortAsc = true; }
        });
        _page = 0; _fetchPage();
      } : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
          if (_sortColumn == sortKey)
            Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: ShellTokens.textSecondary),
        ]),
      ),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> entry, int index, AppLocalizations l10n) {
    final balance = entry['balance'] as double;
    final isEven = index.isEven;

    return TableRow(
      decoration: BoxDecoration(
        color: isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3),
      ),
      children: [
        GestureDetector(
          onTap: () => _openDetail(entry),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('${entry['firstName']} ${entry['lastName']}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
              if (entry['schoolLevel'] != null)
                Text(entry['schoolLevel'] as String, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
            ]),
          ),
        ),
        GestureDetector(onTap: () => _openDetail(entry), behavior: HitTestBehavior.opaque,
          child: _textCell(entry['schoolLevel'] as String? ?? '—')),
        GestureDetector(onTap: () => _openDetail(entry), behavior: HitTestBehavior.opaque,
          child: _textCell('${(entry['totalCharged'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}')),
        GestureDetector(onTap: () => _openDetail(entry), behavior: HitTestBehavior.opaque,
          child: _textCell('${(entry['totalPaid'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}')),
        GestureDetector(
          onTap: () => _openDetail(entry),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text('${balance.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                color: balance > 0 ? SemanticTokens.error : SemanticTokens.success)),
          ),
        ),
        GestureDetector(onTap: () => _openDetail(entry), behavior: HitTestBehavior.opaque,
          child: _textCell(entry['code'] as String)),
      ],
    );
  }

  Widget _textCell(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(t, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildPagination(AppLocalizations l10n, int totalPages) {
    final start = _page * _pageSize + 1;
    final end = (_page + 1) * _pageSize > _total ? _total : (_page + 1) * _pageSize;
    return ShellPaginationBar(
      page: _page, pageSize: _pageSize, rowCount: end - start + 1, total: _total,
      onPrevious: () { setState(() { _page = (_page - 1).clamp(0, totalPages - 1); }); _fetchPage(); },
      onNext: () { setState(() { _page = (_page + 1).clamp(0, totalPages - 1); }); _fetchPage(); },
      showingResultsText: l10n.showingResults(start, end, _total),
    );
  }
}

class _SelectOption {
  final String label;
  final String value;
  const _SelectOption(this.label, this.value);
}

class _StudentBalanceDetailDialog extends StatefulWidget {
  final AppDatabase database;
  final String studentId;
  final String studentName;
  final String studentCode;
  final double balance;
  final double totalCharged;
  final double totalPaid;

  const _StudentBalanceDetailDialog({
    required this.database,
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.balance,
    required this.totalCharged,
    required this.totalPaid,
  });

  @override
  State<_StudentBalanceDetailDialog> createState() => _StudentBalanceDetailDialogState();
}

class _StudentBalanceDetailDialogState extends State<_StudentBalanceDetailDialog> {
  bool _saving = false;

  Future<void> _recordPayment() async {
    final l10n = AppLocalizations.of(context);
    final amountCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 440, title: l10n.recordPayment,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShellSectionHeader(text: widget.studentName, withBorder: false),
          const SizedBox(height: 4),
          Text(widget.studentCode, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
          const SizedBox(height: 12),
          TextField(
            controller: amountCtrl, autofocus: true, keyboardType: TextInputType.number,
            decoration: ShellInputDecoration.textField(hintText: '${l10n.amount} (${AppConstants.currencySymbol})'),
            style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: reasonCtrl,
            decoration: ShellInputDecoration.textField(hintText: l10n.reason),
            style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive)));
                return;
              }
              await TransactionService(widget.database).createStudentPayment(
                studentId: widget.studentId, amount: amount, note: reasonCtrl.text);
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.save)),
          ),
        ]),
      ),
    );
    amountCtrl.dispose();
    reasonCtrl.dispose();
    if (result == true && mounted) Navigator.pop(context, true);
  }

  void _openHistory() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => StudentHistoryDialog(database: widget.database, studentId: widget.studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final balance = widget.balance;
    return ShellDialog(
      maxWidth: 440, title: widget.studentName,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.studentCode, style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
        const SizedBox(height: 16),
        Row(children: [
          _statCard(l10n.totalCharged, widget.totalCharged, const Color(0xFF4A90D9)),
          const SizedBox(width: 8),
          _statCard(l10n.totalPaid, widget.totalPaid, SemanticTokens.success),
          const SizedBox(width: 8),
          _statCard(l10n.remaining, balance, balance > 0 ? SemanticTokens.error : SemanticTokens.success),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: FilledButton.icon(
            onPressed: _recordPayment,
            icon: const Icon(PhosphorIcons.currencyCircleDollar, size: 14),
            label: Text(l10n.recordPayment, style: const TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(
            onPressed: _openHistory,
            icon: const Icon(PhosphorIcons.scroll, size: 14, color: ShellTokens.textSecondary),
            label: Text(l10n.paymentHistory, style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: ShellTokens.chromeBorder), padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
        ]),
      ]),
    );
  }

  Widget _statCard(String label, double value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Column(children: [
          Text('${value.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
