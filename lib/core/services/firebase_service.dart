// lib/core/services/firebase_service.dart
// خدمة Firebase الأساسية - تدعم العمل بدون اتصال

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// خدمة Firebase الأساسية
class FirebaseService {
  factory FirebaseService() => _instance;
  FirebaseService._internal();
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// تفعيل الوضع Offline
  Future<void> enableOfflineMode() async {
    try {
      await firestore.enablePersistence(
        const PersistenceSettings(synchronizeTabs: true),
      );
    } catch (e) {
      // قد يكون مفعل مسبقاً
    }
  }

  /// تهيئة Firebase
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // تفعيل الوضع Offline
      await enableOfflineMode();
      _isInitialized = true;
    } catch (e) {
      // يمكن العمل بدون Firebase
      _isInitialized = false;
    }
  }

  /// التحقق من وجود اتصال
  bool get hasConnection => _isInitialized;

  /// الحصول على المستخدم الحالي
  User? get currentUser => auth.currentUser;

  /// تسجيل الدخول كضيف
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await auth.signInAnonymously();
    } catch (e) {
      return null;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      // تجاهل الأخطاء
    }
  }
}
