import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/classroom_repository.dart';

class ClassroomListScreen extends StatefulWidget {
  final AppDatabase database;
  const ClassroomListScreen({super.key, required this.database});
  @override
  State<ClassroomListScreen> createState() => _ClassroomListScreenState();
}

class _ClassroomListScreenState extends State<ClassroomListScreen> {
  late final ClassroomRepository _repo;
  List<Classroom> _rooms = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _repo = ClassroomRepository(widget.database); _load(); }
  Future<void> _load() async { setState(() => _loading = true); _rooms = await _repo.getAll(); setState(() => _loading = false); }

  Future<void> _showForm({String? id}) async {
    final nameArCtrl = TextEditingController(); final nameFrCtrl = TextEditingController();
    final floorCtrl = TextEditingController(); final capacityCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    if (id != null) {
      final r = await _repo.getById(id);
      if (r != null) { nameArCtrl.text = r.nameAr; nameFrCtrl.text = r.nameFr ?? ''; floorCtrl.text = r.floor?.toString() ?? ''; capacityCtrl.text = r.capacity?.toString() ?? ''; notesCtrl.text = r.notes ?? ''; }
    }

    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text(id != null ? l10n.edit : l10n.add),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameArCtrl, decoration: InputDecoration(labelText: '${l10n.name} (AR)')),
        TextField(controller: nameFrCtrl, decoration: InputDecoration(labelText: '${l10n.name} (FR)')),
        TextField(controller: floorCtrl, decoration: InputDecoration(labelText: l10n.floor), keyboardType: TextInputType.number),
        TextField(controller: capacityCtrl, decoration: InputDecoration(labelText: l10n.capacity), keyboardType: TextInputType.number),
        TextField(controller: notesCtrl, decoration: InputDecoration(labelText: l10n.note), maxLines: 2),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
      ],
    ));
    if (ok == true) {
      final c = ClassroomsCompanion(
        nameAr: Value(nameArCtrl.text), nameFr: Value(nameFrCtrl.text.isEmpty ? null : nameFrCtrl.text),
        floor: Value(int.tryParse(floorCtrl.text)), capacity: Value(int.tryParse(capacityCtrl.text)),
        notes: Value(notesCtrl.text.isEmpty ? null : notesCtrl.text),
      );
      if (id != null) { await _repo.update(id, c); } else { await _repo.create(c); }
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.classrooms)),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(), child: const Icon(Icons.add)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : _rooms.isEmpty ? Center(child: Text(l10n.noData))
          : ListView.builder(itemCount: _rooms.length, itemBuilder: (_, i) {
              final r = _rooms[i];
              return ListTile(
                leading: const Icon(Icons.meeting_room), title: Text(r.nameAr),
                subtitle: Text('${r.floor != null ? '${l10n.floor} ${r.floor}' : ''}  ${r.capacity != null ? '${l10n.capacity}: ${r.capacity}' : ''}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showForm(id: r.id)),
                  IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () async {
                    final c = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: Text(l10n.confirmDelete), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)), TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete))]));
                    if (c == true) { await _repo.delete(r.id); _load(); }
                  }),
                ]),
              );
            }),
    );
  }
}
