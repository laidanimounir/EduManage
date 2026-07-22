import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    if (_instance != null) return _instance!;

    await _initializeSqlite();

    final dbPath = await _getDatabasePath();
    final database = AppDatabase._(NativeDatabase(File(dbPath)));
    _instance = database;
    return database;
  }

  static Future<void> _initializeSqlite() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await applySqlite3UnixLikeMigrations();
      sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    }
  }

  static Future<String> _getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'edumanage.db');
  }

  @override
  int get schemaVersion => 1;
}
