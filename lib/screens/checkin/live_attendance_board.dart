import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../database/app_database.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/enrollment_repository.dart';
import '../../repositories/transaction_service.dart';
import '../../repositories/subject_group_repository.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/shell_dialog.dart';
import 'teacher_self_service_screen.dart';

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
  final _barcodeCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _processing = false;

  final _teacherSearchCtrl = TextEditingController();
  Timer? _teacherDebounce;
  List<Teacher> _teacherResults = [];
  int? _teacherCount;

  final _studentSearchCtrl = TextEditingController();
  Timer? _studentDebounce;
  List<Student> _studentResults = [];
  bool _showingStudentSearch = false;
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

  String _viewMode = 'time';
  List<Map<String, dynamic>> _roomGridData = [];
  int? _roomFloorFilter;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _teacherRepo = TeacherRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _attendanceRepo = AttendanceRepository(widget.database);
    _txService = TransactionService(widget.database);
    _loadFullData();
    _startLiveRefresh();
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _focusNode.dispose();
    _teacherSearchCtrl.dispose();
    _teacherDebounce?.cancel();
    _studentSearchCtrl.dispose();
    _studentDebounce?.cancel();
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
      if (!mounted) return;
      _liveCounts = counts;
      _reclassifySessions();
      if (_viewMode == 'room') {
        final roomRows = await widget.database.getTodayRoomGrid();
        if (mounted) _roomGridData = roomRows;
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _reclassifySessions() {
    final now = DateTime.now();
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final allSessions = [..._liveSessions, ..._upcomingSessions, ..._completedSessions];
    final live = <Map<String, dynamic>>[];
    final upcoming = <Map<String, dynamic>>[];
    final completed = <Map<String, dynamic>>[];
    for (final s in allSessions) {
      final start = s['start_time'] as DateTime;
      final end = s['end_time'] as DateTime;
      if (nowTime.hour > end.hour || (nowTime.hour == end.hour && nowTime.minute >= end.minute)) {
        completed.add(s);
      } else if (nowTime.hour > start.hour || (nowTime.hour == start.hour && nowTime.minute >= start.minute)) {
        live.add(s);
      } else {
        upcoming.add(s);
      }
    }
    _liveSessions = live;
    _upcomingSessions = upcoming;
    _completedSessions = completed;
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

        if (nowTime.hour > end.hour || (nowTime.hour == end.hour && nowTime.minute >= end.minute)) {
          completed.add(s);
        } else if (nowTime.hour > start.hour || (nowTime.hour == start.hour && nowTime.minute >= start.minute)) {
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

      try {
        _classrooms = await widget.database.getClassroomUtilization();
      } catch (_) {
        _classrooms = [];
      }

      if (mounted) setState(() {
        _liveSessions = live;
        _upcomingSessions = upcoming;
        _completedSessions = completed;
        _loading = false;
      });

      final roomRows = await widget.database.getTodayRoomGrid();
      if (mounted) setState(() => _roomGridData = roomRows);

      final tc = await widget.database.getTodayTeacherCheckinCount();
      if (mounted) setState(() => _teacherCount = tc);
    } catch (e, st) {
      if (mounted) setState(() {
        _loading = false;
        _error = 'Failed to load board: $e';
        debugPrint('Dashboard load error: $e\n$st');
      });
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
      await _processStudent(code);
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

  Future<void> _processTeacherByName(Teacher teacher) async {
    final now = DateTime.now();
    final sessions = await _sessionRepo.getActiveSessionsForTeacher(teacher.id, now);
    if (sessions.isEmpty) {
      _showFeedback('No active session for ${teacher.firstNameAr}', SemanticTokens.warning);
      return;
    }
    try {
      final date = DateTime.now();
      final existing = await widget.database.customSelect(
        'SELECT id FROM attendance WHERE session_id = ? AND teacher_id = ? AND attendance_date >= ? AND attendance_date < ? AND status = \'present\'',
        variables: [Variable.withString(sessions.first.id), Variable.withString(teacher.id), Variable.withDateTime(DateTime(date.year, date.month, date.day)), Variable.withDateTime(DateTime(date.year, date.month, date.day + 1))],
      ).getSingleOrNull();
      if (existing != null) {
        _showFeedback('${teacher.firstNameAr} already checked in', const Color(0xFFC2823A));
        return;
      }
      await _attendanceRepo.create(AttendanceCompanion(
        teacherId: Value(teacher.id), sessionId: Value(sessions.first.id),
        attendanceDate: Value(date), personType: const Value('teacher'),
        checkInMethod: const Value('manual'), isManualEntry: const Value(true),
        checkedInByUserId: Value(widget.currentUserId),
      ));
      await _txService.createTeacherPayout(teacherId: teacher.id, sessionId: sessions.first.id, date: date, createdByUserId: widget.currentUserId);
      _showFeedback('${teacher.firstNameAr} ${teacher.lastNameAr} — Check-in success', SemanticTokens.success);
      _teacherCount = (_teacherCount ?? 0) + 1;
      if (mounted) setState(() {});
    } catch (e) {
      _showFeedback('Check-in failed: $e', SemanticTokens.error);
    }
  }

  void _onTeacherSearchChanged(String query) {
    _teacherDebounce?.cancel();
    _teacherDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.trim().isEmpty) {
        if (mounted) setState(() => _teacherResults = []);
        return;
      }
      final results = await _teacherRepo.search(query.trim());
      if (mounted) setState(() => _teacherResults = results);
    });
  }

  void _onStudentSearchChanged(String query) {
    _studentDebounce?.cancel();
    _studentDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.trim().isEmpty) {
        if (mounted) setState(() => _studentResults = []);
        return;
      }
      final results = await _studentRepo.search(query.trim());
      if (mounted) setState(() => _studentResults = results);
    });
  }

  Future<void> _studentSearchCheckin(Student student) async {
    _studentSearchCtrl.clear();
    setState(() { _studentResults = []; _showingStudentSearch = false; _focusNode.requestFocus(); });
    final sessions = await _sessionRepo.getActiveSessionsForStudent(student.id, DateTime.now());
    if (!mounted) return;
    if (sessions.isEmpty) {
      _showFeedback('No active session for ${student.firstNameAr}', SemanticTokens.warning);
      return;
    }
    if (sessions.length > 1) {
      await _showSessionPicker(student, sessions);
    } else {
      await _completeStudentCheckin(student, sessions.first);
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
                  if (_showingStudentSearch) _buildStudentSearchBar(),
                  _buildTeacherCheckinSection(),
                  _buildViewToggle(),
                  Expanded(child: RefreshIndicator(onRefresh: _loadFullData, child: _viewMode == 'time' ? _buildBoard() : _buildRoomGrid())),
                ]),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Row(children: [
        _viewTab('By time', 'time'),
        const SizedBox(width: 4),
        _viewTab('By room', 'room'),
      ]),
    );
  }

  Widget _viewTab(String label, String mode) {
    final active = _viewMode == mode;
    return Material(
      color: active ? ShellTokens.accentMuted : ShellTokens.chromeBase,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          if (_viewMode != mode) {
            setState(() => _viewMode = mode);
            if (mode == 'room') _refreshLiveCounts();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? ShellTokens.textPrimary : ShellTokens.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildRoomGrid() {
    final now = DateTime.now();
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

    final roomMap = <String, Map<String, dynamic>>{};
    for (final r in _roomGridData) {
      final rid = r['classroom_id'] as String;
      roomMap.putIfAbsent(rid, () => {
        'classroom_id': rid,
        'classroom_name': r['classroom_name'],
        'capacity': r['capacity'],
        'floor': r['floor'],
        'sessions': <Map<String, dynamic>>[],
      });
    }

    final studentRows = _roomGridData.where((r) => r['student_id'] != null).toList();
    for (final r in studentRows) {
      final rid = r['classroom_id'] as String;
      final sid = r['session_id'] as String?;
      if (sid == null) continue;
      final room = roomMap[rid]!;
      final sessions = room['sessions'] as List<Map<String, dynamic>>;
      var session = sessions.cast<Map<String, dynamic>?>().firstWhere((s) => s!['session_id'] == sid, orElse: () => null);
      if (session == null) {
        session = {
          'session_id': sid,
          'group_name': r['group_name'],
          'start_time': r['start_time'],
          'end_time': r['end_time'],
          'teacher_first': r['teacher_first'],
          'teacher_last': r['teacher_last'],
          'present': <Map<String, dynamic>>[],
          'absent': <Map<String, dynamic>>[],
        };
        sessions.add(session);
      }
      final student = {
        'student_id': r['student_id'],
        'stu_first': r['stu_first'],
        'stu_last': r['stu_last'],
        'code': r['code'],
        'photo_path': r['photo_path'],
        'att_status': r['att_status'],
        'check_in_time': r['check_in_time'],
      };
      if (r['att_status'] == 'present') {
        (session['present'] as List).add(student);
      } else {
        (session['absent'] as List).add(student);
      }
    }

    final floors = <int>{};
    for (final room in roomMap.values) {
      final f = room['floor'] as int?;
      if (f != null) floors.add(f);
    }

    var rooms = roomMap.values.toList();

    final sessionRows = _roomGridData.where((r) => r['session_id'] != null && r['student_id'] == null).toList();
    final seenSessions = <String>{};
    for (final r in sessionRows) {
      final sid = r['session_id'] as String;
      if (seenSessions.contains(sid)) continue;
      seenSessions.add(sid);
      final rid = r['classroom_id'] as String;
      final room = roomMap[rid]!;
      final sessions = room['sessions'] as List<Map<String, dynamic>>;
      if (!sessions.any((s) => s['session_id'] == sid)) {
        sessions.add({
          'session_id': sid,
          'group_name': r['group_name'],
          'start_time': r['start_time'],
          'end_time': r['end_time'],
          'teacher_first': r['teacher_first'],
          'teacher_last': r['teacher_last'],
          'present': <Map<String, dynamic>>[],
          'absent': <Map<String, dynamic>>[],
        });
      }
    }

    if (_roomFloorFilter != null) {
      rooms = rooms.where((r) => r['floor'] == _roomFloorFilter).toList();
    }

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        if (floors.length > 1) ...[
          SizedBox(
            height: 30,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _buildFloorChip('All floors', _roomFloorFilter == null, () => setState(() => _roomFloorFilter = null)),
              ...floors.map((f) => _buildFloorChip('Floor $f', _roomFloorFilter == f, () => setState(() => _roomFloorFilter = f))),
            ]),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: rooms.map((room) => _buildRoomCard(room, now, nowTime)).toList(),
        ),
        if (rooms.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No classrooms available', style: TextStyle(fontSize: 13, color: ShellTokens.textDisabled)))),
      ],
    );
  }

  Widget _buildFloorChip(String label, bool selected, VoidCallback onTap) {
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

  Widget _buildRoomCard(Map<String, dynamic> room, DateTime now, TimeOfDay nowTime) {
    final sessions = (room['sessions'] as List<Map<String, dynamic>>);
    Map<String, dynamic>? activeSession;
    Map<String, dynamic>? nextSession;

    for (final s in sessions) {
      final start = s['start_time'] as DateTime;
      final end = s['end_time'] as DateTime;
      final isLive = (nowTime.hour > start.hour || (nowTime.hour == start.hour && nowTime.minute >= start.minute)) &&
          !(nowTime.hour > end.hour || (nowTime.hour == end.hour && nowTime.minute >= end.minute));
      if (isLive) {
        activeSession = s;
        break;
      }
    }
    if (activeSession == null) {
      for (final s in sessions) {
        final start = s['start_time'] as DateTime;
        if (nowTime.hour < start.hour || (nowTime.hour == start.hour && nowTime.minute < start.minute)) {
          nextSession = s;
          break;
        }
      }
    }

    final present = (activeSession?['present'] as List?) ?? [];
    final absent = (activeSession?['absent'] as List?) ?? [];
    final total = present.length + absent.length;
    final pct = total > 0 ? present.length / total : 0.0;

    final sessionElapsed = activeSession != null
        ? (now.hour * 60 + now.minute) - ((activeSession['start_time'] as DateTime).hour * 60 + (activeSession['start_time'] as DateTime).minute)
        : 0;
    final sessionDuration = activeSession != null
        ? ((activeSession['end_time'] as DateTime).hour * 60 + (activeSession['end_time'] as DateTime).minute) - ((activeSession['start_time'] as DateTime).hour * 60 + (activeSession['start_time'] as DateTime).minute)
        : 0;
    final showAmber = activeSession != null && sessionDuration > 0 && sessionElapsed > sessionDuration / 2 && pct < 0.5;

    return Card(
      color: showAmber ? const Color(0xFFC2823A).withValues(alpha: 0.08) : ShellTokens.chromeSurface,
      child: Container(
        width: 280,
        constraints: const BoxConstraints(maxHeight: 320),
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Icon(PhosphorIcons.building, size: 14, color: ShellTokens.accent),
            const SizedBox(width: 6),
            Expanded(child: Text(room['classroom_name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ShellTokens.textPrimary))),
            if (room['capacity'] != null)
              Text('${room['capacity']}', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
          ]),
          const SizedBox(height: 4),
          if (activeSession != null) ...[
            Row(children: [
              const Icon(PhosphorIcons.clock, size: 11, color: SemanticTokens.success),
              const SizedBox(width: 4),
              Text(activeSession['group_name'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            ]),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(PhosphorIcons.chalkboardTeacher, size: 10, color: ShellTokens.textSecondary),
              const SizedBox(width: 3),
              Text('${activeSession['teacher_first'] ?? ''} ${activeSession['teacher_last'] ?? ''}', style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary)),
              const SizedBox(width: 8),
              Text('${present.length}/$total present', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: showAmber ? const Color(0xFFC2823A) : ShellTokens.textDisabled)),
            ]),
            const SizedBox(height: 2),
            Text(_timeLabel(activeSession['start_time'], activeSession['end_time']), style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
            const SizedBox(height: 6),
            _roomListSection('Present', present, SemanticTokens.success),
            _roomListSection('Absent', absent, SemanticTokens.error),
          ] else if (nextSession != null) ...[
            Row(children: [
              const Icon(PhosphorIcons.calendar, size: 11, color: ShellTokens.accent),
              const SizedBox(width: 4),
              Text(nextSession['group_name'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            ]),
            const SizedBox(height: 2),
            Text('Next at ${_timeLabel(nextSession['start_time'], nextSession['end_time'])}', style: const TextStyle(fontSize: 10, color: ShellTokens.accent)),
          ] else ...[
            const Row(children: [
              Icon(PhosphorIcons.info, size: 11, color: ShellTokens.textDisabled),
              SizedBox(width: 4),
              Text('No sessions today', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: ShellTokens.textDisabled)),
            ]),
          ],
        ]),
      ),
    );
  }

  Widget _roomListSection(String label, List list, Color color) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Icon(PhosphorIcons.checkCircle, size: 10, color: color),
          const SizedBox(width: 4),
          Text('$label (${list.length})', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ]),
        const SizedBox(height: 2),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (_, i) {
                final s = list[i];
                return Text(
                  '${label == 'Absent' ? '\u00B7 ' : ''}${s['stu_first'] ?? ''} ${s['stu_last'] ?? ''}',
                  style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
        ),
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
                  hintText: 'Scan barcode or student code...',
                  hintStyle: const TextStyle(fontSize: 12, color: ShellTokens.textDisabled),
                  prefixIcon: const Icon(PhosphorIcons.identificationCard, size: 18, color: ShellTokens.textSecondary),
                  suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: Icon(PhosphorIcons.magnifyingGlass, size: 16, color: _showingStudentSearch ? ShellTokens.accent : ShellTokens.textSecondary), onPressed: () => setState(() { _showingStudentSearch = !_showingStudentSearch; _studentResults = []; _studentSearchCtrl.clear(); if (!_showingStudentSearch) _focusNode.requestFocus(); }), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28)),
                    IconButton(icon: const Icon(PhosphorIcons.chalkboardTeacher, size: 16, color: ShellTokens.textSecondary), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherSelfServiceScreen(database: widget.database, currentUserId: widget.currentUserId))), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Teacher Self-Service'),
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

  Widget _buildStudentSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Column(children: [
        SizedBox(
          height: 34,
          child: TextField(
            controller: _studentSearchCtrl,
            autofocus: true,
            style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search student by name or code...',
              hintStyle: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled),
              prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 14, color: ShellTokens.textSecondary),
              suffixIcon: _studentResults.isNotEmpty
                  ? IconButton(icon: const Icon(PhosphorIcons.x, size: 14, color: ShellTokens.textSecondary), onPressed: () { _studentSearchCtrl.clear(); setState(() => _studentResults = []); }, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28))
                  : null,
              filled: true,
              fillColor: ShellTokens.chromeBase,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
              isDense: true,
            ),
            onChanged: _onStudentSearchChanged,
          ),
        ),
        if (_studentResults.isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(border: Border.all(color: ShellTokens.chromeBorder), borderRadius: BorderRadius.circular(6)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _studentResults.length,
              itemBuilder: (_, i) {
                final st = _studentResults[i];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(radius: 14, backgroundColor: ShellTokens.accentMuted, child: Text(st.firstNameAr[0], style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 10, fontWeight: FontWeight.w700))),
                  title: Text('${st.firstNameAr} ${st.lastNameAr}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ShellTokens.textPrimary)),
                  subtitle: Text(st.code, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
                  onTap: () => _studentSearchCheckin(st),
                );
              },
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildTeacherCheckinSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          title: Row(children: [
            const Icon(PhosphorIcons.chalkboardTeacher, size: 16, color: ShellTokens.accent),
            const SizedBox(width: 6),
            const Text('Teacher check-in', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
            if ((_teacherCount ?? 0) > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: ShellTokens.accentMuted, borderRadius: BorderRadius.circular(8)),
                child: Text('$_teacherCount', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ShellTokens.accent)),
              ),
            ],
          ]),
          children: [
            SizedBox(
              height: 34,
              child: TextField(
                controller: _teacherSearchCtrl,
                style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search teacher by name...',
                  hintStyle: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled),
                  prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 14, color: ShellTokens.textSecondary),
                  suffixIcon: _teacherResults.isNotEmpty
                      ? IconButton(icon: const Icon(PhosphorIcons.x, size: 14, color: ShellTokens.textSecondary), onPressed: () { _teacherSearchCtrl.clear(); setState(() => _teacherResults = []); }, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28))
                      : null,
                  filled: true,
                  fillColor: ShellTokens.chromeBase,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.chromeBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: ShellTokens.accent)),
                  isDense: true,
                ),
                onChanged: _onTeacherSearchChanged,
              ),
            ),
            if (_teacherResults.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                constraints: const BoxConstraints(maxHeight: 160),
                decoration: BoxDecoration(border: Border.all(color: ShellTokens.chromeBorder), borderRadius: BorderRadius.circular(6)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _teacherResults.length,
                  itemBuilder: (_, i) {
                    final t = _teacherResults[i];
                    return ListTile(
                      dense: true,
                      title: Text('${t.firstNameAr} ${t.lastNameAr}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ShellTokens.textPrimary)),
                      subtitle: Text(t.code, style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
                      onTap: () {
                        _teacherSearchCtrl.clear();
                        setState(() => _teacherResults = []);
                        _processTeacherByName(t);
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
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

        _sectionHeader('LIVE NOW', SemanticTokens.success),
        const SizedBox(height: 6),
        if (filteredLive.isNotEmpty)
          ...filteredLive.map((s) => _sessionCard(s, true))
        else
          _emptySectionCard('No sessions in progress right now', SemanticTokens.success),
        const SizedBox(height: 10),

        _sectionHeader('UPCOMING TODAY', ShellTokens.accent),
        const SizedBox(height: 6),
        if (filteredUpcoming.isNotEmpty)
          ...filteredUpcoming.map((s) => _sessionCard(s, false))
        else
          _emptySectionCard('No upcoming sessions remaining today', ShellTokens.accent),
        const SizedBox(height: 10),

        _sectionHeader('COMPLETED TODAY', ShellTokens.textDisabled),
        const SizedBox(height: 6),
        if (filteredCompleted.isNotEmpty)
          ...filteredCompleted.map((s) => _sessionCardCompleted(s))
        else
          _emptySectionCard('No sessions completed yet today', ShellTokens.textDisabled),
        const SizedBox(height: 10),

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

  Widget _emptySectionCard(String message, Color color) {
    return Card(
      color: ShellTokens.chromeSurface,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(PhosphorIcons.info, size: 12, color: color.withValues(alpha: 0.6)),
          const SizedBox(width: 6),
          Text(message, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.6), fontStyle: FontStyle.italic)),
        ]),
      ),
    );
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
              onPressed: () => _cancelSession(s),
              icon: const Icon(PhosphorIcons.x, size: 12),
              label: const Text('Cancel', style: TextStyle(fontSize: 10)),
              style: TextButton.styleFrom(foregroundColor: SemanticTokens.error, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero),
            ),
            const SizedBox(width: 4),
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

  Future<void> _cancelSession(Map<String, dynamic> s) async {
    final reasonCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
        title: const Text('Cancel Session'),
        content: SizedBox(width: 300, child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(s['group_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(title: const Text('Date'), subtitle: Text('${selectedDate.year}/${selectedDate.month}/${selectedDate.day}'), trailing: const Icon(PhosphorIcons.calendar, size: 18), onTap: () async {
            final d = await showDatePicker(context: ctx, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (d != null) setSt(() => selectedDate = d);
          }),
          TextField(controller: reasonCtrl, decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder())),
        ])),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm'))],
      )),
    );
    if (confirmed == true) {
      try {
        final txService = TransactionService(widget.database);
        final reversedCount = await txService.reverseCancelledSessionCharges(sessionId: s['id'] as String, date: selectedDate, createdByUserId: widget.currentUserId);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Session cancelled. ${reversedCount.length} reversal(s) created.'), backgroundColor: ShellTokens.chromeSurface));
        _loadFullData();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
    reasonCtrl.dispose();
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
  String _filter = 'all';
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];
  bool _showPhotos = false;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    _filtered = widget.roster.where((r) {
      if (_filter == 'present' && (r['status'] != 'present')) return false;
      if (_filter == 'absent' && (r['status'] != null && r['status'] != 'absent')) return false;
      if (_filter == 'late' && (r['status'] != 'late')) return false;
      if (_filter == 'pending' && (r['status'] != null)) return false;
      if (q.isNotEmpty) {
        final name = '${r['first_name_ar'] ?? ''} ${r['last_name_ar'] ?? ''} ${r['code'] ?? ''}'.toLowerCase();
        if (!name.contains(q)) return false;
      }
      return true;
    }).toList();
    if (mounted) setState(() {});
  }

  Future<void> _markPresent(Map<String, dynamic> r) async {
    final sessionId = widget.session['id'] as String;
    final studentId = r['id'] as String;
    final date = DateTime.now();
    try {
      final attRepo = AttendanceRepository(widget.database);
      final enrollments = await EnrollmentRepository(widget.database).getByStudent(studentId);
      final enrollment = enrollments.cast<Enrollment?>().firstWhere((e) => e?.subjectGroupId == widget.session['subject_group_id'], orElse: () => null);
      await attRepo.create(AttendanceCompanion(
        studentId: Value(studentId), sessionId: Value(sessionId),
        attendanceDate: Value(date), personType: const Value('student'),
        checkInMethod: const Value('manual'), isManualEntry: const Value(true),
        checkedInByUserId: Value(widget.currentUserId),
      ));
      await TransactionService(widget.database).createSessionCharge(
        studentId: studentId, sessionId: sessionId,
        enrollmentId: enrollment?.id ?? '', createdByUserId: widget.currentUserId, date: date,
      );
      widget.onChanged?.call();
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _markAbsent(Map<String, dynamic> r) async {
    final sessionId = widget.session['id'] as String;
    final studentId = r['id'] as String;
    try {
      final reason = await showDialog<String>(context: context, builder: (ctx) => ShellDialog(maxWidth: 360, title: 'Mark Absent', body: Column(mainAxisSize: MainAxisSize.min, children: ['unexcused', 'sick', 'family', 'other'].map((v) => ListTile(title: Text(v), onTap: () => Navigator.pop(ctx, v))).toList())));
      if (reason != null && mounted) {
        await AttendanceRepository(widget.database).markAbsent(sessionId: sessionId, studentId: studentId, date: DateTime.now(), reason: reason, userId: widget.currentUserId);
        widget.onChanged?.call();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _undoCheckin(Map<String, dynamic> r) async {
    if (r['attendance_id'] == null) return;
    final studentId = r['id'] as String;
    final sessionId = widget.session['id'] as String;
    try {
      final prefs = await SharedPreferences.getInstance();
      final undoWindow = prefs.getInt('undo_window_minutes') ?? 10;
      final checkInTime = r['check_in_time'] as DateTime?;
      if (checkInTime != null) {
        final elapsed = DateTime.now().difference(checkInTime).inMinutes;
        if (elapsed > undoWindow) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Undo window has expired. Use Payments screen for reversals.')));
          return;
        }
      }
      await TransactionService(widget.database).undoCheckin(
        attendanceId: r['attendance_id'] as String,
        studentId: studentId, sessionId: sessionId,
        attendanceDate: DateTime.now(),
        createdByUserId: widget.currentUserId,
      );
      widget.onChanged?.call();
      Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Undo failed: $e')));
    }
  }

  Future<void> _backdatedCheckin(Map<String, dynamic> r) async {
    final sessionDate = DateTime.now().subtract(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: sessionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 2)),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    final now = DateTime.now();
    final maxBack = DateTime(now.year, now.month, now.day - 1).subtract(const Duration(days: 1));
    if (picked.isBefore(maxBack)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backdated check-in limited to 48 hours')));
      return;
    }
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Backdated Check-in'),
      content: Text('You are recording attendance for ${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}. Continue?'),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm'))],
    ));
    if (confirmed != true) return;
    try {
      final attRepo = AttendanceRepository(widget.database);
      final sessionId = widget.session['id'] as String;
      final studentId = r['id'] as String;
      final enrollments = await EnrollmentRepository(widget.database).getByStudent(studentId);
      final enrollment = enrollments.cast<Enrollment?>().firstWhere((e) => e?.subjectGroupId == widget.session['subject_group_id'], orElse: () => null);
      await attRepo.create(AttendanceCompanion(
        studentId: Value(studentId), sessionId: Value(sessionId),
        attendanceDate: Value(picked), personType: const Value('student'),
        checkInMethod: const Value('manual'), isManualEntry: const Value(true),
        isBackdated: const Value(true), checkedInByUserId: Value(widget.currentUserId),
      ));
      await TransactionService(widget.database).createSessionCharge(
        studentId: studentId, sessionId: sessionId,
        enrollmentId: enrollment?.id ?? '', createdByUserId: widget.currentUserId, date: picked,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backdated check-in recorded for ${r['first_name_ar']}'), backgroundColor: ShellTokens.chromeSurface));
        widget.onChanged?.call();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _bulkCheckIn() async {
    final pending = widget.roster.where((r) => r['status'] == null || r['status'] == 'absent').toList();
    if (pending.isEmpty) return;
    setState(() => _working = true);
    int ok = 0, fail = 0;
    for (final r in pending) {
      try {
        await _markPresent(r);
        ok++;
      } catch (_) { fail++; }
    }
    if (mounted) {
      setState(() => _working = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$ok checked in, $fail failed'), backgroundColor: ShellTokens.chromeSurface));
      widget.onChanged?.call();
      Navigator.pop(context);
    }
  }

  Future<void> _bulkMarkAbsent() async {
    final pending = widget.roster.where((r) => r['status'] == null).toList();
    if (pending.isEmpty) return;
    setState(() => _working = true);
    int ok = 0, fail = 0;
    for (final r in pending) {
      try {
        await AttendanceRepository(widget.database).markAbsent(sessionId: widget.session['id'] as String, studentId: r['id'] as String, date: DateTime.now(), reason: 'unexcused', userId: widget.currentUserId);
        ok++;
      } catch (_) { fail++; }
    }
    if (mounted) {
      setState(() => _working = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$ok marked absent, $fail failed'), backgroundColor: ShellTokens.chromeSurface));
      widget.onChanged?.call();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final presCount = widget.roster.where((r) => r['status'] == 'present').length;
    final absCount = widget.roster.where((r) => r['status'] != null && r['status'] != 'present' && r['status'] != 'late').length;
    final lateCount = widget.roster.where((r) => r['status'] == 'late').length;
    final pendCount = widget.roster.where((r) => r['status'] == null).length;

    return ShellDialog(
      maxWidth: 750, maxHeight: 750,
      title: '${widget.session['group_name']} \u00b7 ${widget.session['classroom_name'] ?? ''}',
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(PhosphorIcons.chalkboardTeacher, size: 12, color: ShellTokens.textSecondary),
          const SizedBox(width: 4),
          Text('${widget.session['first_name_ar'] ?? ''} ${widget.session['last_name_ar'] ?? ''}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
          const Spacer(),
          Text('$presCount present \u00b7 $absCount absent \u00b7 $pendCount pending', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: SizedBox(height: 30, child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
            decoration: InputDecoration(hintText: 'Search', isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: ShellTokens.chromeBorder)), prefixIcon: const Icon(PhosphorIcons.magnifyingGlass, size: 12, color: ShellTokens.textSecondary)),
            onChanged: (_) => _applyFilter(),
          ))),
        ]),
        const SizedBox(height: 6),
        SizedBox(height: 26, child: ListView(scrollDirection: Axis.horizontal, children: [
          _rosterChip('All ($_filtered.length)', _filter == 'all', () => setState(() { _filter = 'all'; _applyFilter(); })),
          _rosterChip('Present ($presCount)', _filter == 'present', () => setState(() { _filter = 'present'; _applyFilter(); })),
          _rosterChip('Absent ($absCount)', _filter == 'absent', () => setState(() { _filter = 'absent'; _applyFilter(); })),
          _rosterChip('Late ($lateCount)', _filter == 'late', () => setState(() { _filter = 'late'; _applyFilter(); })),
          _rosterChip('Pending ($pendCount)', _filter == 'pending', () => setState(() { _filter = 'pending'; _applyFilter(); })),
        ])),
        const SizedBox(height: 6),
        Row(children: [
          TextButton.icon(onPressed: _working ? null : _bulkCheckIn, icon: const Icon(PhosphorIcons.checkCircle, size: 12), label: const Text('Check in all', style: TextStyle(fontSize: 10)), style: TextButton.styleFrom(foregroundColor: SemanticTokens.success, padding: const EdgeInsets.symmetric(horizontal: 6), minimumSize: Size.zero)),
          TextButton.icon(onPressed: _working ? null : _bulkMarkAbsent, icon: const Icon(PhosphorIcons.x, size: 12), label: const Text('Mark all absent', style: TextStyle(fontSize: 10)), style: TextButton.styleFrom(foregroundColor: SemanticTokens.error, padding: const EdgeInsets.symmetric(horizontal: 6), minimumSize: Size.zero)),
          const Spacer(),
          TextButton(onPressed: () => setState(() => _showPhotos = !_showPhotos), child: Text(_showPhotos ? 'Hide photos' : 'Show photos', style: const TextStyle(fontSize: 10))),
        ]),
        if (_working) const LinearProgressIndicator(),
        const SizedBox(height: 6),
        Flexible(
          child: _filtered.isEmpty
              ? const Center(child: Text('No students match', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled)))
              : Table(
                  columnWidths: const {0: FixedColumnWidth(36), 1: FlexColumnWidth(2.5), 2: FixedColumnWidth(80), 3: FixedColumnWidth(70), 4: IntrinsicColumnWidth()},
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(horizontalInside: BorderSide(color: ShellTokens.chromeBorder.withValues(alpha: 0.3), width: 0.5)),
                  children: [
                    TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface), children: [
                      _cell('', bold: true),
                      _cell('Name', bold: true),
                      _cell('Status', bold: true),
                      _cell('Time', bold: true),
                      _cell('', bold: true),
                    ]),
                    ..._filtered.map((r) {
                      final status = r['status'] as String?;
                      final isEndingSoon = _isSessionEndingSoon() && status == null;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: isEndingSoon ? SemanticTokens.warning.withValues(alpha: 0.08)
                              : (status == 'absent' || (status != null && status != 'present')) ? SemanticTokens.error.withValues(alpha: 0.05)
                              : Colors.transparent,
                        ),
                        children: [
                          _photoCell(r, _showPhotos),
                          _nameCell(r, status, isEndingSoon),
                          _statusCell(status, r['minutes_late'] as int?, r['is_backdated'] as bool),
                          _cell(r['check_in_time'] != null ? _fmtTime(r['check_in_time'] as DateTime) : '\u2014'),
                          _actionsCell(r, status),
                        ],
                      );
                    }),
                  ],
                ),
        ),
      ]),
    );
  }

  bool _isSessionEndingSoon() {
    final end = widget.session['end_time'] as DateTime;
    final now = DateTime.now();
    final endToday = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    return endToday.difference(now).inMinutes <= 10 && endToday.difference(now).inMinutes > 0;
  }

  Widget _rosterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 5),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeBase,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(borderRadius: BorderRadius.circular(4), onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary)))),
      ),
    );
  }

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: bold ? FontWeight.w600 : FontWeight.w400, color: bold ? ShellTokens.textDisabled : ShellTokens.textSecondary)),
    );
  }

  Widget _photoCell(Map<String, dynamic> r, bool showPhoto) {
    final path = r['photo_path'] as String?;
    final first = (r['first_name_ar'] as String? ?? '?')[0];
    return Padding(
      padding: const EdgeInsets.all(4),
      child: showPhoto && path != null && path.isNotEmpty
          ? ClipOval(child: Image.file(File(path), width: 28, height: 28, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _defaultAvatar(first)))
          : _defaultAvatar(first),
    );
  }

  Widget _defaultAvatar(String letter) => CircleAvatar(radius: 14, backgroundColor: ShellTokens.accentMuted, child: Text(letter, style: const TextStyle(color: ShellTokens.textPrimary, fontSize: 10, fontWeight: FontWeight.w700)));

  Widget _nameCell(Map<String, dynamic> r, String? status, bool isEndingSoon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${r['first_name_ar'] ?? ''} ${r['last_name_ar'] ?? ''}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: ShellTokens.textPrimary)),
          Text(r['code'] ?? '', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
        ])),
        if (status == 'absent' && r['absence_reason'] != null)
          Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: SemanticTokens.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3)), child: Text(r['absence_reason'] as String, style: const TextStyle(fontSize: 8, color: SemanticTokens.error))),
      ]),
    );
  }

  Widget _statusCell(String? status, int? minutesLate, bool isBackdated) {
    final label = status ?? 'Pending';
    final color = status == 'present' ? SemanticTokens.success
        : status == 'late' ? const Color(0xFFC2823A)
        : status == 'absent' || status == 'excused_absence' ? SemanticTokens.error
        : ShellTokens.textDisabled;
    final icon = status == 'present' ? PhosphorIcons.checkCircle
        : status == 'late' ? PhosphorIcons.clock
        : status == 'absent' || status == 'excused_absence' ? PhosphorIcons.x
        : PhosphorIcons.clock;
    final extra = minutesLate != null ? ' (+${minutesLate}m)' : (isBackdated ? ' \u2190' : '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 2),
        Text('$label$extra', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _actionsCell(Map<String, dynamic> r, String? status) {
    if (status == 'present' && r['attendance_id'] != null) {
      return IconButton(icon: const Icon(PhosphorIcons.arrowCounterClockwise, size: 14, color: ShellTokens.textSecondary), onPressed: () => _undoCheckin(r), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Undo');
    }
    if (status == null || status == 'absent') {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(PhosphorIcons.checkCircle, size: 14, color: SemanticTokens.success), onPressed: () => _markPresent(r), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Check in'),
        if (status == null) IconButton(icon: const Icon(PhosphorIcons.x, size: 14, color: SemanticTokens.error), onPressed: () => _markAbsent(r), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Mark absent'),
        IconButton(icon: const Icon(PhosphorIcons.clock, size: 14, color: const Color(0xFFC2823A)), onPressed: () => _backdatedCheckin(r), padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 28, minHeight: 28), tooltip: 'Backdated check-in'),
      ]);
    }
    return const SizedBox(width: 28);
  }

  String _fmtTime(DateTime t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
}
