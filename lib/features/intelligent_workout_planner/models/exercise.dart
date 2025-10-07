import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 2)
class Exercise extends HiveObject {

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.targetMuscles,
    required this.equipment,
    required this.sets,
    required this.reps,
    this.durationSeconds = 0,
    required this.restSeconds,
    this.difficulty = 'intermediate',
    required this.instructions,
    this.tips = const [],
    this.videoUrl,
    this.imageUrl,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category; // 'cardio', 'strength', 'flexibility', 'balance'

  @HiveField(4)
  final List<String> targetMuscles;

  @HiveField(5)
  final String equipment; // 'bodyweight', 'dumbbells', 'barbell', etc.

  @HiveField(6)
  final int sets;

  @HiveField(7)
  final int reps;

  @HiveField(8)
  final int durationSeconds; // for cardio exercises

  @HiveField(9)
  final int restSeconds;

  @HiveField(10)
  final String difficulty; // 'beginner', 'intermediate', 'advanced'

  @HiveField(11)
  final String instructions;

  @HiveField(12)
  final List<String> tips;

  @HiveField(13)
  final String? videoUrl;

  @HiveField(14)
  final String? imageUrl;

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    List<String>? targetMuscles,
    String? equipment,
    int? sets,
    int? reps,
    int? durationSeconds,
    int? restSeconds,
    String? difficulty,
    String? instructions,
    List<String>? tips,
    String? videoUrl,
    String? imageUrl,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      difficulty: difficulty ?? this.difficulty,
      instructions: instructions ?? this.instructions,
      tips: tips ?? this.tips,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
