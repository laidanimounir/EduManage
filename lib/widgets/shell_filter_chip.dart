import 'package:flutter/material.dart';
import '../constants/theme_tokens.dart';

class ShellFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ShellFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: Material(
        color: selected ? ShellTokens.accentMuted : ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? ShellTokens.textPrimary : ShellTokens.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
