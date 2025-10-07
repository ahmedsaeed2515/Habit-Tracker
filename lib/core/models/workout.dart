// lib/core/models/workout.dart
// نموذج تمرين الجيم مع Hive للتخزين المحلي

import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject { // ملاحظات

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.muscleGroup,
    required this.sets,
    this.duration = 0,
    this.isCompleted = false,
    this.type = 'قوة',
    this.notes = '',
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String muscleGroup;

  @HiveField(5)
  List<ExerciseSet> sets;

  @HiveField(6)
  int duration; // بالدقائق

  @HiveField(7)
  bool isCompleted;

  @HiveField(8)
  String type; // نوع التمرين (قوة، كارديو، مرونة، رياضة)

  @HiveField(9)
  String notes;

  // حساب إجمالي الوزن المرفوع
  double get totalWeight {
    return sets.fold(0.0, (sum, set) => sum + (set.weight * set.reps));
  }

  // حساب إجمالي التكرارات
  int get totalReps {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  // نسخة محدثة من التمرين
  Workout copyWith({
    String? name,
    String? description,
    DateTime? date,
    String? muscleGroup,
    List<ExerciseSet>? sets,
    int? duration,
    bool? isCompleted,
    String? type,
    String? notes,
  }) {
    return Workout(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      sets: sets ?? this.sets,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }
}

@HiveType(typeId: 1)
class ExerciseSet extends HiveObject {

  ExerciseSet({
    required this.exerciseName,
    required this.reps,
    required this.weight,
    this.restTime = 60,
    this.isCompleted = false,
  });
  @HiveField(0)
  String exerciseName;

  @HiveField(1)
  int reps;

  @HiveField(2)
  double weight;

  @HiveField(3)
  int restTime; // بالثواني

  @HiveField(4)
  bool isCompleted;

  ExerciseSet copyWith({
    String? exerciseName,
    int? reps,
    double? weight,
    int? restTime,
    bool? isCompleted,
  }) {
    return ExerciseSet(
      exerciseName: exerciseName ?? this.exerciseName,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restTime: restTime ?? this.restTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
