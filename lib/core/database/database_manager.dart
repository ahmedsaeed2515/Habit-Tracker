// lib/core/database/database_manager.dart
// مدير قاعدة البيانات المحلية باستخدام Hive

import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';
import '../models/morning_exercise.dart';
import '../models/habit.dart';
import '../models/task.dart';
import '../models/settings.dart';
import '../../features/smart_notifications/models/smart_notification.dart';
import '../../features/voice_commands/models/voice_command.dart';
import '../../features/habit_builder/models/habit_template.dart';
import '../../features/ai_assistant/models/ai_message.dart';
import '../../features/smart_recommendations/models/habit_recommendation.dart';

class DatabaseManager {
  static const String _workoutsBoxName = 'workouts';
  static const String _morningExercisesBoxName = 'morning_exercises';
  static const String _exerciseGoalsBoxName = 'exercise_goals';
  static const String _habitsBoxName = 'habits';
  static const String _habitEntriesBoxName = 'habit_entries';
  static const String _taskSheetsBoxName = 'task_sheets';
  static const String _tasksBoxName = 'tasks';
  static const String _settingsBoxName = 'settings';

  static late Box<Workout> _workoutsBox;
  static late Box<MorningExercise> _morningExercisesBox;
  static late Box<ExerciseGoal> _exerciseGoalsBox;
  static late Box<Habit> _habitsBox;
  static late Box<HabitEntry> _habitEntriesBox;
  static late Box<TaskSheet> _taskSheetsBox;
  static late Box<Task> _tasksBox;
  static late Box<AppSettings> _settingsBox;

  /// تهيئة قاعدة البيانات
  static Future<void> initialize() async {
    // تهيئة Hive
    await Hive.initFlutter();

    // تسجيل المحولات (Adapters)
    _registerAdapters();

    // فتح الصناديق (Boxes)
    await _openBoxes();

    // إنشاء البيانات الافتراضية إذا لم تكن موجودة
    await _createDefaultData();
  }

  /// تسجيل محولات Hive لجميع النماذج
  static void _registerAdapters() {
    // تسجيل محولات الإشعارات الذكية
    try {
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(SmartNotificationAdapter());
      }
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(NotificationTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(12)) {
        Hive.registerAdapter(NotificationPriorityAdapter());
      }
    } catch (e) {
      print('تخطي تسجيل adapters الإشعارات الذكية: $e');
    }

    // نماذج التمارين (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(WorkoutAdapter());
      if (!Hive.isAdapterRegistered(1))
        Hive.registerAdapter(ExerciseSetAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters التمارين: $e');
    }

    // نماذج تمارين الصباح (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(2))
        Hive.registerAdapter(MorningExerciseAdapter());
      if (!Hive.isAdapterRegistered(3))
        Hive.registerAdapter(ExerciseTypeAdapter());
      if (!Hive.isAdapterRegistered(4))
        Hive.registerAdapter(ExerciseGoalAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters تمارين الصباح: $e');
    }

    // نماذج العادات (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(HabitAdapter());
      if (!Hive.isAdapterRegistered(6))
        Hive.registerAdapter(HabitEntryAdapter());
      if (!Hive.isAdapterRegistered(7))
        Hive.registerAdapter(HabitTypeAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters العادات: $e');
    }

    // نماذج المهام (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(8))
        Hive.registerAdapter(TaskSheetAdapter());
      if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(TaskAdapter());
      // تم تخصيص typeId 10-12 للإشعارات
      if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter(SubTaskAdapter());
      if (!Hive.isAdapterRegistered(14))
        Hive.registerAdapter(TaskPriorityAdapter());
      if (!Hive.isAdapterRegistered(15))
        Hive.registerAdapter(TaskStatusAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters المهام: $e');
    }

    // نماذج الإعدادات (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(16))
        Hive.registerAdapter(AppSettingsAdapter());
      if (!Hive.isAdapterRegistered(17))
        Hive.registerAdapter(AppTimeOfDayAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters الإعدادات: $e');
    }

    // نماذج الأوامر الصوتية (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(18))
        Hive.registerAdapter(VoiceCommandTypeAdapter());
      if (!Hive.isAdapterRegistered(19))
        Hive.registerAdapter(CommandStatusAdapter());
      if (!Hive.isAdapterRegistered(20))
        Hive.registerAdapter(VoiceCommandAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters الأوامر الصوتية: $e');
    }

    // نماذج بناء العادات (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(21))
        Hive.registerAdapter(HabitTemplateAdapter());
      if (!Hive.isAdapterRegistered(22))
        Hive.registerAdapter(HabitCategoryAdapter());
      if (!Hive.isAdapterRegistered(23))
        Hive.registerAdapter(UserProfileAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters بناء العادات: $e');
    }

    // نماذج المساعد الذكي (إذا كانت متوفرة)
    try {
      if (!Hive.isAdapterRegistered(24))
        Hive.registerAdapter(AIMessageAdapter());
      if (!Hive.isAdapterRegistered(25))
        Hive.registerAdapter(AIMessageTypeAdapter());
      if (!Hive.isAdapterRegistered(26))
        Hive.registerAdapter(AIPersonalityProfileAdapter());
      if (!Hive.isAdapterRegistered(27))
        Hive.registerAdapter(PersonalityTypeAdapter());
    } catch (e) {
      print('تخطي تسجيل adapters المساعد الذكي: $e');
    }
  }

  /// فتح جميع الصناديق
  static Future<void> _openBoxes() async {
    _workoutsBox = await Hive.openBox<Workout>(_workoutsBoxName);
    _morningExercisesBox = await Hive.openBox<MorningExercise>(
      _morningExercisesBoxName,
    );
    _exerciseGoalsBox = await Hive.openBox<ExerciseGoal>(_exerciseGoalsBoxName);
    _habitsBox = await Hive.openBox<Habit>(_habitsBoxName);
    _habitEntriesBox = await Hive.openBox<HabitEntry>(_habitEntriesBoxName);
    _taskSheetsBox = await Hive.openBox<TaskSheet>(_taskSheetsBoxName);
    _tasksBox = await Hive.openBox<Task>(_tasksBoxName);
    _settingsBox = await Hive.openBox<AppSettings>(_settingsBoxName);
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

  // ========== تمارين الجيم ==========
  static Box<Workout> get workoutsBox => _workoutsBox;

  static Future<void> addWorkout(Workout workout) async {
    await _workoutsBox.put(workout.id, workout);
  }

  static Future<void> updateWorkout(Workout workout) async {
    await _workoutsBox.put(workout.id, workout);
  }

  static Future<void> deleteWorkout(String id) async {
    await _workoutsBox.delete(id);
  }

  static List<Workout> getWorkouts({DateTime? startDate, DateTime? endDate}) {
    var workouts = _workoutsBox.values.toList();

    if (startDate != null && endDate != null) {
      workouts = workouts
          .where(
            (workout) =>
                workout.date.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                workout.date.isBefore(endDate.add(const Duration(days: 1))),
          )
          .toList();
    }

    workouts.sort((a, b) => b.date.compareTo(a.date));
    return workouts;
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

  // ========== العادات ==========
  static Box<Habit> get habitsBox => _habitsBox;
  static Box<HabitEntry> get habitEntriesBox => _habitEntriesBox;

  static Future<void> addHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  static Future<void> updateHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  static Future<void> deleteHabit(String id) async {
    // حذف جميع إدخالات العادة
    final entries = _habitEntriesBox.values
        .where((entry) => entry.habitId == id)
        .toList();
    for (var entry in entries) {
      await _habitEntriesBox.delete(entry.key);
    }

    await _habitsBox.delete(id);
  }

  static List<Habit> getActiveHabits() {
    return _habitsBox.values.where((habit) => habit.isActive).toList();
  }

  static Future<void> addHabitEntry(HabitEntry entry) async {
    await _habitEntriesBox.put(entry.id, entry);

    // تحديث العادة
    final habit = _habitsBox.get(entry.habitId);
    if (habit != null) {
      habit.entries = getHabitEntries(entry.habitId);
      habit.updateStreak();
      await updateHabit(habit);
    }
  }

  static List<HabitEntry> getHabitEntries(String habitId) {
    return _habitEntriesBox.values
        .where((entry) => entry.habitId == habitId)
        .toList();
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
    await _workoutsBox.clear();
    await _morningExercisesBox.clear();
    await _exerciseGoalsBox.clear();
    await _habitsBox.clear();
    await _habitEntriesBox.clear();
    await _taskSheetsBox.clear();
    await _tasksBox.clear();
    // لا نحذف الإعدادات

    await _createDefaultData();
  }
}
