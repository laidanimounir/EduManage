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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revenue = _metrics['revenue'] ?? 0;
    final expenses = _metrics['expenses'] ?? 0;
    final outstanding = _metrics['outstanding'] ?? 0;
    final net = revenue - expenses;
    final prevRevenue = _prevMetrics['revenue'] ?? 0;
    final prevExpenses = _prevMetrics['expenses'] ?? 0;
    final prevOutstanding = _prevMetrics['outstanding'] ?? 0;
    final prevNet = prevRevenue - prevExpenses;

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
                  TextButton(onPressed: _loadStats, child: const Text('Retry')),
                ]))
              : SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final kpiCols = width >= 1400 ? 4 : (width >= 1024 ? 3 : 2);
                      final chartCols = width >= 1024 ? 2 : 1;

                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          _buildTopBar(l10n, width),
                          if (_alerts.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _buildAlertsSection(),
                          ],
                          const SizedBox(height: 12),
                          _buildKpiGrid(l10n, kpiCols, revenue, prevRevenue, expenses, prevExpenses, net, prevNet, outstanding, prevOutstanding),
                          const SizedBox(height: 12),
                          _buildChartsGrid(chartCols),
                          const SizedBox(height: 12),
                          _buildFinancialDetails(revenue, outstanding, net),
                          const SizedBox(height: 10),
                          _buildBillingHealth(),
                          const SizedBox(height: 10),
                          _buildTeacherSummary(),
                          const SizedBox(height: 10),
                          _buildEnrollmentTrend(),
                          const SizedBox(height: 10),
                          _buildClassroomUtilization(),
                          const SizedBox(height: 10),
                          _buildKeyRatios(revenue, outstanding, net),
                          if (_liveSessions.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _buildLiveSection(),
                          ],
                          const SizedBox(height: 10),
                          _buildChartCard('Debt Aging', DashboardDonutChart(database: widget.database, type: 'debt_aging')),
                          const SizedBox(height: 10),
                          Card(color: ShellTokens.chromeSurface, child: Padding(padding: const EdgeInsets.all(12), child: DashboardHeatmap(database: widget.database))),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n, double width) {
    final stacked = width < 1100;
    final dateFilter = _buildDateFilter(l10n);
    final quickActions = _buildQuickActions(l10n);
    if (stacked) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        dateFilter,
        const SizedBox(height: 8),
        quickActions,
      ]);
    }
    return Row(children: [
      dateFilter,
      const SizedBox(width: 16),
      Expanded(child: quickActions),
    ]);
  }

  Widget _buildDateFilter(AppLocalizations l10n) {
    String fmtDt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _buildDateBtn(l10n.from, _dateFrom, (d) { setState(() => _dateFrom = d); _loadStats(); }, fmtDt),
      const SizedBox(width: 8),
      _buildDateBtn(l10n.to, _dateTo, (d) { setState(() => _dateTo = d); _loadStats(); }, fmtDt),
      if (_dateFrom != null || _dateTo != null) ...[
        const SizedBox(width: 4),
        IconButton(icon: const Icon(PhosphorIcons.x, size: 14, color: ShellTokens.textSecondary),
          onPressed: () { setState(() { _dateFrom = null; _dateTo = null; }); _loadStats(); },
          padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 24, minHeight: 24)),
      ],
    ]);
  }

  Widget _buildDateBtn(String label, DateTime? value, ValueChanged<DateTime> onPick, String Function(DateTime) fmt) {
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
          value != null ? fmt(value) : label,
          style: TextStyle(fontSize: 11, color: value != null ? ShellTokens.textPrimary : ShellTokens.textDisabled))),
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations l10n) {
    return SizedBox(
      height: 44,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        _actionBtn(PhosphorIcons.currencyCircleDollar, 'Record Payment', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UnifiedPaymentScreen(database: widget.database)));
        }),
        _actionBtn(PhosphorIcons.checkCircle, l10n.checkIn, () {}),
        _actionBtn(PhosphorIcons.chalkboardTeacher, 'Pay Teacher', () {}),
        _actionBtn(PhosphorIcons.plus, 'New Student', () {}),
        _actionBtn(PhosphorIcons.calendar, 'Today', () {}),
      ]),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(borderRadius: BorderRadius.circular(8), onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 16, color: ShellTokens.accent),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Icon(PhosphorIcons.warning, size: 14, color: SemanticTokens.warning),
            const SizedBox(width: 6),
            const Text('Needs Attention', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          ]),
          const SizedBox(height: 4),
          ..._alerts.take(3).map((a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              Icon(a['icon'] as IconData, size: 12, color: a['color'] as Color),
              const SizedBox(width: 6),
              Expanded(child: Text(a['text'] as String, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const Icon(PhosphorIcons.caretRight, size: 10, color: ShellTokens.textDisabled),
            ]),
          )),
          if (_alerts.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('+${_alerts.length - 3} more', style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
            ),
        ]),
      ),
    );
  }

  Widget _buildKpiGrid(AppLocalizations l10n, int columns, double revenue, double prevRevenue, double expenses, double prevExpenses, double net, double prevNet, double outstanding, double prevOutstanding) {
    final cards = [
      _kpiCard(l10n.totalStudents, _totalStudents.toDouble(), PhosphorIcons.users, ShellTokens.accent),
      _kpiCard(l10n.totalTeachers, _totalTeachers.toDouble(), PhosphorIcons.chalkboardTeacher, const Color(0xFF5B8C5A)),
      _kpiCard('Revenue', revenue, PhosphorIcons.trendUp, SemanticTokens.success, prevValue: prevRevenue, suffix: AppConstants.currencySymbol),
      _kpiCard('Expenses', expenses, PhosphorIcons.currencyCircleDollar, SemanticTokens.error, prevValue: prevExpenses, suffix: AppConstants.currencySymbol),
      _kpiCard('Net', net, PhosphorIcons.chartBar, net >= 0 ? SemanticTokens.success : SemanticTokens.error, prevValue: prevNet, suffix: AppConstants.currencySymbol),
      _kpiCard(l10n.outstandingDebts, outstanding, PhosphorIcons.wallet, outstanding > 0 ? const Color(0xFFC2483D) : SemanticTokens.success, prevValue: prevOutstanding, suffix: AppConstants.currencySymbol),
    ];

    final grid = <Widget>[];
    for (var i = 0; i < cards.length; i += columns) {
      final row = <Widget>[];
      for (var j = i; j < i + columns && j < cards.length; j++) {
        row.add(Expanded(child: cards[j]));
        if (j < i + columns - 1) row.add(const SizedBox(width: 8));
      }
      grid.add(Row(children: row));
      if (i + columns < cards.length) grid.add(const SizedBox(height: 8));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: grid);
  }

  Widget _kpiCard(String label, double value, IconData icon, Color color, {double prevValue = 0, String suffix = ''}) {
    final trendLabel = prevValue != 0 ? _trendLabel(value, prevValue) : '';
    final trendColor = prevValue != 0 ? _trendColor(value, prevValue) : ChartTokens.trendNeutral;
    final trendIcon = prevValue != 0 ? _trendIcon(value, prevValue) : null;

    return SizedBox(
      height: 96,
      child: Card(
        color: ShellTokens.chromeSurface,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 3),
            _AnimatedNumber(value: value, suffix: suffix, color: color, fontSize: 16),
            const SizedBox(height: 1),
            Text(label, style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (trendLabel.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(mainAxisSize: MainAxisSize.min, children: [
                if (trendIcon != null) Icon(trendIcon, size: 10, color: trendColor),
                if (trendIcon != null) const SizedBox(width: 2),
                Text(trendLabel.startsWith('-') ? trendLabel.substring(1) : trendLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: trendColor)),
              ]),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _buildChartsGrid(int columns) {
    final charts = [
      _buildChartCard('Monthly Revenue vs Expenses', DashboardBarChart(database: widget.database)),
      _buildChartCard('Revenue Trend', DashboardLineChart(database: widget.database)),
      _buildChartCard('Payment Methods', DashboardDonutChart(database: widget.database, type: 'payment_method')),
      _buildChartCard('Students by Level', DashboardDonutChart(database: widget.database, type: 'student_level')),
    ];

    if (columns == 1) {
      return Column(children: charts.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: c)).toList());
    }
    return Column(children: [
      Row(children: [Expanded(child: charts[0]), const SizedBox(width: 10), Expanded(child: charts[1])]),
      const SizedBox(height: 10),
      Row(children: [Expanded(child: charts[2]), const SizedBox(width: 10), Expanded(child: charts[3])]),
    ]);
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          SizedBox(height: 200, child: ClipRect(child: chart)),
        ]),
      ),
    );
  }

  Widget _buildFinancialDetails(double revenue, double outstanding, double net) {
    final avgRevenue = _activeStudentCount > 0 ? (revenue / _activeStudentCount) : 0.0;
    final netAfterDiscounts = net - _familyDiscount;
    return _sectionCard('Financial Details', [
      _finRow('Collection Rate', _collectionRateLabel),
      _finRow('Family Discounts', '${_familyDiscount.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
      _finRow('Net After Discounts', '${netAfterDiscounts.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
      _finRow('Avg Revenue / Student', '${avgRevenue.toStringAsFixed(0)} ${AppConstants.currencySymbol}'),
      _finRow('Active Students', '$_activeStudentCount'),
    ]);
  }

  Widget _buildBillingHealth() {
    final open = _billingHealth['openCycles'] ?? 0;
    final closed = _billingHealth['closedCycles'] ?? 0;
    final mid = _billingHealth['midCycleStudents'] ?? 0;
    return _sectionCard('Billing Cycle Health', [
      Row(children: [
        _healthStat('Open Cycles', '$open', SemanticTokens.warning),
        _healthStat('Closed Cycles', '$closed', SemanticTokens.success),
        _healthStat('Mid-Cycle', '$mid', ShellTokens.accent),
      ]),
    ]);
  }

  Widget _buildTeacherSummary() {
    final topTeachers = _teacherSummary['topOverdueTeachers'] as List? ?? [];
    return _sectionCard('Teacher Payouts', [
      Text('Total Payouts: ${(_teacherSummary['totalPayouts'] as double?)?.toStringAsFixed(0) ?? '0'} ${AppConstants.currencySymbol}', style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
      if (topTeachers.isNotEmpty) ...[
        const SizedBox(height: 4),
        const Text('Nearest to Overdue:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ShellTokens.textDisabled)),
        const SizedBox(height: 2),
        ...topTeachers.take(5).map((t) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text('${t['name']} (${t['code']})', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
        )),
      ],
    ]);
  }

  Widget _buildEnrollmentTrend() {
    final newE = _enrollmentTrend['newEnrollments'] ?? 0;
    final dropped = _enrollmentTrend['dropped'] ?? 0;
    return _sectionCard('Enrollment Trend', [
      Row(children: [
        _healthStat('New', '$newE', SemanticTokens.success),
        _healthStat('Dropped', '$dropped', SemanticTokens.error),
        _healthStat('Net', '${newE - dropped}', newE - dropped >= 0 ? SemanticTokens.success : SemanticTokens.error),
      ]),
    ]);
  }

  Widget _buildClassroomUtilization() {
    return _sectionCard('Classroom Utilization', [
      ..._classrooms.take(8).map((c) {
        final capacity = (c['capacity'] as int?) ?? 1;
        final sessions = (c['sessionCount'] as int?) ?? 0;
        final pct = capacity > 0 ? (sessions * 100 ~/ capacity).clamp(0, 100).toDouble() / 100 : 0.0;
        final isLow = pct < 0.2;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            SizedBox(width: 80, child: Text(c['name'] ?? '', style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 6),
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: pct, minHeight: 6, backgroundColor: ShellTokens.chromeBorder, color: isLow ? SemanticTokens.warning : SemanticTokens.success),
            )),
            const SizedBox(width: 6),
            Text('$sessions/$capacity', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled)),
            if (isLow) Container(
              margin: const EdgeInsetsDirectional.only(start: 4),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(color: SemanticTokens.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(2)),
              child: const Text('low', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600, color: SemanticTokens.warning)),
            ),
          ]),
        );
      }),
    ]);
  }

  Widget _buildKeyRatios(double revenue, double outstanding, double net) {
    final collectionRate = revenue > 0 ? ((revenue - outstanding) / revenue).clamp(0, 1).toDouble() : 0.0;
    final netMargin = revenue > 0 ? (net / revenue).clamp(-1, 1).toDouble() : 0.0;
    final activeRatio = _totalStudents > 0 ? (_activeStudentCount / _totalStudents).clamp(0, 1).toDouble() : 0.0;

    return Card(
      color: ShellTokens.chromeSurface,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Key Ratios', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: Row(children: [
              Expanded(child: _AnimatedCircularPercent(label: 'Collection Rate', percent: collectionRate, color: SemanticTokens.success)),
              const SizedBox(width: 8),
              Expanded(child: _AnimatedCircularPercent(label: 'Net Margin', percent: netMargin.abs(), color: net >= 0 ? SemanticTokens.success : SemanticTokens.error, negative: net < 0)),
              const SizedBox(width: 8),
              Expanded(child: _AnimatedCircularPercent(label: 'Active Students', percent: activeRatio, color: ShellTokens.accent)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildLiveSection() {
    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: SemanticTokens.success, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('Live Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          ]),
          const SizedBox(height: 6),
          SizedBox(
            height: 58,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _liveSessions.length,
              itemBuilder: (_, i) {
                final s = _liveSessions[i];
                return Container(
                  width: 200,
                  margin: const EdgeInsetsDirectional.only(end: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: ShellTokens.chromeBase.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(6), border: Border.all(color: SemanticTokens.success.withValues(alpha: 0.3))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(children: [
                      Expanded(child: Text(s['groupName'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 4),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: SemanticTokens.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)), child: const Text('Live', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: SemanticTokens.success))),
                    ]),
                    const SizedBox(height: 2),
                    Text('${s['time'] ?? ''} · ${s['teacherName'] ?? ''}', style: const TextStyle(fontSize: 9, color: ShellTokens.textDisabled), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${s['attendance']} present', style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary)),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Card(
      color: ShellTokens.chromeSurface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
          const SizedBox(height: 6),
          ...children,
        ]),
      ),
    );
  }

  Widget _finRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
      ]),
    );
  }

  Widget _healthStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

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
              painter: _CircularPercentPainter(percent: _anim.value, color: widget.color, trackColor: ShellTokens.chromeBorder),
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
        Text(widget.label, style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
      ]);
    });
  }
}

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
