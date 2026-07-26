import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class SchoolLevelRepository extends BaseRepository {
  SchoolLevelRepository(super.db);

  Future<List<SchoolLevel>> getAll() => db.select(db.schoolLevels).get();

  Future<List<SchoolLevel>> searchByName(String query) {
    final q = '%$query%';
    return (db.select(db.schoolLevels)
      ..where((t) => t.name.like(q)))
        .get();
  }

  Future<SchoolLevel?> getByName(String name) {
    return (db.select(db.schoolLevels)
      ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
  }

  Future<String> create(String name) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.schoolLevels).insert(SchoolLevelsCompanion(
      id: Value(id),
      name: Value(name),
      deviceId: Value(deviceId),
    ));
    return id;
  }
}
