// lib/core/database/managers/base_database_manager.dart
// المدير الأساسي لقاعدة البيانات

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// المدير الأساسي لقاعدة البيانات - يحتوي على الوظائف المشتركة
abstract class BaseDatabaseManager {
  /// تسجيل محول Hive إذا لم يكن مسجلاً مسبقاً
  static void registerAdapterSafe<T>(TypeAdapter<T> adapter, int typeId) {
    try {
      if (!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(adapter);
        debugPrint('✅ تم تسجيل adapter للنوع $T بـ ID $typeId');
      }
    } catch (e) {
      debugPrint('⚠️ تخطي تسجيل adapter للنوع $T: $e');
    }
  }

  /// فتح صندوق Hive بأمان
  static Future<Box<T>> openBoxSafe<T>(String boxName) async {
    try {
      final box = await Hive.openBox<T>(boxName);
      debugPrint('✅ تم فتح صندوق $boxName بنجاح');
      return box;
    } catch (e) {
      debugPrint('❌ خطأ في فتح صندوق $boxName: $e');
      rethrow;
    }
  }

  /// إنشاء بيانات افتراضية للصندوق
  static Future<void> createDefaultDataIfEmpty<T>(
    Box<T> box,
    String boxName,
    List<MapEntry<String, T>> defaultData,
  ) async {
    if (box.isEmpty && defaultData.isNotEmpty) {
      for (var entry in defaultData) {
        await box.put(entry.key, entry.value);
      }
      debugPrint('✅ تم إنشاء البيانات الافتراضية لـ $boxName');
    }
  }
}
