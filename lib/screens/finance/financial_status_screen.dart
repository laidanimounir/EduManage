import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/enrollment_repository.dart';

class FinancialStatusScreen extends StatefulWidget {
  final AppDatabase database;
  const FinancialStatusScreen({super.key, required this.database});
  @override
  State<FinancialStatusScreen> createState() => _FinancialStatusScreenState();
}

class _FinancialStatusScreenState extends State<FinancialStatusScreen> {
  late final TransactionRepository _txRepo;
  late final TransactionService _txService;
  List<Transaction> _transactions = [];
  String _filterType = 'all';
  DateTime? _dateFrom, _dateTo;
  bool _loading = true;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _expenseCategory = 'other';

  @override
  void initState() { super.initState(); _txRepo = TransactionRepository(widget.database); _txService = TransactionService(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); if (_filterType == 'all') { _transactions = await _txRepo.getAll(); } else if (_filterType == 'expense') { _transactions = await _txRepo.getByType('expense'); } else if (_filterType == 'student_payment') { _transactions = await _txRepo.getByType('student_payment'); } else if (_filterType == 'teacher_payout') { _transactions = await _txRepo.getByType('teacher_payout'); } setState(() => _loading = false); }

  Future<void> _addExpense() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive))); return; }
    await _txService.createExpense(amount: amount, category: _expenseCategory, note: _noteCtrl.text);
    _amountCtrl.clear(); _noteCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chargeSum = _transactions.where((t) => t.type == 'session_charge').fold<double>(0, (s, t) => s + t.amount);
    final paymentSum = _transactions.where((t) => t.type == 'student_payment').fold<double>(0, (s, t) => s + t.amount);
    final payoutSum = _transactions.where((t) => t.type == 'teacher_payout').fold<double>(0, (s, t) => s + t.amount);
    final expenseSum = _transactions.where((t) => t.type == 'expense').fold<double>(0, (s, t) => s + t.amount);

    return Scaffold(
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('$chargeSum', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(l10n.income)])))),
          Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('$paymentSum', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(l10n.payments)])))),
        ])),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
          FilterChip(label: Text(l10n.all), selected: _filterType == 'all', onSelected: (_) { _filterType = 'all'; _load(); }), const SizedBox(width: 4),
          FilterChip(label: Text(l10n.expenses), selected: _filterType == 'expense', onSelected: (_) { _filterType = 'expense'; _load(); }), const SizedBox(width: 4),
          FilterChip(label: Text(l10n.payments), selected: _filterType == 'student_payment', onSelected: (_) { _filterType = 'student_payment'; _load(); }), const SizedBox(width: 4),
          FilterChip(label: Text(l10n.teacherPayouts), selected: _filterType == 'teacher_payout', onSelected: (_) { _filterType = 'teacher_payout'; _load(); }),
        ])),
        Card(margin: const EdgeInsets.all(12), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Text(l10n.add, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(controller: _amountCtrl, decoration: InputDecoration(labelText: l10n.amount), keyboardType: TextInputType.number),
          DropdownButtonFormField<String>(value: _expenseCategory, decoration: InputDecoration(labelText: l10n.category), items: [
            DropdownMenuItem(value: 'rent', child: Text(l10n.rent)), DropdownMenuItem(value: 'salary', child: Text(l10n.salary)),
            DropdownMenuItem(value: 'materials', child: Text(l10n.materials)), DropdownMenuItem(value: 'utilities', child: Text(l10n.utilities)),
            DropdownMenuItem(value: 'other', child: Text(l10n.other)),
          ], onChanged: (v) => setState(() => _expenseCategory = v!)),
          TextField(controller: _noteCtrl, decoration: InputDecoration(labelText: l10n.note)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _addExpense, child: Text('${l10n.add} ${l10n.expense}')),
        ]))),
        Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) : _transactions.isEmpty ? Center(child: Text(l10n.noData)) : ListView.builder(itemCount: _transactions.length, itemBuilder: (_, i) {
          final t = _transactions[i];
          final isCredit = t.type == 'student_payment';
          return ListTile(title: Text('${isCredit ? '+' : '-'}${t.amount} DA'), subtitle: Text('${t.type} - ${t.transactionDate.year}/${t.transactionDate.month}/${t.transactionDate.day}'), leading: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red));
        })),
      ]),
    );
  }
}
