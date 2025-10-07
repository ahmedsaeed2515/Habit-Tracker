// lib/features/smart_notifications/providers/smart_notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/smart_notification.dart';
import '../services/notification_service.dart';
import '../services/notification_database_service.dart';

final smartNotificationsProvider =
    StateNotifierProvider<SmartNotificationsNotifier, SmartNotificationsState>((
      ref,
    ) {
      return SmartNotificationsNotifier();
    });

class SmartNotificationsState {

  const SmartNotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.notificationSettings = const {},
  });
  final List<SmartNotification> notifications;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, bool> notificationSettings;

  SmartNotificationsState copyWith({
    List<SmartNotification>? notifications,
    bool? isLoading,
    String? errorMessage,
    Map<String, bool>? notificationSettings,
  }) {
    return SmartNotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }
}

class SmartNotificationsNotifier
    extends StateNotifier<SmartNotificationsState> {
  SmartNotificationsNotifier() : super(const SmartNotificationsState()) {
    _initialize();
  }

  late Box _notificationsBox;
  late Box _settingsBox;
  final NotificationService _notificationService = NotificationService();
  final Uuid _uuid = const Uuid();

  // قوائم الرسائل التحفيزية
  final List<String> _morningMotivationalMessages = [
    'صباح الخير! هل أنت مستعد لتحقيق أهدافك اليوم؟ 🌅',
    'يوم جديد، فرصة جديدة للنجاح! ابدأ بقوة 💪',
    'الصباح الباكر هو سر النجاح، انطلق الآن! ⭐',
    'أهدافك تنتظرك، لا تخذلها اليوم! 🎯',
    'كل يوم خطوة نحو النسخة الأفضل منك 🚀',
  ];

  final List<String> _eveningMotivationalMessages = [
    'ممتاز! راجع إنجازاتك اليوم واستعد للغد 🌙',
    'أحسنت اليوم! حان وقت الراحة والتخطيط للغد 😴',
    'نهاية يوم منتج، استعد لنوم هادئ 🛌',
    'تأمل في إنجازاتك اليوم، أنت تتقدم! 🎉',
    'شكراً لنفسك على المجهود المبذول اليوم 👏',
  ];

  final List<String> _habitReminders = [
    'لا تنس عادتك المهمة! كل تكرار يقربك من هدفك 🎯',
    'عادتك تنتظرك! الثبات هو مفتاح النجاح 🗝️',
    'تذكر: العادات الصغيرة تحقق نتائج كبيرة 📈',
    'حان وقت عادتك! استمر في البناء 🏗️',
    'عادة يومية = نجاح مستقبلي! لا تتوقف 🔄',
  ];

  Future<void> _initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      // تهيئة قاعدة بيانات الإشعارات
      await NotificationDatabaseService.initialize();

      // تهيئة صناديق البيانات
      _notificationsBox = NotificationDatabaseService.notificationsBox;
      _settingsBox = NotificationDatabaseService.settingsBox;

      // تهيئة خدمة الإشعارات
      await _notificationService.initialize();

      // تحميل البيانات
      await _loadNotifications();
      await _loadSettings();

      // تشغيل الإشعارات المجدولة
      await _scheduleActiveNotifications();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'خطأ في تهيئة الإشعارات: ${e.toString()}',
      );
    }
  }

  Future<void> _loadNotifications() async {
    // مؤقتاً - سنقوم بإنشاء قائمة فارغة حتى نضع نظام الـ adapters
    final notifications = <SmartNotification>[];
    state = state.copyWith(notifications: notifications);
  }

  Future<void> _loadSettings() async {
    // مؤقتاً - استخدام إعدادات افتراضية
    final settings = <String, bool>{
      'habits': true,
      'tasks': true,
      'workouts': true,
      'motivational': true,
      'achievements': true,
    };
    state = state.copyWith(notificationSettings: settings);
  }

  Future<void> _scheduleActiveNotifications() async {
    for (final notification in state.notifications) {
      if (notification.isActive &&
          notification.scheduledTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(notification);
      }
    }
  }

  // إنشاء إشعار جديد
  Future<String> createNotification({
    required String title,
    required String body,
    required NotificationType type,
    required DateTime scheduledTime,
    String? habitId,
    String? taskId,
    List<int> repeatDays = const [],
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, String> customData = const {},
    bool isSmartTiming = false,
    String? motivationalMessage,
  }) async {
    try {
      final notification = SmartNotification(
        id: _uuid.v4(),
        title: title,
        body: body,
        type: type,
        scheduledTime: scheduledTime,
        habitId: habitId,
        taskId: taskId,
        repeatDays: repeatDays,
        priority: priority,
        customData: customData,
        createdAt: DateTime.now(),
        isSmartTiming: isSmartTiming,
        motivationalMessage: motivationalMessage,
      );

      // حفظ في قاعدة البيانات
      await _notificationsBox.put(notification.id, notification);

      // جدولة الإشعار
      if (notification.isActive) {
        await _notificationService.scheduleNotification(notification);
      }

      // تحديث الحالة
      await _loadNotifications();

      return notification.id;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'خطأ في إنشاء الإشعار: ${e.toString()}',
      );
      rethrow;
    }
  }

  // إنشاء إشعارات العادات التلقائية
  Future<void> createHabitNotifications(
    String habitId,
    String habitName,
    List<DateTime> reminderTimes,
  ) async {
    for (int i = 0; i < reminderTimes.length; i++) {
      final time = reminderTimes[i];
      final message = _habitReminders[i % _habitReminders.length];

      await createNotification(
        title: 'تذكير بالعادة',
        body: '$habitName - $message',
        type: NotificationType.habit,
        scheduledTime: time,
        habitId: habitId,
        repeatDays: [1, 2, 3, 4, 5, 6, 7], // كل يوم
        isSmartTiming: true,
      );
    }
  }

  // إنشاء إشعارات المهام التلقائية
  Future<void> createTaskNotifications(
    String taskId,
    String taskTitle,
    DateTime dueDate,
  ) async {
    final notifications = [
      // تذكير قبل يوم
      {
        'time': dueDate.subtract(const Duration(days: 1)),
        'title': 'تذكير بالمهمة - غداً',
        'body': '$taskTitle تحتاج لإنهائها غداً',
      },
      // تذكير قبل ساعة
      {
        'time': dueDate.subtract(const Duration(hours: 1)),
        'title': 'تذكير عاجل',
        'body': '$taskTitle موعد انتهائها خلال ساعة!',
      },
    ];

    for (final notif in notifications) {
      final time = notif['time']! as DateTime;
      if (time.isAfter(DateTime.now())) {
        await createNotification(
          title: notif['title']! as String,
          body: notif['body']! as String,
          type: NotificationType.task,
          scheduledTime: time,
          taskId: taskId,
          priority: NotificationPriority.high,
        );
      }
    }
  }

  // إنشاء رسائل تحفيزية يومية
  Future<void> createDailyMotivationalNotifications() async {
    final now = DateTime.now();

    // رسالة صباحية (7:00 ص)
    final morningTime = DateTime(now.year, now.month, now.day, 7);
    if (morningTime.isAfter(now)) {
      final message =
          _morningMotivationalMessages[now.day %
              _morningMotivationalMessages.length];
      await createNotification(
        title: 'رسالة تحفيزية صباحية',
        body: message,
        type: NotificationType.motivational,
        scheduledTime: morningTime,
        repeatDays: [1, 2, 3, 4, 5, 6, 7], // كل يوم
        isSmartTiming: true,
      );
    }

    // رسالة مسائية (9:00 م)
    final eveningTime = DateTime(now.year, now.month, now.day, 21);
    if (eveningTime.isAfter(now)) {
      final message =
          _eveningMotivationalMessages[now.day %
              _eveningMotivationalMessages.length];
      await createNotification(
        title: 'رسالة تحفيزية مسائية',
        body: message,
        type: NotificationType.motivational,
        scheduledTime: eveningTime,
        repeatDays: [1, 2, 3, 4, 5, 6, 7], // كل يوم
        isSmartTiming: true,
      );
    }
  }

  // إرسال إشعار إنجاز
  Future<void> sendAchievementNotification(
    String title,
    String description, {
    String? habitId,
  }) async {
    await _notificationService.sendNotification(
      SmartNotification(
        id: _uuid.v4(),
        title: title,
        body: description,
        type: NotificationType.achievement,
        scheduledTime: DateTime.now(),
        habitId: habitId,
        priority: NotificationPriority.high,
        createdAt: DateTime.now(),
      ),
    );
  }

  // إرسال إشعار سلسلة
  Future<void> sendStreakNotification(int streakCount, String habitName) async {
    String message;
    if (streakCount == 7) {
      message = 'مبروك! أسبوع كامل من $habitName 🔥';
    } else if (streakCount == 30) {
      message = 'إنجاز رائع! شهر كامل من $habitName 🏆';
    } else if (streakCount == 100) {
      message = 'أسطورة! 100 يوم من $habitName 👑';
    } else {
      message = 'ممتاز! $streakCount أيام متتالية من $habitName 🔥';
    }

    await _notificationService.sendNotification(
      SmartNotification(
        id: _uuid.v4(),
        title: 'سلسلة إنجازات!',
        body: message,
        type: NotificationType.streak,
        scheduledTime: DateTime.now(),
        priority: NotificationPriority.high,
        createdAt: DateTime.now(),
      ),
    );
  }

  // تعديل إشعار
  Future<void> updateNotification(
    String id, {
    String? title,
    String? body,
    DateTime? scheduledTime,
    bool? isActive,
    List<int>? repeatDays,
    NotificationPriority? priority,
  }) async {
    try {
      final notification = _notificationsBox.get(id);
      if (notification == null) return;

      final updatedNotification = notification.copyWith(
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        isActive: isActive,
        repeatDays: repeatDays,
        priority: priority,
      );

      await _notificationsBox.put(id, updatedNotification);

      // إعادة جدولة الإشعار
      await _notificationService.cancelNotification(id);
      if (updatedNotification.isActive) {
        await _notificationService.scheduleNotification(updatedNotification);
      }

      await _loadNotifications();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'خطأ في تعديل الإشعار: ${e.toString()}',
      );
    }
  }

  // حذف إشعار
  Future<void> deleteNotification(String id) async {
    try {
      await _notificationService.cancelNotification(id);
      await _notificationsBox.delete(id);
      await _loadNotifications();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'خطأ في حذف الإشعار: ${e.toString()}',
      );
    }
  }

  // تفعيل/إلغاء تفعيل إشعار
  Future<void> toggleNotification(String id) async {
    final notification = _notificationsBox.get(id);
    if (notification == null) return;

    await updateNotification(id, isActive: !notification.isActive);
  }

  // حذف جميع الإشعارات
  Future<void> clearAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      await _notificationsBox.clear();
      await _loadNotifications();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'خطأ في حذف جميع الإشعارات: ${e.toString()}',
      );
    }
  }

  // تحديث إعدادات الإشعارات
  Future<void> updateSettings(Map<String, bool> newSettings) async {
    try {
      await _settingsBox.put('settings', newSettings);
      state = state.copyWith(notificationSettings: newSettings);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'خطأ في حفظ الإعدادات: ${e.toString()}',
      );
    }
  }

  // الحصول على إعداد معين
  bool getSetting(String key, {bool defaultValue = true}) {
    return state.notificationSettings[key] ?? defaultValue;
  }

  // تحديد إعداد معين
  Future<void> setSetting(String key, bool value) async {
    final newSettings = Map<String, bool>.from(state.notificationSettings);
    newSettings[key] = value;
    await updateSettings(newSettings);
  }

  // فتح إعدادات النظام
  Future<void> openSystemSettings() async {
    await _notificationService.openNotificationSettings();
  }

  // التحقق من حالة الإشعارات
  Future<bool> checkPermissions() async {
    return _notificationService.areNotificationsEnabled();
  }

  // مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith();
  }

  @override
  void dispose() {
    _notificationsBox.close();
    _settingsBox.close();
    super.dispose();
  }
}
