import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/transaction_repository.dart';

class PaymentScreen extends StatefulWidget {
  final AppDatabase database;
  const PaymentScreen({super.key, required this.database});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final StudentRepository _studentRepo;
  late final TransactionService _txService;
  late final TransactionRepository _txRepo;
  List<Transaction> _recentPayments = [];
  Student? _selectedStudent;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() { super.initState(); _studentRepo = StudentRepository(widget.database); _txService = TransactionService(widget.database); _txRepo = TransactionRepository(widget.database); _loadPayments(); }
  Future<void> _loadPayments() async { setState(() => _loading = true); _recentPayments = await _txRepo.getByType('student_payment'); setState(() => _loading = false); }

  Future<void> _searchStudent(String query) async {
    final students = await _studentRepo.search(query);
    if (students.isNotEmpty) { setState(() => _selectedStudent = students.first); }
  }

  Future<void> _processPayment() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.amountMustBePositive)));
      return;
    }
    await _txService.createStudentPayment(studentId: _selectedStudent!.id, amount: amount, note: _noteCtrl.text);
    if (!mounted) return;
    _amountCtrl.clear(); _noteCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.operationSuccessful)));
    _loadPayments();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.payments)),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              decoration: InputDecoration(hintText: l10n.searchStudent, prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              onSubmitted: _searchStudent,
            ),
            if (_selectedStudent != null) ...[
              const SizedBox(height: 12),
              Card(color: Colors.blue.shade50, child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
                CircleAvatar(child: Text(_selectedStudent!.firstNameAr[0])),
                const SizedBox(width: 12),
                Expanded(child: Text('${_selectedStudent!.firstNameAr} ${_selectedStudent!.lastNameAr}\n${_selectedStudent!.code}', style: const TextStyle(fontWeight: FontWeight.bold))),
              ]))),
              const SizedBox(height: 12),
              TextField(controller: _amountCtrl, decoration: InputDecoration(labelText: l10n.amount), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: _noteCtrl, decoration: InputDecoration(labelText: l10n.note)),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _processPayment, child: Text(l10n.save))),
            ],
          ])),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(l10n.paymentHistory, style: Theme.of(context).textTheme.titleMedium)),
        Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) : _recentPayments.isEmpty ? Center(child: Text(l10n.noData)) : ListView.builder(itemCount: _recentPayments.length, itemBuilder: (_, i) {
          final p = _recentPayments[i];
          return ListTile(title: Text('${p.amount} DA'), subtitle: Text('${p.transactionDate.year}/${p.transactionDate.month}/${p.transactionDate.day}  ${p.note ?? ''}'), leading: const Icon(Icons.payment, color: Colors.green));
        })),
      ]),
    );
  }
}
