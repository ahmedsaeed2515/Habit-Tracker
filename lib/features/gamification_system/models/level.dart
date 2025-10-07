import 'package:hive/hive.dart';

part 'level.g.dart';

@HiveType(typeId: 29)
class Level extends HiveObject {

  Level({
    required this.levelNumber,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.iconPath,
    List<String>? rewards,
    required this.theme,
  }) : rewards = rewards ?? [];
  @HiveField(0)
  final int levelNumber;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int pointsRequired;

  @HiveField(4)
  final String iconPath;

  @HiveField(5)
  final List<String> rewards; // List of reward IDs

  @HiveField(6)
  final LevelTheme theme;

  Level copyWith({
    int? levelNumber,
    String? name,
    String? description,
    int? pointsRequired,
    String? iconPath,
    List<String>? rewards,
    LevelTheme? theme,
  }) {
    return Level(
      levelNumber: levelNumber ?? this.levelNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      iconPath: iconPath ?? this.iconPath,
      rewards: rewards ?? this.rewards,
      theme: theme ?? this.theme,
    );
  }

  static int calculatePointsForLevel(int level) {
    // Points required doubles every 5 levels
    return (level * 100) + ((level ~/ 5) * 500);
  }

  static Level createDefaultLevel(int levelNumber) {
    return Level(
      levelNumber: levelNumber,
      name: 'Level $levelNumber',
      description: 'Reach level $levelNumber to unlock new rewards!',
      pointsRequired: calculatePointsForLevel(levelNumber),
      iconPath: 'assets/icons/levels/level_$levelNumber.png',
      theme: LevelTheme.values[levelNumber % LevelTheme.values.length],
    );
  }
}

@HiveType(typeId: 30)
enum LevelTheme {
  @HiveField(0)
  bronze,
  @HiveField(1)
  silver,
  @HiveField(2)
  gold,
  @HiveField(3)
  platinum,
  @HiveField(4)
  diamond,
  @HiveField(5)
  master,
}
