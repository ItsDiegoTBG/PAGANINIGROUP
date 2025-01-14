import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionService {
  final String _base64Key = dotenv.env['ENCRYPTION_KEY'] ?? 'clave_por_defecto';

  late final encrypt.Encrypter _encrypter;
  late final encrypt.Key _key;

  EncryptionService() {
    try {
      // Decodificar la clave Base64 y validar longitud
      final keyBytes = base64.decode(_base64Key);
      if (keyBytes.length != 32) {
        throw ArgumentError(
            'La clave debe tener exactamente 32 bytes para AES-256');
      }
      _key = encrypt.Key(keyBytes);
      _encrypter =
          encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    } catch (e) {
      throw Exception('Error al inicializar el servicio de encriptación: $e');
    }
  }

  String encryptData(String data) {
    try {
      // Generar un IV aleatorio
      final iv = encrypt.IV.fromLength(16); // IV de 16 bytes
      final encrypted = _encrypter.encrypt(data, iv: iv);

      // Concatenar el IV con los datos cifrados
      final encryptedDataWithIv ='${base64.encode(iv.bytes)}:${encrypted.base64}';
      return encryptedDataWithIv;
    } catch (e) {
      debugPrint("Error al cifrar: $e");
      return '';
    }
  }

  String decryptData(String encryptedDataWithIv) {
    try {
      // Separar el IV y los datos cifrados
      final parts = encryptedDataWithIv.split(':');
      if (parts.length != 2) {
        throw ArgumentError('Formato de datos cifrados incorrecto');
      }

      final ivFromEncrypted = encrypt.IV.fromBase64(parts[0]);
      final encryptedData = parts[1];

      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);

      // Desencriptar usando el IV extraído
      return _encrypter.decrypt(encrypted, iv: ivFromEncrypted);
    } catch (e) {
      debugPrint('Error al desencriptar: $e');
      return 'Error al desencriptar';
    }
  }
}
