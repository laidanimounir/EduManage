import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/student_repository.dart';

class TodayAttendanceScreen extends StatefulWidget {
  final AppDatabase database;
  const TodayAttendanceScreen({super.key, required this.database});
  @override
  State<TodayAttendanceScreen> createState() => _TodayAttendanceScreenState();
}

class _TodayAttendanceScreenState extends State<TodayAttendanceScreen> {
  late final AttendanceRepository _attendanceRepo;
  late final SessionRepository _sessionRepo;
  late final EnrollmentRepository _enrollmentRepo;
  late final StudentRepository _studentRepo;
  List<AttendanceData> _attendances = [];
  List<Session> _activeSessions = [];
  Map<String, List<AttendanceData>> _attendanceBySession = {};
  Map<String, List<Enrollment>> _enrollmentsByGroup = {};
  Map<String, Student> _studentCache = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _attendanceRepo = AttendanceRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _enrollmentRepo = EnrollmentRepository(widget.database);
    _studentRepo = StudentRepository(widget.database);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    _attendances = await _attendanceRepo.getTodayAttendance();
    _activeSessions = await _sessionRepo.getActiveAtTime(now);

    _attendanceBySession = {};
    for (final a in _attendances) {
      _attendanceBySession.putIfAbsent(a.sessionId, () => []).add(a);
    }

    _enrollmentsByGroup = {};
    _studentCache = {};
    for (final s in _activeSessions) {
      final enrollments = await _enrollmentRepo.getBySubjectGroup(s.subjectGroupId);
      _enrollmentsByGroup[s.id] = enrollments;
      for (final e in enrollments) {
        if (!_studentCache.containsKey(e.studentId)) {
          final student = await _studentRepo.getById(e.studentId);
          if (student != null) {
            _studentCache[e.studentId] = student;
          }
        }
      }
    }

    setState(() => _loading = false);
  }

  String _studentName(String studentId) {
    final s = _studentCache[studentId];
    if (s == null) return studentId;
    return '${s.firstNameAr} ${s.lastNameAr}';
  }

  String _formatTime(DateTime t) {
    return '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
  }

  String _sessionLabel(Session s) {
    final days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[s.dayOfWeek]} ${_formatTime(s.startTime)}-${_formatTime(s.endTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activeSessions.isEmpty
              ? Center(child: Text(l10n.noActiveSessions))
              : _attendances.isEmpty
                  ? Center(child: Text(l10n.noAttendanceToday))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _activeSessions.length,
                      itemBuilder: (_, i) {
                        final session = _activeSessions[i];
                        final attendances =
                            _attendanceBySession[session.id] ?? [];
                        final enrollments =
                            _enrollmentsByGroup[session.id] ?? [];
                        final presentIds = attendances
                            .map((a) => a.studentId)
                            .whereType<String>()
                            .toSet();
                        final expectedIds = enrollments
                            .where((e) => e.status == 'active')
                            .map((e) => e.studentId)
                            .toList();
                        final missingIds = expectedIds
                            .where((id) => !presentIds.contains(id))
                            .toList();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            initiallyExpanded: i == 0,
                            title: Text(
                              session.id,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${_sessionLabel(session)}  |  '
                              '${l10n.presentCount}: ${presentIds.length}  '
                              '${l10n.absentCount}: ${missingIds.length}',
                            ),
                            children: [
                              if (attendances.isNotEmpty) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '${l10n.checkedIn} (${attendances.length})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                ...attendances.map(
                                  (a) => ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20),
                                    title: Text(
                                        _studentName(a.studentId ?? '')),
                                    trailing: Text(
                                      _formatTime(a.checkInTime),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                              if (missingIds.isNotEmpty) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '${l10n.missing} (${missingIds.length})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ...missingIds.take(10).map(
                                      (id) => ListTile(
                                        dense: true,
                                        leading: const Icon(Icons.cancel,
                                            color: Colors.red, size: 20),
                                        title: Text(_studentName(id)),
                                      ),
                                    ),
                                if (missingIds.length > 10)
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      '... ${missingIds.length - 10} ${l10n.noData}',
                                      style: const TextStyle(
                                          color: Colors.grey),
                                    ),
                                  ),
                              ],
                              if (attendances.isEmpty && missingIds.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(l10n.noData),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
