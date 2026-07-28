import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/chart_tokens.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';

class DashboardBarChart extends StatefulWidget {
  final AppDatabase database;
  const DashboardBarChart({super.key, required this.database});
  @override
  State<DashboardBarChart> createState() => _DashboardBarChartState();
}

class _DashboardBarChartState extends State<DashboardBarChart> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      _data = await widget.database.getMonthlyRevenueAndExpenses(6);
      if (mounted) setState(() => _loading = false);
      _animCtrl.forward();
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load chart'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingWidget();
    if (_error != null) return _errorWidget();
    if (_data.isEmpty) return _emptyWidget();

    const monthLabels = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return AspectRatio(
      aspectRatio: 1.6,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _data.fold<double>(0, (s, d) => max(s, max((d['revenue'] as double?) ?? 0, (d['expenses'] as double?) ?? 0))) * 1.2,
            barGroups: _data.asMap().entries.map((e) {
              final rev = ((e.value['revenue'] as double?) ?? 0) * _anim.value;
              final exp = ((e.value['expenses'] as double?) ?? 0) * _anim.value;
              return BarChartGroupData(x: e.key, barRods: [
                BarChartRodData(toY: rev, color: ChartTokens.seriesPalette[0], width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                BarChartRodData(toY: exp, color: ChartTokens.seriesPalette[2], width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
              ]);
            }).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, _) {
                final idx = v.toInt();
                final month = idx >= 0 && idx < _data.length ? (_data[idx]['month'] as int?) : null;
                return Text(monthLabels[month ?? 1], style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel));
              })),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36, getTitlesWidget: (v, _) => Text('${v.toInt()}', style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel)))),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (_) => FlLine(color: ChartTokens.gridLine, strokeWidth: 0.5)),
            borderData: FlBorderData(show: false),
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget _loadingWidget() => const SizedBox(height: 180, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
  Widget _errorWidget() => SizedBox(height: 180, child: Center(child: Text(_error!, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
  Widget _emptyWidget() => const SizedBox(height: 180, child: Center(child: Text('No data', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
}

class DashboardLineChart extends StatefulWidget {
  final AppDatabase database;
  const DashboardLineChart({super.key, required this.database});
  @override
  State<DashboardLineChart> createState() => _DashboardLineChartState();
}

class _DashboardLineChartState extends State<DashboardLineChart> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      _data = await widget.database.getMonthlyTrend(6);
      if (mounted) setState(() => _loading = false);
      _animCtrl.forward();
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load chart'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingWidget();
    if (_error != null) return _errorWidget();
    if (_data.isEmpty) return _emptyWidget();

    const monthLabels = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return AspectRatio(
      aspectRatio: 1.6,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), ((e.value['revenue'] as double?) ?? 0) * _anim.value)).toList(),
                color: ChartTokens.seriesPalette[0], barWidth: 2, dotData: const FlDotData(show: false), isCurved: true, preventCurveOverShooting: true,
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, _) => Text(monthLabels[(v.toInt() < _data.length ? (_data[v.toInt()]['month'] as int?) : DateTime.now().month) ?? (v.toInt() + 1)], style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel)))),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36, getTitlesWidget: (v, _) => v % 1 == 0 ? Text('${v.toInt()}', style: const TextStyle(fontSize: 9, color: ChartTokens.axisLabel)) : const SizedBox.shrink())),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (_) => FlLine(color: ChartTokens.gridLine, strokeWidth: 0.5)),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(getTooltipItems: (spots) => spots.map((s) => LineTooltipItem('${s.y.toStringAsFixed(0)} DA', const TextStyle(color: ChartTokens.tooltipText, fontSize: 10))).toList())),
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget _loadingWidget() => const SizedBox(height: 180, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
  Widget _errorWidget() => SizedBox(height: 180, child: Center(child: Text(_error!, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
  Widget _emptyWidget() => const SizedBox(height: 180, child: Center(child: Text('No data', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
}

class DashboardDonutChart extends StatefulWidget {
  final AppDatabase database;
  final String type;
  const DashboardDonutChart({super.key, required this.database, required this.type});
  @override
  State<DashboardDonutChart> createState() => _DashboardDonutChartState();
}

class _DashboardDonutChartState extends State<DashboardDonutChart> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      final now = DateTime.now();
      switch (widget.type) {
        case 'payment_method':
          _data = await widget.database.getRevenueByPaymentMethod(DateTime(now.year, 1, 1), now);
          _data = _data.map((d) => {'label': _methodLabel(d['method'] as String), 'value': d['total']}).toList();
        case 'student_level':
          _data = await widget.database.getStudentCountByLevel();
          _data = _data.map((d) => {'label': _levelLabel(d['level'] as String), 'value': d['count']}).toList();
        case 'debt_aging':
          _data = await widget.database.getDebtByAgingBucket();
          _data = _data.map((d) => {'label': d['label'], 'value': d['count']}).toList();
      }
      if (mounted) setState(() => _loading = false);
      _animCtrl.forward();
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load chart'; });
    }
  }

  String _methodLabel(String m) => switch (m) { 'cash' => 'Cash', 'card' => 'Card', 'bank_transfer' => 'Bank', 'mobile_payment' => 'Mobile', _ => m };
  String _levelLabel(String l) => switch (l) { 'primary' => 'Primary', 'middle' => 'Middle', 'secondary' => 'Secondary', _ => l };

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingWidget();
    if (_error != null) return _errorWidget();
    if (_data.isEmpty) return _emptyWidget();

    final total = _data.fold<double>(0, (s, d) => s + ((d['value'] as num?)?.toDouble() ?? 0));
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => PieChart(
          PieChartData(
            sections: _data.asMap().entries.map((e) {
              final val = ((e.value['value'] as num?)?.toDouble() ?? 0) * _anim.value;
              return PieChartSectionData(
                value: max(val, 0.01),
                color: ChartTokens.seriesPalette[e.key % ChartTokens.seriesPalette.length],
                radius: 40,
                title: total > 0 ? '${(val / total * 100).toStringAsFixed(0)}%' : '',
                titleStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
              );
            }).toList(),
            sectionsSpace: 2,
            centerSpaceRadius: 30,
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }

  Widget _loadingWidget() => const SizedBox(height: 160, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
  Widget _errorWidget() => SizedBox(height: 160, child: Center(child: Text(_error!, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
  Widget _emptyWidget() => const SizedBox(height: 160, child: Center(child: Text('No data', style: TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));
}

class DashboardHeatmap extends StatefulWidget {
  final AppDatabase database;
  const DashboardHeatmap({super.key, required this.database});
  @override
  State<DashboardHeatmap> createState() => _DashboardHeatmapState();
}

class _DashboardHeatmapState extends State<DashboardHeatmap> {
  Map<int, Map<int, int>> _data = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      _data = await widget.database.getSessionHeatmap();
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = 'Failed to load chart'; });
    }
  }

  Color _heatColor(int count) {
    if (count == 0) return ChartTokens.heatmapEmpty;
    if (count <= 1) return ChartTokens.heatmapLow;
    if (count <= 2) return ChartTokens.heatmapMedium;
    if (count <= 3) return ChartTokens.heatmapHigh;
    return ChartTokens.heatmapMax;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 140, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
    if (_error != null) return SizedBox(height: 100, child: Center(child: Text(_error!, style: const TextStyle(fontSize: 11, color: ShellTokens.textDisabled))));

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final hours = <int>{};
    for (final byHour in _data.values) { hours.addAll(byHour.keys); }
    final sortedHours = hours.toList()..sort();
    if (sortedHours.isEmpty) sortedHours.addAll([8, 10, 12, 14, 16, 18, 20]);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Session Heatmap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
      const SizedBox(height: 6),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Table(
        defaultColumnWidth: const FixedColumnWidth(36),
        border: TableBorder.all(color: ShellTokens.chromeBorder.withValues(alpha: 0.2), width: 0.5),
        children: [
          TableRow(children: [
            const SizedBox(width: 44, child: Text('', style: TextStyle(fontSize: 8))),
            ...sortedHours.map((h) => SizedBox(width: 36, child: Text('${h}h', textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: ChartTokens.axisLabel)))),
          ]),
          ...days.map((day) => TableRow(children: [
            SizedBox(width: 44, child: Text(day, style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary))),
            ...sortedHours.map((h) => Container(
              height: 24,
              color: _heatColor(_data[days.indexOf(day) + 1]?[h] ?? 0),
              child: Center(child: Text('${_data[days.indexOf(day) + 1]?[h] ?? 0}', style: const TextStyle(fontSize: 8, color: ShellTokens.textDisabled))),
            )),
          ])),
        ],
      )),
    ]);
  }
}

class _loadingWidget extends StatelessWidget {
  const _loadingWidget();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 180, child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent))));
}
