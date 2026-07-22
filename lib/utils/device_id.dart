import 'package:shared_preferences/shared_preferences.dart';
import 'uuid_helper.dart';

class DeviceId {
  DeviceId._();

  static const _key = 'device_id';

  static String? _cached;

  static Future<String> get() async {
    if (_cached != null) return _cached!;

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);

    if (existing != null && existing.isNotEmpty) {
      _cached = existing;
      return existing;
    }

    final newId = UuidHelper.generate();
    await prefs.setString(_key, newId);
    _cached = newId;
    return newId;
  }
}
