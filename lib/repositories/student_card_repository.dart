import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';
import 'package:drift/drift.dart';

class StudentCardRepository extends BaseRepository {
  StudentCardRepository(super.db);

  Future<StudentCard?> getByStudent(String studentId) {
    return (db.select(db.studentCards)
      ..where((t) => t.studentId.equals(studentId) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<StudentCard?> getByToken(String token) {
    return (db.select(db.studentCards)
      ..where((t) => t.secureToken.equals(token) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<StudentCard?> getActiveCard(String studentId) {
    return (db.select(db.studentCards)
      ..where((t) => t.studentId.equals(studentId) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<String> create(StudentCardsCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.studentCards).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<void> revoke(String cardId) async {
    final deviceId = await DeviceId.get();
    final now = DateTime.now();
    await (db.update(db.studentCards)..where((t) => t.id.equals(cardId)))
        .write(StudentCardsCompanion(
      isActive: const Value(false),
      revokedDate: Value(now),
      deviceId: Value(deviceId),
    ));
  }

  Future<List<StudentCard>> getAllByStudent(String studentId) {
    return (db.select(db.studentCards)
      ..where((t) => t.studentId.equals(studentId))
      ..orderBy([(t) => OrderingTerm.desc(t.issuedDate)]))
        .get();
  }
}
