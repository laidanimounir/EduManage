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

  Future<String> generateCode() async {
    final result = await db.select(db.teachers).get();
    var maxNum = 0;
    for (final t in result) {
      final match = RegExp(r'TCH-(\d+)').firstMatch(t.code);
      if (match != null) {
        final num = int.tryParse(match.group(1) ?? '') ?? 0;
        if (num > maxNum) maxNum = num;
      }
    }
    return 'TCH-${(maxNum + 1).toString().padLeft(3, '0')}';
  }

  Future<void> update(String id, TeachersCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.teachers)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> archive(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.teachers)..where((t) => t.id.equals(id)))
        .write(TeachersCompanion(
          isArchived: const Value(true),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> restore(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.teachers)..where((t) => t.id.equals(id)))
        .write(TeachersCompanion(
          isArchived: const Value(false),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.teachers)..where((t) => t.id.equals(id))).go();
  }

  Future<({List<Teacher> teachers, int total})> fetchPage({
    int offset = 0,
    int limit = 20,
    String? statusFilter,
    String? searchQuery,
    bool includeArchived = false,
  }) async {
    var query = db.select(db.teachers);

    if (statusFilter != null && statusFilter != 'all') {
      if (statusFilter == 'archived') {
        query = query..where((t) => t.isArchived.equals(true));
      } else if (statusFilter == 'ended') {
        query = query..where((t) => t.isArchived.equals(false) & t.employmentEndDate.isNotNull());
      } else {
        query = query..where((t) => t.isArchived.equals(false) & t.employmentEndDate.isNull());
      }
    } else {
      query = query..where((t) => includeArchived
          ? const Constant(true).equals(true)
          : t.isArchived.equals(false));
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
    final teachers = allResults.skip(offset).take(limit).toList();

    return (teachers: teachers, total: total);
  }

  Future<List<Session>> getSessions(String teacherId) {
    return (db.select(db.sessions)
      ..where((t) => t.teacherId.equals(teacherId)))
        .get();
  }

  Future<void> savePhones(String teacherId, List<({String number, String? label})> entries) async {
    await (db.delete(db.teacherPhones)..where((p) => p.teacherId.equals(teacherId))).go();
    for (final entry in entries) {
      await db.into(db.teacherPhones).insert(TeacherPhonesCompanion(
        id: Value(UuidHelper.generate()),
        teacherId: Value(teacherId),
        phoneNumber: Value(entry.number),
        label: Value(entry.label),
        deviceId: Value(await DeviceId.get()),
      ));
    }
  }

  Future<List<({String phoneNumber, String? label})>> getPhones(String teacherId) async {
    final rows = await (db.select(db.teacherPhones)..where((p) => p.teacherId.equals(teacherId))).get();
    return rows.map((r) => (phoneNumber: r.phoneNumber, label: r.label)).toList();
  }

  Future<Map<String, List<({String phoneNumber, String? label})>>> getPhonesForTeachers(List<String> teacherIds) async {
    if (teacherIds.isEmpty) return {};
    final rows = await (db.select(db.teacherPhones)..where((p) => p.teacherId.isIn(teacherIds))).get();
    final map = <String, List<({String phoneNumber, String? label})>>{};
    for (final r in rows) {
      map.putIfAbsent(r.teacherId, () => []).add((phoneNumber: r.phoneNumber, label: r.label));
    }
    return map;
  }
}
