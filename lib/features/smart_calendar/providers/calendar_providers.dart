import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../smart_notifications/services/notification_service.dart';
import '../models/calendar_models.dart';
import '../services/smart_calendar_service.dart';

/// مقدمات خدمات التقويم الذكي

// مقدم خدمة الإشعارات
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// مقدم خدمة التقويم الذكي
final smartCalendarServiceProvider = Provider<SmartCalendarService>((ref) {
  // SmartCalendarService is a singleton and initializes its own
  // NotificationService internally, so we construct it without injection.
  return SmartCalendarService();
});

// ==================== مقدمات التقاويم ====================

/// مقدم حالة التقاويم
class CalendarsNotifier extends StateNotifier<AsyncValue<List<SmartCalendar>>> {

  CalendarsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadCalendars();
  }
  final SmartCalendarService _service;

  Future<void> _loadCalendars() async {
    try {
      final calendars = _service.getAllCalendars();
      state = AsyncValue.data(calendars);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCalendar({
    required String name,
    String? description,
    required CalendarType type,
    required String color,
    CalendarSettings? settings,
  }) async {
    try {
      await _service.createCalendar(
        name: name,
        description: description,
        type: type,
        color: color,
        settings: settings,
      );
      await _loadCalendars();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCalendar(SmartCalendar calendar) async {
    try {
      await _service.updateCalendar(calendar);
      await _loadCalendars();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCalendar(String calendarId) async {
    try {
      await _service.deleteCalendar(calendarId);
      await _loadCalendars();
    } catch (e) {
      rethrow;
    }
  }

  void refresh() => _loadCalendars();
}

final calendarsProvider =
    StateNotifierProvider<CalendarsNotifier, AsyncValue<List<SmartCalendar>>>((
      ref,
    ) {
      final service = ref.watch(smartCalendarServiceProvider);
      return CalendarsNotifier(service);
    });

/// مقدم التقويم الافتراضي
final defaultCalendarProvider = Provider<SmartCalendar?>((ref) {
  final calendarsAsync = ref.watch(calendarsProvider);
  return calendarsAsync.when(
    data: (calendars) =>
        calendars.where((c) => c.isDefault).toList().firstOrNull,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// مقدم التقاويم المرئية
final visibleCalendarsProvider = Provider<List<SmartCalendar>>((ref) {
  final calendarsAsync = ref.watch(calendarsProvider);
  return calendarsAsync.when(
    data: (calendars) => calendars.where((c) => c.isVisible).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ==================== مقدمات الأحداث ====================

/// مقدم حالة الأحداث
class EventsNotifier extends StateNotifier<AsyncValue<List<CalendarEvent>>> {

  EventsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadEvents();
  }
  final SmartCalendarService _service;

  Future<void> _loadEvents() async {
    try {
      final events = _service.getAllEvents();
      state = AsyncValue.data(events);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<CalendarEvent> createEvent({
    required String title,
    String? description,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required CalendarEventType type,
    String? habitId,
    CalendarEventPriority priority = CalendarEventPriority.medium,
    String? location,
    List<String> participants = const [],
    EventReminder? reminder,
    Map<String, dynamic> metadata = const {},
    String? calendarId,
  }) async {
    try {
      final now = DateTime.now();
      final event = CalendarEvent(
        id: 'event_${now.microsecondsSinceEpoch}',
        title: title,
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        type: type,
        habitId: habitId,
        priority: priority,
        location: location,
        participants: participants,
        reminder: reminder,
        metadata: {
          ...metadata,
          if (calendarId != null) 'calendarId': calendarId,
        },
        createdAt: now,
        updatedAt: now,
      );

      final createdEvent = await _service.createEvent(event);
      await _loadEvents();
      return createdEvent;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEvent(CalendarEvent event) async {
    try {
      await _service.updateEvent(event);
      await _loadEvents();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markEventCompleted(String eventId, bool completed) async {
    try {
      await _service.markEventCompleted(eventId, completed);
      await _loadEvents();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _service.deleteEvent(eventId);
      await _loadEvents();
    } catch (e) {
      rethrow;
    }
  }

  void refresh() => _loadEvents();
}

final eventsProvider =
    StateNotifierProvider<EventsNotifier, AsyncValue<List<CalendarEvent>>>((
      ref,
    ) {
      final service = ref.watch(smartCalendarServiceProvider);
      return EventsNotifier(service);
    });

/// مقدم أحداث تاريخ محدد
final eventsForDateProvider = Provider.family<List<CalendarEvent>, DateTime>((
  ref,
  date,
) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getEventsForDate(date);
});

/// مقدم أحداث اليوم
final todayEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getTodayEvents();
});

/// مقدم الأحداث القادمة
final upcomingEventsProvider = Provider.family<List<CalendarEvent>, int>((
  ref,
  limit,
) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getUpcomingEvents(limit: limit);
});

/// مقدم أحداث فترة زمنية
final eventsForRangeProvider =
    Provider.family<List<CalendarEvent>, DateTimeRange>((ref, range) {
      final service = ref.watch(smartCalendarServiceProvider);
      return service.getEventsForRange(range.start, range.end);
    });

/// مقدم أحداث عادة محددة
final eventsForHabitProvider = Provider.family<List<CalendarEvent>, String>((
  ref,
  habitId,
) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getEventsForHabit(habitId);
});

// ==================== مقدمات عرض التقويم ====================

/// مقدم حالة عرض التقويم
class CalendarViewNotifier extends StateNotifier<CalendarView> {
  CalendarViewNotifier()
    : super(
        CalendarView(
          id: 'main',
          type: CalendarViewType.month,
          currentDate: DateTime.now(),
          visibleCalendars: [],
          visibleEventTypes: {
            for (final type in CalendarEventType.values) type: true,
          },
          settings: const CalendarViewSettings(),
        ),
      );

  void setViewType(CalendarViewType type) {
    state = state.copyWith(type: type);
  }

  void setCurrentDate(DateTime date) {
    state = state.copyWith(currentDate: date);
  }

  void toggleCalendarVisibility(String calendarId) {
    final visibleCalendars = List<String>.from(state.visibleCalendars);
    if (visibleCalendars.contains(calendarId)) {
      visibleCalendars.remove(calendarId);
    } else {
      visibleCalendars.add(calendarId);
    }
    state = state.copyWith(visibleCalendars: visibleCalendars);
  }

  void toggleEventTypeVisibility(CalendarEventType type) {
    final visibleEventTypes = Map<CalendarEventType, bool>.from(
      state.visibleEventTypes,
    );
    visibleEventTypes[type] = !(visibleEventTypes[type] ?? true);
    state = state.copyWith(visibleEventTypes: visibleEventTypes);
  }

  void updateSettings(CalendarViewSettings settings) {
    state = state.copyWith(settings: settings);
  }

  void goToPreviousPeriod() {
    DateTime newDate;
    switch (state.type) {
      case CalendarViewType.day:
        newDate = state.currentDate.subtract(const Duration(days: 1));
        break;
      case CalendarViewType.week:
        newDate = state.currentDate.subtract(const Duration(days: 7));
        break;
      case CalendarViewType.month:
        newDate = DateTime(
          state.currentDate.year,
          state.currentDate.month - 1,
        );
        break;
      default:
        newDate = state.currentDate.subtract(const Duration(days: 1));
        break;
    }
    state = state.copyWith(currentDate: newDate);
  }

  void goToNextPeriod() {
    DateTime newDate;
    switch (state.type) {
      case CalendarViewType.day:
        newDate = state.currentDate.add(const Duration(days: 1));
        break;
      case CalendarViewType.week:
        newDate = state.currentDate.add(const Duration(days: 7));
        break;
      case CalendarViewType.month:
        newDate = DateTime(
          state.currentDate.year,
          state.currentDate.month + 1,
        );
        break;
      default:
        newDate = state.currentDate.add(const Duration(days: 1));
        break;
    }
    state = state.copyWith(currentDate: newDate);
  }

  void goToToday() {
    state = state.copyWith(currentDate: DateTime.now());
  }
}

final calendarViewProvider =
    StateNotifierProvider<CalendarViewNotifier, CalendarView>((ref) {
      return CalendarViewNotifier();
    });

/// مقدم أحداث العرض الحالي
final currentViewEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final view = ref.watch(calendarViewProvider);
  final service = ref.watch(smartCalendarServiceProvider);

  switch (view.type) {
    case CalendarViewType.day:
      return service.getEventsForDate(view.currentDate);
    case CalendarViewType.week:
      final startOfWeek = view.currentDate.subtract(
        Duration(days: view.currentDate.weekday - 1),
      );
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      return service.getEventsForRange(startOfWeek, endOfWeek);
    case CalendarViewType.month:
      final startOfMonth = DateTime(
        view.currentDate.year,
        view.currentDate.month,
      );
      final endOfMonth = DateTime(
        view.currentDate.year,
        view.currentDate.month + 1,
        0,
      );
      return service.getEventsForRange(startOfMonth, endOfMonth);
    default:
      return service.getTodayEvents();
  }
});

/// مقدم الأحداث المفلترة حسب الإعدادات
final filteredEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final events = ref.watch(currentViewEventsProvider);
  final view = ref.watch(calendarViewProvider);

  return events.where((event) {
    // فلترة حسب التقاويم المرئية
    final eventCalendarId = event.metadata['calendarId'] as String?;
    if (eventCalendarId != null && view.visibleCalendars.isNotEmpty) {
      if (!view.visibleCalendars.contains(eventCalendarId)) return false;
    }

    // فلترة حسب أنواع الأحداث المرئية
    if (!(view.visibleEventTypes[event.type] ?? true)) return false;

    // فلترة الأحداث المكتملة
    if (!view.settings.showCompletedEvents && event.isCompleted) return false;

    return true;
  }).toList();
});

// ==================== مقدمات الجدولة الذكية ====================

/// مقدم اقتراحات الجدولة
class ScheduleSuggestionsNotifier
    extends StateNotifier<AsyncValue<List<SmartScheduleSuggestion>>> {

  ScheduleSuggestionsNotifier(this._service) : super(const AsyncValue.data([]));
  final SmartCalendarService _service;

  Future<void> generateSuggestions({
    required Duration duration,
    DateTime? preferredDate,
    TimeOfDay? preferredTime,
    CalendarEventPriority priority = CalendarEventPriority.medium,
    List<String> constraints = const [],
  }) async {
    try {
      state = const AsyncValue.loading();
      final suggestions = await _service.suggestOptimalTimes(
        duration: duration,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        priority: priority,
        constraints: constraints,
      );
      state = AsyncValue.data(suggestions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clearSuggestions() {
    state = const AsyncValue.data([]);
  }
}

final scheduleSuggestionsProvider =
    StateNotifierProvider<
      ScheduleSuggestionsNotifier,
      AsyncValue<List<SmartScheduleSuggestion>>
    >((ref) {
      final service = ref.watch(smartCalendarServiceProvider);
      return ScheduleSuggestionsNotifier(service);
    });

// ==================== مقدمات التحليلات ====================

/// مقدم تحليلات اليوم
final dailyAnalyticsProvider = Provider.family<CalendarAnalytics?, DateTime>((
  ref,
  date,
) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getAnalyticsForDate(date);
});

/// مقدم تحليلات اليوم الحالي
final todayAnalyticsProvider = Provider<CalendarAnalytics?>((ref) {
  final service = ref.watch(smartCalendarServiceProvider);
  return service.getAnalyticsForDate(DateTime.now());
});

/// مقدم تحليلات فترة زمنية
final analyticsForRangeProvider =
    Provider.family<List<CalendarAnalytics>, DateTimeRange>((ref, range) {
      final service = ref.watch(smartCalendarServiceProvider);
      return service.getAnalyticsForRange(range.start, range.end);
    });

/// مقدم إحصائيات سريعة
final quickStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final todayEvents = ref.watch(todayEventsProvider);
  final upcomingEvents = ref.watch(upcomingEventsProvider(10));

  final completedToday = todayEvents.where((e) => e.isCompleted).length;
  final missedToday = todayEvents
      .where((e) => e.isPast && !e.isCompleted)
      .length;
  final upcomingToday = todayEvents.where((e) => e.isUpcoming).length;

  return {
    'todayTotal': todayEvents.length,
    'todayCompleted': completedToday,
    'todayMissed': missedToday,
    'todayUpcoming': upcomingToday,
    'upcomingCount': upcomingEvents.length,
    'completionRate': todayEvents.isEmpty
        ? 0.0
        : (completedToday / todayEvents.length) * 100,
  };
});

// ==================== مقدمات التضارب ====================

/// مقدم حالة التضارب
class ConflictsNotifier
    extends StateNotifier<AsyncValue<List<CalendarConflict>>> {
  ConflictsNotifier() : super(const AsyncValue.loading()) {
    _loadConflicts();
  }

  Future<void> _loadConflicts() async {
    try {
      // في التطبيق الفعلي، يمكن الحصول على التضارب من الخدمة
      final conflicts = <CalendarConflict>[]; // placeholder مؤقتاً
      state = AsyncValue.data(conflicts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> resolveConflict(
    String conflictId,
    ConflictResolution resolution,
  ) async {
    try {
      // تنفيذ حل التضارب
      await _loadConflicts();
    } catch (e) {
      rethrow;
    }
  }

  void refresh() => _loadConflicts();
}

final conflictsProvider =
    StateNotifierProvider<
      ConflictsNotifier,
      AsyncValue<List<CalendarConflict>>
    >((ref) {
      return ConflictsNotifier();
    });

/// مقدم التضارب النشط
final activeConflictsProvider = Provider<List<CalendarConflict>>((ref) {
  final conflictsAsync = ref.watch(conflictsProvider);
  return conflictsAsync.when(
    data: (conflicts) => conflicts.where((c) => !c.isResolved).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ==================== مقدمات المزامنة ====================

/// مقدم حالة المزامنة
class SyncStatusNotifier extends StateNotifier<Map<String, SyncStatus>> {
  SyncStatusNotifier() : super({});

  void updateSyncStatus(String calendarId, SyncStatus status) {
    state = {...state, calendarId: status};
  }

  Future<void> performManualSync(String calendarId) async {
    try {
      updateSyncStatus(calendarId, SyncStatus.syncing);
      // تنفيذ المزامنة - placeholder مؤقتاً
      await Future.delayed(const Duration(seconds: 2));
      updateSyncStatus(calendarId, SyncStatus.success);
    } catch (e) {
      updateSyncStatus(calendarId, SyncStatus.error);
      rethrow;
    }
  }
}

final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, Map<String, SyncStatus>>((ref) {
      return SyncStatusNotifier();
    });

// ==================== مقدمات التحكم ====================

/// مقدم حالة التحميل العامة
final calendarLoadingProvider = Provider<bool>((ref) {
  final calendarsLoading = ref.watch(calendarsProvider).isLoading;
  final eventsLoading = ref.watch(eventsProvider).isLoading;
  final conflictsLoading = ref.watch(conflictsProvider).isLoading;

  return calendarsLoading || eventsLoading || conflictsLoading;
});

/// مقدم حالة الأخطاء العامة
final calendarErrorProvider = Provider<String?>((ref) {
  final calendarsError = ref.watch(calendarsProvider).error;
  final eventsError = ref.watch(eventsProvider).error;
  final conflictsError = ref.watch(conflictsProvider).error;

  if (calendarsError != null) return calendarsError.toString();
  if (eventsError != null) return eventsError.toString();
  if (conflictsError != null) return conflictsError.toString();

  return null;
});

/// مقدم تحديث البيانات
final refreshCalendarProvider = Provider<VoidCallback>((ref) {
  return () {
    ref.invalidate(calendarsProvider);
    ref.invalidate(eventsProvider);
    ref.invalidate(conflictsProvider);
  };
});

// ==================== مقدمات مساعدة ====================

/// مقدم أدوات التاريخ والوقت
final dateTimeUtilsProvider = Provider<DateTimeUtils>((ref) {
  final view = ref.watch(calendarViewProvider);
  return DateTimeUtils(firstDayOfWeek: view.settings.firstDayOfWeek);
});

/// فئة أدوات التاريخ والوقت
class DateTimeUtils {

  const DateTimeUtils({this.firstDayOfWeek = 1});
  final int firstDayOfWeek;

  DateTime getStartOfWeek(DateTime date) {
    final daysFromFirstDayOfWeek = (date.weekday - firstDayOfWeek) % 7;
    return date.subtract(Duration(days: daysFromFirstDayOfWeek));
  }

  DateTime getEndOfWeek(DateTime date) {
    return getStartOfWeek(date).add(const Duration(days: 6));
  }

  DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  List<DateTime> getDaysInMonth(DateTime date) {
    final start = getStartOfMonth(date);
    final end = getEndOfMonth(date);
    final days = <DateTime>[];

    for (int day = start.day; day <= end.day; day++) {
      days.add(DateTime(date.year, date.month, day));
    }

    return days;
  }

  List<DateTime> getWeekDays(DateTime date) {
    final start = getStartOfWeek(date);
    final days = <DateTime>[];

    for (int i = 0; i < 7; i++) {
      days.add(start.add(Duration(days: i)));
    }

    return days;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isSameWeek(DateTime a, DateTime b) {
    final startA = getStartOfWeek(a);
    final startB = getStartOfWeek(b);
    return isSameDay(startA, startB);
  }

  bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  String formatEventTime(CalendarEvent event, {bool show24Hour = true}) {
    final startTime = show24Hour
        ? TimeOfDay.fromDateTime(event.startDateTime).format24Hour()
        : TimeOfDay.fromDateTime(event.startDateTime).format12Hour();

    if (event.duration.inMinutes == 0) {
      return startTime;
    }

    final endTime = show24Hour
        ? TimeOfDay.fromDateTime(event.endDateTime).format24Hour()
        : TimeOfDay.fromDateTime(event.endDateTime).format12Hour();

    return '$startTime - $endTime';
  }

  String getEventDurationText(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} يوم';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ساعة';
    } else {
      return '${duration.inMinutes} دقيقة';
    }
  }
}

/// تمديدات مفيدة
extension TimeOfDayExtensions on TimeOfDay {
  String format24Hour() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String format12Hour() {
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
