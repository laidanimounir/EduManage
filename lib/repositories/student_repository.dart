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

  Future<void> savePhones(String studentId, List<({String number, String? label})> entries) async {
    await (db.delete(db.studentPhones)..where((p) => p.studentId.equals(studentId))).go();
    for (final entry in entries) {
      await db.into(db.studentPhones).insert(StudentPhonesCompanion(
        id: Value(UuidHelper.generate()),
        studentId: Value(studentId),
        phoneNumber: Value(entry.number),
        label: Value(entry.label),
        deviceId: Value(await DeviceId.get()),
      ));
    }
  }

  Future<List<({String phoneNumber, String? label})>> getPhones(String studentId) async {
    final rows = await (db.select(db.studentPhones)..where((p) => p.studentId.equals(studentId))).get();
    return rows.map((r) => (phoneNumber: r.phoneNumber, label: r.label)).toList();
  }

  Future<Map<String, List<({String phoneNumber, String? label})>>> getPhonesForStudents(List<String> studentIds) async {
    if (studentIds.isEmpty) return {};
    final rows = await (db.select(db.studentPhones)..where((p) => p.studentId.isIn(studentIds))).get();
    final map = <String, List<({String phoneNumber, String? label})>>{};
    for (final r in rows) {
      map.putIfAbsent(r.studentId, () => []).add((phoneNumber: r.phoneNumber, label: r.label));
    }
    return map;
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

    if (statusFilter != null && statusFilter != 'all') {
      if (statusFilter == 'archived') {
        query = query..where((t) => t.isArchived.equals(true));
      } else {
        query = query..where((t) => t.isArchived.equals(false) & t.status.equals(statusFilter));
      }
    } else {
      query = query..where((t) => includeArchived
          ? const Constant(true).equals(true)
          : t.isArchived.equals(false));
    }

    if (schoolLevelFilter != null) {
      query = query..where((t) => t.schoolLevel.equals(schoolLevelFilter));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim()}%';
      final phoneRows = await db.customSelect(
        'SELECT DISTINCT student_id FROM student_phones WHERE phone_number LIKE ?',
        variables: [Variable.withString(q)],
      ).get();
      final phoneIds = phoneRows.map((r) => r.read<String>('student_id')).toList();
      query = query..where((t) {
        var condition = t.firstNameAr.like(q) |
            t.lastNameAr.like(q) |
            t.firstNameFr.like(q) |
            t.lastNameFr.like(q) |
            t.code.like(q);
        if (phoneIds.isNotEmpty) {
          condition = condition | t.id.isIn(phoneIds);
        }
        return condition;
      });
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
