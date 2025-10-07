// lib/features/analytics/models/analytics_data.dart
import 'package:hive/hive.dart';

part 'analytics_data.g.dart';

@HiveType(typeId: 13)
class AnalyticsData extends HiveObject {

  AnalyticsData({
    required this.id,
    required this.userId,
    required this.date,
    this.habitCompletions = const {},
    this.taskCompletions = const {},
    this.totalHabitsCompleted = 0,
    this.totalTasksCompleted = 0,
    this.categoryScores = const {},
    this.overallScore = 0.0,
    this.streakCount = 0,
    this.exerciseMinutes = 0,
    this.focusMinutes = 0,
    this.customMetrics = const {},
    required this.createdAt,
    required this.updatedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  Map<String, int> habitCompletions;

  @HiveField(4)
  Map<String, int> taskCompletions;

  @HiveField(5)
  int totalHabitsCompleted;

  @HiveField(6)
  int totalTasksCompleted;

  @HiveField(7)
  Map<String, double> categoryScores;

  @HiveField(8)
  double overallScore;

  @HiveField(9)
  int streakCount;

  @HiveField(10)
  int exerciseMinutes;

  @HiveField(11)
  int focusMinutes;

  @HiveField(12)
  Map<String, dynamic> customMetrics;

  @HiveField(13)
  DateTime createdAt;

  @HiveField(14)
  DateTime updatedAt;

  // Helper methods for analytics calculations
  double get completionRate {
    final totalPlanned = habitCompletions.length + taskCompletions.length;
    if (totalPlanned == 0) return 0.0;
    return (totalHabitsCompleted + totalTasksCompleted) / totalPlanned;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'habitCompletions': habitCompletions,
    'taskCompletions': taskCompletions,
    'totalHabitsCompleted': totalHabitsCompleted,
    'totalTasksCompleted': totalTasksCompleted,
    'categoryScores': categoryScores,
    'overallScore': overallScore,
    'streakCount': streakCount,
    'exerciseMinutes': exerciseMinutes,
    'focusMinutes': focusMinutes,
    'customMetrics': customMetrics,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  static AnalyticsData fromJson(Map<String, dynamic> json) => AnalyticsData(
    id: json['id'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    habitCompletions: Map<String, int>.from(json['habitCompletions'] ?? {}),
    taskCompletions: Map<String, int>.from(json['taskCompletions'] ?? {}),
    totalHabitsCompleted: json['totalHabitsCompleted'] ?? 0,
    totalTasksCompleted: json['totalTasksCompleted'] ?? 0,
    categoryScores: Map<String, double>.from(json['categoryScores'] ?? {}),
    overallScore: json['overallScore']?.toDouble() ?? 0.0,
    streakCount: json['streakCount'] ?? 0,
    exerciseMinutes: json['exerciseMinutes'] ?? 0,
    focusMinutes: json['focusMinutes'] ?? 0,
    customMetrics: json['customMetrics'] ?? {},
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

@HiveType(typeId: 14)
enum AnalyticsPeriod {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
  @HiveField(4)
  custom,
}

@HiveType(typeId: 15)
class AnalyticsSummary extends HiveObject {

  AnalyticsSummary({
    required this.id,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.averageScore = 0.0,
    this.totalHabitsCompleted = 0,
    this.totalTasksCompleted = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.categoryAverages = const {},
    this.topPerformingHabits = const [],
    this.improvementAreas = const [],
    required this.generatedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  AnalyticsPeriod period;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  @HiveField(4)
  double averageScore;

  @HiveField(5)
  int totalHabitsCompleted;

  @HiveField(6)
  int totalTasksCompleted;

  @HiveField(7)
  int longestStreak;

  @HiveField(8)
  int currentStreak;

  @HiveField(9)
  Map<String, double> categoryAverages;

  @HiveField(10)
  List<String> topPerformingHabits;

  @HiveField(11)
  List<String> improvementAreas;

  @HiveField(12)
  DateTime generatedAt;
}
