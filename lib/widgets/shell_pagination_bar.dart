import 'package:flutter/material.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';

class ShellPaginationBar extends StatelessWidget {
  final int page;
  final int pageSize;
  final int rowCount;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String showingResultsText;

  const ShellPaginationBar({
    super.key,
    required this.page,
    required this.pageSize,
    required this.rowCount,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    required this.showingResultsText,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (total / pageSize).ceil();
    final isFirst = page <= 0;
    final isLast = page >= totalPages - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: ShellTokens.chromeSurface,
        border: Border(top: BorderSide(color: ShellTokens.chromeBorder)),
      ),
      child: Row(
        children: [
          Text(
            showingResultsText,
            style: const TextStyle(fontSize: 11, color: ShellTokens.textSecondary),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(PhosphorIcons.caretLeft, size: 14),
            onPressed: isFirst ? null : onPrevious,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            color: ShellTokens.textSecondary,
          ),
          Text(
            '${page + 1}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ShellTokens.textPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.caretRight, size: 14),
            onPressed: isLast ? null : onNext,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            color: ShellTokens.textSecondary,
          ),
        ],
      ),
    );
  }
}
