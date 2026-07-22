import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class TeacherRepository extends BaseRepository {
  TeacherRepository(super.db);

  Future<List<Teacher>> getAll() => db.select(db.teachers).get();

  Future<Teacher?> getById(String id) =>
      (db.select(db.teachers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Teacher?> getByCode(String code) =>
      (db.select(db.teachers)..where((t) => t.code.equals(code))).getSingleOrNull();

  Future<List<Teacher>> search(String query) {
    final q = '%$query%';
    return (db.select(db.teachers)
      ..where(
        (t) =>
            t.firstNameAr.like(q) |
            t.lastNameAr.like(q) |
            t.firstNameFr.like(q) |
            t.lastNameFr.like(q) |
            t.phone.like(q) |
            t.code.like(q),
      ))
        .get();
  }

  Future<String> create(TeachersCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.teachers).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, TeachersCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.teachers)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.teachers)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Session>> getSessions(String teacherId) {
    return (db.select(db.sessions)
      ..where((t) => t.teacherId.equals(teacherId)))
        .get();
  }
}
