// lib/features/smart_notifications/services/notification_database_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/smart_notification.dart';

class NotificationDatabaseService {
  static late Box<SmartNotification> _notificationsBox;
  static late Box<Map> _settingsBox;

  static const String _notificationsBoxName = 'smart_notifications';
  static const String _notificationSettingsBoxName = 'notification_settings';

  /// تهيئة قاعدة بيانات الإشعارات
  static Future<void> initialize() async {
    try {
      // تسجيل adapters الإشعارات (سيتم إضافتها لاحقاً)
      debugPrint('تم تخطي تسجيل Hive adapters - سيتم إضافتها لاحقاً');

      // فتح الصناديق كصناديق عامة مؤقتاً
      await Hive.openBox('smart_notifications');
      await Hive.openBox('notification_settings');

      debugPrint('تم تهيئة قاعدة بيانات الإشعارات بنجاح (وضع مؤقت)');
    } catch (e) {
      debugPrint('خطأ في تهيئة قاعدة بيانات الإشعارات: $e');
      rethrow;
    }
  }

  /// الحصول على صندوق الإشعارات
  static Box get notificationsBox => Hive.box('smart_notifications');

  /// الحصول على صندوق الإعدادات
  static Box get settingsBox => Hive.box('notification_settings');

  /// إغلاق قاعدة البيانات
  static Future<void> close() async {
    await Hive.box('smart_notifications').close();
    await Hive.box('notification_settings').close();
  }
}
