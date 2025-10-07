import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../smart_notifications/services/notification_service.dart';
import '../../smart_notifications/models/smart_notification.dart';
import '../models/calendar_models.dart';

/// خدمة التقويم الذكي المبسطة
class SmartCalendarService {
  factory SmartCalendarService() => _instance;
  SmartCalendarService._internal();
  static const String _eventsBoxName = 'calendar_events';
  static const String _syncBoxName = 'calendar_sync';
  static const String _calendarsBoxName = 'smart_calendars';

  // Hive boxes
  late Box<CalendarEvent> _eventsBox;
  late Box<CalendarSync> _syncBox;
  late Box<SmartCalendar> _calendarsBox;

  // خدمات خارجية
  final NotificationService _notificationService = NotificationService();

  // مؤقتات للمهام الدورية
  Timer? _reminderTimer;
  Timer? _syncTimer;

  static final SmartCalendarService _instance =
      SmartCalendarService._internal();

  /// تهيئة الخدمة
  Future<void> initialize() async {
    debugPrint('🎯 تهيئة خدمة التقويم الذكي...');

    try {
      // فتح قواعد البيانات
      _eventsBox = await Hive.openBox<CalendarEvent>(_eventsBoxName);
      _syncBox = await Hive.openBox<CalendarSync>(_syncBoxName);
      _calendarsBox = await Hive.openBox<SmartCalendar>(_calendarsBoxName);

      // تهيئة خدمة الإشعارات
      await _notificationService.initialize();

      // بدء المهام الدورية
      _startPeriodicTasks();

      debugPrint('✅ تم تهيئة خدمة التقويم الذكي بنجاح');
    } catch (e) {
      debugPrint('❌ فشل في تهيئة خدمة التقويم الذكي: $e');
      rethrow;
    }
  }

  // ================= Compatibility / convenience shims ================

  /// Return all calendars (empty list if none)
  List<SmartCalendar> getAllCalendars() {
    try {
      return _calendarsBox.values.toList();
    } catch (_) {
      return [];
    }
  }

  Future<SmartCalendar> createCalendar({
    required String name,
    String? description,
    required CalendarType type,
    required String color,
    CalendarSettings? settings,
  }) async {
    final now = DateTime.now();
    final id = '${now.millisecondsSinceEpoch}_${name.hashCode}';
    final calendar = SmartCalendar(
      id: id,
      name: name,
      description: description,
      type: type,
      color: color,
      settings: settings ?? const CalendarSettings(),
      createdAt: now,
      updatedAt: now,
    );
    await _calendarsBox.put(calendar.id, calendar);
    return calendar;
  }

  Future<void> updateCalendar(SmartCalendar calendar) async {
    await _calendarsBox.put(calendar.id, calendar);
  }

  Future<void> deleteCalendar(String calendarId) async {
    await _calendarsBox.delete(calendarId);
  }

  /// Return all events
  List<CalendarEvent> getAllEvents() => _eventsBox.values.toList();

  /// Alias expected by providers
  List<CalendarEvent> getEventsForDate(DateTime date) => getEventsByDate(date);

  List<CalendarEvent> getTodayEvents() => getEventsByDate(DateTime.now());

  List<CalendarEvent> getUpcomingEvents({int limit = 10}) {
    final upcoming = _eventsBox.values.where((e) => e.isUpcoming).toList()
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    if (limit <= 0) return upcoming;
    return upcoming.take(limit).toList();
  }

  List<CalendarEvent> getEventsForRange(DateTime start, DateTime end) =>
      getEventsByDateRange(start, end);

  List<CalendarEvent> getEventsForHabit(String habitId) {
    return _eventsBox.values.where((e) => e.habitId == habitId).toList();
  }

  Future<void> markEventCompleted(String eventId, bool completed) async {
    final event = _eventsBox.get(eventId);
    if (event == null) return;
    final updated = event.copyWith(
      isCompleted: completed,
      updatedAt: DateTime.now(),
    );
    await updateEvent(updated);
  }

  /// Suggest optimal times (placeholder/simple implementation)
  Future<List<SmartScheduleSuggestion>> suggestOptimalTimes({
    required Duration duration,
    DateTime? preferredDate,
    TimeOfDay? preferredTime,
    CalendarEventPriority priority = CalendarEventPriority.medium,
    List<String> constraints = const [],
  }) async {
    // Minimal implementation: return empty list for now.
    return <SmartScheduleSuggestion>[];
  }

  /// Simple analytics for a single date
  CalendarAnalytics? getAnalyticsForDate(DateTime date) {
    final events = getEventsByDate(date);
    if (events.isEmpty) return null;

    final total = events.length;
    final completed = events.where((e) => e.isCompleted).length;
    final missed = events.where((e) => e.isPast && !e.isCompleted).length;
    final totalTime = events.fold<Duration>(
      Duration.zero,
      (acc, e) => acc + e.duration,
    );

    final Map<CalendarEventType, int> typeStats = {};
    final Map<CalendarEventPriority, int> priorityStats = {};
    for (final e in events) {
      typeStats[e.type] = (typeStats[e.type] ?? 0) + 1;
      priorityStats[e.priority] = (priorityStats[e.priority] ?? 0) + 1;
    }

    final productivity = total > 0 ? (completed / total) : 0.0;

    final analytics = CalendarAnalytics(
      id: 'analytics_${date.toIso8601String()}',
      date: date,
      totalEvents: total,
      completedEvents: completed,
      missedEvents: missed,
      totalTimeSpent: totalTime,
      eventTypeStats: typeStats,
      priorityStats: priorityStats,
      productivityScore: productivity,
      busySlots: <TimeSlot>[],
      freeSlots: <TimeSlot>[],
    );

    return analytics;
  }

  List<CalendarAnalytics> getAnalyticsForRange(DateTime start, DateTime end) {
    final days = <CalendarAnalytics>[];
    DateTime cursor = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    while (!cursor.isAfter(endDay)) {
      final analytics = getAnalyticsForDate(cursor);
      if (analytics != null) days.add(analytics);
      cursor = cursor.add(const Duration(days: 1));
    }
    return days;
  }

  /// بدء المهام الدورية
  void _startPeriodicTasks() {
    // تحقق دوري من التذكيرات
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkReminders();
    });

    // مزامنة دورية
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      _performPeriodicSync();
    });
  }

  /// إنشاء حدث جديد
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    try {
      debugPrint('📅 إنشاء حدث جديد: ${event.title}');

      // حفظ الحدث
      await _eventsBox.put(event.id, event);

      // جدولة التذكير إذا كان مطلوباً
      if (event.reminder != null && event.reminder!.isEnabled) {
        await _scheduleReminder(event);
      }

      debugPrint('✅ تم إنشاء الحدث بنجاح');
      return event;
    } catch (e) {
      debugPrint('❌ فشل في إنشاء الحدث: $e');
      rethrow;
    }
  }

  /// تحديث حدث موجود
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    try {
      debugPrint('📝 تحديث الحدث: ${event.title}');

      final oldEvent = _eventsBox.get(event.id);

      // إلغاء التذكير القديم
      if (oldEvent?.reminder?.isEnabled ?? false) {
        await _cancelReminder(event.id);
      }

      // حفظ التحديث
      await _eventsBox.put(event.id, event);

      // جدولة التذكير الجديد
      if (event.reminder != null && event.reminder!.isEnabled) {
        await _scheduleReminder(event);
      }

      debugPrint('✅ تم تحديث الحدث بنجاح');
      return event;
    } catch (e) {
      debugPrint('❌ فشل في تحديث الحدث: $e');
      rethrow;
    }
  }

  /// حذف حدث
  Future<void> deleteEvent(String eventId) async {
    try {
      debugPrint('🗑️ حذف الحدث: $eventId');

      final event = _eventsBox.get(eventId);
      if (event == null) {
        debugPrint('⚠️ الحدث غير موجود');
        return;
      }

      // إلغاء التذكير
      if (event.reminder?.isEnabled ?? false) {
        await _cancelReminder(eventId);
      }

      // حذف الحدث
      await _eventsBox.delete(eventId);

      debugPrint('✅ تم حذف الحدث بنجاح');
    } catch (e) {
      debugPrint('❌ فشل في حذف الحدث: $e');
      rethrow;
    }
  }

  /// الحصول على الأحداث في فترة زمنية محددة
  List<CalendarEvent> getEventsByDateRange(DateTime start, DateTime end) {
    return _eventsBox.values
        .where(
          (event) =>
              event.startDateTime.isBefore(end) &&
              event.endDateTime.isAfter(start),
        )
        .toList();
  }

  /// الحصول على أحداث يوم معين
  List<CalendarEvent> getEventsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getEventsByDateRange(startOfDay, endOfDay);
  }

  /// البحث في الأحداث
  List<CalendarEvent> searchEvents(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _eventsBox.values
        .where(
          (event) =>
              event.title.toLowerCase().contains(lowerQuery) ||
              (event.description?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              (event.location?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  /// جدولة تذكير للحدث
  Future<void> _scheduleReminder(CalendarEvent event) async {
    if (event.reminder == null || !event.reminder!.isEnabled) return;

    final reminderTime = event.startDateTime.subtract(
      event.reminder!.beforeEvent,
    );
    final now = DateTime.now();

    if (reminderTime.isAfter(now)) {
      try {
        final notification = SmartNotification(
          id: event.id,
          title: 'تذكير: ${event.title}',
          body: _getReminderBody(event),
          scheduledTime: reminderTime,
          type: NotificationType.reminder,
          createdAt: now,
        );

        await _notificationService.scheduleNotification(notification);
        debugPrint('Reminder scheduled for event: ${event.title}');
      } catch (e) {
        debugPrint('Failed to schedule reminder: $e');
      }
    }
  }

  /// إلغاء تذكير الحدث
  Future<void> _cancelReminder(String eventId) async {
    await _notificationService.cancelNotification(eventId);
    debugPrint('Reminder canceled for event: $eventId');
  }

  /// التحقق من التذكيرات المطلوبة
  Future<void> _checkReminders() async {
    final now = DateTime.now();

    for (final event in _eventsBox.values) {
      if (event.reminder != null && event.reminder!.isEnabled) {
        final reminderTime = event.startDateTime.subtract(
          event.reminder!.beforeEvent,
        );

        if (now.isAfter(reminderTime) &&
            now.isBefore(reminderTime.add(const Duration(minutes: 1)))) {
          await _showReminder(event);
        }
      }
    }
  }

  /// عرض التذكير
  Future<void> _showReminder(CalendarEvent event) async {
    try {
      final notification = SmartNotification(
        id: '${event.id}_immediate',
        title: 'تذكير: ${event.title}',
        body: _getReminderBody(event),
        scheduledTime: DateTime.now(),
        type: NotificationType.reminder,
        createdAt: DateTime.now(),
      );

      await _notificationService.scheduleNotification(notification);
      debugPrint('Immediate reminder shown for event: ${event.title}');
    } catch (e) {
      debugPrint('Failed to show immediate reminder: $e');
    }
  }

  /// الحصول على نص التذكير
  String _getReminderBody(CalendarEvent event) {
    final timeStr =
        '${event.startDateTime.hour.toString().padLeft(2, '0')}:${event.startDateTime.minute.toString().padLeft(2, '0')}';
    final locationText = (event.location?.isNotEmpty ?? false)
        ? ' في ${event.location}'
        : '';
    return 'يبدأ الحدث في $timeStr$locationText';
  }

  /// إضافة إعدادات المزامنة
  Future<CalendarSync> addSyncSettings({
    required String calendarId,
    required SyncProvider provider,
    required Map<String, String> credentials,
    SyncSettings? settings,
  }) async {
    final sync = CalendarSync(
      id: '${calendarId}_${provider.name}',
      calendarId: calendarId,
      provider: provider,
      credentials: credentials,
      settings: settings ?? const SyncSettings(),
      status: SyncStatus.idle,
    );

    await _syncBox.put(sync.id, sync);
    debugPrint('Sync settings added for calendar: $calendarId');
    return sync;
  }

  /// تنفيذ المزامنة التلقائية
  Future<void> _performPeriodicSync() async {
    final activeSyncs = _syncBox.values
        .where(
          (sync) => sync.settings.autoSync && sync.status != SyncStatus.syncing,
        )
        .toList();

    for (final sync in activeSyncs) {
      await _performSync(sync);
    }
  }

  /// تنفيذ مزامنة واحدة
  Future<void> _performSync(CalendarSync sync) async {
    try {
      final updatedSync = sync.copyWith(status: SyncStatus.syncing);
      await _syncBox.put(sync.id, updatedSync);

      // محاكاة المزامنة
      await Future.delayed(const Duration(seconds: 2));

      final finalSync = updatedSync.copyWith(
        status: SyncStatus.success,
      );
      await _syncBox.put(sync.id, finalSync);

      debugPrint('Sync completed successfully for: ${sync.provider}');
    } catch (e) {
      final errorSync = sync.copyWith(
        status: SyncStatus.error,
        lastError: e.toString(),
      );
      await _syncBox.put(sync.id, errorSync);

      debugPrint('Sync failed for ${sync.provider}: $e');
    }
  }

  /// إنهاء الخدمة
  Future<void> dispose() async {
    _reminderTimer?.cancel();
    _syncTimer?.cancel();
    debugPrint('Smart Calendar Service disposed');
  }
}
