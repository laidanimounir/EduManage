import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/enrollment_repository.dart';
import 'package:drift/drift.dart' hide Column;

class StudentFormScreen extends StatefulWidget {
  final AppDatabase database;
  final String? studentId;

  const StudentFormScreen({
    super.key,
    required this.database,
    this.studentId,
  });

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  late final StudentRepository _repo;
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _firstNameArCtrl = TextEditingController();
  final _lastNameArCtrl = TextEditingController();
  final _firstNameFrCtrl = TextEditingController();
  final _lastNameFrCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _birthPlaceCtrl = TextEditingController();
  String _gender = 'male';
  String _status = 'active';
  DateTime? _birthDate;
  DateTime _registrationDate = DateTime.now();
  bool _isEdit = false;
  bool _saving = false;
  List<SubjectGroup> _groups = [];
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    SubjectGroupRepository(widget.database).getAll().then((g) { if (mounted) setState(() => _groups = g); }).catchError((_) {});
    if (widget.studentId != null) {
      _isEdit = true;
      _loadStudent();
    }
  }

  Future<void> _loadStudent() async {
    final s = await _repo.getById(widget.studentId!);
    if (s == null) return;
    setState(() {
      _codeCtrl.text = s.code;
      _firstNameArCtrl.text = s.firstNameAr;
      _lastNameArCtrl.text = s.lastNameAr;
      _firstNameFrCtrl.text = s.firstNameFr ?? '';
      _lastNameFrCtrl.text = s.lastNameFr ?? '';
      _phoneCtrl.text = s.phone ?? '';
      _addressCtrl.text = s.address ?? '';
      _birthPlaceCtrl.text = s.birthPlace ?? '';
      _gender = s.gender ?? 'male';
      _status = s.status;
      _birthDate = s.birthDate;
      _registrationDate = s.registrationDate;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final companion = StudentsCompanion(
        code: Value(_codeCtrl.text.trim()),
        firstNameAr: Value(_firstNameArCtrl.text.trim()),
        lastNameAr: Value(_lastNameArCtrl.text.trim()),
        firstNameFr: Value(_firstNameFrCtrl.text.trim().isEmpty
            ? null
            : _firstNameFrCtrl.text.trim()),
        lastNameFr: Value(_lastNameFrCtrl.text.trim().isEmpty
            ? null
            : _lastNameFrCtrl.text.trim()),
        phone: Value(_phoneCtrl.text.trim().isEmpty
            ? null
            : _phoneCtrl.text.trim()),
        address: Value(_addressCtrl.text.trim().isEmpty
            ? null
            : _addressCtrl.text.trim()),
        gender: Value(_gender),
        birthDate: Value(_birthDate),
        birthPlace: Value(_birthPlaceCtrl.text.trim().isEmpty
            ? null
            : _birthPlaceCtrl.text.trim()),
        registrationDate: Value(_registrationDate),
        status: Value(_status),
      );

      if (_isEdit) {
        await _repo.update(widget.studentId!, companion);
      } else {
        final studentId = await _repo.create(companion);
        if (_selectedGroupId != null) {
          await EnrollmentRepository(widget.database).create(EnrollmentsCompanion(
            studentId: Value(studentId),
            subjectGroupId: Value(_selectedGroupId!),
            status: const Value('active'),
          ));
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: InputDecoration(labelText: l10n.code),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firstNameArCtrl,
              decoration: InputDecoration(labelText: '${l10n.firstName} (AR)'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameArCtrl,
              decoration: InputDecoration(labelText: '${l10n.lastName} (AR)'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firstNameFrCtrl,
              decoration: InputDecoration(labelText: '${l10n.firstName} (FR)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameFrCtrl,
              decoration: InputDecoration(labelText: '${l10n.lastName} (FR)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              decoration: InputDecoration(labelText: l10n.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressCtrl,
              decoration: InputDecoration(labelText: l10n.address),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(labelText: l10n.gender),
              items: [
                DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                DropdownMenuItem(value: 'female', child: Text(l10n.female)),
              ],
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(l10n.birthDate),
              subtitle: Text(_birthDate != null
                  ? '${_birthDate!.year}/${_birthDate!.month}/${_birthDate!.day}'
                  : '--'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _birthDate ?? DateTime(2010, 1, 1),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (d != null) setState(() => _birthDate = d);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _birthPlaceCtrl,
              decoration: InputDecoration(labelText: l10n.birthPlace),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(labelText: l10n.status),
              items: [
                DropdownMenuItem(value: 'active', child: Text(l10n.active)),
                DropdownMenuItem(
                    value: 'inactive', child: Text(l10n.inactive)),
                DropdownMenuItem(
                    value: 'graduated', child: Text(l10n.graduated)),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedGroupId,
              decoration: InputDecoration(
                labelText: l10n.groups,
                helperText: _selectedGroupId == null ? l10n.enrollStudent : null,
              ),
              items: _groups.map((g) => DropdownMenuItem(
                value: g.id,
                child: Text(g.nameAr),
              )).toList(),
              onChanged: (v) => setState(() => _selectedGroupId = v),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _firstNameArCtrl.dispose();
    _lastNameArCtrl.dispose();
    _firstNameFrCtrl.dispose();
    _lastNameFrCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _birthPlaceCtrl.dispose();
    super.dispose();
  }
}
