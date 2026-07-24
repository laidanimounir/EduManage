import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/audit_log_repository.dart';
import 'package:drift/drift.dart' hide Column;

class CheckinScreen extends StatefulWidget {
  final AppDatabase database;
  final String? currentUserId;
  const CheckinScreen({super.key, required this.database, this.currentUserId});
  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  late final StudentRepository _studentRepo;
  late final SessionRepository _sessionRepo;
  late final AttendanceRepository _attendanceRepo;
  late final TransactionService _txService;
  late final AuditLogRepository _auditRepo;
  final _barcodeCtrl = TextEditingController();
  String _feedbackMessage = '';
  Color _feedbackColor = Colors.grey;
  bool _processing = false;
  List<Session> _ambiguousSessions = [];
  Student? _scannedStudent;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _attendanceRepo = AttendanceRepository(widget.database);
    _txService = TransactionService(widget.database);
    _auditRepo = AuditLogRepository(widget.database);
  }

  Future<void> _processBarcode(String code) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _processing = true);
    try {
      final student = await _studentRepo.getByCode(code.trim());
      if (student == null) {
        _showFeedback(l10n.studentNotFound, Colors.red); return;
      }
      _scannedStudent = student;
      final now = DateTime.now();
      final sessions = await _sessionRepo.getActiveSessionsForStudent(student.id, now);

      if (sessions.isEmpty) {
        _showFeedback(l10n.noActiveSession, Colors.orange); return;
      }
      if (sessions.length > 1) {
        setState(() { _ambiguousSessions = sessions; _feedbackMessage = l10n.multipleSessionsFound; _feedbackColor = Colors.orange; });
        return;
      }
      await _completeCheckin(student, sessions.first, 'barcode');
    } catch (e) {
      _showFeedback('${l10n.checkInFailed}: $e', Colors.red);
    } finally {
      setState(() => _processing = false);
    }
  }

  Future<void> _completeCheckin(Student student, Session session, String method, {bool isManual = false}) async {
    final l10n = AppLocalizations.of(context);
    try {
      final date = DateTime.now();
      final duplicate = await _attendanceRepo.hasCheckedInToday(session.id, student.id, date);
      if (duplicate) { _showFeedback(l10n.alreadyCheckedIn, Colors.orange); return; }

      final enrollments = await EnrollmentRepository(widget.database).getByStudent(student.id);
      final enrollment = enrollments.cast<Enrollment?>().firstWhere((e) => e?.subjectGroupId == session.subjectGroupId, orElse: () => null);

      await _attendanceRepo.create(AttendanceCompanion(
        studentId: Value(student.id), sessionId: Value(session.id),
        attendanceDate: Value(date), personType: const Value('student'),
        checkInMethod: Value(method), isManualEntry: Value(isManual),
        checkedInByUserId: Value(isManual ? widget.currentUserId : null),
      ));

      await _txService.createSessionCharge(
        studentId: student.id, sessionId: session.id,
        enrollmentId: enrollment?.id ?? '', createdByUserId: widget.currentUserId, date: date,
      );

      if (isManual) {
        await _auditRepo.create(AuditLogCompanion(
          userId: Value(widget.currentUserId ?? 'system'),
          action: const Value('manual_checkin'),
          entityType: const Value('attendance'),
          details: Value('Student: ${student.code}, Session: ${session.id}'),
        ));
      }

      _showFeedback('${student.firstNameAr} ${student.lastNameAr} - ${l10n.checkInSuccess}', Colors.green);
      _ambiguousSessions = []; _scannedStudent = null;
    } catch (e) {
      _showFeedback('${l10n.checkInFailed}: $e', Colors.red);
    }
  }

  Future<void> _manualSearch(String query) async {
    final l10n = AppLocalizations.of(context);
    final students = await _studentRepo.search(query);
    if (students.isEmpty) { _showFeedback(l10n.studentNotFound, Colors.red); return; }
    if (students.length == 1) {
      _scannedStudent = students.first;
      final sessions = await _sessionRepo.getActiveSessionsForStudent(_scannedStudent!.id, DateTime.now());
      if (sessions.isEmpty) { _showFeedback(l10n.noActiveSession, Colors.orange); return; }
      setState(() { _ambiguousSessions = sessions; _feedbackMessage = l10n.selectSession; _feedbackColor = Colors.blue; });
    } else {
      final selected = await showDialog<Student>(context: context, builder: (ctx) => AlertDialog(
        title: Text(l10n.selectSession),
        content: SizedBox(width: 300, child: ListView.builder(shrinkWrap: true, itemCount: students.length, itemBuilder: (_, i) => ListTile(
          title: Text('${students[i].firstNameAr} ${students[i].lastNameAr}'),
          subtitle: Text(students[i].code),
          onTap: () => Navigator.pop(ctx, students[i]),
        ))),
      ));
      if (selected != null) {
        _scannedStudent = selected;
        final sessions = await _sessionRepo.getActiveSessionsForStudent(_scannedStudent!.id, DateTime.now());
        if (sessions.isEmpty) { _showFeedback(l10n.noActiveSession, Colors.orange); return; }
        setState(() { _ambiguousSessions = sessions; _feedbackMessage = l10n.selectSession; _feedbackColor = Colors.blue; });
      }
    }
  }

  void _showFeedback(String msg, Color color) { setState(() { _feedbackMessage = msg; _feedbackColor = color; }); Future.delayed(const Duration(seconds: 5), () { if (mounted) setState(() => _feedbackMessage = ''); }); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkIn)),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: _feedbackColor.withValues(alpha: 0.1),
          child: Column(children: [
            TextField(
              controller: _barcodeCtrl,
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.scanBarcode, prefixIcon: const Icon(Icons.qr_code_scanner), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), filled: true, fillColor: Colors.white),
              onSubmitted: (v) { _processBarcode(v); _barcodeCtrl.clear(); },
            ),
            const SizedBox(height: 16),
            if (_feedbackMessage.isNotEmpty)
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: _feedbackColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: Text(_feedbackMessage, style: TextStyle(color: _feedbackColor, fontSize: 16, fontWeight: FontWeight.bold))),
            if (_ambiguousSessions.isNotEmpty && _scannedStudent != null) ...[
              const SizedBox(height: 12),
              Text(l10n.selectSession, style: const TextStyle(fontWeight: FontWeight.bold)),
              ..._ambiguousSessions.map((s) => ListTile(
                title: Text('${s.id}'), subtitle: Text('${s.startTime.hour}:${s.startTime.minute} - ${s.endTime.hour}:${s.endTime.minute}'),
                onTap: () => _completeCheckin(_scannedStudent!, s, 'barcode'),
              )),
            ],
          ]),
        ),
        Padding(padding: const EdgeInsets.all(16), child: TextField(
          decoration: InputDecoration(hintText: l10n.searchStudent, prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          onSubmitted: _manualSearch,
        )),
        if (_processing) const Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}
