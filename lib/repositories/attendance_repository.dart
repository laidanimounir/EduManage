import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

class AttendanceRepository extends BaseRepository {
  AttendanceRepository(super.db);

  Future<String> create(AttendanceCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.attendance).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<List<AttendanceData>> getBySessionDate(
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

  Future<List<AttendanceData>> getByStudent(String studentId) {
    return (db.select(db.attendance)
      ..where((t) => t.studentId.equals(studentId))
      ..orderBy([(t) => OrderingTerm.desc(t.attendanceDate)]))
        .get();
  }

  Future<List<AttendanceData>> getByTeacher(String teacherId) {
    return (db.select(db.attendance)
      ..where((t) => t.teacherId.equals(teacherId))
      ..orderBy([(t) => OrderingTerm.desc(t.attendanceDate)]))
        .get();
  }

  Future<List<AttendanceData>> getTodayAttendance() {
    final today = DateTime.now();
    final dateStart = DateTime(today.year, today.month, today.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    return (db.select(db.attendance)
      ..where((t) =>
          t.attendanceDate.isBiggerOrEqualValue(dateStart) &
          t.attendanceDate.isSmallerThanValue(dateEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.checkInTime)]))
        .get();
  }

  Future<List<AttendanceData>> getAbsences(
      String sessionId, DateTime date) {
    return (db.select(db.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.attendanceDate.equals(date)))
        .get();
  }

  Future<bool> hasCheckedInToday(
      String sessionId, String studentId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final result = await (db.select(db.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.studentId.equals(studentId) &
          t.attendanceDate.isBiggerOrEqualValue(dateStart) &
          t.attendanceDate.isSmallerThanValue(dateEnd)))
        .get();
    return result.isNotEmpty;
  }
}
