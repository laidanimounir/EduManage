import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

class SubjectRepository extends BaseRepository {
  SubjectRepository(super.db);

  Future<List<Subject>> getAll() => db.select(db.subjects).get();

  Future<List<Subject>> getAllActive() =>
      (db.select(db.subjects)..where((t) => t.isArchived.equals(false))).get();

  Future<Subject?> getById(String id) =>
      (db.select(db.subjects)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Subject?> getByNameAr(String nameAr) =>
      (db.select(db.subjects)..where((t) => t.nameAr.equals(nameAr)))
          .getSingleOrNull();

  Future<String> create({
    required String nameAr,
    String? nameFr,
  }) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.subjects).insert(SubjectsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameFr: Value(nameFr),
      deviceId: Value(deviceId),
    ));
    return id;
  }

  Future<void> update(String id, SubjectsCompanion entry) async {
    final deviceId = await DeviceId.get();
    await (db.update(db.subjects)..where((t) => t.id.equals(id)))
        .write(entry.copyWith(deviceId: Value(deviceId)));
  }

  Future<void> delete(String id) async {
    await (db.delete(db.subjects)..where((t) => t.id.equals(id))).go();
  }
}