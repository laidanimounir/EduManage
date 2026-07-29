import 'package:flutter/material.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../l10n/app_localizations.dart';
import '../utils/date_helper.dart';

class ShellHeader extends StatelessWidget {
  final String title;
  final String userName;
  final String userRole;
  final String? displayName;
  final VoidCallback onLogout;
  final VoidCallback onQuickFind;
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const ShellHeader({
    super.key,
    required this.title,
    required this.userName,
    required this.userRole,
    this.displayName,
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
    final dateStr = DateHelper.formatHeaderDate(now, currentLocale.languageCode);

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: ShellTokens.chromeBase,
        border: Border(
          bottom: BorderSide(color: ShellTokens.chromeBorder, width: 1),
        ),
      ),
      padding: const EdgeInsetsDirectional.only(start: 10, end: 14),
      child: Row(
        children: [
          if (canPop)
            _HeaderIconButton(
              icon: isRtl
                  ? PhosphorIcons.arrowRight
                  : PhosphorIcons.arrowLeft,
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
          const SizedBox(width: 20),
          _HeaderIconButton(
            icon: PhosphorIcons.magnifyingGlass,
            tooltip: '${l10n.quickFind} (Ctrl+K)',
            onTap: onQuickFind,
          ),
          const Spacer(),
          _OfflineBadge(l10n: l10n),
          const SizedBox(width: 16),
          Text(
            dateStr,
            style: const TextStyle(
              color: ShellTokens.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          _LanguageSwitch(
            currentLocale: currentLocale,
            onLocaleChanged: onLocaleChanged,
          ),
          const SizedBox(width: 12),
          _UserBlock(userName: userName, userRole: userRole, displayName: displayName),
          const SizedBox(width: 6),
          _HeaderIconButton(
            icon: PhosphorIcons.signOut,
            tooltip: l10n.logout,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  final AppLocalizations l10n;
  const _OfflineBadge({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 8, end: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2416),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D3520)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFC2823A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.offlineMode,
            style: const TextStyle(
              color: Color(0xFFC2823A),
              fontSize: 10,
              fontWeight: FontWeight.w500,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Text('AR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Text('FR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _UserBlock extends StatefulWidget {
  final String userName;
  final String userRole;
  final String? displayName;

  const _UserBlock({required this.userName, required this.userRole, this.displayName});

  @override
  State<_UserBlock> createState() => _UserBlockState();
}

class _UserBlockState extends State<_UserBlock> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final name = (widget.displayName != null && widget.displayName!.isNotEmpty) ? widget.displayName! : widget.userName;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final roleLabel = widget.userRole.isNotEmpty
        ? '${widget.userRole[0].toUpperCase()}${widget.userRole.substring(1)}'
        : '';

    const gradient = LinearGradient(
      colors: [Color(0xFF6E2E8C), Color(0xFF9B3A78)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: _hovered
                  ? [BoxShadow(color: const Color(0xFF9B3A78).withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1)]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: ShellTokens.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
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
