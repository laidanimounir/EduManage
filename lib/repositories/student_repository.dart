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

  Future<String> generateCode() async {
    final result = await db.select(db.students).get();
    var maxNum = 0;
    for (final s in result) {
      final match = RegExp(r'STU-(\d+)').firstMatch(s.code);
      if (match != null) {
        final num = int.tryParse(match.group(1) ?? '') ?? 0;
        if (num > maxNum) maxNum = num;
      }
    }
    return 'STU-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  Future<void> update(String id, StudentsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.students)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> archive(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.students)..where((t) => t.id.equals(id)))
        .write(StudentsCompanion(
          isArchived: const Value(true),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> restore(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.students)..where((t) => t.id.equals(id)))
        .write(StudentsCompanion(
          isArchived: const Value(false),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.students)..where((t) => t.id.equals(id))).go();
  }

  Future<({List<Student> students, int total})> fetchPage({
    int offset = 0,
    int limit = 20,
    String? statusFilter,
    String? searchQuery,
    String? schoolLevelFilter,
    bool includeArchived = false,
  }) async {
    var query = db.select(db.students);
    var countQuery = db.selectOnly(db.students)..addColumns([db.students.id.count()]);

    query = query..where((t) => includeArchived ? const Constant(true).equals(true) : t.isArchived.equals(false));

    if (statusFilter != null && statusFilter != 'all') {
      if (statusFilter == 'archived') {
        query = query..where((t) => t.isArchived.equals(true));
      } else {
        query = query..where((t) => t.status.equals(statusFilter));
      }
    }

    if (schoolLevelFilter != null) {
      query = query..where((t) => t.schoolLevel.equals(schoolLevelFilter));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim()}%';
      query = query..where((t) =>
        t.firstNameAr.like(q) |
        t.lastNameAr.like(q) |
        t.firstNameFr.like(q) |
        t.lastNameFr.like(q) |
        t.phone.like(q) |
        t.code.like(q),
      );
    }

    final total = await query.map((r) => r.id).get().then((ids) => ids.length);

    var allResults = await query.get();
    allResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final students = allResults.skip(offset).take(limit).toList();

    return (students: students, total: total);
  }

  Future<List<Enrollment>> getEnrollments(String studentId) {
    return (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId)))
        .get();
  }
}
