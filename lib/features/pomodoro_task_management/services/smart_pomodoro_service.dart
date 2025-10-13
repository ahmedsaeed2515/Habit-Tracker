import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../core/services/ai_service.dart';
import '../../../core/services/health_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/pomodoro_models.dart';

/// خدمة Pomodoro الذكية مع ميزات AI متقدمة
class SmartPomodoroService {
  static const String _sessionsBoxName = 'pomodoro_sessions';
  static const String _tasksBoxName = 'pomodoro_tasks';
  static const String _statsBoxName = 'pomodoro_stats';
  static const String _settingsBoxName = 'pomodoro_settings';
  static const String _achievementsBoxName = 'achievements';
  static const String _multiTimersBoxName = 'multi_timers';

  final NotificationService _notificationService = NotificationService();
  final AIService _aiService = AIService();
  final HealthService _healthService = HealthService();

  Timer? _sessionTimer;
  Timer? _backgroundTimer;
  StreamController<PomodoroSession>? _sessionController;
  StreamController<PomodoroStats>? _statsController;

  // Getters للـBoxes - استخدام dynamic box وcast عند الحاجة
  Box<dynamic> get _sessionsBox => Hive.box(_sessionsBoxName);
  Box<dynamic> get _tasksBox => Hive.box(_tasksBoxName);
  Box<dynamic> get _statsBox => Hive.box(_statsBoxName);
  Box<dynamic> get _settingsBox => Hive.box(_settingsBoxName);
  Box<dynamic> get _achievementsBox => Hive.box(_achievementsBoxName);
  Box<dynamic> get _multiTimersBox => Hive.box(_multiTimersBoxName);

  // Streams
  Stream<PomodoroSession> get sessionStream =>
      _sessionController?.stream ?? const Stream.empty();
  Stream<PomodoroStats> get statsStream =>
      _statsController?.stream ?? const Stream.empty();

  /// تهيئة الخدمة
  Future<void> initialize() async {
    // الصناديق مفتوحة بالفعل في DatabaseManager
    _sessionController = StreamController<PomodoroSession>.broadcast();
    _statsController = StreamController<PomodoroStats>.broadcast();

    // تهيئة الإعدادات الافتراضية
    await _initializeDefaultSettings();

    // تهيئة الإنجازات الافتراضية
    await _initializeAchievements();

    // استئناف الجلسة النشطة إن وجدت
    await _resumeActiveSession();
  }

  /// إنشاء جلسة Pomodoro جديدة
  Future<PomodoroSession> createSession({
    required SessionType type,
    Duration? customDuration,
    String? taskId,
  }) async {
    final settings = getSettings();
    Duration duration;

    switch (type) {
      case SessionType.focus:
        duration = customDuration ?? settings.focusSession;
        break;
      case SessionType.shortBreak:
        duration = customDuration ?? settings.shortBreak;
        break;
      case SessionType.longBreak:
        duration = customDuration ?? settings.longBreak;
        break;
      case SessionType.custom:
        duration = customDuration ?? const Duration(minutes: 25);
        break;
    }

    final session = PomodoroSession(
      id: _generateId(),
      taskId: taskId,
      type: type,
      duration: duration,
      startTime: DateTime.now(),
      status: SessionStatus.waiting,
      cycleNumber: _getCurrentCycleNumber(),
    );

    await _sessionsBox.put(session.id, session);
    return session;
  }

  /// بدء الجلسة
  Future<void> startSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null) return;

    final updatedSession = session.copyWith(
      status: SessionStatus.active,
      startTime: DateTime.now(),
    );

    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    // بدء التايمر
    _startSessionTimer(updatedSession);

    // إشعار البداية
    await _sendSessionNotification(
      updatedSession,
      'بدأت جلسة ${_getSessionTypeText(updatedSession.type)}',
    );

    // تحديث الإحصائيات
    await _updateStats();
  }

  /// إيقاف الجلسة مؤقتاً
  Future<void> pauseSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null || session.status != SessionStatus.active) return;

    final updatedSession = session.copyWith(status: SessionStatus.paused);
    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    _sessionTimer?.cancel();
  }

  /// استئناف الجلسة
  Future<void> resumeSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null || session.status != SessionStatus.paused) return;

    final updatedSession = session.copyWith(status: SessionStatus.active);
    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    _startSessionTimer(updatedSession);
  }

  /// إنهاء الجلسة
  Future<void> completeSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null) return;

    final now = DateTime.now();
    final actualDuration = now.difference(session.startTime);

    final updatedSession = session.copyWith(
      status: SessionStatus.completed,
      endTime: now,
      isCompleted: true,
      actualDuration: actualDuration,
    );

    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    _sessionTimer?.cancel();

    // تحديث إحصائيات المهمة
    if (session.taskId != null) {
      await _updateTaskStats(session.taskId!, actualDuration);
    }

    // إشعار الانتهاء
    await _sendSessionNotification(
      updatedSession,
      'انتهت جلسة ${_getSessionTypeText(updatedSession.type)}',
    );

    // تحديث الإحصائيات
    await _updateStats();

    // فحص الإنجازات
    await _checkAchievements();

    // بدء الجلسة التالية تلقائياً إذا كان مفعلاً
    await _autoStartNextSession(updatedSession);
  }

  /// تخطي الجلسة
  Future<void> skipSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null) return;

    final updatedSession = session.copyWith(
      status: SessionStatus.skipped,
      endTime: DateTime.now(),
    );

    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    _sessionTimer?.cancel();
    await _updateStats();
  }

  /// إلغاء الجلسة
  Future<void> cancelSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId) as PomodoroSession?;
    if (session == null) return;

    final updatedSession = session.copyWith(
      status: SessionStatus.cancelled,
      endTime: DateTime.now(),
    );

    await _sessionsBox.put(sessionId, updatedSession);
    _sessionController?.add(updatedSession);

    _sessionTimer?.cancel();
  }

  /// إنشاء مهمة متقدمة
  Future<AdvancedTask> createTask({
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
    final task = AdvancedTask(
      id: _generateId(),
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
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _tasksBox.put(task.id, task);

    // تحديث تقدير الوقت باستخدام AI
    await _updateAITimeEstimation(task.id);

    return task;
  }

  /// تحديث المهمة
  Future<void> updateTask(String taskId, AdvancedTask updatedTask) async {
    final task = updatedTask.copyWith(updatedAt: DateTime.now());
    await _tasksBox.put(taskId, task);
  }

  /// حذف المهمة
  Future<void> deleteTask(String taskId) async {
    await _tasksBox.delete(taskId);

    // حذف الجلسات المرتبطة
    final sessions = _sessionsBox.values
        .cast<PomodoroSession>()
        .where((s) => s.taskId == taskId)
        .toList();
    for (final session in sessions) {
      await _sessionsBox.delete(session.id);
    }
  }

  /// إكمال المهمة
  Future<void> completeTask(String taskId) async {
    final task = _tasksBox.get(taskId);
    if (task == null) return;

    final updatedTask = task.copyWith(
      status: TaskStatus.completed,
      updatedAt: DateTime.now(),
    );

    await updateTask(taskId, updatedTask);
    await _updateStats();
    await _checkAchievements();
  }

  /// إنشاء تايمر متعدد
  Future<MultiTimer> createMultiTimer({
    required String name,
    required List<PomodoroSession> sessions,
  }) async {
    final multiTimer = MultiTimer(
      id: _generateId(),
      name: name,
      sessions: sessions,
    );

    await _multiTimersBox.put(multiTimer.id, multiTimer);
    return multiTimer;
  }

  /// بدء التايمر المتعدد
  Future<void> startMultiTimer(String timerId) async {
    final timer = _multiTimersBox.get(timerId);
    if (timer == null || timer.sessions.isEmpty) return;

    final updatedTimer = timer.copyWith(
      isActive: true,
      startedAt: DateTime.now(),
    );

    await _multiTimersBox.put(timerId, updatedTimer);

    // بدء أول جلسة
    final firstSession = timer.sessions.first;
    await _sessionsBox.put(firstSession.id, firstSession);
    await startSession(firstSession.id);
  }

  /// الحصول على اقتراحات AI للمهام
  Future<List<AITaskSuggestion>> getAITaskSuggestions(String taskId) async {
    final task = _tasksBox.get(taskId);
    if (task == null) return [];

    final suggestions = <AITaskSuggestion>[];

    // اقتراح تقسيم المهمة
    if (task.subtasks.isEmpty &&
        task.estimatedDuration != null &&
        task.estimatedDuration!.inMinutes > 90) {
      suggestions.add(
        AITaskSuggestion(
          id: _generateId(),
          taskId: taskId,
          type: SuggestionType.taskBreakdown,
          suggestion:
              'يُنصح بتقسيم هذه المهمة إلى مهام فرعية أصغر لسهولة الإدارة',
          confidence: 0.8,
          reasons: [
            'المهمة طويلة (${task.estimatedDuration!.inMinutes} دقيقة)',
            'لا توجد مهام فرعية',
          ],
          createdAt: DateTime.now(),
        ),
      );
    }

    // اقتراح الأولوية
    if (task.dueDate != null && task.priority == TaskPriority.medium) {
      final daysUntilDue = task.dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 2) {
        suggestions.add(
          AITaskSuggestion(
            id: _generateId(),
            taskId: taskId,
            type: SuggestionType.taskPriority,
            suggestion:
                'يُنصح برفع أولوية هذه المهمة إلى عالية نظراً لقرب موعد التسليم',
            confidence: 0.9,
            reasons: [
              'موعد التسليم خلال $daysUntilDue يوم',
              'الأولوية الحالية متوسطة',
            ],
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    // اقتراح تقدير الوقت
    if (task.estimatedDuration == null) {
      final similarTasks = _findSimilarTasks(task);
      if (similarTasks.isNotEmpty) {
        final avgDuration = _calculateAverageDuration(similarTasks);
        suggestions.add(
          AITaskSuggestion(
            id: _generateId(),
            taskId: taskId,
            type: SuggestionType.timeEstimation,
            suggestion:
                'بناءً على المهام المماثلة، الوقت المقدر: ${avgDuration.inMinutes} دقيقة',
            confidence: 0.7,
            reasons: ['تحليل ${similarTasks.length} مهمة مماثلة'],
            data: {'estimatedDuration': avgDuration.inMinutes},
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    return suggestions;
  }

  /// الحصول على اقتراحات الاستراحة
  List<BreakSuggestion> getBreakSuggestions() {
    return [
      const BreakSuggestion(
        id: 'stretch_basic',
        title: 'تمدد أساسي',
        description: 'تمارين تمدد بسيطة للرقبة والكتفين',
        duration: Duration(minutes: 3),
        type: BreakType.stretch,
        instructions: [
          'اجلس بشكل مستقيم',
          'أدر رأسك يميناً ويساراً ببطء',
          'ارفع كتفيك لأعلى واخفضهما',
          'مد ذراعيك فوق رأسك',
        ],
      ),
      const BreakSuggestion(
        id: 'hydration',
        title: 'شرب الماء',
        description: 'وقت شرب الماء للحفاظ على الترطيب',
        duration: Duration(minutes: 2),
        type: BreakType.hydration,
        instructions: ['احضر كوب ماء', 'اشرب ببطء', 'تنفس بعمق'],
      ),
      const BreakSuggestion(
        id: 'eye_rest',
        title: 'راحة العين',
        description: 'تمارين للعين لتقليل الإجهاد',
        duration: Duration(minutes: 2),
        type: BreakType.eyeRest,
        instructions: [
          'انظر بعيداً عن الشاشة',
          'ركز على نقطة بعيدة لمدة 20 ثانية',
          'أغلق عينيك وافتحهما عدة مرات',
          'قم بحركات دائرية بالعينين',
        ],
      ),
    ];
  }

  /// فلترة وترتيب المهام
  List<AdvancedTask> filterAndSortTasks({
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? tags,
    String? projectId,
    TaskSortBy sortBy = TaskSortBy.dueDate,
    bool ascending = true,
  }) {
    var tasks = _tasksBox.values.cast<AdvancedTask>().toList();

    // التصفية
    if (status != null) {
      tasks = tasks.where((t) => t.status == status).toList();
    }
    if (priority != null) {
      tasks = tasks.where((t) => t.priority == priority).toList();
    }
    if (tags != null && tags.isNotEmpty) {
      tasks = tasks
          .where((t) => tags.any((tag) => t.tags.contains(tag)))
          .toList();
    }
    if (projectId != null) {
      tasks = tasks.where((t) => t.projectId == projectId).toList();
    }

    // الترتيب
    tasks.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case TaskSortBy.dueDate:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          comparison = a.dueDate!.compareTo(b.dueDate!);
          break;
        case TaskSortBy.priority:
          comparison = _priorityToInt(
            a.priority,
          ).compareTo(_priorityToInt(b.priority));
          break;
        case TaskSortBy.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TaskSortBy.title:
          comparison = a.title.compareTo(b.title);
          break;
        case TaskSortBy.progress:
          comparison = a.completionPercentage.compareTo(b.completionPercentage);
          break;
      }
      return ascending ? comparison : -comparison;
    });

    return tasks;
  }

  /// الحصول على الإحصائيات
  PomodoroStats getTodayStats() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    return _statsBox.get(todayKey) ?? PomodoroStats(id: todayKey, date: today);
  }

  /// الحصول على إحصائيات الأسبوع
  List<PomodoroStats> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final weeklyStats = <PomodoroStats>[];
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      final stats = _statsBox.get(key) ?? PomodoroStats(id: key, date: date);
      weeklyStats.add(stats);
    }

    return weeklyStats;
  }

  /// الحصول على إحصائيات الشهر
  PomodoroStats getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    // تجميع إحصائيات الشهر
    int totalSessions = 0;
    int totalSkipped = 0;
    Duration totalFocus = Duration.zero;
    Duration totalBreak = Duration.zero;
    int totalTasks = 0;
    double totalProductivity = 0.0;
    int daysCount = 0;

    for (int i = 1; i <= monthEnd.day; i++) {
      final date = DateTime(now.year, now.month, i);
      final key = '${date.year}-${date.month}-${date.day}';
      final stats = _statsBox.get(key);

      if (stats != null) {
        totalSessions = totalSessions + (stats.completedSessions as int);
        totalSkipped = totalSkipped + (stats.skippedSessions as int);
        totalFocus += stats.totalFocusTime;
        totalBreak += stats.totalBreakTime;
        totalTasks = totalTasks + (stats.completedTasks as int);
        totalProductivity += stats.productivityScore;
        daysCount++;
      }
    }

    return PomodoroStats(
      id: '${now.year}-${now.month}',
      date: monthStart,
      completedSessions: totalSessions,
      skippedSessions: totalSkipped,
      totalFocusTime: totalFocus,
      totalBreakTime: totalBreak,
      completedTasks: totalTasks,
      productivityScore: daysCount > 0 ? totalProductivity / daysCount : 0.0,
    );
  }

  /// الحصول على إحصائيات السنة
  PomodoroStats getYearlyStats() {
    final now = DateTime.now();
    final yearStart = DateTime(now.year);

    // تجميع إحصائيات السنة
    int totalSessions = 0;
    int totalSkipped = 0;
    Duration totalFocus = Duration.zero;
    Duration totalBreak = Duration.zero;
    int totalTasks = 0;
    double totalProductivity = 0.0;
    int monthsCount = 0;

    for (int month = 1; month <= 12; month++) {
      final monthEnd = DateTime(now.year, month + 1, 0);
      bool hasData = false;

      for (int day = 1; day <= monthEnd.day; day++) {
        final date = DateTime(now.year, month, day);
        final key = '${date.year}-${date.month}-${date.day}';
        final stats = _statsBox.get(key);

        if (stats != null) {
          totalSessions = totalSessions + (stats.completedSessions as int);
          totalSkipped = totalSkipped + (stats.skippedSessions as int);
          totalFocus += stats.totalFocusTime;
          totalBreak += stats.totalBreakTime;
          totalTasks = totalTasks + (stats.completedTasks as int);
          totalProductivity += stats.productivityScore;
          hasData = true;
        }
      }

      if (hasData) monthsCount++;
    }

    return PomodoroStats(
      id: now.year.toString(),
      date: yearStart,
      completedSessions: totalSessions,
      skippedSessions: totalSkipped,
      totalFocusTime: totalFocus,
      totalBreakTime: totalBreak,
      completedTasks: totalTasks,
      productivityScore: monthsCount > 0
          ? totalProductivity / monthsCount
          : 0.0,
    );
  }

  /// الحصول على الإعدادات
  PomodoroSettings getSettings() {
    return _settingsBox.get('settings') as PomodoroSettings? ??
        const PomodoroSettings();
  }

  /// تحديث الإعدادات
  Future<void> updateSettings(PomodoroSettings settings) async {
    await _settingsBox.put('settings', settings);
  }

  /// الحصول على الإنجازات
  List<Achievement> getAchievements() {
    return _achievementsBox.values.cast<Achievement>().toList();
  }

  /// الحصول على الإنجازات المفتوحة
  List<Achievement> getUnlockedAchievements() {
    return _achievementsBox.values
        .cast<Achievement>()
        .where((a) => a.isUnlocked)
        .toList();
  }

  /// تصدير البيانات
  Future<Map<String, dynamic>> exportData() async {
    return {
      'sessions': _sessionsBox.values.map((s) => s.toJson()).toList(),
      'tasks': _tasksBox.values.map((t) => t.toJson()).toList(),
      'stats': _statsBox.values.map((s) => s.toJson()).toList(),
      'settings': getSettings().toJson(),
      'achievements': _achievementsBox.values.map((a) => a.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  /// استيراد البيانات
  Future<void> importData(Map<String, dynamic> data) async {
    // تنفيذ منطق الاستيراد
    // هذا يتطلب تحويل البيانات من JSON وحفظها في Hive
  }

  // الطرق المساعدة الخاصة

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  int _getCurrentCycleNumber() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todaySessions = _sessionsBox.values
        .where(
          (s) => s.startTime.isAfter(todayStart) && s.type == SessionType.focus,
        )
        .length;
    return (todaySessions ~/ 4) + 1;
  }

  void _startSessionTimer(PomodoroSession session) {
    _sessionTimer?.cancel();

    final remainingTime = session.remainingTime;
    if (remainingTime <= Duration.zero) {
      completeSession(session.id);
      return;
    }

    _sessionTimer = Timer(remainingTime, () {
      completeSession(session.id);
    });

    // تايمر للتحديثات المتكررة
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _sessionController?.add(session);
    });
  }

  Future<void> _sendSessionNotification(
    PomodoroSession session,
    String message,
  ) async {
    if (!getSettings().enableNotifications) return;

    await _notificationService.showNotification(
      title: 'Pomodoro Timer',
      body: message,
      payload: session.id,
    );
  }

  String _getSessionTypeText(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return 'التركيز';
      case SessionType.shortBreak:
        return 'الاستراحة القصيرة';
      case SessionType.longBreak:
        return 'الاستراحة الطويلة';
      case SessionType.custom:
        return 'المخصص';
    }
  }

  Future<void> _updateStats() async {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    final currentStats =
        _statsBox.get(todayKey) ?? PomodoroStats(id: todayKey, date: today);

    // حساب الإحصائيات الجديدة
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final todaySessions = _sessionsBox.values
        .where(
          (s) =>
              s.startTime.isAfter(todayStart) && s.startTime.isBefore(todayEnd),
        )
        .toList();

    final completedSessions = todaySessions.where((s) => s.isCompleted).length;
    final skippedSessions = todaySessions
        .where((s) => s.status == SessionStatus.skipped)
        .length;

    final totalFocusTime = todaySessions
        .where((s) => s.type == SessionType.focus && s.isCompleted)
        .fold<Duration>(
          Duration.zero,
          (total, s) => total + (s.actualDuration ?? s.duration),
        );

    final totalBreakTime = todaySessions
        .where(
          (s) =>
              (s.type == SessionType.shortBreak ||
                  s.type == SessionType.longBreak) &&
              s.isCompleted,
        )
        .fold<Duration>(
          Duration.zero,
          (total, s) => total + (s.actualDuration ?? s.duration),
        );

    final completedTasks = _tasksBox.values
        .where(
          (t) =>
              t.status == TaskStatus.completed &&
              t.updatedAt.isAfter(todayStart) &&
              t.updatedAt.isBefore(todayEnd),
        )
        .length;

    final streakDays = _calculateStreakDays();
    final productivityScore = _calculateProductivityScore();

    final updatedStats = currentStats.copyWith(
      completedSessions: completedSessions,
      skippedSessions: skippedSessions,
      totalFocusTime: totalFocusTime,
      totalBreakTime: totalBreakTime,
      completedTasks: completedTasks,
      streakDays: streakDays,
      productivityScore: productivityScore,
    );

    await _statsBox.put(todayKey, updatedStats);
    _statsController?.add(updatedStats);
  }

  int _calculateStreakDays() {
    // حساب أيام السلسلة المتتالية
    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (true) {
      final key = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      final dayStats = _statsBox.get(key);

      if (dayStats == null || dayStats.completedSessions == 0) {
        break;
      }

      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  double _calculateProductivityScore() {
    final todayStats = getTodayStats();
    double score = 0.0;

    // نقاط للجلسات المكتملة
    score += todayStats.completedSessions * 10.0;

    // خصم للجلسات المتخطاة
    score -= todayStats.skippedSessions * 5.0;

    // نقاط للمهام المكتملة
    score += todayStats.completedTasks * 15.0;

    // نقاط لوقت التركيز
    score += todayStats.totalFocusTime.inMinutes * 0.5;

    return math.max(0.0, math.min(100.0, score));
  }

  Future<void> _updateTaskStats(String taskId, Duration actualDuration) async {
    final task = _tasksBox.get(taskId);
    if (task == null) return;

    final updatedTask = task.copyWith(
      actualDuration: task.actualDuration + actualDuration,
      pomodoroSessions: task.pomodoroSessions + 1,
      updatedAt: DateTime.now(),
    );

    await updateTask(taskId, updatedTask);
  }

  Future<void> _checkAchievements() async {
    final achievements = _achievementsBox.values.toList();
    final stats = getTodayStats();

    for (final achievement in achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;
      int newValue = achievement.currentValue;

      switch (achievement.type) {
        case AchievementType.sessionsCompleted:
          newValue = stats.completedSessions;
          shouldUnlock = newValue >= achievement.targetValue;
          break;
        case AchievementType.focusTime:
          newValue = stats.totalFocusTime.inMinutes;
          shouldUnlock = newValue >= achievement.targetValue;
          break;
        case AchievementType.tasksCompleted:
          newValue = stats.completedTasks;
          shouldUnlock = newValue >= achievement.targetValue;
          break;
        case AchievementType.streak:
          newValue = stats.streakDays;
          shouldUnlock = newValue >= achievement.targetValue;
          break;
        case AchievementType.productivity:
          newValue = stats.productivityScore.round();
          shouldUnlock = newValue >= achievement.targetValue;
          break;
        default:
          break;
      }

      if (shouldUnlock) {
        final unlockedAchievement = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
          currentValue: newValue,
        );

        await _achievementsBox.put(achievement.id, unlockedAchievement);

        // إشعار فتح الإنجاز
        await _notificationService.showNotification(
          title: 'إنجاز جديد! 🏆',
          body: achievement.title,
        );
      } else if (newValue != achievement.currentValue) {
        final updatedAchievement = achievement.copyWith(currentValue: newValue);
        await _achievementsBox.put(achievement.id, updatedAchievement);
      }
    }
  }

  Future<void> _autoStartNextSession(PomodoroSession completedSession) async {
    final settings = getSettings();
    if (!settings.autoStartBreaks && !settings.autoStartFocus) return;

    SessionType? nextType;

    if (completedSession.type == SessionType.focus) {
      if (settings.autoStartBreaks) {
        // تحديد نوع الاستراحة
        final isLongBreak =
            completedSession.cycleNumber % settings.longBreakInterval == 0;
        nextType = isLongBreak ? SessionType.longBreak : SessionType.shortBreak;
      }
    } else if (completedSession.type == SessionType.shortBreak ||
        completedSession.type == SessionType.longBreak) {
      if (settings.autoStartFocus) {
        nextType = SessionType.focus;
      }
    }

    if (nextType != null) {
      final nextSession = await createSession(
        type: nextType,
        taskId: completedSession.taskId,
      );

      // تأخير قصير قبل البدء التلقائي
      await Future.delayed(const Duration(seconds: 3));
      await startSession(nextSession.id);
    }
  }

  List<AdvancedTask> _findSimilarTasks(AdvancedTask task) {
    return _tasksBox.values
        .cast<AdvancedTask>()
        .where(
          (t) =>
              t.id != task.id &&
              t.actualDuration > Duration.zero &&
              (t.tags.any((tag) => task.tags.contains(tag)) ||
                  t.priority == task.priority),
        )
        .toList();
  }

  Duration _calculateAverageDuration(List<AdvancedTask> tasks) {
    if (tasks.isEmpty) return Duration.zero;

    final totalMinutes = tasks.fold<int>(
      0,
      (sum, task) => sum + task.actualDuration.inMinutes,
    );

    return Duration(minutes: totalMinutes ~/ tasks.length);
  }

  Future<void> _updateAITimeEstimation(String taskId) async {
    final task = _tasksBox.get(taskId);
    if (task == null || task.estimatedDuration != null) return;

    // استخدام AI لتقدير الوقت
    final similarTasks = _findSimilarTasks(task);
    if (similarTasks.isNotEmpty) {
      final estimatedDuration = _calculateAverageDuration(similarTasks);
      final updatedTask = task.copyWith(estimatedDuration: estimatedDuration);
      await updateTask(taskId, updatedTask);
    }
  }

  int _priorityToInt(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return 4;
      case TaskPriority.high:
        return 3;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
    }
  }

  Future<void> _initializeDefaultSettings() async {
    if (_settingsBox.get('settings') == null) {
      await updateSettings(const PomodoroSettings());
    }
  }

  Future<void> _initializeAchievements() async {
    if (_achievementsBox.isEmpty) {
      final defaultAchievements = [
        const Achievement(
          id: 'first_session',
          title: 'أول جلسة',
          description: 'أكمل أول جلسة تركيز',
          icon: '🎯',
          type: AchievementType.sessionsCompleted,
          targetValue: 1,
          color: Colors.blue,
        ),
        const Achievement(
          id: 'focus_hour',
          title: 'ساعة تركيز',
          description: 'اجمع 60 دقيقة من التركيز في يوم واحد',
          icon: '⏰',
          type: AchievementType.focusTime,
          targetValue: 60,
          color: Colors.green,
          points: 25,
        ),
        const Achievement(
          id: 'task_master',
          title: 'سيد المهام',
          description: 'أكمل 10 مهام في يوم واحد',
          icon: '✅',
          type: AchievementType.tasksCompleted,
          targetValue: 10,
          color: Colors.purple,
          points: 50,
        ),
        const Achievement(
          id: 'week_streak',
          title: 'أسبوع متواصل',
          description: 'حافظ على التركيز لمدة 7 أيام متتالية',
          icon: '🔥',
          type: AchievementType.streak,
          targetValue: 7,
          color: Colors.orange,
          points: 100,
        ),
      ];

      for (final achievement in defaultAchievements) {
        await _achievementsBox.put(achievement.id, achievement);
      }
    }
  }

  Future<void> _resumeActiveSession() async {
    final activeSessions = _sessionsBox.values
        .where((s) => s.status == SessionStatus.active)
        .toList();

    if (activeSessions.isNotEmpty) {
      final session = activeSessions.first;
      _startSessionTimer(session);
    }
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    _sessionTimer?.cancel();
    _backgroundTimer?.cancel();
    await _sessionController?.close();
    await _statsController?.close();
  }
}

/// أنواع ترتيب المهام
enum TaskSortBy {
  dueDate, // تاريخ الاستحقاق
  priority, // الأولوية
  createdAt, // تاريخ الإنشاء
  title, // العنوان
  progress, // التقدم
}

/// امتدادات مفيدة
extension AdvancedTaskExtensions on AdvancedTask {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'tags': tags,
      'dueDate': dueDate?.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
      'estimatedDuration': estimatedDuration?.inMinutes,
      'actualDuration': actualDuration.inMinutes,
      'status': status.index,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
      'projectId': projectId,
      'collaborators': collaborators,
      'pomodoroSessions': pomodoroSessions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

extension SubtaskExtensions on Subtask {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'estimatedDuration': estimatedDuration?.inMinutes,
      'order': order,
    };
  }
}

extension PomodoroSessionExtensions on PomodoroSession {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'type': type.index,
      'duration': duration.inMinutes,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.index,
      'isCompleted': isCompleted,
      'actualDuration': actualDuration?.inMinutes,
      'cycleNumber': cycleNumber,
      'metadata': metadata,
    };
  }
}

extension PomodoroStatsExtensions on PomodoroStats {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'completedSessions': completedSessions,
      'skippedSessions': skippedSessions,
      'totalFocusTime': totalFocusTime.inMinutes,
      'totalBreakTime': totalBreakTime.inMinutes,
      'completedTasks': completedTasks,
      'streakDays': streakDays,
      'productivityScore': productivityScore,
      'tagStats': tagStats,
      'priorityStats': priorityStats.map((k, v) => MapEntry(k.index, v)),
    };
  }
}

extension PomodoroSettingsExtensions on PomodoroSettings {
  Map<String, dynamic> toJson() {
    return {
      'focusSession': focusSession.inMinutes,
      'shortBreak': shortBreak.inMinutes,
      'longBreak': longBreak.inMinutes,
      'longBreakInterval': longBreakInterval,
      'autoStartBreaks': autoStartBreaks,
      'autoStartFocus': autoStartFocus,
      'enableNotifications': enableNotifications,
      'enableBackgroundMode': enableBackgroundMode,
      'focusSound': focusSound,
      'breakSound': breakSound,
      'soundVolume': soundVolume,
      'enableVibration': enableVibration,
      'motivationalQuotes': motivationalQuotes,
      'customSettings': customSettings,
    };
  }
}

extension AchievementExtensions on Achievement {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type.index,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'color': color.value,
      'points': points,
    };
  }
}
