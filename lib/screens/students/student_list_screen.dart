import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import 'student_form_screen.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  final AppDatabase database;

  const StudentListScreen({super.key, required this.database});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late final StudentRepository _repo;
  List<Student> _students = [];
  List<Student> _filtered = [];
  String _searchQuery = '';
  String _statusFilter = 'all';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _loading = true);
    final students = await _repo.getAll();
    setState(() {
      _students = students;
      _loading = false;
    });
    _applyFilters();
  }

  void _applyFilters() {
    var result = _students;
    if (_statusFilter != 'all') {
      result = result.where((s) => s.status == _statusFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((s) {
        return (s.firstNameAr.toLowerCase().contains(q) ||
            s.lastNameAr.toLowerCase().contains(q) ||
            (s.firstNameFr?.toLowerCase().contains(q) ?? false) ||
            (s.lastNameFr?.toLowerCase().contains(q) ?? false) ||
            s.code.toLowerCase().contains(q) ||
            (s.phone?.toLowerCase().contains(q) ?? false));
      }).toList();
    }
    setState(() => _filtered = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.students)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentFormScreen(database: widget.database),
            ),
          );
          if (result == true) _loadStudents();
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (v) {
                _searchQuery = v;
                _applyFilters();
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildFilterChip(l10n.all, 'all'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.active, 'active'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.inactive, 'inactive'),
                const SizedBox(width: 8),
                _buildFilterChip(l10n.graduated, 'graduated'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? Center(child: Text(l10n.noData))
                    : ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (ctx, i) {
                          final s = _filtered[i];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(s.firstNameAr[0]),
                            ),
                            title: Text(
                              '${s.firstNameAr} ${s.lastNameAr}',
                            ),
                            subtitle: Text(
                              '${l10n.code}: ${s.code}  |  ${l10n.status}: ${_statusLabel(s.status, l10n)}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StudentDetailScreen(
                                    database: widget.database,
                                    studentId: s.id,
                                  ),
                                ),
                              );
                              _loadStudents();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _statusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _statusFilter = value);
        _applyFilters();
      },
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
