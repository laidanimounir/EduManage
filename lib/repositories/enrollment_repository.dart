import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class EnrollmentRepository extends BaseRepository {
  EnrollmentRepository(super.db);

  Future<List<Enrollment>> getAll() => db.select(db.enrollments).get();

  Future<Enrollment?> getById(String id) =>
      (db.select(db.enrollments)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Enrollment>> getByStudent(String studentId) {
    return (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId)))
        .get();
  }

  Future<List<Enrollment>> getBySubjectGroup(String groupId) {
    return (db.select(db.enrollments)
      ..where((t) => t.subjectGroupId.equals(groupId)))
        .get();
  }

  Future<List<Enrollment>> getActiveEnrollments(String studentId) {
    return (db.select(db.enrollments)
      ..where(
          (t) => t.studentId.equals(studentId) & t.status.equals('active')))
        .get();
  }

  Future<String> create(EnrollmentsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.enrollments).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, EnrollmentsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.enrollments)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.enrollments)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateStatus(String id, String status) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.enrollments)..where((t) => t.id.equals(id)))
        .write(EnrollmentsCompanion(
      status: Value(status),
      deviceId: Value(deviceId),
    ));
  }
}
