import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class StudentRepository extends BaseRepository {
  StudentRepository(super.db);

  Future<List<Student>> getAll() => db.select(db.students).get();

  Future<Student?> getById(String id) =>
      (db.select(db.students)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Student?> getByCode(String code) =>
      (db.select(db.students)..where((t) => t.code.equals(code))).getSingleOrNull();

  Future<List<Student>> search(String query) {
    final q = '%$query%';
    return (db.select(db.students)
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

  Future<String> create(StudentsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.students).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, StudentsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.students)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.students)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Enrollment>> getEnrollments(String studentId) {
    return (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId)))
        .get();
  }
}
