import '../database/app_database.dart';
import '../utils/device_id.dart';
import '../utils/uuid_helper.dart';
import 'base_repository.dart';

class AuditLogRepository extends BaseRepository {
  AuditLogRepository(super.db);

  Future<String> create(AuditLogCompanion entry) async {
    final id = UuidHelper.generate();
    final deviceId = await DeviceId.get();
    await db.into(db.auditLog).insert(
          entry.copyWith(id: Value(id), deviceId: Value(deviceId)),
        );
    return id;
  }

  Future<List<AuditLogEntry>> getAll() {
    return (db.select(db.auditLog)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<AuditLogEntry>> getByUser(String userId) {
    return (db.select(db.auditLog)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<AuditLogEntry>> getByEntity(String entityType, String entityId) {
    return (db.select(db.auditLog)
      ..where((t) =>
          t.entityType.equals(entityType) & t.entityId.equals(entityId))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<AuditLogEntry>> getByDateRange(
      DateTime start, DateTime end) {
    return (db.select(db.auditLog)
      ..where((t) =>
          t.timestamp.isBiggerOrEqualValue(start) &
          t.timestamp.isSmallerOrEqualValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<AuditLogEntry>> getRecentActions({int limit = 50}) {
    return (db.select(db.auditLog)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(limit))
        .get();
  }
}
