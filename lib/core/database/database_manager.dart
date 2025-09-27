// lib/core/database/database_manager.dart
// مدير قاعدة البيانات المحلية باستخدام Hive - تم إعادة تنظيمه

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'managers/base_database_manager.dart';
import 'managers/adapters_manager.dart';
import 'managers/workout_manager.dart';
import 'managers/habits_manager.dart';
import '../models/workout.dart';
import '../models/morning_exercise.dart';
import '../models/habit.dart';
import '../models/task.dart';
import '../models/settings.dart';

/// مدير قاعدة البيانات الرئيسي - تم إعادة تنظيمه إلى مديرين منفصلين
class DatabaseManager extends BaseDatabaseManager {
  // أسماء الصناديق للوحدات المتبقية (غير المُقسَّمة)
  static const String _morningExercisesBoxName = 'morning_exercises';
  static const String _exerciseGoalsBoxName = 'exercise_goals';
  static const String _taskSheetsBoxName = 'task_sheets';
  static const String _tasksBoxName = 'tasks';
  static const String _settingsBoxName = 'settings';

  // الصناديق للوحدات المتبقية
  static late Box<MorningExercise> _morningExercisesBox;
  static late Box<ExerciseGoal> _exerciseGoalsBox;
  static late Box<TaskSheet> _taskSheetsBox;
  static late Box<Task> _tasksBox;
  static late Box<AppSettings> _settingsBox;

  /// تهيئة قاعدة البيانات
  static Future<void> initialize() async {
    // تهيئة Hive
    await Hive.initFlutter();

    // تسجيل المحولات (Adapters)
    AdaptersManager.registerAllAdapters();

    // تهيئة المديرين المُقسَّمين
    await WorkoutManager.initialize();
    await HabitsManager.initialize();

    // فتح الصناديق المتبقية
    await _openRemainingBoxes();

    // إنشاء البيانات الافتراضية إذا لم تكن موجودة
    await _createDefaultData();

    debugPrint('✅ تم تهيئة قاعدة البيانات بنجاح');
  }

  /// فتح الصناديق المتبقية (غير المُقسَّمة)
  static Future<void> _openRemainingBoxes() async {
    _morningExercisesBox =
        await BaseDatabaseManager.openBoxSafe<MorningExercise>(
          _morningExercisesBoxName,
        );
    _exerciseGoalsBox = await BaseDatabaseManager.openBoxSafe<ExerciseGoal>(
      _exerciseGoalsBoxName,
    );
    _taskSheetsBox = await BaseDatabaseManager.openBoxSafe<TaskSheet>(
      _taskSheetsBoxName,
    );
    _tasksBox = await BaseDatabaseManager.openBoxSafe<Task>(_tasksBoxName);
    _settingsBox = await BaseDatabaseManager.openBoxSafe<AppSettings>(
      _settingsBoxName,
    );

    // فتح صناديق Pomodoro
    await _openPomodoroBoxes();
  }

  /// فتح صناديق Pomodoro
  static Future<void> _openPomodoroBoxes() async {
    try {
      await Hive.openBox('pomodoro_sessions');
      await Hive.openBox('pomodoro_tasks');
      await Hive.openBox('pomodoro_stats');
      await Hive.openBox('pomodoro_settings');
      await Hive.openBox('achievements');
      await Hive.openBox('multi_timers');
      debugPrint('✅ تم فتح جميع صناديق Pomodoro');
    } catch (e) {
      debugPrint('⚠️ خطأ في فتح صناديق Pomodoro: $e');
    }
  }

  /// إنشاء البيانات الافتراضية
  static Future<void> _createDefaultData() async {
    // إنشاء الإعدادات الافتراضية
    if (_settingsBox.isEmpty) {
      final defaultSettings = AppSettings();
      await _settingsBox.put('app_settings', defaultSettings);
    }

    // إنشاء أهداف تمارين الصباح الافتراضية
    if (_exerciseGoalsBox.isEmpty) {
      final goals = [
        ExerciseGoal(
          type: ExerciseType.squat,
          targetReps: 1000,
          lastUpdated: DateTime.now(),
        ),
        ExerciseGoal(
          type: ExerciseType.pushUp,
          targetReps: 1000,
          lastUpdated: DateTime.now(),
        ),
        ExerciseGoal(
          type: ExerciseType.pullUp,
          targetReps: 1000,
          lastUpdated: DateTime.now(),
        ),
      ];

      for (var goal in goals) {
        await _exerciseGoalsBox.put(goal.type.toString(), goal);
      }
    }

    // إنشاء ورقة مهام افتراضية
    if (_taskSheetsBox.isEmpty) {
      final defaultSheet = TaskSheet(
        id: 'default_sheet',
        name: 'المهام الرئيسية',
        description: 'ورقة المهام الافتراضية',
        color: '#2196F3',
        tasks: [],
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );
      await _taskSheetsBox.put(defaultSheet.id, defaultSheet);
    }
  }

  // ========== تمارين الجيم (تم نقلها إلى WorkoutManager) ==========

  /// الحصول على صندوق التمارين
  static Box<Workout> get workoutsBox => WorkoutManager.box;

  /// إضافة تمرين جديد
  @deprecated
  static Future<void> addWorkout(Workout workout) async {
    await WorkoutManager.add(workout);
  }

  /// تحديث تمرين موجود
  @deprecated
  static Future<void> updateWorkout(Workout workout) async {
    await WorkoutManager.update(workout);
  }

  /// حذف تمرين
  @deprecated
  static Future<void> deleteWorkout(String id) async {
    await WorkoutManager.delete(id);
  }

  /// الحصول على التمارين مع فلترة بالتاريخ
  @deprecated
  static List<Workout> getWorkouts({DateTime? startDate, DateTime? endDate}) {
    return WorkoutManager.getAll(startDate: startDate, endDate: endDate);
  }

  // ========== تمارين الصباح ==========
  static Box<MorningExercise> get morningExercisesBox => _morningExercisesBox;
  static Box<ExerciseGoal> get exerciseGoalsBox => _exerciseGoalsBox;

  static Future<void> addMorningExercise(MorningExercise exercise) async {
    await _morningExercisesBox.put(exercise.id, exercise);

    // تحديث الهدف العالمي
    final goal = _exerciseGoalsBox.get(exercise.type.toString());
    if (goal != null) {
      goal.currentReps += exercise.reps;
      goal.lastUpdated = DateTime.now();
      await _exerciseGoalsBox.put(exercise.type.toString(), goal);
    }
  }

  static List<MorningExercise> getMorningExercises({DateTime? date}) {
    var exercises = _morningExercisesBox.values.toList();

    if (date != null) {
      exercises = exercises
          .where(
            (exercise) =>
                exercise.date.year == date.year &&
                exercise.date.month == date.month &&
                exercise.date.day == date.day,
          )
          .toList();
    }

    exercises.sort((a, b) => b.date.compareTo(a.date));
    return exercises;
  }

  static Future<void> updateMorningExercise(MorningExercise exercise) async {
    await _morningExercisesBox.put(exercise.id, exercise);
  }

  static Future<void> deleteMorningExercise(String id) async {
    await _morningExercisesBox.delete(id);
  }

  static ExerciseGoal? getExerciseGoal(ExerciseType type) {
    return _exerciseGoalsBox.get(type.toString());
  }

  static Future<void> updateExerciseGoal(ExerciseGoal goal) async {
    await _exerciseGoalsBox.put(goal.type.toString(), goal);
  }

  // ========== العادات (تم نقلها إلى HabitsManager) ==========

  /// الحصول على صندوق العادات
  static Box<Habit> get habitsBox => HabitsManager.habitsBox;

  /// الحصول على صندوق إدخالات العادات
  static Box<HabitEntry> get habitEntriesBox => HabitsManager.habitEntriesBox;

  /// إضافة عادة جديدة
  @deprecated
  static Future<void> addHabit(Habit habit) async {
    await HabitsManager.addHabit(habit);
  }

  /// تحديث عادة موجودة
  @deprecated
  static Future<void> updateHabit(Habit habit) async {
    await HabitsManager.updateHabit(habit);
  }

  /// حذف عادة
  @deprecated
  static Future<void> deleteHabit(String id) async {
    await HabitsManager.deleteHabit(id);
  }

  /// الحصول على العادات النشطة
  @deprecated
  static List<Habit> getActiveHabits() {
    return HabitsManager.getActiveHabits();
  }

  /// إضافة إدخال عادة
  @deprecated
  static Future<void> addHabitEntry(HabitEntry entry) async {
    await HabitsManager.addHabitEntry(entry);
  }

  /// الحصول على إدخالات عادة
  @deprecated
  static List<HabitEntry> getHabitEntries(String habitId) {
    return HabitsManager.getHabitEntries(habitId);
  }

  // ========== المهام الذكية ==========
  static Box<TaskSheet> get taskSheetsBox => _taskSheetsBox;
  static Box<Task> get tasksBox => _tasksBox;

  static Future<void> addTaskSheet(TaskSheet sheet) async {
    await _taskSheetsBox.put(sheet.id, sheet);
  }

  static Future<void> updateTaskSheet(TaskSheet sheet) async {
    sheet.lastModified = DateTime.now();
    await _taskSheetsBox.put(sheet.id, sheet);
  }

  static Future<void> deleteTaskSheet(String id) async {
    // حذف جميع المهام في الورقة
    final tasks = _tasksBox.values.where((task) => task.sheetId == id).toList();
    for (var task in tasks) {
      await _tasksBox.delete(task.key);
    }

    await _taskSheetsBox.delete(id);
  }

  static List<TaskSheet> getActiveTaskSheets() {
    return _taskSheetsBox.values.where((sheet) => sheet.isActive).toList();
  }

  static Future<void> addTask(Task task) async {
    await _tasksBox.put(task.id, task);

    // تحديث الورقة
    final sheet = _taskSheetsBox.get(task.sheetId);
    if (sheet != null) {
      sheet.tasks = getSheetTasks(task.sheetId);
      await updateTaskSheet(sheet);
    }
  }

  static Future<void> updateTask(Task task) async {
    task.lastModified = DateTime.now();
    await _tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  static List<Task> getSheetTasks(String sheetId) {
    var tasks = _tasksBox.values
        .where((task) => task.sheetId == sheetId)
        .toList();
    tasks.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return tasks;
  }

  // ========== الإعدادات ==========
  static Box<AppSettings> get settingsBox => _settingsBox;

  static AppSettings getAppSettings() {
    return _settingsBox.get('app_settings') ?? AppSettings();
  }

  static Future<void> updateAppSettings(AppSettings settings) async {
    await _settingsBox.put('app_settings', settings);
  }

  // ========== النسخ الاحتياطي ==========
  static Future<void> exportData(String path) async {
    // تصدير جميع البيانات إلى ملف JSON
    // سيتم تنفيذ هذا في المستقبل
  }

  static Future<void> importData(String path) async {
    // استيراد البيانات من ملف JSON
    // سيتم تنفيذ هذا في المستقبل
  }

  /// إغلاق جميع الصناديق
  static Future<void> close() async {
    await Hive.close();
  }

  /// حذف جميع البيانات (لأغراض التطوير)
  static Future<void> clearAllData() async {
    // مسح البيانات من المديرين المُقسَّمين
    await WorkoutManager.clearAll();
    await HabitsManager.clearAll();

    // مسح البيانات من الصناديق المتبقية
    await _morningExercisesBox.clear();
    await _exerciseGoalsBox.clear();
    await _taskSheetsBox.clear();
    await _tasksBox.clear();
    // لا نحذف الإعدادات

    await _createDefaultData();
  }
}
