import '../database/app_database.dart';
import 'base_repository.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository(super.db);

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
}
