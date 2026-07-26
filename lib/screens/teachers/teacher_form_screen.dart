import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import 'package:drift/drift.dart' hide Column;

class TeacherFormScreen extends StatefulWidget {
  final AppDatabase database;
  final String? teacherId;
  const TeacherFormScreen({super.key, required this.database, this.teacherId});
  @override
  State<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends State<TeacherFormScreen> {
  late final TeacherRepository _repo;
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _firstNameArCtrl = TextEditingController();
  final _lastNameArCtrl = TextEditingController();
  final _firstNameFrCtrl = TextEditingController();
  final _lastNameFrCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _idCardCtrl = TextEditingController();
  String _salaryType = 'percentage';
  final _sharePctCtrl = TextEditingController(text: '70');
  final _fixedAmountCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isEdit = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _repo = TeacherRepository(widget.database);
    if (widget.teacherId != null) {
      _isEdit = true;
      _load();
    }
  }

  Future<void> _load() async {
    final t = await _repo.getById(widget.teacherId!);
    if (t == null) return;
    setState(() {
      _codeCtrl.text = t.code;
      _firstNameArCtrl.text = t.firstNameAr;
      _lastNameArCtrl.text = t.lastNameAr;
      _firstNameFrCtrl.text = t.firstNameFr ?? '';
      _lastNameFrCtrl.text = t.lastNameFr ?? '';
      _phoneCtrl.text = t.phone ?? '';
      _addressCtrl.text = t.address ?? '';
      _emailCtrl.text = t.email ?? '';
      _idCardCtrl.text = t.idCard ?? '';
      _salaryType = t.salaryType;
      _sharePctCtrl.text = t.teacherSharePct?.toString() ?? '70';
      _fixedAmountCtrl.text = t.teacherFixedAmount?.toString() ?? '';
      _startDate = t.employmentStartDate;
      _endDate = t.employmentEndDate;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final c = TeachersCompanion(
        code: Value(_codeCtrl.text.trim()),
        firstNameAr: Value(_firstNameArCtrl.text.trim()),
        lastNameAr: Value(_lastNameArCtrl.text.trim()),
        firstNameFr: Value(_firstNameFrCtrl.text.trim().isEmpty ? null : _firstNameFrCtrl.text.trim()),
        lastNameFr: Value(_lastNameFrCtrl.text.trim().isEmpty ? null : _lastNameFrCtrl.text.trim()),
        phone: Value(_phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim()),
        address: Value(_addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim()),
        email: Value(_emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim()),
        idCard: Value(_idCardCtrl.text.trim().isEmpty ? null : _idCardCtrl.text.trim()),
        salaryType: Value(_salaryType),
        teacherSharePct: Value(_salaryType == 'percentage' ? double.tryParse(_sharePctCtrl.text) : null),
        teacherFixedAmount: Value(_salaryType == 'fixed' ? double.tryParse(_fixedAmountCtrl.text) : null),
        employmentStartDate: Value(_startDate),
        employmentEndDate: Value(_endDate),
      );
      if (_isEdit) {
        await _repo.update(widget.teacherId!, c);
      } else {
        await _repo.create(c);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(controller: _codeCtrl, decoration: InputDecoration(labelText: l10n.code), validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null),
          const SizedBox(height: 12),
          TextFormField(controller: _firstNameArCtrl, decoration: InputDecoration(labelText: '${l10n.firstName} (AR)'), validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null),
          const SizedBox(height: 12),
          TextFormField(controller: _lastNameArCtrl, decoration: InputDecoration(labelText: '${l10n.lastName} (AR)'), validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null),
          const SizedBox(height: 12),
          TextFormField(controller: _firstNameFrCtrl, decoration: InputDecoration(labelText: '${l10n.firstName} (FR)')),
          const SizedBox(height: 12),
          TextFormField(controller: _lastNameFrCtrl, decoration: InputDecoration(labelText: '${l10n.lastName} (FR)')),
          const SizedBox(height: 12),
          TextFormField(controller: _phoneCtrl, decoration: InputDecoration(labelText: l10n.phone), keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          TextFormField(controller: _addressCtrl, decoration: InputDecoration(labelText: l10n.address), maxLines: 2),
          const SizedBox(height: 12),
          TextFormField(controller: _emailCtrl, decoration: InputDecoration(labelText: l10n.email), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          TextFormField(controller: _idCardCtrl, decoration: InputDecoration(labelText: l10n.idCard)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _salaryType,
            decoration: InputDecoration(labelText: l10n.salaryType),
            items: [
              DropdownMenuItem(value: 'percentage', child: Text(l10n.percentage)),
              DropdownMenuItem(value: 'fixed', child: Text(l10n.fixed)),
            ],
            onChanged: (v) => setState(() => _salaryType = v!),
          ),
          if (_salaryType == 'percentage') ...[
            const SizedBox(height: 12),
            TextFormField(controller: _sharePctCtrl, decoration: InputDecoration(labelText: l10n.teacherShare), keyboardType: TextInputType.number),
          ],
          if (_salaryType == 'fixed') ...[
            const SizedBox(height: 12),
            TextFormField(controller: _fixedAmountCtrl, decoration: InputDecoration(labelText: l10n.teacherFixedAmount), keyboardType: TextInputType.number),
          ],
          const SizedBox(height: 12),
          ListTile(title: Text(l10n.employmentStartDate), subtitle: Text(_startDate != null ? '${_startDate!.year}/${_startDate!.month}/${_startDate!.day}' : '--'), trailing: const Icon(Icons.calendar_today), onTap: () async {
            final d = await showDatePicker(context: context, initialDate: _startDate ?? DateTime(2024, 1, 1), firstDate: DateTime(2000), lastDate: DateTime.now());
            if (d != null) setState(() => _startDate = d);
          }),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save)),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose(); _firstNameArCtrl.dispose(); _lastNameArCtrl.dispose();
    _firstNameFrCtrl.dispose(); _lastNameFrCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _emailCtrl.dispose(); _idCardCtrl.dispose();
    _sharePctCtrl.dispose(); _fixedAmountCtrl.dispose();
    super.dispose();
  }
}
