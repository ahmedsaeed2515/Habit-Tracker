import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pomodoro_models.dart';
import '../services/smart_pomodoro_service.dart';

/// مزودي حالة نظام Pomodoro Task Management

// مزود الخدمة الرئيسية
final pomodoroServiceProvider = Provider<SmartPomodoroService>((ref) {
  return SmartPomodoroService();
});

// مزود الجلسة النشطة
final activeSessionProvider = StateNotifierProvider<ActiveSessionNotifier, PomodoroSession?>((ref) {
  return ActiveSessionNotifier(ref.watch(pomodoroServiceProvider));
});

class ActiveSessionNotifier extends StateNotifier<PomodoroSession?> {

  ActiveSessionNotifier(this._service) : super(null) {
    _listenToSessionStream();
  }
  final SmartPomodoroService _service;

  void _listenToSessionStream() {
    _service.sessionStream.listen((session) {
      if (session.status == SessionStatus.active || session.status == SessionStatus.paused) {
        state = session;
      } else {
        state = null;
      }
    });
  }

  Future<void> startSession({
    required SessionType type,
    Duration? customDuration,
    String? taskId,
  }) async {
    final session = await _service.createSession(
      type: type,
      customDuration: customDuration,
      taskId: taskId,
    );
    await _service.startSession(session.id);
  }

  Future<void> pauseSession() async {
    if (state != null) {
      await _service.pauseSession(state!.id);
    }
  }

  Future<void> resumeSession() async {
    if (state != null) {
      await _service.resumeSession(state!.id);
    }
  }

  Future<void> completeSession() async {
    if (state != null) {
      await _service.completeSession(state!.id);
    }
  }

  Future<void> skipSession() async {
    if (state != null) {
      await _service.skipSession(state!.id);
    }
  }

  Future<void> cancelSession() async {
    if (state != null) {
      await _service.cancelSession(state!.id);
    }
  }
}

// مزود المهام المتقدمة
final advancedTasksProvider = StateNotifierProvider<AdvancedTasksNotifier, List<AdvancedTask>>((ref) {
  return AdvancedTasksNotifier(ref.watch(pomodoroServiceProvider));
});

class AdvancedTasksNotifier extends StateNotifier<List<AdvancedTask>> {

  AdvancedTasksNotifier(this._service) : super([]) {
    _loadTasks();
  }
  final SmartPomodoroService _service;

  void _loadTasks() {
    state = _service.filterAndSortTasks();
  }

  Future<void> createTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    List<String> tags = const [],
    DateTime? dueDate,
    DateTime? reminderTime,
    Duration? estimatedDuration,
    List<Subtask> subtasks = const [],
    RecurrenceRule? recurrence,
    String? projectId,
  }) async {
    final task = await _service.createTask(
      title: title,
      description: description,
      priority: priority,
      tags: tags,
      dueDate: dueDate,
      reminderTime: reminderTime,
      estimatedDuration: estimatedDuration,
      subtasks: subtasks,
      recurrence: recurrence,
      projectId: projectId,
    );
    state = [...state, task];
  }

  Future<void> updateTask(String taskId, AdvancedTask updatedTask) async {
    await _service.updateTask(taskId, updatedTask);
    state = state.map((task) => task.id == taskId ? updatedTask : task).toList();
  }

  Future<void> deleteTask(String taskId) async {
    await _service.deleteTask(taskId);
    state = state.where((task) => task.id != taskId).toList();
  }

  Future<void> completeTask(String taskId) async {
    await _service.completeTask(taskId);
    _loadTasks();
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    final updatedSubtasks = task.subtasks.map((subtask) {
      if (subtask.id == subtaskId) {
        return subtask.copyWith(isCompleted: !subtask.isCompleted);
      }
      return subtask;
    }).toList();

    final updatedTask = task.copyWith(subtasks: updatedSubtasks);
    await updateTask(taskId, updatedTask);
  }

  void filterTasks({
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? tags,
    String? projectId,
  }) {
    state = _service.filterAndSortTasks(
      status: status,
      priority: priority,
      tags: tags,
      projectId: projectId,
    );
  }

  void sortTasks({
    required TaskSortBy sortBy,
    bool ascending = true,
  }) {
    state = _service.filterAndSortTasks(
      sortBy: sortBy,
      ascending: ascending,
    );
  }
}

// مزود الإعدادات
final pomodoroSettingsProvider = StateNotifierProvider<PomodoroSettingsNotifier, PomodoroSettings>((ref) {
  return PomodoroSettingsNotifier(ref.watch(pomodoroServiceProvider));
});

class PomodoroSettingsNotifier extends StateNotifier<PomodoroSettings> {

  PomodoroSettingsNotifier(this._service) : super(const PomodoroSettings()) {
    state = _service.getSettings();
  }
  final SmartPomodoroService _service;

  Future<void> updateSettings(PomodoroSettings settings) async {
    await _service.updateSettings(settings);
    state = settings;
  }

  Future<void> updateFocusSession(Duration duration) async {
    final updated = state.copyWith(focusSession: duration);
    await updateSettings(updated);
  }

  Future<void> updateShortBreak(Duration duration) async {
    final updated = state.copyWith(shortBreak: duration);
    await updateSettings(updated);
  }

  Future<void> updateLongBreak(Duration duration) async {
    final updated = state.copyWith(longBreak: duration);
    await updateSettings(updated);
  }

  Future<void> updateLongBreakInterval(int interval) async {
    final updated = state.copyWith(longBreakInterval: interval);
    await updateSettings(updated);
  }

  Future<void> toggleAutoStartBreaks() async {
    final updated = state.copyWith(autoStartBreaks: !state.autoStartBreaks);
    await updateSettings(updated);
  }

  Future<void> toggleAutoStartFocus() async {
    final updated = state.copyWith(autoStartFocus: !state.autoStartFocus);
    await updateSettings(updated);
  }

  Future<void> toggleNotifications() async {
    final updated = state.copyWith(enableNotifications: !state.enableNotifications);
    await updateSettings(updated);
  }

  Future<void> toggleBackgroundMode() async {
    final updated = state.copyWith(enableBackgroundMode: !state.enableBackgroundMode);
    await updateSettings(updated);
  }

  Future<void> updateSoundVolume(double volume) async {
    final updated = state.copyWith(soundVolume: volume);
    await updateSettings(updated);
  }

  Future<void> toggleVibration() async {
    final updated = state.copyWith(enableVibration: !state.enableVibration);
    await updateSettings(updated);
  }
  
  // Additional update methods for missing properties
  Future<void> updateAutoStartBreak(bool value) async {
    final updated = state.copyWith(autoStartBreaks: value);
    await updateSettings(updated);
  }
  
  Future<void> updateBackgroundMode(bool value) async {
    final updated = state.copyWith(enableBackgroundMode: value);
    await updateSettings(updated);
  }
  
  Future<void> updateSoundEnabled(bool value) async {
    final updated = state.copyWith(soundVolume: value ? 0.7 : 0.0);
    await updateSettings(updated);
  }
  
  Future<void> updateVibrateEnabled(bool value) async {
    final updated = state.copyWith(enableVibration: value);
    await updateSettings(updated);
  }
  
  Future<void> updateDailyGoal(int goal) async {
    final updated = state.copyWith(dailyGoal: goal);
    await updateSettings(updated);
  }
  
  Future<void> updateShowNotifications(bool value) async {
    final updated = state.copyWith(enableNotifications: value);
    await updateSettings(updated);
  }
  
  Future<void> updateTaskReminders(bool value) async {
    final updated = state.copyWith(taskReminders: value);
    await updateSettings(updated);
  }
  
  Future<void> updateAchievementNotifications(bool value) async {
    final updated = state.copyWith(achievementNotifications: value);
    await updateSettings(updated);
  }
  
  Future<void> updateNotificationSound(String sound) async {
    final updated = state.copyWith(notificationSound: sound);
    await updateSettings(updated);
  }
}

// مزود الإحصائيات
final pomodoroStatsProvider = StateNotifierProvider<PomodoroStatsNotifier, PomodoroStats>((ref) {
  return PomodoroStatsNotifier(ref.watch(pomodoroServiceProvider));
});

class PomodoroStatsNotifier extends StateNotifier<PomodoroStats> {

  PomodoroStatsNotifier(this._service) : super(
    PomodoroStats(
      id: 'today',
      date: DateTime.now(),
    ),
  ) {
    _loadTodayStats();
    _listenToStatsStream();
  }
  final SmartPomodoroService _service;

  void _loadTodayStats() {
    state = _service.getTodayStats();
  }

  void _listenToStatsStream() {
    _service.statsStream.listen((stats) {
      state = stats;
    });
  }

  List<PomodoroStats> getWeeklyStats() {
    return _service.getWeeklyStats();
  }
  
  PomodoroStats getStatsForRange(range) {
    // تحويل نطاق التواريخ إلى بيانات إحصائية
    switch (range.toString()) {
      case 'DateRange.day':
        return _service.getTodayStats();
      case 'DateRange.week':
        final weeklyStats = _service.getWeeklyStats();
        return weeklyStats.isNotEmpty ? weeklyStats.last : state;
      case 'DateRange.month':
        return _service.getMonthlyStats();
      case 'DateRange.year':
        return _service.getYearlyStats();
      default:
        return state;
    }
  }
}

// مزود الإنجازات
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier(ref.watch(pomodoroServiceProvider));
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {

  AchievementsNotifier(this._service) : super([]) {
    state = _service.getAchievements();
  }
  final SmartPomodoroService _service;

  List<Achievement> get unlockedAchievements {
    return state.where((a) => a.isUnlocked).toList();
  }

  List<Achievement> get lockedAchievements {
    return state.where((a) => !a.isUnlocked).toList();
  }

  void refresh() {
    state = _service.getAchievements();
  }
}

// مزود التايمرات المتعددة
final multiTimersProvider = StateNotifierProvider<MultiTimersNotifier, List<MultiTimer>>((ref) {
  return MultiTimersNotifier(ref.watch(pomodoroServiceProvider));
});

class MultiTimersNotifier extends StateNotifier<List<MultiTimer>> {

  MultiTimersNotifier(this._service) : super([]);
  final SmartPomodoroService _service;

  Future<void> createMultiTimer({
    required String name,
    required List<PomodoroSession> sessions,
  }) async {
    final timer = await _service.createMultiTimer(
      name: name,
      sessions: sessions,
    );
    state = [...state, timer];
  }

  Future<void> startMultiTimer(String timerId) async {
    await _service.startMultiTimer(timerId);
    // تحديث الحالة
    final updatedTimers = state.map((timer) {
      if (timer.id == timerId) {
        return timer.copyWith(
          isActive: true,
          startedAt: DateTime.now(),
        );
      }
      return timer;
    }).toList();
    state = updatedTimers;
  }
}

// مزود اقتراحات AI
final aiSuggestionsProvider = FutureProvider.family<List<AITaskSuggestion>, String>((ref, taskId) async {
  final service = ref.watch(pomodoroServiceProvider);
  return service.getAITaskSuggestions(taskId);
});

// مزود اقتراحات الاستراحة
final breakSuggestionsProvider = Provider<List<BreakSuggestion>>((ref) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.getBreakSuggestions();
});

// مزود تصفية المهام
final taskFilterProvider = StateNotifierProvider<TaskFilterNotifier, TaskFilter>((ref) {
  return TaskFilterNotifier();
});

class TaskFilterNotifier extends StateNotifier<TaskFilter> {
  TaskFilterNotifier() : super(const TaskFilter());

  void updateStatus(TaskStatus? status) {
    state = state.copyWith(status: status);
  }

  void updatePriority(TaskPriority? priority) {
    state = state.copyWith(priority: priority);
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  void updateProjectId(String? projectId) {
    state = state.copyWith(projectId: projectId);
  }

  void updateSortBy(TaskSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void updateAscending(bool ascending) {
    state = state.copyWith(ascending: ascending);
  }

  void resetFilter() {
    state = const TaskFilter();
  }
}

// مزود المهام المفلترة
final filteredTasksProvider = Provider<List<AdvancedTask>>((ref) {
  ref.watch(advancedTasksProvider);
  final filter = ref.watch(taskFilterProvider);
  final service = ref.watch(pomodoroServiceProvider);

  return service.filterAndSortTasks(
    status: filter.status,
    priority: filter.priority,
    tags: filter.tags,
    projectId: filter.projectId,
    sortBy: filter.sortBy,
    ascending: filter.ascending,
  );
});

// مزود المهام المتأخرة
final overdueTasksProvider = Provider<List<AdvancedTask>>((ref) {
  final tasks = ref.watch(advancedTasksProvider);
  return tasks.where((task) => task.isOverdue).toList();
});

// مزود المهام المستحقة اليوم
final dueTodayTasksProvider = Provider<List<AdvancedTask>>((ref) {
  final tasks = ref.watch(advancedTasksProvider);
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  return tasks.where((task) {
    if (task.dueDate == null) return false;
    return task.dueDate!.isAfter(todayStart) && task.dueDate!.isBefore(todayEnd);
  }).toList();
});

// مزود المهام المكتملة اليوم
final completedTodayTasksProvider = Provider<List<AdvancedTask>>((ref) {
  final tasks = ref.watch(advancedTasksProvider);
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = todayStart.add(const Duration(days: 1));

  return tasks.where((task) {
    return task.status == TaskStatus.completed &&
           task.updatedAt.isAfter(todayStart) &&
           task.updatedAt.isBefore(todayEnd);
  }).toList();
});

// مزود إحصائيات المهام
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(advancedTasksProvider);
  
  return TaskStats(
    totalTasks: tasks.length,
    completedTasks: tasks.where((t) => t.status == TaskStatus.completed).length,
    pendingTasks: tasks.where((t) => t.status == TaskStatus.pending).length,
    inProgressTasks: tasks.where((t) => t.status == TaskStatus.inProgress).length,
    overdueTasks: tasks.where((t) => t.isOverdue).length,
    highPriorityTasks: tasks.where((t) => t.priority == TaskPriority.high || t.priority == TaskPriority.urgent).length,
  );
});

// مزود الثيمات
final pomodoroThemesProvider = StateNotifierProvider<PomodoroThemesNotifier, List<PomodoroTheme>>((ref) {
  return PomodoroThemesNotifier();
});

class PomodoroThemesNotifier extends StateNotifier<List<PomodoroTheme>> {
  PomodoroThemesNotifier() : super(_defaultThemes);

  static const List<PomodoroTheme> _defaultThemes = [
    PomodoroTheme(
      id: 'minimal_light',
      name: 'بسيط فاتح',
      style: ThemeStyle.minimal,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF03DAC6),
      backgroundColor: Color(0xFFFAFAFA),
      surfaceColor: Color(0xFFFFFFFF),
    ),
    PomodoroTheme(
      id: 'minimal_dark',
      name: 'بسيط داكن',
      style: ThemeStyle.minimal,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF03DAC6),
      backgroundColor: Color(0xFF121212),
      surfaceColor: Color(0xFF1E1E1E),
      isDark: true,
    ),
    PomodoroTheme(
      id: 'neon',
      name: 'نيون',
      style: ThemeStyle.neon,
      primaryColor: Color(0xFF00FFFF),
      secondaryColor: Color(0xFFFF007F),
      backgroundColor: Color(0xFF0A0A0A),
      surfaceColor: Color(0xFF1A1A1A),
      isDark: true,
    ),
    PomodoroTheme(
      id: 'nature',
      name: 'طبيعي',
      style: ThemeStyle.nature,
      primaryColor: Color(0xFF4CAF50),
      secondaryColor: Color(0xFF8BC34A),
      backgroundColor: Color(0xFFF1F8E9),
      surfaceColor: Color(0xFFFFFFFF),
    ),
  ];

  PomodoroTheme? get currentTheme => state.isNotEmpty ? state.first : null;

  void setTheme(String themeId) {
    final theme = state.firstWhere((t) => t.id == themeId);
    state = [theme, ...state.where((t) => t.id != themeId)];
  }
}

// مزود الثيم النشط
final activePomodoroThemeProvider = Provider<PomodoroTheme?>((ref) {
  final themes = ref.watch(pomodoroThemesProvider);
  return themes.isNotEmpty ? themes.first : null;
});

// مزود تفاصيل المهمة
final taskDetailsProvider = Provider.family<AdvancedTask?, String>((ref, taskId) {
  final tasks = ref.watch(advancedTasksProvider);
  try {
    return tasks.firstWhere((task) => task.id == taskId);
  } catch (e) {
    return null;
  }
});

// مزود تقدم المهمة
final taskProgressProvider = Provider.family<double, String>((ref, taskId) {
  final task = ref.watch(taskDetailsProvider(taskId));
  return task?.completionPercentage ?? 0.0;
});

// مزود عدد Pomodoro للمهمة
final taskPomodoroCountProvider = Provider.family<int, String>((ref, taskId) {
  final task = ref.watch(taskDetailsProvider(taskId));
  return task?.pomodoroSessions ?? 0;
});

/// فئات مساعدة

class TaskFilter {

  const TaskFilter({
    this.status,
    this.priority,
    this.tags = const [],
    this.projectId,
    this.sortBy = TaskSortBy.dueDate,
    this.ascending = true,
  });
  final TaskStatus? status;
  final TaskPriority? priority;
  final List<String> tags;
  final String? projectId;
  final TaskSortBy sortBy;
  final bool ascending;

  TaskFilter copyWith({
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? tags,
    String? projectId,
    TaskSortBy? sortBy,
    bool? ascending,
  }) {
    return TaskFilter(
      status: status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      projectId: projectId,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

class TaskStats {

  const TaskStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.overdueTasks,
    required this.highPriorityTasks,
  });
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int overdueTasks;
  final int highPriorityTasks;

  double get completionRate {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }

  double get overdueRate {
    if (totalTasks == 0) return 0.0;
    return (overdueTasks / totalTasks) * 100;
  }
}

/// مزودي الأداء والتحليل

// مزود تحليل الإنتاجية
final productivityAnalysisProvider = Provider<ProductivityAnalysis>((ref) {
  final stats = ref.watch(pomodoroStatsProvider);
  final weeklyStats = ref.read(pomodoroStatsProvider.notifier).getWeeklyStats();
  
  final weeklyAvg = weeklyStats.isNotEmpty 
      ? weeklyStats.fold<double>(0.0, (sum, stat) => sum + stat.productivityScore) / weeklyStats.length
      : 0.0;
  
  return ProductivityAnalysis(
    todayScore: stats.productivityScore,
    weeklyAverage: weeklyAvg,
    streak: stats.streakDays,
    totalFocusTime: stats.totalFocusTime,
    sessionCompletionRate: stats.sessionCompletionRate,
    averageScore: (stats.productivityScore + weeklyAvg) / 2,
  );
});

class ProductivityAnalysis { // متوسط النقاط

  const ProductivityAnalysis({
    required this.todayScore,
    required this.weeklyAverage,
    required this.streak,
    required this.totalFocusTime,
    required this.sessionCompletionRate,
    required this.averageScore,
  });
  final double todayScore;
  final double weeklyAverage;
  final int streak;
  final Duration totalFocusTime;
  final double sessionCompletionRate;
  final double averageScore;

  bool get isImproving => todayScore > weeklyAverage;
  
  String get performanceLevel {
    if (todayScore >= 80) return 'ممتاز';
    if (todayScore >= 60) return 'جيد';
    if (todayScore >= 40) return 'متوسط';
    return 'يحتاج تحسين';
  }
}

// مزود التوصيات الذكية
final smartRecommendationsProvider = Provider<List<SmartRecommendation>>((ref) {
  final analysis = ref.watch(productivityAnalysisProvider);
  final overdueTasks = ref.watch(overdueTasksProvider);
  final settings = ref.watch(pomodoroSettingsProvider);
  
  final recommendations = <SmartRecommendation>[];
  
  // توصيات بناء على الأداء
  if (analysis.todayScore < 40) {
    recommendations.add(const SmartRecommendation(
      title: 'تحسين التركيز',
      description: 'جرب تقليل مدة الجلسات إلى 20 دقيقة',
      type: RecommendationType.focusImprovement,
      priority: 3,
    ));
  }
  
  // توصيات للمهام المتأخرة
  if (overdueTasks.isNotEmpty) {
    recommendations.add(SmartRecommendation(
      title: 'مهام متأخرة',
      description: 'لديك ${overdueTasks.length} مهام متأخرة تحتاج اهتمام',
      type: RecommendationType.taskManagement,
      priority: 4,
    ));
  }
  
  // توصيات للإعدادات
  if (!settings.enableNotifications) {
    recommendations.add(const SmartRecommendation(
      title: 'تفعيل الإشعارات',
      description: 'الإشعارات تساعد في الالتزام بالجلسات',
      type: RecommendationType.settings,
      priority: 2,
    ));
  }
  
  return recommendations..sort((a, b) => b.priority.compareTo(a.priority));
});

class SmartRecommendation { // 1-5

  const SmartRecommendation({
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
  });
  final String title;
  final String description;
  final RecommendationType type;
  final int priority;
}

enum RecommendationType {
  focusImprovement,
  taskManagement,
  settings,
  health,
  productivity,
}