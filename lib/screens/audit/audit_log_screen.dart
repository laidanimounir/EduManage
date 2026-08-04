import 'package:flutter/material.dart';
import '../../constants/theme_tokens.dart';
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
  String _entityFilter = 'all';

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

  Color _entityColor(String entityType) {
    switch (entityType) {
      case 'student': return const Color(0xFF4A90D9);
      case 'teacher': return const Color(0xFF9B59B6);
      case 'session': return const Color(0xFF5B8C5A);
      case 'payment': return const Color(0xFFE67E22);
      case 'enrollment': return const Color(0xFF1ABC9C);
      case 'group': return const Color(0xFFA78B4A);
      case 'classroom': return const Color(0xFF7C4DFF);
      case 'user': return const Color(0xFFF1C40F);
      case 'family': return const Color(0xFFE74C3C);
      case 'special_case': return const Color(0xFF16A085);
      default: return ShellTokens.textSecondary;
    }
  }

  Color _actionColor(String action) {
    if (action.contains('created') || action.contains('charged')) return SemanticTokens.success;
    if (action.contains('deleted') || action.contains('reversal') || action.contains('reversed') || action.contains('cancellation')) return SemanticTokens.error;
    if (action.contains('updated') || action.contains('edited') || action.contains('changed')) return const Color(0xFF4A90D9);
    if (action.contains('archived')) return const Color(0xFFD1943C);
    if (action.contains('restored') || action.contains('unarchived')) return ShellTokens.accent;
    if (action.contains('payment') || action.contains('payout') || action.contains('refund') || action.contains('fee') || action.contains('discount') || action.contains('transfer')) return const Color(0xFFE67E22);
    return ShellTokens.textSecondary;
  }

  List<AuditLogData> get _filteredEntries {
    if (_entityFilter == 'all') return _entries;
    return _entries.where((e) => _entityGroup(e.entityType) == _entityFilter).toList();
  }

  String _entityGroup(String entityType) {
    switch (entityType) {
      case 'student': return 'student';
      case 'teacher': return 'teacher';
      case 'session': return 'session';
      case 'payment': case 'transaction': return 'financial';
      case 'enrollment': return 'enrollment';
      case 'group': return 'group';
      case 'classroom': return 'classroom';
      case 'user': return 'user';
      case 'family': return 'family';
      case 'special_case': return 'special_case';
      default: return 'other';
    }
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
    final entities = ['all', 'student', 'teacher', 'session', 'financial', 'enrollment', 'group', 'classroom', 'user', 'family', 'special_case', 'other'];
    final entityLabels = <String, String>{
      'all': l10n.all, 'student': l10n.student, 'teacher': l10n.teacher, 'session': 'Session',
      'financial': 'Financial', 'enrollment': 'Enrollment', 'group': 'Group',
      'classroom': 'Classroom', 'user': 'User', 'family': 'Family', 'special_case': 'Special Case', 'other': 'Other',
    };
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: entities.map((v) => _buildFilterChip(entityLabels[v] ?? v, v, _entityFilter == v)).toList(),
            ),
          ),
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
          Row(children: [
            TextButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.calendar_today, size: 14),
              label: Text(l10n.filterByDate, style: const TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(foregroundColor: ShellTokens.textSecondary),
            ),
            TextButton.icon(
              onPressed: _showFilterSheet,
              icon: const Icon(Icons.person, size: 14),
              label: Text(l10n.filterByUser, style: const TextStyle(fontSize: 11)),
              style: TextButton.styleFrom(foregroundColor: ShellTokens.textSecondary),
            ),
          ]),
          Expanded(
            child: _loading && _entries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredEntries.isEmpty
                    ? Center(child: Text(l10n.noAuditEntries))
                    : ListView.builder(
                        itemCount: _filteredEntries.length + (_hasMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i >= _filteredEntries.length) {
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
                          final entry = _filteredEntries[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: ListTile(
                              dense: true,
                              leading: Container(
                                width: 4,
                                decoration: BoxDecoration(
                                  color: _actionColor(entry.action),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              title: Row(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: _entityColor(entry.entityType).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(entry.entityType, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _entityColor(entry.entityType))),
                                ),
                                const SizedBox(width: 6),
                                Expanded(child: Text(
                                  entry.action,
                                  style: const TextStyle(fontSize: 13),
                                )),
                              ]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${l10n.user}: ${_userName(entry.userId)}${entry.entityId != null ? "  |  ID: ${entry.entityId}" : ""}',
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

  Widget _buildFilterChip(String label, String value, bool selected) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => setState(() => _entityFilter = selected ? 'all' : value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary)),
          ),
        ),
      ),
    );
  }
}
