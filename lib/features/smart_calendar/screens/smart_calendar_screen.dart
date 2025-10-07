// lib/features/smart_calendar/screens/smart_calendar_screen.dart
// شاشة التقويم الذكي

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/calendar_models.dart';
import '../providers/calendar_providers.dart';

/// شاشة التقويم الذكي الرئيسية
class SmartCalendarScreen extends ConsumerWidget {
  const SmartCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarView = ref.watch(calendarViewProvider);
    final eventsAsync = ref.watch(eventsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'التقويم الذكي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          // أزرار التبديل بين العروض
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<CalendarViewType>(
              icon: const Icon(Icons.view_module, color: Colors.white),
              onSelected: (viewType) {
                ref.read(calendarViewProvider.notifier).setViewType(viewType);
              },
              itemBuilder: (context) => CalendarViewType.values.map((viewType) {
                return PopupMenuItem(
                  value: viewType,
                  child: Row(
                    children: [
                      Icon(_getViewTypeIcon(viewType)),
                      const SizedBox(width: 8),
                      Text(_getViewTypeName(viewType)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.today, color: Colors.white),
              onPressed: () {
                ref.read(calendarViewProvider.notifier).goToToday();
              },
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary.withValues(alpha: 0.6),
              theme.colorScheme.tertiary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 16),
            // شريط التنقل بين التواريخ
            _buildNavigationHeader(context, ref, calendarView),
            const Divider(height: 1),

            // محتوى التقويم
            Expanded(
              child: eventsAsync.when(
                data: (events) =>
                    _buildCalendarView(context, ref, calendarView, events),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'خطأ في تحميل الأحداث: $error',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(eventsProvider),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showCreateEventDialog(context, ref),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNavigationHeader(
    BuildContext context,
    WidgetRef ref,
    CalendarView view,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              ref.read(calendarViewProvider.notifier).goToPreviousPeriod();
            },
            icon: const Icon(Icons.chevron_left),
          ),

          Text(
            _formatCurrentDate(view.currentDate, view.type),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          IconButton(
            onPressed: () {
              ref.read(calendarViewProvider.notifier).goToNextPeriod();
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    WidgetRef ref,
    CalendarView view,
    List<CalendarEvent> events,
  ) {
    switch (view.type) {
      case CalendarViewType.day:
        return _buildDayView(context, events);
      case CalendarViewType.week:
        return _buildWeekView(context, events);
      case CalendarViewType.month:
        return _buildMonthView(context, events);
      case CalendarViewType.agenda:
        return _buildAgendaView(context, events);
      case CalendarViewType.timeline:
        return _buildTimelineView(context, events);
    }
  }

  Widget _buildDayView(BuildContext context, List<CalendarEvent> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getEventTypeColor(event.type),
              child: Icon(_getEventTypeIcon(event.type), color: Colors.white),
            ),
            title: Text(event.title),
            subtitle: Text(
              '${_formatTime(event.startDateTime)} - ${_formatTime(event.endDateTime)}',
            ),
            trailing: event.isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.radio_button_unchecked),
            onTap: () => _showEventDetails(context, event),
          ),
        );
      },
    );
  }

  Widget _buildWeekView(BuildContext context, List<CalendarEvent> events) {
    return const Center(child: Text('عرض الأسبوع - قيد التطوير'));
  }

  Widget _buildMonthView(BuildContext context, List<CalendarEvent> events) {
    return const Center(child: Text('عرض الشهر - قيد التطوير'));
  }

  Widget _buildAgendaView(BuildContext context, List<CalendarEvent> events) {
    return const Center(child: Text('عرض الأجندة - قيد التطوير'));
  }

  Widget _buildTimelineView(BuildContext context, List<CalendarEvent> events) {
    return const Center(child: Text('عرض الخط الزمني - قيد التطوير'));
  }

  void _showCreateEventDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حدث جديد'),
        content: const Text('ستتم إضافة نموذج إنشاء الأحداث قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description?.isNotEmpty ?? false)
              Text(event.description!),
            const SizedBox(height: 8),
            Text(
              'الوقت: ${_formatTime(event.startDateTime)} - ${_formatTime(event.endDateTime)}',
            ),
            if (event.location?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text('المكان: ${event.location}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  IconData _getViewTypeIcon(CalendarViewType type) {
    switch (type) {
      case CalendarViewType.day:
        return Icons.view_day;
      case CalendarViewType.week:
        return Icons.view_week;
      case CalendarViewType.month:
        return Icons.calendar_month;
      case CalendarViewType.agenda:
        return Icons.list;
      case CalendarViewType.timeline:
        return Icons.timeline;
    }
  }

  String _getViewTypeName(CalendarViewType type) {
    switch (type) {
      case CalendarViewType.day:
        return 'يوم';
      case CalendarViewType.week:
        return 'أسبوع';
      case CalendarViewType.month:
        return 'شهر';
      case CalendarViewType.agenda:
        return 'أجندة';
      case CalendarViewType.timeline:
        return 'خط زمني';
    }
  }

  String _formatCurrentDate(DateTime date, CalendarViewType type) {
    switch (type) {
      case CalendarViewType.day:
        return '${date.day}/${date.month}/${date.year}';
      case CalendarViewType.week:
        return 'أسبوع ${date.day}/${date.month}/${date.year}';
      case CalendarViewType.month:
        return '${_getMonthName(date.month)} ${date.year}';
      default:
        return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getEventTypeColor(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.habit:
        return Colors.green;
      case CalendarEventType.reminder:
        return Colors.blue;
      case CalendarEventType.appointment:
        return Colors.purple;
      case CalendarEventType.deadline:
        return Colors.red;
      case CalendarEventType.meeting:
        return Colors.orange;
      case CalendarEventType.workout:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventTypeIcon(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.habit:
        return Icons.track_changes;
      case CalendarEventType.reminder:
        return Icons.notifications;
      case CalendarEventType.appointment:
        return Icons.event;
      case CalendarEventType.deadline:
        return Icons.alarm;
      case CalendarEventType.meeting:
        return Icons.people;
      case CalendarEventType.workout:
        return Icons.fitness_center;
      default:
        return Icons.event_note;
    }
  }
}
