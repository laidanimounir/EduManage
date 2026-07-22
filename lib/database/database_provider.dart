import 'package:flutter/foundation.dart';
import '../utils/device_id.dart';
import 'app_database.dart';

class DatabaseProvider extends ChangeNotifier {
  AppDatabase? _database;
  String? _deviceId;
  bool _initialized = false;

  AppDatabase get database {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  String get deviceId {
    if (_deviceId == null) {
      throw StateError('Device ID not initialized.');
    }
    return _deviceId!;
  }

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    _deviceId = await DeviceId.get();
    _database = await AppDatabase.getInstance();
    _initialized = true;
    notifyListeners();
  }
}
