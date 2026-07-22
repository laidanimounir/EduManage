import '../database/app_database.dart';

abstract class BaseRepository {
  final AppDatabase db;

  BaseRepository(this.db);
}
