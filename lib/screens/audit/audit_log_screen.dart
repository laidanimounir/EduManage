import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/audit_log_repository.dart';
import '../../repositories/user_repository.dart';

class AuditLogScreen extends StatefulWidget {
  final AppDatabase database;
  const AuditLogScreen({super.key, required this.database});
  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  late final AuditLogRepository _auditRepo;
  late final UserRepository _userRepo;
  List<AuditLogData> _entries = [];
  List<User> _users = [];
  bool _loading = true;
  int _currentPage = 0;
  static const int _pageSize = 30;
  bool _hasMore = true;

  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String? _filterUserId;

  @override
  void initState() {
    super.initState();
    _auditRepo = AuditLogRepository(widget.database);
    _userRepo = UserRepository(widget.database);
    _loadUsers();
    _loadEntries();
  }

  Future<void> _loadUsers() async {
    _users = await _userRepo.getAll();
    if (mounted) setState(() {});
  }

  Future<void> _loadEntries() async {
    setState(() => _loading = true);
    _currentPage = 0;
    _hasMore = true;

    List<AuditLogData> allEntries;
    if (_filterStartDate != null && _filterEndDate != null) {
      allEntries = await _auditRepo.getByDateRange(
          _filterStartDate!, _filterEndDate!);
    } else if (_filterUserId != null) {
      allEntries = await _auditRepo.getByUser(_filterUserId!);
    } else {
      allEntries = await _auditRepo.getAll();
    }

    if (_filterUserId != null) {
      allEntries = allEntries
          .where((e) => e.userId == _filterUserId)
          .toList();
    }

    _entries = allEntries.take(_pageSize).toList();
    _hasMore = allEntries.length > _pageSize;

    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loading) return;
    setState(() => _loading = true);

    _currentPage++;
    List<AuditLogData> allEntries;
    if (_filterStartDate != null && _filterEndDate != null) {
      allEntries = await _auditRepo.getByDateRange(
          _filterStartDate!, _filterEndDate!);
    } else if (_filterUserId != null) {
      allEntries = await _auditRepo.getByUser(_filterUserId!);
    } else {
      allEntries = await _auditRepo.getAll();
    }

    if (_filterUserId != null) {
      allEntries = allEntries
          .where((e) => e.userId == _filterUserId)
          .toList();
    }

    final start = _currentPage * _pageSize;
    if (start >= allEntries.length) {
      _hasMore = false;
    } else {
      final more =
          allEntries.skip(start).take(_pageSize).toList();
      _entries.addAll(more);
      _hasMore = start + _pageSize < allEntries.length;
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  String _userName(String userId) {
    final user = _users.where((u) => u.id == userId).firstOrNull;
    if (user != null) return '${user.firstName} ${user.lastName}';
    return userId;
  }

  String _formatTimestamp(DateTime ts) {
    return '${ts.year}/${ts.month.toString().padLeft(2, '0')}/${ts.day.toString().padLeft(2, '0')} '
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: l10n.filterByDate,
    );
    if (range != null) {
      _filterStartDate = range.start;
      _filterEndDate = range.end;
      _filterUserId = null;
      _loadEntries();
    }
  }

  Future<void> _showFilterSheet() async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.filterByUser,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ListTile(
                title: Text(l10n.allUsers),
                leading: Radio<String?>(
                  value: null,
                  groupValue: _filterUserId,
                  onChanged: (_) {
                    _filterUserId = null;
                    _filterStartDate = null;
                    _filterEndDate = null;
                    Navigator.pop(ctx);
                    _loadEntries();
                  },
                ),
              ),
              ..._users.map(
                (u) => ListTile(
                  title: Text('${u.firstName} ${u.lastName}'),
                  subtitle: Text(u.role),
                  leading: Radio<String?>(
                    value: u.id,
                    groupValue: _filterUserId,
                    onChanged: (_) {
                      _filterUserId = u.id;
                      _filterStartDate = null;
                      _filterEndDate = null;
                      Navigator.pop(ctx);
                      _loadEntries();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          if (_filterStartDate != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Text(
                    '${_formatTimestamp(_filterStartDate!)} - ${_formatTimestamp(_filterEndDate!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _filterStartDate = null;
                      _filterEndDate = null;
                      _loadEntries();
                    },
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          if (_filterUserId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Text(
                    '${l10n.user}: ${_userName(_filterUserId!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _filterUserId = null;
                      _loadEntries();
                    },
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _loading && _entries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? Center(child: Text(l10n.noAuditEntries))
                    : ListView.builder(
                        itemCount: _entries.length + (_hasMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i >= _entries.length) {
                            if (_loading) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return TextButton(
                              onPressed: _loadMore,
                              child: Text(l10n.next),
                            );
                          }
                          final entry = _entries[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                entry.action,
                                style: const TextStyle(fontSize: 13),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.user}: ${_userName(entry.userId)}  |  ${l10n.entity}: ${entry.entityType}${entry.entityId != null ? " (${entry.entityId})" : ""}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  if (entry.details != null)
                                    Text(
                                      entry.details!,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                              trailing: Text(
                                _formatTimestamp(entry.timestamp),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
