import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/subject_group_repository.dart';

class EnrollmentScreen extends StatefulWidget {
  final AppDatabase database;
  const EnrollmentScreen({super.key, required this.database});
  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  late final EnrollmentRepository _enrollRepo;
  late final StudentRepository _studentRepo;
  late final SubjectGroupRepository _groupRepo;
  List<Enrollment> _enrollments = [];
  List<Student> _students = [];
  List<SubjectGroup> _groups = [];
  bool _loading = true;
  String _viewMode = 'all';

  @override
  void initState() { super.initState(); _enrollRepo = EnrollmentRepository(widget.database); _studentRepo = StudentRepository(widget.database); _groupRepo = SubjectGroupRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _enrollments = await _enrollRepo.getAll(); _students = await _studentRepo.getAll(); _groups = await _groupRepo.getAll(); setState(() => _loading = false); }

  Future<void> _showForm() async {
    final l10n = AppLocalizations.of(context);
    String? studentId; String? groupId; final priceCtrl = TextEditingController(); final discountCtrl = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      title: Text(l10n.enrollStudent),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(value: studentId, decoration: InputDecoration(labelText: l10n.students), items: _students.map((s) => DropdownMenuItem(value: s.id, child: Text('${s.firstNameAr} ${s.lastNameAr} (${s.code})'))).toList(), onChanged: (v) => setSt(() => studentId = v)),
        DropdownButtonFormField<String>(value: groupId, decoration: InputDecoration(labelText: l10n.groups), items: _groups.map((g) => DropdownMenuItem(value: g.id, child: Text(g.nameAr))).toList(), onChanged: (v) => setSt(() => groupId = v)),
        TextFormField(controller: priceCtrl, decoration: InputDecoration(labelText: l10n.customPrice), keyboardType: TextInputType.number),
        TextFormField(controller: discountCtrl, decoration: InputDecoration(labelText: l10n.discount), keyboardType: TextInputType.number),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
    )));
    if (ok == true && studentId != null && groupId != null) {
      await _enrollRepo.create(EnrollmentsCompanion(
        studentId: Value(studentId!), subjectGroupId: Value(groupId!),
        customPriceOverride: Value(double.tryParse(priceCtrl.text)),
        customDiscount: Value(double.tryParse(discountCtrl.text)),
      ));
      _load();
    }
  }

  String _studentName(String id) { final s = _students.cast<Student?>().firstWhere((s) => s?.id == id, orElse: () => null); return s != null ? '${s.firstNameAr} ${s.lastNameAr}' : id; }
  String _groupName(String id) { final g = _groups.cast<SubjectGroup?>().firstWhere((g) => g?.id == id, orElse: () => null); return g != null ? g.nameAr : id; }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.enrollments)),
      floatingActionButton: FloatingActionButton(onPressed: _showForm, child: const Icon(Icons.add)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : _enrollments.isEmpty ? Center(child: Text(l10n.noEnrollments)) : ListView.builder(itemCount: _enrollments.length, itemBuilder: (_, i) {
        final e = _enrollments[i];
        return Card(child: ListTile(
          title: Text(_studentName(e.studentId)),
          subtitle: Text('${_groupName(e.subjectGroupId)}  |  ${l10n.status}: ${e.status}'),
          trailing: PopupMenuButton<String>(onSelected: (action) async {
            if (action == 'drop') {
              await _enrollRepo.updateStatus(e.id, 'inactive');
            } else if (action == 'activate') {
              await _enrollRepo.updateStatus(e.id, 'active');
            } else if (action == 'delete') {
              await _enrollRepo.delete(e.id);
            }
            _load();
          }, itemBuilder: (_) => [
            PopupMenuItem(value: 'activate', child: Text(l10n.active)),
            PopupMenuItem(value: 'drop', child: Text(l10n.dropEnrollment)),
            PopupMenuItem(value: 'delete', child: Text(l10n.delete, style: const TextStyle(color: Colors.red))),
          ]),
        ));
      }),
    );
  }
}
