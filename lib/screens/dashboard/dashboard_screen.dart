import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/phosphor_icons.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/theme_tokens.dart';
import '../../constants/app_constants.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../widgets/app_loading.dart';

class DashboardScreen extends StatefulWidget {
  final AppDatabase database;

  const DashboardScreen({super.key, required this.database});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? _dateFrom, _dateTo;
  Map<String, double> _metrics = {};
  int _totalStudents = 0, _totalTeachers = 0, _todaySessions = 0, _todayAttendance = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final sRepo = StudentRepository(widget.database);
      final tRepo = TeacherRepository(widget.database);
      final results = await Future.wait([
        sRepo.getAll(),
        tRepo.getAll(),
        widget.database.getPeriodSummary(from: _dateFrom, to: _dateTo),
      ]);

      final students = results[0] as List;
      final teachers = results[1] as List;
      final summary = results[2] as Map<String, double>;

      _totalStudents = students.length;
      _totalTeachers = teachers.length;
      _metrics = summary;

      if (_dateFrom == null) {
        final now = DateTime.now();
        final sessionRepo = SessionRepository(widget.database);
        final attendanceRepo = AttendanceRepository(widget.database);
        final todayResults = await Future.wait([
          sessionRepo.getByDay(now.weekday),
          attendanceRepo.getTodayAttendance(),
        ]);
        _todaySessions = (todayResults[0] as List).length;
        _todayAttendance = (todayResults[1] as List).length;
      }

      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revenue = _metrics['revenue'] ?? 0;
    final expenses = _metrics['expenses'] ?? 0;
    final outstanding = _metrics['outstanding'] ?? 0;
    final net = revenue - expenses;

    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: _loading
            ? const AppLoading()
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Row(children: [
                    _buildDateBtn(l10n.from, _dateFrom, (d) { setState(() => _dateFrom = d); _loadStats(); }),
                    const SizedBox(width: 8),
                    _buildDateBtn(l10n.to, _dateTo, (d) { setState(() => _dateTo = d); _loadStats(); }),
                    if (_dateFrom != null || _dateTo != null) ...[
                      const SizedBox(width: 4),
                      IconButton(icon: const Icon(PhosphorIcons.x, size: 14, color: ShellTokens.textSecondary),
                        onPressed: () { setState(() { _dateFrom = null; _dateTo = null; }); _loadStats(); },
                        padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 24, minHeight: 24)),
                    ],
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _kpiCard(l10n.totalStudents, '$_totalStudents', PhosphorIcons.users, ShellTokens.accent),
                    const SizedBox(width: 8),
                    _kpiCard(l10n.totalTeachers, '$_totalTeachers', PhosphorIcons.chalkboardTeacher, const Color(0xFF5B8C5A)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _kpiCard(l10n.todaySessions, '$_todaySessions', PhosphorIcons.clock, const Color(0xFFC2823A)),
                    const SizedBox(width: 8),
                    _kpiCard(l10n.todayAttendance, '$_todayAttendance', PhosphorIcons.checkCircle, const Color(0xFF4B8B4A)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _kpiCard('Revenue', '${revenue.toStringAsFixed(0)} DA', PhosphorIcons.trendUp, SemanticTokens.success),
                    const SizedBox(width: 8),
                    _kpiCard('Expenses', '${expenses.toStringAsFixed(0)} DA', PhosphorIcons.currencyCircleDollar, SemanticTokens.error),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _kpiCard('Net', '${net.toStringAsFixed(0)} DA', PhosphorIcons.chartBar, net >= 0 ? SemanticTokens.success : SemanticTokens.error),
                    const SizedBox(width: 8),
                    _kpiCard(l10n.outstandingDebts, '${outstanding.toStringAsFixed(0)} DA', PhosphorIcons.wallet, outstanding > 0 ? const Color(0xFFC2483D) : SemanticTokens.success),
                  ]),
                  const SizedBox(height: 8),
                  _kpiCard('Collection Rate', _collectionRate, PhosphorIcons.checkCircle, ShellTokens.accent, fullWidth: true),
                ],
              ),
      ),
    );
  }

  String get _collectionRate {
    final revenue = _metrics['revenue'] ?? 0;
    if (revenue == 0) return 'N/A';
    final paid = revenue - (_metrics['outstanding'] ?? 0);
    final rate = (paid / revenue * 100).clamp(0, 100);
    return '${rate.toStringAsFixed(0)}%';
  }

  Widget _buildDateBtn(String label, DateTime? value, ValueChanged<DateTime> onPick) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (d != null) onPick(d);
      },
      child: Container(
        height: 34, padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: ShellTokens.chromeSurface, borderRadius: BorderRadius.circular(6),
            border: Border.all(color: value != null ? ShellTokens.accent : ShellTokens.chromeBorder)),
        child: Center(child: Text(
          value != null ? '${value.year}-${value.month.toString().padLeft(2,'0')}-${value.day.toString().padLeft(2,'0')}' : label,
          style: TextStyle(fontSize: 11, color: value != null ? ShellTokens.textPrimary : ShellTokens.textDisabled))),
      ),
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color, {bool fullWidth = false}) {
    final widget = Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Icon(icon, size: fullWidth ? 20 : 24, color: color),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: fullWidth ? 18 : 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
    if (fullWidth) return widget;
    return Expanded(child: widget);
  }
}
