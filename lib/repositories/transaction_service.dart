import '../database/app_database.dart';
import 'base_repository.dart';
import 'transaction_repository.dart';
import 'enrollment_repository.dart';
import 'session_repository.dart';
import 'teacher_repository.dart';
import 'audit_log_repository.dart';
import 'attendance_repository.dart';
import 'package:drift/drift.dart';

class TransactionService extends BaseRepository {
  final TransactionRepository _txRepo;
  final EnrollmentRepository _enrollmentRepo;
  final SessionRepository _sessionRepo;
  final AuditLogRepository _auditRepo;
  final AttendanceRepository _attendanceRepo;

  TransactionService(super.db)
      : _txRepo = TransactionRepository(db),
        _enrollmentRepo = EnrollmentRepository(db),
        _sessionRepo = SessionRepository(db),
        _auditRepo = AuditLogRepository(db),
        _attendanceRepo = AttendanceRepository(db);

  Future<String> createSessionCharge({
    required String studentId,
    required String sessionId,
    required String enrollmentId,
    DateTime? date,
    String? note,
    String? createdByUserId,
  }) async {
    final txDate = date ?? DateTime.now();

    final cancelled = await _isSessionCancelled(sessionId, txDate);
    if (cancelled) {
      throw StateError('Session is cancelled on this date');
    }

    final duplicate = await _isDuplicateCharge(studentId, sessionId, txDate);
    if (duplicate) {
      throw StateError('Student already charged for this session on this date');
    }

    final session = await _sessionRepo.getById(sessionId);
    final enrollment = await _enrollmentRepo.getById(enrollmentId);

    double amount;
    if (enrollment != null && enrollment.customPriceOverride != null) {
      amount = enrollment.customPriceOverride!;
    } else if (session != null && session.sessionsPerMonth > 0) {
      amount = session.monthlyPrice / session.sessionsPerMonth;
    } else {
      amount = 0;
    }

    if (enrollment != null && enrollment.customDiscount != null) {
      amount -= enrollment.customDiscount!;
    }

    if (amount < 0) amount = 0;

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      sessionId: Value(sessionId),
      type: const Value('session_charge'),
      amount: Value(amount),
      transactionDate: Value(txDate),
      note: Value(note),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('session_charge_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Session: $sessionId, Amount: $amount'),
    ));

    return id;
  }

  Future<String> createStudentPayment({
    required String studentId,
    required double amount,
    String? enrollmentId,
    String? note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      type: const Value('student_payment'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('student_payment_received'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Amount: $amount'),
    ));

    return id;
  }

  Future<String> createTeacherPayout({
    required String teacherId,
    required String sessionId,
    DateTime? date,
    String? note,
    String? createdByUserId,
  }) async {
    final txDate = date ?? DateTime.now();
    final session = await _sessionRepo.getById(sessionId);
    if (session == null) throw ArgumentError('Session not found');

    final attendanceCount = await _getSessionAttendanceCount(sessionId, txDate);

    final teacher = await TeacherRepository(db).getById(teacherId);

    double amount;
    String rateSnapshotStr;
    final effectiveFixed = session.teacherFixedAmount ?? teacher?.teacherFixedAmount;
    final effectiveSharePct = session.teacherSharePct ?? teacher?.teacherSharePct;
    final effectiveSalaryType = (session.teacherFixedAmount != null || session.teacherSharePct != null)
        ? (session.teacherFixedAmount != null ? 'fixed' : 'percentage')
        : teacher?.salaryType ?? 'percentage';

    if (effectiveFixed != null && effectiveSalaryType == 'fixed') {
      amount = effectiveFixed;
      rateSnapshotStr = 'fixed:${effectiveFixed.toStringAsFixed(0)}';
    } else if (effectiveSharePct != null && session.sessionsPerMonth > 0) {
      final perSessionPrice = session.monthlyPrice / session.sessionsPerMonth;
      final perStudentAmount = perSessionPrice * effectiveSharePct / 100;
      amount = perStudentAmount * attendanceCount;
      rateSnapshotStr = 'pct:${effectiveSharePct.toStringAsFixed(1)},base:${session.monthlyPrice.toStringAsFixed(0)},sessions:${session.sessionsPerMonth},students:${attendanceCount}';
    } else {
      amount = 0;
      rateSnapshotStr = 'none';
    }

    final fullNote = note != null
        ? '$rateSnapshotStr | $note'
        : rateSnapshotStr;

    final id = await _txRepo.insert(TransactionsCompanion(
      teacherId: Value(teacherId),
      sessionId: Value(sessionId),
      type: const Value('teacher_payout'),
      amount: Value(amount),
      transactionDate: Value(txDate),
      note: Value(fullNote),
      rateSnapshot: Value(rateSnapshotStr),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('teacher_payout_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Teacher: $teacherId, Session: $sessionId, Amount: $amount, Rate: $rateSnapshotStr'),
    ));

    return id;
  }

  Future<int> _getSessionAttendanceCount(String sessionId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final records = await (db.select(db.attendance)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.attendanceDate.isBiggerOrEqualValue(dateStart) &
          t.attendanceDate.isSmallerThanValue(dateEnd) &
          t.studentId.isNotNull()))
        .get();
    return records.length;
  }

  Future<String> createExpense({
    required double amount,
    required String category,
    String? teacherId,
    String? note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    final id = await _txRepo.insert(TransactionsCompanion(
      teacherId: Value(teacherId),
      type: const Value('expense'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value('[$category] ${note ?? ''}'),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('expense_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Category: $category, Amount: $amount'),
    ));

    return id;
  }

  Future<String> createDiscount({
    required String studentId,
    required double amount,
    String? enrollmentId,
    String? note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      type: const Value('discount'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('discount_applied'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Amount: $amount'),
    ));

    return id;
  }

  Future<String> createCorrection({
    required String referenceTransactionId,
    required double amount,
    String? studentId,
    String? teacherId,
    String? note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');

    final original = await _txRepo.getById(referenceTransactionId);
    if (original == null) throw ArgumentError('Original transaction not found');

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId ?? original.studentId),
      teacherId: Value(teacherId ?? original.teacherId),
      enrollmentId: Value(original.enrollmentId),
      sessionId: Value(original.sessionId),
      type: const Value('correction'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note),
      referenceTransactionId: Value(referenceTransactionId),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('correction_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Ref: $referenceTransactionId, Amount: $amount, Note: $note'),
    ));

    return id;
  }

  Future<String> createReversal({
    required String referenceTransactionId,
    String? note,
    String? createdByUserId,
  }) async {
    final original = await _txRepo.getById(referenceTransactionId);
    if (original == null) throw ArgumentError('Original transaction not found');

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(original.studentId),
      teacherId: Value(original.teacherId),
      enrollmentId: Value(original.enrollmentId),
      sessionId: Value(original.sessionId),
      type: const Value('reversal'),
      amount: Value(original.amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note ?? 'Reversal of $referenceTransactionId'),
      referenceTransactionId: Value(referenceTransactionId),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('reversal_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Reversed: $referenceTransactionId'),
    ));

    return id;
  }

  Future<bool> _isSessionCancelled(String sessionId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));

    final closedResult = await (db.select(db.schoolClosures)
      ..where((t) =>
          t.closureDate.isBiggerOrEqualValue(dateStart) &
          t.closureDate.isSmallerThanValue(dateEnd)))
        .get();
    if (closedResult.isNotEmpty) return true;

    final result = await (db.select(db.cancellations)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.cancelDate.isBiggerOrEqualValue(dateStart) &
          t.cancelDate.isSmallerThanValue(dateEnd)))
        .get();
    return result.isNotEmpty;
  }

  Future<bool> _isDuplicateCharge(
      String studentId, String sessionId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final result = await (db.select(db.transactions)
      ..where((t) =>
          t.studentId.equals(studentId) &
          t.sessionId.equals(sessionId) &
          t.type.equals('session_charge') &
          t.transactionDate.isBiggerOrEqualValue(dateStart) &
          t.transactionDate.isSmallerThanValue(dateEnd)))
        .get();
    return result.isNotEmpty;
  }

  Future<List<String>> reverseCancelledSessionCharges({
    required String sessionId,
    required DateTime date,
    String? createdByUserId,
  }) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final reversedIds = <String>[];

    final studentCharges = await (db.select(db.transactions)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.type.equals('session_charge') &
          t.transactionDate.isBiggerOrEqualValue(dateStart) &
          t.transactionDate.isSmallerThanValue(dateEnd)))
        .get();

    for (final charge in studentCharges) {
      final id = await _txRepo.insert(TransactionsCompanion(
        studentId: Value(charge.studentId),
        sessionId: Value(sessionId),
        type: const Value('session_cancellation_reversal'),
        amount: Value(charge.amount),
        transactionDate: Value(date),
        note: Value('Refunded — session cancelled on ${dateStart.toIso8601String().substring(0, 10)}'),
        referenceTransactionId: Value(charge.id),
        createdByUserId: Value(createdByUserId),
      ));
      reversedIds.add(id);
      await _auditRepo.create(AuditLogCompanion(
        userId: Value(createdByUserId ?? 'system'),
        action: const Value('session_cancellation_reversal_created'),
        entityType: const Value('transaction'),
        entityId: Value(id),
        details: Value('Student: ${charge.studentId}, Session: $sessionId, Amount: ${charge.amount}, Ref: ${charge.id}'),
      ));
    }

    final teacherPayouts = await (db.select(db.transactions)
      ..where((t) =>
          t.sessionId.equals(sessionId) &
          t.type.equals('teacher_payout') &
          t.transactionDate.isBiggerOrEqualValue(dateStart) &
          t.transactionDate.isSmallerThanValue(dateEnd)))
        .get();

    for (final payout in teacherPayouts) {
      final id = await _txRepo.insert(TransactionsCompanion(
        teacherId: Value(payout.teacherId),
        sessionId: Value(sessionId),
        type: const Value('session_cancellation_reversal'),
        amount: Value(payout.amount),
        transactionDate: Value(date),
        note: Value('Deducted — session cancelled on ${dateStart.toIso8601String().substring(0, 10)}'),
        referenceTransactionId: Value(payout.id),
        createdByUserId: Value(createdByUserId),
      ));
      reversedIds.add(id);
      await _auditRepo.create(AuditLogCompanion(
        userId: Value(createdByUserId ?? 'system'),
        action: const Value('session_cancellation_reversal_created'),
        entityType: const Value('transaction'),
        entityId: Value(id),
        details: Value('Teacher: ${payout.teacherId}, Session: $sessionId, Amount: ${payout.amount}, Ref: ${payout.id}'),
      ));
    }

    return reversedIds;
  }

  Future<String> createRegistrationFee({
    required String studentId,
    required double amount,
  }) async {
    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      type: const Value('registration_fee'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
    ));
    return id;
  }

  Future<String> createRegistrationFeePayment({
    required String studentId,
    required double amount,
  }) async {
    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      type: const Value('registration_fee_payment'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
    ));
    return id;
  }

  Future<int> getRegistrationFeeCount(String studentId) async {
    final result = await (db.select(db.transactions)
      ..where((t) => t.studentId.equals(studentId) & t.type.equals('registration_fee')))
        .get();
    return result.length;
  }
}
