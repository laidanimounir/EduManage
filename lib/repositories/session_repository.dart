import '../database/app_database.dart';
import '../utils/date_helper.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class SessionRepository extends BaseRepository {
  SessionRepository(super.db);

  Future<List<Session>> getAll() => db.select(db.sessions).get();

  Future<Session?> getById(String id) =>
      (db.select(db.sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Session>> getByDay(int dayOfWeek) {
    return (db.select(db.sessions)
      ..where((t) => t.dayOfWeek.equals(dayOfWeek) & t.isActive.equals(true)))
        .get();
  }

  Future<List<Session>> getByTeacher(String teacherId) {
    return (db.select(db.sessions)
      ..where((t) => t.teacherId.equals(teacherId)))
        .get();
  }

  Future<List<Session>> getByClassroom(String classroomId) {
    return (db.select(db.sessions)
      ..where((t) => t.classroomId.equals(classroomId)))
        .get();
  }

  Future<List<Session>> getActiveAtTime(DateTime time) async {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final allActive = await (db.select(db.sessions)
      ..where((t) => t.dayOfWeek.equals(dayOfWeek) & t.isActive.equals(true)))
        .get();

    return allActive.where((s) {
      return DateHelper.isTimeInRange(time, s.startTime, s.endTime);
    }).toList();
  }

  Future<List<Session>> getActiveSessionsForStudent(
      String studentId, DateTime time) async {
    final enrollments = await (db.select(db.enrollments)
      ..where((t) => t.studentId.equals(studentId) & t.status.equals('active')))
        .get();

    if (enrollments.isEmpty) return [];

    final activeSessions = await getActiveAtTime(time);
    final enrolledGroupIds = enrollments.map((e) => e.subjectGroupId).toSet();

    return activeSessions
        .where((s) => enrolledGroupIds.contains(s.subjectGroupId))
        .toList();
  }

  Future<List<Session>> getActiveSessionsForTeacher(
      String teacherId, DateTime time) async {
    final activeSessions = await getActiveAtTime(time);
    return activeSessions.where((s) => s.teacherId == teacherId).toList();
  }

  Future<String> create(SessionsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.sessions).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, SessionsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.sessions)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.sessions)..where((t) => t.id.equals(id))).go();
  }

  Future<List<AttendanceData>> getAttendanceDataForDate(
      String sessionId, DateTime date) {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    return (db.select(db.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.attendanceDate.isBiggerOrEqualValue(dateStart) &
          t.attendanceDate.isSmallerThanValue(dateEnd)))
        .get();
  }
}
