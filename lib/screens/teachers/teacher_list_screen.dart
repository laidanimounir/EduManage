import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import 'teacher_form_screen.dart';
import 'teacher_detail_screen.dart';

class TeacherListScreen extends StatefulWidget {
  final AppDatabase database;
  const TeacherListScreen({super.key, required this.database});
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  late final TeacherRepository _repo;
  List<Teacher> _teachers = [];
  String _searchQuery = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = TeacherRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _teachers = await _repo.getAll();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _searchQuery.isEmpty
        ? _teachers
        : _teachers.where((t) {
            final q = _searchQuery.toLowerCase();
            return t.firstNameAr.toLowerCase().contains(q) ||
                t.lastNameAr.toLowerCase().contains(q) ||
                t.code.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teachers)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final r = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => TeacherFormScreen(database: widget.database)));
          if (r == true) _load();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(child: Text(l10n.noData))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final t = filtered[i];
                          return ListTile(
                            leading: CircleAvatar(child: Text(t.firstNameAr[0])),
                            title: Text('${t.firstNameAr} ${t.lastNameAr}'),
                            subtitle: Text('${l10n.code}: ${t.code}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(
                                builder: (_) => TeacherDetailScreen(database: widget.database, teacherId: t.id),
                              ));
                              _load();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
