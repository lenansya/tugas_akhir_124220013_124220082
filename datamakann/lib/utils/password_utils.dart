import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordUtils {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password); // Konversi ke byte array
    final hash = sha256.convert(bytes); // Hash menggunakan SHA-256
    return hash.toString(); // Ubah ke string
  }

  static bool verifyPassword(String inputPassword, String storedHash) {
    final inputHash = hashPassword(inputPassword);
    return inputHash == storedHash;
  }
}
