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
import 'special_cases/special_cases_screen.dart';

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

  late List<_NavEntry> _entries;

  static const double _collapsedWidth = 56;
  static const double _expandedWidth = 220;

  late final AnimationController _sidebarCtrl;
  List<Animation<double>> _itemAnimations = [];

  String get _displayName {
    final full = '${widget.firstName} ${widget.lastName}'.trim();
    return full.isNotEmpty ? full : widget.userName;
  }

  int get _tileCount => _entries.length;

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
      final db = widget.database;
      _entries = [
        _NavEntry(icon: PhosphorIcons.squaresFour, label: l10n.dashboard, screen: DashboardScreen(database: db), section: NavSection.core),
        _NavEntry(icon: PhosphorIcons.signIn, label: l10n.checkIn, screen: LiveAttendanceBoard(database: db, currentUserId: widget.userId), section: NavSection.core),
        _NavEntry(icon: PhosphorIcons.users, label: l10n.students, screen: StudentListScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.chalkboardTeacher, label: l10n.teachers, screen: TeacherListScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.clock, label: l10n.sessions, screen: SessionListScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.table, label: l10n.timetable, screen: TimetableScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.usersThree, label: l10n.groups, screen: SubjectGroupListScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.building, label: l10n.classrooms, screen: ClassroomListScreen(database: db), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.notebook, label: 'Enrollment Operations', screen: EnrollmentScreen(database: db, currentUserId: widget.userId), section: NavSection.manage),
        _NavEntry(icon: PhosphorIcons.usersThree, label: 'Families', screen: FamilyScreen(database: db), section: NavSection.finance),
        _NavEntry(icon: PhosphorIcons.warning, label: 'Special Cases', screen: SpecialCasesScreen(database: db, createdByUserId: widget.userId), section: NavSection.finance),
        _NavEntry(icon: PhosphorIcons.currencyCircleDollar, label: l10n.payments, screen: UnifiedPaymentScreen(database: db), section: NavSection.finance),
        _NavEntry(icon: PhosphorIcons.wallet, label: l10n.outstandingDebts, screen: StudentBalancesScreen(database: db), section: NavSection.finance),
        _NavEntry(icon: PhosphorIcons.chartBar, label: l10n.reports, screen: ProfitReportScreen(database: db), section: NavSection.system),
        _NavEntry(icon: PhosphorIcons.identificationCard, label: l10n.cards, screen: StudentCardScreen(database: db), section: NavSection.system),
        _NavEntry(icon: PhosphorIcons.scroll, label: l10n.auditLog, screen: AuditLogScreen(database: db), section: NavSection.system),
        _NavEntry(icon: PhosphorIcons.userCircleGear, label: l10n.users, screen: UserManagementScreen(database: db), section: NavSection.system, adminOnly: true),
        _NavEntry(icon: PhosphorIcons.gear, label: l10n.settings, screen: SettingsScreen(database: db), section: NavSection.system),
      ].where((e) => !e.adminOnly || widget.userRole == 'admin').toList();
    }
  }

  void _buildItemAnimations({required int count}) {
    _itemAnimations = [];
    const itemSpan = 0.40;
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

    _sidebarCtrl.duration = const Duration(milliseconds: 1500);
    _sidebarCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    _sidebarCtrl.duration = const Duration(milliseconds: 1100);
    _sidebarCtrl.reverse();
    await Future.delayed(const Duration(milliseconds: 1100));
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
    final title = _selectedIndex < _entries.length ? _entries[_selectedIndex].label : '';

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
                          children: List.generate(_entries.length, (i) => KeyedSubtree(
                            key: ValueKey('screen_${i}_${_visitCounters[i] ?? 0}'),
                            child: _entries[i].screen,
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

    const sectionOrder = [NavSection.core, NavSection.manage, NavSection.finance, NavSection.system];
    final sectionLabels = <NavSection, String>{
      NavSection.core: l10n.sidebarSectionCore,
      NavSection.manage: l10n.sidebarSectionManage,
      NavSection.finance: l10n.sidebarSectionFinance,
      NavSection.system: l10n.sidebarSectionSystem,
    };

    final widgets = <Widget>[];
    int flatIndex = 0;
    for (final section in sectionOrder) {
      final indices = <int>[
        for (var i = 0; i < _entries.length; i++)
          if (_entries[i].section == section) i,
      ];
      if (indices.isEmpty) continue;

      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 2));
        if (showExpanded) {
          widgets.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              sectionLabels[section] ?? '',
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

      for (final i in indices) {
        final item = _entries[i];
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
  late final Animation<Offset> _slideIn;
  late final Animation<Offset> _slideOut;
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    final inCurve = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(inCurve);
    _slideIn = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(inCurve);

    final outCurve = CurvedAnimation(parent: _ctrl, curve: Curves.easeInCubic);
    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)).animate(outCurve);

    _ctrl.forward();
    Timer(const Duration(milliseconds: 3000), _startExit);
  }

  void _startExit() {
    if (!mounted) return;
    _ctrl.duration = const Duration(milliseconds: 400);
    setState(() => _exiting = true);
    _ctrl.reset();
    _ctrl.forward().then((_) {
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
          color: ShellTokens.chromeBase,
          child: Center(
            child: SlideTransition(
              position: _exiting ? _slideOut : _slideIn,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(PhosphorIcons.graduationCap, size: 80, color: ShellTokens.accent),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ShellTokens.textDisabled,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.displayName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: ShellTokens.textPrimary,
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

enum NavSection { core, manage, finance, system }

class _NavEntry {
  final IconData icon;
  final String label;
  final Widget screen;
  final NavSection section;
  final bool adminOnly;
  const _NavEntry({
    required this.icon,
    required this.label,
    required this.screen,
    required this.section,
    this.adminOnly = false,
  });
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
