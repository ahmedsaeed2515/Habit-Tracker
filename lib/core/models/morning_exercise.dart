// lib/core/models/morning_exercise.dart
// نموذج تمارين الصباح (القرفصاء، الضغط، العقلة)

import 'package:hive/hive.dart';

part 'morning_exercise.g.dart';

@HiveType(typeId: 2)
class MorningExercise extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  ExerciseType type;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int reps;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String name;

  @HiveField(6)
  int targetReps;

  @HiveField(7)
  int targetSets;

  @HiveField(8)
  int caloriesBurned;

  @HiveField(9)
  int? actualReps;

  @HiveField(10)
  int? actualSets;

  @HiveField(11)
  DateTime? completedAt;

  MorningExercise({
    required this.id,
    required this.type,
    required this.date,
    required this.reps,
    this.isCompleted = false,
    required this.name,
    required this.targetReps,
    required this.targetSets,
    this.caloriesBurned = 0,
    this.actualReps,
    this.actualSets,
    this.completedAt,
  });

  MorningExercise copyWith({
    ExerciseType? type,
    DateTime? date,
    int? reps,
    bool? isCompleted,
    String? name,
    int? targetReps,
    int? targetSets,
    int? caloriesBurned,
    int? actualReps,
    int? actualSets,
    DateTime? completedAt,
  }) {
    return MorningExercise(
      id: id,
      type: type ?? this.type,
      date: date ?? this.date,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      name: name ?? this.name,
      targetReps: targetReps ?? this.targetReps,
      targetSets: targetSets ?? this.targetSets,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      actualReps: actualReps ?? this.actualReps,
      actualSets: actualSets ?? this.actualSets,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

@HiveType(typeId: 3)
enum ExerciseType {
  @HiveField(0)
  squat,

  @HiveField(1)
  pushUp,

  @HiveField(2)
  pullUp,

  @HiveField(3)
  custom,
}

// إضافة هدف عالمي للتمارين
@HiveType(typeId: 4)
class ExerciseGoal extends HiveObject {
  @HiveField(0)
  ExerciseType type;

  @HiveField(1)
  int targetReps;

  @HiveField(2)
  int currentReps;

  @HiveField(3)
  DateTime lastUpdated;

  ExerciseGoal({
    required this.type,
    this.targetReps = 1000,
    this.currentReps = 0,
    required this.lastUpdated,
  });

  // حساب النسبة المئوية للإنجاز
  double get progressPercentage {
    if (targetReps == 0) return 0.0;
    return (currentReps / targetReps * 100).clamp(0.0, 100.0);
  }

  // التحقق من إتمام الهدف
  bool get isCompleted => currentReps >= targetReps;

  // التكرارات المتبقية
  int get remainingReps => (targetReps - currentReps).clamp(0, targetReps);

  ExerciseGoal copyWith({
    ExerciseType? type,
    int? targetReps,
    int? currentReps,
    DateTime? lastUpdated,
  }) {
    return ExerciseGoal(
      type: type ?? this.type,
      targetReps: targetReps ?? this.targetReps,
      currentReps: currentReps ?? this.currentReps,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
