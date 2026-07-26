import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/transaction_repository.dart';
import 'student_form_screen.dart';
import 'package:drift/drift.dart' hide Column;

class StudentDetailScreen extends StatefulWidget {
  final AppDatabase database;
  final String studentId;

  const StudentDetailScreen({
    super.key,
    required this.database,
    required this.studentId,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late final StudentRepository _repo;
  late final EnrollmentRepository _enrollmentRepo;
  late final TransactionRepository _txRepo;
  Student? _student;
  List<Enrollment> _enrollments = [];
  List<Transaction> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    _enrollmentRepo = EnrollmentRepository(widget.database);
    _txRepo = TransactionRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _student = await _repo.getById(widget.studentId);
    _enrollments = await _enrollmentRepo.getByStudent(widget.studentId);
    _transactions = await _txRepo.getByStudent(widget.studentId);
    setState(() => _loading = false);
  }

  Future<void> _changeStatus(String newStatus) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirm),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );
    if (confirm != true) return;
    await _repo.update(widget.studentId, StudentsCompanion(status: Value(newStatus)));
    _load();
  }

  Future<void> _deleteStudent() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(_enrollments.isNotEmpty
            ? '${l10n.confirmDelete}\n${l10n.enrollments}: ${_enrollments.length}'
            : l10n.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _repo.delete(widget.studentId);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_student == null) {
      return Scaffold(
        body: Center(child: Text(l10n.studentNotFound)),
      );
    }

    final s = _student!;
    final chargeSum = _transactions
        .where((t) => t.type == 'session_charge')
        .fold<double>(0, (sum, t) => sum + t.amount);
    final paymentSum = _transactions
        .where((t) => t.type == 'student_payment' || t.type == 'discount')
        .fold<double>(0, (sum, t) => sum + t.amount);
    final balance = chargeSum - paymentSum;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.personalInfo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  _infoRow(l10n.code, s.code),
                  _infoRow(l10n.firstName, '${s.firstNameAr} / ${s.firstNameFr ?? ''}'),
                  _infoRow(l10n.lastName, '${s.lastNameAr} / ${s.lastNameFr ?? ''}'),
                  _infoRow(l10n.phone, s.phone ?? '--'),
                  _infoRow(l10n.gender, s.gender == 'male' ? l10n.male : l10n.female),
                  _infoRow(l10n.status, _statusLabel(s.status, l10n)),
                  if (s.birthDate != null)
                    _infoRow(l10n.birthDate,
                        '${s.birthDate!.year}/${s.birthDate!.month}/${s.birthDate!.day}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.financialStatus,
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  _infoRow(l10n.balance, '$balance ${l10n.balance}'),
                  _infoRow('${l10n.sessionCharge}:', '$chargeSum'),
                  _infoRow(l10n.payments, '$paymentSum'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.enrollments,
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  if (_enrollments.isEmpty)
                    Text(l10n.noEnrollments)
                  else
                    ..._enrollments.map((e) => ListTile(
                          title: Text(e.subjectGroupId),
                          subtitle: Text(
                              '${l10n.status}: ${_statusLabel(e.status, l10n)}'),
                        )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_enrollments.isEmpty && _transactions.isEmpty)
            const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'active', label: Text(l10n.active)),
              ButtonSegment(value: 'inactive', label: Text(l10n.inactive)),
              ButtonSegment(value: 'graduated', label: Text(l10n.graduated)),
            ],
            selected: {s.status},
            onSelectionChanged: (v) => _changeStatus(v.first),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'active':
        return l10n.active;
      case 'inactive':
        return l10n.inactive;
      case 'graduated':
        return l10n.graduated;
      default:
        return status;
    }
  }
}
