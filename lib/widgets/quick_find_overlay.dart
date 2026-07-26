import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../repositories/student_repository.dart';

class QuickFindOverlay extends StatefulWidget {
  final AppDatabase database;
  final AppLocalizations l10n;
  final ValueChanged<String> onStudentSelected;

  const QuickFindOverlay({
    super.key,
    required this.database,
    required this.l10n,
    required this.onStudentSelected,
  });

  @override
  State<QuickFindOverlay> createState() => _QuickFindOverlayState();
}

class _QuickFindOverlayState extends State<QuickFindOverlay> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final StudentRepository _repo;
  List<_QuickFindResult> _results = [];
  bool _loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _repo = StudentRepository(widget.database);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    _debounce?.cancel();
    if (text.trim().isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 200), () => _search(text));
  }

  Future<void> _search(String query) async {
    final students = await _repo.search(query);
    final results = <_QuickFindResult>[];
    for (final s in students) {
      final balance = await widget.database.getStudentBalance(s.id);
      results.add(_QuickFindResult(student: s, balance: balance));
    }
    if (mounted) {
      setState(() {
        _results = results;
        _loading = false;
      });
    }
  }

  void _selectResult(_QuickFindResult result) {
    widget.onStudentSelected(result.student.code);
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (_) => Navigator.of(context).pop(),
        ),
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 520,
          constraints: const BoxConstraints(maxHeight: 480),
          decoration: BoxDecoration(
            color: ShellTokens.chromeSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ShellTokens.chromeBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    color: ShellTokens.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.l10n.quickFindPlaceholder,
                    hintStyle:
                        const TextStyle(color: ShellTokens.textDisabled),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ShellTokens.textSecondary,
                      size: 18,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: ShellTokens.chromeBase,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Esc',
                            style: TextStyle(
                              color: ShellTokens.textDisabled,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: ShellTokens.chromeBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: ShellTokens.chromeBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: ShellTokens.accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  onChanged: _onTextChanged,
                ),
              ),
              const Divider(height: 1, color: ShellTokens.chromeBorder),
              Flexible(
                child: _buildResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: ShellTokens.accent,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (_controller.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            widget.l10n.quickFindPlaceholder,
            style: const TextStyle(
              color: ShellTokens.textDisabled,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            widget.l10n.noResults,
            style: const TextStyle(
              color: ShellTokens.textDisabled,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: _results.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: ShellTokens.chromeBorder),
      itemBuilder: (context, i) {
        final r = _results[i];
        final s = r.student;
        final name = '${s.firstNameAr} ${s.lastNameAr}';
        final balance = r.balance;

        return InkWell(
          onTap: () => _selectResult(r),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ShellTokens.chromeBase,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    s.code,
                    style: const TextStyle(
                      color: ShellTokens.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: ShellTokens.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.code,
                        style: const TextStyle(
                          color: ShellTokens.textDisabled,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${balance >= 0 ? "" : "-"}${balance.abs().toStringAsFixed(0)} DA',
                  style: TextStyle(
                    color: balance < 0
                        ? const Color(0xFFC2483D)
                        : balance > 0
                            ? ShellTokens.accent
                            : ShellTokens.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickFindResult {
  final Student student;
  final double balance;
  const _QuickFindResult({required this.student, required this.balance});
}
