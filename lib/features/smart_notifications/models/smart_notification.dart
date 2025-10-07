// lib/features/smart_notifications/models/smart_notification.dart
import 'package:hive/hive.dart';

part 'smart_notification.g.dart';

@HiveType(typeId: 10)
class SmartNotification extends HiveObject { // رسالة تحفيزية مخصصة

  SmartNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.scheduledTime,
    this.habitId,
    this.taskId,
    this.isActive = true,
    this.repeatDays = const [],
    this.priority = NotificationPriority.normal,
    this.customData = const {},
    required this.createdAt,
    this.lastSent,
    this.sentCount = 0,
    this.isSmartTiming = false,
    this.motivationalMessage,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  NotificationType type;

  @HiveField(4)
  DateTime scheduledTime;

  @HiveField(5)
  String? habitId;

  @HiveField(6)
  String? taskId;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  List<int> repeatDays; // أيام الأسبوع (0-6, حيث 0 = الأحد)

  @HiveField(9)
  NotificationPriority priority;

  @HiveField(10)
  Map<String, String> customData;

  @HiveField(11)
  DateTime createdAt;

  @HiveField(12)
  DateTime? lastSent;

  @HiveField(13)
  int sentCount;

  @HiveField(14)
  bool isSmartTiming; // هل يستخدم التوقيت الذكي؟

  @HiveField(15)
  String? motivationalMessage;

  // تحديث وقت الإرسال الأخير
  void markAsSent() {
    lastSent = DateTime.now();
    sentCount++;
    save();
  }

  // تحقق من إمكانية إرسال الإشعار
  bool canSendNow() {
    if (!isActive) return false;

    // تحقق من أيام التكرار
    if (repeatDays.isNotEmpty) {
      final today = DateTime.now().weekday % 7;
      if (!repeatDays.contains(today)) return false;
    }

    // تحقق من التوقيت
    final now = DateTime.now();
    if (scheduledTime.isAfter(now)) return false;

    return true;
  }

  // إنشاء نسخة مخصصة
  SmartNotification copyWith({
    String? title,
    String? body,
    NotificationType? type,
    DateTime? scheduledTime,
    String? habitId,
    String? taskId,
    bool? isActive,
    List<int>? repeatDays,
    NotificationPriority? priority,
    Map<String, String>? customData,
    bool? isSmartTiming,
    String? motivationalMessage,
  }) {
    return SmartNotification(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      habitId: habitId ?? this.habitId,
      taskId: taskId ?? this.taskId,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
      priority: priority ?? this.priority,
      customData: customData ?? this.customData,
      createdAt: createdAt,
      lastSent: lastSent,
      sentCount: sentCount,
      isSmartTiming: isSmartTiming ?? this.isSmartTiming,
      motivationalMessage: motivationalMessage ?? this.motivationalMessage,
    );
  }
}

@HiveType(typeId: 11)
enum NotificationType {
  @HiveField(0)
  habit, // تذكير بالعادة

  @HiveField(1)
  task, // تذكير بالمهمة

  @HiveField(2)
  workout, // تذكير بالتمرين

  @HiveField(3)
  morningExercise, // تذكير بالتمرين الصباحي

  @HiveField(4)
  motivational, // رسالة تحفيزية

  @HiveField(5)
  achievement, // إشعار إنجاز

  @HiveField(6)
  streak, // إشعار السلسلة

  @HiveField(7)
  reminder, // تذكير عام

  @HiveField(8)
  weeklyReport, // التقرير الأسبوعي
}

@HiveType(typeId: 12)
enum NotificationPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  normal,

  @HiveField(2)
  high,

  @HiveField(3)
  critical,
}

// امتدادات مساعدة
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.habit:
        return 'تذكير بالعادة';
      case NotificationType.task:
        return 'تذكير بالمهمة';
      case NotificationType.workout:
        return 'تذكير بالتمرين';
      case NotificationType.morningExercise:
        return 'تمرين صباحي';
      case NotificationType.motivational:
        return 'رسالة تحفيزية';
      case NotificationType.achievement:
        return 'إنجاز';
      case NotificationType.streak:
        return 'سلسلة';
      case NotificationType.reminder:
        return 'تذكير';
      case NotificationType.weeklyReport:
        return 'التقرير الأسبوعي';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.habit:
        return '✅';
      case NotificationType.task:
        return '📝';
      case NotificationType.workout:
        return '🏋️';
      case NotificationType.morningExercise:
        return '🌅';
      case NotificationType.motivational:
        return '💪';
      case NotificationType.achievement:
        return '🏆';
      case NotificationType.streak:
        return '🔥';
      case NotificationType.reminder:
        return '⏰';
      case NotificationType.weeklyReport:
        return '📊';
    }
  }
}
