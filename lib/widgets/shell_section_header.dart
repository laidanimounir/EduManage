import 'package:flutter/material.dart';
import '../constants/theme_tokens.dart';

class ShellSectionHeader extends StatelessWidget {
  final String text;
  final bool withBorder;

  const ShellSectionHeader({
    super.key,
    required this.text,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: ShellTokens.textDisabled,
            letterSpacing: 0.3,
          ),
        ),
        if (withBorder)
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 8),
            child: Divider(height: 1, color: ShellTokens.chromeBorder),
          ),
      ],
    );
  }
}
