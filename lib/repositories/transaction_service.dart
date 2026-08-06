import '../database/app_database.dart';
import 'base_repository.dart';
import 'transaction_repository.dart';
import 'enrollment_repository.dart';
import 'session_repository.dart';
import 'teacher_repository.dart';
import 'audit_log_repository.dart';
import 'attendance_repository.dart';
import '../utils/uuid_helper.dart';
import '../utils/device_id.dart';
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

  Future<int> _countSessionCharges(String enrollmentId) async {
    final result = await (db.select(db.transactions)
      ..where((t) =>
          t.enrollmentId.equals(enrollmentId) &
          t.type.equals('session_charge')))
        .get();
    return result.length;
  }

  Future<String> createSessionCharge({
    required String studentId,
    required String sessionId,
    required String enrollmentId,
    DateTime? date,
    String? note,
    String? createdByUserId,
  }) async {
    final txDate = date ?? DateTime.now();

    await _checkPeriodOpen(txDate);

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

    double familyDiscountAmount = 0;
    String? familyDiscountNote;
    final family = await db.getFamilyByMember(studentId);
    if (family != null) {
      if (family.discountPercent != null) {
        familyDiscountAmount = amount * family.discountPercent! / 100;
        familyDiscountNote = 'Family discount (${family.name}) — ${family.discountPercent!.toStringAsFixed(0)}%';
      } else if (family.discountFixed != null) {
        familyDiscountAmount = family.discountFixed!;
        familyDiscountNote = 'Family discount (${family.name}) — ${family.discountFixed!.toStringAsFixed(0)} DA';
      }
    }

    double specialCaseDiscountAmount = 0;
    String? specialCaseDiscountNote;
    final specialCase = await db.getActiveSpecialCase(studentId);
    if (specialCase != null) {
      if (specialCase.caseType == 'full') {
        specialCaseDiscountAmount = amount;
        specialCaseDiscountNote = 'Special case exemption (${specialCase.reason}) — 100%';
      } else if (specialCase.discountPercent != null) {
        specialCaseDiscountAmount = amount * specialCase.discountPercent! / 100;
        specialCaseDiscountNote = 'Special case exemption (${specialCase.reason}) — ${specialCase.discountPercent!.toStringAsFixed(0)}%';
      } else if (specialCase.discountFixed != null) {
        specialCaseDiscountAmount = specialCase.discountFixed!;
        specialCaseDiscountNote = 'Special case exemption (${specialCase.reason}) — ${specialCase.discountFixed!.toStringAsFixed(0)} DA';
      }
    }

    if (amount < 0) amount = 0;

    final currentBalance = await db.getStudentBalance(studentId);
    if (currentBalance < 0 && amount > 0) {
      final creditToApply = (-currentBalance).clamp(0, amount);
      amount -= creditToApply;
      if (amount < 0) amount = 0;
    }

    // Cap the discounts so combined family + special case exemptions never
    // exceed the charge that survives credit application. Without this a
    // discount computed on the pre-credit amount could exceed the final charge
    // and mint a fabricated credit balance.
    if (familyDiscountAmount > amount) familyDiscountAmount = amount;
    final specialCaseBudget = amount - familyDiscountAmount;
    if (specialCaseDiscountAmount > specialCaseBudget) specialCaseDiscountAmount = specialCaseBudget;

    final priceSnapshotStr = 'price:${amount.toStringAsFixed(0)},monthly:${session?.monthlyPrice.toStringAsFixed(0) ?? '0'},perMonth:${session?.sessionsPerMonth ?? 0}';

    final priorCount = await _countSessionCharges(enrollmentId);
    final sessionsPerMonth = session?.sessionsPerMonth ?? 1;
    final cycleNumber = (priorCount / sessionsPerMonth).floor() + 1;

    // TODO: School closures vs single-session cancellations need clearer distinction
    // for cycle counting. Currently, a cancelled session still consumes a cycle slot.
    // A school closure day should probably NOT count against the student's cycle
    // (or a make-up session should be auto-scheduled). This is intentionally deferred
    // until a decision is made on the correct business rule.

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      sessionId: Value(sessionId),
      type: const Value('session_charge'),
      amount: Value(amount),
      transactionDate: Value(txDate),
      note: Value(note),
      priceSnapshot: Value(priceSnapshotStr),
      cycleNumber: Value(cycleNumber),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('session_charge_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Session: $sessionId, Amount: $amount'),
    ));

    if (familyDiscountAmount > 0 && familyDiscountNote != null) {
      final discountId = await _txRepo.insert(TransactionsCompanion(
        studentId: Value(studentId),
        enrollmentId: Value(enrollmentId),
        sessionId: Value(sessionId),
        type: const Value('discount'),
        amount: Value(familyDiscountAmount),
        transactionDate: Value(txDate),
        note: Value(familyDiscountNote),
        referenceTransactionId: Value(id),
        createdByUserId: Value(createdByUserId),
      ));
      await _auditRepo.create(AuditLogCompanion(
        userId: Value(createdByUserId ?? 'system'),
        action: const Value('family_discount_applied'),
        entityType: const Value('transaction'),
        entityId: Value(discountId),
        details: Value('Student: $studentId, Charge: $id, Discount: $familyDiscountAmount, Family: ${familyDiscountNote}'),
      ));
    }

    if (specialCaseDiscountAmount > 0 && specialCaseDiscountNote != null) {
      final discountId = await _txRepo.insert(TransactionsCompanion(
        studentId: Value(studentId),
        enrollmentId: Value(enrollmentId),
        sessionId: Value(sessionId),
        type: const Value('discount'),
        amount: Value(specialCaseDiscountAmount),
        transactionDate: Value(txDate),
        note: Value(specialCaseDiscountNote),
        referenceTransactionId: Value(id),
        createdByUserId: Value(createdByUserId),
      ));
      await _auditRepo.create(AuditLogCompanion(
        userId: Value(createdByUserId ?? 'system'),
        action: const Value('special_case_discount_applied'),
        entityType: const Value('transaction'),
        entityId: Value(discountId),
        details: Value('Student: $studentId, Charge: $id, Discount: $specialCaseDiscountAmount, Case: $specialCaseDiscountNote'),
      ));
    }

    return id;
  }

  Future<String> createStudentPayment({
    required String studentId,
    required double amount,
    String? enrollmentId,
    String? note,
    String? createdByUserId,
    String? paymentMethod,
    Map<String, double>? allocations,
    List<String>? chargeTypes,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    await _checkPeriodOpen(DateTime.now());

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      enrollmentId: Value(enrollmentId),
      type: const Value('student_payment'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note),
      paymentMethod: Value(paymentMethod ?? 'cash'),
      createdByUserId: Value(createdByUserId),
    ));

    Map<String, double> resolvedAllocations;
    if (allocations != null && allocations.isNotEmpty) {
      resolvedAllocations = allocations;
    } else {
      resolvedAllocations = await _fifoAllocate(studentId, amount, chargeTypes: chargeTypes);
    }

    for (final entry in resolvedAllocations.entries) {
      await db.into(db.paymentAllocations).insert(PaymentAllocationsCompanion(
        id: Value(UuidHelper.generate()),
        paymentTransactionId: Value(id),
        chargeTransactionId: Value(entry.key),
        amount: Value(entry.value),
        deviceId: Value(await DeviceId.get()),
      ));
    }

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('student_payment_received'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Amount: $amount, Method: ${paymentMethod ?? 'cash'}'),
    ));

    return id;
  }

  Future<Map<String, double>> _fifoAllocate(String studentId, double paymentAmount, {List<String>? chargeTypes}) async {
    final types = chargeTypes ?? ['session_charge', 'registration_fee', 'correction'];
    final charges = await (db.select(db.transactions)
      ..where((t) =>
          t.studentId.equals(studentId) &
          t.type.isIn(types))
      ..orderBy([(t) => OrderingTerm.asc(t.transactionDate)]))
        .get();

    final allocations = <String, double>{};
    double remaining = paymentAmount;

    for (final charge in charges) {
      if (remaining <= 0) break;
      final alreadyAllocated = await _getAllocatedAmount(charge.id);
      final unpaid = charge.amount - alreadyAllocated;
      if (unpaid <= 0) continue;

      final alloc = remaining >= unpaid ? unpaid : remaining;
      allocations[charge.id] = alloc;
      remaining -= alloc;
    }

    return allocations;
  }

  Future<double> _getAllocatedAmount(String chargeTransactionId) async {
    final result = await (db.select(db.paymentAllocations)
      ..where((t) => t.chargeTransactionId.equals(chargeTransactionId)))
        .get();
    return result.fold<double>(0, (sum, a) => sum + a.amount);
  }

  Future<List<Map<String, dynamic>>> getUnpaidCharges(String studentId) async {
    final charges = await (db.select(db.transactions)
      ..where((t) =>
          t.studentId.equals(studentId) &
          t.type.isIn(['session_charge', 'registration_fee', 'correction']))
      ..orderBy([(t) => OrderingTerm.asc(t.transactionDate)]))
        .get();

    final result = <Map<String, dynamic>>[];
    for (final charge in charges) {
      final allocated = await _getAllocatedAmount(charge.id);
      final remaining = charge.amount - allocated;
      if (remaining > 0) {
        result.add({
          'transaction': charge,
          'remaining': remaining,
          'total': charge.amount,
          'paid': allocated,
          'cycle': charge.cycleNumber,
        });
      }
    }
    return result;
  }

  Future<String> createTeacherPayout({
    required String teacherId,
    required String sessionId,
    DateTime? date,
    String? note,
    String? createdByUserId,
    String? paymentMethod,
  }) async {
    final txDate = date ?? DateTime.now();
    final session = await _sessionRepo.getById(sessionId);
    if (session == null) throw ArgumentError('Session not found');

    await _checkPeriodOpen(txDate);

    final cancelled = await _isSessionCancelled(sessionId, txDate);
    if (cancelled) {
      throw StateError('Cannot pay out for a cancelled session');
    }

    final duplicate = await _isDuplicatePayout(teacherId, sessionId, txDate);
    if (duplicate) {
      throw StateError('Payout already recorded for this session on this date');
    }

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
      paymentMethod: Value(paymentMethod),
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

  Future<String> createTeacherPayoutOverride({
    required String teacherId,
    required String sessionId,
    required double amount,
    required String rateSnapshotStr,
    required DateTime date,
    String? note,
    String? createdByUserId,
    String? paymentMethod,
  }) async {
    await _checkPeriodOpen(date);

    final cancelled = await _isSessionCancelled(sessionId, date);
    if (cancelled) {
      throw StateError('Cannot pay out for a cancelled session');
    }

    final duplicate = await _isDuplicatePayout(teacherId, sessionId, date);
    if (duplicate) {
      throw StateError('Payout already recorded for this session on this date');
    }

    final fullNote = note != null ? '$rateSnapshotStr | $note' : rateSnapshotStr;

    final id = await _txRepo.insert(TransactionsCompanion(
      teacherId: Value(teacherId),
      sessionId: Value(sessionId),
      type: const Value('teacher_payout'),
      amount: Value(amount),
      transactionDate: Value(date),
      note: Value(fullNote),
      rateSnapshot: Value(rateSnapshotStr),
      createdByUserId: Value(createdByUserId),
      paymentMethod: Value(paymentMethod),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('teacher_payout_created'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Teacher: $teacherId, Session: $sessionId, Amount: $amount, Rate: $rateSnapshotStr (partial/manual)'),
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
    await _checkPeriodOpen(DateTime.now());

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
    required String note,
    String? studentId,
    String? teacherId,
    String? createdByUserId,
  }) async {
    if (note.trim().isEmpty) throw ArgumentError('Correction reason is mandatory');
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
    required String note,
    String? createdByUserId,
  }) async {
    if (note.trim().isEmpty) throw ArgumentError('Reversal reason is mandatory');
    final original = await _txRepo.getById(referenceTransactionId);
    if (original == null) throw ArgumentError('Original transaction not found');
    final existing = await (db.select(db.transactions)
      ..where((t) =>
          t.referenceTransactionId.equals(referenceTransactionId) &
          t.type.equals('reversal')))
        .getSingleOrNull();
    if (existing != null) throw StateError('Transaction already reversed');

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(original.studentId),
      teacherId: Value(original.teacherId),
      enrollmentId: Value(original.enrollmentId),
      sessionId: Value(original.sessionId),
      type: const Value('reversal'),
      amount: Value(original.amount),
      transactionDate: Value(DateTime.now()),
      note: Value(note),
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

  Future<bool> _isDuplicatePayout(
      String teacherId, String sessionId, DateTime date) async {
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));
    final result = await (db.select(db.transactions)
      ..where((t) =>
          t.teacherId.equals(teacherId) &
          t.sessionId.equals(sessionId) &
          t.type.equals('teacher_payout') &
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

  Future<String> createRefund({
    required String studentId,
    required double amount,
    required String note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    await _checkPeriodOpen(DateTime.now());

    final id = await _txRepo.insert(TransactionsCompanion(
      studentId: Value(studentId),
      type: const Value('correction'),
      amount: Value(amount),
      transactionDate: Value(DateTime.now()),
      note: Value('Cash Refund: $note'),
      createdByUserId: Value(createdByUserId),
    ));

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('refund_issued'),
      entityType: const Value('transaction'),
      entityId: Value(id),
      details: Value('Student: $studentId, Amount: $amount, Note: $note'),
    ));

    return id;
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

  Future<void> createBalanceTransfer({
    required String fromStudentId,
    required String toStudentId,
    required double amount,
    required String note,
    String? createdByUserId,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    await _checkPeriodOpen(DateTime.now());
    await createStudentPayment(
      studentId: toStudentId, amount: amount,
      note: 'Transfer from $fromStudentId: $note',
      paymentMethod: 'transfer', createdByUserId: createdByUserId,
    );
    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('balance_transfer'),
      entityType: const Value('transaction'),
      entityId: Value(toStudentId),
      details: Value('From: $fromStudentId, To: $toStudentId, Amount: $amount, Note: $note'),
    ));
  }

  Future<void> _checkPeriodOpen(DateTime date) async {
    final closed = await db.isPeriodClosed(date.year, date.month);
    if (closed) {
      throw StateError('Cannot modify transactions in a closed period (${date.year}-${date.month.toString().padLeft(2, '0')})');
    }
  }

  Future<void> undoCheckin({
    required String attendanceId,
    required String studentId,
    required String sessionId,
    required DateTime attendanceDate,
    String? createdByUserId,
  }) async {
    await _checkPeriodOpen(attendanceDate);

    final attendance = await (db.select(db.attendance)
      ..where((t) => t.id.equals(attendanceId))).getSingleOrNull();
    if (attendance == null) throw StateError('Attendance record not found');

    final charges = await (db.select(db.transactions)
      ..where((t) =>
          t.studentId.equals(studentId) &
          t.sessionId.equals(sessionId) &
          t.type.equals('session_charge') &
          t.transactionDate.isBiggerOrEqualValue(DateTime(attendanceDate.year, attendanceDate.month, attendanceDate.day)) &
          t.transactionDate.isSmallerThanValue(DateTime(attendanceDate.year, attendanceDate.month, attendanceDate.day + 1))))
        .get();

    for (final charge in charges) {
      await createReversal(
        referenceTransactionId: charge.id,
        note: 'Undo check-in correction',
        createdByUserId: createdByUserId,
      );
    }

    await (db.delete(db.attendance)
      ..where((t) => t.id.equals(attendanceId))).go();

    await _auditRepo.create(AuditLogCompanion(
      userId: Value(createdByUserId ?? 'system'),
      action: const Value('checkin_undone'),
      entityType: const Value('attendance'),
      entityId: Value(attendanceId),
      details: Value('Student: $studentId, Session: $sessionId, Date: $attendanceDate'),
    ));
  }
}
