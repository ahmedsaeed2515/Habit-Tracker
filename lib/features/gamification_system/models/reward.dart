import 'package:hive/hive.dart';

part 'reward.g.dart';

@HiveType(typeId: 35)
class Reward extends HiveObject { // Additional data for specific reward types

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.type,
    required this.cost,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.rarity,
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconPath;

  @HiveField(4)
  final RewardType type;

  @HiveField(5)
  final int cost; // Points required to unlock

  @HiveField(6)
  final bool isUnlocked;

  @HiveField(7)
  final DateTime? unlockedAt;

  @HiveField(8)
  final RewardRarity rarity;

  @HiveField(9)
  final Map<String, dynamic> metadata;

  Reward copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    RewardType? type,
    int? cost,
    bool? isUnlocked,
    DateTime? unlockedAt,
    RewardRarity? rarity,
    Map<String, dynamic>? metadata,
  }) {
    return Reward(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rarity: rarity ?? this.rarity,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 36)
enum RewardType {
  @HiveField(0)
  theme,
  @HiveField(1)
  avatar,
  @HiveField(2)
  sound,
  @HiveField(3)
  animation,
  @HiveField(4)
  feature,
  @HiveField(5)
  badge,
  @HiveField(6)
  title,
}

@HiveType(typeId: 37)
enum RewardRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  rare,
  @HiveField(2)
  epic,
  @HiveField(3)
  legendary,
}
