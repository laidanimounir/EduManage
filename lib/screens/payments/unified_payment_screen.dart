import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/transaction_repository.dart';
import '../../constants/app_constants.dart';

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
  late final StudentRepository _studentRepo;
  late final TransactionService _txService;
  late final TransactionRepository _txRepo;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  Student? _selectedStudent;
  double _totalCharged = 0;
  double _totalPaid = 0;
  double _balance = 0;
  List<Transaction> _paymentHistory = [];
  bool _loading = false;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _txService = TransactionService(widget.database);
    _txRepo = TransactionRepository(widget.database);

    if (widget.initialStudentCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadByCode(widget.initialStudentCode!));
    }
  }

  Future<void> _loadByCode(String code) async {
    setState(() => _loading = true);
    final student = await _studentRepo.getByCode(code.trim());
    if (student != null) {
      await _selectStudent(student);
    }
    setState(() { _loading = false; _initialLoadDone = true; });
  }

  Future<void> _searchStudent(String query) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);
    final students = await _studentRepo.search(query);
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.studentNotFound)),
      );
      setState(() => _loading = false);
      return;
    }
    if (students.length == 1) {
      await _selectStudent(students.first);
    } else {
      final selected = await showDialog<Student>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.selectSession),
          content: SizedBox(
            width: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (_, i) => ListTile(
                title: Text('${students[i].firstNameAr} ${students[i].lastNameAr}'),
                subtitle: Text(students[i].code),
                onTap: () => Navigator.pop(ctx, students[i]),
              ),
            ),
          ),
        ),
      );
      if (selected != null) {
        await _selectStudent(selected);
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _selectStudent(Student student) async {
    setState(() { _selectedStudent = student; _loading = true; });
    await _refreshData();
  }

  Future<void> _refreshData() async {
    if (_selectedStudent == null) return;
    final results = await Future.wait([
      widget.database.getStudentTotalCharged(_selectedStudent!.id),
      widget.database.getStudentTotalPaid(_selectedStudent!.id),
      widget.database.getStudentBalance(_selectedStudent!.id),
      _txRepo.getByStudent(_selectedStudent!.id),
    ]);
    setState(() {
      _totalCharged = results[0] as double;
      _totalPaid = results[1] as double;
      _balance = results[2] as double;
      _paymentHistory = (results[3] as List<Transaction>)
          .where((t) => t.type == 'student_payment' || t.type == 'discount' || t.type == 'reversal')
          .toList();
      _loading = false;
      _initialLoadDone = true;
    });
  }

  Future<void> _processPayment() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.amountMustBePositive)),
      );
      return;
    }
    await _txService.createStudentPayment(
      studentId: _selectedStudent!.id,
      amount: amount,
      note: _noteCtrl.text,
    );
    if (!mounted) return;
    _amountCtrl.clear();
    _noteCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.operationSuccessful)),
    );
    await _refreshData();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = AppConstants.currencySymbol;

    return Scaffold(
      body: _loading && !_initialLoadDone
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    autofocus: _initialLoadDone ? false : true,
                    decoration: InputDecoration(
                      hintText: l10n.searchStudent,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: _searchStudent,
                  ),
                ),
                if (_selectedStudent != null) ...[
                  _buildSummaryCard(l10n, currency),
                  _buildPaymentForm(l10n),
                  Expanded(child: _buildHistoryList(l10n)),
                ] else if (_initialLoadDone) ...[
                  Expanded(
                    child: Center(child: Text(l10n.noData)),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildSummaryCard(AppLocalizations l10n, String currency) {
    final balanceOwing = _balance > 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(_selectedStudent!.firstNameAr.characters.first),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedStudent!.firstNameAr} ${_selectedStudent!.lastNameAr}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _selectedStudent!.code,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(l10n.totalCharged, _totalCharged, currency, Colors.blue),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(
                  child: _buildStatTile(l10n.totalPaid, _totalPaid, currency, Colors.green),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(
                  child: _buildStatTile(
                    l10n.remaining,
                    _balance,
                    currency,
                    balanceOwing ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, double value, String currency, Color color) {
    return Column(
      children: [
        Text(
          '$value ${AppConstants.currencySymbol}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPaymentForm(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recordPayment, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: l10n.amount,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(
                labelText: l10n.note,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _processPayment,
                icon: const Icon(Icons.payment),
                label: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.paymentHistory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: _paymentHistory.isEmpty
              ? Center(child: Text(l10n.noData))
              : ListView.builder(
                  itemCount: _paymentHistory.length,
                  itemBuilder: (_, i) {
                    final p = _paymentHistory[i];
                    return ListTile(
                      leading: Icon(
                        p.type == 'reversal' ? Icons.undo : p.type == 'discount' ? Icons.discount : Icons.payment,
                        color: p.type == 'reversal' ? Colors.red : Colors.green,
                      ),
                      title: Text('${p.amount} ${AppConstants.currencySymbol}'),
                      subtitle: Text(
                        '${p.transactionDate.year}/${p.transactionDate.month.toString().padLeft(2, '0')}/${p.transactionDate.day.toString().padLeft(2, '0')}  ${p.note ?? ''}',
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
