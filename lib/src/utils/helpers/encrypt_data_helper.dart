import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptDataHelper {
  static String encryptAES(String? plainText) {
    if (plainText == null) {
      return '';
    } else {
      final keyPlain = dotenv.maybeGet('ENCRYPTED_KEY', fallback: null) ?? "";
      final ivPlain = dotenv.maybeGet('ENCRYPTED_IV', fallback: null) ?? "";
      final key = Key.fromUtf8(keyPlain);
      final iv = IV.fromUtf8(ivPlain);
      final encryptType = Encrypter(AES(key, mode: AESMode.cbc));
      Encrypted encrypted = encryptType.encrypt(plainText, iv: iv);
      return encrypted.base64;
    }
  }

  static String decryptAES(String? data) {
    if (data!.isEmpty) {
      return '';
    } else {
      final keyPlain = dotenv.maybeGet('ENCRYPTED_KEY', fallback: null) ?? "";
      final ivPlain = dotenv.maybeGet('ENCRYPTED_IV', fallback: null) ?? "";
      final key = Key.fromUtf8(keyPlain);
      final iv = IV.fromUtf8(ivPlain);

      final encryptType = Encrypter(AES(key, mode: AESMode.cbc));
      return encryptType.decrypt(Encrypted.fromBase64(data), iv: iv);
    }
  }
}
