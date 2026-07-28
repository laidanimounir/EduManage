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
          t.attendanceDate.isSmallerThanValue(dateEnd) &
          t.status.equals('present')))
        .get();
    return result.isNotEmpty;
  }

  Future<String> markAbsent({
    required String sessionId,
    required String studentId,
    required DateTime date,
    String? reason,
    String? userId,
  }) async {
    final existing = await (db.select(db.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.studentId.equals(studentId) &
          t.attendanceDate.equals(date)))
        .getSingleOrNull();
    if (existing != null) {
      await (db.update(db.attendance)
        ..where((t) => t.id.equals(existing.id)))
        .write(AttendanceCompanion(
          status: const Value('absent'),
          absenceReason: Value(reason),
          modifiedByUserId: Value(userId),
          modifiedAt: Value(DateTime.now().toIso8601String()),
        ));
      return existing.id;
    }
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.attendance).insert(AttendanceCompanion(
      id: Value(id),
      studentId: Value(studentId),
      sessionId: Value(sessionId),
      attendanceDate: Value(date),
      personType: const Value('student'),
      status: const Value('absent'),
      absenceReason: Value(reason),
      checkedInByUserId: Value(userId),
      deviceId: Value(deviceId),
    ));
    return id;
  }

  Future<void> updateStatus({
    required String attendanceId,
    required String status,
    int? minutesLate,
    String? userId,
  }) async {
    await (db.update(db.attendance)
      ..where((t) => t.id.equals(attendanceId)))
      .write(AttendanceCompanion(
        status: Value(status),
        minutesLate: minutesLate != null ? Value(minutesLate) : const Value.absent(),
        modifiedByUserId: Value(userId),
        modifiedAt: Value(DateTime.now().toIso8601String()),
      ));
  }
}
