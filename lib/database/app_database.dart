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

class Teachers extends Table {
  TextColumn get id => text()();
  TextColumn get code => text().unique()();
  TextColumn get firstNameAr => text()();
  TextColumn get lastNameAr => text()();
  TextColumn get firstNameFr => text().nullable()();
  TextColumn get lastNameFr => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get idCard => text().nullable()();
  DateTimeColumn get employmentStartDate => dateTime().nullable()();
  DateTimeColumn get employmentEndDate => dateTime().nullable()();
  TextColumn get salaryType => text().withDefault(const Constant('percentage'))();
  RealColumn get teacherSharePct => real().nullable()();
  RealColumn get teacherFixedAmount => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Classrooms extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameFr => text().nullable()();
  IntColumn get floor => integer().nullable()();
  IntColumn get capacity => integer().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SubjectGroups extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameFr => text().nullable()();
  TextColumn get subjectAr => text()();
  TextColumn get subjectFr => text().nullable()();
  TextColumn get schoolLevel => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get subjectGroupId => text().references(SubjectGroups, #id)();
  TextColumn get teacherId => text().references(Teachers, #id)();
  TextColumn get classroomId => text().references(Classrooms, #id)();
  IntColumn get dayOfWeek => integer()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  RealColumn get monthlyPrice => real()();
  IntColumn get sessionsPerMonth => integer()();
  RealColumn get teacherSharePct => real().nullable()();
  RealColumn get teacherFixedAmount => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Enrollments extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get subjectGroupId => text().references(SubjectGroups, #id)();
  DateTimeColumn get enrollmentDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get customPriceOverride => real().nullable()();
  RealColumn get customDiscount => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Cancellations extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(Sessions, #id)();
  DateTimeColumn get cancelDate => dateTime()();
  TextColumn get reason => text().nullable()();
  TextColumn get cancelledByUserId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().nullable().references(Students, #id)();
  TextColumn get teacherId => text().nullable().references(Teachers, #id)();
  TextColumn get enrollmentId => text().nullable().references(Enrollments, #id)();
  TextColumn get sessionId => text().nullable().references(Sessions, #id)();
  TextColumn get type => text()();
  RealColumn get amount => real()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get createdByUserId => text().nullable()();
  TextColumn get deviceId => text()();
  TextColumn get referenceTransactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Attendance extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().nullable().references(Students, #id)();
  TextColumn get teacherId => text().nullable().references(Teachers, #id)();
  TextColumn get sessionId => text().references(Sessions, #id)();
  DateTimeColumn get attendanceDate => dateTime()();
  DateTimeColumn get checkInTime => dateTime().withDefault(currentDateAndTime)();
  TextColumn get personType => text()();
  TextColumn get checkInMethod => text().withDefault(const Constant('barcode'))();
  BoolColumn get isManualEntry => boolean().withDefault(const Constant(false))();
  TextColumn get checkedInByUserId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text().withDefault(const Constant('teacher'))();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class StudentCards extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get secureToken => text().unique()();
  TextColumn get barcodeContent => text()();
  DateTimeColumn get issuedDate => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get revokedDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [Students, Teachers, Classrooms, SubjectGroups, Sessions, Enrollments, Cancellations, Transactions, Attendance, Users, AuditLog, StudentCards, Settings],
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
