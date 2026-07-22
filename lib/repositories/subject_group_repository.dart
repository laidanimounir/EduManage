import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

class SubjectGroupRepository extends BaseRepository {
  SubjectGroupRepository(super.db);

  Future<List<SubjectGroup>> getAll() => db.select(db.subjectGroups).get();

  Future<SubjectGroup?> getById(String id) =>
      (db.select(db.subjectGroups)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<SubjectGroup>> search(String query) {
    final q = '%$query%';
    return (db.select(db.subjectGroups)
      ..where(
        (t) =>
            t.nameAr.like(q) |
            t.nameFr.like(q) |
            t.subjectAr.like(q) |
            t.subjectFr.like(q),
      ))
        .get();
  }

  Future<String> create(SubjectGroupsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.subjectGroups).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, SubjectGroupsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.subjectGroups)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.subjectGroups)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Enrollment>> getStudents(String groupId) {
    return (db.select(db.enrollments)
      ..where((t) => t.subjectGroupId.equals(groupId)))
        .get();
  }

  Future<List<Session>> getSessions(String groupId) {
    return (db.select(db.sessions)
      ..where((t) => t.subjectGroupId.equals(groupId)))
        .get();
  }
}
