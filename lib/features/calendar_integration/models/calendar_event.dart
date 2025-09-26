import 'package:hive/hive.dart';

part 'calendar_event.g.dart';

@HiveType(typeId: 63)
class CalendarEvent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  @HiveField(5)
  EventType type;

  @HiveField(6)
  String? habitId;

  @HiveField(7)
  bool isAllDay;

  @HiveField(8)
  EventRecurrence? recurrence;

  @HiveField(9)
  List<EventReminder> reminders;

  @HiveField(10)
  String color;

  @HiveField(11)
  EventStatus status;

  @HiveField(12)
  Map<String, dynamic> metadata;

  @HiveField(13)
  String? location;

  @HiveField(14)
  List<String> attendees;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    required this.type,
    this.habitId,
    this.isAllDay = false,
    this.recurrence,
    this.reminders = const [],
    this.color = '#2196F3',
    this.status = EventStatus.scheduled,
    this.metadata = const {},
    this.location,
    this.attendees = const [],
  });

  // فحص ما إذا كان الحدث في تاريخ محدد
  bool isOnDate(DateTime date) {
    final startDate = DateTime(startTime.year, startTime.month, startTime.day);
    final endDate = DateTime(endTime.year, endTime.month, endTime.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    return targetDate.isAtSameMomentAs(startDate) ||
           targetDate.isAtSameMomentAs(endDate) ||
           (targetDate.isAfter(startDate) && targetDate.isBefore(endDate));
  }

  // الحصول على مدة الحدث
  Duration get duration => endTime.difference(startTime);

  // تحديث حالة الحدث
  void updateStatus(EventStatus newStatus) {
    status = newStatus;
    save();
  }

  // إضافة تذكير
  void addReminder(EventReminder reminder) {
    final newReminders = List<EventReminder>.from(reminders);
    newReminders.add(reminder);
    reminders = newReminders;
    save();
  }

  // إزالة تذكير
  void removeReminder(EventReminder reminder) {
    final newReminders = List<EventReminder>.from(reminders);
    newReminders.removeWhere((r) => r.id == reminder.id);
    reminders = newReminders;
    save();
  }

  // فحص ما إذا كان الحدث متكرر
  bool get isRecurring => recurrence != null;

  // الحصول على الأحداث المتكررة التالية
  List<CalendarEvent> getRecurringEvents(DateTime until) {
    if (!isRecurring) return [];

    final events = <CalendarEvent>[];
    var currentStart = startTime;
    var currentEnd = endTime;
    final eventDuration = duration;
    
    while (currentStart.isBefore(until)) {
      // حساب التاريخ التالي بناءً على نوع التكرار
      switch (recurrence!.type) {
        case RecurrenceType.daily:
          currentStart = currentStart.add(Duration(days: recurrence!.interval));
          break;
        case RecurrenceType.weekly:
          currentStart = currentStart.add(Duration(days: 7 * recurrence!.interval));
          break;
        case RecurrenceType.monthly:
          currentStart = DateTime(
            currentStart.year,
            currentStart.month + recurrence!.interval,
            currentStart.day,
            currentStart.hour,
            currentStart.minute,
          );
          break;
        case RecurrenceType.yearly:
          currentStart = DateTime(
            currentStart.year + recurrence!.interval,
            currentStart.month,
            currentStart.day,
            currentStart.hour,
            currentStart.minute,
          );
          break;
      }
      
      currentEnd = currentStart.add(eventDuration);
      
      if (currentStart.isBefore(until)) {
        events.add(CalendarEvent(
          id: '${id}_${currentStart.millisecondsSinceEpoch}',
          title: title,
          description: description,
          startTime: currentStart,
          endTime: currentEnd,
          type: type,
          habitId: habitId,
          isAllDay: isAllDay,
          color: color,
          status: EventStatus.scheduled,
          location: location,
          attendees: attendees,
        ));
      }
    }
    
    return events;
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type.name,
      'habitId': habitId,
      'isAllDay': isAllDay,
      'recurrence': recurrence?.toMap(),
      'reminders': reminders.map((r) => r.toMap()).toList(),
      'color': color,
      'status': status.name,
      'metadata': metadata,
      'location': location,
      'attendees': attendees,
    };
  }
}

@HiveType(typeId: 64)
enum EventType {
  @HiveField(0)
  habit,          // عادة

  @HiveField(1)
  reminder,       // تذكير

  @HiveField(2)
  appointment,    // موعد

  @HiveField(3)
  task,           // مهمة

  @HiveField(4)
  workout,        // تمرين

  @HiveField(5)
  meal,           // وجبة

  @HiveField(6)
  meeting,        // اجتماع

  @HiveField(7)
  personal,       // شخصي

  @HiveField(8)
  other,          // أخرى
}

@HiveType(typeId: 65)
enum EventStatus {
  @HiveField(0)
  scheduled,      // مجدول

  @HiveField(1)
  completed,      // مكتمل

  @HiveField(2)
  missed,         // فائت

  @HiveField(3)
  cancelled,      // ملغي

  @HiveField(4)
  postponed,      // مؤجل
}

@HiveType(typeId: 66)
class EventRecurrence extends HiveObject {
  @HiveField(0)
  RecurrenceType type;

  @HiveField(1)
  int interval; // كل كم (يوم/أسبوع/شهر/سنة)

  @HiveField(2)
  List<int> daysOfWeek; // للتكرار الأسبوعي (1=الاثنين, 7=الأحد)

  @HiveField(3)
  int? dayOfMonth; // للتكرار الشهري

  @HiveField(4)
  DateTime? endDate; // تاريخ انتهاء التكرار

  @HiveField(5)
  int? occurrences; // عدد التكرارات

  EventRecurrence({
    required this.type,
    this.interval = 1,
    this.daysOfWeek = const [],
    this.dayOfMonth,
    this.endDate,
    this.occurrences,
  });

  // فحص ما إذا كان التكرار ينتهي
  bool get hasEndCondition => endDate != null || occurrences != null;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'endDate': endDate?.toIso8601String(),
      'occurrences': occurrences,
    };
  }

  // إنشاء من خريطة
  factory EventRecurrence.fromMap(Map<String, dynamic> map) {
    return EventRecurrence(
      type: RecurrenceType.values.firstWhere((t) => t.name == map['type']),
      interval: map['interval'] ?? 1,
      daysOfWeek: List<int>.from(map['daysOfWeek'] ?? []),
      dayOfMonth: map['dayOfMonth'],
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      occurrences: map['occurrences'],
    );
  }
}

@HiveType(typeId: 67)
enum RecurrenceType {
  @HiveField(0)
  daily,      // يومي

  @HiveField(1)
  weekly,     // أسبوعي

  @HiveField(2)
  monthly,    // شهري

  @HiveField(3)
  yearly,     // سنوي
}

@HiveType(typeId: 68)
class EventReminder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  ReminderType type;

  @HiveField(2)
  int minutesBefore;

  @HiveField(3)
  String message;

  @HiveField(4)
  bool isEnabled;

  EventReminder({
    required this.id,
    this.type = ReminderType.notification,
    this.minutesBefore = 15,
    this.message = '',
    this.isEnabled = true,
  });

  // الحصول على وقت التذكير
  DateTime getReminderTime(DateTime eventTime) {
    return eventTime.subtract(Duration(minutes: minutesBefore));
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'minutesBefore': minutesBefore,
      'message': message,
      'isEnabled': isEnabled,
    };
  }

  // إنشاء من خريطة
  factory EventReminder.fromMap(Map<String, dynamic> map) {
    return EventReminder(
      id: map['id'],
      type: ReminderType.values.firstWhere((t) => t.name == map['type']),
      minutesBefore: map['minutesBefore'] ?? 15,
      message: map['message'] ?? '',
      isEnabled: map['isEnabled'] ?? true,
    );
  }
}

@HiveType(typeId: 69)
enum ReminderType {
  @HiveField(0)
  notification,   // إشعار

  @HiveField(1)
  email,          // بريد إلكتروني

  @HiveField(2)
  sms,            // رسالة نصية

  @HiveField(3)
  alarm,          // منبه
}

@HiveType(typeId: 70)
class CalendarSync extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  CalendarProvider provider;

  @HiveField(3)
  String calendarId;

  @HiveField(4)
  bool isEnabled;

  @HiveField(5)
  DateTime lastSync;

  @HiveField(6)
  SyncDirection direction;

  @HiveField(7)
  List<EventType> syncedTypes;

  @HiveField(8)
  Map<String, dynamic> settings;

  CalendarSync({
    required this.id,
    required this.name,
    required this.provider,
    required this.calendarId,
    this.isEnabled = true,
    required this.lastSync,
    this.direction = SyncDirection.bidirectional,
    this.syncedTypes = const [],
    this.settings = const {},
  });

  // تحديث وقت آخر مزامنة
  void updateLastSync() {
    lastSync = DateTime.now();
    save();
  }

  // فحص ما إذا كان نوع الحدث مزامن
  bool isSyncedType(EventType type) {
    return syncedTypes.contains(type);
  }

  // إضافة نوع حدث للمزامنة
  void addSyncedType(EventType type) {
    if (!syncedTypes.contains(type)) {
      final newTypes = List<EventType>.from(syncedTypes);
      newTypes.add(type);
      syncedTypes = newTypes;
      save();
    }
  }

  // إزالة نوع حدث من المزامنة
  void removeSyncedType(EventType type) {
    final newTypes = List<EventType>.from(syncedTypes);
    newTypes.remove(type);
    syncedTypes = newTypes;
    save();
  }
}

@HiveType(typeId: 71)
enum CalendarProvider {
  @HiveField(0)
  google,     // Google Calendar

  @HiveField(1)
  apple,      // Apple Calendar

  @HiveField(2)
  outlook,    // Microsoft Outlook

  @HiveField(3)
  exchange,   // Exchange

  @HiveField(4)
  caldav,     // CalDAV
}

@HiveType(typeId: 72)
enum SyncDirection {
  @HiveField(0)
  bidirectional,  // ثنائي الاتجاه

  @HiveField(1)
  import_only,    // استيراد فقط

  @HiveField(2)
  export_only,    // تصدير فقط
}