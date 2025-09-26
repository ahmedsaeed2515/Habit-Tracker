// lib/core/database/managers/workout_manager.dart
// مدير قاعدة بيانات التمارين

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/workout.dart';
import 'base_database_manager.dart';

/// مدير قاعدة بيانات التمارين
class WorkoutManager extends BaseDatabaseManager {
  static const String _boxName = 'workouts';
  static late Box<Workout> _box;

  /// تهيئة صندوق التمارين
  static Future<void> initialize() async {
    _box = await BaseDatabaseManager.openBoxSafe<Workout>(_boxName);
  }

  /// الحصول على صندوق التمارين
  static Box<Workout> get box => _box;

  /// إضافة تمرين جديد
  static Future<void> add(Workout workout) async {
    await _box.put(workout.id, workout);
  }

  /// تحديث تمرين موجود
  static Future<void> update(Workout workout) async {
    await _box.put(workout.id, workout);
  }

  /// حذف تمرين
  static Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// الحصول على جميع التمارين مع فلترة اختيارية بالتاريخ
  static List<Workout> getAll({DateTime? startDate, DateTime? endDate}) {
    var workouts = _box.values.toList();

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

  /// الحصول على تمرين بالمعرف
  static Workout? getById(String id) {
    return _box.get(id);
  }

  /// الحصول على تمارين اليوم
  static List<Workout> getTodayWorkouts() {
    final today = DateTime.now();
    return getAll(
      startDate: DateTime(today.year, today.month, today.day),
      endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
    );
  }

  /// الحصول على إحصائيات التمارين
  static Map<String, dynamic> getStats() {
    final workouts = _box.values.toList();

    return {
      'totalWorkouts': workouts.length,
      'lastWorkoutDate': workouts.isNotEmpty
          ? workouts.map((w) => w.date).reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }

  /// مسح جميع البيانات
  static Future<void> clearAll() async {
    await _box.clear();
  }
}
