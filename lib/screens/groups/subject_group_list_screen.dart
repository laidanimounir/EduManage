import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/subject_group_repository.dart';
import 'package:drift/drift.dart' hide Column;

class SubjectGroupListScreen extends StatefulWidget {
  final AppDatabase database;
  const SubjectGroupListScreen({super.key, required this.database});
  @override
  State<SubjectGroupListScreen> createState() => _SubjectGroupListScreenState();
}

class _SubjectGroupListScreenState extends State<SubjectGroupListScreen> {
  late final SubjectGroupRepository _repo;
  List<SubjectGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _repo = SubjectGroupRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _groups = await _repo.getAll(); setState(() => _loading = false); }

  Future<void> _showForm({String? id}) async {
    final nameArCtrl = TextEditingController(); final nameFrCtrl = TextEditingController();
    final subjectArCtrl = TextEditingController(); final subjectFrCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String level = 'primary';
    if (id != null) {
      final g = await _repo.getById(id); if (g != null) {
        nameArCtrl.text = g.nameAr; nameFrCtrl.text = g.nameFr ?? '';
        subjectArCtrl.text = g.subjectAr; subjectFrCtrl.text = g.subjectFr ?? '';
        descCtrl.text = g.description ?? ''; level = g.schoolLevel;
      }
    }
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      title: Text(id != null ? l10n.edit : l10n.add),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameArCtrl, decoration: InputDecoration(labelText: '${l10n.name} (AR)')),
        TextField(controller: nameFrCtrl, decoration: InputDecoration(labelText: '${l10n.name} (FR)')),
        TextField(controller: subjectArCtrl, decoration: InputDecoration(labelText: '${l10n.subject} (AR)')),
        TextField(controller: subjectFrCtrl, decoration: InputDecoration(labelText: '${l10n.subject} (FR)')),
        DropdownButtonFormField<String>(value: level, decoration: InputDecoration(labelText: l10n.schoolLevel), items: const [
          DropdownMenuItem(value: 'primary', child: Text('Primary')),
          DropdownMenuItem(value: 'middle', child: Text('Middle')),
        ], onChanged: (v) => setSt(() => level = v!)),
        TextField(controller: descCtrl, decoration: InputDecoration(labelText: l10n.description), maxLines: 2),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save))],
    )));
    if (ok == true) {
      final c = SubjectGroupsCompanion(nameAr: Value(nameArCtrl.text), nameFr: Value(nameFrCtrl.text.isEmpty ? null : nameFrCtrl.text), subjectAr: Value(subjectArCtrl.text), subjectFr: Value(subjectFrCtrl.text.isEmpty ? null : subjectFrCtrl.text), schoolLevel: Value(level), description: Value(descCtrl.text.isEmpty ? null : descCtrl.text));
      if (id != null) { await _repo.update(id, c); } else { await _repo.create(c); }
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.groups)),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : _groups.isEmpty ? Center(child: Text(l10n.noData))
          : ListView.builder(itemCount: _groups.length, itemBuilder: (_, i) {
              final g = _groups[i];
              return ListTile(
                leading: const Icon(Icons.group), title: Text(g.nameAr),
                subtitle: Text('${g.subjectAr} - ${g.schoolLevel}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showForm(id: g.id)),
                  IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () async {
                    final c = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: Text(l10n.confirmDelete), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete))]));
                    if (c == true) { await _repo.delete(g.id); _load(); }
                  }),
                ]),
              );
            }),
    );
  }
}
