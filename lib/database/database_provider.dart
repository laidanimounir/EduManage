import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/uuid_helper.dart';
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

    _deviceId = await _loadOrGenerateDeviceId();
    _database = await AppDatabase.getInstance();
    _initialized = true;
    notifyListeners();
  }

  Future<String> _loadOrGenerateDeviceId() async {
    const key = 'device_id';
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(key);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final newId = UuidHelper.generate();
    await prefs.setString(key, newId);
    return newId;
  }
}
