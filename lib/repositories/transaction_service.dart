import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'transaction_repository.dart';
import 'enrollment_repository.dart';
import 'session_repository.dart';
import 'audit_log_repository.dart';
import 'package:drift/drift.dart';

class TransactionService extends BaseRepository {
  final TransactionRepository _txRepo;
  final EnrollmentRepository _enrollmentRepo;
  final SessionRepository _sessionRepo;
  final AuditLogRepository _auditRepo;

  TransactionService(super.db)
      : _txRepo = TransactionRepository(db),
        _enrollmentRepo = EnrollmentRepository(db),
        _sessionRepo = SessionRepository(db),
        _auditRepo = AuditLogRepository(db);

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

    double amount;
    if (session.teacherFixedAmount != null) {
      amount = session.teacherFixedAmount!;
    } else if (session.teacherSharePct != null && session.sessionsPerMonth > 0) {
      final perSessionPrice = session.monthlyPrice / session.sessionsPerMonth;
      amount = perSessionPrice * session.teacherSharePct! / 100;
    } else {
      amount = 0;
    }

    final id = await _txRepo.insert(TransactionsCompanion(
      teacherId: Value(teacherId),
      sessionId: Value(sessionId),
      type: const Value('teacher_payout'),
      amount: Value(amount),
      transactionDate: Value(txDate),
      note: Value(note),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('teacher_payout_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Teacher: $teacherId, Session: $sessionId, Amount: $amount'),
    ));

    return id;
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
}
