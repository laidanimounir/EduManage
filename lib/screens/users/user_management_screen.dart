import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import 'package:drift/drift.dart' hide Column;

class UserManagementScreen extends StatefulWidget {
  final AppDatabase database;

  const UserManagementScreen({super.key, required this.database});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late final UserRepository _userRepo;
  List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _userRepo = UserRepository(widget.database);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    final users = await _userRepo.getAll();
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  Future<void> _showUserDialog({User? user}) async {
    final l10n = AppLocalizations.of(context);
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final passwordCtrl = TextEditingController();
    final firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: user?.lastName ?? '');
    var role = user?.role ?? 'teacher';
    var isActive = user?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEdit ? l10n.editUser : l10n.addUser),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(labelText: l10n.username),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: InputDecoration(labelText: l10n.password),
                    obscureText: true,
                    validator: isEdit
                        ? null
                        : (v) => (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: firstNameCtrl,
                    decoration: InputDecoration(labelText: l10n.firstName),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: lastNameCtrl,
                    decoration: InputDecoration(labelText: l10n.lastName),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: InputDecoration(labelText: l10n.role),
                    items: [
                      DropdownMenuItem(value: 'admin', child: Text(l10n.admin)),
                      DropdownMenuItem(value: 'teacher', child: Text(l10n.teacher)),
                    ],
                    onChanged: (v) => setDialogState(() => role = v!),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(isActive ? l10n.active : l10n.inactive),
                    value: isActive,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setDialogState(() => isActive = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final companion = UsersCompanion(
                    username: Value(usernameCtrl.text.trim()),
                    firstName: Value(firstNameCtrl.text.trim()),
                    lastName: Value(lastNameCtrl.text.trim()),
                    role: Value(role),
                    isActive: Value(isActive),
                    passwordHash: Value(
                      isEdit && passwordCtrl.text.isEmpty
                          ? user!.passwordHash
                          : UserRepository.hashPassword(passwordCtrl.text),
                    ),
                  );
                  if (isEdit) {
                    await _userRepo.update(user!.id, companion);
                  } else {
                    await _userRepo.create(companion);
                  }
                  if (ctx.mounted) Navigator.pop(ctx, true);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );

    if (result == true) _loadUsers();
  }

  Future<void> _confirmDelete(User user) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text('${l10n.username}: ${user.username}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.no)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.yes)),
        ],
      ),
    );

    if (confirmed == true) {
      await _userRepo.delete(user.id);
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text(l10n.noData))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (_, i) {
                    final u = _users[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(u.firstName[0].toUpperCase()),
                        ),
                        title: Text('${u.firstName} ${u.lastName}'),
                        subtitle: Text(
                          '@${u.username}  |  ${u.role == 'admin' ? l10n.admin : l10n.teacher}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              u.isActive ? Icons.check_circle : Icons.cancel,
                              color: u.isActive ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            PopupMenuButton<String>(
                              onSelected: (action) {
                                if (action == 'edit') _showUserDialog(user: u);
                                if (action == 'delete') _confirmDelete(u);
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                                PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
