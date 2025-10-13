// lib/core/services/encryption_service.dart
// خدمة التشفير للبيانات الحساسة

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

/// خدمة التشفير للبيانات الحساسة
class EncryptionService {
  factory EncryptionService() => _instance;
  EncryptionService._internal();
  static final EncryptionService _instance = EncryptionService._internal();

  static const String _keyName = 'encryption_key';
  static const String _ivName = 'encryption_iv';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  encrypt.Key? _encryptionKey;
  encrypt.IV? _encryptionIV;
  encrypt.Encrypter? _encrypter;
  bool _initialized = false;

  /// تهيئة خدمة التشفير
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // محاولة تحميل المفتاح الموجود
      await _loadOrGenerateKey();
      await _loadOrGenerateIV();

      // إنشاء المشفر
      if (_encryptionKey != null) {
        _encrypter = encrypt.Encrypter(
          encrypt.AES(_encryptionKey!, mode: encrypt.AESMode.cbc),
        );
      }

      _initialized = true;
      debugPrint('✅ تم تهيئة خدمة التشفير بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة التشفير: $e');
      rethrow;
    }
  }

  /// تحميل أو توليد مفتاح التشفير
  Future<void> _loadOrGenerateKey() async {
    try {
      // محاولة تحميل المفتاح الموجود
      final keyString = await _secureStorage.read(key: _keyName);

      if (keyString != null) {
        _encryptionKey = encrypt.Key.fromBase64(keyString);
        debugPrint('✅ تم تحميل مفتاح التشفير الموجود');
      } else {
        // توليد مفتاح جديد
        _encryptionKey = encrypt.Key.fromSecureRandom(32);
        await _secureStorage.write(
          key: _keyName,
          value: _encryptionKey!.base64,
        );
        debugPrint('✅ تم توليد مفتاح تشفير جديد');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل/توليد مفتاح التشفير: $e');
      rethrow;
    }
  }

  /// تحميل أو توليد IV (Initialization Vector)
  Future<void> _loadOrGenerateIV() async {
    try {
      final ivString = await _secureStorage.read(key: _ivName);

      if (ivString != null) {
        _encryptionIV = encrypt.IV.fromBase64(ivString);
        debugPrint('✅ تم تحميل IV الموجود');
      } else {
        _encryptionIV = encrypt.IV.fromSecureRandom(16);
        await _secureStorage.write(
          key: _ivName,
          value: _encryptionIV!.base64,
        );
        debugPrint('✅ تم توليد IV جديد');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل/توليد IV: $e');
      rethrow;
    }
  }

  /// تشفير نص
  String encryptString(String plainText) {
    if (!_initialized || _encrypter == null || _encryptionIV == null) {
      throw Exception('خدمة التشفير غير مهيأة');
    }

    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _encryptionIV);
      return encrypted.base64;
    } catch (e) {
      debugPrint('❌ خطأ في تشفير النص: $e');
      rethrow;
    }
  }

  /// فك تشفير نص
  String decryptString(String encryptedText) {
    if (!_initialized || _encrypter == null || _encryptionIV == null) {
      throw Exception('خدمة التشفير غير مهيأة');
    }

    try {
      final decrypted = _encrypter!.decrypt64(encryptedText, iv: _encryptionIV);
      return decrypted;
    } catch (e) {
      debugPrint('❌ خطأ في فك تشفير النص: $e');
      rethrow;
    }
  }

  /// تشفير بيانات JSON
  String encryptJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    return encryptString(jsonString);
  }

  /// فك تشفير بيانات JSON
  Map<String, dynamic> decryptJson(String encryptedData) {
    final jsonString = decryptString(encryptedData);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// الحصول على مفتاح تشفير Hive
  Future<List<int>> getHiveEncryptionKey() async {
    if (!_initialized) {
      await initialize();
    }

    if (_encryptionKey == null) {
      throw Exception('مفتاح التشفير غير متوفر');
    }

    // إنشاء مفتاح 256-bit من المفتاح الأساسي
    final keyBytes = _encryptionKey!.bytes;
    
    // استخدام SHA-256 للحصول على مفتاح ثابت الطول
    final digest = sha256.convert(keyBytes);
    
    return digest.bytes;
  }

  /// إعادة تعيين مفاتيح التشفير (استخدام بحذر!)
  Future<void> resetEncryptionKeys() async {
    try {
      await _secureStorage.delete(key: _keyName);
      await _secureStorage.delete(key: _ivName);
      
      _encryptionKey = null;
      _encryptionIV = null;
      _encrypter = null;
      _initialized = false;

      debugPrint('⚠️ تم إعادة تعيين مفاتيح التشفير');
    } catch (e) {
      debugPrint('❌ خطأ في إعادة تعيين مفاتيح التشفير: $e');
      rethrow;
    }
  }

  /// حذف جميع البيانات المشفرة بشكل آمن
  Future<void> secureDeleteAllData() async {
    try {
      await _secureStorage.deleteAll();
      _encryptionKey = null;
      _encryptionIV = null;
      _encrypter = null;
      _initialized = false;
      
      debugPrint('⚠️ تم حذف جميع البيانات المشفرة');
    } catch (e) {
      debugPrint('❌ خطأ في حذف البيانات: $e');
      rethrow;
    }
  }

  /// التحقق من حالة التهيئة
  bool get isInitialized => _initialized;
}
