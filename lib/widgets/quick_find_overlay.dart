import 'package:flutter/material.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';

class QuickFindOverlay extends StatefulWidget {
  final AppDatabase database;
  final AppLocalizations l10n;

  const QuickFindOverlay({
    super.key,
    required this.database,
    required this.l10n,
  });

  @override
  State<QuickFindOverlay> createState() => _QuickFindOverlayState();
}

class _QuickFindOverlayState extends State<QuickFindOverlay> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  hintStyle: const TextStyle(color: ShellTokens.textDisabled),
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
                    borderSide: const BorderSide(color: ShellTokens.chromeBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: ShellTokens.chromeBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: ShellTokens.accent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Divider(height: 1, color: ShellTokens.chromeBorder),
            Flexible(
              child: _controller.text.isEmpty
                  ? Padding(
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
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ShellTokens.accent,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
