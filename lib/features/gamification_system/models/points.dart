import 'package:hive/hive.dart';

part 'points.g.dart';

@HiveType(typeId: 26)
class Points extends HiveObject {

  Points({
    required this.id,
    this.totalPoints = 0,
    this.currentLevel = 1,
    this.pointsToNextLevel = 100,
    Map<String, int>? categoryPoints,
    List<PointsTransaction>? transactions,
  }) : categoryPoints = categoryPoints ?? {},
       transactions = transactions ?? [];
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int totalPoints;

  @HiveField(2)
  final int currentLevel;

  @HiveField(3)
  final int pointsToNextLevel;

  @HiveField(4)
  final Map<String, int> categoryPoints; // Points per category

  @HiveField(5)
  final List<PointsTransaction> transactions;

  Points copyWith({
    String? id,
    int? totalPoints,
    int? currentLevel,
    int? pointsToNextLevel,
    Map<String, int>? categoryPoints,
    List<PointsTransaction>? transactions,
  }) {
    return Points(
      id: id ?? this.id,
      totalPoints: totalPoints ?? this.totalPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      pointsToNextLevel: pointsToNextLevel ?? this.pointsToNextLevel,
      categoryPoints: categoryPoints ?? this.categoryPoints,
      transactions: transactions ?? this.transactions,
    );
  }

  double get levelProgress =>
      pointsToNextLevel > 0 ? (totalPoints % 100) / 100.0 : 0.0;

  int get pointsInCurrentLevel => totalPoints % 100;
}

@HiveType(typeId: 27)
class PointsTransaction extends HiveObject { // Habit ID, achievement ID, etc.

  PointsTransaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.timestamp,
    this.relatedId,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final PointsCategory category;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String? relatedId;
}

@HiveType(typeId: 28)
enum PointsCategory {
  @HiveField(0)
  habitCompletion,
  @HiveField(1)
  streak,
  @HiveField(2)
  achievement,
  @HiveField(3)
  workout,
  @HiveField(4)
  social,
  @HiveField(5)
  bonus,
}
