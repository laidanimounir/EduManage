import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' hide Text;
import 'package:excel/excel.dart' hide Border;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/audit_log_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_badge.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_filter_chip.dart';
import '../../widgets/shell_pagination_bar.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_empty_state.dart';
import '../../constants/app_constants.dart';
import 'student_history_dialog.dart';
import '../../utils/pdf_generator.dart';

class UnifiedPaymentScreen extends StatefulWidget {
  final AppDatabase database;
  final String? initialStudentCode;

  const UnifiedPaymentScreen({
    super.key,
    required this.database,
    this.initialStudentCode,
  });

  @override
  State<UnifiedPaymentScreen> createState() => _UnifiedPaymentScreenState();
}

class _UnifiedPaymentScreenState extends State<UnifiedPaymentScreen> {
  late final TransactionService _txService;
  late final TransactionRepository _txRepo;
  late final StudentRepository _studentRepo;

  List<Map<String, dynamic>> _rows = [];
  int _total = 0;
  int _page = 0;
  static const int _pageSize = 20;
  bool _loading = true;

  String _typeFilter = 'all';
  String? _studentFilter;
  String _searchQuery = '';
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _sortColumn;
  bool _sortAsc = false;
  Set<String> _selectedIds = {};

  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _txService = TransactionService(widget.database);
    _txRepo = TransactionRepository(widget.database);
    _studentRepo = StudentRepository(widget.database);
    _fetchPage();
    if (widget.initialStudentCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadStudentFilter());
    }
  }

  Future<void> _loadStudentFilter() async {
    final student = await _studentRepo.getByCode(widget.initialStudentCode!.trim());
    if (student != null && mounted) {
      setState(() => _studentFilter = student.id);
      _searchCtrl.text = student.firstNameAr;
      _searchQuery = student.firstNameAr;
      _page = 0;
      _fetchPage();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchPage() async {
    setState(() => _loading = true);
    try {
      final result = await widget.database.getTransactionsPage(
        offset: _page * _pageSize,
        limit: _pageSize,
        typeFilter: _typeFilter,
        studentFilter: _studentFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        sortField: _sortColumn,
        sortAsc: _sortAsc,
      );
      if (mounted) {
        setState(() {
          _rows = (result['transactions'] as List).cast<Map<String, dynamic>>();
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
      _selectedIds.clear();
      _fetchPage();
    });
  }

  void _onTypeFilter(String f) {
    setState(() { _typeFilter = f; _page = 0; _selectedIds.clear(); });
    _fetchPage();
  }

  void _clearFilters() {
    _searchCtrl.clear();
    _searchQuery = '';
    _studentFilter = null;
    _typeFilter = 'all';
    _dateFrom = null;
    _dateTo = null;
    _page = 0;
    _selectedIds.clear();
    _fetchPage();
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == _rows.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = _rows.map((r) => (r['transaction'] as Transaction).id).toSet();
      }
    });
  }

  void _openDetail(Transaction tx) {
    showDialog(
      context: context,
      builder: (_) => _TransactionDetailDialog(database: widget.database, transaction: tx),
    ).then((_) => _fetchPage());
  }

  void _openRecordPayment() {
    showDialog<bool>(
      context: context,
      builder: (_) => _RecordPaymentDialog(database: widget.database),
    ).then((v) { if (v == true) _fetchPage(); });
  }

  void _openRecordExpense() {
    showDialog<bool>(
      context: context,
      builder: (_) => _RecordExpenseDialog(database: widget.database),
    ).then((v) { if (v == true) _fetchPage(); });
  }

  void _openVoidTransaction(Transaction tx) {
    showDialog<bool>(
      context: context,
      builder: (_) => _VoidTransactionDialog(database: widget.database, transaction: tx),
    ).then((v) { if (v == true) _fetchPage(); });
  }

  void _openStudentHistory() async {
    final student = await showDialog<Student>(
      context: context,
      builder: (ctx) => _StudentSearchDialog(database: widget.database),
    );
    if (student != null && mounted) {
      showDialog(
        context: context,
        builder: (_) => StudentHistoryDialog(database: widget.database, studentId: student.id),
      );
    }
  }

  void _openClosePeriod() {
    showDialog(
      context: context,
      builder: (_) => _ClosePeriodDialog(database: widget.database),
    ).then((_) => _fetchPage());
  }

  void _openBalanceTransfer() {
    showDialog(
      context: context,
      builder: (_) => _BalanceTransferDialog(database: widget.database),
    ).then((_) => _fetchPage());
  }

  void _openRefundCredit() {
    showDialog(
      context: context,
      builder: (_) => _RefundCreditDialog(database: widget.database),
    ).then((_) => _fetchPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalPages = (_total / _pageSize).ceil();
    final hasSelection = _selectedIds.isNotEmpty;
    final hasFilters = _searchQuery.isNotEmpty || _typeFilter != 'all' || _dateFrom != null || _studentFilter != null;

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(
        children: [
          if (hasSelection)
            _buildSelectionBar(l10n),
          _buildToolbar(l10n, hasFilters),
          Expanded(child: _buildBody(l10n)),
          if (!_loading && _total > 0)
            _buildPagination(l10n, totalPages),
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
          Text('${_selectedIds.length} ${l10n.selected}',
            style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          const Spacer(),
          TextButton.icon(
            onPressed: _toggleSelectAll,
            icon: Icon(_selectedIds.length == _rows.length ? PhosphorIcons.arrowLeft : PhosphorIcons.squaresFour, size: 16),
            label: Text(_selectedIds.length == _rows.length ? l10n.clearSelection : l10n.selectAll),
            style: TextButton.styleFrom(foregroundColor: ShellTokens.textPrimary),
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
            const SizedBox(width: 8),
            _buildDateButton(l10n, _dateFrom, l10n.from, (d) { setState(() => _dateFrom = d); _page = 0; _fetchPage(); }),
            const SizedBox(width: 4),
            _buildDateButton(l10n, _dateTo, l10n.to, (d) { setState(() => _dateTo = d); _page = 0; _fetchPage(); }),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            child: Row(children: [
              _buildFilterChip(l10n.all, 'all'),
              _buildFilterChip(l10n.payments, 'student_payment'),
              _buildFilterChip(l10n.sessionCharges, 'session_charge'),
              _buildFilterChip(l10n.registrationFee, 'registration_fee'),
              _buildFilterChip(l10n.teacherPayouts, 'teacher_payout'),
              _buildFilterChip(l10n.expenses, 'expense'),
              _buildFilterChip(l10n.correction, 'correction'),
              _buildFilterChip(l10n.reversal, 'reversal'),
              const SizedBox(width: 8),
              _buildExportBtn(l10n.exportPdf, PhosphorIcons.file),
              const SizedBox(width: 4),
              _buildExportBtn(l10n.exportExcel, PhosphorIcons.table),
              const Spacer(),
              IconButton(icon: const Icon(PhosphorIcons.receipt, size: 16, color: ShellTokens.textSecondary),
                onPressed: _openStudentHistory, tooltip: l10n.paymentHistory, padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
              IconButton(icon: const Icon(PhosphorIcons.arrowsLeftRight, size: 16, color: ShellTokens.textSecondary),
                onPressed: _openBalanceTransfer, tooltip: 'Transfer', padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
              IconButton(icon: const Icon(PhosphorIcons.archive, size: 16, color: ShellTokens.textSecondary),
                onPressed: _openClosePeriod, tooltip: 'Close Period', padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
              IconButton(icon: const Icon(PhosphorIcons.arrowCounterClockwise, size: 16, color: ShellTokens.textSecondary),
                onPressed: _openRefundCredit, tooltip: 'Refund/Credit', padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
              IconButton(icon: const Icon(PhosphorIcons.plus, size: 18, color: ShellTokens.accent),
                onPressed: _openRecordPayment, tooltip: l10n.recordPayment, padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(AppLocalizations l10n, DateTime? value, String label, ValueChanged<DateTime> onPick) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (d != null) onPick(d);
      },
      child: Container(
        height: 34, padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: ShellTokens.chromeSurface, borderRadius: BorderRadius.circular(6),
            border: Border.all(color: value != null ? ShellTokens.accent : ShellTokens.chromeBorder)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value != null ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}' : label,
            style: TextStyle(fontSize: 11, color: value != null ? ShellTokens.textPrimary : ShellTokens.textDisabled)),
          if (value != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () { setState(() {
                if (label == l10n.from) { _dateFrom = null; } else { _dateTo = null; }
              }); _page = 0; _fetchPage(); },
              child: const Icon(PhosphorIcons.x, size: 12, color: ShellTokens.textSecondary),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildExportBtn(String label, IconData icon) {
    return Material(
      color: ShellTokens.chromeSurface, borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).comingSoon),
            backgroundColor: ShellTokens.chromeSurface));
        },
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

  Widget _buildFilterChip(String label, String value) {
    final selected = _typeFilter == value;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => _onTypeFilter(selected ? 'all' : value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_loading) return const AppLoading();
    if (_rows.isEmpty) return AppEmptyState(icon: PhosphorIcons.currencyCircleDollar, message: l10n.noData);
    return Column(children: [
      Table(
        columnWidths: const {
          0: FixedColumnWidth(44), 1: FixedColumnWidth(90), 2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.8), 4: FixedColumnWidth(90), 5: FixedColumnWidth(70), 6: FlexColumnWidth(1.5), 7: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: const TableBorder(bottom: BorderSide(color: ShellTokens.chromeBorder)),
        children: [_buildHeaderRow(l10n)],
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(44), 1: FixedColumnWidth(90), 2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.8), 4: FixedColumnWidth(90), 5: FixedColumnWidth(70), 6: FlexColumnWidth(1.5), 7: IntrinsicColumnWidth(),
            },
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
        _buildHeaderCell(PhosphorIcons.checkSquare, null),
        _buildHeaderCell(null, l10n.date),
        _buildHeaderCell(null, l10n.transactionType),
        _buildHeaderCell(null, l10n.studentOrTeacher),
        _buildHeaderCell(null, l10n.amount),
        _buildHeaderCell(null, l10n.paymentMethod),
        _buildHeaderCell(null, l10n.note),
        _buildHeaderCell(PhosphorIcons.gear, null),
      ],
    );
  }

  Widget _buildHeaderCell(IconData? icon, String? label) {
    return GestureDetector(
      onTap: label != null ? () {
        setState(() {
          if (_sortColumn == label) { _sortAsc = !_sortAsc; } else { _sortColumn = label; _sortAsc = true; }
        });
        _page = 0; _fetchPage();
      } : (icon == PhosphorIcons.checkSquare ? _toggleSelectAll : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null)
            Icon(icon, size: 14, color: ShellTokens.textSecondary)
          else ...[
            Text(label!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled, letterSpacing: 0.3)),
            if (_sortColumn == label)
              Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: ShellTokens.textSecondary),
          ],
        ]),
      ),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> entry, int index, AppLocalizations l10n) {
    final tx = entry['transaction'] as Transaction;
    final isSelected = _selectedIds.contains(tx.id);
    final isEven = index.isEven;
    final resolvedName = entry['studentName'] as String? ?? entry['teacherName'] as String? ?? '—';

    return TableRow(
      decoration: BoxDecoration(
        color: isSelected ? ShellTokens.accentMuted.withValues(alpha: 0.3)
            : isEven ? Colors.transparent : ShellTokens.chromeBase.withValues(alpha: 0.3),
      ),
      children: [
        _buildCheckCell(tx, isSelected),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(_formatDate(tx.transactionDate), style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)))),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: _typeBadge(tx.type, l10n))),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(resolvedName, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis))),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text('${tx.amount.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                color: _amountColor(tx.type))),
          )),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(tx.paymentMethod != null ? _paymentMethodLabel(tx.paymentMethod!, l10n) : '—',
              style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)))),
        GestureDetector(onTap: () => _openDetail(tx), behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(tx.note ?? '', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled), maxLines: 1, overflow: TextOverflow.ellipsis))),
        _buildActionsCell(tx),
      ],
    );
  }

  Widget _buildCheckCell(Transaction tx, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) { _selectedIds.remove(tx.id); } else { _selectedIds.add(tx.id); }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Container(width: 14, height: 14,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
            border: Border.all(color: isSelected ? ShellTokens.accent : ShellTokens.chromeBorder, width: 1.5),
            color: isSelected ? ShellTokens.accent : Colors.transparent),
          child: isSelected ? const Icon(Icons.check, size: 9, color: ShellTokens.chromeBase) : null),
      ),
    );
  }

  Widget _buildActionsCell(Transaction tx) {
    final isPayment = tx.type == 'student_payment' || tx.type == 'registration_fee_payment';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (isPayment)
          IconButton(icon: const Icon(PhosphorIcons.receipt, size: 14, color: ShellTokens.accent),
            onPressed: () async {
              try {
                final receiptNo = 'REC-${tx.id.hashCode.abs().toString().substring(0, 6)}';
                final path = await PdfGenerator.generatePaymentReceipt(
                  database: widget.database,
                  transactionId: tx.id,
                  receiptNumber: receiptNo,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Receipt saved: $path'), backgroundColor: ShellTokens.chromeSurface));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            }, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: AppLocalizations.of(context).receipt),
        IconButton(icon: const Icon(PhosphorIcons.info, size: 14, color: ShellTokens.textSecondary),
          onPressed: () => _openDetail(tx), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          tooltip: AppLocalizations.of(context).details),
        if (tx.type != 'reversal' && tx.type != 'session_cancellation_reversal')
          IconButton(icon: const Icon(PhosphorIcons.arrowCounterClockwise, size: 14, color: SemanticTokens.warning),
            onPressed: () => _openVoidTransaction(tx), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: AppLocalizations.of(context).reversal),
      ]),
    );
  }

  Widget _typeBadge(String type, AppLocalizations l10n) {
    final label = _txTypeLabel(type, l10n);
    final color = _txTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }

  String _txTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'session_charge': return l10n.sessionCharges;
      case 'student_payment': return l10n.payments;
      case 'registration_fee': return l10n.registrationFee;
      case 'registration_fee_payment': return l10n.registrationFeePayment;
      case 'teacher_payout': return l10n.teacherPayouts;
      case 'expense': return l10n.expenses;
      case 'correction': return l10n.correction;
      case 'reversal': return l10n.reversal;
      case 'discount': return l10n.discount;
      case 'session_cancellation_reversal': return l10n.sessionCancellationReversal;
      default: return type;
    }
  }

  Color _txTypeColor(String type) {
    switch (type) {
      case 'session_charge':
      case 'registration_fee':
        return const Color(0xFF4A90D9);
      case 'student_payment':
      case 'registration_fee_payment':
        return SemanticTokens.success;
      case 'teacher_payout':
        return const Color(0xFF9B59B6);
      case 'expense':
        return const Color(0xFFE67E22);
      case 'correction':
        return const Color(0xFFE74C3C);
      case 'reversal':
      case 'session_cancellation_reversal':
        return const Color(0xFFE74C3C);
      case 'discount':
        return const Color(0xFF27AE60);
      default:
        return ShellTokens.textDisabled;
    }
  }

  Color _amountColor(String type) {
    switch (type) {
      case 'student_payment':
      case 'registration_fee_payment':
      case 'discount':
      case 'reversal':
      case 'session_cancellation_reversal':
        return SemanticTokens.success;
      case 'session_charge':
      case 'registration_fee':
      case 'expense':
      case 'teacher_payout':
      case 'correction':
        return SemanticTokens.error;
      default:
        return ShellTokens.textPrimary;
    }
  }

  String _paymentMethodLabel(String method, AppLocalizations l10n) {
    switch (method) {
      case 'cash': return l10n.cash;
      case 'card': return l10n.check;
      case 'bank_transfer': return l10n.paymentMethodBankTransfer;
      case 'mobile_payment': return l10n.paymentMethodMobile;
      default: return method;
    }
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

class _TransactionDetailDialog extends StatefulWidget {
  final AppDatabase database;
  final Transaction transaction;
  const _TransactionDetailDialog({required this.database, required this.transaction});
  @override
  State<_TransactionDetailDialog> createState() => _TransactionDetailDialogState();
}

class _TransactionDetailDialogState extends State<_TransactionDetailDialog> {
  String? _studentName;
  String? _teacherName;
  String? _sessionInfo;
  Transaction? _referenceTx;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tx = widget.transaction;
    final results = await Future.wait([
      if (tx.studentId != null) widget.database.customSelect(
        'SELECT first_name_ar, last_name_ar, code FROM students WHERE id = ?',
        variables: [Variable.withString(tx.studentId!)],
      ).map((r) => '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')} (${r.read<String>('code')})').getSingle(),
      if (tx.teacherId != null) widget.database.customSelect(
        'SELECT first_name_ar, last_name_ar, code FROM teachers WHERE id = ?',
        variables: [Variable.withString(tx.teacherId!)],
      ).map((r) => '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')} (${r.read<String>('code')})').getSingle(),
      if (tx.sessionId != null) widget.database.customSelect(
        'SELECT sg.name_ar FROM sessions s JOIN subject_groups sg ON s.subject_group_id = sg.id WHERE s.id = ?',
        variables: [Variable.withString(tx.sessionId!)],
      ).map((r) => r.read<String>('name_ar')).getSingle(),
      if (tx.referenceTransactionId != null) TransactionRepository(widget.database).getById(tx.referenceTransactionId!),
    ]);
    if (mounted) {
      int idx = 0;
      if (tx.studentId != null) _studentName = results[idx++] as String;
      if (tx.teacherId != null) _teacherName = results[idx++] as String;
      if (tx.sessionId != null) _sessionInfo = results[idx++] as String;
      if (tx.referenceTransactionId != null) _referenceTx = results[idx++] as Transaction?;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tx = widget.transaction;
    final isPayment = tx.type == 'student_payment' || tx.type == 'registration_fee_payment';
    return ShellDialog(
      maxWidth: 480,
      title: l10n.details,
      body: _loading
          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _detailRow(l10n.transactionId, tx.id),
        const SizedBox(height: 6),
        _detailRow(l10n.date, _formatDate(tx.transactionDate)),
        const SizedBox(height: 6),
        _detailRow(l10n.transactionType, _txTypeLabel(tx.type, l10n)),
        const SizedBox(height: 6),
        _detailRow(l10n.amount, '${tx.amount.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
        if (_studentName != null) ...[
          const SizedBox(height: 6),
          _detailRow(l10n.student, _studentName!),
        ],
        if (_teacherName != null) ...[
          const SizedBox(height: 6),
          _detailRow(l10n.teacher, _teacherName!),
        ],
        if (_sessionInfo != null) ...[
          const SizedBox(height: 6),
          _detailRow(l10n.group, _sessionInfo!),
        ],
        if (tx.paymentMethod != null) ...[
          const SizedBox(height: 6),
          _detailRow(l10n.paymentMethod, _paymentMethodLabel(tx.paymentMethod!, l10n)),
        ],
        if (tx.note != null && tx.note!.isNotEmpty) ...[
          const SizedBox(height: 6),
          _detailRow(l10n.note, tx.note!),
        ],
        if (tx.rateSnapshot != null && tx.rateSnapshot!.isNotEmpty) ...[
          const SizedBox(height: 6),
          _detailRow('Rate Snapshot', tx.rateSnapshot!),
        ],
        if (_referenceTx != null) ...[
          const SizedBox(height: 12),
          ShellSectionHeader(text: l10n.referenceTransaction, withBorder: true),
          const SizedBox(height: 4),
          Text('${_referenceTx!.id} (${_referenceTx!.amount.toStringAsFixed(0)} ${AppConstants.currencySymbol})',
            style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
        ],
        const SizedBox(height: 12),
        ShellSectionHeader(text: l10n.auditLog, withBorder: true),
        const SizedBox(height: 4),
        Text('${l10n.createdAt}: ${tx.createdAt.year}-${tx.createdAt.month.toString().padLeft(2, '0')}-${tx.createdAt.day.toString().padLeft(2, '0')} ${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
      ]),
      actions: isPayment ? Row(children: [
        IconButton(
          icon: const Icon(PhosphorIcons.receipt, size: 18, color: ShellTokens.accent),
          onPressed: () async {
            try {
              final receiptNo = 'REC-${tx.id.hashCode.abs().toString().substring(0, 6)}';
              final path = await PdfGenerator.generatePaymentReceipt(
                database: widget.database,
                transactionId: tx.id,
                receiptNumber: receiptNo,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Receipt saved: $path'), backgroundColor: ShellTokens.chromeSurface));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }
          },
          tooltip: 'Print Receipt',
        ),
      ]) : null,
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled, fontWeight: FontWeight.w600))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
    ]);
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _txTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'session_charge': return l10n.sessionCharges;
      case 'student_payment': return l10n.payments;
      case 'registration_fee': return l10n.registrationFee;
      case 'registration_fee_payment': return l10n.registrationFeePayment;
      case 'teacher_payout': return l10n.teacherPayouts;
      case 'expense': return l10n.expenses;
      case 'correction': return l10n.correction;
      case 'reversal': return l10n.reversal;
      case 'discount': return l10n.discount;
      case 'session_cancellation_reversal': return l10n.sessionCancellationReversal;
      default: return type;
    }
  }

  String _paymentMethodLabel(String method, AppLocalizations l10n) {
    switch (method) {
      case 'cash': return l10n.cash;
      case 'card': return l10n.check;
      case 'bank_transfer': return l10n.paymentMethodBankTransfer;
      case 'mobile_payment': return l10n.paymentMethodMobile;
      default: return method;
    }
  }
}

class _RecordPaymentDialog extends StatefulWidget {
  final AppDatabase database;
  const _RecordPaymentDialog({required this.database});
  @override
  State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<_RecordPaymentDialog> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  Student? _student;
  String _method = 'cash';
  bool _saving = false;
  List<Map<String, dynamic>> _charges = [];
  Set<String> _selectedCharges = {};
  bool _showAllocation = false;
  String? _savedTxId;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    final student = await showDialog<Student>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 400, title: l10n.selectStudent,
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: ctrl, autofocus: true,
            decoration: ShellInputDecoration.textField(hintText: '${l10n.code} أو ${l10n.name}'),
            onSubmitted: (q) async {
              try {
                final repo = StudentRepository(widget.database);
                final results = await repo.search(q);
                if (results.length == 1) {
                  if (ctx.mounted) Navigator.pop(ctx, results.first);
                } else if (results.isNotEmpty) {
                  final picked = await showDialog<Student>(
                    context: ctx,
                    builder: (c2) => ShellDialog(
                      maxWidth: 350, title: l10n.selectStudent,
                      body: Column(mainAxisSize: MainAxisSize.min, children: results.map((s) => ListTile(
                        title: Text('${s.firstNameAr} ${s.lastNameAr}',
                          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                        subtitle: Text(s.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                        onTap: () => Navigator.pop(c2, s),
                      )).toList()),
                    ),
                  );
                  if (picked != null && ctx.mounted) Navigator.pop(ctx, picked);
                } else {
                  if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.studentNotFound)));
                }
              } catch (e) {
                if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${l10n.errorOccurred}: $e')));
              }
            },
          ),
        ]),
      ),
    );
    ctrl.dispose();
    if (student != null && mounted) {
      setState(() => _student = student);
      try {
        await _loadCharges();
      } catch (_) {
        if (mounted) {
          setState(() => _student = null);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorOccurred)));
        }
      }
    }
  }

  Future<void> _loadCharges() async {
    if (_student == null) return;
    try {
      final service = TransactionService(widget.database);
      final charges = await service.getUnpaidCharges(_student!.id);
      if (mounted) setState(() => _charges = charges);
    } catch (_) {
      if (mounted) setState(() => _charges = []);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _student == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive)));
      return;
    }
    setState(() => _saving = true);
    try {
      final txService = TransactionService(widget.database);
      Map<String, double>? allocations;
        if (_showAllocation && _selectedCharges.isNotEmpty) {
        final allocTotal = _selectedCharges.fold<double>(0, (sum, id) {
          final matching = _charges.where((c) => (c['transaction'] as Transaction).id == id);
          if (matching.isEmpty) return sum;
          return sum + ((matching.first['remaining'] as num?) ?? 0).toDouble();
        });
        if (allocTotal > amount) {
          if (mounted) setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive)));
          return;
        }
        allocations = {};
        for (final id in _selectedCharges) {
          final matching = _charges.where((c) => (c['transaction'] as Transaction).id == id);
          if (matching.isNotEmpty) allocations![id] = ((matching.first['remaining'] as num?) ?? 0).toDouble();
        }
      }
      final txId = await txService.createStudentPayment(
        studentId: _student!.id,
        amount: amount,
        note: _noteCtrl.text,
        paymentMethod: _method,
        allocations: allocations,
      );
      if (mounted) setState(() { _saving = false; _savedTxId = txId; });
    } catch (_) {
      if (mounted) { setState(() => _saving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.operationFailed))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allocTotal = _showAllocation
        ? _selectedCharges.fold<double>(0, (sum, id) {
            final charge = _charges.firstWhere((c) => (c['transaction'] as Transaction).id == id);
            return sum + (charge['remaining'] as double);
          })
        : 0.0;
    if (_savedTxId != null) {
      return ShellDialog(
        maxWidth: 440, title: l10n.recordPayment,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(PhosphorIcons.checkCircle, size: 40, color: SemanticTokens.success),
          const SizedBox(height: 12),
          Text('Payment recorded successfully',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          const SizedBox(height: 4),
          Text('${_amountCtrl.text} ${AppConstants.currencySymbol} — ${_student!.firstNameAr} ${_student!.lastNameAr}',
            style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(PhosphorIcons.x, size: 14),
              label: const Text('Done', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: ShellTokens.chromeBorder), foregroundColor: ShellTokens.textSecondary),
            )),
            const SizedBox(width: 10),
            Expanded(child: FilledButton.icon(
              onPressed: () async {
                try {
                  final receiptNo = 'REC-${_savedTxId!.hashCode.abs().toString().substring(0, 6)}';
                  final path = await PdfGenerator.generatePaymentReceipt(
                    database: widget.database,
                    transactionId: _savedTxId!,
                    receiptNumber: receiptNo,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Receipt saved: $path'), backgroundColor: ShellTokens.chromeSurface));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              icon: const Icon(PhosphorIcons.receipt, size: 14),
              label: const Text('Print Receipt', style: TextStyle(fontSize: 12)),
              style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase),
            )),
          ]),
        ]),
      );
    }
    return ShellDialog(
      maxWidth: 520, maxHeight: 650, title: l10n.recordPayment,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: l10n.student, withBorder: false),
        const SizedBox(height: 6),
        if (_student == null)
          OutlinedButton.icon(
            onPressed: _pick,
            icon: const Icon(PhosphorIcons.magnifyingGlass, size: 14, color: ShellTokens.accent),
            label: Text(l10n.selectStudent, style: const TextStyle(fontSize: 12, color: ShellTokens.accent)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: ShellTokens.chromeBorder)),
          )
        else
          Row(children: [
            const Icon(PhosphorIcons.users, size: 16, color: ShellTokens.accent),
            const SizedBox(width: 8),
            Flexible(child: Text('${_student!.firstNameAr} ${_student!.lastNameAr} (${_student!.code})',
              style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary, fontWeight: FontWeight.w600))),
          ]),
        const SizedBox(height: 12),
        TextField(
          controller: _amountCtrl, keyboardType: TextInputType.number,
          decoration: ShellInputDecoration.textField(hintText: '${l10n.amount} (${AppConstants.currencySymbol})'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
        ),
        const SizedBox(height: 8),
        ShellSectionHeader(text: l10n.paymentMethod, withBorder: false),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _method,
          decoration: ShellInputDecoration.dropdown(),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          items: ['cash', 'card', 'bank_transfer', 'mobile_payment'].map((m) => DropdownMenuItem(
            value: m, child: Text(_methodLabel(m, l10n), style: const TextStyle(fontSize: 12)),
          )).toList(),
          onChanged: (v) => setState(() => _method = v!),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteCtrl,
          decoration: ShellInputDecoration.textField(hintText: l10n.note),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
        ),
        if (_charges.isNotEmpty) ...[
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l10n.allocatePayment, style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
            subtitle: Text('${_charges.length} ${l10n.unpaidCharges} (FIFO ${l10n.ifUnchecked})',
              style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
            value: _showAllocation,
            onChanged: (v) => setState(() => _showAllocation = v),
            dense: true, contentPadding: EdgeInsets.zero,
            activeColor: ShellTokens.accent,
          ),
          if (_showAllocation)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true, itemCount: _charges.length,
                itemBuilder: (_, i) {
                  final c = _charges[i];
                  final tx = c['transaction'] as Transaction;
                  final rem = c['remaining'] as double;
                  final id = tx.id;
                  final sel = _selectedCharges.contains(id);
              return CheckboxListTile(
                value: sel,
                onChanged: (v) {
                  setState(() {
                    if (v == true) { _selectedCharges.add(id); } else { _selectedCharges.remove(id); }
                  });
                },
                dense: true, contentPadding: EdgeInsets.zero,
                title: Text('Cycle ${c['cycle'] ?? '?'}: ${tx.amount.toStringAsFixed(0)} DA — ${_fmtDate(tx.transactionDate)}',
                  style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
                subtitle: Text('${l10n.remaining}: ${rem.toStringAsFixed(0)} DA',
                  style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
                activeColor: ShellTokens.accent, checkColor: ShellTokens.chromeBase,
              );
                },
              ),
            ),
          if (_showAllocation)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${l10n.allocatedTotal}: ${allocTotal.toStringAsFixed(0)} DA',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: allocTotal > 0 ? ShellTokens.textPrimary : ShellTokens.textDisabled)),
            ),
        ],
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(l10n.save),
        )),
      ]),
    );
  }

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _methodLabel(String m, AppLocalizations l10n) {
    switch (m) {
      case 'cash': return l10n.cash;
      case 'card': return l10n.check;
      case 'bank_transfer': return l10n.paymentMethodBankTransfer;
      case 'mobile_payment': return l10n.paymentMethodMobile;
      default: return m;
    }
  }
}

class _RecordExpenseDialog extends StatefulWidget {
  final AppDatabase database;
  const _RecordExpenseDialog({required this.database});
  @override
  State<_RecordExpenseDialog> createState() => _RecordExpenseDialogState();
}

class _RecordExpenseDialogState extends State<_RecordExpenseDialog> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _category = 'other';
  bool _saving = false;

  @override
  void dispose() { _amountCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive)));
      return;
    }
    setState(() => _saving = true);
    try {
      final txService = TransactionService(widget.database);
      await txService.createExpense(amount: amount, category: _category, note: _noteCtrl.text);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) { setState(() => _saving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.operationFailed))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellDialog(
      maxWidth: 440, title: '${l10n.recordPayment} ${l10n.expenses}',
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: _amountCtrl, keyboardType: TextInputType.number,
          decoration: ShellInputDecoration.textField(hintText: '${l10n.amount} (${AppConstants.currencySymbol})'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
        ),
        const SizedBox(height: 8),
        ShellSectionHeader(text: l10n.category, withBorder: false),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: ShellInputDecoration.dropdown(),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          items: ['rent', 'salary', 'materials', 'utilities', 'other'].map((c) => DropdownMenuItem(
            value: c,
            child: Text(_categoryLabel(c, l10n), style: const TextStyle(fontSize: 12)),
          )).toList(),
          onChanged: (v) => setState(() => _category = v!),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteCtrl,
          decoration: ShellInputDecoration.textField(hintText: l10n.note),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
        ),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(l10n.save),
        )),
      ]),
    );
  }

  String _categoryLabel(String c, AppLocalizations l10n) {
    switch (c) {
      case 'rent': return l10n.rent;
      case 'salary': return l10n.salary;
      case 'materials': return l10n.materials;
      case 'utilities': return l10n.utilities;
      case 'other': return l10n.other;
      default: return c;
    }
  }
}

class _VoidTransactionDialog extends StatefulWidget {
  final AppDatabase database;
  final Transaction transaction;
  const _VoidTransactionDialog({required this.database, required this.transaction});
  @override
  State<_VoidTransactionDialog> createState() => _VoidTransactionDialogState();
}

class _VoidTransactionDialogState extends State<_VoidTransactionDialog> {
  final _reasonCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fieldRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final txService = TransactionService(widget.database);
      await txService.createReversal(
        referenceTransactionId: widget.transaction.id,
        note: _reasonCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) { setState(() => _saving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.operationFailed))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellDialog(
      maxWidth: 440, title: l10n.reversal,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${l10n.reverseTransaction} ${widget.transaction.id} (${widget.transaction.amount.toStringAsFixed(0)} ${AppConstants.currencySymbol})',
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 12),
        TextField(
          controller: _reasonCtrl, autofocus: true, maxLines: 3,
          decoration: ShellInputDecoration.textField(hintText: l10n.reason),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
        ),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: SemanticTokens.error, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(l10n.confirm),
        )),
      ]),
    );
  }
}

class _StudentSearchDialog extends StatefulWidget {
  final AppDatabase database;
  const _StudentSearchDialog({required this.database});
  @override
  State<_StudentSearchDialog> createState() => _StudentSearchDialogState();
}

class _StudentSearchDialogState extends State<_StudentSearchDialog> {
  final _ctrl = TextEditingController();
  List<Student> _results = [];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShellDialog(
      maxWidth: 400, title: l10n.selectStudent,
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _ctrl, autofocus: true,
          decoration: ShellInputDecoration.textField(hintText: '${l10n.code} أو ${l10n.name}'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          onChanged: (q) async {
            if (q.trim().isEmpty) { setState(() => _results = []); return; }
            try {
              final repo = StudentRepository(widget.database);
              final r = await repo.search(q);
              if (mounted) setState(() => _results = r);
            } catch (_) {
              if (mounted) setState(() => _results = []);
            }
          },
        ),
        const SizedBox(height: 8),
        if (_results.isNotEmpty)
          Flexible(child: ListView.builder(
            shrinkWrap: true, itemCount: _results.length,
            itemBuilder: (_, i) {
              final s = _results[i];
              return ListTile(
                title: Text('${s.firstNameAr} ${s.lastNameAr}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                subtitle: Text(s.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                onTap: () => Navigator.pop(context, s),
              );
            },
          )),
      ]),
    );
  }
}



class _ClosePeriodDialog extends StatefulWidget {
  final AppDatabase database;
  const _ClosePeriodDialog({required this.database});
  @override
  State<_ClosePeriodDialog> createState() => _ClosePeriodDialogState();
}

class _ClosePeriodDialogState extends State<_ClosePeriodDialog> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  Map<String, double>? _summary;
  bool _loadingWatch = false;
  bool _saving = false;

  Future<void> _loadSummary() async {
    setState(() => _loadingWatch = true);
    final s = await widget.database.getPeriodSummary(from: DateTime(_year, _month, 1), to: DateTime(_year, _month + 1, 0));
    if (mounted) setState(() { _summary = s; _loadingWatch = false; });
  }

  Future<void> _close() async {
    setState(() => _saving = true);
    await widget.database.closePeriod(_year, _month, 'system');
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final months = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return ShellDialog(
      maxWidth: 460, title: 'Close Period',
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: DropdownButtonFormField<int>(
            value: _year, decoration: ShellInputDecoration.dropdown(),
            items: List.generate(5, (i) => _year - 2 + i).map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
            onChanged: (v) => setState(() { _year = v!; _summary = null; }),
          )),
          const SizedBox(width: 8),
          Expanded(child: DropdownButtonFormField<int>(
            value: _month, decoration: ShellInputDecoration.dropdown(),
            items: months.asMap().entries.map((e) => DropdownMenuItem(value: e.key + 1, child: Text(e.value))).toList(),
            onChanged: (v) => setState(() { _month = v!; _summary = null; }),
          )),
          const SizedBox(width: 8),
          IconButton(onPressed: _loadSummary, icon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.accent)),
        ]),
        const SizedBox(height: 12),
        if (_loadingWatch) const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
        else if (_summary != null) ...[
          _summaryLine('Revenue', _summary!['revenue']!, SemanticTokens.success),
          _summaryLine('Expenses', _summary!['expenses']!, SemanticTokens.error),
          _summaryLine('Outstanding Debt', _summary!['outstanding']!, SemanticTokens.warning),
          const Divider(color: ShellTokens.chromeBorder),
          _summaryLine('Net', _summary!['revenue']! - _summary!['expenses']!,
            (_summary!['revenue']! - _summary!['expenses']!) >= 0 ? SemanticTokens.success : SemanticTokens.error),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: _saving ? null : _close,
            style: FilledButton.styleFrom(backgroundColor: SemanticTokens.error, foregroundColor: ShellTokens.chromeBase),
            child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : const Text('Close Period'),
          )),
        ],
      ]),
    );
  }

  Widget _summaryLine(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: ShellTokens.textSecondary)),
        Text('${amount.toStringAsFixed(0)} DA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _BalanceTransferDialog extends StatefulWidget {
  final AppDatabase database;
  const _BalanceTransferDialog({required this.database});
  @override
  State<_BalanceTransferDialog> createState() => _BalanceTransferDialogState();
}

class _BalanceTransferDialogState extends State<_BalanceTransferDialog> {
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  Student? _from, _to;
  bool _saving = false;

  @override
  void dispose() { _amountCtrl.dispose(); _reasonCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _from == null || _to == null || _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields required')));
      return;
    }
    setState(() => _saving = true);
    try {
      await TransactionService(widget.database).createBalanceTransfer(
        fromStudentId: _from!.id, toStudentId: _to!.id, amount: amount, note: _reasonCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transfer failed: $e')));
      }
    }
  }

  Future<Student?> _pick() async {
    final ctrl = TextEditingController();
    final result = await showDialog<Student>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 400, title: 'Select Student',
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: ctrl, autofocus: true,
            decoration: ShellInputDecoration.textField(hintText: 'Code or Name'),
            onSubmitted: (q) async {
              try {
                final r = await StudentRepository(widget.database).search(q);
                if (r.isNotEmpty && ctx.mounted) Navigator.pop(ctx, r.first);
              } catch (_) {}
            },
          ),
        ]),
      ),
    );
    ctrl.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 460, title: 'Transfer Balance',
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: 'From Student', withBorder: false),
        const SizedBox(height: 6),
        _studentBtn(_from, 'From', (s) => setState(() => _from = s)),
        const SizedBox(height: 8),
        ShellSectionHeader(text: 'To Student', withBorder: false),
        const SizedBox(height: 6),
        _studentBtn(_to, 'To', (s) => setState(() => _to = s)),
        const SizedBox(height: 8),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number,
          decoration: ShellInputDecoration.textField(hintText: 'Amount (DA)')),
        const SizedBox(height: 8),
        TextField(controller: _reasonCtrl,
          decoration: ShellInputDecoration.textField(hintText: 'Reason')),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : const Text('Transfer'),
        )),
      ]),
    );
  }

  Widget _studentBtn(Student? s, String hint, ValueChanged<Student> onPick) {
    return s != null
        ? Row(children: [
            Text('${s.firstNameAr} ${s.lastNameAr}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            const SizedBox(width: 6), Text(s.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
          ])
        : OutlinedButton.icon(
            onPressed: () async { final p = await _pick(); if (p != null) onPick(p); },
            icon: const Icon(PhosphorIcons.magnifyingGlass, size: 14),
            label: Text('Select $hint', style: const TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: ShellTokens.chromeBorder)),
          );
  }
}

class _RefundCreditDialog extends StatefulWidget {
  final AppDatabase database;
  const _RefundCreditDialog({required this.database});
  @override
  State<_RefundCreditDialog> createState() => _RefundCreditDialogState();
}

class _RefundCreditDialogState extends State<_RefundCreditDialog> {
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  Student? _student;
  String _mode = 'credit';
  bool _saving = false;

  @override
  void dispose() { _amountCtrl.dispose(); _reasonCtrl.dispose(); super.dispose(); }

  Future<Student?> _pick() async {
    final ctrl = TextEditingController();
    final result = await showDialog<Student>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 400, title: 'Select Student',
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: ctrl, autofocus: true,
            decoration: ShellInputDecoration.textField(hintText: 'Code or Name'),
            onSubmitted: (q) async {
              try {
                final r = await StudentRepository(widget.database).search(q);
                if (r.isNotEmpty && ctx.mounted) Navigator.pop(ctx, r.first);
              } catch (_) {}
            },
          ),
        ]),
      ),
    );
    ctrl.dispose();
    return result;
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _student == null || _reasonCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields required')));
      return;
    }
    setState(() => _saving = true);
    try {
      final txService = TransactionService(widget.database);
      if (_mode == 'credit') {
        await txService.createDiscount(
          studentId: _student!.id, amount: amount, note: 'Credit Note: ${_reasonCtrl.text.trim()}',
        );
      } else {
        await txService.createRefund(
          studentId: _student!.id, amount: amount, note: _reasonCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) { setState(() => _saving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 460, title: 'Refund / Credit Note',
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShellSectionHeader(text: 'Student', withBorder: false),
        const SizedBox(height: 6),
        _studentBtn(_student, (s) => setState(() => _student = s)),
        const SizedBox(height: 12),
        ShellSectionHeader(text: 'Mode', withBorder: false),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: RadioListTile<String>(
            title: const Text('Credit Note', style: TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
            subtitle: const Text('No cash, creates credit', style: TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            value: 'credit', groupValue: _mode, onChanged: (v) => setState(() => _mode = v!), dense: true, contentPadding: EdgeInsets.zero,
            activeColor: ShellTokens.accent,
          )),
          Expanded(child: RadioListTile<String>(
            title: const Text('Cash Refund', style: TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
            subtitle: const Text('Money leaves the center', style: TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            value: 'cash', groupValue: _mode, onChanged: (v) => setState(() => _mode = v!), dense: true, contentPadding: EdgeInsets.zero,
            activeColor: SemanticTokens.error,
          )),
        ]),
        const SizedBox(height: 12),
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number,
          decoration: ShellInputDecoration.textField(hintText: 'Amount (DA)'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 8),
        TextField(controller: _reasonCtrl,
          decoration: ShellInputDecoration.textField(hintText: 'Reason (required)'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: _mode == 'cash' ? SemanticTokens.error : ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text(_mode == 'cash' ? 'Record Refund' : 'Issue Credit Note'),
        )),
      ]),
    );
  }

  Widget _studentBtn(Student? s, ValueChanged<Student> onPick) {
    return s != null
        ? Row(children: [
            Text('${s.firstNameAr} ${s.lastNameAr}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            const SizedBox(width: 6), Text(s.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
            const Spacer(),
            IconButton(icon: const Icon(PhosphorIcons.x, size: 14), onPressed: () => onPick(s), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 20, minHeight: 20)),
          ])
        : OutlinedButton.icon(
            onPressed: () async { final p = await _pick(); if (p != null) onPick(p); },
            icon: const Icon(PhosphorIcons.magnifyingGlass, size: 14),
            label: const Text('Select Student', style: TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: ShellTokens.chromeBorder)),
          );
  }
}
