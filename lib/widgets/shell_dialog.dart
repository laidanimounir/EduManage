import 'package:flutter/material.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';

class ShellDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget body;
  final Widget? actions;
  final double maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onClose;

  const ShellDialog({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.actions,
    this.maxWidth = 520,
    this.maxHeight,
    this.contentPadding = const EdgeInsets.all(16),
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ShellTokens.chromeSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight ?? 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ShellTokens.chromeBorder)),
              ),
              child: Row(
                children: [
                  if (titleWidget != null)
                    Expanded(child: titleWidget!)
                  else if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ShellTokens.textPrimary,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  IconButton(
                    icon: const Icon(PhosphorIcons.x, size: 18, color: ShellTokens.textSecondary),
                    onPressed: onClose ?? () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: body,
              ),
            ),
            if (actions != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: ShellTokens.chromeBorder)),
                ),
                child: actions!,
              ),
          ],
        ),
      ),
    );
  }
}
