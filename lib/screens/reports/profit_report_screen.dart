import 'dart:io';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../constants/chart_tokens.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/student_repository.dart';
import '../../constants/app_constants.dart';
import '../checkin/attendance_reports_screen.dart';

class ProfitReportScreen extends StatefulWidget {
  final AppDatabase database;

  const ProfitReportScreen({super.key, required this.database});

  @override
  State<ProfitReportScreen> createState() => _ProfitReportScreenState();
}

class _ProfitReportScreenState extends State<ProfitReportScreen> {
  late final TransactionRepository _txRepo;
  late final StudentRepository _studentRepo;

  int _tabIndex = 0;
  static const _tabs = ['الأرباح الشهرية', 'الحضور', 'الاتجاه المالي', 'أداء الأقسام', 'عبء الأساتذة'];

  DateTime _selectedDate = DateTime.now();
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _loading = true;

  List<Map<String, dynamic>> _trendData = [];
  bool _trendLoading = false;
  List<Map<String, dynamic>> _classData = [];
  bool _classLoading = false;
  int _classSortColumn = 0;
  bool _classSortAsc = true;
  List<Map<String, dynamic>> _teacherData = [];
  bool _teacherLoading = false;
  int _teacherSortColumn = 0;
  bool _teacherSortAsc = true;

  double _studentPaymentIncome = 0;
  double _sessionChargeIncome = 0;
  double _discountTotal = 0;
  double _teacherPayouts = 0;
  double _expenses = 0;
  double _netProfit = 0;
  List<_DebtorEntry> _debtors = [];

  @override
  void initState() {
    super.initState();
    _txRepo = TransactionRepository(widget.database);
    _studentRepo = StudentRepository(widget.database);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final DateTime start, end;
    if (_dateFrom != null && _dateTo != null) {
      start = _dateFrom!;
      end = DateTime(_dateTo!.year, _dateTo!.month, _dateTo!.day, 23, 59, 59);
    } else {
      start = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final endOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
      end = DateTime(endOfMonth.year, endOfMonth.month, endOfMonth.day, 23, 59, 59);
    }

    final allTx = await _txRepo.getByDateRange(start, end);

    double studentPayment = 0;
    double sessionCharge = 0;
    double discount = 0;
    double teacherPayout = 0;
    double expense = 0;

    for (final tx in allTx) {
      switch (tx.type) {
        case 'student_payment':
          studentPayment += tx.amount;
          break;
        case 'session_charge':
          sessionCharge += tx.amount;
          break;
        case 'discount':
          discount += tx.amount;
          break;
        case 'teacher_payout':
          teacherPayout += tx.amount;
          break;
        case 'expense':
          expense += tx.amount;
          break;
      }
    }

    final grossIncome = studentPayment + sessionCharge;
    final netIncome = grossIncome - discount;
    final totalExpenses = teacherPayout + expense;
    final netProfit = netIncome - totalExpenses;

    final students = await _studentRepo.getAll();
    final debtors = <_DebtorEntry>[];

    for (final student in students) {
      final balance = await widget.database.getStudentBalance(student.id);
      if (balance > 0) {
        debtors.add(_DebtorEntry(
          studentName: '${student.firstNameAr} ${student.lastNameAr}',
          studentCode: student.code,
          debt: balance,
        ));
      }
    }

    debtors.sort((a, b) => b.debt.compareTo(a.debt));

    if (!mounted) return;
    setState(() {
      _loading = false;
      _studentPaymentIncome = studentPayment;
      _sessionChargeIncome = sessionCharge;
      _discountTotal = discount;
      _teacherPayouts = teacherPayout;
      _expenses = expense;
      _netProfit = netProfit;
      _debtors = debtors;
    });
  }

  Future<void> _loadTrend() async {
    setState(() => _trendLoading = true);
    try {
      _trendData = await widget.database.getMonthlyRevenueAndExpenses(6);
    } catch (_) {
      _trendData = [];
    }
    if (mounted) setState(() => _trendLoading = false);
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
    _loadData();
  }

  Future<void> _selectYear() async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final currentYear = DateTime.now().year;
        final years = List.generate(10, (i) => currentYear - 5 + i);
        return AlertDialog(
          title: Text(l10n.selectYear),
          content: SizedBox(
            width: 200,
            height: 300,
            child: ListView.builder(
              itemCount: years.length,
              itemBuilder: (_, i) => ListTile(
                title: Text('${years[i]}'),
                onTap: () => Navigator.pop(ctx, years[i]),
              ),
            ),
          ),
        );
      },
    );
    if (chosen != null) {
      if (!mounted) return;
      setState(() {
        _selectedDate = DateTime(chosen, _selectedDate.month, 1);
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final monthNames = const [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(l10n, monthNames),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    final pdf = pw.Document();
    const monthLabels = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hasRange = _dateFrom != null && _dateTo != null;
    final periodLabel = hasRange
        ? '${_fmtDate(_dateFrom!)} — ${_fmtDate(_dateTo!)}'
        : '${monthLabels[_selectedDate.month]} ${_selectedDate.year}';
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (_) => [
        pw.Header(text: 'Monthly Profit — $periodLabel', level: 1),
        pw.SizedBox(height: 8),
        pw.Text('Net Profit: ${_netProfit.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        pw.Header(text: 'Income', level: 2),
        pw.TableHelper.fromTextArray(
          headers: ['Category', 'Amount'],
          data: [
            ['Student Payments', '${_studentPaymentIncome.toStringAsFixed(2)} ${AppConstants.currencySymbol}'],
            ['Session Charges', '${_sessionChargeIncome.toStringAsFixed(2)} ${AppConstants.currencySymbol}'],
            if (_discountTotal > 0) ['Discounts', '-${_discountTotal.toStringAsFixed(2)} ${AppConstants.currencySymbol}'],
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Header(text: 'Expenses', level: 2),
        pw.TableHelper.fromTextArray(
          headers: ['Category', 'Amount'],
          data: [
            ['Teacher Payouts', '${_teacherPayouts.toStringAsFixed(2)} ${AppConstants.currencySymbol}'],
            ['Expenses', '${_expenses.toStringAsFixed(2)} ${AppConstants.currencySymbol}'],
          ],
        ),
        if (_debtors.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          pw.Header(text: 'Top Debtors', level: 2),
          pw.TableHelper.fromTextArray(
            headers: ['Student', 'Code', 'Debt'],
            data: _debtors.take(10).map((d) => [d.studentName, d.studentCode, '${d.debt.toStringAsFixed(2)} ${AppConstants.currencySymbol}']).toList(),
          ),
        ],
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Monthly Profit'];
    sheet.appendRow([TextCellValue('Category'), TextCellValue('Amount')]);
    sheet.appendRow([TextCellValue('Net Profit'), TextCellValue('${_netProfit.toStringAsFixed(2)} ${AppConstants.currencySymbol}')]);
    sheet.appendRow([TextCellValue(''), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Income'), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Student Payments'), TextCellValue('${_studentPaymentIncome.toStringAsFixed(2)}')]);
    sheet.appendRow([TextCellValue('Session Charges'), TextCellValue('${_sessionChargeIncome.toStringAsFixed(2)}')]);
    if (_discountTotal > 0) {
      sheet.appendRow([TextCellValue('Discounts'), TextCellValue('-${_discountTotal.toStringAsFixed(2)}')]);
    }
    sheet.appendRow([TextCellValue(''), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Expenses'), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Teacher Payouts'), TextCellValue('${_teacherPayouts.toStringAsFixed(2)}')]);
    sheet.appendRow([TextCellValue('Expenses'), TextCellValue('${_expenses.toStringAsFixed(2)}')]);
    sheet.appendRow([TextCellValue(''), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Top Debtors'), TextCellValue('')]);
    sheet.appendRow([TextCellValue('Student'), TextCellValue('Code'), TextCellValue('Debt')]);
    for (final d in _debtors.take(10)) {
      sheet.appendRow([TextCellValue(d.studentName), TextCellValue(d.studentCode), TextCellValue('${d.debt.toStringAsFixed(2)}')]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final hasRange = _dateFrom != null && _dateTo != null;
    final filePart = hasRange
        ? '${_fmtDate(_dateFrom!)}_${_fmtDate(_dateTo!)}'
        : '${_selectedDate.year}_${_selectedDate.month.toString().padLeft(2, '0')}';
    final file = File('${dir.path}/monthly_profit_$filePart.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Excel: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
    }
  }

  Widget _buildTrendContent() {
    if (_trendLoading) return const Center(child: CircularProgressIndicator());
    if (_trendData.isEmpty) {
      _loadTrend();
      return const Center(child: CircularProgressIndicator());
    }

    const monthLabels = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final totalRevenue = _trendData.fold<double>(0, (s, d) => s + ((d['revenue'] as num?)?.toDouble() ?? 0));
    final totalExpenses = _trendData.fold<double>(0, (s, d) => s + ((d['expenses'] as num?)?.toDouble() ?? 0));
    final totalNet = totalRevenue - totalExpenses;

    return RefreshIndicator(
      onRefresh: _loadTrend,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(children: [
                const SizedBox(width: 12),
                const Text('آخر 6 أشهر', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                const Spacer(),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary), onPressed: _exportTrendPdf, tooltip: 'Export PDF', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
                const SizedBox(width: 4),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary), onPressed: _exportTrendExcel, tooltip: 'Export Excel', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            _trendKpiCard('المداخيل', totalRevenue, Colors.green),
            const SizedBox(width: 8),
            _trendKpiCard('المصاريف', totalExpenses, Colors.red),
            const SizedBox(width: 8),
            _trendKpiCard('الصافي', totalNet, totalNet >= 0 ? Colors.green.shade700 : Colors.red.shade700),
          ]),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildTrendChart(monthLabels),
            ),
          ),
          const SizedBox(height: 12),
          _buildTrendTable(monthLabels),
        ],
      ),
    );
  }

  Widget _trendKpiCard(String label, double amount, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
            const SizedBox(height: 4),
            Text('${amount.toStringAsFixed(0)} ${AppConstants.currencySymbol}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          ]),
        ),
      ),
    );
  }

  Widget _buildTrendChart(List<String> monthLabels) {
    final maxY = _trendData.fold<double>(0, (s, d) {
      final r = (d['revenue'] as num?)?.toDouble() ?? 0;
      final e = (d['expenses'] as num?)?.toDouble() ?? 0;
      return s > r ? (s > e ? s : e) : (r > e ? r : e);
    }) * 1.2;
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barGroups: _trendData.asMap().entries.map((e) {
            final rev = (e.value['revenue'] as double?) ?? 0;
            final exp = (e.value['expenses'] as double?) ?? 0;
            return BarChartGroupData(x: e.key, barRods: [
              BarChartRodData(toY: rev, color: ChartTokens.seriesPalette[0], width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
              BarChartRodData(toY: exp, color: ChartTokens.seriesPalette[2], width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
            ]);
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, _) {
              final idx = v.toInt();
              final month = idx >= 0 && idx < _trendData.length ? (_trendData[idx]['month'] as int?) : null;
              return Text(monthLabels[month ?? 1], style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel));
            })),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel)))),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (_) => FlLine(color: ChartTokens.gridLine, strokeWidth: 0.5)),
          borderData: FlBorderData(show: false),
        ),
        duration: Duration.zero,
      ),
    );
  }

  Widget _buildTrendTable(List<String> monthLabels) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('البيانات الشهرية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5),
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1)},
            children: [
              TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeBorder), children: [
                _trendCell('الشهر', isHeader: true),
                _trendCell('المداخيل', isHeader: true),
                _trendCell('المصاريف', isHeader: true),
                _trendCell('الصافي', isHeader: true),
              ]),
              ..._trendData.map((d) {
                final month = monthLabels[d['month'] as int];
                final year = d['year'] as int;
                final rev = (d['revenue'] as num?)?.toDouble() ?? 0;
                final exp = (d['expenses'] as num?)?.toDouble() ?? 0;
                final net = rev - exp;
                return TableRow(children: [
                  _trendCell('$month $year'),
                  _trendCell(rev.toStringAsFixed(0), color: Colors.green),
                  _trendCell(exp.toStringAsFixed(0), color: Colors.red),
                  _trendCell(net.toStringAsFixed(0), color: net >= 0 ? Colors.green : Colors.red),
                ]);
              }),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _trendCell(String text, {bool isHeader = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400, color: color ?? ShellTokens.textPrimary)),
    );
  }

  Future<void> _exportTrendPdf() async {
    if (_trendData.isEmpty) return;
    final pdf = pw.Document();
    const monthLabels = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (_) => [
        pw.Header(text: 'Financial Trend — Last 6 Months', level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Month', 'Revenue', 'Expenses', 'Net'],
          data: _trendData.map((d) {
            final month = monthLabels[d['month'] as int];
            final year = d['year'] as int;
            final rev = (d['revenue'] as num?)?.toDouble() ?? 0;
            final exp = (d['expenses'] as num?)?.toDouble() ?? 0;
            return ['$month $year', '${rev.toStringAsFixed(0)} ${AppConstants.currencySymbol}', '${exp.toStringAsFixed(0)} ${AppConstants.currencySymbol}', '${(rev - exp).toStringAsFixed(0)} ${AppConstants.currencySymbol}'];
          }).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportTrendExcel() async {
    if (_trendData.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel['Financial Trend'];
    sheet.appendRow([TextCellValue('Month'), TextCellValue('Revenue'), TextCellValue('Expenses'), TextCellValue('Net')]);
    for (final d in _trendData) {
      final rev = (d['revenue'] as num?)?.toDouble() ?? 0;
      final exp = (d['expenses'] as num?)?.toDouble() ?? 0;
      sheet.appendRow([TextCellValue('${d['year']}-${(d['month'] as int).toString().padLeft(2, '0')}'), TextCellValue('${rev.toStringAsFixed(0)}'), TextCellValue('${exp.toStringAsFixed(0)}'), TextCellValue('${(rev - exp).toStringAsFixed(0)}')]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/financial_trend.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Excel: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }

  Future<void> _loadClassPerformance() async {
    setState(() => _classLoading = true);
    try {
      _classData = await widget.database.getClassPerformanceReport();
      _sortClassData();
    } catch (_) {
      _classData = [];
    }
    if (mounted) setState(() => _classLoading = false);
  }

  void _sortClassData() {
    final keys = ['group_name', 'school_level', 'teacher_name', 'enrolled', 'revenue', 'attendance_rate'];
    _classData.sort((a, b) {
      final va = a[keys[_classSortColumn]];
      final vb = b[keys[_classSortColumn]];
      int cmp = 0;
      if (va is String && vb is String) {
        cmp = va.compareTo(vb);
      } else if (va is num && vb is num) {
        cmp = va.compareTo(vb);
      }
      return _classSortAsc ? cmp : -cmp;
    });
  }

  void _onClassSort(int col) {
    setState(() {
      if (_classSortColumn == col) {
        _classSortAsc = !_classSortAsc;
      } else {
        _classSortColumn = col;
        _classSortAsc = true;
      }
      _sortClassData();
    });
  }

  Widget _buildClassPerformanceContent() {
    if (_classLoading) return const Center(child: CircularProgressIndicator());
    if (_classData.isEmpty) {
      _loadClassPerformance();
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadClassPerformance,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(children: [
                const SizedBox(width: 12),
                Text('${_classData.length} أقسام', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                const Spacer(),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary), onPressed: _exportClassPdf, tooltip: 'Export PDF', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
                const SizedBox(width: 4),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary), onPressed: _exportClassExcel, tooltip: 'Export Excel', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          _buildClassTable(),
        ],
      ),
    );
  }

  Widget _buildClassTable() {
    const headers = ['القسم', 'المستوى', 'الأستاذ', 'الطلاب', 'المداخيل', 'نسبة الحضور'];
    const keys = ['group_name', 'school_level', 'teacher_name', 'enrolled', 'revenue', 'attendance_rate'];

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: _classSortColumn,
          sortAscending: _classSortAsc,
          headingRowColor: WidgetStateProperty.all(ShellTokens.chromeBorder),
          columns: List.generate(headers.length, (i) => DataColumn(label: Text(headers[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), onSort: (col, _) => _onClassSort(col))),
          rows: _classData.map((d) => DataRow(cells: [
            DataCell(Text(d['group_name'] as String, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text(_levelLabel(d['school_level'] as String), style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
            DataCell(Text((d['teacher_name'] as String?)?.isNotEmpty == true ? (d['teacher_name'] as String) : '—', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary))),
            DataCell(Text('${d['enrolled']}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text('${(d['revenue'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(borderRadius: BorderRadius.circular(3), child: SizedBox(width: 40, height: 6, child: LinearProgressIndicator(value: ((d['attendance_rate'] as num).toDouble()) / 100, minHeight: 6, backgroundColor: ShellTokens.chromeBorder, color: (d['attendance_rate'] as num).toDouble() >= 80 ? SemanticTokens.success : (d['attendance_rate'] as num).toDouble() >= 50 ? SemanticTokens.warning : SemanticTokens.error))),
              const SizedBox(width: 6),
              Text('${(d['attendance_rate'] as num).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
            ])),
          ])).toList(),
        ),
      ),
    );
  }

  String _levelLabel(String l) => switch (l) { 'primary' => 'ابتدائي', 'middle' => 'متوسط', 'secondary' => 'ثانوي', _ => l };

  Future<void> _exportClassPdf() async {
    if (_classData.isEmpty) return;
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (_) => [
        pw.Header(text: 'Class Performance Report', level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 7),
          headers: ['Group', 'Level', 'Teacher', 'Students', 'Revenue', 'Attendance %'],
          data: _classData.map((d) => [
            d['group_name'] as String,
            _levelLabel(d['school_level'] as String),
            (d['teacher_name'] as String?) ?? '',
            '${d['enrolled']}',
            '${(d['revenue'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}',
            '${(d['attendance_rate'] as num).toStringAsFixed(0)}%',
          ]).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportClassExcel() async {
    if (_classData.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel['Class Performance'];
    sheet.appendRow([TextCellValue('Group'), TextCellValue('Level'), TextCellValue('Teacher'), TextCellValue('Students'), TextCellValue('Revenue'), TextCellValue('Attendance %')]);
    for (final d in _classData) {
      sheet.appendRow([
        TextCellValue(d['group_name'] as String),
        TextCellValue(_levelLabel(d['school_level'] as String)),
        TextCellValue((d['teacher_name'] as String?) ?? ''),
        TextCellValue('${d['enrolled']}'),
        TextCellValue('${(d['revenue'] as num).toStringAsFixed(0)}'),
        TextCellValue('${(d['attendance_rate'] as num).toStringAsFixed(0)}%'),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/class_performance.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Excel: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }

  Future<void> _loadTeacherWorkload() async {
    setState(() => _teacherLoading = true);
    try {
      _teacherData = await widget.database.getTeacherWorkloadReport();
      _sortTeacherData();
    } catch (_) {
      _teacherData = [];
    }
    if (mounted) setState(() => _teacherLoading = false);
  }

  void _sortTeacherData() {
    final keys = ['name', 'session_count', 'weekly_hours', 'students_taught', 'earnings'];
    _teacherData.sort((a, b) {
      final va = a[keys[_teacherSortColumn]];
      final vb = b[keys[_teacherSortColumn]];
      int cmp = 0;
      if (va is String && vb is String) {
        cmp = va.compareTo(vb);
      } else if (va is num && vb is num) {
        cmp = va.compareTo(vb);
      }
      return _teacherSortAsc ? cmp : -cmp;
    });
  }

  void _onTeacherSort(int col) {
    setState(() {
      if (_teacherSortColumn == col) {
        _teacherSortAsc = !_teacherSortAsc;
      } else {
        _teacherSortColumn = col;
        _teacherSortAsc = true;
      }
      _sortTeacherData();
    });
  }

  Widget _buildTeacherWorkloadContent() {
    if (_teacherLoading) return const Center(child: CircularProgressIndicator());
    if (_teacherData.isEmpty) {
      _loadTeacherWorkload();
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadTeacherWorkload,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(children: [
                const SizedBox(width: 12),
                Text('${_teacherData.length} أساتذة', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
                const Spacer(),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary), onPressed: _exportTeacherPdf, tooltip: 'Export PDF', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
                const SizedBox(width: 4),
                SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary), onPressed: _exportTeacherExcel, tooltip: 'Export Excel', style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          _buildTeacherWorkloadTable(),
        ],
      ),
    );
  }

  Widget _buildTeacherWorkloadTable() {
    const headers = ['الأستاذ', 'الحصص', 'الساعات/أسبوع', 'الطلاب', 'المستخلصات'];
    const keys = ['name', 'session_count', 'weekly_hours', 'students_taught', 'earnings'];

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: _teacherSortColumn,
          sortAscending: _teacherSortAsc,
          headingRowColor: WidgetStateProperty.all(ShellTokens.chromeBorder),
          columns: List.generate(headers.length, (i) => DataColumn(label: Text(headers[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)), onSort: (col, _) => _onTeacherSort(col))),
          rows: _teacherData.map((d) => DataRow(cells: [
            DataCell(Text(d['name'] as String, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text('${d['session_count']}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text((d['weekly_hours'] as num).toStringAsFixed(1), style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text('${d['students_taught']}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
            DataCell(Text('${(d['earnings'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}', style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary))),
          ])).toList(),
        ),
      ),
    );
  }

  Future<void> _exportTeacherPdf() async {
    if (_teacherData.isEmpty) return;
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (_) => [
        pw.Header(text: 'Teacher Workload Report', level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 7),
          headers: ['Teacher', 'Sessions', 'Hours/Week', 'Students', 'Payouts'],
          data: _teacherData.map((d) => [
            d['name'] as String,
            '${d['session_count']}',
            (d['weekly_hours'] as num).toStringAsFixed(1),
            '${d['students_taught']}',
            '${(d['earnings'] as num).toStringAsFixed(0)} ${AppConstants.currencySymbol}',
          ]).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportTeacherExcel() async {
    if (_teacherData.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel['Teacher Workload'];
    sheet.appendRow([TextCellValue('Teacher'), TextCellValue('Sessions'), TextCellValue('Hours/Week'), TextCellValue('Students'), TextCellValue('Payouts')]);
    for (final d in _teacherData) {
      sheet.appendRow([
        TextCellValue(d['name'] as String),
        TextCellValue('${d['session_count']}'),
        TextCellValue((d['weekly_hours'] as num).toStringAsFixed(1)),
        TextCellValue('${d['students_taught']}'),
        TextCellValue('${(d['earnings'] as num).toStringAsFixed(0)}'),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/teacher_workload.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Excel: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: ShellTokens.chromeSurface,
        border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _tabIndex == i;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: GestureDetector(
              onTap: () { setState(() => _tabIndex = i); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? ShellTokens.accent : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? ShellTokens.chromeBase : ShellTokens.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(AppLocalizations l10n, List<String> monthNames) {
    if (_tabIndex == 1) {
      return AttendanceReportsScreen(database: widget.database);
    }
    if (_tabIndex == 2) {
      return _buildTrendContent();
    }
    if (_tabIndex == 3) {
      return _buildClassPerformanceContent();
    }
    if (_tabIndex == 4) {
      return _buildTeacherWorkloadContent();
    }

    if (_loading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMonthSelector(l10n, monthNames),
          const SizedBox(height: 16),
          _buildSummaryCard(l10n),
          const SizedBox(height: 12),
          _buildBreakdownCard(l10n),
          const SizedBox(height: 12),
          _buildDebtorsCard(l10n),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _buildMonthSelector(AppLocalizations l10n, List<String> monthNames) {
    final hasRange = _dateFrom != null && _dateTo != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            if (!hasRange) ...[
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
                tooltip: l10n.previous,
              ),
              GestureDetector(
                onTap: _selectYear,
                child: Text(
                  '${monthNames[_selectedDate.month]} ${_selectedDate.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                tooltip: l10n.next,
              ),
            ] else ...[
              _buildDateButton('من ${_fmtDate(_dateFrom!)}', () => _pickDate(from: true)),
              const SizedBox(width: 4),
              _buildDateButton('إلى ${_fmtDate(_dateTo!)}', () => _pickDate(from: false)),
              const SizedBox(width: 4),
              SizedBox(
                height: 34,
                child: IconButton(
                  icon: const Icon(PhosphorIcons.x, size: 14, color: ShellTokens.textSecondary),
                  onPressed: () { setState(() { _dateFrom = null; _dateTo = null; }); _loadData(); },
                  tooltip: 'Clear',
                  style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeBase),
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              height: 34,
              child: IconButton(
                icon: Icon(hasRange ? Icons.calendar_view_month : Icons.date_range, size: 16, color: hasRange ? ShellTokens.accent : ShellTokens.textSecondary),
                onPressed: hasRange ? () { setState(() { _dateFrom = null; _dateTo = null; }); _loadData(); } : _pickDate,
                tooltip: hasRange ? 'Show month' : 'Custom Range',
                style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 34,
              child: IconButton(
                icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary),
                onPressed: _exportPdf,
                tooltip: 'Export PDF',
                style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 34,
              child: IconButton(
                icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary),
                onPressed: _exportExcel,
                tooltip: 'Export Excel',
                style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 34,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: ShellTokens.chromeSurface,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: const BorderSide(color: ShellTokens.chromeBorder)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textPrimary)),
      ),
    );
  }

  Future<void> _pickDate({bool from = true}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _dateFrom = picked;
        if (_dateTo == null) _dateTo = picked;
      } else {
        _dateTo = picked;
        if (_dateFrom == null) _dateFrom = picked;
      }
    });
    _loadData();
  }

  Widget _buildSummaryCard(AppLocalizations l10n) {
    return Card(
      color: _netProfit >= 0 ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              l10n.netProfit,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${_netProfit.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _netProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.income,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green.shade700),
            ),
            const SizedBox(height: 8),
            _breakdownRow(l10n.studentPayments, _studentPaymentIncome, Colors.green),
            _breakdownRow(l10n.sessionCharges, _sessionChargeIncome, Colors.green),
            if (_discountTotal > 0)
              _breakdownRow(l10n.discount, -_discountTotal, Colors.orange),
            const Divider(height: 24),
            Text(
              l10n.expenses,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red.shade700),
            ),
            const SizedBox(height: 8),
            _breakdownRow(l10n.teacherPayouts, _teacherPayouts, Colors.red),
            _breakdownRow(l10n.expenses, _expenses, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${amount.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtorsCard(AppLocalizations l10n) {
    final topDebtors = _debtors.take(10).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.outstandingDebtsList,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (topDebtors.isEmpty)
              Text(l10n.noData)
            else
              ...topDebtors.map(
                (d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.studentName, style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text(d.studentCode, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(
                        '${d.debt.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DebtorEntry {
  final String studentName;
  final String studentCode;
  final double debt;

  _DebtorEntry({
    required this.studentName,
    required this.studentCode,
    required this.debt,
  });
}
