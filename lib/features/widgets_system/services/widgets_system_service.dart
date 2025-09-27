import '../models/widget_config.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/models/habit.dart';

class WidgetsSystemService {
  static final WidgetsSystemService _instance =
      WidgetsSystemService._internal();
  factory WidgetsSystemService() => _instance;
  WidgetsSystemService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Helper methods لاستبدال HabitService
  Future<List<Habit>> _getActiveHabits() async {
    try {
      if (!Hive.isBoxOpen('habits')) {
        debugPrint('تحذير: صندوق العادات غير مفتوح');
        return [];
      }
      final habitsBox = Hive.box<Habit>('habits');
      return habitsBox.values.where((habit) => habit.isActive).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على العادات النشطة: $e');
      return [];
    }
  }

  Future<List<Habit>> _getHabitsByIds(List<String> habitIds) async {
    try {
      if (!Hive.isBoxOpen('habits')) {
        debugPrint('صندوق العادات غير مفتوح');
        return [];
      }
      final habitsBox = Hive.box<Habit>('habits');
      return habitIds
          .map((id) => habitsBox.get(id))
          .where((habit) => habit != null)
          .cast<Habit>()
          .toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على العادات بالمعرف: $e');
      return [];
    }
  }

  Future<List<Habit>> _getHabitsForDay(DateTime date) async {
    // إرجاع جميع العادات النشطة - يمكن تخصيصها حسب الحاجة
    return _getActiveHabits();
  }

  Future<double> _getHabitCompletion(String habitId, DateTime date) async {
    try {
      if (!Hive.isBoxOpen('habits')) {
        debugPrint('صندوق العادات غير مفتوح');
        return 0.0;
      }

      final habitsBox = Hive.box<Habit>('habits');
      final habit = habitsBox.get(habitId);
      if (habit == null) return 0.0;

      final dateStart = DateTime(date.year, date.month, date.day);
      final dateEnd = dateStart.add(const Duration(days: 1));

      final entry = habit.entries
          .where(
            (entry) =>
                entry.date.isAfter(
                  dateStart.subtract(const Duration(milliseconds: 1)),
                ) &&
                entry.date.isBefore(dateEnd),
          )
          .firstOrNull;

      if (entry == null) return 0.0;

      if (habit.type == HabitType.boolean) {
        return entry.isCompleted ? 100.0 : 0.0;
      } else {
        return (entry.value / habit.targetValue * 100).clamp(0.0, 100.0);
      }
    } catch (e) {
      debugPrint('خطأ في الحصول على إكمال العادة: $e');
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> _getStatistics(
    DateTime start,
    DateTime end,
  ) async {
    final habits = await _getActiveHabits();
    int totalHabits = habits.length;
    int completedHabits = 0;

    for (final habit in habits) {
      final entries = habit.entries
          .where(
            (entry) =>
                entry.date.isAfter(
                  start.subtract(const Duration(milliseconds: 1)),
                ) &&
                entry.date.isBefore(end.add(const Duration(milliseconds: 1))),
          )
          .toList();

      if (entries.isNotEmpty && entries.any((e) => e.isCompleted)) {
        completedHabits++;
      }
    }

    return {
      'totalHabits': totalHabits,
      'completedHabits': completedHabits,
      'completionRate': totalHabits > 0
          ? (completedHabits / totalHabits * 100)
          : 0.0,
    };
  }

  // إنشاء ودجت جديد
  Future<bool> createWidget(WidgetConfig widget) async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');
      await box.put(widget.id, widget);

      // إنشاء بيانات أولية للودجت
      await _initializeWidgetData(widget);

      return true;
    } catch (e) {
      debugPrint('خطأ في إنشاء الودجت: $e');
      return false;
    }
  }

  // الحصول على جميع الودجت
  Future<List<WidgetConfig>> getAllWidgets() async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');
      return box.values.toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));
    } catch (e) {
      debugPrint('خطأ في الحصول على الودجت: $e');
      return [];
    }
  }

  // الحصول على الودجت المفعلة فقط
  Future<List<WidgetConfig>> getActiveWidgets() async {
    try {
      final allWidgets = await getAllWidgets();
      return allWidgets.where((w) => w.isEnabled).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على الودجت المفعلة: $e');
      return [];
    }
  }

  // الحصول على ودجت بواسطة الهوية
  Future<WidgetConfig?> getWidget(String id) async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');
      return box.get(id);
    } catch (e) {
      debugPrint('خطأ في الحصول على الودجت: $e');
      return null;
    }
  }

  // تحديث ودجت
  Future<bool> updateWidget(WidgetConfig widget) async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');
      await box.put(widget.id, widget);

      // تحديث بيانات الودجت
      await refreshWidgetData(widget.id);

      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث الودجت: $e');
      return false;
    }
  }

  // حذف ودجت
  Future<bool> deleteWidget(String id) async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');
      await box.delete(id);

      // حذف بيانات الودجت
      final dataBox = await _databaseHelper.openBox<WidgetData>('widget_data');
      await dataBox.delete(id);

      return true;
    } catch (e) {
      debugPrint('خطأ في حذف الودجت: $e');
      return false;
    }
  }

  // تحديث بيانات ودجت معين
  Future<bool> refreshWidgetData(String widgetId) async {
    try {
      final widget = await getWidget(widgetId);
      if (widget == null || !widget.isEnabled) return false;

      final data = await _generateWidgetData(widget);

      final dataBox = await _databaseHelper.openBox<WidgetData>('widget_data');
      final widgetData = WidgetData(
        widgetId: widgetId,
        data: data,
        lastUpdate: DateTime.now(),
      );

      await dataBox.put(widgetId, widgetData);
      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث بيانات الودجت: $e');

      // تسجيل الخطأ في بيانات الودجت
      final dataBox = await _databaseHelper.openBox<WidgetData>('widget_data');
      final errorData = WidgetData(
        widgetId: widgetId,
        lastUpdate: DateTime.now(),
        isValid: false,
        errorMessage: e.toString(),
      );
      await dataBox.put(widgetId, errorData);

      return false;
    }
  }

  // تحديث جميع بيانات الودجت
  Future<void> refreshAllWidgetData() async {
    try {
      final activeWidgets = await getActiveWidgets();

      for (final widget in activeWidgets) {
        await refreshWidgetData(widget.id);
      }
    } catch (e) {
      debugPrint('خطأ في تحديث جميع بيانات الودجت: $e');
    }
  }

  // الحصول على بيانات ودجت
  Future<WidgetData?> getWidgetData(String widgetId) async {
    try {
      final dataBox = await _databaseHelper.openBox<WidgetData>('widget_data');
      return dataBox.get(widgetId);
    } catch (e) {
      debugPrint('خطأ في الحصول على بيانات الودجت: $e');
      return null;
    }
  }

  // إنشاء ودجت افتراضي
  Future<List<WidgetConfig>> createDefaultWidgets() async {
    try {
      final defaultWidgets = <WidgetConfig>[
        // ودجت تقدم العادات
        WidgetConfig(
          id: 'habit_progress_widget',
          type: WidgetType.habitProgress,
          title: 'تقدم العادات',
          size: WidgetSize.medium,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priority: 1,
          settings: {'showPercentage': true, 'showCount': true, 'maxHabits': 5},
        ),

        // ودجت مهام اليوم
        WidgetConfig(
          id: 'today_tasks_widget',
          type: WidgetType.todayTasks,
          title: 'مهام اليوم',
          size: WidgetSize.large,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priority: 2,
          settings: {
            'showCompleted': false,
            'maxTasks': 10,
            'sortBy': 'priority',
          },
        ),

        // ودجت عداد السلاسل
        WidgetConfig(
          id: 'streak_counter_widget',
          type: WidgetType.streakCounter,
          title: 'عداد السلاسل',
          size: WidgetSize.small,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priority: 3,
          settings: {
            'showBest': true,
            'showCurrent': true,
            'animateChanges': true,
          },
        ),

        // ودجت الاقتباس التحفيزي
        WidgetConfig(
          id: 'motivational_quote_widget',
          type: WidgetType.motivationalQuote,
          title: 'اقتباس تحفيزي',
          size: WidgetSize.medium,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priority: 4,
          refreshInterval: RefreshInterval.hour1,
          settings: {
            'category': 'motivation',
            'showAuthor': true,
            'changeDaily': true,
          },
        ),
      ];

      for (final widget in defaultWidgets) {
        await createWidget(widget);
      }

      return defaultWidgets;
    } catch (e) {
      debugPrint('خطأ في إنشاء الودجت الافتراضية: $e');
      return [];
    }
  }

  // إنشاء تخطيط ودجت جديد
  Future<bool> createWidgetLayout(WidgetLayout layout) async {
    try {
      final box = await _databaseHelper.openBox<WidgetLayout>('widget_layouts');
      await box.put(layout.id, layout);
      return true;
    } catch (e) {
      debugPrint('خطأ في إنشاء تخطيط الودجت: $e');
      return false;
    }
  }

  // الحصول على جميع تخطيطات الودجت
  Future<List<WidgetLayout>> getAllLayouts() async {
    try {
      final box = await _databaseHelper.openBox<WidgetLayout>('widget_layouts');
      return box.values.toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      debugPrint('خطأ في الحصول على تخطيطات الودجت: $e');
      return [];
    }
  }

  // الحصول على التخطيط الافتراضي
  Future<WidgetLayout?> getDefaultLayout() async {
    try {
      final layouts = await getAllLayouts();
      return layouts.where((l) => l.isDefault).firstOrNull;
    } catch (e) {
      debugPrint('خطأ في الحصول على التخطيط الافتراضي: $e');
      return null;
    }
  }

  // تحديث ترتيب الودجت
  Future<bool> updateWidgetPriorities(List<String> widgetIds) async {
    try {
      final box = await _databaseHelper.openBox<WidgetConfig>('widgets');

      for (int i = 0; i < widgetIds.length; i++) {
        final widget = box.get(widgetIds[i]);
        if (widget != null) {
          widget.priority = i;
          widget.updatedAt = DateTime.now();
          await widget.save();
        }
      }

      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث ترتيب الودجت: $e');
      return false;
    }
  }

  // الحصول على ودجت حسب النوع
  Future<List<WidgetConfig>> getWidgetsByType(WidgetType type) async {
    try {
      final allWidgets = await getAllWidgets();
      return allWidgets.where((w) => w.type == type).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على الودجت حسب النوع: $e');
      return [];
    }
  }

  // تحديث موضوع الودجت
  Future<bool> updateWidgetTheme(String widgetId, WidgetTheme theme) async {
    try {
      final widget = await getWidget(widgetId);
      if (widget == null) return false;

      widget.theme = theme;
      widget.updatedAt = DateTime.now();
      await widget.save();

      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث موضوع الودجت: $e');
      return false;
    }
  }

  // إنشاء بيانات أولية للودجت
  Future<void> _initializeWidgetData(WidgetConfig widget) async {
    try {
      await refreshWidgetData(widget.id);
    } catch (e) {
      debugPrint('خطأ في إنشاء البيانات الأولية للودجت: $e');
    }
  }

  // توليد بيانات الودجت حسب النوع
  Future<Map<String, dynamic>> _generateWidgetData(WidgetConfig widget) async {
    switch (widget.type) {
      case WidgetType.habitProgress:
        return await _generateHabitProgressData(widget);
      case WidgetType.todayTasks:
        return await _generateTodayTasksData(widget);
      case WidgetType.weeklyProgress:
        return await _generateWeeklyProgressData(widget);
      case WidgetType.motivationalQuote:
        return await _generateMotivationalQuoteData(widget);
      case WidgetType.streakCounter:
        return await _generateStreakCounterData(widget);
      case WidgetType.statisticsOverview:
        return await _generateStatisticsOverviewData(widget);
      case WidgetType.upcomingReminders:
        return await _generateUpcomingRemindersData(widget);
      case WidgetType.achievementsBadges:
        return await _generateAchievementsBadgesData(widget);
    }
  }

  // توليد بيانات ودجت تقدم العادات
  Future<Map<String, dynamic>> _generateHabitProgressData(
    WidgetConfig widget,
  ) async {
    try {
      final habits = widget.habitIds.isNotEmpty
          ? await _getHabitsByIds(widget.habitIds)
          : await _getActiveHabits();

      final maxHabits = widget.getSetting<int>('maxHabits') ?? 5;
      final selectedHabits = habits.take(maxHabits).toList();

      final progressData = <Map<String, dynamic>>[];
      int totalCompleted = 0;
      int totalHabits = selectedHabits.length;

      for (final habit in selectedHabits) {
        final todayCompletion = await _getHabitCompletion(
          habit.id,
          DateTime.now(),
        );
        final progress = todayCompletion >= 100.0 ? 1.0 : 0.0;

        if (progress > 0) totalCompleted++;

        progressData.add({
          'id': habit.id,
          'name': habit.name,
          'progress': progress,
          'color': '#2196F3', // لون افتراضي
          'isCompleted': progress >= 1.0,
        });
      }

      final overallProgress = totalHabits > 0
          ? totalCompleted / totalHabits
          : 0.0;

      return {
        'habits': progressData,
        'totalHabits': totalHabits,
        'completedHabits': totalCompleted,
        'overallProgress': overallProgress,
        'showPercentage': widget.getSetting<bool>('showPercentage') ?? true,
        'showCount': widget.getSetting<bool>('showCount') ?? true,
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات تقدم العادات: $e');
    }
  }

  // توليد بيانات ودجت مهام اليوم
  Future<Map<String, dynamic>> _generateTodayTasksData(
    WidgetConfig widget,
  ) async {
    try {
      final today = DateTime.now();
      final habits = await _getHabitsForDay(today);

      final maxTasks = widget.getSetting<int>('maxTasks') ?? 10;
      final showCompleted = widget.getSetting<bool>('showCompleted') ?? false;

      final tasks = <Map<String, dynamic>>[];

      for (final habit in habits.take(maxTasks)) {
        final completion = await _getHabitCompletion(habit.id, today);
        final isCompleted = completion >= 100.0;

        if (showCompleted || !isCompleted) {
          tasks.add({
            'id': habit.id,
            'name': habit.name,
            'isCompleted': isCompleted,
            'time': null, // لا توجد خاصية وقت التذكير في نموذج Habit
            'priority': 1, // أولوية افتراضية
            'color': '#2196F3', // لون افتراضي
          });
        }
      }

      // ترتيب المهام
      final sortBy = widget.getSetting<String>('sortBy') ?? 'priority';
      if (sortBy == 'priority') {
        tasks.sort(
          (a, b) => (b['priority'] ?? 0).compareTo(a['priority'] ?? 0),
        );
      } else if (sortBy == 'time') {
        tasks.sort((a, b) {
          final timeA = a['time'] as String?;
          final timeB = b['time'] as String?;
          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;
          return timeA.compareTo(timeB);
        });
      }

      return {
        'tasks': tasks,
        'totalTasks': tasks.length,
        'completedTasks': tasks.where((t) => t['isCompleted'] == true).length,
        'showCompleted': showCompleted,
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات مهام اليوم: $e');
    }
  }

  // توليد بيانات ودجت التقدم الأسبوعي
  Future<Map<String, dynamic>> _generateWeeklyProgressData(
    WidgetConfig widget,
  ) async {
    try {
      final today = DateTime.now();
      final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      final weeklyData = <Map<String, dynamic>>[];

      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        final dayHabits = await _getHabitsForDay(date);

        int completed = 0;
        for (final habit in dayHabits) {
          final completion = await _getHabitCompletion(habit.id, date);
          if (completion >= 100.0) {
            completed++;
          }
        }

        final progress = dayHabits.isNotEmpty
            ? completed / dayHabits.length
            : 0.0;

        weeklyData.add({
          'date': date.toIso8601String(),
          'dayName': _getDayName(date.weekday),
          'totalHabits': dayHabits.length,
          'completedHabits': completed,
          'progress': progress,
          'isToday':
              date.day == today.day &&
              date.month == today.month &&
              date.year == today.year,
        });
      }

      final totalProgress =
          weeklyData.fold(
            0.0,
            (sum, day) => sum + (day['progress'] as double),
          ) /
          7;

      return {
        'weeklyData': weeklyData,
        'overallProgress': totalProgress,
        'startOfWeek': startOfWeek.toIso8601String(),
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات التقدم الأسبوعي: $e');
    }
  }

  // توليد بيانات ودجت الاقتباس التحفيزي
  Future<Map<String, dynamic>> _generateMotivationalQuoteData(
    WidgetConfig widget,
  ) async {
    try {
      final quotes = _getMotivationalQuotes();
      final category = widget.getSetting<String>('category') ?? 'motivation';
      final showAuthor = widget.getSetting<bool>('showAuthor') ?? true;

      // اختيار اقتباس عشوائي أو يومي
      final changeDaily = widget.getSetting<bool>('changeDaily') ?? true;
      final seed = changeDaily
          ? DateTime.now().day +
                DateTime.now().month * 31 +
                DateTime.now().year * 365
          : DateTime.now().millisecondsSinceEpoch;

      final randomIndex = seed % quotes.length;
      final selectedQuote = quotes[randomIndex];

      return {
        'text': selectedQuote['text'],
        'author': showAuthor ? selectedQuote['author'] : null,
        'category': category,
        'showAuthor': showAuthor,
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات الاقتباس التحفيزي: $e');
    }
  }

  // توليد بيانات ودجت عداد السلاسل
  Future<Map<String, dynamic>> _generateStreakCounterData(
    WidgetConfig widget,
  ) async {
    try {
      final habits = widget.habitIds.isNotEmpty
          ? await _getHabitsByIds(widget.habitIds)
          : await _getActiveHabits();

      final showBest = widget.getSetting<bool>('showBest') ?? true;
      final showCurrent = widget.getSetting<bool>('showCurrent') ?? true;

      final streakData = <Map<String, dynamic>>[];
      int totalCurrentStreak = 0;
      int bestStreak = 0;

      for (final habit in habits) {
        final currentStreak = habit.currentStreak;
        final longestStreak = habit.longestStreak;

        totalCurrentStreak += currentStreak;
        if (longestStreak > bestStreak) {
          bestStreak = longestStreak;
        }

        streakData.add({
          'id': habit.id,
          'name': habit.name,
          'currentStreak': currentStreak,
          'longestStreak': longestStreak,
          'color': '#2196F3', // لون افتراضي
        });
      }

      return {
        'habits': streakData,
        'totalCurrentStreak': totalCurrentStreak,
        'bestStreak': bestStreak,
        'showBest': showBest,
        'showCurrent': showCurrent,
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات عداد السلاسل: $e');
    }
  }

  // توليد بيانات ودجت نظرة عامة على الإحصائيات
  Future<Map<String, dynamic>> _generateStatisticsOverviewData(
    WidgetConfig widget,
  ) async {
    try {
      final today = DateTime.now();
      final thisWeek = today.subtract(Duration(days: 7));
      final thisMonth = today.subtract(Duration(days: 30));

      final todayHabits = await _getHabitsForDay(today);
      final todayCompleted = await _getTotalCompletedHabits(todayHabits, today);

      final weeklyStats = await _getStatistics(thisWeek, today);
      final monthlyStats = await _getStatistics(thisMonth, today);

      return {
        'today': {
          'total': todayHabits.length,
          'completed': todayCompleted,
          'percentage': todayHabits.isNotEmpty
              ? (todayCompleted / todayHabits.length * 100).round()
              : 0,
        },
        'thisWeek': {
          'completionRate': weeklyStats['completionRate'] ?? 0,
          'totalHabits': weeklyStats['totalHabits'] ?? 0,
          'longestStreak': weeklyStats['longestStreak'] ?? 0,
        },
        'thisMonth': {
          'completionRate': monthlyStats['completionRate'] ?? 0,
          'totalHabits': monthlyStats['totalHabits'] ?? 0,
          'averageDaily': monthlyStats['averageDaily'] ?? 0,
        },
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات نظرة عامة على الإحصائيات: $e');
    }
  }

  // توليد بيانات ودجت التذكيرات القادمة
  Future<Map<String, dynamic>> _generateUpcomingRemindersData(
    WidgetConfig widget,
  ) async {
    try {
      // المتغيرات محجوزة للاستخدام المستقبلي
      // final today = DateTime.now();
      // final tomorrow = today.add(Duration(days: 1));

      // تم إزالة المتغيرات غير المستخدمة
      // final todayHabits = await _getHabitsForDay(today);
      // final tomorrowHabits = await _getHabitsForDay(tomorrow);

      final upcomingReminders = <Map<String, dynamic>>[];

      // تم تعطيل التذكيرات لأن نموذج Habit لا يحتوي على reminderTime
      // يمكن إضافة منطق تذكيرات بديل هنا

      // ترتيب التذكيرات حسب الوقت (فارغة حالياً)
      upcomingReminders.sort((a, b) {
        final timeA = DateTime.parse(a['time']);
        final timeB = DateTime.parse(b['time']);
        return timeA.compareTo(timeB);
      });

      return {
        'reminders': upcomingReminders,
        'totalReminders': upcomingReminders.length,
        'todayReminders': upcomingReminders
            .where((r) => r['isToday'] == true)
            .length,
        'tomorrowReminders': upcomingReminders
            .where((r) => r['isToday'] == false)
            .length,
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات التذكيرات القادمة: $e');
    }
  }

  // توليد بيانات ودجت شارات الإنجازات
  Future<Map<String, dynamic>> _generateAchievementsBadgesData(
    WidgetConfig widget,
  ) async {
    try {
      // في التطبيق الحقيقي، ستحصل على الإنجازات من خدمة الألعاب
      final achievements = <Map<String, dynamic>>[
        {
          'id': 'first_habit',
          'title': 'البداية',
          'description': 'أول عادة',
          'icon': '🌟',
          'isUnlocked': true,
          'unlockedAt': DateTime.now()
              .subtract(Duration(days: 10))
              .toIso8601String(),
        },
        {
          'id': 'week_streak',
          'title': 'أسبوع كامل',
          'description': 'سلسلة أسبوع',
          'icon': '🔥',
          'isUnlocked': true,
          'unlockedAt': DateTime.now()
              .subtract(Duration(days: 3))
              .toIso8601String(),
        },
        {
          'id': 'perfect_day',
          'title': 'يوم مثالي',
          'description': 'جميع العادات في يوم واحد',
          'icon': '💎',
          'isUnlocked': false,
          'unlockedAt': null,
        },
      ];

      final unlockedAchievements = achievements
          .where((a) => a['isUnlocked'] == true)
          .toList();
      final recentAchievements = unlockedAchievements
          .where(
            (a) => DateTime.parse(
              a['unlockedAt'],
            ).isAfter(DateTime.now().subtract(Duration(days: 7))),
          )
          .toList();

      return {
        'achievements': achievements,
        'unlockedCount': unlockedAchievements.length,
        'totalCount': achievements.length,
        'recentAchievements': recentAchievements,
        'completionPercentage':
            (unlockedAchievements.length / achievements.length * 100).round(),
      };
    } catch (e) {
      throw Exception('خطأ في توليد بيانات شارات الإنجازات: $e');
    }
  }

  // الحصول على اسم اليوم
  String _getDayName(int weekday) {
    const dayNames = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return dayNames[weekday - 1];
  }

  // الحصول على عدد العادات المكتملة في يوم معين
  Future<int> _getTotalCompletedHabits(
    List<Habit> habits,
    DateTime date,
  ) async {
    int completed = 0;
    for (final habit in habits) {
      final completion = await _getHabitCompletion(habit.id, date);
      if (completion >= 100.0) {
        completed++;
      }
    }
    return completed;
  }

  // الحصول على الاقتباسات التحفيزية
  List<Map<String, String>> _getMotivationalQuotes() {
    return [
      {
        'text': 'النجاح هو مجموع الجهود الصغيرة المتكررة يوماً بعد يوم',
        'author': 'روبرت كولير',
      },
      {
        'text': 'العادات الجيدة هي صعبة التكوين ولكن سهلة المعيشة معها',
        'author': 'بريان تريسي',
      },
      {
        'text': 'لا تنتظر اللحظة المناسبة، اجعل اللحظة مناسبة',
        'author': 'جورج برنارد شو',
      },
      {
        'text': 'الثبات على العادات الصغيرة يؤدي إلى تغييرات كبيرة',
        'author': 'جيمس كلير',
      },
      {
        'text': 'كل يوم جديد فرصة لتصبح نسخة أفضل من نفسك',
        'author': 'غير معروف',
      },
      {'text': 'التقدم، وليس الكمال، هو الهدف', 'author': 'غير معروف'},
      {
        'text': 'العادات هي الفائدة المركبة للتحسن الذاتي',
        'author': 'جيمس كلير',
      },
      {
        'text': 'أنت لا تصل إلى مستوى أهدافك، بل تنحدر إلى مستوى أنظمتك',
        'author': 'جيمس كلير',
      },
    ];
  }
}
