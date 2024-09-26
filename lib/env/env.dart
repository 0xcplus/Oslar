import 'package:envied/envied.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart';
//import 'dart:convert';

@Envied(path: "assets/config/.env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static String get apiKey {
    try {
      String? encryptedApiKey = dotenv.env['OPEN_AI_API_KEY'];

      if (encryptedApiKey != null) {
        return _decryptApiKey(encryptedApiKey, 'your_passphrase'); // 'your_passphrase'는 GitHub Secrets의 암호화 키
      } else {
        return 'dummy_key';
      }
    } catch (e) {
      print('Error loading API key: $e');
      return 'fatal error;';
    }
  }

  static String _decryptApiKey(String encryptedApiKey, String passphrase) {
    final key = Key.fromUtf8(passphrase.padRight(32, ' ')); // 32-byte 키
    final iv = IV.fromLength(16); // AES는 16-byte IV 필요
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final decrypted = encrypter.decrypt64(encryptedApiKey, iv: iv);

    return decrypted;
  }
}