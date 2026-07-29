import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/phosphor_icons.dart';
import '../constants/theme_tokens.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../widgets/shell_header.dart';
import '../widgets/quick_find_overlay.dart';
import 'dashboard/dashboard_screen.dart';
import 'checkin/live_attendance_board.dart';
import 'students/student_list_screen.dart';
import 'students/student_balances_screen.dart';
import 'teachers/teacher_list_screen.dart';
import 'sessions/session_list_screen.dart';
import 'sessions/timetable_screen.dart';
import 'groups/subject_group_list_screen.dart';
import 'classrooms/classroom_list_screen.dart';
import 'payments/unified_payment_screen.dart';
import 'reports/profit_report_screen.dart';
import 'cards/student_card_screen.dart';
import 'audit/audit_log_screen.dart';
import 'users/user_management_screen.dart';
import 'settings/settings_screen.dart';
import 'enrollments/enrollment_screen.dart';
import 'families/family_screen.dart';

class MainShell extends StatefulWidget {
  final AppDatabase database;
  final String userId;
  final String userRole;
  final String userName;
  final String firstName;
  final String lastName;

  const MainShell({
    super.key,
    required this.database,
    required this.userId,
    required this.userRole,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _initialized = false;
  bool _sidebarHovered = false;
  bool _sidebarPinned = false;
  bool _sidebarIntroPlayed = false;
  bool _showWelcome = true;
  final Map<int, int> _visitCounters = {};

  late List<_NavItem> _items;
  late List<Widget> _screens;

  static const double _collapsedWidth = 56;
  static const double _expandedWidth = 220;

  late final AnimationController _sidebarCtrl;
  List<Animation<double>> _itemAnimations = [];

  String get _displayName {
    final full = '${widget.firstName} ${widget.lastName}'.trim();
    return full.isNotEmpty ? full : widget.userName;
  }

  int get _tileCount => _items.length;

  @override
  void initState() {
    super.initState();
    _sidebarCtrl = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
  }

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
        _NavItem(PhosphorIcons.table, l10n.timetable),
        _NavItem(PhosphorIcons.usersThree, l10n.groups),
        _NavItem(PhosphorIcons.building, l10n.classrooms),
        _NavItem(PhosphorIcons.notebook, l10n.enrollments),
        _NavItem(PhosphorIcons.usersThree, 'Families'),
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
        LiveAttendanceBoard(database: widget.database, currentUserId: widget.userId),
        StudentListScreen(database: widget.database),
        TeacherListScreen(database: widget.database),
        SessionListScreen(database: widget.database),
        TimetableScreen(database: widget.database),
        SubjectGroupListScreen(database: widget.database),
        ClassroomListScreen(database: widget.database),
        EnrollmentScreen(database: widget.database),
        FamilyScreen(database: widget.database),
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

  void _buildItemAnimations({required int count}) {
    _itemAnimations = [];
    const itemSpan = 0.35;
    for (int i = 0; i < count; i++) {
      final begin = (i / count) * (1.0 - itemSpan);
      final end = (begin + itemSpan).clamp(0.0, 1.0);
      _itemAnimations.add(
        CurvedAnimation(
          parent: _sidebarCtrl,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        ),
      );
    }
  }

  Future<void> _playSidebarIntro() async {
    if (!mounted) return;
    _buildItemAnimations(count: _tileCount);
    setState(() {});

    _sidebarCtrl.duration = const Duration(milliseconds: 700);
    _sidebarCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    _sidebarCtrl.duration = const Duration(milliseconds: 500);
    _sidebarCtrl.reverse();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    _sidebarCtrl.duration = const Duration(milliseconds: 450);
    _itemAnimations = [];
    setState(() => _sidebarIntroPlayed = true);
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
    final title = _selectedIndex < _items.length ? _items[_selectedIndex].label : '';

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _openQuickFind,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _openQuickFind,
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                ShellHeader(
                  title: title,
                  userName: widget.userName,
                  userRole: widget.userRole,
                  displayName: _displayName,
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
                          if (!_sidebarPinned && _sidebarIntroPlayed) {
                            setState(() => _sidebarHovered = true);
                            _sidebarCtrl.forward();
                          }
                        },
                        onExit: (_) {
                          if (!_sidebarPinned && _sidebarIntroPlayed) {
                            setState(() => _sidebarHovered = false);
                            _sidebarCtrl.value = 0.0;
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _sidebarCtrl,
                          builder: (context, _) {
                            final width = _sidebarIntroPlayed
                                ? (_sidebarPinned
                                    ? _expandedWidth
                                    : _collapsedWidth + (_expandedWidth - _collapsedWidth) * _sidebarCtrl.value)
                                : _expandedWidth;
                            return Container(
                              width: width,
                              color: ShellTokens.chromeBase,
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  const Icon(
                                    PhosphorIcons.graduationCap,
                                    color: ShellTokens.textPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 2),
                                  Opacity(
                                    opacity: _sidebarIntroPlayed
                                        ? (_sidebarPinned ? 1.0 : _sidebarCtrl.value.clamp(0.0, 1.0))
                                        : 1.0,
                                    child: const Text(
                                      'EduManage',
                                      style: TextStyle(
                                        color: ShellTokens.textPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Divider(
                                    color: ShellTokens.chromeBorder,
                                    height: 1,
                                    indent: 8,
                                    endIndent: 8,
                                  ),
                                  const SizedBox(height: 2),
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
                            );
                          },
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
            if (_showWelcome)
              _WelcomeOverlay(
                displayName: _displayName,
                onComplete: () {
                  setState(() => _showWelcome = false);
                  _playSidebarIntro();
                },
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSectionedTiles(bool isRtl) {
    final l10n = AppLocalizations.of(context);
    final expanded = _sidebarHovered || _sidebarPinned || !_sidebarIntroPlayed;
    final showExpanded = expanded;

    final sections = [
      _SidebarSection(label: l10n.sidebarSectionCore, indices: [0, 1]),
      _SidebarSection(label: l10n.sidebarSectionManage, indices: [2, 3, 4, 5, 6, 7, 8]),
      _SidebarSection(label: l10n.sidebarSectionFinance, indices: [9, 10, 11]),
      _SidebarSection(label: l10n.sidebarSectionSystem, indices: [12, 13, 14, 15]),
    ];

    final widgets = <Widget>[];
    int flatIndex = 0;
    for (final section in sections) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 2));
        if (showExpanded) {
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

        Widget tile = _SidebarTile(
          icon: item.icon,
          label: item.label,
          selected: selected,
          expanded: showExpanded,
          isRtl: isRtl,
          onTap: () => _navigateTo(i),
        );

        if (!_sidebarIntroPlayed && flatIndex < _itemAnimations.length) {
          tile = FadeTransition(
            opacity: _itemAnimations[flatIndex],
            child: tile,
          );
        }

        widgets.add(tile);
        flatIndex++;
      }
    }
    return widgets;
  }

  @override
  void dispose() {
    _sidebarCtrl.dispose();
    super.dispose();
  }
}

class _WelcomeOverlay extends StatefulWidget {
  final String displayName;
  final VoidCallback onComplete;

  const _WelcomeOverlay({required this.displayName, required this.onComplete});

  @override
  State<_WelcomeOverlay> createState() => _WelcomeOverlayState();
}

class _WelcomeOverlayState extends State<_WelcomeOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    final curve = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _slide = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(curve);

    _ctrl.forward();
    Timer(const Duration(milliseconds: 3000), _startExit);
  }

  void _startExit() {
    if (!mounted) return;
    _ctrl.duration = const Duration(milliseconds: 400);
    _ctrl.reverse().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: SlideTransition(
              position: _slide,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(PhosphorIcons.graduationCap, size: 80, color: ShellTokens.accent),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome back, ${widget.displayName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: ShellTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'EduManage',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ShellTokens.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    final indicatorRadius = isRtl
        ? const BorderRadius.only(
            topRight: Radius.circular(2),
            bottomRight: Radius.circular(2),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            bottomLeft: Radius.circular(2),
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : null,
            children: [
              Container(
                width: 3,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: selected ? ShellTokens.accent : Colors.transparent,
                  borderRadius: indicatorRadius,
                ),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  padding: EdgeInsetsDirectional.only(
                    start: expanded ? 9 : 0,
                    end: expanded ? 8 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: expanded
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: selected
                            ? ShellTokens.accent
                            : ShellTokens.textSecondary,
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
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            textAlign:
                                isRtl ? TextAlign.right : TextAlign.left,
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
