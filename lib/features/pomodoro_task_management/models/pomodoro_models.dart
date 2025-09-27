import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'pomodoro_models.g.dart';

/// نماذج نظام Pomodoro Task Management
/// TypeIds: 231-280

/// جلسة Pomodoro
@HiveType(typeId: 81)
class PomodoroSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? taskId; // ربط بالمهمة

  @HiveField(2)
  final SessionType type;

  @HiveField(3)
  final Duration duration;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final DateTime? endTime;

  @HiveField(6)
  final SessionStatus status;

  @HiveField(7)
  final bool isCompleted;

  @HiveField(8)
  final Duration? actualDuration; // المدة الفعلية

  @HiveField(9)
  final int cycleNumber; // رقم الدورة في السلسلة

  @HiveField(10)
  final Map<String, dynamic> metadata;

  const PomodoroSession({
    required this.id,
    this.taskId,
    required this.type,
    required this.duration,
    required this.startTime,
    this.endTime,
    required this.status,
    this.isCompleted = false,
    this.actualDuration,
    this.cycleNumber = 1,
    this.metadata = const {},
  });

  PomodoroSession copyWith({
    String? id,
    String? taskId,
    SessionType? type,
    Duration? duration,
    DateTime? startTime,
    DateTime? endTime,
    SessionStatus? status,
    bool? isCompleted,
    Duration? actualDuration,
    int? cycleNumber,
    Map<String, dynamic>? metadata,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      actualDuration: actualDuration ?? this.actualDuration,
      cycleNumber: cycleNumber ?? this.cycleNumber,
      metadata: metadata ?? this.metadata,
    );
  }

  Duration get remainingTime {
    if (status != SessionStatus.active || endTime == null) return duration;
    final elapsed = DateTime.now().difference(startTime);
    return duration - elapsed;
  }

  double get progress {
    if (status != SessionStatus.active) return isCompleted ? 1.0 : 0.0;
    final elapsed = DateTime.now().difference(startTime);
    return (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }
}

/// نوع الجلسة
@HiveType(typeId: 82)
enum SessionType {
  @HiveField(0)
  focus, // تركيز

  @HiveField(1)
  shortBreak, // استراحة قصيرة

  @HiveField(2)
  longBreak, // استراحة طويلة

  @HiveField(3)
  custom, // مخصص
}

/// حالة الجلسة
@HiveType(typeId: 83)
enum SessionStatus {
  @HiveField(0)
  waiting, // في الانتظار

  @HiveField(1)
  active, // نشط

  @HiveField(2)
  paused, // متوقف مؤقتاً

  @HiveField(3)
  completed, // مكتمل

  @HiveField(4)
  skipped, // تم التخطي

  @HiveField(5)
  cancelled, // ملغي
}

/// إعدادات Pomodoro
@HiveType(typeId: 84)
class PomodoroSettings {
  @HiveField(0)
  final Duration focusSession;

  @HiveField(1)
  final Duration shortBreak;

  @HiveField(2)
  final Duration longBreak;

  @HiveField(3)
  final int longBreakInterval; // بعد كم جلسة تركيز

  @HiveField(4)
  final bool autoStartBreaks;

  @HiveField(5)
  final bool autoStartFocus;

  @HiveField(6)
  final bool enableNotifications;

  @HiveField(7)
  final bool enableBackgroundMode;

  @HiveField(8)
  final String focusSound;

  @HiveField(9)
  final String breakSound;

  @HiveField(10)
  final double soundVolume;

  @HiveField(11)
  final bool enableVibration;

  @HiveField(12)
  final List<String> motivationalQuotes;

  @HiveField(13)
  final Map<String, dynamic> customSettings;

  @HiveField(14)
  final int dailyGoal; // هدف يومي لجلسات Pomodoro

  @HiveField(15)
  final bool taskReminders; // تذكيرات المهام

  @HiveField(16)
  final bool achievementNotifications; // إشعارات الإنجازات

  @HiveField(17)
  final String notificationSound; // صوت الإشعارات

  const PomodoroSettings({
    this.focusSession = const Duration(minutes: 25),
    this.shortBreak = const Duration(minutes: 5),
    this.longBreak = const Duration(minutes: 15),
    this.longBreakInterval = 4,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.enableNotifications = true,
    this.enableBackgroundMode = true,
    this.focusSound = 'default_focus.mp3',
    this.breakSound = 'default_break.mp3',
    this.soundVolume = 0.7,
    this.enableVibration = true,
    this.motivationalQuotes = const [],
    this.customSettings = const {},
    this.dailyGoal = 8,
    this.taskReminders = true,
    this.achievementNotifications = true,
    this.notificationSound = 'default_notification.mp3',
  });

  PomodoroSettings copyWith({
    Duration? focusSession,
    Duration? shortBreak,
    Duration? longBreak,
    int? longBreakInterval,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? enableNotifications,
    bool? enableBackgroundMode,
    String? focusSound,
    String? breakSound,
    double? soundVolume,
    bool? enableVibration,
    List<String>? motivationalQuotes,
    Map<String, dynamic>? customSettings,
    int? dailyGoal,
    bool? taskReminders,
    bool? achievementNotifications,
    String? notificationSound,
  }) {
    return PomodoroSettings(
      focusSession: focusSession ?? this.focusSession,
      shortBreak: shortBreak ?? this.shortBreak,
      longBreak: longBreak ?? this.longBreak,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableBackgroundMode: enableBackgroundMode ?? this.enableBackgroundMode,
      focusSound: focusSound ?? this.focusSound,
      breakSound: breakSound ?? this.breakSound,
      soundVolume: soundVolume ?? this.soundVolume,
      enableVibration: enableVibration ?? this.enableVibration,
      motivationalQuotes: motivationalQuotes ?? this.motivationalQuotes,
      customSettings: customSettings ?? this.customSettings,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      taskReminders: taskReminders ?? this.taskReminders,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      notificationSound: notificationSound ?? this.notificationSound,
    );
  }

  /// Getter methods for aliases used in widgets
  bool get autoStartBreak => autoStartBreaks;
  bool get backgroundMode => enableBackgroundMode;
  bool get soundEnabled => soundVolume > 0;
  bool get vibrateEnabled => enableVibration;
  bool get showNotifications => enableNotifications;
}

/// مهمة To-Do متقدمة
@HiveType(typeId: 85)
class AdvancedTask {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final TaskPriority priority;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final DateTime? reminderTime;

  @HiveField(7)
  final Duration? estimatedDuration;

  @HiveField(8)
  final Duration actualDuration;

  @HiveField(9)
  final TaskStatus status;

  @HiveField(10)
  final List<Subtask> subtasks;

  @HiveField(11)
  final RecurrenceRule? recurrence;

  @HiveField(12)
  final String? projectId;

  @HiveField(13)
  final List<String> collaborators;

  @HiveField(14)
  final int pomodoroSessions; // عدد جلسات Pomodoro المستخدمة

  @HiveField(15)
  final DateTime createdAt;

  @HiveField(16)
  final DateTime updatedAt;

  @HiveField(17)
  final Map<String, dynamic> metadata;

  const AdvancedTask({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.dueDate,
    this.reminderTime,
    this.estimatedDuration,
    this.actualDuration = Duration.zero,
    this.status = TaskStatus.pending,
    this.subtasks = const [],
    this.recurrence,
    this.projectId,
    this.collaborators = const [],
    this.pomodoroSessions = 0,
    required this.createdAt,
    required this.updatedAt,
    this.metadata = const {},
  });

  AdvancedTask copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    List<String>? tags,
    DateTime? dueDate,
    DateTime? reminderTime,
    Duration? estimatedDuration,
    Duration? actualDuration,
    TaskStatus? status,
    List<Subtask>? subtasks,
    RecurrenceRule? recurrence,
    String? projectId,
    List<String>? collaborators,
    int? pomodoroSessions,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AdvancedTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      status: status ?? this.status,
      subtasks: subtasks ?? this.subtasks,
      recurrence: recurrence ?? this.recurrence,
      projectId: projectId ?? this.projectId,
      collaborators: collaborators ?? this.collaborators,
      pomodoroSessions: pomodoroSessions ?? this.pomodoroSessions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  double get completionPercentage {
    if (subtasks.isEmpty) return status == TaskStatus.completed ? 100.0 : 0.0;
    final completedSubtasks = subtasks.where((s) => s.isCompleted).length;
    return (completedSubtasks / subtasks.length) * 100;
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != TaskStatus.completed;
  }

  Duration? get remainingTime {
    if (dueDate == null) return null;
    final now = DateTime.now();
    if (now.isAfter(dueDate!)) return Duration.zero;
    return dueDate!.difference(now);
  }

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.urgent:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}

/// أولوية المهمة
@HiveType(typeId: 86)
enum TaskPriority {
  @HiveField(0)
  urgent, // عاجل

  @HiveField(1)
  high, // عالي

  @HiveField(2)
  medium, // متوسط

  @HiveField(3)
  low, // منخفض
}

/// حالة المهمة
@HiveType(typeId: 87)
enum TaskStatus {
  @HiveField(0)
  pending, // في الانتظار

  @HiveField(1)
  inProgress, // قيد التنفيذ

  @HiveField(2)
  completed, // مكتملة

  @HiveField(3)
  cancelled, // ملغية

  @HiveField(4)
  onHold, // معلقة

  @HiveField(5)
  archived, // مؤرشفة
}

/// مهمة فرعية
@HiveType(typeId: 88)
class Subtask {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime? dueDate;

  @HiveField(4)
  final Duration? estimatedDuration;

  @HiveField(5)
  final int order; // ترتيب المهمة الفرعية

  const Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.estimatedDuration,
    this.order = 0,
  });

  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    Duration? estimatedDuration,
    int? order,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      order: order ?? this.order,
    );
  }
}

/// قاعدة التكرار
@HiveType(typeId: 89)
class RecurrenceRule {
  @HiveField(0)
  final RecurrenceType type;

  @HiveField(1)
  final int interval; // كل كم (يوم/أسبوع/شهر)

  @HiveField(2)
  final List<int> daysOfWeek; // أيام الأسبوع (1-7)

  @HiveField(3)
  final DateTime? endDate;

  @HiveField(4)
  final int? maxOccurrences;

  const RecurrenceRule({
    required this.type,
    this.interval = 1,
    this.daysOfWeek = const [],
    this.endDate,
    this.maxOccurrences,
  });

  RecurrenceRule copyWith({
    RecurrenceType? type,
    int? interval,
    List<int>? daysOfWeek,
    DateTime? endDate,
    int? maxOccurrences,
  }) {
    return RecurrenceRule(
      type: type ?? this.type,
      interval: interval ?? this.interval,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      endDate: endDate ?? this.endDate,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
    );
  }

  DateTime getNextOccurrence(DateTime from) {
    switch (type) {
      case RecurrenceType.daily:
        return from.add(Duration(days: interval));
      case RecurrenceType.weekly:
        return from.add(Duration(days: 7 * interval));
      case RecurrenceType.monthly:
        return DateTime(from.year, from.month + interval, from.day);
      case RecurrenceType.yearly:
        return DateTime(from.year + interval, from.month, from.day);
      case RecurrenceType.weekdays:
        DateTime next = from.add(const Duration(days: 1));
        while (next.weekday > 5) {
          // تخطي عطلة نهاية الأسبوع
          next = next.add(const Duration(days: 1));
        }
        return next;
      case RecurrenceType.custom:
        // منطق مخصص للأيام المحددة
        if (daysOfWeek.isNotEmpty) {
          DateTime next = from.add(const Duration(days: 1));
          while (!daysOfWeek.contains(next.weekday)) {
            next = next.add(const Duration(days: 1));
          }
          return next;
        }
        return from.add(Duration(days: interval));
    }
  }
}

/// نوع التكرار
@HiveType(typeId: 90)
enum RecurrenceType {
  @HiveField(0)
  daily, // يومي

  @HiveField(1)
  weekly, // أسبوعي

  @HiveField(2)
  monthly, // شهري

  @HiveField(3)
  yearly, // سنوي

  @HiveField(4)
  weekdays, // أيام الأسبوع فقط

  @HiveField(5)
  custom, // مخصص
}

/// مشروع
@HiveType(typeId: 91)
class Project {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final String? icon;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final ProjectStatus status;

  @HiveField(7)
  final List<String> memberIds;

  @HiveField(8)
  final bool isShared;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    this.icon,
    this.dueDate,
    this.status = ProjectStatus.active,
    this.memberIds = const [],
    this.isShared = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    String? icon,
    DateTime? dueDate,
    ProjectStatus? status,
    List<String>? memberIds,
    bool? isShared,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      memberIds: memberIds ?? this.memberIds,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// حالة المشروع
@HiveType(typeId: 92)
enum ProjectStatus {
  @HiveField(0)
  active, // نشط

  @HiveField(1)
  completed, // مكتمل

  @HiveField(2)
  onHold, // معلق

  @HiveField(3)
  cancelled, // ملغي

  @HiveField(4)
  archived, // مؤرشف
}

/// إحصائيات Pomodoro
@HiveType(typeId: 93)
class PomodoroStats {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int completedSessions;

  @HiveField(3)
  final int skippedSessions;

  @HiveField(4)
  final Duration totalFocusTime;

  @HiveField(5)
  final Duration totalBreakTime;

  @HiveField(6)
  final int completedTasks;

  @HiveField(7)
  final int streakDays;

  @HiveField(8)
  final double productivityScore; // 0-100

  @HiveField(9)
  final Map<String, int> tagStats; // إحصائيات بالتاقات

  @HiveField(10)
  final Map<TaskPriority, int> priorityStats;

  const PomodoroStats({
    required this.id,
    required this.date,
    this.completedSessions = 0,
    this.skippedSessions = 0,
    this.totalFocusTime = Duration.zero,
    this.totalBreakTime = Duration.zero,
    this.completedTasks = 0,
    this.streakDays = 0,
    this.productivityScore = 0.0,
    this.tagStats = const {},
    this.priorityStats = const {},
  });

  PomodoroStats copyWith({
    String? id,
    DateTime? date,
    int? completedSessions,
    int? skippedSessions,
    Duration? totalFocusTime,
    Duration? totalBreakTime,
    int? completedTasks,
    int? streakDays,
    double? productivityScore,
    Map<String, int>? tagStats,
    Map<TaskPriority, int>? priorityStats,
  }) {
    return PomodoroStats(
      id: id ?? this.id,
      date: date ?? this.date,
      completedSessions: completedSessions ?? this.completedSessions,
      skippedSessions: skippedSessions ?? this.skippedSessions,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      totalBreakTime: totalBreakTime ?? this.totalBreakTime,
      completedTasks: completedTasks ?? this.completedTasks,
      streakDays: streakDays ?? this.streakDays,
      productivityScore: productivityScore ?? this.productivityScore,
      tagStats: tagStats ?? this.tagStats,
      priorityStats: priorityStats ?? this.priorityStats,
    );
  }

  double get sessionCompletionRate {
    final totalSessions = completedSessions + skippedSessions;
    if (totalSessions == 0) return 0.0;
    return (completedSessions / totalSessions) * 100;
  }

  Duration get averageSessionTime {
    if (completedSessions == 0) return Duration.zero;
    return Duration(
      milliseconds: totalFocusTime.inMilliseconds ~/ completedSessions,
    );
  }
}

/// فئة الإنجاز
@HiveType(typeId: 101)
enum AchievementCategory {
  @HiveField(0)
  productivity, // إنتاجية

  @HiveField(1)
  focus, // تركيز

  @HiveField(2)
  consistency, // ثبات

  @HiveField(3)
  milestone, // إنجاز

  @HiveField(4)
  social, // اجتماعي

  @HiveField(5)
  sessions, // جلسات

  @HiveField(6)
  tasks, // مهام

  @HiveField(7)
  streaks, // سلاسل

  @HiveField(8)
  time, // وقت

  @HiveField(9)
  special, // خاص
}

/// إنجاز/شارة
@HiveType(typeId: 94)
class Achievement {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final AchievementType type;

  @HiveField(5)
  final int targetValue;

  @HiveField(6)
  final int currentValue;

  @HiveField(7)
  final bool isUnlocked;

  @HiveField(8)
  final DateTime? unlockedAt;

  @HiveField(9)
  final Color color;

  @HiveField(10)
  final int points; // نقاط الإنجاز

  @HiveField(11)
  final AchievementCategory category; // فئة الإنجاز

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.color = Colors.amber,
    this.points = 10,
    this.category = AchievementCategory.milestone,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementType? type,
    int? targetValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    Color? color,
    int? points,
    AchievementCategory? category,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      color: color ?? this.color,
      points: points ?? this.points,
      category: category ?? this.category,
    );
  }

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);
}

/// نوع الإنجاز
@HiveType(typeId: 95)
enum AchievementType {
  @HiveField(0)
  sessionsCompleted, // جلسات مكتملة

  @HiveField(1)
  focusTime, // وقت التركيز

  @HiveField(2)
  tasksCompleted, // مهام مكتملة

  @HiveField(3)
  streak, // سلسلة متتالية

  @HiveField(4)
  productivity, // إنتاجية

  @HiveField(5)
  consistency, // الثبات

  @HiveField(6)
  milestone, // إنجاز معين
}

/// تايمر متعدد
@HiveType(typeId: 96)
class MultiTimer {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<PomodoroSession> sessions;

  @HiveField(3)
  final int currentSessionIndex;

  @HiveField(4)
  final bool isActive;

  @HiveField(5)
  final DateTime? startedAt;

  const MultiTimer({
    required this.id,
    required this.name,
    this.sessions = const [],
    this.currentSessionIndex = 0,
    this.isActive = false,
    this.startedAt,
  });

  MultiTimer copyWith({
    String? id,
    String? name,
    List<PomodoroSession>? sessions,
    int? currentSessionIndex,
    bool? isActive,
    DateTime? startedAt,
  }) {
    return MultiTimer(
      id: id ?? this.id,
      name: name ?? this.name,
      sessions: sessions ?? this.sessions,
      currentSessionIndex: currentSessionIndex ?? this.currentSessionIndex,
      isActive: isActive ?? this.isActive,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  PomodoroSession? get currentSession {
    if (currentSessionIndex >= sessions.length) return null;
    return sessions[currentSessionIndex];
  }

  Duration get totalDuration {
    return sessions.fold<Duration>(
      Duration.zero,
      (total, session) => total + session.duration,
    );
  }

  Duration get elapsedTime {
    if (!isActive || startedAt == null) return Duration.zero;
    return DateTime.now().difference(startedAt!);
  }

  double get overallProgress {
    if (sessions.isEmpty) return 0.0;
    final completedSessions = sessions.take(currentSessionIndex).length;
    final currentProgress = currentSession?.progress ?? 0.0;
    return ((completedSessions + currentProgress) / sessions.length).clamp(
      0.0,
      1.0,
    );
  }
}

/// اقتراح AI للمهام
@HiveType(typeId: 97)
class AITaskSuggestion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String taskId;

  @HiveField(2)
  final SuggestionType type;

  @HiveField(3)
  final String suggestion;

  @HiveField(4)
  final double confidence; // 0-1

  @HiveField(5)
  final List<String> reasons;

  @HiveField(6)
  final Map<String, dynamic> data;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final bool isApplied;

  const AITaskSuggestion({
    required this.id,
    required this.taskId,
    required this.type,
    required this.suggestion,
    required this.confidence,
    this.reasons = const [],
    this.data = const {},
    required this.createdAt,
    this.isApplied = false,
  });

  AITaskSuggestion copyWith({
    String? id,
    String? taskId,
    SuggestionType? type,
    String? suggestion,
    double? confidence,
    List<String>? reasons,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isApplied,
  }) {
    return AITaskSuggestion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      suggestion: suggestion ?? this.suggestion,
      confidence: confidence ?? this.confidence,
      reasons: reasons ?? this.reasons,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

/// نوع الاقتراح
@HiveType(typeId: 98)
enum SuggestionType {
  @HiveField(0)
  taskPriority, // أولوية المهمة

  @HiveField(1)
  taskBreakdown, // تقسيم المهمة

  @HiveField(2)
  timeEstimation, // تقدير الوقت

  @HiveField(3)
  scheduling, // الجدولة

  @HiveField(4)
  taskOptimization, // تحسين المهمة

  @HiveField(5)
  focusImprovement, // تحسين التركيز
}

/// ثيم تطبيق Pomodoro
@HiveType(typeId: 99)
class PomodoroTheme {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ThemeStyle style;

  @HiveField(3)
  final Color primaryColor;

  @HiveField(4)
  final Color secondaryColor;

  @HiveField(5)
  final Color backgroundColor;

  @HiveField(6)
  final Color surfaceColor;

  @HiveField(7)
  final bool isDark;

  @HiveField(8)
  final Map<String, Color> customColors;

  const PomodoroTheme({
    required this.id,
    required this.name,
    required this.style,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    this.isDark = false,
    this.customColors = const {},
  });

  PomodoroTheme copyWith({
    String? id,
    String? name,
    ThemeStyle? style,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    bool? isDark,
    Map<String, Color>? customColors,
  }) {
    return PomodoroTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      style: style ?? this.style,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      isDark: isDark ?? this.isDark,
      customColors: customColors ?? this.customColors,
    );
  }
}

/// أنماط الثيم
@HiveType(typeId: 100)
enum ThemeStyle {
  @HiveField(0)
  minimal, // بسيط

  @HiveField(1)
  neon, // نيون

  @HiveField(2)
  glassmorphism, // زجاجي

  @HiveField(3)
  nature, // طبيعي

  @HiveField(4)
  dark, // داكن

  @HiveField(5)
  colorful, // ملون
}

/// إعدادات اقتراحات الاستراحة
@HiveType(typeId: 251)
class BreakSuggestion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final Duration duration;

  @HiveField(4)
  final BreakType type;

  @HiveField(5)
  final List<String> instructions;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final bool isActive;

  const BreakSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.type,
    this.instructions = const [],
    this.imageUrl,
    this.isActive = true,
  });

  BreakSuggestion copyWith({
    String? id,
    String? title,
    String? description,
    Duration? duration,
    BreakType? type,
    List<String>? instructions,
    String? imageUrl,
    bool? isActive,
  }) {
    return BreakSuggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// نوع الاستراحة
@HiveType(typeId: 252)
enum BreakType {
  @HiveField(0)
  stretch, // تمدد

  @HiveField(1)
  hydration, // شرب الماء

  @HiveField(2)
  breathing, // تنفس

  @HiveField(3)
  eyeRest, // راحة العين

  @HiveField(4)
  walk, // مشي

  @HiveField(5)
  meditation, // تأمل

  @HiveField(6)
  snack, // وجبة خفيفة
}
