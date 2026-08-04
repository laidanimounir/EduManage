import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/student_repository.dart';
import '../../constants/app_constants.dart';

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
  static const _tabs = ['الأرباح الشهرية'];

  DateTime _selectedDate = DateTime.now();
  bool _loading = true;

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

    final startOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final endOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final endOfMonthInclusive =
        DateTime(endOfMonth.year, endOfMonth.month, endOfMonth.day, 23, 59, 59);

    final allTx = await _txRepo.getByDateRange(startOfMonth, endOfMonthInclusive);

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

  Widget _buildMonthSelector(AppLocalizations l10n, List<String> monthNames) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
          ],
        ),
      ),
    );
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
