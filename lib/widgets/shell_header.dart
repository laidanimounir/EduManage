import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart' show PhosphorIconsRegular;
import '../constants/theme_tokens.dart';
import '../l10n/app_localizations.dart';

class ShellHeader extends StatelessWidget {
  final String title;
  final String userId;
  final String userRole;
  final VoidCallback onLogout;
  final VoidCallback onQuickFind;
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const ShellHeader({
    super.key,
    required this.title,
    required this.userId,
    required this.userRole,
    required this.onLogout,
    required this.onQuickFind,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final canPop = Navigator.of(context).canPop();
    final now = DateTime.now();
    final dateStr = _formatDate(now, l10n);

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: ShellTokens.chromeBase,
        border: Border(
          bottom: BorderSide(color: ShellTokens.chromeBorder, width: 1),
        ),
      ),
      padding: const EdgeInsetsDirectional.only(start: 8, end: 12),
      child: Row(
        children: [
          if (canPop)
            _HeaderIconButton(
              icon: isRtl
                  ? PhosphorIconsRegular.arrowRight
                  : PhosphorIconsRegular.arrowLeft,
              tooltip: l10n.back,
              onTap: () => Navigator.of(context).pop(),
            ),
          if (!canPop)
            const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: ShellTokens.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          _HeaderIconButton(
            icon: PhosphorIconsRegular.magnifyingGlass,
            tooltip: '${l10n.quickFind} (Ctrl+K)',
            onTap: onQuickFind,
          ),
          const Spacer(),
          _OfflineBadge(l10n: l10n),
          const SizedBox(width: 12),
          Text(
            dateStr,
            style: const TextStyle(
              color: ShellTokens.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 12),
          _LanguageSwitch(
            currentLocale: currentLocale,
            onLocaleChanged: onLocaleChanged,
          ),
          const SizedBox(width: 8),
          _UserBlock(userId: userId, userRole: userRole),
          const SizedBox(width: 4),
          _HeaderIconButton(
            icon: PhosphorIconsRegular.signOut,
            tooltip: l10n.logout,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d, AppLocalizations l10n) {
    final months = _monthNames(l10n);
    final month = months[d.month - 1];
    return '$month ${d.day}, ${d.year}';
  }

  List<String> _monthNames(AppLocalizations l10n) {
    return [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
  }
}

class _OfflineBadge extends StatelessWidget {
  final AppLocalizations l10n;
  const _OfflineBadge({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ShellTokens.chromeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ShellTokens.chromeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF6B6B63),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.offlineMode,
            style: const TextStyle(
              color: ShellTokens.textDisabled,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const _LanguageSwitch({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = currentLocale.languageCode;

    return SizedBox(
      height: 26,
      child: ToggleButtons(
        constraints: const BoxConstraints(minWidth: 36, minHeight: 26),
        borderRadius: BorderRadius.circular(5),
        borderColor: ShellTokens.chromeBorder,
        selectedBorderColor: ShellTokens.accent,
        fillColor: ShellTokens.accentMuted,
        color: ShellTokens.textSecondary,
        selectedColor: ShellTokens.textPrimary,
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        isSelected: [lang == 'ar', lang == 'fr'],
        onPressed: (i) {
          final newLocale = i == 0 ? const Locale('ar') : const Locale('fr');
          onLocaleChanged(newLocale);
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(l10n.arabic.substring(0, 2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(l10n.francais.substring(0, 2)),
          ),
        ],
      ),
    );
  }
}

class _UserBlock extends StatelessWidget {
  final String userId;
  final String userRole;

  const _UserBlock({required this.userId, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final initial = userId.isNotEmpty ? userId[0].toUpperCase() : '?';
    final roleLabel = userRole.isNotEmpty
        ? '${userRole[0].toUpperCase()}${userRole.substring(1)}'
        : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: ShellTokens.accentMuted,
          child: Text(
            initial,
            style: const TextStyle(
              color: ShellTokens.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userId,
              style: const TextStyle(
                color: ShellTokens.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              roleLabel,
              style: const TextStyle(
                color: ShellTokens.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 18,
              color: ShellTokens.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
