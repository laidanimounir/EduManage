import '../repositories/user_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/classroom_repository.dart';
import '../utils/uuid_helper.dart';
import '../utils/device_id.dart';
import 'app_database.dart';
import 'database_provider.dart';

class DatabaseInitializer {
  static Future<void> initialize(DatabaseProvider provider) async {
    await provider.initialize();
    final db = provider.database;
    final deviceId = await DeviceId.get();

    final userRepo = UserRepository(db);
    final existingUsers = await userRepo.getAll();

    if (existingUsers.isEmpty) {
      final adminId = UuidHelper.generate();
      await db.into(db.users).insert(UsersCompanion(
        id: Value(adminId),
        username: const Value('admin'),
        passwordHash: Value(UserRepository.hashPassword('admin')),
        role: const Value('admin'),
        firstName: const Value('Admin'),
        lastName: const Value('Admin'),
        isActive: const Value(true),
        deviceId: Value(deviceId),
      ));
    }

    final classroomRepo = ClassroomRepository(db);
    final existingRooms = await classroomRepo.getAll();

    if (existingRooms.isEmpty) {
      final rooms = [
        ('قاعة 1', 'Salle 1', null, null),
        ('قاعة 2', 'Salle 2', null, null),
        ('قاعة 3', 'Salle 3', null, null),
      ];

      for (final room in rooms) {
        await classroomRepo.create(ClassroomsCompanion(
          nameAr: Value(room.$1),
          nameFr: Value(room.$2),
          floor: Value(room.$3),
          capacity: Value(room.$4),
        ));
      }
    }

    final settingsRepo = SettingsRepository(db);
    final lang = await settingsRepo.get('language');
    if (lang == null) {
      await settingsRepo.set('language', 'ar');
    }
    final timeout = await settingsRepo.get('session_timeout');
    if (timeout == null) {
      await settingsRepo.set('session_timeout', '30');
    }
  }
}
