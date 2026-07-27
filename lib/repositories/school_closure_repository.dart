import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class SchoolClosureRepository extends BaseRepository {
  SchoolClosureRepository(super.db);

  Future<List<SchoolClosure>> getAll() {
    return (db.select(db.schoolClosures)
      ..orderBy([(t) => OrderingTerm.desc(t.closureDate)]))
        .get();
  }

  Future<List<SchoolClosure>> getUpcoming() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    return (db.select(db.schoolClosures)
      ..where((t) => t.closureDate.isBiggerOrEqualValue(todayStart))
      ..orderBy([(t) => OrderingTerm.asc(t.closureDate)]))
        .get();
  }

  Future<SchoolClosure?> getByDate(DateTime date) {
    return (db.select(db.schoolClosures)
      ..where((t) => t.closureDate.equals(date)))
        .getSingleOrNull();
  }

  Future<bool> isSchoolClosed(DateTime date) async {
    final result = await (db.select(db.schoolClosures)
      ..where((t) => t.closureDate.equals(date)))
        .get();
    return result.isNotEmpty;
  }

  Future<String> create(DateTime date, String? reason) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.schoolClosures).insert(
      SchoolClosuresCompanion(
        id: Value(id),
        closureDate: Value(date),
        reason: Value(reason),
        deviceId: Value(deviceId),
      ),
    );
    return id;
  }

  Future<void> remove(String id) async {
    await (db.delete(db.schoolClosures)
      ..where((t) => t.id.equals(id)))
        .go();
  }
}
