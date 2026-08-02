import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../repositories/student_repository.dart';
import 'app_empty_state.dart';
import 'shell_dialog.dart';
import 'shell_input_decoration.dart';

class StudentPickerDialog extends StatefulWidget {
  final AppDatabase database;

  const StudentPickerDialog({super.key, required this.database});

  @override
  State<StudentPickerDialog> createState() => _StudentPickerDialogState();
}

class _StudentPickerDialogState extends State<StudentPickerDialog> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _all = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final rows = await widget.database.getStudentPickerList();
      if (!mounted) return;
      setState(() {
        _all = rows;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((m) {
      final name = '${m['firstNameAr']} ${m['lastNameAr']} '
          '${m['firstNameFr'] ?? ''} ${m['lastNameFr'] ?? ''}'
          .toLowerCase();
      final code = (m['code'] as String).toLowerCase();
      return name.contains(q) || code.contains(q);
    }).toList();
  }

  Future<void> _pick(Map<String, dynamic> m) async {
    final student = await StudentRepository(widget.database).getById(m['id'] as String);
    if (!mounted || student == null) return;
    Navigator.pop(context, student);
  }

  String _levelLabel(String? level, AppLocalizations l10n) {
    switch (level) {
      case 'primary':
        return l10n.schoolLevelPrimary;
      case 'middle':
        return l10n.schoolLevelMiddle;
      case 'secondary':
        return l10n.schoolLevelSecondary;
      default:
        return level ?? '—';
    }
  }

  String _dayShort(int dayOfWeek, String locale) {
    const en = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const fr = ['', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const ar = ['', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    if (dayOfWeek < 1 || dayOfWeek > 7) return '';
    if (locale == 'ar') return ar[dayOfWeek];
    if (locale == 'fr') return fr[dayOfWeek];
    return en[dayOfWeek];
  }

  String _groupText(List<dynamic> groups, String locale) {
    return groups.map((g) {
      final gm = g as Map<String, dynamic>;
      final name = (gm['name'] as String?) ?? (gm['subject'] as String?) ?? '?';
      final day = _dayShort((gm['dayOfWeek'] as num).toInt(), locale);
      final t = gm['startTime'] as DateTime;
      final time = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      return '$name ($day $time)';
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final rows = _filtered;

    return ShellDialog(
      maxWidth: 760,
      title: l10n.selectStudent,
      body: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: ShellInputDecoration.textField(hintText: '${l10n.code} أو ${l10n.name}'),
          style: const TextStyle(fontSize: 12, color: ShellTokens.textPrimary),
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 8),
        if (_loading)
          const SizedBox(
            height: 120,
            child: Center(
              child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: ShellTokens.accent)),
            ),
          )
        else if (rows.isEmpty)
          SizedBox(height: 120, child: AppEmptyState(icon: PhosphorIcons.users, message: l10n.noData))
        else ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text('${rows.length} ${l10n.students}',
              style: const TextStyle(fontSize: 10, color: ShellTokens.textDisabled)),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _headerRow(l10n),
              Flexible(
                child: ListView.builder(
                  itemCount: rows.length,
                  itemExtent: 40,
                  itemBuilder: (_, i) => _row(rows[i], locale, l10n),
                ),
              ),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _headerRow(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(color: ShellTokens.chromeBase, border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder))),
      child: Row(children: [
        Expanded(flex: 3, child: Text(l10n.columnName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled))),
        SizedBox(width: 96, child: Text(l10n.schoolLevel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled))),
        Expanded(flex: 4, child: Text(l10n.groups, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled))),
        SizedBox(width: 90, child: Text(l10n.balance, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ShellTokens.textDisabled))),
      ]),
    );
  }

  Widget _row(Map<String, dynamic> m, String locale, AppLocalizations l10n) {
    final balance = (m['balance'] as num).toDouble();
    final groups = (m['groups'] as List<dynamic>);
    final groupText = groups.isEmpty ? '—' : _groupText(groups, locale);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _pick(m),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder, width: 0.5))),
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${m['firstNameAr']} ${m['lastNameAr']}',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ShellTokens.textPrimary)),
              Text(m['code'] as String, maxLines: 1, style: const TextStyle(fontSize: 9, color: ShellTokens.textSecondary)),
            ]),
          ),
          SizedBox(
            width: 96,
            child: Text(_levelLabel(m['schoolLevel'] as String?, l10n),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: ShellTokens.textSecondary)),
          ),
          Expanded(
            flex: 4,
            child: Tooltip(
              message: groupText,
              child: Text(groupText, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: ShellTokens.textPrimary)),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text('${balance.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
              textAlign: TextAlign.right, maxLines: 1,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: balance > 0 ? SemanticTokens.error : SemanticTokens.success)),
          ),
        ]),
      ),
    );
  }
}
