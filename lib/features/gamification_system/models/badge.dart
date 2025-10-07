import 'package:hive/hive.dart';

part 'badge.g.dart';

@HiveType(typeId: 23)
class Badge extends HiveObject { // User ID or achievement ID

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.type,
    required this.rarity,
    this.isEarned = false,
    this.earnedAt,
    this.earnedBy,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconPath;

  @HiveField(4)
  final BadgeType type;

  @HiveField(5)
  final BadgeRarity rarity;

  @HiveField(6)
  final bool isEarned;

  @HiveField(7)
  final DateTime? earnedAt;

  @HiveField(8)
  final String? earnedBy;

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    BadgeType? type,
    BadgeRarity? rarity,
    bool? isEarned,
    DateTime? earnedAt,
    String? earnedBy,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      isEarned: isEarned ?? this.isEarned,
      earnedAt: earnedAt ?? this.earnedAt,
      earnedBy: earnedBy ?? this.earnedBy,
    );
  }
}

@HiveType(typeId: 24)
enum BadgeType {
  @HiveField(0)
  streak,
  @HiveField(1)
  completion,
  @HiveField(2)
  milestone,
  @HiveField(3)
  social,
  @HiveField(4)
  special,
}

@HiveType(typeId: 25)
enum BadgeRarity {
  @HiveField(0)
  bronze,
  @HiveField(1)
  silver,
  @HiveField(2)
  gold,
  @HiveField(3)
  platinum,
}
