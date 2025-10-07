import 'package:hive/hive.dart';

part 'ai_recommendation.g.dart';

@HiveType(typeId: 3)
class AIRecommendation extends HiveObject { // user feedback on the recommendation

  AIRecommendation({
    required this.id,
    required this.userId,
    required this.recommendationType,
    required this.title,
    required this.description,
    required this.parameters,
    required this.confidence,
    required this.createdAt,
    this.isApplied = false,
    this.appliedAt,
    this.feedback,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String recommendationType; // 'workout_plan', 'exercise_modification', 'progress_adjustment'

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final Map<String, dynamic> parameters;

  @HiveField(6)
  final double confidence; // 0.0 to 1.0

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final bool isApplied;

  @HiveField(9)
  final DateTime? appliedAt;

  @HiveField(10)
  final String? feedback;

  AIRecommendation copyWith({
    String? id,
    String? userId,
    String? recommendationType,
    String? title,
    String? description,
    Map<String, dynamic>? parameters,
    double? confidence,
    DateTime? createdAt,
    bool? isApplied,
    DateTime? appliedAt,
    String? feedback,
  }) {
    return AIRecommendation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recommendationType: recommendationType ?? this.recommendationType,
      title: title ?? this.title,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      isApplied: isApplied ?? this.isApplied,
      appliedAt: appliedAt ?? this.appliedAt,
      feedback: feedback ?? this.feedback,
    );
  }
}
