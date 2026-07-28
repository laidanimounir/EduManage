import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/chart_tokens.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/audit_log_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/shell_dialog.dart';

class LiveAttendanceBoard extends StatefulWidget {
  final AppDatabase database;
  final String? currentUserId;
  const LiveAttendanceBoard({super.key, required this.database, this.currentUserId});
  @override
  State<LiveAttendanceBoard> createState() => _LiveAttendanceBoardState();
}

class _LiveAttendanceBoardState extends State<LiveAttendanceBoard> {
  late final StudentRepository _studentRepo;
  late final TeacherRepository _teacherRepo;
  late final SessionRepository _sessionRepo;
  late final AttendanceRepository _attendanceRepo;
  late final TransactionService _txService;
  late final AuditLogRepository _auditRepo;

  final _barcodeCtrl = TextEditingController();
  final _focusNode = FocusNode();
  String _mode = 'student';
  bool _processing = false;
  String? _feedbackMsg;
  Color? _feedbackColor;
  String? _lastStudentName;
  String? _lastStudentPhoto;
  Timer? _feedbackTimer;

  List<Map<String, dynamic>> _liveSessions = [];
  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> _completedSessions = [];
  Map<String, int> _liveCounts = {};
  bool _loading = true;
  String? _error;

  final List<Map<String, String>> _lastCheckedIn = [];
  Timer? _refreshTimer;

  String _classroomFilter = 'all';
  List<Map<String, dynamic>> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _teacherRepo = TeacherRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _attendanceRepo = AttendanceRepository(widget.database);
    _txService = TransactionService(widget.database);
    _auditRepo = AuditLogRepository(widget.database);
    _loadFullData();
    _startLiveRefresh();
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _focusNode.dispose();
    _refreshTimer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _startLiveRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refreshLiveCounts());
  }

  Future<void> _refreshLiveCounts() async {
    if (!mounted) return;
    try {
      final counts = await widget.database.getLiveAttendanceCounts();
      if (mounted) setState(() => _liveCounts = counts);
    } catch (_) {}
  }

  Future<void> _loadFullData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final sessions = await widget.database.getTodaySessionsWithAttendance();
      final now = DateTime.now();
      final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

      final live = <Map<String, dynamic>>[];
      final upcoming = <Map<String, dynamic>>[];
      final completed = <Map<String, dynamic>>[];

      for (final s in sessions) {
        final start = s['start_time'] as DateTime;
        final end = s['end_time'] as DateTime;
        final startH = start.hour;
        final startM = start.minute;
        final endH = end.hour;
        final endM = end.minute;

        final startTod = TimeOfDay(hour: startH, minute: startM);
        final endTod = TimeOfDay(hour: endH, minute: endM);

        if (nowTime.hour > endH || (nowTime.hour == endH && nowTime.minute >= endM)) {
          completed.add(s);
        } else if (nowTime.hour > startH || (nowTime.hour == startH && nowTime.minute >= startM)) {
          live.add(s);
        } else {
          upcoming.add(s);
        }
      }

      final counts = <String, int>{};
      for (final s in live) {
        counts[s['id'] as String] = s['checked_in'] as int;
      }
      _liveCounts = counts;

      _classrooms = await widget.database.getClassroomUtilization();

      if (mounted) setState(() {
        _liveSessions = live;
        _upcomingSessions = upcoming;
        _completedSessions = completed;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load board'; });
    }
  }

  void _showFeedback(String msg, Color color) {
    _feedbackTimer?.cancel();
    setState(() { _feedbackMsg = msg; _feedbackColor = color; });
    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() { _feedbackMsg = null; _feedbackColor = null; });
    });
  }

  Future<void> _processBarcode(String code) async {
    if (_processing) return;
    setState(() => _processing = true);
    try {
      if (_mode == 'student') {
        await _processStudent(code);
      } else {
        await _processTeacher(code);
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _processStudent(String code) async {
    final student = await _studentRepo.getByCode(code.trim());
    if (student == null) {
      _showFeedback('Student not found', SemanticTokens.error);
      _flashInputBar(SemanticTokens.error);
      return;
    }

    final now = DateTime.now();
    final sessions = await _sessionRepo.getActiveSessionsForStudent(student.id, now);

    if (sessions.isEmpty) {
      _showFeedback('No active session for ${student.firstNameAr}', SemanticTokens.warning);
      _flashInputBar(SemanticTokens.warning);
      return;
    }

    if (sessions.length > 1) {
      await _showSessionPicker(student, sessions);
      return;
    }

    await _completeStudentCheckin(student, sessions.first);
  }

  Future<void> _completeStudentCheckin(Student student, Session session) async {
    final date = DateTime.now();
    final duplicate = await _attendanceRepo.hasCheckedInToday(session.id, student.id, date);
    if (duplicate) {
      final existing = await widget.database.customSelect(
        'SELECT check_in_time FROM attendance WHERE session_id = ? AND student_id = ? AND attendance_date >= ? AND status = \'present\' ORDER BY check_in_time DESC LIMIT 1',
        variables: [Variable.withString(session.id), Variable.withString(student.id), Variable.withDateTime(DateTime(date.year, date.month, date.day))],
      ).getSingleOrNull();
      final time = existing != null ? '${existing.read<DateTime>('check_in_time').hour}:${existing.read<DateTime>('check_in_time').minute.toString().padLeft(2, '0')}' : '';
      _showFeedback('${student.firstNameAr} already checked in at $time', const Color(0xFFC2823A));
      _flashInputBar(const Color(0xFFC2823A));
      return;
    }

    final enrollments = await EnrollmentRepository(widget.database).getByStudent(student.id);
    final enrollment = enrollments.cast<Enrollment?>().firstWhere((e) => e?.subjectGroupId == session.subjectGroupId, orElse: () => null);

    await _attendanceRepo.create(AttendanceCompanion(
      studentId: Value(student.id), sessionId: Value(session.id),
      attendanceDate: Value(date), personType: const Value('student'),
      checkInMethod: const Value('barcode'), isManualEntry: const Value(false),
      checkedInByUserId: Value(widget.currentUserId),
    ));

    await _txService.createSessionCharge(
      studentId: student.id, sessionId: session.id,
      enrollmentId: enrollment?.id ?? '', createdByUserId: widget.currentUserId, date: date,
    );

    _lastCheckedIn.insert(0, {
      'name': '${student.firstNameAr} ${student.lastNameAr}',
      'time': '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
    });
    if (_lastCheckedIn.length > 5) _lastCheckedIn.removeLast();

    _showFeedback('${student.firstNameAr} ${student.lastNameAr} - Check-in success', SemanticTokens.success);
    _lastStudentName = '${student.firstNameAr} ${student.lastNameAr}';
    _lastStudentPhoto = student.photoPath;

    _liveCounts[session.id] = (_liveCounts[session.id] ?? 0) + 1;
    if (mounted) setState(() {});

    final delay = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() { _lastStudentName = null; _lastStudentPhoto = null; });
    });
    _feedbackTimer?.cancel();
    _feedbackTimer = delay;
  }

  Future<void> _processTeacher(String code) async {
    final teacher = await _teacherRepo.getByCode(code.trim());
    if (teacher == null) { _showFeedback('Teacher not found', SemanticTokens.error); _flashInputBar(SemanticTokens.error); return; }
    final now = DateTime.now();
    final sessions = await _sessionRepo.getActiveSessionsForTeacher(teacher.id, now);
    if (sessions.isEmpty) { _showFeedback('No active session for teacher', SemanticTokens.warning); return; }
    try {
      final date = DateTime.now();
      final existing = await widget.database.customSelect(
        'SELECT id FROM attendance WHERE session_id = ? AND teacher_id = ? AND attendance_date >= ? AND attendance_date < ? AND status = \'present\'',
        variables: [Variable.withString(sessions.first.id), Variable.withString(teacher.id), Variable.withDateTime(DateTime(date.year, date.month, date.day)), Variable.withDateTime(DateTime(date.year, date.month, date.day + 1))],
      ).getSingleOrNull();
      if (existing != null) { _showFeedback('${teacher.firstNameAr} already checked in', const Color(0xFFC2823A)); return; }
      await _attendanceRepo.create(AttendanceCompanion(
        teacherId: Value(teacher.id), sessionId: Value(sessions.first.id),
        attendanceDate: Value(date), personType: const Value('teacher'),
        checkInMethod: const Value('barcode'), isManualEntry: const Value(false),
        checkedInByUserId: Value(widget.currentUserId),
      ));
      await _txService.createTeacherPayout(teacherId: teacher.id, sessionId: sessions.first.id, date: date, createdByUserId: widget.currentUserId);
      _showFeedback('${teacher.firstNameAr} ${teacher.lastNameAr} - Teacher check-in success', SemanticTokens.success);
    } catch (e) {
      _showFeedback('Check-in failed: $e', SemanticTokens.error);
    }
  }

  Future<void> _showSessionPicker(Student student, List<Session> sessions) async {
    final groupRepo = SubjectGroupRepository(widget.database);
    final teacherRepo = TeacherRepository(widget.database);
    final enriched = <Map<String, String>>[];
    for (final s in sessions) {
      final g = await groupRepo.getById(s.subjectGroupId);
      final t = await teacherRepo.getById(s.teacherId);
      enriched.add({
        'sessionId': s.id,
        'groupName': g?.nameAr ?? s.subjectGroupId,
        'teacherName': t != null ? '${t.firstNameAr} ${t.lastNameAr}' : s.teacherId,
        'time': '${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}-${s.endTime.hour}:${s.endTime.minute.toString().padLeft(2, '0')}',
      });
    }
    if (!mounted) return;
    final picked = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 400, title: 'Select Session',
        body: Column(mainAxisSize: MainAxisSize.min, children: enriched.map((e) => ListTile(
          title: Text(e['groupName']!, style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
          subtitle: Text('${e['teacherName']} \u00b7 ${e['time']}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
          onTap: () => Navigator.pop(ctx, e),
        )).toList()),
      ),
    );
    if (picked != null && mounted) {
      final session = sessions.firstWhere((s) => s.id == picked['sessionId']);
      await _completeStudentCheckin(student, session);
    }
  }

  Future<void> _manualSearch() async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    final result = await showDialog<Student>(
      context: context,
      builder: (ctx) => ShellDialog(
        maxWidth: 400, title: l10n.selectStudent,
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: ctrl, autofocus: true,
            decoration: const InputDecoration(hintText: 'Code or Name'),
            onSubmitted: (q) async {
              final students = await _studentRepo.search(q);
              if (students.isEmpty) {
                if (ctx.mounted) Navigator.pop(ctx);
                return;
              }
              if (students.length == 1) {
                if (ctx.mounted) Navigator.pop(ctx, students.first);
                return;
              }
              final picked = await showDialog<Student>(
                context: ctx,
                builder: (c2) => ShellDialog(
                  maxWidth: 350, title: 'Select Student',
                  body: Column(mainAxisSize: MainAxisSize.min, children: students.map((s) => ListTile(
                    title: Text('${s.firstNameAr} ${s.lastNameAr}', style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary)),
                    subtitle: Text(s.code, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
                    onTap: () => Navigator.pop(c2, s),
                  )).toList()),
                ),
              );
              if (picked != null && ctx.mounted) Navigator.pop(ctx, picked);
            },
          ),
        ]),
      ),
    );
    ctrl.dispose();
    if (result != null && mounted) {
      final sessions = await _sessionRepo.getActiveSessionsForStudent(result.id, DateTime.now());
      if (sessions.isEmpty) { _showFeedback('No active session', SemanticTokens.warning); return; }
      if (sessions.length > 1) {
        await _showSessionPicker(result, sessions);
      } else {
        await _completeStudentCheckin(result, sessions.first);
      }
    }
  }

  void _flashInputBar(Color color) {
    if (mounted) setState(() => _feedbackColor = color);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _feedbackColor = null);
    });
  }

  void _openRoster(Map<String, dynamic> session) async {
    final date = DateTime.now();
    final roster = await widget.database.getSessionRoster(session['id'] as String, date);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => _SessionRosterDialog(
        database: widget.database,
        session: session,
        roster: roster,
        currentUserId: widget.currentUserId,
        onChanged: () {
          _loadFullData();
          _refreshLiveCounts();
        },
      ),
    );
  }

  String _timeLabel(dynamic start, dynamic end) {
    final s = start is DateTime ? start : DateTime.now();
    final e = end is DateTime ? end : DateTime.now();
    return '${s.hour}:${s.minute.toString().padLeft(2, '0')} \u2014 ${e.hour}:${e.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: _loading
          ? const AppLoading()
          : _error != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(PhosphorIcons.warning, size: 32, color: SemanticTokens.warning),
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: ShellTokens.textSecondary)),
                  const SizedBox(height: 12),
                  TextButton(onPressed: _loadFullData, child: const Text('Retry')),
                ]))
              : Column(children: [
                  _buildStickyTopBar(),
                  Expanded(child: RefreshIndicator(onRefresh: _loadFullData, child: _buildBoard())),
                ]),
    );
  }

  Widget _buildStickyTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: _feedbackColor != null ? _feedbackColor!.withValues(alpha: 0.15) : ShellTokens.chromeSurface,
        border: const Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                controller: _barcodeCtrl,
                focusNode: _focusNode,
                autofocus: true,
                style: const TextStyle(fontSize: 14, color: ShellTokens.textPrimary),
                decoration: InputDecoration(
                  hintText: _mode == 'student' ? 'Scan barcode or student code...' : 'Scan teacher barcode...',
                  hintStyle: const TextStyle(fontSize: 12, color: ShellTokens.textDisabled),
                  prefixIcon: const Icon(PhosphorIcons.identificationCard, size: 18, color: ShellTokens.textSecondary),
                  suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(PhosphorIcons.magnifyingGlass, size: 16, color: ShellTokens.textSecondary), onPressed: _manualSearch, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                    IconButton(icon: Icon(_mode == 'student' ? PhosphorIcons.users : PhosphorIcons.chalkboardTeacher, size: 16, color: ShellTokens.accent), onPressed: () => setState(() => _mode = _mode == 'student' ? 'teacher' : 'student'), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Switch mode'),
                  ]),
                  filled: true,
                  fillColor: ShellTokens.chromeBase,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _feedbackColor ?? ShellTokens.chromeBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _feedbackColor ?? ShellTokens.chromeBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _feedbackColor ?? ShellTokens.accent)),
                ),
                onSubmitted: (v) { _processBarcode(v); _barcodeCtrl.clear(); },
              ),
            ),
          ),
        ]),
        if (_feedbackMsg != null) ...[
          const SizedBox(height: 4),
          Text(_feedbackMsg!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _feedbackColor ?? ShellTokens.textPrimary)),
        ],
        if (_lastStudentName != null) ...[
          const SizedBox(height: 4),
          Row(children: [
            if (_lastStudentPhoto != null && _lastStudentPhoto!.isNotEmpty)
              ClipOval(child: Image.file(File(_lastStudentPhoto!), width: 32, height: 32, fit: BoxFit.cover))
            else
              const Icon(PhosphorIcons.checkCircle, size: 22, color: SemanticTokens.success),
            const SizedBox(width: 8),
            Text(_lastStudentName!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: SemanticTokens.success)),
          ]),
        ],
        if (_lastCheckedIn.isNotEmpty) ...[
          const SizedBox(height: 4),
          SizedBox(
            height: 24,
            child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _lastCheckedIn.length, itemBuilder: (_, i) {
              final l = _lastCheckedIn[i];
              return Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: SemanticTokens.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text('${l['name']} \u00b7 ${l['time']}', style: const TextStyle(fontSize: 10, color: SemanticTokens.success)),
              );
            }),
          ),
        ],
      ]),
    );
  }

  Widget _buildBoard() {
    final filteredLive = _classroomFilter == 'all' ? _liveSessions : _liveSessions.where((s) => s['classroom_id'] == _classroomFilter).toList();
    final filteredUpcoming = _classroomFilter == 'all' ? _upcomingSessions : _upcomingSessions.where((s) => s['classroom_id'] == _classroomFilter).toList();
    final filteredCompleted = _classroomFilter == 'all' ? _completedSessions : _completedSessions.where((s) => s['classroom_id'] == _classroomFilter).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_classrooms.length > 1) ...[
          SizedBox(
            height: 30,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _buildFilterChip('All', _classroomFilter == 'all', () => setState(() => _classroomFilter = 'all')),
              ..._classrooms.map((c) => _buildFilterChip(c['name'] as String, _classroomFilter == c['id'] as String, () => setState(() => _classroomFilter = c['id'] as String))),
            ]),
          ),
          const SizedBox(height: 8),
        ],

        if (filteredLive.isNotEmpty) ...[
          _sectionHeader('LIVE NOW', SemanticTokens.success),
          const SizedBox(height: 6),
          ...filteredLive.map((s) => _sessionCard(s, true)),
          const SizedBox(height: 10),
        ],

        if (filteredUpcoming.isNotEmpty) ...[
          _sectionHeader('UPCOMING TODAY', ShellTokens.accent),
          const SizedBox(height: 6),
          ...filteredUpcoming.map((s) => _sessionCard(s, false)),
          const SizedBox(height: 10),
        ],

        if (filteredCompleted.isNotEmpty) ...[
          _sectionHeader('COMPLETED TODAY', ShellTokens.textDisabled),
          const SizedBox(height: 6),
          ...filteredCompleted.map((s) => _sessionCardCompleted(s)),
          const SizedBox(height: 10),
        ],

        if (_liveSessions.isEmpty && _upcomingSessions.isEmpty && _completedSessions.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No sessions scheduled today', style: TextStyle(fontSize: 13, color: ShellTokens.textDisabled)))),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary))),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
    ]);
  }

  Widget _sessionCard(Map<String, dynamic> s, bool isLive) {
    final checkedIn = isLive ? (_liveCounts[s['id']] ?? s['checked_in'] ?? 0) : (s['checked_in'] ?? 0);
    final total = s['total_enrolled'] ?? 0;
    final pct = total > 0 ? checkedIn / total : 0.0;
    final isEndingSoon = isLive && _minutesUntilEnd(s['end_time'] as DateTime) <= 10;

    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(isLive ? PhosphorIcons.clock : PhosphorIcons.calendar, size: 14, color: isLive ? SemanticTokens.success : ShellTokens.accent),
            const SizedBox(width: 6),
            Expanded(child: Text(s['group_name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: (isLive ? SemanticTokens.success : ShellTokens.accent).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: Text(isLive ? 'LIVE' : 'Upcoming', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: isLive ? SemanticTokens.success : ShellTokens.accent)),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(PhosphorIcons.chalkboardTeacher, size: 12, color: ShellTokens.textSecondary),
            const SizedBox(width: 4),
            Text('${s['first_name_ar'] ?? ''} ${s['last_name_ar'] ?? ''}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
            const SizedBox(width: 12),
            const Icon(PhosphorIcons.building, size: 12, color: ShellTokens.textDisabled),
            const SizedBox(width: 4),
            Text(s['classroom_name'] ?? '', style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: pct, minHeight: 6, backgroundColor: ShellTokens.chromeBorder, color: pct > 0.5 ? SemanticTokens.success : SemanticTokens.warning),
            )),
            const SizedBox(width: 8),
            Text('$checkedIn/$total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: pct > 0 ? ShellTokens.textPrimary : ShellTokens.textDisabled)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Text(_timeLabel(s['start_time'], s['end_time']), style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
            if (isEndingSoon) ...[
              const SizedBox(width: 8),
              const Icon(PhosphorIcons.warning, size: 10, color: SemanticTokens.warning),
              const SizedBox(width: 2),
              const Text('Ending soon', style: TextStyle(fontSize: 9, color: SemanticTokens.warning, fontWeight: FontWeight.w600)),
            ],
            const Spacer(),
            TextButton.icon(
              onPressed: () => _openRoster(s),
              icon: const Icon(PhosphorIcons.usersThree, size: 12),
              label: const Text('View Roster', style: TextStyle(fontSize: 10)),
              style: TextButton.styleFrom(foregroundColor: ShellTokens.accent, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _sessionCardCompleted(Map<String, dynamic> s) {
    final checkedIn = s['checked_in'] ?? 0;
    final total = s['total_enrolled'] ?? 0;
    final absent = total - checkedIn;

    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(PhosphorIcons.checkCircle, size: 14, color: ShellTokens.textDisabled),
            const SizedBox(width: 6),
            Expanded(child: Text(s['group_name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary))),
            Text('${_timeLabel(s['start_time'], s['end_time'])}', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Text('$checkedIn present', style: const TextStyle(fontSize: 11, color: SemanticTokens.success, fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            Text('$absent absent', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: absent > 0 ? SemanticTokens.error : ShellTokens.textDisabled)),
          ]),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () => _openRoster(s),
            icon: const Icon(PhosphorIcons.usersThree, size: 12),
            label: const Text('View Report', style: TextStyle(fontSize: 10)),
            style: TextButton.styleFrom(foregroundColor: ShellTokens.accent, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero),
          ),
        ]),
      ),
    );
  }

  int _minutesUntilEnd(DateTime end) {
    final now = DateTime.now();
    final endToday = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    return endToday.difference(now).inMinutes;
  }
}

class _SessionRosterDialog extends StatefulWidget {
  final AppDatabase database;
  final Map<String, dynamic> session;
  final List<Map<String, dynamic>> roster;
  final String? currentUserId;
  final VoidCallback? onChanged;
  const _SessionRosterDialog({required this.database, required this.session, required this.roster, this.currentUserId, this.onChanged});
  @override
  State<_SessionRosterDialog> createState() => _SessionRosterDialogState();
}

class _SessionRosterDialogState extends State<_SessionRosterDialog> {
  @override
  Widget build(BuildContext context) {
    return ShellDialog(
      maxWidth: 700, maxHeight: 700,
      title: widget.session['group_name'] ?? 'Session Roster',
      body: const Center(child: Text('Roster placeholder — full implementation pending')),
    );
  }
}
