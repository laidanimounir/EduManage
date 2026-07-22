import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_switcher.dart';
import 'dashboard/dashboard_screen.dart';
import 'checkin/checkin_screen.dart';
import 'students/student_list_screen.dart';
import 'teachers/teacher_list_screen.dart';
import 'sessions/session_list_screen.dart';
import 'groups/subject_group_list_screen.dart';
import 'classrooms/classroom_list_screen.dart';
import 'payments/payment_screen.dart';
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

  late final List<NavigationRailDestination> _destinations;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final l10n = AppLocalizations.of(context);
    _destinations = [
      NavigationRailDestination(icon: const Icon(Icons.dashboard), label: Text(_shortLabel(l10n.dashboard))),
      NavigationRailDestination(icon: const Icon(Icons.login), label: Text(_shortLabel(l10n.checkIn))),
      NavigationRailDestination(icon: const Icon(Icons.people), label: Text(_shortLabel(l10n.students))),
      NavigationRailDestination(icon: const Icon(Icons.school), label: Text(_shortLabel(l10n.teachers))),
      NavigationRailDestination(icon: const Icon(Icons.schedule), label: Text(_shortLabel(l10n.sessions))),
      NavigationRailDestination(icon: const Icon(Icons.group_work), label: Text(_shortLabel(l10n.groups))),
      NavigationRailDestination(icon: const Icon(Icons.meeting_room), label: Text(_shortLabel(l10n.classrooms))),
      NavigationRailDestination(icon: const Icon(Icons.assignment), label: Text(_shortLabel(l10n.enrollments))),
      NavigationRailDestination(icon: const Icon(Icons.payment), label: Text(_shortLabel(l10n.payments))),
      NavigationRailDestination(icon: const Icon(Icons.bar_chart), label: Text(_shortLabel(l10n.reports))),
      NavigationRailDestination(icon: const Icon(Icons.credit_card), label: Text(_shortLabel(l10n.cards))),
      NavigationRailDestination(icon: const Icon(Icons.history), label: Text(_shortLabel(l10n.auditLog))),
      if (widget.userRole == 'admin')
        NavigationRailDestination(icon: const Icon(Icons.admin_panel_settings), label: Text(_shortLabel(l10n.users))),
      NavigationRailDestination(icon: const Icon(Icons.settings), label: Text(_shortLabel(l10n.settings))),
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
      PaymentScreen(database: widget.database),
      ProfitReportScreen(database: widget.database),
      StudentCardScreen(database: widget.database),
      AuditLogScreen(database: widget.database),
      if (widget.userRole == 'admin') UserManagementScreen(database: widget.database),
      SettingsScreen(database: widget.database),
    ];
  }

  String _shortLabel(String label) {
    return label.length > 10 ? '${label.substring(0, 8)}...' : label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            destinations: _destinations,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 32),
                  const SizedBox(height: 4),
                  const Text('EduManage',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
