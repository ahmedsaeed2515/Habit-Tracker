import 'package:hive/hive.dart';

import 'exercise.dart';

part 'workout_plan.g.dart';

@HiveType(typeId: 0)
class WorkoutPlan extends HiveObject { // 'beginner', 'intermediate', 'advanced'

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscles,
    required this.durationWeeks,
    required this.days,
    required this.createdAt,
    this.updatedAt,
    this.isActive = false,
    this.difficulty = 'intermediate',
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> targetMuscles;

  @HiveField(4)
  final int durationWeeks;

  @HiveField(5)
  final List<WorkoutDay> days;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  @HiveField(8)
  final bool isActive;

  @HiveField(9)
  final String difficulty;

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? targetMuscles,
    int? durationWeeks,
    List<WorkoutDay>? days,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? difficulty,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

@HiveType(typeId: 1)
class WorkoutDay extends HiveObject {

  WorkoutDay({
    required this.id,
    required this.name,
    required this.exercises,
    required this.dayNumber,
    this.isRestDay = false,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<Exercise> exercises;

  @HiveField(3)
  final int dayNumber;

  @HiveField(4)
  final bool isRestDay;

  WorkoutDay copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    int? dayNumber,
    bool? isRestDay,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      dayNumber: dayNumber ?? this.dayNumber,
      isRestDay: isRestDay ?? this.isRestDay,
    );
  }
}
