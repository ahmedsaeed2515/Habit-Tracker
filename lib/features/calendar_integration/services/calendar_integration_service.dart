import '../models/calendar_event.dart';
import 'package:flutter/foundation.dart';
import '../../../core/database/database_helper.dart';
import '../../habits/models/habit.dart';

class CalendarIntegrationService {
  static final CalendarIntegrationService _instance = CalendarIntegrationService._internal();
  factory CalendarIntegrationService() => _instance;
  CalendarIntegrationService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // الحصول على جميع الأحداث
  Future<List<CalendarEvent>> getAllEvents() async {
    try {
      final box = await _databaseHelper.openBoxDynamic('calendar_events');
      final events = <CalendarEvent>[];
      
      for (var key in box.keys) {
        final eventData = box.get(key);
        if (eventData != null) {
          // إضافة منطق تحويل البيانات هنا
          // events.add(CalendarEvent.fromData(eventData));
        }
      }
      
      return events;
    } catch (e) {
      debugPrint('خطأ في الحصول على الأحداث: $e');
      return [];
    }
  }

  // الحصول على الأحداث لتاريخ محدد
  Future<List<CalendarEvent>> getEventsForDate(DateTime date) async {
    try {
      final allEvents = await getAllEvents();
      final eventsForDate = <CalendarEvent>[];
      
      // الأحداث العادية
      final regularEvents = allEvents.where((event) => event.isOnDate(date)).toList();
      eventsForDate.addAll(regularEvents);
      
      // الأحداث المتكررة
      for (final event in allEvents.where((e) => e.isRecurring)) {
        final recurringEvents = event.getRecurringEvents(date.add(const Duration(days: 1)));
        final eventOnDate = recurringEvents.where((e) => e.isOnDate(date));
        eventsForDate.addAll(eventOnDate);
      }
      
      // ترتيب الأحداث حسب الوقت
      eventsForDate.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      return eventsForDate;
    } catch (e) {
      debugPrint('خطأ في الحصول على أحداث التاريخ: $e');
      return [];
    }
  }

  // الحصول على الأحداث لفترة زمنية
  Future<List<CalendarEvent>> getEventsForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final eventsInRange = <CalendarEvent>[];
      
      var currentDate = startDate;
      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
        final dailyEvents = await getEventsForDate(currentDate);
        eventsInRange.addAll(dailyEvents);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      
      // إزالة التكرارات
      final uniqueEvents = <String, CalendarEvent>{};
      for (final event in eventsInRange) {
        uniqueEvents[event.id] = event;
      }
      
      return uniqueEvents.values.toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      debugPrint('خطأ في الحصول على أحداث الفترة: $e');
      return [];
    }
  }

  // إنشاء حدث جديد
  Future<bool> createEvent(CalendarEvent event) async {
    try {
      final box = await _databaseHelper.openBox<CalendarEvent>('calendar_events');
      await box.put(event.id, event);
      
      // إنشاء تذكيرات إذا كانت مفعلة
      if (event.reminders.isNotEmpty) {
        await _scheduleReminders(event);
      }
      
      // مزامنة مع التقويمات الخارجية
      await _syncWithExternalCalendars(event);
      
      return true;
    } catch (e) {
      debugPrint('خطأ في إنشاء الحدث: $e');
      return false;
    }
  }

  // تحديث حدث موجود
  Future<bool> updateEvent(CalendarEvent event) async {
    try {
      final box = await _databaseHelper.openBox<CalendarEvent>('calendar_events');
      await box.put(event.id, event);
      
      // تحديث التذكيرات
      await _cancelReminders(event.id);
      if (event.reminders.isNotEmpty) {
        await _scheduleReminders(event);
      }
      
      // مزامنة التحديث مع التقويمات الخارجية
      await _syncWithExternalCalendars(event);
      
      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث الحدث: $e');
      return false;
    }
  }

  // حذف حدث
  Future<bool> deleteEvent(String eventId) async {
    try {
      final box = await _databaseHelper.openBox<CalendarEvent>('calendar_events');
      await box.delete(eventId);
      
      // إلغاء التذكيرات
      await _cancelReminders(eventId);
      
      return true;
    } catch (e) {
      debugPrint('خطأ في حذف الحدث: $e');
      return false;
    }
  }

  // إنشاء أحداث من العادات
  Future<List<CalendarEvent>> createEventsFromHabits(List<Habit> habits) async {
    try {
      final events = <CalendarEvent>[];
      
      for (final habit in habits) {
        if (habit.isActive) {
          final event = CalendarEvent(
            id: 'habit_${habit.id}_${DateTime.now().millisecondsSinceEpoch}',
            title: habit.name,
            description: habit.description,
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(minutes: 30)), // مدة افتراضية
            type: EventType.habit,
            habitId: habit.id,
            color: '#2196F3', // لون أزرق افتراضي
            reminders: [
              EventReminder(
                id: 'habit_reminder_${habit.id}',
                type: ReminderType.notification,
                minutesBefore: 15, // تذكير افتراضي
                message: 'حان وقت ${habit.name}',
              ),
            ],
          );
          
          events.add(event);
          await createEvent(event);
        }
      }
      
      return events;
    } catch (e) {
      debugPrint('خطأ في إنشاء أحداث العادات: $e');
      return [];
    }
  }

  // الحصول على الأحداث المتعلقة بعادة معينة
  Future<List<CalendarEvent>> getHabitEvents(String habitId) async {
    try {
      final allEvents = await getAllEvents();
      return allEvents.where((event) => event.habitId == habitId).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على أحداث العادة: $e');
      return [];
    }
  }

  // تحديث حالة الحدث (مكتمل/فائت)
  Future<bool> updateEventStatus(String eventId, EventStatus status) async {
    try {
      final box = await _databaseHelper.openBox<CalendarEvent>('calendar_events');
      final event = box.get(eventId);
      
      if (event != null) {
        event.updateStatus(status);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('خطأ في تحديث حالة الحدث: $e');
      return false;
    }
  }

  // الحصول على إحصائيات الأحداث
  Future<Map<String, dynamic>> getEventStatistics(DateTime startDate, DateTime endDate) async {
    try {
      final events = await getEventsForDateRange(startDate, endDate);
      
      final completed = events.where((e) => e.status == EventStatus.completed).length;
      final missed = events.where((e) => e.status == EventStatus.missed).length;
      final cancelled = events.where((e) => e.status == EventStatus.cancelled).length;
      final total = events.length;
      
      final completionRate = total > 0 ? (completed / total * 100).round() : 0;
      
      return {
        'total': total,
        'completed': completed,
        'missed': missed,
        'cancelled': cancelled,
        'completionRate': completionRate,
        'eventsByType': _getEventsByType(events),
        'eventsByDay': _getEventsByDay(events),
      };
    } catch (e) {
      debugPrint('خطأ في الحصول على إحصائيات الأحداث: $e');
      return {};
    }
  }

  // البحث في الأحداث
  Future<List<CalendarEvent>> searchEvents(String query) async {
    try {
      final allEvents = await getAllEvents();
      final lowerQuery = query.toLowerCase();
      
      return allEvents.where((event) {
        return event.title.toLowerCase().contains(lowerQuery) ||
               event.description.toLowerCase().contains(lowerQuery) ||
               (event.location?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في البحث عن الأحداث: $e');
      return [];
    }
  }

  // تحديد الأحداث التي تحتاج تذكير
  Future<List<CalendarEvent>> getEventsNeedingReminders() async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      
      final upcomingEvents = await getEventsForDateRange(now, tomorrow);
      
      return upcomingEvents.where((event) {
        return event.reminders.any((reminder) {
          final reminderTime = reminder.getReminderTime(event.startTime);
          return reminder.isEnabled && reminderTime.isAfter(now) && 
                 reminderTime.isBefore(now.add(const Duration(minutes: 5)));
        });
      }).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على الأحداث التي تحتاج تذكير: $e');
      return [];
    }
  }

  // مزامنة مع التقويمات الخارجية
  Future<void> _syncWithExternalCalendars(CalendarEvent event) async {
    try {
      final syncSettings = await _getSyncSettings();
      
      for (final sync in syncSettings) {
        if (sync.isEnabled && sync.isSyncedType(event.type)) {
          // محاكاة مزامنة مع التقويم الخارجي
          debugPrint('مزامنة الحدث ${event.title} مع ${sync.name}');
          
          // في التطبيق الحقيقي، ستتم المزامنة مع API التقويم المختار
          await Future.delayed(const Duration(milliseconds: 500));
          sync.updateLastSync();
        }
      }
    } catch (e) {
      debugPrint('خطأ في المزامنة مع التقويمات الخارجية: $e');
    }
  }

  // الحصول على إعدادات المزامنة
  Future<List<CalendarSync>> _getSyncSettings() async {
    try {
      final box = await _databaseHelper.openBox<CalendarSync>('calendar_sync');
      return box.values.toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على إعدادات المزامنة: $e');
      return [];
    }
  }

  // جدولة التذكيرات
  Future<void> _scheduleReminders(CalendarEvent event) async {
    try {
      for (final reminder in event.reminders) {
        if (reminder.isEnabled) {
          final reminderTime = reminder.getReminderTime(event.startTime);
          
          // في التطبيق الحقيقي، ستتم جدولة الإشعار باستخدام flutter_local_notifications
          debugPrint('تم جدولة تذكير للحدث ${event.title} في $reminderTime');
        }
      }
    } catch (e) {
      debugPrint('خطأ في جدولة التذكيرات: $e');
    }
  }

  // إلغاء التذكيرات
  Future<void> _cancelReminders(String eventId) async {
    try {
      // في التطبيق الحقيقي، ستتم إلغاء الإشعارات المجدولة
      debugPrint('تم إلغاء تذكيرات الحدث $eventId');
    } catch (e) {
      debugPrint('خطأ في إلغاء التذكيرات: $e');
    }
  }

  // تجميع الأحداث حسب النوع
  Map<String, int> _getEventsByType(List<CalendarEvent> events) {
    final eventsByType = <String, int>{};
    
    for (final event in events) {
      final typeName = event.type.name;
      eventsByType[typeName] = (eventsByType[typeName] ?? 0) + 1;
    }
    
    return eventsByType;
  }

  // تجميع الأحداث حسب اليوم
  Map<String, int> _getEventsByDay(List<CalendarEvent> events) {
    final eventsByDay = <String, int>{};
    
    for (final event in events) {
      final dayKey = '${event.startTime.year}-${event.startTime.month}-${event.startTime.day}';
      eventsByDay[dayKey] = (eventsByDay[dayKey] ?? 0) + 1;
    }
    
    return eventsByDay;
  }

  // إنشاء مزامنة تقويم جديدة
  Future<bool> createCalendarSync(CalendarSync sync) async {
    try {
      final box = await _databaseHelper.openBox<CalendarSync>('calendar_sync');
      await box.put(sync.id, sync);
      return true;
    } catch (e) {
      debugPrint('خطأ في إنشاء مزامنة التقويم: $e');
      return false;
    }
  }

  // تحديث مزامنة التقويم
  Future<bool> updateCalendarSync(CalendarSync sync) async {
    try {
      final box = await _databaseHelper.openBox<CalendarSync>('calendar_sync');
      await box.put(sync.id, sync);
      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث مزامنة التقويم: $e');
      return false;
    }
  }

  // حذف مزامنة التقويم
  Future<bool> deleteCalendarSync(String syncId) async {
    try {
      final box = await _databaseHelper.openBox<CalendarSync>('calendar_sync');
      await box.delete(syncId);
      return true;
    } catch (e) {
      debugPrint('خطأ في حذف مزامنة التقويم: $e');
      return false;
    }
  }

  // مزامنة جميع التقويمات
  Future<bool> syncAllCalendars() async {
    try {
      final syncSettings = await _getSyncSettings();
      
      for (final sync in syncSettings.where((s) => s.isEnabled)) {
        await _performSync(sync);
      }
      
      return true;
    } catch (e) {
      debugPrint('خطأ في مزامنة جميع التقويمات: $e');
      return false;
    }
  }

  // تنفيذ المزامنة لتقويم واحد
  Future<void> _performSync(CalendarSync sync) async {
    try {
      // محاكاة المزامنة مع التقويم الخارجي
      debugPrint('بدء مزامنة ${sync.name}...');
      
      // في التطبيق الحقيقي، ستتم المزامنة الفعلية مع API التقويم
      await Future.delayed(const Duration(seconds: 2));
      
      sync.updateLastSync();
      debugPrint('تمت مزامنة ${sync.name} بنجاح');
    } catch (e) {
      debugPrint('خطأ في مزامنة ${sync.name}: $e');
    }
  }

  // الحصول على أحداث اليوم
  Future<List<CalendarEvent>> getTodayEvents() async {
    return await getEventsForDate(DateTime.now());
  }

  // الحصول على أحداث الأسبوع الحالي
  Future<List<CalendarEvent>> getThisWeekEvents() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return await getEventsForDateRange(startOfWeek, endOfWeek);
  }

  // الحصول على أحداث الشهر الحالي
  Future<List<CalendarEvent>> getThisMonthEvents() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return await getEventsForDateRange(startOfMonth, endOfMonth);
  }
}
