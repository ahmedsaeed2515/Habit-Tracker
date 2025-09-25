// lib/features/smart_notifications/services/notification_service.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/smart_notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  // تهيئة خدمة الإشعارات
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // تهيئة Awesome Notifications
      final success = await AwesomeNotifications().initialize(
        null, // أيقونة افتراضية
        [
          // قناة الإشعارات العامة
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'إشعارات عامة',
            channelDescription: 'إشعارات عامة للتطبيق',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // قناة إشعارات العادات
          NotificationChannel(
            channelKey: 'habits_channel',
            channelName: 'تذكير العادات',
            channelDescription: 'تذكيرات للعادات اليومية',
            defaultColor: const Color(0xFF4CAF50),
            ledColor: const Color(0xFF4CAF50),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // قناة إشعارات المهام
          NotificationChannel(
            channelKey: 'tasks_channel',
            channelName: 'تذكير المهام',
            channelDescription: 'تذكيرات للمهام والأعمال',
            defaultColor: const Color(0xFF2196F3),
            ledColor: const Color(0xFF2196F3),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // قناة إشعارات التمارين
          NotificationChannel(
            channelKey: 'workouts_channel',
            channelName: 'تذكير التمارين',
            channelDescription: 'تذكيرات للتمارين والنشاط البدني',
            defaultColor: const Color(0xFFFF5722),
            ledColor: const Color(0xFFFF5722),
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),

          // قناة الرسائل التحفيزية
          NotificationChannel(
            channelKey: 'motivational_channel',
            channelName: 'رسائل تحفيزية',
            channelDescription: 'رسائل تحفيزية وإيجابية',
            defaultColor: const Color(0xFFFF9800),
            ledColor: const Color(0xFFFF9800),
            importance: NotificationImportance.Default,
            channelShowBadge: true,
          ),

          // قناة الإنجازات
          NotificationChannel(
            channelKey: 'achievements_channel',
            channelName: 'الإنجازات',
            channelDescription: 'إشعارات الإنجازات والمكافآت',
            defaultColor: const Color(0xFFFFC107),
            ledColor: const Color(0xFFFFC107),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            soundSource: 'resource://raw/achievement_sound',
          ),
        ],
      );

      if (success) {
        _isInitialized = true;

        // طلب الأذونات
        await _requestPermissions();

        // إعداد مستمعات الإشعارات
        _setupListeners();

        debugPrint('✅ تم تهيئة خدمة الإشعارات بنجاح');
        return true;
      }
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة الإشعارات: $e');
    }

    return false;
  }

  // طلب الأذونات المطلوبة
  Future<bool> _requestPermissions() async {
    // أذونات النظام
    final systemPermission = await Permission.notification.request();

    // أذونات التطبيق
    final appPermission = await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
          if (!isAllowed) {
            return await AwesomeNotifications()
                .requestPermissionToSendNotifications();
          }
          return true;
        });

    final hasPermissions = systemPermission.isGranted && appPermission;

    if (hasPermissions) {
      debugPrint('✅ تم منح جميع أذونات الإشعارات');
    } else {
      debugPrint('❌ لم يتم منح أذونات الإشعارات');
    }

    return hasPermissions;
  }

  // إعداد مستمعات الأحداث
  void _setupListeners() {
    // عند إنشاء إشعار
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onDismissActionReceived,
    );
  }

  // عند تلقي إجراء من الإشعار
  static Future<void> _onActionReceived(ReceivedAction receivedAction) async {
    debugPrint('🔔 تم تلقي إجراء من الإشعار: ${receivedAction.actionType}');

    // معالجة الإجراءات حسب النوع
    switch (receivedAction.actionType) {
      case ActionType.Default:
        // فتح التطبيق
        break;
      case ActionType.SilentAction:
        // إجراء صامت (مثل تسجيل إكمال العادة)
        await _handleSilentAction(receivedAction);
        break;
      case ActionType.SilentBackgroundAction:
        // إجراء في الخلفية
        await _handleBackgroundAction(receivedAction);
        break;
      default:
        break;
    }
  }

  // عند إنشاء الإشعار
  static Future<void> _onNotificationCreated(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('📱 تم إنشاء إشعار: ${receivedNotification.title}');
  }

  // عند عرض الإشعار
  static Future<void> _onNotificationDisplayed(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('👁️ تم عرض إشعار: ${receivedNotification.title}');
  }

  // عند رفض الإشعار
  static Future<void> _onDismissActionReceived(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('❌ تم رفض الإشعار: ${receivedAction.title}');
  }

  // معالجة الإجراءات الصامتة
  static Future<void> _handleSilentAction(ReceivedAction action) async {
    // يمكن هنا تنفيذ إجراءات مثل تسجيل إكمال العادة
    final payload = action.payload;
    if (payload != null) {
      final habitId = payload['habitId'];
      final taskId = payload['taskId'];

      if (habitId != null) {
        // تسجيل إكمال العادة
        debugPrint('✅ تسجيل إكمال العادة: $habitId');
      }

      if (taskId != null) {
        // تسجيل إكمال المهمة
        debugPrint('✅ تسجيل إكمال المهمة: $taskId');
      }
    }
  }

  // معالجة إجراءات الخلفية
  static Future<void> _handleBackgroundAction(ReceivedAction action) async {
    debugPrint('🔧 معالجة إجراء الخلفية: ${action.actionType}');
  }

  // إرسال إشعار فوري
  Future<bool> sendNotification(SmartNotification notification) async {
    if (!_isInitialized) {
      debugPrint('❌ خدمة الإشعارات غير مهيئة');
      return false;
    }

    try {
      final success = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notification.id.hashCode,
          channelKey: _getChannelKey(notification.type),
          title: '${notification.type.icon} ${notification.title}',
          body: notification.body,
          bigPicture: null,
          largeIcon: null,
          notificationLayout: NotificationLayout.Default,
          payload: {
            'notificationId': notification.id,
            'type': notification.type.name,
            if (notification.habitId != null) 'habitId': notification.habitId!,
            if (notification.taskId != null) 'taskId': notification.taskId!,
            ...notification.customData,
          },
          category: _getNotificationCategory(notification.type),
          wakeUpScreen:
              notification.priority == NotificationPriority.high ||
              notification.priority == NotificationPriority.critical,
          fullScreenIntent:
              notification.priority == NotificationPriority.critical,
        ),
        actionButtons: _buildActionButtons(notification),
      );

      if (success) {
        notification.markAsSent();
        debugPrint('✅ تم إرسال الإشعار: ${notification.title}');
      }

      return success;
    } catch (e) {
      debugPrint('❌ خطأ في إرسال الإشعار: $e');
      return false;
    }
  }

  // جدولة إشعار
  Future<bool> scheduleNotification(SmartNotification notification) async {
    if (!_isInitialized) {
      debugPrint('❌ خدمة الإشعارات غير مهيئة');
      return false;
    }

    try {
      NotificationSchedule schedule;

      if (notification.repeatDays.isNotEmpty) {
        // إشعار متكرر
        schedule = NotificationCalendar(
          hour: notification.scheduledTime.hour,
          minute: notification.scheduledTime.minute,
          second: 0,
          millisecond: 0,
          allowWhileIdle: true,
          repeats: true,
        );
      } else {
        // إشعار لمرة واحدة
        schedule = NotificationCalendar.fromDate(
          date: notification.scheduledTime,
          allowWhileIdle: true,
        );
      }

      final success = await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notification.id.hashCode,
          channelKey: _getChannelKey(notification.type),
          title: '${notification.type.icon} ${notification.title}',
          body: notification.body,
          payload: {
            'notificationId': notification.id,
            'type': notification.type.name,
            if (notification.habitId != null) 'habitId': notification.habitId!,
            if (notification.taskId != null) 'taskId': notification.taskId!,
            ...notification.customData,
          },
          category: _getNotificationCategory(notification.type),
          wakeUpScreen:
              notification.priority == NotificationPriority.high ||
              notification.priority == NotificationPriority.critical,
        ),
        actionButtons: _buildActionButtons(notification),
        schedule: schedule,
      );

      if (success) {
        debugPrint('📅 تم جدولة الإشعار: ${notification.title}');
      }

      return success;
    } catch (e) {
      debugPrint('❌ خطأ في جدولة الإشعار: $e');
      return false;
    }
  }

  // إلغاء إشعار
  Future<bool> cancelNotification(String notificationId) async {
    try {
      await AwesomeNotifications().cancel(notificationId.hashCode);
      debugPrint('🗑️ تم إلغاء الإشعار: $notificationId');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في إلغاء الإشعار: $e');
      return false;
    }
  }

  // إلغاء جميع الإشعارات
  Future<bool> cancelAllNotifications() async {
    try {
      await AwesomeNotifications().cancelAll();
      debugPrint('🗑️ تم إلغاء جميع الإشعارات');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في إلغاء جميع الإشعارات: $e');
      return false;
    }
  }

  // الحصول على قناة الإشعار
  String _getChannelKey(NotificationType type) {
    switch (type) {
      case NotificationType.habit:
        return 'habits_channel';
      case NotificationType.task:
        return 'tasks_channel';
      case NotificationType.workout:
      case NotificationType.morningExercise:
        return 'workouts_channel';
      case NotificationType.motivational:
        return 'motivational_channel';
      case NotificationType.achievement:
      case NotificationType.streak:
        return 'achievements_channel';
      case NotificationType.reminder:
      case NotificationType.weeklyReport:
        return 'basic_channel';
    }
  }

  // الحصول على فئة الإشعار
  NotificationCategory _getNotificationCategory(NotificationType type) {
    switch (type) {
      case NotificationType.habit:
      case NotificationType.task:
      case NotificationType.workout:
      case NotificationType.morningExercise:
        return NotificationCategory.Reminder;
      case NotificationType.motivational:
        return NotificationCategory.Social;
      case NotificationType.achievement:
      case NotificationType.streak:
        return NotificationCategory.Status;
      case NotificationType.reminder:
      case NotificationType.weeklyReport:
        return NotificationCategory.Reminder;
    }
  }

  // بناء أزرار الإجراءات
  List<NotificationActionButton>? _buildActionButtons(
    SmartNotification notification,
  ) {
    switch (notification.type) {
      case NotificationType.habit:
        return [
          NotificationActionButton(
            key: 'MARK_DONE',
            label: 'تم ✅',
            actionType: ActionType.SilentAction,
            isDangerousOption: false,
          ),
          NotificationActionButton(
            key: 'REMIND_LATER',
            label: 'تذكير لاحقاً ⏰',
            actionType: ActionType.SilentAction,
            isDangerousOption: false,
          ),
        ];

      case NotificationType.task:
        return [
          NotificationActionButton(
            key: 'COMPLETE_TASK',
            label: 'إكمال ✅',
            actionType: ActionType.SilentAction,
            isDangerousOption: false,
          ),
          NotificationActionButton(
            key: 'SNOOZE',
            label: 'غفوة 🔕',
            actionType: ActionType.SilentAction,
            isDangerousOption: false,
          ),
        ];

      default:
        return null;
    }
  }

  // التحقق من حالة الإشعارات
  Future<bool> areNotificationsEnabled() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  // فتح إعدادات الإشعارات
  Future<void> openNotificationSettings() async {
    await AwesomeNotifications().showNotificationConfigPage();
  }
}
