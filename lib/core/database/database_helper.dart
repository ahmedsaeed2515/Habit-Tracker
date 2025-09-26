import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../models/task.dart';
import '../models/morning_exercise.dart';
import '../models/workout.dart';
import '../models/settings.dart';
import '../../features/dynamic_theming/models/theming_models.dart';

/// مساعد قاعدة البيانات الرئيسي
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();
  
  DatabaseHelper._();

  // أسماء الصناديق
  static const String _habitsBoxName = 'habits';
  static const String _tasksBoxName = 'tasks';
  static const String _exercisesBoxName = 'morning_exercises';
  static const String _workoutsBoxName = 'workouts';
  static const String _settingsBoxName = 'settings';
  static const String _themingBoxName = 'theming';
  static const String _pomodoroBoxName = 'pomodoro';

  // الصناديق المفتوحة
  static Box<Habit>? _habitsBox;
  static Box<Task>? _tasksBox;
  static Box<MorningExercise>? _exercisesBox;
  static Box<Workout>? _workoutsBox;
  static Box<AppSettings>? _settingsBox;
  static Box<DynamicTheme>? _themingBox;
  static Box? _pomodoroBox;

  /// تهيئة قاعدة البيانات
  static Future<void> initialize() async {
    try {
      // تهيئة Hive
      await Hive.initFlutter();

      // تسجيل محولات النماذج الأساسية
      _registerCoreAdapters();
      
      // تسجيل محولات السمات
      _registerThemeAdapters();

      // فتح الصناديق
      await _openBoxes();

      debugPrint('✅ تم تهيئة قاعدة البيانات بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة قاعدة البيانات: $e');
      rethrow;
    }
  }

  /// تسجيل محولات النماذج الأساسية
  static void _registerCoreAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MorningExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(WorkoutAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
  }

  /// تسجيل محولات السمات
  static void _registerThemeAdapters() {
    if (!Hive.isAdapterRegistered(144)) {
      Hive.registerAdapter(DynamicThemeAdapter());
    }
    if (!Hive.isAdapterRegistered(145)) {
      Hive.registerAdapter(ColorPaletteAdapter());
    }
    if (!Hive.isAdapterRegistered(146)) {
      Hive.registerAdapter(TypographySettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(147)) {
      Hive.registerAdapter(ComponentsStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(148)) {
      Hive.registerAdapter(ButtonStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(149)) {
      Hive.registerAdapter(CardStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(150)) {
      Hive.registerAdapter(InputStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(151)) {
      Hive.registerAdapter(AppBarStyleAdapter());
    }
    if (!Hive.isAdapterRegistered(152)) {
      Hive.registerAdapter(AnimationSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(153)) {
      Hive.registerAdapter(LayoutSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(154)) {
      Hive.registerAdapter(AccessibilitySettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(155)) {
      Hive.registerAdapter(FontSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(156)) {
      Hive.registerAdapter(PresetThemeAdapter());
    }
  }

  /// فتح جميع الصناديق
  static Future<void> _openBoxes() async {
    _habitsBox = await Hive.openBox<Habit>(_habitsBoxName);
    _tasksBox = await Hive.openBox<Task>(_tasksBoxName);
    _exercisesBox = await Hive.openBox<MorningExercise>(_exercisesBoxName);
    _workoutsBox = await Hive.openBox<Workout>(_workoutsBoxName);
    _settingsBox = await Hive.openBox<AppSettings>(_settingsBoxName);
    _themingBox = await Hive.openBox<DynamicTheme>(_themingBoxName);
    _pomodoroBox = await Hive.openBox(_pomodoroBoxName);
  }

  // ===== طرق الوصول للصناديق =====

  /// الحصول على صندوق العادات
  static Box<Habit> get habitsBox {
    if (_habitsBox == null || !_habitsBox!.isOpen) {
      throw StateError('صندوق العادات غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _habitsBox!;
  }

  /// الحصول على صندوق المهام
  static Box<Task> get tasksBox {
    if (_tasksBox == null || !_tasksBox!.isOpen) {
      throw StateError('صندوق المهام غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _tasksBox!;
  }

  /// الحصول على صندوق التمارين الصباحية
  static Box<MorningExercise> get exercisesBox {
    if (_exercisesBox == null || !_exercisesBox!.isOpen) {
      throw StateError('صندوق التمارين غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _exercisesBox!;
  }

  /// الحصول على صندوق التمارين
  static Box<Workout> get workoutsBox {
    if (_workoutsBox == null || !_workoutsBox!.isOpen) {
      throw StateError('صندوق التدريبات غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _workoutsBox!;
  }

  /// الحصول على صندوق الإعدادات
  static Box<AppSettings> get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw StateError('صندوق الإعدادات غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _settingsBox!;
  }

  /// الحصول على صندوق السمات
  static Box<DynamicTheme> get themingBox {
    if (_themingBox == null || !_themingBox!.isOpen) {
      throw StateError('صندوق السمات غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _themingBox!;
  }

  /// الحصول على صندوق البومودورو
  static Box get pomodoroBox {
    if (_pomodoroBox == null || !_pomodoroBox!.isOpen) {
      throw StateError('صندوق البومودورو غير مفتوح. تأكد من استدعاء initialize() أولاً');
    }
    return _pomodoroBox!;
  }

  // ===== طرق مساعدة عامة =====

  /// حفظ البيانات
  static Future<void> saveData<T>(String boxName, String key, T value) async {
    final box = Hive.box<T>(boxName);
    await box.put(key, value);
  }

  /// استرداد البيانات
  static T? getData<T>(String boxName, String key) {
    final box = Hive.box<T>(boxName);
    return box.get(key);
  }

  /// حذف البيانات
  static Future<void> deleteData(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// الحصول على جميع البيانات
  static List<T> getAllData<T>(String boxName) {
    final box = Hive.box<T>(boxName);
    return box.values.toList();
  }

  /// مسح جميع البيانات من صندوق
  static Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  /// إغلاق صندوق معين
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// إغلاق جميع الصناديق
  static Future<void> closeAllBoxes() async {
    await Hive.close();
    _habitsBox = null;
    _tasksBox = null;
    _exercisesBox = null;
    _workoutsBox = null;
    _settingsBox = null;
    _themingBox = null;
    _pomodoroBox = null;
  }

  /// حذف الصندوق نهائياً
  static Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).deleteFromDisk();
    }
  }

  /// النسخ الاحتياطي
  static Future<Map<String, dynamic>> backup() async {
    final backup = <String, dynamic>{};
    
    backup['habits'] = habitsBox.values.toList();
    backup['tasks'] = tasksBox.values.toList();
    backup['exercises'] = exercisesBox.values.toList();
    backup['workouts'] = workoutsBox.values.toList();
    backup['settings'] = settingsBox.values.toList();
    backup['themes'] = themingBox.values.toList();
    
    backup['timestamp'] = DateTime.now().toIso8601String();
    backup['version'] = '1.0.0';
    
    return backup;
  }

  /// استعادة النسخ الاحتياطي
  static Future<void> restore(Map<String, dynamic> backup) async {
    try {
      // مسح البيانات الموجودة
      await Future.wait([
        habitsBox.clear(),
        tasksBox.clear(),
        exercisesBox.clear(),
        workoutsBox.clear(),
        settingsBox.clear(),
        themingBox.clear(),
      ]);

      // استعادة البيانات
      if (backup['habits'] != null) {
        for (var habit in backup['habits']) {
          await habitsBox.add(habit as Habit);
        }
      }
      
      if (backup['tasks'] != null) {
        for (var task in backup['tasks']) {
          await tasksBox.add(task as Task);
        }
      }
      
      if (backup['exercises'] != null) {
        for (var exercise in backup['exercises']) {
          await exercisesBox.add(exercise as MorningExercise);
        }
      }
      
      if (backup['workouts'] != null) {
        for (var workout in backup['workouts']) {
          await workoutsBox.add(workout as Workout);
        }
      }
      
      if (backup['settings'] != null) {
        for (var setting in backup['settings']) {
          await settingsBox.add(setting as AppSettings);
        }
      }
      
      if (backup['themes'] != null) {
        for (var theme in backup['themes']) {
          await themingBox.add(theme as DynamicTheme);
        }
      }

      debugPrint('✅ تم استعادة النسخة الاحتياطية بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في استعادة النسخة الاحتياطية: $e');
      rethrow;
    }
  }

  /// الحصول على إحصائيات قاعدة البيانات
  static Map<String, dynamic> getDatabaseStats() {
    return {
      'habits_count': habitsBox.length,
      'tasks_count': tasksBox.length,
      'exercises_count': exercisesBox.length,
      'workouts_count': workoutsBox.length,
      'settings_count': settingsBox.length,
      'themes_count': themingBox.length,
      'total_records': habitsBox.length + 
                      tasksBox.length + 
                      exercisesBox.length + 
                      workoutsBox.length + 
                      settingsBox.length + 
                      themingBox.length,
      'database_size_mb': _calculateDatabaseSize(),
      'last_accessed': DateTime.now().toIso8601String(),
    };
  }

  /// حساب حجم قاعدة البيانات تقريبياً
  static double _calculateDatabaseSize() {
    // حساب تقريبي بناءً على عدد الكائنات
    final totalObjects = habitsBox.length + 
                        tasksBox.length + 
                        exercisesBox.length + 
                        workoutsBox.length + 
                        settingsBox.length + 
                        themingBox.length;
    
    // تقدير متوسط حجم الكائن الواحد بـ 1KB
    return (totalObjects * 1024) / (1024 * 1024); // بالميجابايت
  }

  /// تنظيف قاعدة البيانات (إزالة البيانات القديمة)
  static Future<void> cleanup() async {
    try {
      final now = DateTime.now();
      int deletedCount = 0;

      // حذف المهام المكتملة والقديمة (أكثر من 30 يوم)
      final oldTasks = tasksBox.values.where((task) {
        return task.isCompleted && 
               now.difference(task.completedAt ?? task.createdAt).inDays > 30;
      }).toList();

      for (final task in oldTasks) {
        final key = tasksBox.keys.firstWhere(
          (k) => tasksBox.get(k) == task,
          orElse: () => null,
        );
        if (key != null) {
          await tasksBox.delete(key);
          deletedCount++;
        }
      }

      debugPrint('🧹 تم تنظيف قاعدة البيانات - حذف $deletedCount عنصر');
    } catch (e) {
      debugPrint('❌ خطأ في تنظيف قاعدة البيانات: $e');
    }
  }

  /// التحقق من حالة قاعدة البيانات
  static bool get isInitialized {
    return _habitsBox != null && 
           _tasksBox != null && 
           _exercisesBox != null && 
           _workoutsBox != null && 
           _settingsBox != null && 
           _themingBox != null && 
           _pomodoroBox != null;
  }

  /// إعادة فتح الصناديق إذا تم إغلاقها
  static Future<void> ensureOpen() async {
    if (!isInitialized) {
      await initialize();
    }
  }

  /// طريقة مساعدة للتوافق مع الكود القديم - سيتم إزالتها لاحقاً
  @deprecated
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  /// طريقة مساعدة للتوافق مع الكود القديم - سيتم إزالتها لاحقاً  
  @deprecated
  Future<Box> openBoxDynamic(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }
}