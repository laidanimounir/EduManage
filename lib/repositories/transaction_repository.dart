import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class TransactionRepository extends BaseRepository {
  TransactionRepository(super.db);

  Future<String> insert(TransactionsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.transactions).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<List<Transaction>> getByStudent(String studentId) {
    return (db.select(db.transactions)
      ..where((t) => t.studentId.equals(studentId))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Transaction>> getByTeacher(String teacherId) {
    return (db.select(db.transactions)
      ..where((t) => t.teacherId.equals(teacherId))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Transaction>> getByEnrollment(String enrollmentId) {
    return (db.select(db.transactions)
      ..where((t) => t.enrollmentId.equals(enrollmentId))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Transaction>> getByDateRange(
      DateTime start, DateTime end) {
    return (db.select(db.transactions)
      ..where((t) =>
          t.transactionDate.isBiggerOrEqualValue(start) &
          t.transactionDate.isSmallerOrEqualValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Transaction>> getByType(String type) {
    return (db.select(db.transactions)
      ..where((t) => t.type.equals(type))
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<List<Transaction>> getAll() {
    return (db.select(db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<Transaction?> getById(String id) {
    return (db.select(db.transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }
}
