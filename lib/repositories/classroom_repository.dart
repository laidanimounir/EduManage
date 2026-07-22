import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

class ClassroomRepository extends BaseRepository {
  ClassroomRepository(super.db);

  Future<List<Classroom>> getAll() => db.select(db.classrooms).get();

  Future<Classroom?> getById(String id) =>
      (db.select(db.classrooms)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> create(ClassroomsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.classrooms).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> update(String id, ClassroomsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.classrooms)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.classrooms)..where((t) => t.id.equals(id))).go();
  }
}
