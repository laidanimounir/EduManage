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

  Future<void> transferEnrollment({
    required String studentId,
    required String fromSessionId,
    required String toSessionId,
  }) async {
    final existing = await (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId) & t.sessionId.equals(fromSessionId) & t.status.equals('active')))
        .getSingleOrNull();
    if (existing == null) throw StateError('No active enrollment found in source session');

    final toSession = await (db.select(db.sessions)..where((t) => t.id.equals(toSessionId))).getSingleOrNull();
    if (toSession == null) throw StateError('Target session not found');

    final deviceId = await DeviceId.get();
    await db.transaction(() async {
      await (db.update(db.enrollments)..where((t) => t.id.equals(existing.id)))
          .write(EnrollmentsCompanion(status: const Value('transferred_out'), isTransferred: const Value(true), deviceId: Value(deviceId)));

      await db.into(db.enrollments).insert(EnrollmentsCompanion(
        id: Value(UuidHelper.generate()),
        studentId: Value(studentId),
        sessionId: Value(toSessionId),
        subjectGroupId: Value(toSession.subjectGroupId),
        status: const Value('active'),
        deviceId: Value(deviceId),
      ));
    });
  }

  Future<List<Enrollment>> getStudentHistory(String studentId) {
    return (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId))
      ..orderBy([(t) => OrderingTerm.desc(t.enrollmentDate)]))
        .get();
  }

  Future<String> addToWaitlist(String studentId, String subjectGroupId) async {
    final existing = await (db.select(db.enrollmentWaitlist)
      ..where((t) => t.studentId.equals(studentId) & t.subjectGroupId.equals(subjectGroupId)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.enrollmentWaitlist).insert(EnrollmentWaitlistCompanion(
      id: Value(id), studentId: Value(studentId), subjectGroupId: Value(subjectGroupId), deviceId: Value(deviceId),
    ));
    return id;
  }

  Future<List<EnrollmentWaitlistData>> getWaitlist(String subjectGroupId) {
    return (db.select(db.enrollmentWaitlist)
      ..where((t) => t.subjectGroupId.equals(subjectGroupId))
      ..orderBy([(t) => OrderingTerm.asc(t.requestedAt)]))
        .get();
  }

  Future<void> removeFromWaitlist(String waitlistId) async {
    await (db.delete(db.enrollmentWaitlist)..where((t) => t.id.equals(waitlistId))).go();
  }

  Future<bool> isOnWaitlist(String studentId, String subjectGroupId) async {
    final result = await (db.select(db.enrollmentWaitlist)
      ..where((t) => t.studentId.equals(studentId) & t.subjectGroupId.equals(subjectGroupId)))
        .get();
    return result.isNotEmpty;
  }
}
