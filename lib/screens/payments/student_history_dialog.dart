import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/transaction_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_section_header.dart';
import '../../constants/app_constants.dart';

class StudentHistoryDialog extends StatefulWidget {
  final AppDatabase database;
  final String studentId;

  const StudentHistoryDialog({super.key, required this.database, required this.studentId});

  @override
  State<StudentHistoryDialog> createState() => _StudentHistoryDialogState();
}

class _StudentHistoryDialogState extends State<StudentHistoryDialog> {
  List<Transaction> _txs = [];
  String _studentName = '';
  double _charged = 0;
  double _paid = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      widget.database.getStudentTotalCharged(widget.studentId),
      widget.database.getStudentTotalPaid(widget.studentId),
      TransactionRepository(widget.database).getByStudent(widget.studentId),
      widget.database.customSelect(
        'SELECT first_name_ar, last_name_ar FROM students WHERE id = ?',
        variables: [Variable.withString(widget.studentId)],
      ).map((r) => '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')}').getSingle(),
    ]);
    if (mounted) {
      setState(() {
        _charged = results[0] as double;
        _paid = results[1] as double;
        _txs = results[2] as List<Transaction>;
        _studentName = results[3] as String;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 700,
      maxHeight: 650,
      title: _studentName,
      body: StudentHistoryContent(
        charged: _charged,
        paid: _paid,
        txs: _txs,
        loading: _loading,
      ),
    );
  }
}

class StudentHistoryContent extends StatelessWidget {
  final double charged;
  final double paid;
  final List<Transaction> txs;
  final bool loading;

  const StudentHistoryContent({
    super.key,
    required this.charged,
    required this.paid,
    required this.txs,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (loading) {
      return const Center(
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)),
      );
    }
    final balance = charged - paid;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _statCard(l10n.totalCharged, charged, const Color(0xFF4A90D9)),
        const SizedBox(width: 8),
        _statCard(l10n.totalPaid, paid, SemanticTokens.success),
        const SizedBox(width: 8),
        _statCard(l10n.remaining, balance, balance > 0 ? SemanticTokens.error : SemanticTokens.success),
      ]),
      const SizedBox(height: 12),
      ShellSectionHeader(text: l10n.paymentHistory, withBorder: true),
      const SizedBox(height: 4),
      txs.isEmpty
          ? Center(child: Text(l10n.noData, style: const TextStyle(fontSize: 12, color: ShellTokens.textDisabled)))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: txs.length,
              itemBuilder: (_, i) {
                final t = txs[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(children: [
                    SizedBox(width: 80, child: Text(_formatDate(t.transactionDate), style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled))),
                    SizedBox(width: 90, child: _txBadge(t.type, l10n)),
                    if (t.cycleNumber != null) SizedBox(width: 60, child: Text('Cycle ${t.cycleNumber}', style: TextStyle(fontSize: 9, color: ShellTokens.accent, fontWeight: FontWeight.w600))),
                    Expanded(child: Text(t.note ?? '', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Text('${t.amount.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: t.type == 'student_payment' || t.type == 'discount' || t.type == 'reversal' ? SemanticTokens.success : SemanticTokens.error)),
                  ]),
                );
              },
            ),
    ]);
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

  Widget _txBadge(String type, AppLocalizations l10n) {
    String label;
    Color color;
    switch (type) {
      case 'session_charge': label = l10n.sessionCharges; color = const Color(0xFF4A90D9);
      case 'student_payment': label = l10n.payments; color = SemanticTokens.success;
      case 'registration_fee': label = l10n.registrationFee; color = const Color(0xFF4A90D9);
      case 'registration_fee_payment': label = l10n.registrationFeePayment; color = SemanticTokens.success;
      case 'discount': label = l10n.discount; color = const Color(0xFF27AE60);
      case 'reversal': label = l10n.reversal; color = const Color(0xFFE74C3C);
      case 'session_cancellation_reversal': label = l10n.sessionCancellationReversal; color = const Color(0xFFE74C3C);
      case 'correction': label = l10n.correction; color = const Color(0xFFE74C3C);
      default: label = type; color = ShellTokens.textDisabled;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(3)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
    );
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
