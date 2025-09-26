// lib/core/database/database_exports.dart
// ملف تصدير موحد لجميع مديري قاعدة البيانات

/// تصدير المدير الأساسي
export 'database_manager.dart';

/// تصدير المديرين المُقسَّمين
export 'managers/base_database_manager.dart';
export 'managers/adapters_manager.dart';
export 'managers/workout_manager.dart';
export 'managers/habits_manager.dart';

/// تصدير النماذج الأساسية
export '../models/workout.dart';
export '../models/morning_exercise.dart';
export '../models/habit.dart';
export '../models/task.dart';
export '../models/settings.dart';
