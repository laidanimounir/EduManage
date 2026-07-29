import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import '../../constants/chart_tokens.dart';
import '../../constants/phosphor_icons.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/theme_tokens.dart';
import '../../constants/app_constants.dart';
import '../../widgets/app_loading.dart';
import '../../screens/payments/unified_payment_screen.dart' show UnifiedPaymentScreen;
import '../../widgets/dashboard_charts.dart';

class DashboardScreen extends StatefulWidget {
  final AppDatabase database;
  const DashboardScreen({super.key, required this.database});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? _dateFrom, _dateTo;

  Map<String, double> _metrics = {};
  int _totalStudents = 0, _totalTeachers = 0;

  List<Map<String, dynamic>> _alerts = [];
  List<Map<String, dynamic>> _liveSessions = [];
  Map<String, double> _prevMetrics = {};
  Map<String, List<double>> _sparklineData = {};
  Map<String, int> _billingHealth = {};
  Map<String, dynamic> _teacherSummary = {};
  Map<String, int> _enrollmentTrend = {};
  List<Map<String, dynamic>> _classrooms = [];
  double _familyDiscount = 0;
  int _activeStudentCount = 0;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() { _loading = true; _error = null; });
    try {
      final now = DateTime.now();
      final from = _dateFrom ?? DateTime(now.year, 1, 1);
      final to = _dateTo ?? now;

      final results = await Future.wait([
        widget.database.customSelect('SELECT COUNT(*) AS cnt FROM students WHERE is_archived = 0').map((r) => r.read<int>('cnt')).getSingle(),
        widget.database.customSelect('SELECT COUNT(*) AS cnt FROM teachers WHERE is_archived = 0').map((r) => r.read<int>('cnt')).getSingle(),
        widget.database.getPeriodSummary(from: _dateFrom, to: _dateTo),
        _loadAlerts(),
        _loadLiveSessions(),
        widget.database.getPreviousPeriodComparison(metric: 'summary', from: from, to: to).catchError((_) => <String, double>{}),
        _loadSparklines(),
        widget.database.getBillingCycleHealth().catchError((_) => <String, dynamic>{}),
        widget.database.getTeacherPayoutSummary().catchError((_) => <String, dynamic>{}),
        widget.database.getEnrollmentTrend(from, to).catchError((_) => <String, int>{}),
        widget.database.getClassroomUtilization().catchError((_) => <Map<String, dynamic>>[]),
        widget.database.getFamilyDiscountTotal(from, to).catchError((_) => 0.0),
        widget.database.customSelect(
          'SELECT COUNT(*) AS cnt FROM students s JOIN enrollments e ON s.id = e.student_id WHERE s.is_archived = 0 AND e.status = ? AND e.is_transferred = 0',
          variables: [Variable.withString('active')],
        ).map((r) => r.read<int>('cnt')).getSingle().catchError((_) => 0),
      ]);

      _totalStudents = results[0] as int;
      _totalTeachers = results[1] as int;
      _metrics = results[2] as Map<String, double>;
      _alerts = results[3] as List<Map<String, dynamic>>;
      _liveSessions = results[4] as List<Map<String, dynamic>>;
      _prevMetrics = results[5] as Map<String, double>;
      _sparklineData = results[6] as Map<String, List<double>>;
      _billingHealth = (results[7] as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toInt()));
      _teacherSummary = results[8] as Map<String, dynamic>;
      _enrollmentTrend = (results[9] as Map<String, int>);
      _classrooms = results[10] as List<Map<String, dynamic>>;
      _familyDiscount = results[11] as double;
      _activeStudentCount = results[12] as int;

      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load dashboard: $e'; });
    }
  }

  Future<List<Map<String, dynamic>>> _loadAlerts() async {
    final alerts = <Map<String, dynamic>>[];
    try {
      final unbilled = await widget.database.countUnbilledActiveStudents();
      if (unbilled > 0) alerts.add({'icon': PhosphorIcons.warning, 'color': const Color(0xFFC2823A), 'text': '$unbilled unbilled active students', 'screen': 'balances'});

      final topTeachers = await widget.database.getTeacherPayoutSummary().then((s) => s['topOverdueTeachers'] as List).catchError((_) => <Map>[]);
      for (final t in topTeachers) {
        if (t['lastPayout'] == null || (t['thresholdDays'] != null && DateTime.now().difference(t['lastPayout'] as DateTime).inDays > (t['thresholdDays'] as int))) {
          alerts.add({'icon': PhosphorIcons.warning, 'color': SemanticTokens.error, 'text': '${t['name']} is overdue for payout', 'screen': 'teachers', 'teacherId': t['id']});
        }
      }

      final waitlistCount = await widget.database.customSelect('SELECT COUNT(*) AS cnt FROM enrollment_waitlist').map((r) => r.read<int>('cnt')).getSingle().catchError((_) => 0);
      if (waitlistCount > 0) alerts.add({'icon': PhosphorIcons.usersThree, 'color': const Color(0xFFC2823A), 'text': '$waitlistCount student(s) on waitlist', 'screen': 'enrollments'});
    } catch (_) {}
    return alerts;
  }

  Future<List<Map<String, dynamic>>> _loadLiveSessions() async {
    final live = <Map<String, dynamic>>[];
    try {
      final now = DateTime.now();
      final today = now.weekday;
      final rows = await widget.database.customSelect(
        'SELECT s.id, s.subject_group_id, s.teacher_id, s.start_time, s.end_time, sg.name_ar AS group_name, t.first_name_ar, t.last_name_ar '
        'FROM sessions s '
        'JOIN subject_groups sg ON s.subject_group_id = sg.id '
        'LEFT JOIN teachers t ON s.teacher_id = t.id '
        'WHERE s.day_of_week = ? AND s.is_active = 1 AND s.is_archived = 0',
        variables: [Variable.withInt(today)],
      ).get();
      for (final r in rows) {
        final startTime = DateTime(now.year, now.month, now.day, r.read<DateTime>('start_time').hour, r.read<DateTime>('start_time').minute);
        final endTime = DateTime(now.year, now.month, now.day, r.read<DateTime>('end_time').hour, r.read<DateTime>('end_time').minute);
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          final attCount = await widget.database.customSelect(
            'SELECT COUNT(*) AS cnt FROM attendance WHERE session_id = ? AND attendance_date >= ? AND attendance_date < ?',
            variables: [Variable.withString(r.read<String>('id')), Variable.withDateTime(DateTime(now.year, now.month, now.day)), Variable.withDateTime(DateTime(now.year, now.month, now.day + 1))],
          ).map((rr) => rr.read<int>('cnt')).getSingle().catchError((_) => 0);
          live.add({
            'id': r.read<String>('id'), 'groupId': r.read<String>('subject_group_id'), 'teacherId': r.read<String>('teacher_id'),
            'groupName': r.read<String>('group_name'), 'teacherName': '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')}',
            'time': '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}-${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
            'attendance': attCount,
          });
        }
      }
    } catch (_) {}
    return live;
  }

  Future<Map<String, List<double>>> _loadSparklines() async {
    final data = <String, List<double>>{};
    try {
      final trend = await widget.database.getMonthlyTrend(6);
      data['revenue'] = trend.map((m) => (m['revenue'] as double?) ?? 0).toList();
      data['collectionRate'] = trend.map((m) => (m['collectionRate'] as double?) ?? 0).toList();
    } catch (_) {
      data['revenue'] = List.filled(6, 0.0);
      data['collectionRate'] = List.filled(6, 0.0);
    }
    return data;
  }

  String _trendLabel(double current, double previous) {
    if (current == 0 || previous == 0) return '';
    final pct = ((current - previous) / previous * 100).round();
    return pct >= 0 ? '+$pct%' : '$pct%';
  }

  Color _trendColor(double current, double previous) {
    if (current == 0 || previous == 0) return ChartTokens.trendNeutral;
    return current >= previous ? ChartTokens.trendUp : ChartTokens.trendDown;
  }

  IconData? _trendIcon(double current, double previous) {
    if (current == 0 || previous == 0) return null;
    return current >= previous ? PhosphorIcons.trendUp : PhosphorIcons.arrowLeft;
  }

  String get _collectionRateLabel {
    final revenue = _metrics['revenue'] ?? 0;
    if (revenue == 0) return 'N/A';
    final paid = revenue - (_metrics['outstanding'] ?? 0);
    final rate = (paid / revenue * 100).clamp(0, 100);
    return '${rate.toStringAsFixed(0)}%';
  }

  // ================== BUILD ==================
  @override
  Widget build(BuildContext context) {
    final revenue = _metrics['revenue'] ?? 0;
    final expenses = _metrics['expenses'] ?? 0;
    final outstanding = _metrics['outstanding'] ?? 0;
    final net = revenue - expenses;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      body: _loading
          ? const AppLoading()
          : _error != null
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.warning_amber_rounded, size: 32, color: Colors.orange),
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _loadStats, child: const Text('Retry')),
                  ]),
                )
              : SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 1000;
                      return RefreshIndicator(
                        onRefresh: _loadStats,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            _buildTopBar(),
                            const SizedBox(height: 16),
                            _buildTopKpiRow(wide),
                            const SizedBox(height: 16),
                            wide
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: _buildReservationsCard()),
                                      const SizedBox(width: 16),
                                      Expanded(flex: 3, child: _buildCampaignOverviewCard()),
                                    ],
                                  )
                                : Column(children: [
                                    _buildReservationsCard(),
                                    const SizedBox(height: 16),
                                    _buildCampaignOverviewCard(),
                                  ]),
                            const SizedBox(height: 16),
                            wide
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: _buildRecentActivitiesCard()),
                                      const SizedBox(width: 16),
                                      Expanded(flex: 2, child: _buildRevenueStatCard(revenue)),
                                      const SizedBox(width: 16),
                                      Expanded(flex: 2, child: _buildBookingsCard()),
                                    ],
                                  )
                                : Column(children: [
                                    _buildRecentActivitiesCard(),
                                    const SizedBox(height: 16),
                                    _buildRevenueStatCard(revenue),
                                    const SizedBox(height: 16),
                                    _buildBookingsCard(),
                                  ]),
                            const SizedBox(height: 16),
                            _buildKeyRatios(revenue, outstanding, net),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  // ================== Top Bar (search + date filter) ==================
  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.search, color: Colors.white38, size: 18),
              SizedBox(width: 8),
              Text('Search...', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ]),
          ),
        ),
        const SizedBox(width: 12),
        _dateChip('From', _dateFrom, (d) { setState(() => _dateFrom = d); _loadStats(); }),
        const SizedBox(width: 8),
        _dateChip('To', _dateTo, (d) { setState(() => _dateTo = d); _loadStats(); }),
        if (_dateFrom != null || _dateTo != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.white38),
            onPressed: () { setState(() { _dateFrom = null; _dateTo = null; }); _loadStats(); },
          ),
        ],
      ],
    );
  }

  Widget _dateChip(String label, DateTime? value, ValueChanged<DateTime> onPick) {
    String fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (d != null) onPick(d);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(value != null ? fmt(value) : label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
      ),
    );
  }

  // ================== Alerts (Needs Attention) ==================
  Widget _buildAlertsSection() {
    if (_alerts.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orangeAccent),
            const SizedBox(width: 6),
            const Text('Needs Attention', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
          const SizedBox(height: 6),
          ..._alerts.take(3).map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  Icon(a['icon'] as IconData, size: 13, color: a['color'] as Color),
                  const SizedBox(width: 6),
                  Expanded(child: Text(a['text'] as String, style: const TextStyle(fontSize: 12, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.chevron_right, size: 12, color: Colors.white24),
                ]),
              )),
          if (_alerts.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('+${_alerts.length - 3} more', style: const TextStyle(fontSize: 10, color: Colors.white38)),
            ),
        ],
      ),
    );
  }

  // ================== Top KPI Cards ==================
  Widget _buildTopKpiRow(bool wide) {
    final cards = [
      _gradientKpiCard(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Outstanding',
        value: '${(_metrics['outstanding'] ?? 0).toStringAsFixed(0)} ${AppConstants.currencySymbol}',
        gradient: const [Color(0xFF8A5A1A), Color(0xFFC2823A)],
      ),
      _gradientKpiCard(
        icon: Icons.trending_up,
        label: 'Revenue',
        value: '${(_metrics['revenue'] ?? 0).toStringAsFixed(0)} ${AppConstants.currencySymbol}',
        gradient: const [Color(0xFF6E2E8C), Color(0xFF8C3FB0)],
      ),
      _gradientKpiCard(
        icon: Icons.school_outlined,
        label: 'Total Teachers',
        value: _totalTeachers.toString(),
        gradient: const [Color(0xFF7A2A5C), Color(0xFF9B3A78)],
      ),
      _gradientKpiCard(
        icon: Icons.groups_outlined,
        label: 'Total Students',
        value: _totalStudents.toString(),
        gradient: const [Color(0xFF0F3D3E), Color(0xFF145C5C)],
      ),
    ];

    if (!wide) {
      return Column(
        children: [
          Row(children: [Expanded(child: cards[0]), const SizedBox(width: 12), Expanded(child: cards[1])]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: cards[2]), const SizedBox(width: 12), Expanded(child: cards[3])]),
        ],
      );
    }
    return Row(
      children: cards
          .map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c)))
          .toList(),
    );
  }

  Widget _gradientKpiCard({required IconData icon, required String label, required String value, required List<Color> gradient}) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const Icon(Icons.more_horiz, color: Colors.white38, size: 16),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  // ================== Reservations / Active Students (Circular) ==================
  Widget _buildReservationsCard() {
    final revenue = _metrics['revenue'] ?? 0;
    final capacityPct = _totalStudents > 0 ? (_activeStudentCount / _totalStudents).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Students', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(140, 140),
                  painter: _CircularPercentPainter(percent: capacityPct, color: const Color(0xFF7C4DFF), trackColor: Colors.white12),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$_activeStudentCount', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    const Text('Active', style: TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('${revenue.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const Text('Total Revenue This Period', style: TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  // ================== Campaign / Revenue Trend (Line Chart) ==================
  Widget _buildCampaignOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revenue Trend', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                child: const Text('This Period', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 160, child: DashboardLineChart(database: widget.database)),
        ],
      ),
    );
  }

  // ================== Recent Activities (from alerts) ==================
  Widget _buildRecentActivitiesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activities', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const Text('View All', style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 10),
          if (_alerts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No recent activity', style: TextStyle(color: Colors.white24, fontSize: 11)),
            ),
          ..._alerts.take(5).map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: (a['color'] as Color).withOpacity(0.2),
                      child: Icon(a['icon'] as IconData, size: 14, color: a['color'] as Color),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(a['text'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ================== Revenue Stat (Bar Chart) ==================
  Widget _buildRevenueStatCard(double revenue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue Stat', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('${revenue.toStringAsFixed(2)} ${AppConstants.currencySymbol}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          SizedBox(height: 100, child: DashboardBarChart(database: widget.database)),
        ],
      ),
    );
  }

  // ================== Enrollments (Bookings-style bar) ==================
  Widget _buildBookingsCard() {
    final newE = _enrollmentTrend['newEnrollments'] ?? 0;
    final dropped = _enrollmentTrend['dropped'] ?? 0;
    final total = newE + dropped;
    final pct = total > 0 ? newE / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enrollments', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('$total', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const Text('Total This Period', style: TextStyle(color: Colors.white38, fontSize: 10)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.red.withOpacity(0.3), color: Colors.green),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('dropped $dropped', style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
              Text('new $newE', style: const TextStyle(color: Colors.green, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // ================== Financial Details ==================
  Widget _buildFinancialDetails(double revenue, double outstanding, double net) {
    final avgRevenue = _activeStudentCount > 0 ? (revenue / _activeStudentCount) : 0.0;
    final netAfterDiscounts = net - _familyDiscount;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Financial Details', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _finRow('Collection Rate', _collectionRateLabel),
          _finRow('Family Discounts', '${_familyDiscount.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
          _finRow('Net After Discounts', '${netAfterDiscounts.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
          _finRow('Avg Revenue / Student', '${avgRevenue.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
          _finRow('Active Students', '$_activeStudentCount'),
        ],
      ),
    );
  }

  Widget _finRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }

  // ================== Billing Cycle Health ==================
  Widget _buildBillingHealth() {
    final open = _billingHealth['openCycles'] ?? 0;
    final closed = _billingHealth['closedCycles'] ?? 0;
    final mid = _billingHealth['midCycleStudents'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Billing Cycle Health', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            _healthStat('Open Cycles', '$open', Colors.orangeAccent),
            _healthStat('Closed Cycles', '$closed', Colors.greenAccent),
            _healthStat('Mid-Cycle', '$mid', const Color(0xFF7C4DFF)),
          ]),
        ],
      ),
    );
  }

  Widget _healthStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  // ================== Teacher Payout Summary ==================
  Widget _buildTeacherSummary() {
    final topTeachers = _teacherSummary['topOverdueTeachers'] as List? ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Teacher Payouts', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Total Payouts: ${(_teacherSummary['totalPayouts'] as double?)?.toStringAsFixed(0) ?? '0'} ${AppConstants.currencySymbol}',
              style: const TextStyle(fontSize: 12, color: Colors.white60)),
          if (topTeachers.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('Nearest to Overdue:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white38)),
            const SizedBox(height: 4),
            ...topTeachers.take(5).map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${t['name']} (${t['code']})', style: const TextStyle(fontSize: 11, color: Colors.white60)),
                )),
          ],
        ],
      ),
    );
  }

  // ================== Enrollment Trend ==================
  Widget _buildEnrollmentTrend() {
    final newE = _enrollmentTrend['newEnrollments'] ?? 0;
    final dropped = _enrollmentTrend['dropped'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enrollment Trend', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(children: [
            _healthStat('New', '$newE', Colors.greenAccent),
            _healthStat('Dropped', '$dropped', Colors.redAccent),
            _healthStat('Net', '${newE - dropped}', newE - dropped >= 0 ? Colors.greenAccent : Colors.redAccent),
          ]),
        ],
      ),
    );
  }

  // ================== Classroom Utilization ==================
  Widget _buildClassroomUtilization() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Classroom Utilization', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ..._classrooms.take(8).map((c) {
            final capacity = (c['capacity'] as int?) ?? 1;
            final sessions = (c['sessionCount'] as int?) ?? 0;
            final pct = capacity > 0 ? (sessions * 100 ~/ capacity).clamp(0, 100).toDouble() / 100 : 0.0;
            final isLow = pct < 0.2;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                SizedBox(width: 80, child: Text(c['name'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.white60), maxLines: 1, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: pct, minHeight: 7, backgroundColor: Colors.white12, color: isLow ? Colors.orangeAccent : Colors.greenAccent),
                )),
                const SizedBox(width: 8),
                Text('$sessions/$capacity', style: const TextStyle(fontSize: 10, color: Colors.white38)),
                if (isLow) Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(3)),
                  child: const Text('low', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.orangeAccent)),
                ),
              ]),
            );
          }),
        ],
      ),
    );
  }

  // ================== Live Sessions ==================
  Widget _buildLiveSection() {
    if (_liveSessions.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('Live Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _liveSessions.length,
              itemBuilder: (_, i) {
                final s = _liveSessions[i];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.greenAccent.withOpacity(0.3))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(children: [
                      Expanded(child: Text(s['groupName'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 4),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(3)), child: const Text('Live', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.greenAccent))),
                    ]),
                    const SizedBox(height: 2),
                    Text('${s['time'] ?? ''} · ${s['teacherName'] ?? ''}', style: const TextStyle(fontSize: 9, color: Colors.white38), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${s['attendance']} present', style: const TextStyle(fontSize: 9, color: Colors.white60)),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================== Key Ratios ==================
  Widget _buildKeyRatios(double revenue, double outstanding, double net) {
    final collectionRate = revenue > 0 ? ((revenue - outstanding) / revenue).clamp(0, 1).toDouble() : 0.0;
    final netMargin = revenue > 0 ? (net / revenue).clamp(-1, 1).toDouble() : 0.0;
    final activeRatio = _totalStudents > 0 ? (_activeStudentCount / _totalStudents).clamp(0, 1).toDouble() : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF17171A), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Key Ratios', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(children: [
              Expanded(child: _AnimatedCircularPercent(label: 'Collection Rate', percent: collectionRate, color: Colors.greenAccent)),
              const SizedBox(width: 8),
              Expanded(child: _AnimatedCircularPercent(label: 'Net Margin', percent: netMargin.abs(), color: net >= 0 ? Colors.greenAccent : Colors.redAccent, negative: net < 0)),
              const SizedBox(width: 8),
              Expanded(child: _AnimatedCircularPercent(label: 'Active Students', percent: activeRatio, color: const Color(0xFF7C4DFF))),
            ]),
          ),
        ],
      ),
    );
  }
}

// ================== Animated Number ==================
class _AnimatedNumber extends StatefulWidget {
  final double value;
  final String suffix;
  final Color color;
  final double fontSize;
  const _AnimatedNumber({required this.value, this.suffix = '', required this.color, required this.fontSize});
  @override
  State<_AnimatedNumber> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedNumber> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: max(400, (widget.value * 0.008).round().clamp(200, 1200))));
    _anim = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedNumber old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _ctrl.duration = Duration(milliseconds: max(400, (widget.value * 0.008).round().clamp(200, 1200)));
      _anim = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Text(
        widget.suffix.isNotEmpty ? '${_anim.value.toStringAsFixed(0)} ${widget.suffix}' : '${_anim.value.toStringAsFixed(0)}',
        style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w700, color: widget.color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ================== Animated Circular Percent ==================
class _AnimatedCircularPercent extends StatefulWidget {
  final String label;
  final double percent;
  final Color color;
  final bool negative;
  const _AnimatedCircularPercent({required this.label, required this.percent, required this.color, this.negative = false});

  @override
  State<_AnimatedCircularPercent> createState() => _AnimatedCircularPercentState();
}

class _AnimatedCircularPercentState extends State<_AnimatedCircularPercent> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0, end: widget.percent.clamp(0, 1)).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedCircularPercent old) {
    super.didUpdateWidget(old);
    if (old.percent != widget.percent) {
      _anim = Tween<double>(begin: _anim.value, end: widget.percent.clamp(0, 1)).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl..reset()..forward();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const maxDiameter = 130.0;
      final rawSize = min(constraints.maxWidth, constraints.maxHeight - 24) * 0.85;
      final size = rawSize.clamp(70.0, maxDiameter);
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: size, height: size,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => CustomPaint(
              painter: _CircularPercentPainter(percent: _anim.value, color: widget.color, trackColor: Colors.white12),
              child: Center(
                child: Text(
                  '${widget.negative ? '-' : ''}${(_anim.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: size * 0.16, fontWeight: FontWeight.w700, color: widget.color),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(widget.label, style: const TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
      ]);
    });
  }
}

// ================== Circular Percent Painter ==================
class _CircularPercentPainter extends CustomPainter {
  final double percent;
  final Color color;
  final Color trackColor;
  _CircularPercentPainter({required this.percent, required this.color, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.09;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * pi * percent.clamp(0, 1);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularPercentPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}