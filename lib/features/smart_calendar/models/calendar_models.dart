import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'calendar_models.g.dart';

/// نماذج التقويم الذكي
/// TypeIds: 194-230

/// حدث في التقويم
@HiveType(typeId: 194)
class CalendarEvent {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime startDateTime;

  @HiveField(4)
  final DateTime endDateTime;

  @HiveField(5)
  final CalendarEventType type;

  @HiveField(6)
  final String? habitId; // ربط بالعادة

  @HiveField(7)
  final CalendarEventPriority priority;

  @HiveField(8)
  final String? location;

  @HiveField(9)
  final List<String> participants;

  @HiveField(10)
  final EventReminder? reminder;

  @HiveField(11)
  final bool isCompleted;

  @HiveField(12)
  final Map<String, dynamic> metadata;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    this.habitId,
    required this.priority,
    this.location,
    this.participants = const [],
    this.reminder,
    this.isCompleted = false,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    CalendarEventType? type,
    String? habitId,
    CalendarEventPriority? priority,
    String? location,
    List<String>? participants,
    EventReminder? reminder,
    bool? isCompleted,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      type: type ?? this.type,
      habitId: habitId ?? this.habitId,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      participants: participants ?? this.participants,
      reminder: reminder ?? this.reminder,
      isCompleted: isCompleted ?? this.isCompleted,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => endDateTime.difference(startDateTime);
  
  bool get isToday {
    final now = DateTime.now();
    return startDateTime.year == now.year &&
           startDateTime.month == now.month &&
           startDateTime.day == now.day;
  }

  bool get isUpcoming => startDateTime.isAfter(DateTime.now());
  
  bool get isPast => endDateTime.isBefore(DateTime.now());
  
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(startDateTime) && now.isBefore(endDateTime);
  }
}

/// نوع الحدث
@HiveType(typeId: 195)
enum CalendarEventType {
  @HiveField(0)
  habit,           // مرتبط بعادة

  @HiveField(1)
  reminder,        // تذكير

  @HiveField(2)
  appointment,     // موعد

  @HiveField(3)
  deadline,        // موعد نهائي

  @HiveField(4)
  meeting,         // اجتماع

  @HiveField(5)
  workout,         // تمرين

  @HiveField(6)
  meal,            // وجبة

  @HiveField(7)
  medication,      // دواء

  @HiveField(8)
  social,          // اجتماعي

  @HiveField(9)
  work,            // عمل

  @HiveField(10)
  personal,        // شخصي

  @HiveField(11)
  entertainment,   // ترفيه

  @HiveField(12)
  travel,          // سفر

  @HiveField(13)
  health,          // صحة

  @HiveField(14)
  education,       // تعليم

  @HiveField(15)
  other,           // آخر
}

/// أولوية الحدث
@HiveType(typeId: 196)
enum CalendarEventPriority {
  @HiveField(0)
  low,      // منخفضة

  @HiveField(1)
  medium,   // متوسطة

  @HiveField(2)
  high,     // عالية

  @HiveField(3)
  critical, // حرجة
}

/// تذكير الحدث
@HiveType(typeId: 197)
class EventReminder {
  @HiveField(0)
  final Duration beforeEvent; // كم قبل الحدث

  @HiveField(1)
  final bool isEnabled;

  @HiveField(2)
  final ReminderType type;

  @HiveField(3)
  final String? customMessage;

  @HiveField(4)
  final List<ReminderMethod> methods;

  const EventReminder({
    required this.beforeEvent,
    this.isEnabled = true,
    required this.type,
    this.customMessage,
    this.methods = const [ReminderMethod.notification],
  });

  EventReminder copyWith({
    Duration? beforeEvent,
    bool? isEnabled,
    ReminderType? type,
    String? customMessage,
    List<ReminderMethod>? methods,
  }) {
    return EventReminder(
      beforeEvent: beforeEvent ?? this.beforeEvent,
      isEnabled: isEnabled ?? this.isEnabled,
      type: type ?? this.type,
      customMessage: customMessage ?? this.customMessage,
      methods: methods ?? this.methods,
    );
  }
}

/// نوع التذكير
@HiveType(typeId: 198)
enum ReminderType {
  @HiveField(0)
  simple,        // بسيط

  @HiveField(1)
  detailed,      // مفصل

  @HiveField(2)
  motivational,  // تحفيزي

  @HiveField(3)
  gentle,        // لطيف

  @HiveField(4)
  urgent,        // عاجل
}

/// طريقة التذكير
@HiveType(typeId: 199)
enum ReminderMethod {
  @HiveField(0)
  notification,  // إشعار

  @HiveField(1)
  email,         // بريد إلكتروني

  @HiveField(2)
  sound,         // صوت

  @HiveField(3)
  vibration,     // اهتزاز

  @HiveField(4)
  popup,         // نافذة منبثقة
}

/// تقويم ذكي
@HiveType(typeId: 200)
class SmartCalendar {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final CalendarType type;

  @HiveField(4)
  final String color; // لون التقويم

  @HiveField(5)
  final bool isVisible;

  @HiveField(6)
  final bool isDefault;

  @HiveField(7)
  final CalendarSettings settings;

  @HiveField(8)
  final Map<String, dynamic> syncSettings;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const SmartCalendar({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.color,
    this.isVisible = true,
    this.isDefault = false,
    required this.settings,
    this.syncSettings = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  SmartCalendar copyWith({
    String? id,
    String? name,
    String? description,
    CalendarType? type,
    String? color,
    bool? isVisible,
    bool? isDefault,
    CalendarSettings? settings,
    Map<String, dynamic>? syncSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SmartCalendar(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
      isDefault: isDefault ?? this.isDefault,
      settings: settings ?? this.settings,
      syncSettings: syncSettings ?? this.syncSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// نوع التقويم
@HiveType(typeId: 201)
enum CalendarType {
  @HiveField(0)
  personal,    // شخصي

  @HiveField(1)
  work,        // عمل

  @HiveField(2)
  habits,      // عادات

  @HiveField(3)
  health,      // صحة

  @HiveField(4)
  fitness,     // لياقة

  @HiveField(5)
  social,      // اجتماعي

  @HiveField(6)
  education,   // تعليم

  @HiveField(7)
  family,      // عائلة

  @HiveField(8)
  travel,      // سفر

  @HiveField(9)
  projects,    // مشاريع
}

/// إعدادات التقويم
@HiveType(typeId: 202)
class CalendarSettings {
  @HiveField(0)
  final bool autoCreateFromHabits; // إنشاء أحداث تلقائياً من العادات

  @HiveField(1)
  final bool smartScheduling; // جدولة ذكية

  @HiveField(2)
  final bool conflictDetection; // كشف التعارض

  @HiveField(3)
  final Duration defaultEventDuration; // مدة الحدث الافتراضية

  @HiveField(4)
  final EventReminder? defaultReminder; // التذكير الافتراضي

  @HiveField(5)
  final CalendarEventPriority defaultPriority; // الأولوية الافتراضية

  @HiveField(6)
  final WorkingHours? workingHours; // ساعات العمل

  @HiveField(7)
  final Map<String, dynamic> preferences;

  const CalendarSettings({
    this.autoCreateFromHabits = true,
    this.smartScheduling = true,
    this.conflictDetection = true,
    this.defaultEventDuration = const Duration(hours: 1),
    this.defaultReminder,
    this.defaultPriority = CalendarEventPriority.medium,
    this.workingHours,
    this.preferences = const {},
  });

  CalendarSettings copyWith({
    bool? autoCreateFromHabits,
    bool? smartScheduling,
    bool? conflictDetection,
    Duration? defaultEventDuration,
    EventReminder? defaultReminder,
    CalendarEventPriority? defaultPriority,
    WorkingHours? workingHours,
    Map<String, dynamic>? preferences,
  }) {
    return CalendarSettings(
      autoCreateFromHabits: autoCreateFromHabits ?? this.autoCreateFromHabits,
      smartScheduling: smartScheduling ?? this.smartScheduling,
      conflictDetection: conflictDetection ?? this.conflictDetection,
      defaultEventDuration: defaultEventDuration ?? this.defaultEventDuration,
      defaultReminder: defaultReminder ?? this.defaultReminder,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      workingHours: workingHours ?? this.workingHours,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// ساعات العمل
@HiveType(typeId: 203)
class WorkingHours {
  @HiveField(0)
  final TimeOfDay startTime;

  @HiveField(1)
  final TimeOfDay endTime;

  @HiveField(2)
  final List<int> workingDays; // 1-7 (الاثنين - الأحد)

  @HiveField(3)
  final List<BreakTime> breaks; // فترات الراحة

  const WorkingHours({
    required this.startTime,
    required this.endTime,
    required this.workingDays,
    this.breaks = const [],
  });

  WorkingHours copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<int>? workingDays,
    List<BreakTime>? breaks,
  }) {
    return WorkingHours(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workingDays: workingDays ?? this.workingDays,
      breaks: breaks ?? this.breaks,
    );
  }

  bool isWorkingTime(DateTime dateTime) {
    final weekday = dateTime.weekday;
    if (!workingDays.contains(weekday)) return false;

    final time = TimeOfDay.fromDateTime(dateTime);
    final timeInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = endTime.hour * 60 + endTime.minute;

    if (timeInMinutes < startInMinutes || timeInMinutes > endInMinutes) {
      return false;
    }

    // فحص فترات الراحة
    for (final breakTime in breaks) {
      if (breakTime.isInBreak(time)) return false;
    }

    return true;
  }
}

/// فترة راحة
@HiveType(typeId: 204)
class BreakTime {
  @HiveField(0)
  final TimeOfDay startTime;

  @HiveField(1)
  final TimeOfDay endTime;

  @HiveField(2)
  final String name; // اسم فترة الراحة

  const BreakTime({
    required this.startTime,
    required this.endTime,
    required this.name,
  });

  bool isInBreak(TimeOfDay time) {
    final timeInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = endTime.hour * 60 + endTime.minute;

    return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
  }
}

/// عرض التقويم
@HiveType(typeId: 205)
class CalendarView {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final CalendarViewType type;

  @HiveField(2)
  final DateTime currentDate;

  @HiveField(3)
  final List<String> visibleCalendars; // التقاويم المرئية

  @HiveField(4)
  final Map<CalendarEventType, bool> visibleEventTypes; // أنواع الأحداث المرئية

  @HiveField(5)
  final CalendarViewSettings settings;

  const CalendarView({
    required this.id,
    required this.type,
    required this.currentDate,
    required this.visibleCalendars,
    required this.visibleEventTypes,
    required this.settings,
  });

  CalendarView copyWith({
    String? id,
    CalendarViewType? type,
    DateTime? currentDate,
    List<String>? visibleCalendars,
    Map<CalendarEventType, bool>? visibleEventTypes,
    CalendarViewSettings? settings,
  }) {
    return CalendarView(
      id: id ?? this.id,
      type: type ?? this.type,
      currentDate: currentDate ?? this.currentDate,
      visibleCalendars: visibleCalendars ?? this.visibleCalendars,
      visibleEventTypes: visibleEventTypes ?? this.visibleEventTypes,
      settings: settings ?? this.settings,
    );
  }
}

/// نوع عرض التقويم
@HiveType(typeId: 206)
enum CalendarViewType {
  @HiveField(0)
  day,        // يومي

  @HiveField(1)
  week,       // أسبوعي

  @HiveField(2)
  month,      // شهري

  @HiveField(3)
  agenda,     // جدول أعمال

  @HiveField(4)
  timeline,   // خط زمني
}

/// إعدادات عرض التقويم
@HiveType(typeId: 207)
class CalendarViewSettings {
  @HiveField(0)
  final bool showWeekends;

  @HiveField(1)
  final bool show24HourFormat;

  @HiveField(2)
  final int firstDayOfWeek; // 1-7

  @HiveField(3)
  final bool showCompletedEvents;

  @HiveField(4)
  final bool groupEventsByType;

  @HiveField(5)
  final Map<String, dynamic> customizations;

  const CalendarViewSettings({
    this.showWeekends = true,
    this.show24HourFormat = true,
    this.firstDayOfWeek = 1, // الاثنين
    this.showCompletedEvents = true,
    this.groupEventsByType = false,
    this.customizations = const {},
  });

  CalendarViewSettings copyWith({
    bool? showWeekends,
    bool? show24HourFormat,
    int? firstDayOfWeek,
    bool? showCompletedEvents,
    bool? groupEventsByType,
    Map<String, dynamic>? customizations,
  }) {
    return CalendarViewSettings(
      showWeekends: showWeekends ?? this.showWeekends,
      show24HourFormat: show24HourFormat ?? this.show24HourFormat,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      showCompletedEvents: showCompletedEvents ?? this.showCompletedEvents,
      groupEventsByType: groupEventsByType ?? this.groupEventsByType,
      customizations: customizations ?? this.customizations,
    );
  }
}

/// تحليل التقويم الذكي
@HiveType(typeId: 208)
class CalendarAnalytics {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int totalEvents;

  @HiveField(3)
  final int completedEvents;

  @HiveField(4)
  final int missedEvents;

  @HiveField(5)
  final Duration totalTimeSpent;

  @HiveField(6)
  final Map<CalendarEventType, int> eventTypeStats;

  @HiveField(7)
  final Map<CalendarEventPriority, int> priorityStats;

  @HiveField(8)
  final double productivityScore; // نتيجة الإنتاجية

  @HiveField(9)
  final List<TimeSlot> busySlots; // الفترات المشغولة

  @HiveField(10)
  final List<TimeSlot> freeSlots; // الفترات الحرة

  const CalendarAnalytics({
    required this.id,
    required this.date,
    required this.totalEvents,
    required this.completedEvents,
    required this.missedEvents,
    required this.totalTimeSpent,
    required this.eventTypeStats,
    required this.priorityStats,
    required this.productivityScore,
    required this.busySlots,
    required this.freeSlots,
  });

  double get completionRate => 
      totalEvents > 0 ? (completedEvents / totalEvents) * 100 : 0.0;

  double get missRate => 
      totalEvents > 0 ? (missedEvents / totalEvents) * 100 : 0.0;
}

/// فترة زمنية
@HiveType(typeId: 209)
class TimeSlot {
  @HiveField(0)
  final DateTime startTime;

  @HiveField(1)
  final DateTime endTime;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final Map<String, dynamic> metadata;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.description,
    this.metadata = const {},
  });

  Duration get duration => endTime.difference(startTime);

  bool overlaps(TimeSlot other) {
    return startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime);
  }

  bool contains(DateTime dateTime) {
    return dateTime.isAfter(startTime) && dateTime.isBefore(endTime);
  }
}

/// اقتراح ذكي للجدولة
@HiveType(typeId: 210)
class SmartScheduleSuggestion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String eventId;

  @HiveField(2)
  final DateTime suggestedStartTime;

  @HiveField(3)
  final DateTime suggestedEndTime;

  @HiveField(4)
  final double confidenceScore; // 0.0 - 1.0

  @HiveField(5)
  final List<String> reasons; // أسباب الاقتراح

  @HiveField(6)
  final SuggestionType type;

  @HiveField(7)
  final Map<String, dynamic> context;

  @HiveField(8)
  final DateTime createdAt;

  const SmartScheduleSuggestion({
    required this.id,
    required this.eventId,
    required this.suggestedStartTime,
    required this.suggestedEndTime,
    required this.confidenceScore,
    required this.reasons,
    required this.type,
    this.context = const {},
    required this.createdAt,
  });

  Duration get suggestedDuration => 
      suggestedEndTime.difference(suggestedStartTime);
}

/// نوع الاقتراح
@HiveType(typeId: 211)
enum SuggestionType {
  @HiveField(0)
  optimal,      // الأمثل

  @HiveField(1)
  alternative,  // بديل

  @HiveField(2)
  fallback,     // احتياطي

  @HiveField(3)
  emergency,    // طوارئ
}

/// تضارب في التقويم
@HiveType(typeId: 212)
class CalendarConflict {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<String> conflictingEventIds;

  @HiveField(2)
  final ConflictType type;

  @HiveField(3)
  final ConflictSeverity severity;

  @HiveField(4)
  final DateTime detectedAt;

  @HiveField(5)
  final bool isResolved;

  @HiveField(6)
  final String? resolution; // كيف تم الحل

  @HiveField(7)
  final List<ConflictResolution> suggestedResolutions;

  const CalendarConflict({
    required this.id,
    required this.conflictingEventIds,
    required this.type,
    required this.severity,
    required this.detectedAt,
    this.isResolved = false,
    this.resolution,
    this.suggestedResolutions = const [],
  });

  CalendarConflict copyWith({
    String? id,
    List<String>? conflictingEventIds,
    ConflictType? type,
    ConflictSeverity? severity,
    DateTime? detectedAt,
    bool? isResolved,
    String? resolution,
    List<ConflictResolution>? suggestedResolutions,
  }) {
    return CalendarConflict(
      id: id ?? this.id,
      conflictingEventIds: conflictingEventIds ?? this.conflictingEventIds,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      detectedAt: detectedAt ?? this.detectedAt,
      isResolved: isResolved ?? this.isResolved,
      resolution: resolution ?? this.resolution,
      suggestedResolutions: suggestedResolutions ?? this.suggestedResolutions,
    );
  }
}

/// نوع التضارب
@HiveType(typeId: 213)
enum ConflictType {
  @HiveField(0)
  timeOverlap,        // تداخل زمني

  @HiveField(1)
  locationConflict,   // تضارب مكان

  @HiveField(2)
  resourceConflict,   // تضارب موارد

  @HiveField(3)
  priorityConflict,   // تضارب أولويات

  @HiveField(4)
  habitConflict,      // تضارب عادات
}

/// شدة التضارب
@HiveType(typeId: 214)
enum ConflictSeverity {
  @HiveField(0)
  low,        // منخفضة

  @HiveField(1)
  medium,     // متوسطة

  @HiveField(2)
  high,       // عالية

  @HiveField(3)
  critical,   // حرجة
}

/// حل التضارب
@HiveType(typeId: 215)
class ConflictResolution {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ResolutionType type;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final Map<String, dynamic> parameters;

  @HiveField(4)
  final double feasibilityScore; // 0.0 - 1.0

  const ConflictResolution({
    required this.id,
    required this.type,
    required this.description,
    this.parameters = const {},
    required this.feasibilityScore,
  });
}

/// نوع الحل
@HiveType(typeId: 216)
enum ResolutionType {
  @HiveField(0)
  reschedule,     // إعادة جدولة

  @HiveField(1)
  cancel,         // إلغاء

  @HiveField(2)
  delegate,       // تفويض

  @HiveField(3)
  merge,          // دمج

  @HiveField(4)
  split,          // تقسيم

  @HiveField(5)
  relocate,       // نقل مكان
}

/// مزامنة التقويم
@HiveType(typeId: 217)
class CalendarSync {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String calendarId;

  @HiveField(2)
  final SyncProvider provider;

  @HiveField(3)
  final Map<String, dynamic> credentials;

  @HiveField(4)
  final SyncSettings settings;

  @HiveField(5)
  final DateTime? lastSyncAt;

  @HiveField(6)
  final SyncStatus status;

  @HiveField(7)
  final String? lastError;

  const CalendarSync({
    required this.id,
    required this.calendarId,
    required this.provider,
    required this.credentials,
    required this.settings,
    this.lastSyncAt,
    required this.status,
    this.lastError,
  });

  CalendarSync copyWith({
    String? id,
    String? calendarId,
    SyncProvider? provider,
    Map<String, dynamic>? credentials,
    SyncSettings? settings,
    DateTime? lastSyncAt,
    SyncStatus? status,
    String? lastError,
  }) {
    return CalendarSync(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      provider: provider ?? this.provider,
      credentials: credentials ?? this.credentials,
      settings: settings ?? this.settings,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
    );
  }
}

/// مقدم المزامنة
@HiveType(typeId: 218)
enum SyncProvider {
  @HiveField(0)
  googleCalendar,   // تقويم جوجل

  @HiveField(1)
  outlookCalendar,  // تقويم أوتلوك

  @HiveField(2)
  appleCalendar,    // تقويم آبل

  @HiveField(3)
  exchangeCalendar, // تقويم إكستشينج

  @HiveField(4)
  caldav,           // CalDAV

  @HiveField(5)
  icalendar,        // iCalendar
}

/// إعدادات المزامنة
@HiveType(typeId: 219)
class SyncSettings {
  @HiveField(0)
  final bool autoSync;

  @HiveField(1)
  final Duration syncInterval;

  @HiveField(2)
  final SyncDirection direction;

  @HiveField(3)
  final bool syncCompleted;

  @HiveField(4)
  final bool syncDeleted;

  @HiveField(5)
  final List<CalendarEventType> excludeEventTypes;

  @HiveField(6)
  final Map<String, dynamic> filterRules;

  const SyncSettings({
    this.autoSync = true,
    this.syncInterval = const Duration(minutes: 15),
    this.direction = SyncDirection.bidirectional,
    this.syncCompleted = true,
    this.syncDeleted = false,
    this.excludeEventTypes = const [],
    this.filterRules = const {},
  });

  SyncSettings copyWith({
    bool? autoSync,
    Duration? syncInterval,
    SyncDirection? direction,
    bool? syncCompleted,
    bool? syncDeleted,
    List<CalendarEventType>? excludeEventTypes,
    Map<String, dynamic>? filterRules,
  }) {
    return SyncSettings(
      autoSync: autoSync ?? this.autoSync,
      syncInterval: syncInterval ?? this.syncInterval,
      direction: direction ?? this.direction,
      syncCompleted: syncCompleted ?? this.syncCompleted,
      syncDeleted: syncDeleted ?? this.syncDeleted,
      excludeEventTypes: excludeEventTypes ?? this.excludeEventTypes,
      filterRules: filterRules ?? this.filterRules,
    );
  }
}

/// اتجاه المزامنة
@HiveType(typeId: 220)
enum SyncDirection {
  @HiveField(0)
  upload,         // رفع فقط

  @HiveField(1)
  download,       // تحميل فقط

  @HiveField(2)
  bidirectional,  // ثنائي الاتجاه
}

/// حالة المزامنة
@HiveType(typeId: 221)
enum SyncStatus {
  @HiveField(0)
  idle,           // خامل

  @HiveField(1)
  syncing,        // يتم المزامنة

  @HiveField(2)
  success,        // نجح

  @HiveField(3)
  error,          // خطأ

  @HiveField(4)
  paused,         // متوقف

  @HiveField(5)
  disabled,       // معطل
}

/// نمط التقويم الذكي
@HiveType(typeId: 222)
class CalendarPattern {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final PatternType type;

  @HiveField(3)
  final Map<String, dynamic> rules;

  @HiveField(4)
  final List<String> eventIds; // الأحداث المطابقة للنمط

  @HiveField(5)
  final double confidence; // مدى الثقة في النمط

  @HiveField(6)
  final DateTime discoveredAt;

  @HiveField(7)
  final DateTime? lastSeenAt;

  const CalendarPattern({
    required this.id,
    required this.name,
    required this.type,
    required this.rules,
    required this.eventIds,
    required this.confidence,
    required this.discoveredAt,
    this.lastSeenAt,
  });

  CalendarPattern copyWith({
    String? id,
    String? name,
    PatternType? type,
    Map<String, dynamic>? rules,
    List<String>? eventIds,
    double? confidence,
    DateTime? discoveredAt,
    DateTime? lastSeenAt,
  }) {
    return CalendarPattern(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rules: rules ?? this.rules,
      eventIds: eventIds ?? this.eventIds,
      confidence: confidence ?? this.confidence,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

/// نوع النمط
@HiveType(typeId: 223)
enum PatternType {
  @HiveField(0)
  recurring,      // متكرر

  @HiveField(1)
  seasonal,       // موسمي

  @HiveField(2)
  behavioral,     // سلوكي

  @HiveField(3)
  temporal,       // زمني

  @HiveField(4)
  contextual,     // سياقي
}

// مساعد TimeOfDay للـ Hive
@HiveType(typeId: 224)
class HiveTimeOfDay {
  @HiveField(0)
  final int hour;

  @HiveField(1)
  final int minute;

  const HiveTimeOfDay({required this.hour, required this.minute});

  factory HiveTimeOfDay.fromTimeOfDay(TimeOfDay timeOfDay) {
    return HiveTimeOfDay(hour: timeOfDay.hour, minute: timeOfDay.minute);
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: hour, minute: minute);
  }
}

/// تمديدات للعمل مع TimeOfDay في Hive
extension TimeOfDayHive on TimeOfDay {
  HiveTimeOfDay toHive() => HiveTimeOfDay.fromTimeOfDay(this);
}