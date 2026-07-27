import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class TeacherSubjectGroupRepository extends BaseRepository {
  TeacherSubjectGroupRepository(super.db);

  Future<List<TeacherSubjectGroup>> getByTeacher(String teacherId) {
    return (db.select(db.teacherSubjectGroups)
      ..where((t) => t.teacherId.equals(teacherId)))
        .get();
  }

  Future<List<TeacherSubjectGroup>> getByGroup(String subjectGroupId) {
    return (db.select(db.teacherSubjectGroups)
      ..where((t) => t.subjectGroupId.equals(subjectGroupId)))
        .get();
  }

  Future<String> assign(String teacherId, String subjectGroupId) async {
    final existing = await (db.select(db.teacherSubjectGroups)
      ..where((t) =>
          t.teacherId.equals(teacherId) &
          t.subjectGroupId.equals(subjectGroupId)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.teacherSubjectGroups).insert(
      TeacherSubjectGroupsCompanion(
        id: Value(id),
        teacherId: Value(teacherId),
        subjectGroupId: Value(subjectGroupId),
        deviceId: Value(deviceId),
      ),
    );
    return id;
  }

  Future<void> remove(String teacherId, String subjectGroupId) async {
    await (db.delete(db.teacherSubjectGroups)
      ..where((t) =>
          t.teacherId.equals(teacherId) &
          t.subjectGroupId.equals(subjectGroupId)))
        .go();
  }

  Future<void> setAssignments(String teacherId, List<String> subjectGroupIds) async {
    await (db.delete(db.teacherSubjectGroups)
      ..where((t) => t.teacherId.equals(teacherId)))
        .go();
    for (final groupId in subjectGroupIds) {
      await assign(teacherId, groupId);
    }
  }

  Future<List<SubjectGroup>> getAssignedGroups(String teacherId) async {
    final junctionRows = await getByTeacher(teacherId);
    if (junctionRows.isEmpty) return [];
    final groupIds = junctionRows.map((j) => j.subjectGroupId).toList();
    return (db.select(db.subjectGroups)
      ..where((g) => g.id.isIn(groupIds)))
        .get();
  }
}
