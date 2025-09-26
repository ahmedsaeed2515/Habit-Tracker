// نظام إدارة مهام البومودورو - ملف الفهرسة الرئيسي
library pomodoro_task_management;

import 'package:flutter/foundation.dart';

// النماذج (Models)
export 'models/pomodoro_models.dart';

// الخدمات (Services)
export 'services/smart_pomodoro_service.dart';

// موفرو الحالة (Providers)
export 'providers/pomodoro_providers.dart';

// الشاشات (Screens)
export 'screens/pomodoro_todo_screen.dart';
export 'screens/analytics_screen.dart';
export 'screens/achievements_screen.dart';

// الويدجتس (Widgets)
export 'widgets/pomodoro_timer_widget.dart';
export 'widgets/task_item_widget.dart';
export 'widgets/quick_stats_widget.dart';
export 'widgets/quick_settings_widget.dart';

// التوجيه (Routes)
export 'routes.dart';

/// فئة رئيسية لإعداد وتهيئة نظام البومودورو
class PomodoroTaskManagementSystem {
  static bool _isInitialized = false;

  /// تهيئة النظام
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // تهيئة قاعدة البيانات
      await _initializeDatabase();
      
      // تهيئة الإعدادات الافتراضية
      await _initializeDefaultSettings();
      
      // تهيئة الإنجازات الأساسية
      await _initializeBaseAchievements();
      
      _isInitialized = true;
      debugPrint('✅ تم تهيئة نظام إدارة مهام البومودورو بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة نظام البومودورو: $e');
      rethrow;
    }
  }

  /// تهيئة قاعدة البيانات
  static Future<void> _initializeDatabase() async {
    // سيتم تنفيذ هذا في ملف main.dart عند تهيئة Hive
    debugPrint('🗄️ جاري تهيئة قاعدة البيانات...');
  }

  /// تهيئة الإعدادات الافتراضية
  static Future<void> _initializeDefaultSettings() async {
    debugPrint('⚙️ جاري تهيئة الإعدادات الافتراضية...');
    // سيتم تنفيذ هذا عبر المزودين (Providers)
  }

  /// تهيئة الإنجازات الأساسية
  static Future<void> _initializeBaseAchievements() async {
    debugPrint('🏆 جاري تهيئة الإنجازات الأساسية...');
    // سيتم تنفيذ هذا عبر المزودين (Providers)
  }

  /// التحقق من حالة التهيئة
  static bool get isInitialized => _isInitialized;

  /// إعادة تعيين النظام
  static void reset() {
    _isInitialized = false;
    debugPrint('🔄 تم إعادة تعيين نظام البومودورو');
  }
}

/// معلومات النظام
class PomodoroSystemInfo {
  static const String version = '1.0.0';
  static const String name = 'نظام إدارة مهام البومودورو';
  static const String description = 'نظام شامل لإدارة المهام باستخدام تقنية البومودورو مع ميزات ذكية متقدمة';
  
  /// الميزات المتاحة
  static const List<String> features = [
    'إدارة جلسات البومودورو المتقدمة',
    'نظام مهام شامل مع المهام الفرعية',
    'إحصائيات وتحليلات تفصيلية',
    'نظام الإنجازات والمكافآت',
    'تحليل الإنتاجية بالذكاء الاصطناعي',
    'التذكيرات الذكية والإشعارات',
    'أوضاع التركيز المتخصصة',
    'مؤقتات متعددة',
    'تخصيص السمات والمظاهر',
    'التشغيل في الخلفية',
    'تصدير واستيراد البيانات',
    'المزامنة عبر الأجهزة (قريباً)',
  ];

  /// متطلبات النظام
  static const Map<String, String> requirements = {
    'Flutter': '>= 3.9.2',
    'Dart': '>= 2.19.6',
    'Android': '>= 21 (Android 5.0)',
    'iOS': '>= 11.0',
    'المساحة المطلوبة': '~50 MB',
    'الذاكرة': '>= 2 GB RAM',
  };

  /// المطورون
  static const Map<String, String> developers = {
    'المطور الرئيسي': 'فريق تطوير التطبيقات',
    'تصميم الواجهات': 'فريق التصميم',
    'اختبار الجودة': 'فريق ضمان الجودة',
    'الدعم الفني': 'support@habittracker.com',
  };

  /// طباعة معلومات النظام
  static void printSystemInfo() {
    debugPrint('═══════════════════════════════════════════════');
    debugPrint('📱 $name - v$version');
    debugPrint('📝 $description');
    debugPrint('═══════════════════════════════════════════════');
    debugPrint('✨ الميزات المتاحة:');
    for (int i = 0; i < features.length; i++) {
      debugPrint('   ${i + 1}. ${features[i]}');
    }
    debugPrint('═══════════════════════════════════════════════');
    debugPrint('⚙️ متطلبات النظام:');
    requirements.forEach((key, value) {
      debugPrint('   $key: $value');
    });
    debugPrint('═══════════════════════════════════════════════');
  }
}

/// معالج الأخطاء للنظام
class PomodoroErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    debugPrint('🚨 خطأ في نظام البومودورو:');
    debugPrint('   الخطأ: $error');
    debugPrint('   التتبع: $stackTrace');
    
    // يمكن هنا إرسال التقرير إلى خدمة مراقبة الأخطاء
    // مثل Firebase Crashlytics أو Sentry
  }

  static void logInfo(String message) {
    debugPrint('ℹ️ معلومات النظام: $message');
  }

  static void logWarning(String message) {
    debugPrint('⚠️ تحذير: $message');
  }

  static void logDebug(String message) {
    debugPrint('🐛 تصحيح: $message');
  }
}
