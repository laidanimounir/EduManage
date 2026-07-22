import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/transaction_repository.dart';

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
      appBar: AppBar(title: Text(l10n.dashboard)),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          l10n.totalStudents,
                          _totalStudents.toString(),
                          Icons.school,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.totalTeachers,
                          _totalTeachers.toString(),
                          Icons.people,
                          Colors.teal,
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
                          Icons.calendar_today,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.todayAttendance,
                          _todayAttendance.toString(),
                          Icons.check_circle,
                          Colors.green,
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
                          Icons.trending_up,
                          Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          l10n.outstandingDebts,
                          '${_outstandingDebts.toStringAsFixed(0)} DA',
                          Icons.warning,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.quickActions,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, '/checkin'),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue),
                                  const SizedBox(height: 8),
                                  Text(l10n.quickActions),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, '/payments'),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(Icons.payment, size: 32, color: Colors.green),
                                  const SizedBox(height: 8),
                                  Text(l10n.quickActions),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
