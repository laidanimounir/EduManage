import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class UserRepository extends BaseRepository {
  UserRepository(super.db);

  Future<List<User>> getAll() => db.select(db.users).get();

  Future<User?> getById(String id) =>
      (db.select(db.users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<User?> getByUsername(String username) =>
      (db.select(db.users)..where((t) => t.username.equals(username)))
          .getSingleOrNull();

  Future<User?> validateCredentials(String username, String password) async {
    final user = await getByUsername(username);
    if (user == null || !user.isActive) return null;
    final hash = _hashPassword(password);
    if (user.passwordHash == hash) return user;
    return null;
  }

  Future<String> create(UsersCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.users).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, UsersCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.users)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.users)..where((t) => t.id.equals(id))).go();
  }

  static String hashPassword(String password) => _hashPassword(password);

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
