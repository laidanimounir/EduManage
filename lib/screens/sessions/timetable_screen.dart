import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../constants/phosphor_icons.dart';
import '../../constants/theme_tokens.dart';
import '../../constants/app_constants.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/classroom_repository.dart';
import '../../utils/date_helper.dart';

class TimetableScreen extends StatefulWidget {
  final AppDatabase database;
  const TimetableScreen({super.key, required this.database});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> with WidgetsBindingObserver {
  late final SessionRepository _repo;
  List<Session> _allSessions = [];
  bool _loading = true;
  String _teacherFilter = '';
  Map<String, String> _groupNames = {};
  Map<String, String> _teacherNames = {};
  Map<String, String> _roomNames = {};
  Map<String, Color> _groupColors = {};
  int _selectedWeekOffset = 0;

  final List<Color> _colorPalette = [
    const Color(0xFF5B8C5A),
    const Color(0xFF4A7BA7),
    const Color(0xFF8B6BA7),
    const Color(0xFFA76B6B),
    const Color(0xFF6BA79B),
    const Color(0xFFA78B4A),
  ];

  @override
  void initState() {
    super.initState();
    _repo = SessionRepository(widget.database);
    _load();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_allSessions.isNotEmpty) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await _repo.fetchPage(limit: 500);
    _allSessions = result.sessions;
    await _preloadNames();
    _assignColors();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _preloadNames() async {
    final groupRepo = SubjectGroupRepository(widget.database);
    final teacherRepo = TeacherRepository(widget.database);
    final roomRepo = ClassroomRepository(widget.database);
    final seenGroups = <String>{};
    final seenTeachers = <String>{};
    final seenRooms = <String>{};
    for (final s in _allSessions) {
      if (!seenGroups.contains(s.subjectGroupId)) {
        seenGroups.add(s.subjectGroupId);
        final g = await groupRepo.getById(s.subjectGroupId);
        _groupNames[s.subjectGroupId] = g?.nameAr ?? s.subjectGroupId;
      }
      if (!seenTeachers.contains(s.teacherId)) {
        seenTeachers.add(s.teacherId);
        final t = await teacherRepo.getById(s.teacherId);
        _teacherNames[s.teacherId] = t != null ? '${t.firstNameAr} ${t.lastNameAr}' : s.teacherId;
      }
      if (!seenRooms.contains(s.classroomId)) {
        seenRooms.add(s.classroomId);
        final r = await roomRepo.getById(s.classroomId);
        _roomNames[s.classroomId] = r?.nameAr ?? s.classroomId;
      }
    }
  }

  void _assignColors() {
    final uniqueGroups = _allSessions.map((s) => s.subjectGroupId).toSet().toList();
    for (var i = 0; i < uniqueGroups.length; i++) {
      _groupColors[uniqueGroups[i]] = _colorPalette[i % _colorPalette.length];
    }
  }

  List<Session> _sessionsForDaySlot(int day, int slotStartMinutes, int slotEndMinutes) {
    return _allSessions.where((s) {
      if (_teacherFilter.isNotEmpty && s.teacherId != _teacherFilter) return false;
      if (s.dayOfWeek != day) return false;
      if (s.isArchived || !s.isActive) return false;
      final sStart = s.startTime.hour * 60 + s.startTime.minute;
      final sEnd = s.endTime.hour * 60 + s.endTime.minute;
      if (sEnd - sStart > 480) return false;
      return sStart < slotEndMinutes && sEnd > slotStartMinutes;
    }).toList();
  }

  Color _groupColor(String id) => _groupColors[id] ?? ShellTokens.accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: ShellTokens.accent)));

    final times = _generateTimeSlots();
    final days = List.generate(7, (i) => i + 1);

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: Column(children: [
        _buildToolbar(l10n),
        Expanded(child: SingleChildScrollView(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Table(
          columnWidths: {
            0: const FixedColumnWidth(90),
            for (var i = 0; i < times.length; i++) i + 1: const FixedColumnWidth(160),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          border: TableBorder.all(color: ShellTokens.chromeBorder.withValues(alpha: 0.4), width: 0.5),
          children: [
            TableRow(decoration: const BoxDecoration(color: ShellTokens.chromeSurface), children: [
              _cell('', bold: true),
              for (final t in times)
                _cell(t, bold: true, fontSize: 10),
            ]),
            for (final day in days)
              TableRow(children: [
                _cell(DateHelper.formatDayOfWeek(day, Localizations.localeOf(context).languageCode), bold: true, bgColor: ShellTokens.chromeSurface),
                for (final slot in _generateTimeRanges(times))
                  _sessionCell(day, slot.$1, slot.$2),
              ]),
          ],
        )))),
      ]),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(children: [
        Text(l10n.weeklyTimetable, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
        const Spacer(),
        SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary), onPressed: _exportPdf, tooltip: l10n.exportPdf, style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
        const SizedBox(width: 4),
        SizedBox(height: 34, child: IconButton(icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary), onPressed: _exportExcel, tooltip: l10n.exportExcel, style: IconButton.styleFrom(backgroundColor: ShellTokens.chromeSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))))),
      ]),
    );
  }

  List<String> _generateTimeSlots() {
    if (_allSessions.isEmpty) return ['06:00', '08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00'];
    var minHour = 6;
    var maxHour = 20;
    for (final s in _allSessions) {
      if (s.startTime.hour < minHour) minHour = s.startTime.hour;
      if (s.endTime.hour > maxHour) maxHour = s.endTime.hour;
    }
    minHour = (minHour ~/ 2) * 2;
    if (maxHour < 23) maxHour += 1;
    maxHour = ((maxHour + 1) ~/ 2) * 2;
    return List.generate(((maxHour - minHour) ~/ 2).clamp(1, 12), (i) {
      final h = minHour + i * 2;
      return '${h.toString().padLeft(2, '0')}:00';
    });
  }

  List<(int, int)> _generateTimeRanges(List<String> slots) {
    final result = <(int, int)>[];
    for (var i = 0; i < slots.length; i++) {
      final startParts = slots[i].split(':');
      final startHour = int.parse(startParts[0]);
      result.add((startHour * 60, startHour * 60 + 120));
    }
    return result;
  }

  Widget _sessionCell(int day, int slotStart, int slotEnd) {
    final sessions = _sessionsForDaySlot(day, slotStart, slotEnd);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: sessions.length > 1 ? SemanticTokens.error.withValues(alpha: 0.08) : Colors.transparent,
        border: sessions.length > 1 ? Border.all(color: SemanticTokens.error.withValues(alpha: 0.3), width: 1) : null,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        for (final s in sessions)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _groupColor(s.subjectGroupId).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border(left: BorderSide(color: _groupColor(s.subjectGroupId), width: 3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(_groupNames[s.subjectGroupId] ?? '', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _groupColor(s.subjectGroupId)), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(_teacherNames[s.teacherId] ?? '', style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary), maxLines: 1),
              Text(_roomNames[s.classroomId] ?? '', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled), maxLines: 1),
            ]),
          ),
      ]),
    );
  }

  Widget _cell(String text, {bool bold = false, double fontSize = 11, Color? bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: bgColor,
      child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: ShellTokens.textPrimary)),
    );
  }

  String _fmtTime(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _exportPdf() async {
    final l10n = AppLocalizations.of(context);
    final sessions = _allSessions.where((s) => !s.isArchived && s.isActive && (_teacherFilter.isEmpty || s.teacherId == _teacherFilter)).toList();
    final pdf = pw.Document();
    final dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (_) => [
        pw.Header(text: l10n.weeklyTimetable, level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 7),
          headers: ['Day', 'Start', 'End', 'Group', 'Teacher', 'Classroom', 'Price'],
          data: sessions.map((s) => [
            dayNames[s.dayOfWeek],
            _fmtTime(s.startTime),
            _fmtTime(s.endTime),
            _groupNames[s.subjectGroupId] ?? '',
            _teacherNames[s.teacherId] ?? '',
            _roomNames[s.classroomId] ?? '',
            '${s.monthlyPrice.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
          ]).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportExcel() async {
    final sessions = _allSessions.where((s) => !s.isArchived && s.isActive && (_teacherFilter.isEmpty || s.teacherId == _teacherFilter)).toList();
    final excel = Excel.createExcel();
    final sheet = excel['Timetable'];
    final dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    sheet.appendRow([TextCellValue('Day'), TextCellValue('Start'), TextCellValue('End'), TextCellValue('Group'), TextCellValue('Teacher'), TextCellValue('Classroom'), TextCellValue('Price')]);
    for (final s in sessions) {
      sheet.appendRow([
        TextCellValue(dayNames[s.dayOfWeek]),
        TextCellValue(_fmtTime(s.startTime)),
        TextCellValue(_fmtTime(s.endTime)),
        TextCellValue(_groupNames[s.subjectGroupId] ?? ''),
        TextCellValue(_teacherNames[s.teacherId] ?? ''),
        TextCellValue(_roomNames[s.classroomId] ?? ''),
        TextCellValue('${s.monthlyPrice.toStringAsFixed(0)}'),
      ]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/timetable_export.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export Excel: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }
}
