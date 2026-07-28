import 'package:flutter/material.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../repositories/student_repository.dart';
import '../repositories/transaction_service.dart';
import 'shell_dialog.dart';
import 'shell_section_header.dart';
import 'shell_input_decoration.dart';

class BulkPaymentDialog extends StatefulWidget {
  final AppDatabase database;
  final Set<String>? preSelectedStudentIds;
  final String? title;

  const BulkPaymentDialog({
    super.key,
    required this.database,
    this.preSelectedStudentIds,
    this.title,
  });

  @override
  State<BulkPaymentDialog> createState() => _BulkPaymentDialogState();
}

class _BulkPaymentDialogState extends State<BulkPaymentDialog> {
  final _amountCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  List<Student> _selectedStudents = [];
  List<Map<String, dynamic>> _studentData = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final students = await StudentRepository(widget.database).getAll();
      final data = <Map<String, dynamic>>[];
      final preSelected = widget.preSelectedStudentIds ?? {};
      for (final s in students) {
        final balance = await widget.database.getStudentBalance(s.id);
        if (balance > 0 || preSelected.contains(s.id)) {
          data.add({'student': s, 'balance': balance});
          if (preSelected.contains(s.id)) _selectedStudents.add(s);
        }
      }
      if (mounted) setState(() { _studentData = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select students and enter an amount')));
      return;
    }
    setState(() => _saving = true);
    final txService = TransactionService(widget.database);
    int success = 0, failed = 0;
    for (final s in _selectedStudents) {
      try {
        await txService.createStudentPayment(studentId: s.id, amount: amount, note: _reasonCtrl.text);
        success++;
      } catch (_) {
        failed++;
      }
    }
    if (mounted) {
      final count = _selectedStudents.length;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$success/$count students paid${failed > 0 ? ' ($failed failed)' : ''}'),
        backgroundColor: ShellTokens.chromeSurface));
      if (success > 0) Navigator.pop(context);
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _selectedStudents.length;
    return ShellDialog(
      maxWidth: 500, maxHeight: 650, title: widget.title ?? 'Bulk Payment',
      body: _loading
          ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(controller: _amountCtrl, keyboardType: TextInputType.number,
          decoration: ShellInputDecoration.textField(hintText: 'Amount per student (DA)'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 8),
        TextField(controller: _reasonCtrl,
          decoration: ShellInputDecoration.textField(hintText: 'Reason (optional)'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
        const SizedBox(height: 12),
        ShellSectionHeader(text: '$total students selected', withBorder: true),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true, itemCount: _studentData.length,
            itemBuilder: (_, i) {
              final entry = _studentData[i];
              final s = entry['student'] as Student;
              final bal = entry['balance'] as double;
              return CheckboxListTile(
                value: _selectedStudents.contains(s),
                onChanged: (v) {
                  setState(() { if (v == true) { _selectedStudents.add(s); } else { _selectedStudents.remove(s); } });
                },
                dense: true, contentPadding: EdgeInsets.zero,
                title: Text('${s.firstNameAr} ${s.lastNameAr}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                subtitle: Text('Due: ${bal.toStringAsFixed(0)} DA', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
                activeColor: ShellTokens.accent, checkColor: ShellTokens.chromeBase,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: _saving || _selectedStudents.isEmpty ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase)) : Text('Record ${_selectedStudents.length} Payments'),
        )),
      ]),
    );
  }
}
