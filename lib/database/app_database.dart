import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
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

@DriftDatabase(
  tables: [Students, Teachers, Classrooms, SubjectGroups, Sessions, Enrollments, EnrollmentWaitlist, Cancellations, Transactions, Attendance, Users, AuditLog, StudentCards, Settings, TeacherSubjectGroups, SchoolClosures, SchoolLevels],
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
  int get schemaVersion => 7;

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
      'WHEN type IN (\'reversal\') THEN -amount '
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
}
