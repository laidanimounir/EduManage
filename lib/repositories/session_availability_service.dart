import 'package:drift/drift.dart' hide Column, Table;
import '../database/app_database.dart';
import 'settings_repository.dart';

class FreeTimeWindow {
  final int startMinutes;
  final int endMinutes;

  const FreeTimeWindow({required this.startMinutes, required this.endMinutes});

  static String formatMinutes(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Computes free slots for the recurring weekly schedule.
///
/// Operating hours come from the school settings and a day marked closed is
/// treated as fully unavailable. School closures are date-specific so they are
/// only applied when a concrete date is supplied; the weekday-level
/// availability assumes normal operation and does not permanently disable a
/// weekday slot because of a single closure date.
class SessionAvailabilityService {
  final AppDatabase db;
  final SettingsRepository _settings;

  SessionAvailabilityService(this.db) : _settings = SettingsRepository(db);

  /// For each weekday (1=Mon..7=Sun) reports whether any free window exists
  /// for the given teacher and classroom within that day's operating hours.
  Future<Map<int, bool>> getAvailableDays({
    required String teacherId,
    required String classroomId,
    String? excludeSessionId,
  }) async {
    final hours = await _settings.getOperatingHours();
    final result = <int, bool>{};
    for (var day = 1; day <= 7; day++) {
      final windows = await getFreeWindowsForDay(
        day,
        teacherId: teacherId,
        classroomId: classroomId,
        excludeSessionId: excludeSessionId,
        hours: hours[day],
      );
      result[day] = windows.isNotEmpty;
    }
    return result;
  }

  /// Returns the maximal free time ranges within the day's operating hours
  /// where neither the teacher nor the classroom has an active session.
  /// Pass [forDate] to also treat a whole-school closure date as unavailable.
  Future<List<FreeTimeWindow>> getFreeWindowsForDay(
    int dayOfWeek, {
    required String teacherId,
    required String classroomId,
    String? excludeSessionId,
    DateTime? forDate,
    DayOperatingHours? hours,
  }) async {
    final dayHours = hours ?? (await _settings.getOperatingHours())[dayOfWeek];
    if (dayHours == null || dayHours.closed) return const [];
    if (dayHours.closeMinutes <= dayHours.openMinutes) return const [];
    if (forDate != null && await isSchoolClosedOn(forDate)) return const [];

    final sessions = await (db.select(db.sessions)
      ..where((t) => t.dayOfWeek.equals(dayOfWeek) & t.isActive.equals(true) & t.isArchived.equals(false)))
        .get();

    final busyRanges = sessions
        .where((s) =>
            s.id != excludeSessionId &&
            (s.teacherId == teacherId || s.classroomId == classroomId))
        .map((s) => (
              start: s.startTime.hour * 60 + s.startTime.minute,
              end: s.endTime.hour * 60 + s.endTime.minute,
            ))
        .toList();
    busyRanges.sort((a, b) => a.start.compareTo(b.start));

    final merged = <({int start, int end})>[];
    for (final range in busyRanges) {
      if (merged.isEmpty || range.start >= merged.last.end) {
        merged.add(range);
      } else if (range.end > merged.last.end) {
        merged[merged.length - 1] = (start: merged.last.start, end: range.end);
      }
    }

    final free = <FreeTimeWindow>[];
    var cursor = dayHours.openMinutes;
    for (final range in merged) {
      final start = range.start > dayHours.openMinutes ? range.start : dayHours.openMinutes;
      final end = range.end < dayHours.closeMinutes ? range.end : dayHours.closeMinutes;
      if (start > cursor) {
        free.add(FreeTimeWindow(startMinutes: cursor, endMinutes: start));
      }
      if (end > cursor) cursor = end;
    }
    if (cursor < dayHours.closeMinutes) {
      free.add(FreeTimeWindow(startMinutes: cursor, endMinutes: dayHours.closeMinutes));
    }
    return free;
  }

  Future<bool> isSchoolClosedOn(DateTime date) async {
    final dateClean = DateTime(date.year, date.month, date.day);
    final rows = await (db.select(db.schoolClosures)
      ..where((t) => t.closureDate.equals(dateClean)))
        .get();
    return rows.isNotEmpty;
  }
}
