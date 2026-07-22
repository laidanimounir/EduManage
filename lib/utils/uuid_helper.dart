import 'package:uuid/uuid.dart';

class UuidHelper {
  UuidHelper._();

  static const Uuid _uuid = Uuid();

  static String generate() => _uuid.v4();

  static bool isValid(String uuid) {
    try {
      return Uuid.isValidUUID(fromString: uuid);
    } catch (_) {
      return false;
    }
  }
}
