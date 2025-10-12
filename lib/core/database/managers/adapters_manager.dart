// lib/core/database/managers/adapters_manager.dart
// مدير تسجيل جميع محولات Hive - النسخة المعاد هيكلتها

import 'package:flutter/foundation.dart';
import 'adapters/core_adapters.dart';
import 'adapters/feature_adapters.dart';
import 'adapters/health_adapters.dart';
import 'adapters/pomodoro_adapters.dart';
import 'adapters/taskmeta_adapters.dart';

/// مدير تسجيل جميع محولات Hive
class AdaptersManager {
  /// تسجيل جميع المحولات المطلوبة
  static void registerAllAdapters() {
    debugPrint('🔄 بدء تسجيل محولات Hive...');

    // المحولات الأساسية
    CoreAdaptersRegistrar.registerAll();

    // محولات الميزات المتقدمة
    FeatureAdaptersRegistrar.registerAll();

    // محولات الصحة واللياقة
    HealthAdaptersRegistrar.registerAll();

    // محولات بومودورو
    PomodoroAdaptersRegistrar.registerAll();

    // محولات Task Meta الجديدة
    TaskMetaAdaptersRegistrar.registerAll();

    debugPrint('✅ تم تسجيل جميع محولات Hive بنجاح');
  }

  /// تسجيل محولات محددة فقط (للاختبار أو التطوير)
  static void registerCoreOnly() {
    CoreAdaptersRegistrar.registerAll();
    debugPrint('✅ تم تسجيل المحولات الأساسية فقط');
  }

  /// تسجيل محولات Task Meta فقط
  static void registerTaskMetaOnly() {
    CoreAdaptersRegistrar.registerAll();
    TaskMetaAdaptersRegistrar.registerAll();
    debugPrint('✅ تم تسجيل المحولات الأساسية و Task Meta فقط');
  }
}
