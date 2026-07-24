import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
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
  final Map<int, int> _visitCounters = {};

  late List<_NavItem> _items;
  late List<Widget> _screens;

  static const double _collapsedWidth = 56;
  static const double _expandedWidth = 220;
  static const Duration _animDuration = Duration(milliseconds: 200);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final l10n = AppLocalizations.of(context);
      _items = [
        _NavItem(Icons.dashboard, l10n.dashboard),
        _NavItem(Icons.login, l10n.checkIn),
        _NavItem(Icons.people, l10n.students),
        _NavItem(Icons.school, l10n.teachers),
        _NavItem(Icons.schedule, l10n.sessions),
        _NavItem(Icons.group_work, l10n.groups),
        _NavItem(Icons.meeting_room, l10n.classrooms),
        _NavItem(Icons.assignment, l10n.enrollments),
        _NavItem(Icons.payment, l10n.payments),
        _NavItem(Icons.account_balance_wallet, l10n.outstandingDebts),
        _NavItem(Icons.bar_chart, l10n.reports),
        _NavItem(Icons.credit_card, l10n.cards),
        _NavItem(Icons.history, l10n.auditLog),
        if (widget.userRole == 'admin')
          _NavItem(Icons.admin_panel_settings, l10n.users),
        _NavItem(Icons.settings, l10n.settings),
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

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final width = _sidebarHovered ? _expandedWidth : _collapsedWidth;

    return Scaffold(
      body: Row(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _sidebarHovered = true),
            onExit: (_) => setState(() => _sidebarHovered = false),
            child: AnimatedContainer(
              duration: _animDuration,
              curve: Curves.easeInOut,
              width: width,
              color: const Color(0xFF1A237E),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Icon(Icons.school, color: Colors.white, size: 28),
                  const SizedBox(height: 4),
                  AnimatedOpacity(
                    duration: _animDuration,
                    opacity: _sidebarHovered ? 1.0 : 0.0,
                    child: const Text(
                      'EduManage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: List.generate(_items.length, (i) {
                        final item = _items[i];
                        final selected = _selectedIndex == i;
                        return _SidebarTile(
                          icon: item.icon,
                          label: item.label,
                          selected: selected,
                          expanded: _sidebarHovered,
                          isRtl: isRtl,
                          onTap: () => setState(() {
                            _selectedIndex = i;
                            _visitCounters[i] = (_visitCounters[i] ?? 0) + 1;
                          }),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
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
    );
  }
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
    final bgColor = selected
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.transparent;

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(
            horizontal: expanded ? 16 : 0,
          ),
          child: Row(
            mainAxisAlignment: expanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : null,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : Colors.white70,
                size: 22,
              ),
              if (expanded) ...[
                const SizedBox(width: 14),
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 13,
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
