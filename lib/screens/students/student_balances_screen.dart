import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../constants/app_constants.dart';
import '../payments/unified_payment_screen.dart';

class StudentBalancesScreen extends StatefulWidget {
  final AppDatabase database;
  const StudentBalancesScreen({super.key, required this.database});
  @override
  State<StudentBalancesScreen> createState() => _StudentBalancesScreenState();
}

class _StudentBalancesScreenState extends State<StudentBalancesScreen> {
  late final StudentRepository _repo;
  List<_StudentBalanceEntry> _entries = [];
  bool _loading = true;
  String _sortBy = 'debt';
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final students = await _repo.getAll();
    final entries = <_StudentBalanceEntry>[];
    for (final s in students) {
      final balance = await widget.database.getStudentBalance(s.id);
      entries.add(_StudentBalanceEntry(
        student: s,
        balance: balance,
      ));
    }
    _sort(entries);
    setState(() { _entries = entries; _loading = false; });
  }

  void _sort(List<_StudentBalanceEntry> list) {
    switch (_sortBy) {
      case 'name':
        list.sort((a, b) => _ascending
            ? a.student.firstNameAr.compareTo(b.student.firstNameAr)
            : b.student.firstNameAr.compareTo(a.student.firstNameAr));
      case 'debt':
        list.sort((a, b) => _ascending
            ? a.balance.compareTo(b.balance)
            : b.balance.compareTo(a.balance));
      case 'code':
        list.sort((a, b) => _ascending
            ? a.student.code.compareTo(b.student.code)
            : b.student.code.compareTo(a.student.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.outstandingDebts),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              setState(() => _sortBy = v);
              _sort(_entries);
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'debt', child: Text(l10n.debt)),
              PopupMenuItem(value: 'name', child: Text(l10n.firstName)),
              PopupMenuItem(value: 'code', child: Text(l10n.code)),
            ],
          ),
          IconButton(
            icon: Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() => _ascending = !_ascending);
              _sort(_entries);
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(child: Text(l10n.noData))
              : ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (_, i) {
                    final e = _entries[i];
                    final owing = e.balance > 0;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: owing ? Colors.red.shade100 : Colors.green.shade100,
                          child: Icon(
                            owing ? Icons.warning : Icons.check_circle,
                            color: owing ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(
                          '${e.student.firstNameAr} ${e.student.lastNameAr}',
                        ),
                        subtitle: Text(e.student.code),
                        trailing: Text(
                          '${e.balance.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: owing ? Colors.red : Colors.green,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => UnifiedPaymentScreen(
                              database: widget.database,
                              initialStudentCode: e.student.code,
                            ),
                          ));
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class _StudentBalanceEntry {
  final Student student;
  final double balance;
  const _StudentBalanceEntry({required this.student, required this.balance});
}
