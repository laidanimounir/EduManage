import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../widgets/shell_dialog.dart';
import '../../widgets/shell_section_header.dart';
import '../../widgets/shell_input_decoration.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/bulk_payment_dialog.dart';

class FamilyScreen extends StatefulWidget {
  final AppDatabase database;
  const FamilyScreen({super.key, required this.database});
  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<Family> _families = [];
  Map<String, List<String>> _memberNames = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final families = await (widget.database.select(widget.database.families)
        ..orderBy([(t) => OrderingTerm.desc(t.name)])).get();
      final names = <String, List<String>>{};
      for (final f in families) {
        final memberRows = await (widget.database.select(widget.database.familyMembers)
          ..where((t) => t.familyId.equals(f.id))).get();
        final studentNames = <String>[];
        for (final m in memberRows) {
          final student = await (widget.database.select(widget.database.students)
            ..where((t) => t.id.equals(m.studentId))).getSingleOrNull();
          if (student != null) studentNames.add('${student.firstNameAr} ${student.lastNameAr}');
        }
        names[f.id] = studentNames;
      }
      if (mounted) setState(() { _families = families; _memberNames = names; _loading = false; _error = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load families: $e'; });
    }
  }

  void _openCreate() {
    showDialog(
      context: context,
      builder: (_) => _FamilyEditDialog(database: widget.database),
    ).then((_) { try { _load(); } catch (_) {} });
  }

  void _openEdit(Family f) {
    showDialog(
      context: context,
      builder: (_) => _FamilyEditDialog(database: widget.database, family: f),
    ).then((_) { try { _load(); } catch (_) {} });
  }

  Future<void> _deleteFamily(Family f) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ShellTokens.chromeSurface,
        title: const Text('Delete Family', style: TextStyle(color: ShellTokens.textPrimary)),
        content: const Text('Remove this family? Students will no longer receive the family discount.',
            style: TextStyle(color: ShellTokens.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: SemanticTokens.error))),
        ],
      ),
    );
    if (confirmed == true) {
      await (widget.database.delete(widget.database.familyMembers)
        ..where((t) => t.familyId.equals(f.id))).go();
      await (widget.database.delete(widget.database.families)
        ..where((t) => t.id.equals(f.id))).go();
      await _load();
    }
  }

  Future<void> _payFamily(Family f) async {
    final memberRows = await (widget.database.select(widget.database.familyMembers)
      ..where((t) => t.familyId.equals(f.id))).get();
    final ids = memberRows.map((m) => m.studentId).toSet();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => BulkPaymentDialog(
        database: widget.database,
        preSelectedStudentIds: ids,
        title: 'Pay ${f.name}',
      ),
    ).then((_) { try { _load(); } catch (_) {} });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: ContentTokens.background,
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(PhosphorIcons.warning, size: 32, color: SemanticTokens.warning),
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: ShellTokens.textSecondary)),
          const SizedBox(height: 12),
          TextButton(onPressed: _load, child: const Text('Retry')),
        ])),
      );
    }
    if (_loading) return const AppLoading();
    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(children: [
            const Text('Families', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            const Spacer(),
            IconButton(icon: const Icon(PhosphorIcons.plus, size: 18, color: ShellTokens.accent),
              onPressed: _openCreate, padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
          ]),
        ),
        Expanded(
          child: _families.isEmpty
              ? AppEmptyState(icon: PhosphorIcons.usersThree, message: 'No families')
              : ListView.builder(
                  itemCount: _families.length,
                  itemBuilder: (_, i) {
                    final f = _families[i];
                    final members = _memberNames[f.id] ?? [];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      color: ShellTokens.chromeSurface,
                      child: ListTile(
                        title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600, color: ShellTokens.textPrimary, fontSize: 13)),
                        subtitle: Text(
                          f.discountPercent != null
                              ? '${f.discountPercent!.toStringAsFixed(0)}% discount — ${members.length} member(s)'
                              : f.discountFixed != null
                                  ? '${f.discountFixed!.toStringAsFixed(0)} DA fixed — ${members.length} member(s)'
                                  : '${members.length} member(s)',
                          style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(icon: const Icon(PhosphorIcons.currencyCircleDollar, size: 14, color: ShellTokens.accent),
                            onPressed: () => _payFamily(f), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            tooltip: 'Record Payment for Family'),
                          IconButton(icon: const Icon(PhosphorIcons.pencilSimple, size: 14, color: ShellTokens.textSecondary),
                            onPressed: () => _openEdit(f), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                          IconButton(icon: const Icon(PhosphorIcons.archive, size: 14, color: SemanticTokens.error),
                            onPressed: () => _deleteFamily(f), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

class _FamilyEditDialog extends StatefulWidget {
  final AppDatabase database;
  final Family? family;
  const _FamilyEditDialog({required this.database, this.family});
  @override
  State<_FamilyEditDialog> createState() => _FamilyEditDialogState();
}

class _FamilyEditDialogState extends State<_FamilyEditDialog> {
  final _nameCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  String _discountType = 'percentage';
  Set<String> _selectedStudentIds = {};
  List<Student> _students = [];
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final repo = StudentRepository(widget.database);
      final students = await repo.getAll();
      if (widget.family != null) {
        _nameCtrl.text = widget.family!.name;
        if (widget.family!.discountPercent != null) {
          _discountCtrl.text = widget.family!.discountPercent!.toStringAsFixed(0);
          _discountType = 'percentage';
        } else if (widget.family!.discountFixed != null) {
          _discountCtrl.text = widget.family!.discountFixed!.toStringAsFixed(0);
          _discountType = 'fixed';
        }
        final memberRows = await (widget.database.select(widget.database.familyMembers)
          ..where((t) => t.familyId.equals(widget.family!.id))).get();
        _selectedStudentIds = memberRows.map((m) => m.studentId).toSet();
      }
      if (mounted) setState(() { _students = students; _loading = false; _loadError = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _loadError = 'Failed to load students: $e'; });
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Family name is required')));
      return;
    }
    setState(() => _saving = true);
    try {
      final discountVal = double.tryParse(_discountCtrl.text);

      if (widget.family != null) {
        await widget.database.update(widget.database.families).replace(Family(
          id: widget.family!.id, name: _nameCtrl.text.trim(),
          discountPercent: _discountType == 'percentage' ? discountVal : null,
          discountFixed: _discountType == 'fixed' ? discountVal : null,
          createdAt: widget.family!.createdAt, deviceId: widget.family!.deviceId,
        ));
        await (widget.database.delete(widget.database.familyMembers)
          ..where((t) => t.familyId.equals(widget.family!.id))).go();
        for (final sid in _selectedStudentIds) {
          await widget.database.into(widget.database.familyMembers).insert(FamilyMembersCompanion(
            familyId: Value(widget.family!.id),
            studentId: Value(sid),
          ));
        }
      } else {
        final fid = 'fam_${DateTime.now().millisecondsSinceEpoch}';
        await widget.database.into(widget.database.families).insert(FamiliesCompanion(
          id: Value(fid), name: Value(_nameCtrl.text.trim()),
          discountPercent: Value(_discountType == 'percentage' ? discountVal : null),
          discountFixed: Value(_discountType == 'fixed' ? discountVal : null),
        ));
        for (final sid in _selectedStudentIds) {
          await widget.database.into(widget.database.familyMembers).insert(FamilyMembersCompanion(
            familyId: Value(fid),
            studentId: Value(sid),
          ));
        }
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.family != null;
    return ShellDialog(
      maxWidth: 500, maxHeight: 650, title: isEdit ? 'Edit Family' : 'Create Family',
      body: _loadError != null
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(PhosphorIcons.warning, size: 28, color: SemanticTokens.warning),
              const SizedBox(height: 8),
              Text(_loadError!, style: const TextStyle(color: ShellTokens.textSecondary, fontSize: 12)),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ]))
          : _loading
              ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)))
              : ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      controller: _nameCtrl, autofocus: !isEdit,
                      decoration: ShellInputDecoration.textField(hintText: 'Family Name (required)'),
                      style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: TextField(
                        controller: _discountCtrl, keyboardType: TextInputType.number,
                        decoration: ShellInputDecoration.textField(hintText: _discountType == 'percentage' ? 'Discount %' : 'Fixed DA'),
                        style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                      )),
                      const SizedBox(width: 8),
                      DropdownButtonFormField<String>(
                        value: _discountType,
                        decoration: ShellInputDecoration.dropdown(),
                        style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'percentage', child: Text('%', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'fixed', child: Text('DA', style: TextStyle(fontSize: 12))),
                        ],
                        onChanged: (v) => setState(() => _discountType = v!),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    const ShellSectionHeader(text: 'Family Members', withBorder: false),
                    if (_students.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Text('No students found', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled))),
                      )
                    else
                      ...List.generate(_students.length, (i) {
                        final s = _students[i];
                        return CheckboxListTile(
                          value: _selectedStudentIds.contains(s.id),
                          onChanged: (v) {
                            setState(() {
                              if (v == true) { _selectedStudentIds.add(s.id); } else { _selectedStudentIds.remove(s.id); }
                            });
                          },
                          dense: true, contentPadding: EdgeInsets.zero,
                          title: Text('${s.firstNameAr} ${s.lastNameAr}',
                            style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                          subtitle: Text(s.code, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
                          activeColor: ShellTokens.accent,
                          checkColor: ShellTokens.chromeBase,
                        );
                      }),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(backgroundColor: ShellTokens.accent, foregroundColor: ShellTokens.chromeBase, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: _saving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.chromeBase))
                          : Text('Save Family', style: TextStyle(fontSize: 13, color: ShellTokens.chromeBase, fontWeight: FontWeight.w600)),
                    )),
                  ],
                ),
    );
  }
}
