import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class ClassroomRepository extends BaseRepository {
  ClassroomRepository(super.db);

  Future<List<Classroom>> getAll() => db.select(db.classrooms).get();

  Future<Classroom?> getById(String id) =>
      (db.select(db.classrooms)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> create(ClassroomsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.classrooms).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, ClassroomsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.classrooms)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.classrooms)..where((t) => t.id.equals(id))).go();
  }

  Future<void> archive(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.classrooms)..where((t) => t.id.equals(id)))
        .write(ClassroomsCompanion(isArchived: const Value(true), deviceId: Value(deviceId)));
  }

  Future<void> restore(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.classrooms)..where((t) => t.id.equals(id)))
        .write(ClassroomsCompanion(isArchived: const Value(false), deviceId: Value(deviceId)));
  }

  Future<bool> hasActiveSessions(String classroomId) async {
    final sessions = await (db.select(db.sessions)
      ..where((t) => t.classroomId.equals(classroomId)))
        .get();
    return sessions.any((s) => s.isActive && !s.isArchived);
  }
}
