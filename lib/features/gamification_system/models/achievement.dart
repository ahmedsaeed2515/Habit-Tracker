import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 20)
class Achievement extends HiveObject {

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.points,
    required this.category,
    required this.rarity,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0,
    required this.maxProgress,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconPath;

  @HiveField(4)
  final int points;

  @HiveField(5)
  final AchievementCategory category;

  @HiveField(6)
  final AchievementRarity rarity;

  @HiveField(7)
  final bool isUnlocked;

  @HiveField(8)
  final DateTime? unlockedAt;

  @HiveField(9)
  final int progress;

  @HiveField(10)
  final int maxProgress;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    int? points,
    AchievementCategory? category,
    AchievementRarity? rarity,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? progress,
    int? maxProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      points: points ?? this.points,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      maxProgress: maxProgress ?? this.maxProgress,
    );
  }

  double get progressPercentage =>
      maxProgress > 0 ? progress / maxProgress : 0.0;

  bool get isCompleted => progress >= maxProgress;
}

@HiveType(typeId: 21)
enum AchievementCategory {
  @HiveField(0)
  habitStreak,
  @HiveField(1)
  habitCompletion,
  @HiveField(2)
  workout,
  @HiveField(3)
  social,
  @HiveField(4)
  milestone,
  @HiveField(5)
  special,
}

@HiveType(typeId: 22)
enum AchievementRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  rare,
  @HiveField(2)
  epic,
  @HiveField(3)
  legendary,
}
