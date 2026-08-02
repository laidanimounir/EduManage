import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../utils/date_helper.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

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

  Future<Map<int, ({int openMinutes, int closeMinutes})>> suggestOperatingHours() async {
    final rows = await (db.select(db.sessions)
      ..where((t) => t.isArchived.equals(false) & t.isActive.equals(true)))
        .get();
    final byDay = <int, List<Session>>{};
    for (final s in rows) {
      byDay.putIfAbsent(s.dayOfWeek, () => []).add(s);
    }
    final result = <int, ({int openMinutes, int closeMinutes})>{};
    for (final entry in byDay.entries) {
      var minStart = 24 * 60;
      var maxEnd = 0;
      for (final s in entry.value) {
        final start = s.startTime.hour * 60 + s.startTime.minute;
        final end = s.endTime.hour * 60 + s.endTime.minute;
        if (start < minStart) minStart = start;
        if (end > maxEnd) maxEnd = end;
      }
      result[entry.key] = (openMinutes: minStart, closeMinutes: maxEnd);
    }
    return result;
  }

  Future<List<Session>> getActiveAtTime(DateTime time) async {
    final dayOfWeek = time.weekday;
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

  Future<List<Session>> getOverlappingSessions(
    int dayOfWeek,
    DateTime startTime,
    DateTime endTime, {
    String? excludeId,
  }) {
    var query = db.select(db.sessions)
      ..where((t) =>
          t.dayOfWeek.equals(dayOfWeek) &
          t.isActive.equals(true) &
          t.isArchived.equals(false) &
          t.startTime.isSmallerThanValue(endTime) &
          t.endTime.isBiggerThanValue(startTime));
    if (excludeId != null) {
      query = query..where((t) => t.id.isNotValue(excludeId));
    }
    return query.get();
  }

  Future<List<Session>> getConflictingSessions(
    int dayOfWeek,
    DateTime startTime,
    DateTime endTime, {
    String? teacherId,
    String? classroomId,
    String? excludeId,
  }) async {
    final overlaps = await getOverlappingSessions(dayOfWeek, startTime, endTime, excludeId: excludeId);
    return overlaps
        .where((s) =>
            (teacherId != null && s.teacherId == teacherId) ||
            (classroomId != null && s.classroomId == classroomId))
        .toList();
  }

  Never _throwConflict(Session conflict, String? teacherId, String? classroomId) {
    if (teacherId != null && conflict.teacherId == teacherId) {
      throw StateError('CONFLICT_TEACHER');
    }
    if (classroomId != null && conflict.classroomId == classroomId) {
      throw StateError('CONFLICT_CLASSROOM');
    }
    throw StateError('CONFLICT_TEACHER');
  }

  @override
  Future<String> create(SessionsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    final completeEntry = entry.copyWith(id: Value(id), deviceId: Value(deviceId));

    final dayOfWeek = entry.dayOfWeek.present ? entry.dayOfWeek.value : null;
    final start = entry.startTime.present ? entry.startTime.value : null;
    final end = entry.endTime.present ? entry.endTime.value : null;

    if (dayOfWeek != null && start != null && end != null) {
      await db.transaction(() async {
        final teacherId = entry.teacherId.present ? entry.teacherId.value : null;
        final classroomId = entry.classroomId.present ? entry.classroomId.value : null;
        final conflicts = await getConflictingSessions(dayOfWeek, start, end, teacherId: teacherId, classroomId: classroomId);

        for (final c in conflicts) {
          _throwConflict(c, teacherId, classroomId);
        }

        await db.into(db.sessions).insert(completeEntry);
      });
    } else {
      await db.into(db.sessions).insert(completeEntry);
    }
    return id;
  }

  @override
  Future<void> update(String id, SessionsCompanion entry) async {
    final deviceId = await DeviceId.get();
    final completeEntry = entry.copyWith(deviceId: Value(deviceId));

    final dayOfWeek = entry.dayOfWeek.present ? entry.dayOfWeek.value : null;
    final start = entry.startTime.present ? entry.startTime.value : null;
    final end = entry.endTime.present ? entry.endTime.value : null;

    if (dayOfWeek != null && start != null && end != null) {
      await db.transaction(() async {
        final teacherId = entry.teacherId.present ? entry.teacherId.value : null;
        final classroomId = entry.classroomId.present ? entry.classroomId.value : null;
        final conflicts = await getConflictingSessions(dayOfWeek, start, end, teacherId: teacherId, classroomId: classroomId, excludeId: id);

        for (final c in conflicts) {
          _throwConflict(c, teacherId, classroomId);
        }

        await (db.update(db.sessions)..where((t) => t.id.equals(id)))
            .write(completeEntry);
      });
    } else {
      await (db.update(db.sessions)..where((t) => t.id.equals(id)))
          .write(completeEntry);
    }
  }

  Future<void> archive(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.sessions)..where((t) => t.id.equals(id)))
        .write(SessionsCompanion(
          isArchived: const Value(true),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> restore(String id) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.sessions)..where((t) => t.id.equals(id)))
        .write(SessionsCompanion(
          isArchived: const Value(false),
          deviceId: Value(deviceId),
        ));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.sessions)..where((t) => t.id.equals(id))).go();
  }

  Future<({List<Session> sessions, int total})> fetchPage({
    int offset = 0,
    int limit = 20,
    String? statusFilter,
    String? searchQuery,
    int? dayFilter,
    bool includeArchived = false,
  }) async {
    var query = db.select(db.sessions);

    if (statusFilter != null && statusFilter != 'all') {
      if (statusFilter == 'archived') {
        query = query..where((t) => t.isArchived.equals(true));
      } else if (statusFilter == 'inactive') {
        query = query..where((t) => t.isArchived.equals(false) & t.isActive.equals(false));
      } else {
        query = query..where((t) => t.isArchived.equals(false) & t.isActive.equals(true));
      }
    } else {
      query = query..where((t) => includeArchived
          ? const Constant(true).equals(true)
          : t.isArchived.equals(false));
    }

    if (dayFilter != null && dayFilter > 0) {
      query = query..where((t) => t.dayOfWeek.equals(dayFilter));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim()}%';
      query = query..where((t) =>
        t.teacherId.like(q) |
        t.subjectGroupId.like(q) |
        t.classroomId.like(q),
      );
    }

    final total = await query.map((r) => r.id).get().then((ids) => ids.length);

    var allResults = await query.get();
    allResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final sessions = allResults.skip(offset).take(limit).toList();

    return (sessions: sessions, total: total);
  }
}
