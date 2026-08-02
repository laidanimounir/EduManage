import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'base_repository.dart';

class DayOperatingHours {
  final bool closed;
  final int openMinutes;
  final int closeMinutes;

  const DayOperatingHours({
    required this.closed,
    required this.openMinutes,
    required this.closeMinutes,
  });

  static const DayOperatingHours defaultDay =
      DayOperatingHours(closed: false, openMinutes: 8 * 60, closeMinutes: 18 * 60);

  Map<String, dynamic> toJson() => {
        'open': _formatMinutes(openMinutes),
        'close': _formatMinutes(closeMinutes),
        'closed': closed,
      };

  factory DayOperatingHours.fromJson(Map<String, dynamic> json) {
    return DayOperatingHours(
      closed: json['closed'] == true,
      openMinutes: _parseMinutes(json['open']),
      closeMinutes: _parseMinutes(json['close']),
    );
  }

  static String _formatMinutes(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  static int _parseMinutes(Object? value) {
    if (value is String && value.contains(':')) {
      final parts = value.split(':');
      final h = int.tryParse(parts[0]) ?? 0;
      final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      return h * 60 + m;
    }
    return 8 * 60;
  }
}

class SettingsRepository extends BaseRepository {
  SettingsRepository(super.db);

  static const String operatingHoursKey = 'operating_hours';

  Future<String?> get(String key) async {
    final result = await (db.select(db.settings)
      ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  Future<void> set(String key, String value) async {
    await db.into(db.settings).insertOnConflictUpdate(
          SettingsCompanion(key: Value(key), value: Value(value)),
        );
  }

  Future<Map<String, String>> getAll() async {
    final rows = await db.select(db.settings).get();
    return {for (final row in rows) row.key: row.value ?? ''};
  }

  Future<void> remove(String key) async {
    await (db.delete(db.settings)..where((t) => t.key.equals(key))).go();
  }

  Future<Map<int, DayOperatingHours>> getOperatingHours() async {
    final raw = await get(operatingHoursKey);
    if (raw == null || raw.isEmpty) return defaultOperatingHours();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return defaultOperatingHours();
      final result = defaultOperatingHours();
      for (final entry in decoded.entries) {
        final weekday = int.tryParse(entry.key);
        if (weekday == null || weekday < 1 || weekday > 7) continue;
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          result[weekday] = DayOperatingHours.fromJson(value);
        }
      }
      return result;
    } catch (_) {
      return defaultOperatingHours();
    }
  }

  Future<void> setOperatingHours(Map<int, DayOperatingHours> hours) async {
    final payload = <String, dynamic>{
      for (final entry in hours.entries) '${entry.key}': entry.value.toJson(),
    };
    await set(operatingHoursKey, jsonEncode(payload));
  }

  static Map<int, DayOperatingHours> defaultOperatingHours() =>
      {for (var day = 1; day <= 7; day++) day: DayOperatingHours.defaultDay};
}
