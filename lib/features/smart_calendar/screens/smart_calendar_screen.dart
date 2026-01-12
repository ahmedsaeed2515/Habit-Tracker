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
                      const const SizedBox(width: 8),
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
            const const SizedBox(height: kToolbarHeight + 16),
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
                      const const SizedBox(height: 16),
                      Text(
                        'خطأ في تحميل الأحداث: $error',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const const SizedBox(height: 16),
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
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
    
    return Column(
      children: [
        // Week days header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              final isToday = day.day == now.day && day.month == now.month;
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      _getDayName(day.weekday),
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                    const const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isToday ? Theme.of(context).primaryColor : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isToday ? Colors.white : null,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(),
        // Events for the week
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventDate = event.startTime;
              if (eventDate.isAfter(weekDays.first.subtract(const Duration(days: 1))) &&
                  eventDate.isBefore(weekDays.last.add(const Duration(days: 1)))) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 4,
                      color: _getEventColor(event.type),
                    ),
                    title: Text(event.title),
                    subtitle: Text('${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}'),
                    onTap: () => _showEventDetails(context, event),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
  
  String _getDayName(int weekday) {
    const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return days[weekday - 1];
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMonthView(BuildContext context, List<CalendarEvent> events) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    
    return Column(
      children: [
        // Month header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _getMonthName(now.month),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Week days
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const const SizedBox(height: 8),
        // Calendar grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = index + 1;
              final date = DateTime(now.year, now.month, day);
              final isToday = day == now.day;
              final dayEvents = events.where((e) =>
                  e.startTime.year == date.year &&
                  e.startTime.month == date.month &&
                  e.startTime.day == date.day).length;
              
              return Container(
                decoration: BoxDecoration(
                  color: isToday ? Theme.of(context).primaryColor : null,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        color: isToday ? Colors.white : null,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (dayEvents > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isToday ? Colors.white : Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }

  Widget _buildAgendaView(BuildContext context, List<CalendarEvent> events) {
    if (events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('لا توجد أحداث', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    
    // Group events by date
    final groupedEvents = <String, List<CalendarEvent>>{};
    for (final event in events) {
      final dateKey = '${event.startTime.year}-${event.startTime.month}-${event.startTime.day}';
      groupedEvents.putIfAbsent(dateKey, () => []).add(event);
    }
    
    // Sort dates
    final sortedDates = groupedEvents.keys.toList()..sort();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final dateEvents = groupedEvents[dateKey]!;
        final date = dateEvents.first.startTime;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '${_getDayName(date.weekday)} ${date.day} ${_getMonthName(date.month)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...dateEvents.map((event) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 4,
                  height: double.infinity,
                  color: _getEventColor(event.type),
                ),
                title: Text(event.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}'),
                    if (event.description?.isNotEmpty ?? false)
                      Text(
                        event.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _showEventDetails(context, event),
              ),
            )),
            const const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildTimelineView(BuildContext context, List<CalendarEvent> events) {
    if (events.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('لا توجد أحداث', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }
    
    // Sort events by start time
    final sortedEvents = List<CalendarEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isFirst = index == 0;
        final isLast = index == sortedEvents.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline indicator
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    if (!isFirst)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getEventColor(event.type),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                  ],
                ),
              ),
              const const SizedBox(width: 16),
              // Event card
              Expanded(
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getEventColor(event.type).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                event.type.name,
                                style: TextStyle(
                                  color: _getEventColor(event.type),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const const SizedBox(width: 4),
                            Text(
                              '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const const SizedBox(width: 4),
                            Text(
                              '${event.startTime.day} ${_getMonthName(event.startTime.month)} ${event.startTime.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (event.description?.isNotEmpty ?? false) ...[
                          const const SizedBox(height: 8),
                          Text(
                            event.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            const const SizedBox(height: 8),
            Text(
              'الوقت: ${_formatTime(event.startDateTime)} - ${_formatTime(event.endDateTime)}',
            ),
            if (event.location?.isNotEmpty ?? false) ...[
              const const SizedBox(height: 8),
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
