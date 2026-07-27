import 'package:flutter/material.dart';

class ShellBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;
  final Color? borderColor;

  const ShellBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF3D2E18),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: borderColor ?? const Color(0xFF5C4626)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
