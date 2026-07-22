import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get code => text().unique()();
  TextColumn get firstNameAr => text()();
  TextColumn get lastNameAr => text()();
  TextColumn get firstNameFr => text().nullable()();
  TextColumn get lastNameFr => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get gender => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get birthPlace => text().nullable()();
  DateTimeColumn get registrationDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Students],
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
