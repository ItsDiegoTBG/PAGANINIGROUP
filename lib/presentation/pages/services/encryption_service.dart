import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionService {
  final String _base64Key = dotenv.env['ENCRYPTION_KEY'] ?? 'clave_por_defecto';

  encrypt.Encrypter? _encrypter;
  encrypt.IV? _iv;

  EncryptionService() {
    // Decodificar la clave Base64 y asegurar los 32 bytes
    final keyBytes = base64.decode(_base64Key);
    if (keyBytes.length != 32) {
      throw ArgumentError(
          'La clave debe tener exactamente 32 bytes para AES-256');
    }
    final key = encrypt.Key(keyBytes);
    _iv = encrypt.IV.fromLength(16); // IV de 16 bytes estándar
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  String encryptData(String data) {
    final encrypted = _encrypter!.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedData) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
    return _encrypter!.decrypt(encrypted, iv: _iv!);
  }
}
