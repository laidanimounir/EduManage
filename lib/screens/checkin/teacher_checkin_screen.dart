import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/transaction_service.dart';
import 'package:drift/drift.dart' hide Column;

class TeacherCheckinScreen extends StatefulWidget {
  final AppDatabase database;
  final String? currentUserId;
  const TeacherCheckinScreen({super.key, required this.database, this.currentUserId});
  @override
  State<TeacherCheckinScreen> createState() => _TeacherCheckinScreenState();
}

class _TeacherCheckinScreenState extends State<TeacherCheckinScreen> {
  late final TeacherRepository _teacherRepo;
  late final SessionRepository _sessionRepo;
  late final AttendanceRepository _attendanceRepo;
  late final TransactionService _txService;
  final _barcodeCtrl = TextEditingController();
  String _feedbackMessage = '';
  Color _feedbackColor = Colors.grey;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _teacherRepo = TeacherRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _attendanceRepo = AttendanceRepository(widget.database);
    _txService = TransactionService(widget.database);
  }

  Future<void> _processBarcode(String code) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _processing = true);
    try {
      final teacher = await _teacherRepo.getByCode(code.trim());
      if (teacher == null) {
        _showFeedback(l10n.teacherNotFound, Colors.red);
        return;
      }
      final now = DateTime.now();
      final sessions = await _sessionRepo.getActiveSessionsForTeacher(teacher.id, now);

      if (sessions.isEmpty) {
        _showFeedback(l10n.noActiveSessionForTeacher, Colors.orange);
        return;
      }

      await _completeCheckin(teacher, sessions.first);
    } catch (e) {
      _showFeedback('${l10n.checkInFailed}: $e', Colors.red);
    } finally {
      setState(() => _processing = false);
    }
  }

  Future<void> _completeCheckin(Teacher teacher, Session session) async {
    final l10n = AppLocalizations.of(context);
    try {
      final date = DateTime.now();
      final duplicate = await _hasTeacherCheckedInToday(session.id, teacher.id, date);
      if (duplicate) {
        _showFeedback(l10n.teacherAlreadyCheckedIn, Colors.orange);
        return;
      }

      await _attendanceRepo.create(AttendanceCompanion(
        teacherId: Value(teacher.id),
        sessionId: Value(session.id),
        attendanceDate: Value(date),
        personType: const Value('teacher'),
        checkInMethod: const Value('barcode'),
        isManualEntry: const Value(false),
        checkedInByUserId: Value(widget.currentUserId),
      ));

      await _txService.createTeacherPayout(
        teacherId: teacher.id,
        sessionId: session.id,
        date: date,
        createdByUserId: widget.currentUserId,
      );

      _showFeedback(
        '${teacher.firstNameAr} ${teacher.lastNameAr} - ${l10n.teacherCheckinSuccess}',
        Colors.green,
      );
    } catch (e) {
      _showFeedback('${l10n.checkInFailed}: $e', Colors.red);
    }
  }

  Future<bool> _hasTeacherCheckedInToday(
      String sessionId, String teacherId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final result = await (widget.database.select(widget.database.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.teacherId.equals(teacherId) &
          t.attendanceDate.isBiggerOrEqualValue(dateStart) &
          t.attendanceDate.isSmallerThanValue(dateEnd)))
        .get();
    return result.isNotEmpty;
  }

  void _showFeedback(String msg, Color color) {
    setState(() {
      _feedbackMessage = msg;
      _feedbackColor = color;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _feedbackMessage = '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: _feedbackColor.withValues(alpha: 0.1),
            child: Column(
              children: [
                TextField(
                  controller: _barcodeCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.scanTeacherBarcode,
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (v) {
                    _processBarcode(v);
                    _barcodeCtrl.clear();
                  },
                ),
                const SizedBox(height: 16),
                if (_feedbackMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _feedbackColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _feedbackMessage,
                      style: TextStyle(
                        color: _feedbackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_processing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
