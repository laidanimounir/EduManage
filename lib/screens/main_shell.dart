import 'package:flutter/material.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../widgets/shell_header.dart';
import '../widgets/quick_find_overlay.dart';
import 'dashboard/dashboard_screen.dart';
import 'checkin/checkin_screen.dart';
import 'students/student_list_screen.dart';
import 'students/student_balances_screen.dart';
import 'teachers/teacher_list_screen.dart';
import 'sessions/session_list_screen.dart';
import 'groups/subject_group_list_screen.dart';
import 'classrooms/classroom_list_screen.dart';
import 'payments/unified_payment_screen.dart';
import 'reports/profit_report_screen.dart';
import 'cards/student_card_screen.dart';
import 'audit/audit_log_screen.dart';
import 'users/user_management_screen.dart';
import 'settings/settings_screen.dart';
import 'enrollments/enrollment_screen.dart';

class MainShell extends StatefulWidget {
  final AppDatabase database;
  final String userId;
  final String userRole;

  const MainShell({
    super.key,
    required this.database,
    required this.userId,
    required this.userRole,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  bool _initialized = false;
  bool _sidebarHovered = false;
  bool _sidebarPinned = false;
  final Map<int, int> _visitCounters = {};

  late List<_NavItem> _items;
  late List<Widget> _screens;

  static const double _collapsedWidth = 56;
  static const double _expandedWidth = 220;
  static const Duration _animDuration = Duration(milliseconds: 180);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final l10n = AppLocalizations.of(context);
      _items = [
        _NavItem(PhosphorIcons.squaresFour, l10n.dashboard),
        _NavItem(PhosphorIcons.signIn, l10n.checkIn),
        _NavItem(PhosphorIcons.users, l10n.students),
        _NavItem(PhosphorIcons.chalkboardTeacher, l10n.teachers),
        _NavItem(PhosphorIcons.clock, l10n.sessions),
        _NavItem(PhosphorIcons.usersThree, l10n.groups),
        _NavItem(PhosphorIcons.building, l10n.classrooms),
        _NavItem(PhosphorIcons.notebook, l10n.enrollments),
        _NavItem(PhosphorIcons.currencyCircleDollar, l10n.payments),
        _NavItem(PhosphorIcons.wallet, l10n.outstandingDebts),
        _NavItem(PhosphorIcons.chartBar, l10n.reports),
        _NavItem(PhosphorIcons.identificationCard, l10n.cards),
        _NavItem(PhosphorIcons.scroll, l10n.auditLog),
        if (widget.userRole == 'admin')
          _NavItem(PhosphorIcons.userCircleGear, l10n.users),
        _NavItem(PhosphorIcons.gear, l10n.settings),
      ];

      _screens = [
        DashboardScreen(database: widget.database),
        CheckinScreen(database: widget.database, currentUserId: widget.userId),
        StudentListScreen(database: widget.database),
        TeacherListScreen(database: widget.database),
        SessionListScreen(database: widget.database),
        SubjectGroupListScreen(database: widget.database),
        ClassroomListScreen(database: widget.database),
        EnrollmentScreen(database: widget.database),
        UnifiedPaymentScreen(database: widget.database),
        StudentBalancesScreen(database: widget.database),
        ProfitReportScreen(database: widget.database),
        StudentCardScreen(database: widget.database),
        AuditLogScreen(database: widget.database),
        if (widget.userRole == 'admin')
          UserManagementScreen(database: widget.database),
        SettingsScreen(database: widget.database),
      ];
    }
  }

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
      _visitCounters[index] = (_visitCounters[index] ?? 0) + 1;
    });
  }

  void _openQuickFind() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => QuickFindOverlay(
        database: widget.database,
        l10n: l10n,
        onStudentSelected: (code) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UnifiedPaymentScreen(
                database: widget.database,
                initialStudentCode: code,
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleLogout() {
    final appState = EduManageApp.of(context);
    appState?.logout();
  }

  void _handleLocaleChange(Locale locale) {
    final appState = EduManageApp.of(context);
    appState?.changeLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final currentLocale = Localizations.localeOf(context);
    final width = (_sidebarHovered || _sidebarPinned) ? _expandedWidth : _collapsedWidth;
    final expanded = _sidebarHovered || _sidebarPinned;
    final title = _selectedIndex < _items.length ? _items[_selectedIndex].label : '';

    return Scaffold(
      body: Column(
        children: [
          ShellHeader(
            title: title,
            userId: widget.userId,
            userRole: widget.userRole,
            onLogout: _handleLogout,
            onQuickFind: _openQuickFind,
            onLocaleChanged: _handleLocaleChange,
            currentLocale: currentLocale,
          ),
          Expanded(
            child: Row(
              children: [
                MouseRegion(
                  onEnter: (_) {
                    if (!_sidebarPinned) setState(() => _sidebarHovered = true);
                  },
                  onExit: (_) {
                    if (!_sidebarPinned) setState(() => _sidebarHovered = false);
                  },
                  child: AnimatedContainer(
                    duration: _animDuration,
                    curve: Curves.easeInOut,
                    width: width,
                    color: ShellTokens.chromeBase,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Icon(
                          PhosphorIcons.graduationCap,
                          color: ShellTokens.textPrimary,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        AnimatedOpacity(
                          duration: _animDuration,
                          opacity: expanded ? 1.0 : 0.0,
                          child: const Text(
                            'EduManage',
                            style: TextStyle(
                              color: ShellTokens.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: ShellTokens.chromeBorder,
                          height: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: _buildSectionedTiles(isRtl),
                          ),
                        ),
                        const Divider(
                          color: ShellTokens.chromeBorder,
                          height: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                        _PinToggle(
                          pinned: _sidebarPinned,
                          onToggle: () => setState(() => _sidebarPinned = !_sidebarPinned),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  color: ShellTokens.chromeBorder,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: List.generate(_screens.length, (i) => KeyedSubtree(
                      key: ValueKey('screen_${i}_${_visitCounters[i] ?? 0}'),
                      child: _screens[i],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionedTiles(bool isRtl) {
    final l10n = AppLocalizations.of(context);
    final expanded = _sidebarHovered || _sidebarPinned;

    final sections = [
      _SidebarSection(label: l10n.sidebarSectionCore, indices: [0, 1]),
      _SidebarSection(label: l10n.sidebarSectionManage, indices: [2, 3, 4, 5, 6, 7]),
      _SidebarSection(label: l10n.sidebarSectionFinance, indices: [8, 9, 10]),
      _SidebarSection(label: l10n.sidebarSectionSystem, indices: [11, 12, 13, 14]),
    ];

    final widgets = <Widget>[];
    for (final section in sections) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 2));
        if (expanded) {
          widgets.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              section.label,
              style: const TextStyle(
                color: ShellTokens.textDisabled,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ));
        } else {
          widgets.add(const Divider(
            color: ShellTokens.chromeBorder,
            height: 1,
            indent: 12,
            endIndent: 12,
          ));
        }
        widgets.add(const SizedBox(height: 2));
      }

      for (final i in section.indices) {
        if (i >= _items.length) continue;
        final item = _items[i];
        final selected = _selectedIndex == i;
        widgets.add(_SidebarTile(
          icon: item.icon,
          label: item.label,
          selected: selected,
          expanded: expanded,
          isRtl: isRtl,
          onTap: () => _navigateTo(i),
        ));
      }
    }
    return widgets;
  }
}

class _SidebarSection {
  final String label;
  final List<int> indices;
  const _SidebarSection({required this.label, required this.indices});
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final bool isRtl;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.isRtl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: EdgeInsetsDirectional.only(
            start: expanded ? 12 : 0,
            end: expanded ? 8 : 0,
          ),
          child: Row(
            mainAxisAlignment: expanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : null,
            children: [
              if (selected)
                Container(
                  width: 3,
                  height: 20,
                  margin: EdgeInsetsDirectional.only(
                    start: expanded ? -12 : 0,
                    end: expanded ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: ShellTokens.accent,
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(isRtl ? 0 : 2),
                      bottomStart: Radius.circular(isRtl ? 2 : 0),
                      topEnd: Radius.circular(isRtl ? 0 : 2),
                      topStart: Radius.circular(isRtl ? 2 : 0),
                    ),
                  ),
                )
              else
                const SizedBox(width: 3, height: 20),
              if (selected) const SizedBox(width: 5),
              Icon(
                icon,
                color: selected ? ShellTokens.accent : ShellTokens.textSecondary,
                size: 18,
              ),
              if (expanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: selected
                          ? ShellTokens.textPrimary
                          : ShellTokens.textSecondary,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: Text(label),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PinToggle extends StatelessWidget {
  final bool pinned;
  final VoidCallback onToggle;

  const _PinToggle({required this.pinned, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Tooltip(
      message: pinned ? l10n.unpinSidebar : l10n.pinSidebar,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              pinned
                  ? PhosphorIcons.pushPinSimpleSlash
                  : PhosphorIcons.pushPinSimple,
              size: 16,
              color: pinned ? ShellTokens.accent : ShellTokens.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
