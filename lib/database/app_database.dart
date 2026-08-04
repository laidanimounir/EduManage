import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import '../utils/uuid_helper.dart';
import '../utils/device_id.dart';

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

  TextColumn get schoolLevel => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();

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
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get gender => text().nullable()();
  IntColumn get overdueThresholdDays => integer().nullable()();
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
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
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
  IntColumn get capacity => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
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
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  TextColumn get makeupForSessionId => text().nullable().references(Sessions, #id)();
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
  BoolColumn get isTransferred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class EnrollmentWaitlist extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get subjectGroupId => text().references(SubjectGroups, #id)();
  DateTimeColumn get requestedAt => dateTime().withDefault(currentDateAndTime)();
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
  TextColumn get rateSnapshot => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get priceSnapshot => text().nullable()();
  IntColumn get cycleNumber => integer().nullable()();

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
  TextColumn get status => text().withDefault(const Constant('present'))();
  IntColumn get minutesLate => integer().nullable()();
  TextColumn get absenceReason => text().nullable()();
  BoolColumn get isBackdated => boolean().withDefault(const Constant(false))();
  TextColumn get modifiedByUserId => text().nullable()();
  TextColumn get modifiedAt => text().nullable()();

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

class TeacherSubjectGroups extends Table {
  TextColumn get id => text()();
  TextColumn get teacherId => text().references(Teachers, #id)();
  TextColumn get subjectGroupId => text().references(SubjectGroups, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SchoolClosures extends Table {
  TextColumn get id => text()();
  DateTimeColumn get closureDate => dateTime().unique()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SchoolLevels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get deviceId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class PaymentAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get paymentTransactionId => text().references(Transactions, #id)();
  TextColumn get chargeTransactionId => text().references(Transactions, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ClosedPeriods extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  DateTimeColumn get closedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get closedByUserId => text().nullable()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Families extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get discountPercent => real().nullable()();
  RealColumn get discountFixed => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyMembers extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get studentId => text().references(Students, #id)();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SpecialCases extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get caseType => text()();
  RealColumn get discountPercent => real().nullable()();
  RealColumn get discountFixed => real().nullable()();
  TextColumn get reason => text()();
  TextColumn get approvedByUserId => text().nullable().references(Users, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get reviewDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Students, Teachers, Classrooms, SubjectGroups, Sessions, Enrollments, EnrollmentWaitlist, Cancellations, Transactions, Attendance, Users, AuditLog, StudentCards, Settings, TeacherSubjectGroups, SchoolClosures, SchoolLevels, PaymentAllocations, ClosedPeriods, Families, FamilyMembers, SpecialCases],
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
      final tmpDir = await getTemporaryDirectory();
      sqlite3.tempDirectory = tmpDir.path;
    }
  }

  static Future<String> _getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'edumanage.db');
  }

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.alterTable(TableMigration(students,
          newColumns: [
            students.schoolLevel,
            students.isArchived,
            students.photoPath,
          ],
        ));
      }
      if (from < 3) {
        await m.createTable(schoolLevels);
      }
      if (from < 4) {
        await m.alterTable(TableMigration(teachers,
          newColumns: [
            teachers.isArchived,
            teachers.photoPath,
            teachers.gender,
            teachers.overdueThresholdDays,
          ],
        ));
        await m.alterTable(TableMigration(transactions,
          newColumns: [
            transactions.rateSnapshot,
          ],
        ));
        await m.createTable(teacherSubjectGroups);
      }
      if (from < 5) {
        await m.alterTable(TableMigration(sessions,
          newColumns: [
            sessions.isArchived,
          ],
        ));
        await m.createTable(schoolClosures);
      }
      if (from < 6) {
        await m.alterTable(TableMigration(subjectGroups,
          newColumns: [
            subjectGroups.capacity,
            subjectGroups.isArchived,
          ],
        ));
        await m.alterTable(TableMigration(classrooms,
          newColumns: [
            classrooms.isArchived,
          ],
        ));
        await m.alterTable(TableMigration(enrollments,
          newColumns: [
            enrollments.isTransferred,
          ],
        ));
        await m.createTable(enrollmentWaitlist);
      }
      if (from < 7) {
        await m.alterTable(TableMigration(transactions,
          newColumns: [
            transactions.paymentMethod,
            transactions.priceSnapshot,
          ],
        ));
      }
      if (from < 8) {
        await m.createTable(paymentAllocations);
      }
      if (from < 9) {
        await m.createTable(closedPeriods);
      }
      if (from < 10) {
        await m.alterTable(TableMigration(transactions,
          newColumns: [
            transactions.cycleNumber,
          ],
        ));
      }
      if (from < 11) {
        await m.createTable(families);
        await m.createTable(familyMembers);
      }
      if (from < 12) {
        await m.alterTable(TableMigration(attendance,
          newColumns: [
            attendance.status,
            attendance.minutesLate,
            attendance.absenceReason,
            attendance.isBackdated,
            attendance.modifiedByUserId,
            attendance.modifiedAt,
          ],
        ));
        await m.alterTable(TableMigration(sessions,
          newColumns: [
            sessions.makeupForSessionId,
          ],
        ));
      }
      if (from < 13) {
        await m.createTable(specialCases);
      }
    },
  );

  Future<double> getStudentBalance(String studentId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(CASE '
      'WHEN type IN (\'session_charge\', \'correction\', \'registration_fee\') THEN amount '
      'WHEN type IN (\'student_payment\', \'discount\', \'reversal\', \'registration_fee_payment\') THEN -amount '
      'ELSE 0 END), 0) AS balance '
      'FROM transactions WHERE student_id = ?',
      variables: [Variable.withString(studentId)],
    );
    return query.map((row) => row.read<double>('balance')).getSingle();
  }

  Future<double> getStudentTotalCharged(String studentId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total '
      'FROM transactions WHERE student_id = ? AND type IN (\'session_charge\', \'correction\', \'registration_fee\')',
      variables: [Variable.withString(studentId)],
    );
    return query.map((row) => row.read<double>('total')).getSingle();
  }

  Future<double> getStudentTotalPaid(String studentId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total '
      'FROM transactions WHERE student_id = ? AND type IN (\'student_payment\', \'discount\', \'reversal\', \'registration_fee_payment\')',
      variables: [Variable.withString(studentId)],
    );
    return query.map((row) => row.read<double>('total')).getSingle();
  }

  Future<bool> isRegistrationFeePaid(String studentId) async {
    final result = await customSelect(
      'SELECT '
      '(SELECT COUNT(*) FROM transactions WHERE student_id = ? AND type = \'registration_fee_payment\') AS paid, '
      '(SELECT COUNT(*) FROM transactions WHERE student_id = ? AND type = \'registration_fee\') AS charged',
      variables: [Variable.withString(studentId), Variable.withString(studentId)],
    ).getSingle();
    return result.read<int>('paid') >= result.read<int>('charged');
  }

  Future<Map<String, dynamic>?> getLastStudentPayment(String studentId) async {
    final rows = await customSelect(
      'SELECT amount, transaction_date FROM transactions '
      'WHERE student_id = ? AND type = \'student_payment\' '
      'ORDER BY transaction_date DESC LIMIT 1',
      variables: [Variable.withString(studentId)],
    ).get();
    if (rows.isEmpty) return null;
    return {
      'amount': rows.first.read<double>('amount'),
      'date': rows.first.read<DateTime>('transaction_date'),
    };
  }

  Future<List<Map<String, dynamic>>> getStudentPickerList() async {
    final studentRows = await customSelect(
      'SELECT s.id, s.code, s.first_name_ar, s.last_name_ar, s.first_name_fr, s.last_name_fr, s.school_level, '
      "COALESCE((SELECT SUM(CASE "
      "WHEN t.type IN ('session_charge', 'correction', 'registration_fee') THEN t.amount "
      "WHEN t.type IN ('student_payment', 'discount', 'reversal', 'registration_fee_payment') THEN -t.amount "
      "ELSE 0 END) FROM transactions t WHERE t.student_id = s.id), 0) AS balance "
      'FROM students s WHERE s.is_archived = 0',
    ).get();

    final enrollmentRows = await customSelect(
      'SELECT e.student_id AS student_id, sg.name_ar AS group_name, sg.subject_ar AS subject_ar, '
      'se.day_of_week AS day_of_week, se.start_time AS start_time '
      'FROM enrollments e '
      'JOIN subject_groups sg ON sg.id = e.subject_group_id '
      'JOIN sessions se ON se.subject_group_id = sg.id AND se.is_active = 1 AND se.is_archived = 0 '
      "WHERE e.status = 'active' "
      'ORDER BY e.student_id, se.day_of_week, se.start_time',
    ).get();

    final groupsByStudent = <String, List<Map<String, dynamic>>>{};
    for (final row in enrollmentRows) {
      final sid = row.read<String>('student_id');
      groupsByStudent.putIfAbsent(sid, () => []).add({
        'name': row.read<String>('group_name'),
        'subject': row.read<String>('subject_ar'),
        'dayOfWeek': row.read<int>('day_of_week'),
        'startTime': row.read<DateTime>('start_time'),
      });
    }

    return studentRows.map((row) {
      final id = row.read<String>('id');
      return {
        'id': id,
        'code': row.read<String>('code'),
        'firstNameAr': row.read<String>('first_name_ar'),
        'lastNameAr': row.read<String>('last_name_ar'),
        'firstNameFr': row.read<String?>('first_name_fr'),
        'lastNameFr': row.read<String?>('last_name_fr'),
        'schoolLevel': row.read<String?>('school_level'),
        'balance': row.read<double>('balance'),
        'groups': groupsByStudent[id] ?? const [],
      };
    }).toList();
  }

  Future<double> getTeacherPayoutBalance(String teacherId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(CASE '
      'WHEN type IN (\'teacher_payout\', \'correction\') THEN amount '
      'WHEN type IN (\'reversal\') THEN -amount '
      'ELSE 0 END), 0) AS balance '
      'FROM transactions WHERE teacher_id = ?',
      variables: [Variable.withString(teacherId)],
    );
    return query.map((row) => row.read<double>('balance')).getSingle();
  }

  Future<Map<String, double>> getStudentBalancesForIds(List<String> ids) async {
    if (ids.isEmpty) return {};
    final placeholders = ids.map((_) => '?').join(',');
    final query = customSelect(
      'SELECT student_id, COALESCE(SUM(CASE '
      'WHEN type IN (\'session_charge\', \'correction\', \'registration_fee\') THEN amount '
      'WHEN type IN (\'student_payment\', \'discount\', \'reversal\', \'registration_fee_payment\') THEN -amount '
      'ELSE 0 END), 0) AS balance '
      'FROM transactions WHERE student_id IN ($placeholders) '
      'GROUP BY student_id',
      variables: [for (final id in ids) Variable.withString(id)],
    );
    final rows = await query.get();
    final map = <String, double>{};
    for (final row in rows) {
      map[row.read<String>('student_id')] = row.read<double>('balance');
    }
    for (final id in ids) {
      map.putIfAbsent(id, () => 0);
    }
    return map;
  }

  Future<double> getTeacherTotalEarned(String teacherId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(CASE '
      'WHEN type IN (\'teacher_payout\', \'correction\') THEN amount '
      'WHEN type IN (\'reversal\', \'session_cancellation_reversal\') THEN -amount '
      'ELSE 0 END), 0) AS total '
      'FROM transactions WHERE teacher_id = ?',
      variables: [Variable.withString(teacherId)],
    );
    return query.map((row) => row.read<double>('total')).getSingle();
  }

  Future<double> getTeacherTotalPaid(String teacherId) {
    final query = customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total '
      'FROM transactions WHERE teacher_id = ? AND type = \'teacher_payout\'',
      variables: [Variable.withString(teacherId)],
    );
    return query.map((row) => row.read<double>('total')).getSingle();
  }

  Future<int> getTeacherAttendanceCount(String teacherId) {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM attendance WHERE teacher_id = ?',
      variables: [Variable.withString(teacherId)],
    );
    return query.map((row) => row.read<int>('cnt')).getSingle();
  }

  Future<bool> hasTeacherTransactions(String teacherId) async {
    final result = await customSelect(
      'SELECT COUNT(*) AS cnt FROM transactions WHERE teacher_id = ?',
      variables: [Variable.withString(teacherId)],
    ).getSingle();
    return result.read<int>('cnt') > 0;
  }

  Future<DateTime?> getTeacherLastPayoutDate(String teacherId) async {
    final result = await customSelect(
      'SELECT transaction_date FROM transactions WHERE teacher_id = ? AND type = \'teacher_payout\' ORDER BY transaction_date DESC LIMIT 1',
      variables: [Variable.withString(teacherId)],
    ).get();
    if (result.isEmpty) return null;
    return result.first.read<DateTime>('transaction_date');
  }

  Future<List<Transaction>> getTeacherPayoutHistory(String teacherId) {
    return (select(transactions)
      ..where((t) => t.teacherId.equals(teacherId) & t.type.equals('teacher_payout'))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Map<String, dynamic>>> getSessionAttendanceHistory(String sessionId) async {
    final query = customSelect(
      'SELECT a.attendance_date, a.check_in_time, a.person_type, '
      's.first_name_ar AS student_first_name, s.last_name_ar AS student_last_name, '
      's.code AS student_code, '
      'CASE WHEN c.id IS NOT NULL THEN 1 ELSE 0 END AS is_cancelled, '
      'CASE WHEN sc.id IS NOT NULL THEN 1 ELSE 0 END AS is_school_closed '
      'FROM attendance a '
      'LEFT JOIN students s ON a.student_id = s.id '
      'LEFT JOIN cancellations c ON c.session_id = a.session_id AND c.cancel_date = a.attendance_date '
      'LEFT JOIN school_closures sc ON sc.closure_date = a.attendance_date '
      'WHERE a.session_id = ? '
      'ORDER BY a.attendance_date DESC, a.check_in_time DESC',
      variables: [Variable.withString(sessionId)],
    );
    final rows = await query.get();
    return rows.map((row) => {
      'attendance_date': row.read<DateTime>('attendance_date'),
      'check_in_time': row.read<DateTime>('check_in_time'),
      'person_type': row.read<String>('person_type'),
      'student_first_name': row.read<String?>('student_first_name'),
      'student_last_name': row.read<String?>('student_last_name'),
      'student_code': row.read<String?>('student_code'),
      'is_cancelled': row.read<int>('is_cancelled'),
      'is_school_closed': row.read<int>('is_school_closed'),
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getTeacherSessionEarnings(String teacherId) async {
    final query = customSelect(
      'SELECT s.id AS session_id, sg.name_ar AS group_name, s.day_of_week, '
      's.start_time, s.end_time, s.monthly_price, s.sessions_per_month, '
      's.teacher_share_pct, s.teacher_fixed_amount, '
      '(SELECT COUNT(*) FROM attendance a WHERE a.session_id = s.id) AS attendance_count, '
      'COALESCE((SELECT SUM(t.amount) FROM transactions t WHERE t.session_id = s.id AND t.teacher_id = s.teacher_id AND t.type = \'teacher_payout\'), 0) AS paid, '
      'COALESCE((SELECT SUM(t.amount) FROM transactions t WHERE t.session_id = s.id AND t.teacher_id = s.teacher_id AND t.type = \'session_cancellation_reversal\'), 0) AS deducted '
      'FROM sessions s '
      'JOIN subject_groups sg ON s.subject_group_id = sg.id '
      'WHERE s.teacher_id = ? AND s.is_archived = 0 '
      'ORDER BY s.day_of_week, s.start_time',
      variables: [Variable.withString(teacherId)],
    );
    final rows = await query.get();
    return rows.map((row) => {
      'session_id': row.read<String>('session_id'),
      'group_name': row.read<String>('group_name'),
      'day_of_week': row.read<int>('day_of_week'),
      'start_time': row.read<DateTime>('start_time'),
      'end_time': row.read<DateTime>('end_time'),
      'monthly_price': row.read<double>('monthly_price'),
      'sessions_per_month': row.read<int>('sessions_per_month'),
      'teacher_share_pct': row.read<double?>('teacher_share_pct'),
      'teacher_fixed_amount': row.read<double?>('teacher_fixed_amount'),
      'attendance_count': row.read<int>('attendance_count'),
      'paid': row.read<double>('paid'),
      'deducted': row.read<double>('deducted'),
    }).toList();
  }

  Future<bool> isSessionHappeningNow(String sessionId, DateTime now) async {
    final session = await (select(sessions)
      ..where((t) => t.id.equals(sessionId)))
        .getSingleOrNull();
    if (session == null || !session.isActive || session.isArchived) return false;
    if (session.dayOfWeek != now.weekday) return false;

    final checkMinutes = now.hour * 60 + now.minute;
    final startMinutes = session.startTime.hour * 60 + session.startTime.minute;
    final endMinutes = session.endTime.hour * 60 + session.endTime.minute;
    if (checkMinutes < startMinutes || checkMinutes >= endMinutes) return false;

    final dateClean = DateTime(now.year, now.month, now.day);
    final closed = await customSelect(
      'SELECT COUNT(*) AS cnt FROM school_closures WHERE closure_date = ?',
      variables: [Variable.withDateTime(dateClean)],
    ).map((row) => row.read<int>('cnt')).getSingle();
    if (closed > 0) return false;

    final cancelled = await customSelect(
      'SELECT COUNT(*) AS cnt FROM cancellations WHERE session_id = ? AND cancel_date = ?',
      variables: [Variable.withString(sessionId), Variable.withDateTime(dateClean)],
    ).map((row) => row.read<int>('cnt')).getSingle();
    if (cancelled > 0) return false;

    return true;
  }

  Future<Map<String, dynamic>> getTransactionsPage({
    required int offset,
    required int limit,
    String? typeFilter,
    String? studentFilter,
    String? searchQuery,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sortField,
    bool sortAsc = false,
    String? personCategory,
  }) async {
    final conditions = <String>[];
    final variables = <Variable>[];

    if (typeFilter != null && typeFilter != 'all') {
      conditions.add('t.type = ?');
      variables.add(Variable.withString(typeFilter));
    }
    if (studentFilter != null) {
      conditions.add('t.student_id = ?');
      variables.add(Variable.withString(studentFilter));
    }
    if (dateFrom != null) {
      conditions.add('t.transaction_date >= ?');
      variables.add(Variable.withDateTime(dateFrom));
    }
    if (dateTo != null) {
      final toEnd = DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59);
      conditions.add('t.transaction_date <= ?');
      variables.add(Variable.withDateTime(toEnd));
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('(s.first_name_ar LIKE ? OR s.last_name_ar LIKE ? OR s.code LIKE ? '
          'OR tch.first_name_ar LIKE ? OR tch.last_name_ar LIKE ? OR tch.code LIKE ?)');
      final like = '%$searchQuery%';
      for (int i = 0; i < 6; i++) {
        variables.add(Variable.withString(like));
      }
    }
    if (personCategory == 'students') {
      conditions.add('t.student_id IS NOT NULL');
    } else if (personCategory == 'teachers') {
      conditions.add('t.teacher_id IS NOT NULL');
    }

    final whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

    final sortCol = sortField == 'date' ? 't.transaction_date' :
        sortField == 'amount' ? 't.amount' :
        sortField == 'type' ? 't.type' :
        't.transaction_date';
    final sortDir = sortAsc ? 'ASC' : 'DESC';

    final countQuery = 'SELECT COUNT(*) AS cnt FROM transactions t '
        'LEFT JOIN students s ON t.student_id = s.id '
        'LEFT JOIN teachers tch ON t.teacher_id = tch.id '
        '$whereClause';
    final countResult = await customSelect(countQuery, variables: variables).getSingle();
    final total = countResult.read<int>('cnt');

    final dataQuery = 'SELECT t.*, '
        's.first_name_ar AS student_first, s.last_name_ar AS student_last, s.code AS student_code, '
        'tch.first_name_ar AS teacher_first, tch.last_name_ar AS teacher_last, tch.code AS teacher_code '
        'FROM transactions t '
        'LEFT JOIN students s ON t.student_id = s.id '
        'LEFT JOIN teachers tch ON t.teacher_id = tch.id '
        '$whereClause '
        'ORDER BY $sortCol $sortDir '
        'LIMIT ? OFFSET ?';
    final dataVars = [...variables, Variable.withInt(limit), Variable.withInt(offset)];
    final rows = await customSelect(dataQuery, variables: dataVars).get();

    final transactions = rows.map((row) {
      final tx = Transaction(
        id: row.read<String>('id'),
        studentId: row.read<String?>('student_id'),
        teacherId: row.read<String?>('teacher_id'),
        enrollmentId: row.read<String?>('enrollment_id'),
        sessionId: row.read<String?>('session_id'),
        type: row.read<String>('type'),
        amount: row.read<double>('amount'),
        transactionDate: row.read<DateTime>('transaction_date'),
        note: row.read<String?>('note'),
        createdByUserId: row.read<String?>('created_by_user_id'),
        deviceId: row.read<String>('device_id'),
        referenceTransactionId: row.read<String?>('reference_transaction_id'),
        rateSnapshot: row.read<String?>('rate_snapshot'),
        createdAt: row.read<DateTime>('created_at'),
        paymentMethod: row.read<String?>('payment_method'),
        priceSnapshot: row.read<String?>('price_snapshot'),
      );
      return {
        'transaction': tx,
        'studentName': row.read<String?>('student_first') != null
            ? '${row.read<String?>('student_first')} ${row.read<String?>('student_last')}'
            : null,
        'studentCode': row.read<String?>('student_code'),
        'teacherName': row.read<String?>('teacher_first') != null
            ? '${row.read<String?>('teacher_first')} ${row.read<String?>('teacher_last')}'
            : null,
        'teacherCode': row.read<String?>('teacher_code'),
      };
    }).toList();

    return {'total': total, 'transactions': transactions};
  }

  Future<Map<String, dynamic>> getStudentBalancesPage({
    required int offset,
    required int limit,
    String? statusFilter,
    String? schoolLevel,
    String? groupId,
    String? searchQuery,
    String? sortField,
    bool sortAsc = false,
  }) async {
    final conditions = <String>['s.is_archived = 0'];
    final variables = <Variable>[];

    if (schoolLevel != null && schoolLevel != 'all') {
      conditions.add('s.school_level = ?');
      variables.add(Variable.withString(schoolLevel));
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('(s.first_name_ar LIKE ? OR s.last_name_ar LIKE ? OR s.code LIKE ?)');
      final like = '%$searchQuery%';
      variables.add(Variable.withString(like));
      variables.add(Variable.withString(like));
      variables.add(Variable.withString(like));
    }
    if (groupId != null && groupId != 'all') {
      conditions.add('s.id IN (SELECT e.student_id FROM enrollments e WHERE e.subject_group_id = ? AND e.status = \'active\')');
      variables.add(Variable.withString(groupId));
    }

    final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

    final sortCol = sortField == 'name' ? 's.first_name_ar' :
        sortField == 'code' ? 's.code' :
        sortField == 'debt' ? 'balance' :
        'balance';
    final sortDir = sortAsc ? 'ASC' : 'DESC';

    final countQuery = 'SELECT COUNT(*) AS cnt FROM students s $whereClause';
    final countResult = await customSelect(countQuery, variables: variables).getSingle();
    final total = countResult.read<int>('cnt');

    final dataQuery = 'SELECT s.id, s.first_name_ar, s.last_name_ar, s.code, s.school_level, '
        'COALESCE((SELECT SUM(CASE WHEN t.type IN (\'session_charge\',\'correction\',\'registration_fee\') THEN t.amount '
        'WHEN t.type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\') THEN -t.amount ELSE 0 END) '
        'FROM transactions t WHERE t.student_id = s.id), 0) AS balance, '
        'COALESCE((SELECT SUM(t.amount) FROM transactions t WHERE t.student_id = s.id AND t.type IN (\'session_charge\',\'correction\',\'registration_fee\')), 0) AS total_charged, '
        'COALESCE((SELECT SUM(t.amount) FROM transactions t WHERE t.student_id = s.id AND t.type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\')), 0) AS total_paid '
        'FROM students s $whereClause ';

    String dataQueryFinal;
    if (statusFilter == 'owing') {
      dataQueryFinal = '$dataQuery HAVING balance > 0 ';
    } else if (statusFilter == 'settled') {
      dataQueryFinal = '$dataQuery HAVING balance = 0 ';
    } else if (statusFilter == 'credit') {
      dataQueryFinal = '$dataQuery HAVING balance < 0 ';
    } else if (statusFilter == 'unbilled') {
      dataQueryFinal = '$dataQuery '
          'AND s.id IN (SELECT DISTINCT e.student_id FROM enrollments e WHERE e.status = \'active\' AND e.is_transferred = 0) '
          'AND s.id NOT IN (SELECT DISTINCT t.student_id FROM transactions t WHERE t.type = \'session_charge\') ';
    } else {
      dataQueryFinal = dataQuery;
    }

    dataQueryFinal += 'ORDER BY $sortCol $sortDir '
        'LIMIT ? OFFSET ?';

    final dataVars = [...variables, Variable.withInt(limit), Variable.withInt(offset)];
    final rows = await customSelect(dataQueryFinal, variables: dataVars).get();

    final entries = rows.map((row) => {
      'studentId': row.read<String>('id'),
      'firstName': row.read<String>('first_name_ar'),
      'lastName': row.read<String>('last_name_ar'),
      'code': row.read<String>('code'),
      'schoolLevel': row.read<String?>('school_level'),
      'balance': row.read<double>('balance'),
      'totalCharged': row.read<double>('total_charged'),
      'totalPaid': row.read<double>('total_paid'),
    }).toList();

    return {'total': total, 'entries': entries};
  }

  Future<DateTime?> getOldestUnpaidChargeDate(String studentId) async {
    final result = await customSelect(
      'SELECT MIN(t.transaction_date) AS oldest_date FROM transactions t '
      'WHERE t.student_id = ? AND t.type IN (\'session_charge\', \'registration_fee\', \'correction\') '
      'AND t.amount > COALESCE((SELECT SUM(pa.amount) FROM payment_allocations pa WHERE pa.charge_transaction_id = t.id), 0)',
      variables: [Variable.withString(studentId)],
    ).getSingle();
    return result.read<DateTime?>('oldest_date');
  }

  Future<bool> isPeriodClosed(int year, int month) async {
    final result = await customSelect(
      'SELECT COUNT(*) AS cnt FROM closed_periods WHERE year = ? AND month = ?',
      variables: [Variable.withInt(year), Variable.withInt(month)],
    ).getSingle();
    return result.read<int>('cnt') > 0;
  }

  Future<void> closePeriod(int year, int month, String userId) async {
    await into(closedPeriods).insert(ClosedPeriodsCompanion(
      id: Value(UuidHelper.generate()),
      year: Value(year),
      month: Value(month),
      closedByUserId: Value(userId),
      deviceId: Value(await DeviceId.get()),
    ));
  }

  Future<Map<String, double>> getPeriodSummary({DateTime? from, DateTime? to}) async {
    final now = DateTime.now();
    final start = from ?? DateTime(now.year, 1, 1);
    final end = to != null
        ? DateTime(to.year, to.month, to.day, 23, 59, 59)
        : (from != null ? DateTime(from.year, from.month + 1, 0, 23, 59, 59) : DateTime(now.year, now.month + 1, 0, 23, 59, 59));

    final revenue = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM transactions '
      'WHERE type IN (\'student_payment\', \'registration_fee_payment\') AND transaction_date >= ? AND transaction_date <= ?',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
    ).map((r) => r.read<double>('total')).getSingle();

    final expenses = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM transactions '
      'WHERE type IN (\'expense\', \'teacher_payout\') AND transaction_date >= ? AND transaction_date <= ?',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
    ).map((r) => r.read<double>('total')).getSingle();

    final outstanding = await customSelect(
      'SELECT COALESCE(SUM(CASE WHEN type IN (\'session_charge\',\'correction\',\'registration_fee\') THEN amount '
      'WHEN type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\') THEN -amount ELSE 0 END), 0) AS total FROM transactions',
      variables: [],
    ).map((r) => r.read<double>('total')).getSingle();

    return {'revenue': revenue, 'expenses': expenses, 'outstanding': outstanding};
  }

  Future<List<Map<String, dynamic>>> getMonthlyRevenueAndExpenses(int months) async {
    final now = DateTime.now();
    final results = <Map<String, dynamic>>[];
    for (var i = months - 1; i >= 0; i--) {
      final y = now.month - i <= 0 ? now.year - 1 : now.year;
      final m = ((now.month - i - 1) % 12) + 1;
      final start = DateTime(y, m, 1);
      final end = DateTime(y, m + 1, 0, 23, 59, 59);
      final row = await customSelect(
        'SELECT '
        'COALESCE(SUM(CASE WHEN type IN (\'student_payment\',\'registration_fee_payment\') THEN amount ELSE 0 END), 0) AS revenue, '
        'COALESCE(SUM(CASE WHEN type IN (\'expense\',\'teacher_payout\') THEN amount ELSE 0 END), 0) AS expenses '
        'FROM transactions WHERE transaction_date >= ? AND transaction_date <= ?',
        variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
      ).getSingle();
      results.add({
        'year': y,
        'month': m,
        'revenue': row.read<double>('revenue'),
        'expenses': row.read<double>('expenses'),
      });
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> getMonthlyTrend(int months) async {
    final now = DateTime.now();
    final results = <Map<String, dynamic>>[];
    for (var i = months - 1; i >= 0; i--) {
      final y = now.month - i <= 0 ? now.year - 1 : now.year;
      final m = ((now.month - i - 1) % 12) + 1;
      final start = DateTime(y, m, 1);
      final end = DateTime(y, m + 1, 0, 23, 59, 59);
      final row = await customSelect(
        'SELECT '
        'COALESCE(SUM(CASE WHEN type IN (\'student_payment\',\'registration_fee_payment\') THEN amount ELSE 0 END), 0) AS revenue, '
        'COALESCE(SUM(CASE WHEN type IN (\'session_charge\',\'correction\',\'registration_fee\') THEN amount '
        'WHEN type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\') THEN -amount ELSE 0 END), 0) AS debt_balance '
        'FROM transactions WHERE transaction_date <= ?',
        variables: [Variable.withDateTime(end)],
      ).getSingle();
      final revenue = row.read<double>('revenue');
      final debt = row.read<double>('debt_balance');
      final collectionRate = revenue > 0 ? ((revenue - debt) / revenue * 100).clamp(0, 100) : 0.0;
      results.add({
        'year': y, 'month': m, 'revenue': revenue, 'collectionRate': collectionRate,
      });
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> getRevenueByPaymentMethod(DateTime from, DateTime to) async {
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    return await customSelect(
      'SELECT payment_method, COALESCE(SUM(amount), 0) AS total FROM transactions '
      'WHERE type = \'student_payment\' AND transaction_date >= ? AND transaction_date <= ? '
      'GROUP BY payment_method',
      variables: [Variable.withDateTime(from), Variable.withDateTime(end)],
    ).map((r) => {'method': r.read<String>('payment_method'), 'total': r.read<double>('total')}).get();
  }

  Future<List<Map<String, dynamic>>> getStudentCountByLevel() async {
    return await customSelect(
      'SELECT school_level, COUNT(*) AS cnt FROM students WHERE is_archived = 0 AND school_level IS NOT NULL GROUP BY school_level',
    ).map((r) => {'level': r.read<String>('school_level'), 'count': r.read<int>('cnt')}).get();
  }

  Future<List<Map<String, dynamic>>> getDebtByAgingBucket({int bucket1 = 30, int bucket2 = 60, int bucket3 = 90}) async {
    final now = DateTime.now();
    final thresholds = [0, bucket1, bucket2, bucket3];
    final labels = ['<$bucket1 d', '${bucket1}-${bucket2} d', '${bucket2}-${bucket3} d', '>$bucket3 d'];
    final results = <Map<String, dynamic>>[];
    final allSettled = await customSelect(
      'SELECT COUNT(*) AS cnt FROM students s WHERE s.is_archived = 0 AND '
      '(SELECT COALESCE(SUM(CASE WHEN t.type IN (\'session_charge\',\'correction\',\'registration_fee\') THEN t.amount '
      'WHEN t.type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\') THEN -t.amount ELSE 0 END), 0) FROM transactions t WHERE t.student_id = s.id) <= 0',
    ).getSingle();
    results.add({'label': 'Settled', 'count': allSettled.read<int>('cnt')});
    for (var i = 0; i < thresholds.length; i++) {
      final minDays = thresholds[i];
      final maxDays = i < thresholds.length - 1 ? thresholds[i + 1] : 9999;
      final isLast = i == thresholds.length - 1;
      final row = await customSelect(
        'SELECT COUNT(DISTINCT s.id) AS cnt FROM students s '
        'JOIN transactions t ON s.id = t.student_id AND t.type = \'session_charge\' '
        'WHERE s.is_archived = 0 AND t.transaction_date <= ? '
        'AND (SELECT COALESCE(SUM(CASE WHEN tt.type IN (\'session_charge\',\'correction\',\'registration_fee\') THEN tt.amount '
        'WHEN tt.type IN (\'student_payment\',\'discount\',\'reversal\',\'registration_fee_payment\') THEN -tt.amount ELSE 0 END), 0) FROM transactions tt WHERE tt.student_id = s.id) > 0'
        '${isLast ? '' : ' AND t.transaction_date > ?'}',
        variables: [Variable.withDateTime(now.subtract(Duration(days: minDays))),
          if (!isLast) Variable.withDateTime(now.subtract(Duration(days: maxDays)))],
      ).getSingle();
      results.add({'label': labels[i], 'count': row.read<int>('cnt')});
    }
    return results;
  }

  Future<Map<int, Map<int, int>>> getSessionHeatmap() async {
    final rows = await customSelect(
      'SELECT day_of_week, CAST(strftime(\'%H\', start_time) AS INTEGER) AS hour, COUNT(*) AS cnt '
      'FROM sessions WHERE is_active = 1 AND is_archived = 0 GROUP BY day_of_week, hour',
    ).get();
    final map = <int, Map<int, int>>{};
    for (final r in rows) {
      final day = r.read<int>('day_of_week');
      final hour = r.read<int>('hour');
      final cnt = r.read<int>('cnt');
      map.putIfAbsent(day, () => {});
      map[day]![hour] = cnt;
    }
    return map;
  }

  Future<double> getFamilyDiscountTotal(DateTime from, DateTime to) async {
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    final row = await customSelect(
      'SELECT COALESCE(SUM(t.amount), 0) AS total FROM transactions t '
      'JOIN family_members fm ON t.student_id = fm.student_id '
      'WHERE t.type = \'discount\' AND t.transaction_date >= ? AND t.transaction_date <= ?',
      variables: [Variable.withDateTime(from), Variable.withDateTime(end)],
    ).getSingle();
    return row.read<double>('total');
  }

  Future<Map<String, double>> getPreviousPeriodComparison({
    required String metric,
    required DateTime from,
    required DateTime to,
  }) async {
    final duration = to.difference(from);
    final prevTo = from.subtract(const Duration(days: 1));
    final prevFrom = prevTo.subtract(duration);
    final prev = await getPeriodSummary(from: prevFrom, to: prevTo);
    return prev;
  }

  Future<Map<String, dynamic>> getBillingCycleHealth() async {
    final totalStudents = await (select(students)..where((t) => t.isArchived.equals(false))).map((r) => r.id).get().then((ids) => ids.length);
    final closedCycles = await (select(closedPeriods)).map((r) => r.year).get().then((rows) => rows.length);
    final midCycle = await customSelect(
      'SELECT COUNT(DISTINCT t.student_id) AS cnt FROM transactions t '
      'WHERE t.type = \'session_charge\' AND t.cycle_number IS NOT NULL',
    ).getSingle();
    final openCycles = await customSelect(
      'SELECT COUNT(DISTINCT t.cycle_number) AS cnt FROM transactions t WHERE t.type = \'session_charge\'',
    ).getSingle();
    return {
      'totalStudents': totalStudents,
      'closedCycles': closedCycles,
      'openCycles': openCycles.read<int>('cnt'),
      'midCycleStudents': midCycle.read<int>('cnt'),
    };
  }

  Future<Map<String, dynamic>> getTeacherPayoutSummary() async {
    final totalEarned = await customSelect(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM transactions WHERE type = \'teacher_payout\'',
    ).getSingle();
    final teacherDues = await customSelect(
      'SELECT t.id, t.first_name_ar, t.last_name_ar, t.code, t.overdue_threshold_days, '
      '(SELECT COALESCE(SUM(tt.amount), 0) FROM transactions tt WHERE tt.teacher_id = t.id AND tt.type = \'teacher_payout\') AS paid_out, '
      '(SELECT MAX(tt.transaction_date) FROM transactions tt WHERE tt.teacher_id = t.id AND tt.type = \'teacher_payout\') AS last_payout '
      'FROM teachers t WHERE t.is_archived = 0 AND t.employment_end_date IS NULL '
      'ORDER BY last_payout ASC NULLS FIRST LIMIT 5',
    ).map((r) => {
      'id': r.read<String>('id'),
      'name': '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')}',
      'code': r.read<String>('code'),
      'paidOut': r.read<double>('paid_out'),
      'lastPayout': r.read<DateTime?>('last_payout'),
      'thresholdDays': r.read<int?>('overdue_threshold_days'),
    }).get();
    return {
      'totalPayouts': totalEarned.read<double>('total'),
      'topOverdueTeachers': teacherDues,
    };
  }

  Future<Map<String, int>> getEnrollmentTrend(DateTime from, DateTime to) async {
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    final newEnrollments = await customSelect(
      'SELECT COUNT(*) AS cnt FROM enrollments WHERE enrollment_date >= ? AND enrollment_date <= ? AND status = \'active\' AND is_transferred = 0',
      variables: [Variable.withDateTime(from), Variable.withDateTime(end)],
    ).getSingle();
    final dropped = await customSelect(
      'SELECT COUNT(*) AS cnt FROM enrollments WHERE enrollment_date >= ? AND enrollment_date <= ? AND (status != \'active\' OR is_transferred = 1)',
      variables: [Variable.withDateTime(from), Variable.withDateTime(end)],
    ).getSingle();
    return {
      'newEnrollments': newEnrollments.read<int>('cnt'),
      'dropped': dropped.read<int>('cnt'),
    };
  }

  Future<List<Map<String, dynamic>>> getClassroomUtilization() async {
    return await customSelect(
      'SELECT c.id, c.name_ar, c.capacity, COUNT(s.id) AS session_count '
      'FROM classrooms c '
      'LEFT JOIN sessions s ON c.id = s.classroom_id AND s.is_active = 1 AND s.is_archived = 0 '
      'WHERE c.is_archived = 0 '
      'GROUP BY c.id',
    ).map((r) => {
      'id': r.read<String>('id'),
      'name': r.read<String>('name_ar'),
      'capacity': r.read<int?>('capacity'),
      'sessionCount': r.read<int>('session_count'),
    }).get();
  }

  Future<List<Map<String, dynamic>>> getClosedPeriods() async {
    return await (select(closedPeriods)
      ..orderBy([(t) => OrderingTerm.desc(t.year), (t) => OrderingTerm.desc(t.month)]))
        .map((r) => {'year': r.year, 'month': r.month, 'closedAt': r.closedAt})
        .get();
  }

  Future<FamilyMember?> getStudentFamily(String studentId) async {
    final member = await (select(familyMembers)
      ..where((t) => t.studentId.equals(studentId))
      ..limit(1))
        .getSingleOrNull();
    if (member == null) return null;
    return member;
  }

  Future<Family?> getFamilyByMember(String studentId) async {
    final member = await getStudentFamily(studentId);
    if (member == null) return null;
    return (select(families)..where((t) => t.id.equals(member.familyId))..limit(1)).getSingleOrNull();
  }

  Future<SpecialCase?> getActiveSpecialCase(String studentId) async {
    return (select(specialCases)
      ..where((t) => t.studentId.equals(studentId) & t.isActive.equals(true))
      ..limit(1)).getSingleOrNull();
  }

  Future<int> countUnbilledActiveStudents() async {
    final result = await customSelect(
      'SELECT COUNT(DISTINCT s.id) AS cnt FROM students s '
      'JOIN enrollments e ON s.id = e.student_id AND e.status = \'active\' AND e.is_transferred = 0 '
      'LEFT JOIN transactions t ON s.id = t.student_id AND t.type = \'session_charge\' '
      'WHERE s.is_archived = 0 AND t.id IS NULL',
    ).getSingle();
    return result.read<int>('cnt');
  }

  Future<List<Map<String, dynamic>>> getStudentSessionSchedule(String studentId) async {
    return await customSelect(
      'SELECT sg.name_ar AS group_name, s.day_of_week, s.start_time, s.end_time '
      'FROM enrollments e '
      'JOIN sessions s ON s.subject_group_id = e.subject_group_id AND s.is_active = 1 AND s.is_archived = 0 '
      'JOIN subject_groups sg ON sg.id = e.subject_group_id '
      'WHERE e.student_id = ? AND e.status = \'active\' AND e.is_transferred = 0 '
      'ORDER BY s.day_of_week, s.start_time',
      variables: [Variable.withString(studentId)],
    ).map((r) => {
      'group_name': r.read<String>('group_name'),
      'day_of_week': r.read<int>('day_of_week'),
      'start_time': r.read<DateTime>('start_time'),
      'end_time': r.read<DateTime>('end_time'),
    }).get();
  }

  Future<int> getTodayTeacherCheckinCount() async {
    final now = DateTime.now();
    final row = await customSelect(
      'SELECT COUNT(*) AS cnt FROM attendance '
      'WHERE person_type = \'teacher\' AND attendance_date >= ? AND attendance_date < ? AND status = \'present\'',
      variables: [Variable.withDateTime(DateTime(now.year, now.month, now.day)), Variable.withDateTime(DateTime(now.year, now.month, now.day + 1))],
    ).getSingle();
    return row.read<int>('cnt');
  }

  Future<List<Map<String, dynamic>>> getTodayRoomGrid() async {
    final now = DateTime.now();
    final today = now.weekday;
    return await customSelect(
      'SELECT '
      'c.id AS classroom_id, c.name_ar AS classroom_name, c.capacity, c.floor, '
      's.id AS session_id, sg.name_ar AS group_name, s.start_time, s.end_time, '
      't.first_name_ar AS teacher_first, t.last_name_ar AS teacher_last, '
      'st.id AS student_id, st.first_name_ar AS stu_first, st.last_name_ar AS stu_last, '
      'st.code, st.photo_path, '
      'a.status AS att_status, a.check_in_time '
      'FROM classrooms c '
      'LEFT JOIN sessions s ON c.id = s.classroom_id '
      '  AND s.day_of_week = ? AND s.is_active = 1 AND s.is_archived = 0 '
      'LEFT JOIN subject_groups sg ON s.subject_group_id = sg.id '
      'LEFT JOIN teachers t ON s.teacher_id = t.id '
      'LEFT JOIN enrollments e ON e.subject_group_id = s.subject_group_id '
      '  AND e.status = \'active\' AND e.is_transferred = 0 '
      'LEFT JOIN students st ON st.id = e.student_id AND st.is_archived = 0 '
      'LEFT JOIN attendance a ON a.student_id = st.id AND a.session_id = s.id '
      '  AND a.attendance_date >= ? AND a.attendance_date < ? AND a.status = \'present\' '
      'WHERE c.is_archived = 0 '
      'ORDER BY c.floor, c.name_ar, s.start_time, st.first_name_ar',
      variables: [
        Variable.withInt(today),
        Variable.withDateTime(DateTime(now.year, now.month, now.day)),
        Variable.withDateTime(DateTime(now.year, now.month, now.day + 1)),
      ],
    ).map((r) => {
      'classroom_id': r.read<String>('classroom_id'),
      'classroom_name': r.read<String>('classroom_name'),
      'capacity': r.read<int?>('capacity'),
      'floor': r.read<int?>('floor'),
      'session_id': r.read<String?>('session_id'),
      'group_name': r.read<String?>('group_name'),
      'start_time': r.read<DateTime?>('start_time'),
      'end_time': r.read<DateTime?>('end_time'),
      'teacher_first': r.read<String?>('teacher_first'),
      'teacher_last': r.read<String?>('teacher_last'),
      'student_id': r.read<String?>('student_id'),
      'stu_first': r.read<String?>('stu_first'),
      'stu_last': r.read<String?>('stu_last'),
      'code': r.read<String?>('code'),
      'photo_path': r.read<String?>('photo_path'),
      'att_status': r.read<String?>('att_status'),
      'check_in_time': r.read<DateTime?>('check_in_time'),
    }).get();
  }

  Future<List<Map<String, dynamic>>> getTodaySessionsWithAttendance() async {
    final now = DateTime.now();
    final today = now.weekday;
    return await customSelect(
      'SELECT s.id, s.subject_group_id, s.teacher_id, s.classroom_id, s.start_time, s.end_time, '
      'sg.name_ar AS group_name, t.first_name_ar, t.last_name_ar, c.name_ar AS classroom_name, '
      '(SELECT COUNT(*) FROM attendance a WHERE a.session_id = s.id AND a.attendance_date >= ? AND a.attendance_date < ? AND a.student_id IS NOT NULL AND a.status = \'present\') AS checked_in, '
      '(SELECT COUNT(*) FROM enrollments e WHERE e.subject_group_id = s.subject_group_id AND e.status = \'active\' AND e.is_transferred = 0) AS total_enrolled '
      'FROM sessions s '
      'JOIN subject_groups sg ON s.subject_group_id = sg.id '
      'LEFT JOIN teachers t ON s.teacher_id = t.id '
      'LEFT JOIN classrooms c ON s.classroom_id = c.id '
      'WHERE s.day_of_week = ? AND s.is_active = 1 AND s.is_archived = 0 '
      'ORDER BY s.start_time',
      variables: [Variable.withDateTime(DateTime(now.year, now.month, now.day)), Variable.withDateTime(DateTime(now.year, now.month, now.day + 1)), Variable.withInt(today)],
    ).map((r) => {
      'id': r.read<String>('id'),
      'subject_group_id': r.read<String>('subject_group_id'),
      'teacher_id': r.read<String>('teacher_id'),
      'classroom_id': r.read<String>('classroom_id'),
      'start_time': r.read<DateTime>('start_time'),
      'end_time': r.read<DateTime>('end_time'),
      'group_name': r.read<String>('group_name'),
      'first_name_ar': r.read<String?>('first_name_ar') ?? '',
      'last_name_ar': r.read<String?>('last_name_ar') ?? '',
      'classroom_name': r.read<String?>('classroom_name') ?? '',
      'checked_in': r.read<int>('checked_in'),
      'total_enrolled': r.read<int>('total_enrolled'),
    }).get();
  }

  Future<List<Map<String, dynamic>>> getSessionRoster(String sessionId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final session = await (select(sessions)..where((t) => t.id.equals(sessionId))).getSingleOrNull();
    if (session == null) return [];
    return await customSelect(
      'SELECT s.id, s.first_name_ar, s.last_name_ar, s.code, s.photo_path, '
      'a.id AS attendance_id, a.status, a.check_in_time, a.minutes_late, a.absence_reason, a.is_backdated '
      'FROM students s '
      'JOIN enrollments e ON s.id = e.student_id '
      'LEFT JOIN attendance a ON a.student_id = s.id AND a.session_id = ? AND a.attendance_date >= ? AND a.attendance_date < ? '
      'WHERE e.subject_group_id = ? AND e.status = \'active\' AND e.is_transferred = 0 AND s.is_archived = 0 '
      'ORDER BY s.first_name_ar',
      variables: [Variable.withString(sessionId), Variable.withDateTime(dateStart), Variable.withDateTime(dateEnd), Variable.withString(session.subjectGroupId)],
    ).map((r) => {
      'id': r.read<String>('id'),
      'first_name_ar': r.read<String>('first_name_ar'),
      'last_name_ar': r.read<String>('last_name_ar'),
      'code': r.read<String>('code'),
      'photo_path': r.read<String?>('photo_path'),
      'attendance_id': r.read<String?>('attendance_id'),
      'status': r.read<String?>('status'),
      'check_in_time': r.read<DateTime?>('check_in_time'),
      'minutes_late': r.read<int?>('minutes_late'),
      'absence_reason': r.read<String?>('absence_reason'),
      'is_backdated': (r.read<bool?>('is_backdated') ?? false),
    }).get();
  }

  Future<Map<String, int>> getLiveAttendanceCounts() async {
    final now = DateTime.now();
    final today = now.weekday;
    final rows = await customSelect(
      'SELECT s.id, '
      '(SELECT COUNT(*) FROM attendance a WHERE a.session_id = s.id AND a.attendance_date >= ? AND a.attendance_date < ? AND a.student_id IS NOT NULL AND a.status = \'present\') AS cnt '
      'FROM sessions s '
      'WHERE s.day_of_week = ? AND s.is_active = 1 AND s.is_archived = 0',
      variables: [Variable.withDateTime(DateTime(now.year, now.month, now.day)), Variable.withDateTime(DateTime(now.year, now.month, now.day + 1)), Variable.withInt(today)],
    ).get();
    final counts = <String, int>{};
    for (final r in rows) {
      counts[r.read<String>('id')] = r.read<int>('cnt');
    }
    return counts;
  }

  Future<List<Map<String, dynamic>>> getRepeatedAbsenceStudents(int daysBack, int minAbsences) async {
    final now = DateTime.now();
    final from = now.subtract(Duration(days: daysBack));
    return await customSelect(
      'SELECT s.id, s.first_name_ar, s.last_name_ar, s.code, COUNT(*) AS absence_count '
      'FROM students s '
      'JOIN enrollments e ON s.id = e.student_id AND e.status = \'active\' AND e.is_transferred = 0 '
      'JOIN sessions sess ON sess.subject_group_id = e.subject_group_id AND sess.day_of_week = ? '
      'LEFT JOIN attendance a ON a.student_id = s.id AND a.session_id = sess.id AND a.attendance_date >= ? AND a.status = \'present\' '
      'WHERE s.is_archived = 0 AND a.id IS NULL AND sess.is_active = 1 AND sess.is_archived = 0 '
      'GROUP BY s.id HAVING COUNT(*) >= ? '
      'ORDER BY absence_count DESC',
      variables: [Variable.withInt(now.weekday), Variable.withDateTime(from), Variable.withInt(minAbsences)],
    ).map((r) => {
      'id': r.read<String>('id'),
      'first_name_ar': r.read<String>('first_name_ar'),
      'last_name_ar': r.read<String>('last_name_ar'),
      'code': r.read<String>('code'),
      'absence_count': r.read<int>('absence_count'),
    }).get();
  }

  Future<double> getMonthlyAttendanceRate(String groupId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    final row = await customSelect(
      'SELECT '
      '(SELECT COUNT(*) FROM attendance a JOIN sessions s2 ON a.session_id = s2.id WHERE s2.subject_group_id = ? AND a.attendance_date >= ? AND a.attendance_date <= ? AND a.status = \'present\') AS present, '
      '(SELECT COUNT(*) FROM sessions s3 WHERE s3.subject_group_id = ? AND s3.is_active = 1 AND s3.is_archived = 0) AS total_sessions, '
      '(SELECT COUNT(*) FROM enrollments e2 WHERE e2.subject_group_id = ? AND e2.status = \'active\' AND e2.is_transferred = 0) AS enrolled '
      'FROM (SELECT 1)',
      variables: [Variable.withString(groupId), Variable.withDateTime(start), Variable.withDateTime(end), Variable.withString(groupId), Variable.withString(groupId)],
    ).getSingle();
    final present = row.read<int>('present');
    final totalSessions = row.read<int>('total_sessions');
    final enrolled = row.read<int>('enrolled');
    final expected = totalSessions * enrolled;
    return expected > 0 ? (present / expected * 100) : 0;
  }

  Future<List<Map<String, dynamic>>> getClassPerformanceReport({DateTime? from, DateTime? to}) async {
    final rows = await customSelect(
      'SELECT sg.id, sg.name_ar AS group_name, sg.school_level, '
      '(SELECT t.first_name_ar || \' \' || t.last_name_ar FROM sessions s JOIN teachers t ON s.teacher_id = t.id WHERE s.subject_group_id = sg.id AND s.is_archived = 0 LIMIT 1) AS teacher_name, '
      '(SELECT COUNT(*) FROM enrollments e WHERE e.subject_group_id = sg.id AND e.status = \'active\' AND e.is_transferred = 0) AS enrolled, '
      'COALESCE((SELECT SUM(tx.amount) FROM transactions tx JOIN sessions s2 ON tx.session_id = s2.id WHERE s2.subject_group_id = sg.id AND tx.type = \'session_charge\'), 0) AS revenue, '
      '(SELECT COUNT(*) FROM attendance a JOIN sessions s3 ON a.session_id = s3.id WHERE s3.subject_group_id = sg.id AND a.status = \'present\') AS present_count, '
      '(SELECT COUNT(*) FROM sessions s4 WHERE s4.subject_group_id = sg.id AND s4.is_active = 1 AND s4.is_archived = 0) AS total_sessions '
      'FROM subject_groups sg WHERE sg.is_archived = 0 ORDER BY sg.name_ar',
    ).get();

    return rows.map((r) {
      final enrolled = r.read<int>('enrolled');
      final totalSessions = r.read<int>('total_sessions');
      final present = r.read<int>('present_count');
      final expected = totalSessions * enrolled;
      final rate = expected > 0 ? (present / expected * 100) : 0.0;
      return {
        'id': r.read<String>('id'),
        'group_name': r.read<String>('group_name'),
        'school_level': r.read<String>('school_level'),
        'teacher_name': r.read<String?>('teacher_name') ?? '',
        'enrolled': enrolled,
        'revenue': r.read<double>('revenue'),
        'attendance_rate': rate,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getTeacherWorkloadReport({DateTime? from, DateTime? to}) async {
    final rows = await customSelect(
      'SELECT t.id, t.first_name_ar, t.last_name_ar, t.code, '
      '(SELECT COUNT(*) FROM sessions s WHERE s.teacher_id = t.id AND s.is_active = 1 AND s.is_archived = 0) AS session_count, '
      'COALESCE((SELECT SUM((julianday(s.end_time) - julianday(s.start_time)) * 24) FROM sessions s WHERE s.teacher_id = t.id AND s.is_active = 1 AND s.is_archived = 0), 0) AS weekly_hours, '
      '(SELECT COUNT(DISTINCT e.student_id) FROM enrollments e JOIN sessions s ON e.subject_group_id = s.subject_group_id WHERE s.teacher_id = t.id AND e.status = \'active\' AND e.is_transferred = 0 AND s.is_archived = 0) AS students_taught, '
      'COALESCE((SELECT SUM(tx.amount) FROM transactions tx WHERE tx.teacher_id = t.id AND tx.type = \'teacher_payout\'), 0) AS earnings '
      'FROM teachers t WHERE t.is_archived = 0 AND t.employment_end_date IS NULL ORDER BY t.first_name_ar',
    ).get();

    return rows.map((r) => {
      'id': r.read<String>('id'),
      'name': '${r.read<String>('first_name_ar')} ${r.read<String>('last_name_ar')}',
      'code': r.read<String>('code'),
      'session_count': r.read<int>('session_count'),
      'weekly_hours': r.read<double>('weekly_hours'),
      'students_taught': r.read<int>('students_taught'),
      'earnings': r.read<double>('earnings'),
    }).toList();
  }
}
