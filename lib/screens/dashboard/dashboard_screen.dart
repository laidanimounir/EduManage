import 'package:flutter/material.dart';
import '../../constants/phosphor_icons.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/theme_tokens.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../widgets/app_loading.dart';

class DashboardScreen extends StatefulWidget {
  final AppDatabase database;

  const DashboardScreen({super.key, required this.database});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final StudentRepository _studentRepo;
  late final TeacherRepository _teacherRepo;
  late final SessionRepository _sessionRepo;
  late final AttendanceRepository _attendanceRepo;
  late final TransactionRepository _transactionRepo;

  int _totalStudents = 0;
  int _totalTeachers = 0;
  int _todaySessions = 0;
  int _todayAttendance = 0;
  double _monthlyRevenue = 0;
  double _outstandingDebts = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _teacherRepo = TeacherRepository(widget.database);
    _sessionRepo = SessionRepository(widget.database);
    _attendanceRepo = AttendanceRepository(widget.database);
    _transactionRepo = TransactionRepository(widget.database);
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loading = true);
    try {
      final students = await _studentRepo.getAll();
      final teachers = await _teacherRepo.getAll();

      final now = DateTime.now();
      final todaySessions = await _sessionRepo.getByDay(now.weekday);
      final todayAttendance = await _attendanceRepo.getTodayAttendance();

      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      final monthTx = await _transactionRepo.getByDateRange(monthStart, monthEnd);

      final allTx = await _transactionRepo.getAll();

      final monthlyRevenue = monthTx
          .where((t) => t.type == 'session_charge')
          .fold<double>(0, (sum, t) => sum + t.amount);

      final allCharges = allTx
          .where((t) => t.type == 'session_charge')
          .fold<double>(0, (sum, t) => sum + t.amount);
      final allPayments = allTx
          .where((t) => t.type == 'student_payment' || t.type == 'discount')
          .fold<double>(0, (sum, t) => sum + t.amount);
      final outstandingDebts = allCharges - allPayments;

      setState(() {
        _totalStudents = students.length;
        _totalTeachers = teachers.length;
        _todaySessions = todaySessions.length;
        _todayAttendance = todayAttendance.length;
        _monthlyRevenue = monthlyRevenue;
        _outstandingDebts = outstandingDebts < 0 ? 0 : outstandingDebts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: _loading
            ? const AppLoading()
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          l10n.totalStudents,
                          _totalStudents.toString(),
                          PhosphorIcons.users,
                          ShellTokens.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.totalTeachers,
                          _totalTeachers.toString(),
                          PhosphorIcons.chalkboardTeacher,
                          const Color(0xFF5B8C5A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          l10n.todaySessions,
                          _todaySessions.toString(),
                          PhosphorIcons.clock,
                          const Color(0xFFC2823A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.todayAttendance,
                          _todayAttendance.toString(),
                          PhosphorIcons.checkCircle,
                          const Color(0xFF4B8B4A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          l10n.monthlyRevenue,
                          '${_monthlyRevenue.toStringAsFixed(0)} DA',
                          PhosphorIcons.trendUp,
                          const Color(0xFF5B8C5A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.outstandingDebts,
                          '${_outstandingDebts.toStringAsFixed(0)} DA',
                          PhosphorIcons.warning,
                          const Color(0xFFC2483D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: ShellTokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
