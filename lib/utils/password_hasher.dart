import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  PasswordHasher._();

  static String hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static bool verify(String password, String hash) {
    return hash == hashPassword(password);
  }

  static String hashPassword(String password) => hash(password);
}
