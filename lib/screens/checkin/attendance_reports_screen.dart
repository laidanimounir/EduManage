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
import '../../database/app_database.dart';
import '../../repositories/subject_group_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/shell_dialog.dart';

class AttendanceReportsScreen extends StatefulWidget {
  final AppDatabase database;
  const AttendanceReportsScreen({super.key, required this.database});
  @override
  State<AttendanceReportsScreen> createState() => _AttendanceReportsScreenState();
}

class _AttendanceReportsScreenState extends State<AttendanceReportsScreen> {
  List<Map<String, dynamic>> _groups = [];
  String? _selectedGroupId;
  List<Map<String, dynamic>> _results = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final groups = await SubjectGroupRepository(widget.database).getAll();
    final active = groups.where((g) => !g.isArchived).toList();
    if (mounted) setState(() { _groups = active.map((g) => {'id': g.id, 'name': g.nameAr}).toList(); _loading = false; });
  }

  Future<void> _loadReport() async {
    if (_selectedGroupId == null) return;
    setState(() => _loading = true);
    final now = DateTime.now();
    final results = <Map<String, dynamic>>[];
    for (var i = 0; i < 6; i++) {
      final m = now.month - i;
      final y = m <= 0 ? now.year - 1 : now.year;
      final month = m <= 0 ? 12 + m : m;
      try {
        final rate = await widget.database.getMonthlyAttendanceRate(_selectedGroupId!, y, month);
        results.add({'year': y, 'month': month, 'rate': rate, 'label': '$y-${month.toString().padLeft(2, '0')}'});
      } catch (_) {
        results.add({'year': y, 'month': month, 'rate': 0.0, 'label': '$y-${month.toString().padLeft(2, '0')}'});
      }
    }
    if (mounted) setState(() { _results = results.reversed.toList(); _loading = false; });
  }

  Future<void> _exportPdf() async {
    if (_results.isEmpty) return;
    final pdf = pw.Document();
    final group = _groups.cast<Map<String, dynamic>>().where((g) => g['id'] == _selectedGroupId).firstOrNull;
    final groupName = (group?['name'] as String?) ?? 'Report';
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (_) => [
        pw.Header(text: 'Attendance Report — $groupName', level: 1),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Month', 'Rate %'],
          data: _results.map((r) => [r['label'] as String, '${(r['rate'] as double).toStringAsFixed(0)}%']).toList(),
        ),
      ],
    ));
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _exportExcel() async {
    if (_results.isEmpty) return;
    final excel = Excel.createExcel();
    final sheet = excel['Attendance'];
    sheet.appendRow([TextCellValue('Month'), TextCellValue('Rate %')]);
    for (final r in _results) {
      sheet.appendRow([TextCellValue(r['label'] as String), TextCellValue('${(r['rate'] as double).toStringAsFixed(0)}%')]);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/attendance_report.xlsx');
    await file.writeAsBytes(excel.encode()!);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved: ${file.path}'), backgroundColor: ShellTokens.chromeSurface));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ContentTokens.background,
      body: _loading && _selectedGroupId != null
          ? const AppLoading()
          : Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                decoration: const BoxDecoration(color: ShellTokens.chromeSurface, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
                child: Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGroupId,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), border: OutlineInputBorder()),
                      hint: const Text('Select Group', style: TextStyle(fontSize: 12, color: ShellTokens.textDisabled)),
                      items: _groups.map((g) => DropdownMenuItem(value: g['id'] as String, child: Text(g['name'] as String, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) { setState(() => _selectedGroupId = v); _loadReport(); },
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(icon: const Icon(PhosphorIcons.file, size: 16, color: ShellTokens.textSecondary), onPressed: _exportPdf, tooltip: 'Export PDF'),
                  IconButton(icon: const Icon(PhosphorIcons.table, size: 16, color: ShellTokens.textSecondary), onPressed: _exportExcel, tooltip: 'Export Excel'),
                ]),
              ),
              Expanded(
                child: _selectedGroupId == null
                    ? const Center(child: Text('Select a subject group to view attendance', style: TextStyle(fontSize: 12, color: ShellTokens.textDisabled)))
                    : _results.isEmpty
                        ? const Center(child: Text('No data', style: TextStyle(fontSize: 12, color: ShellTokens.textDisabled)))
                        : ListView(padding: const EdgeInsets.all(12), children: _results.map((r) {
                            final rate = (r['rate'] as double);
                            final color = rate >= 80 ? SemanticTokens.success : rate >= 50 ? SemanticTokens.warning : SemanticTokens.error;
                            return Card(
                              color: ShellTokens.chromeSurface,
                              child: ListTile(
                                title: Text(r['label'] as String, style: const TextStyle(fontSize: 13, color: ShellTokens.textPrimary)),
                                subtitle: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: rate / 100, minHeight: 6, backgroundColor: ShellTokens.chromeBorder, color: color)),
                                trailing: Text('${rate.toStringAsFixed(0)}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
                              ),
                            );
                          }).toList()),
              ),
            ]),
    );
  }
}
