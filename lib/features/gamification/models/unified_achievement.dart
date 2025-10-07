/// نموذج الإنجاز الموحد
/// يمثل إنجازاً واحداً في نظام التحفيز
class UnifiedAchievement {

  const UnifiedAchievement({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.rarity,
    required this.pointsReward,
    required this.iconPath,
    required this.rarityColor,
    this.isUnlocked = false,
    this.unlockedAt,
    this.requirements = const [],
    this.progress = 0.0,
  });

  /// إنشاء من Map
  factory UnifiedAchievement.fromMap(Map<String, dynamic> map) {
    return UnifiedAchievement(
      id: map['id'] ?? '',
      titleEn: map['titleEn'] ?? '',
      titleAr: map['titleAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      type: AchievementType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AchievementType.habit,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.name == map['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      pointsReward: map['pointsReward']?.toInt() ?? 0,
      iconPath: map['iconPath'] ?? '',
      rarityColor: map['rarityColor'] ?? '#4CAF50',
      isUnlocked: map['isUnlocked'] ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? (map['unlockedAt'] is DateTime
                ? map['unlockedAt']
                : DateTime.fromMillisecondsSinceEpoch(map['unlockedAt'] as int))
          : null,
      requirements: List<String>.from(map['requirements'] ?? []),
      progress: map['progress']?.toDouble() ?? 0.0,
    );
  }
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final AchievementType type;
  final AchievementRarity rarity;
  final int pointsReward;
  final String iconPath;
  final String rarityColor;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final List<String> requirements;
  final double progress;

  /// الحصول على العنوان حسب اللغة
  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  /// الحصول على الوصف حسب اللغة
  String getDescription(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;

  /// الحصول على اسم الندرة حسب اللغة
  String getRarityName(bool isArabic) {
    switch (rarity) {
      case AchievementRarity.common:
        return isArabic ? 'عادي' : 'Common';
      case AchievementRarity.rare:
        return isArabic ? 'نادر' : 'Rare';
      case AchievementRarity.epic:
        return isArabic ? 'ملحمي' : 'Epic';
      case AchievementRarity.legendary:
        return isArabic ? 'أسطوري' : 'Legendary';
    }
  }

  /// نسخ مع تحديث القيم
  UnifiedAchievement copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    AchievementType? type,
    AchievementRarity? rarity,
    int? pointsReward,
    String? iconPath,
    String? rarityColor,
    bool? isUnlocked,
    DateTime? unlockedAt,
    List<String>? requirements,
    double? progress,
  }) {
    return UnifiedAchievement(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      pointsReward: pointsReward ?? this.pointsReward,
      iconPath: iconPath ?? this.iconPath,
      rarityColor: rarityColor ?? this.rarityColor,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requirements: requirements ?? this.requirements,
      progress: progress ?? this.progress,
    );
  }

  /// تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'type': type.name,
      'rarity': rarity.name,
      'pointsReward': pointsReward,
      'iconPath': iconPath,
      'rarityColor': rarityColor,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
      'requirements': requirements,
      'progress': progress,
    };
  }
}

/// أنواع الإنجازات
enum AchievementType { habit, streak, points, challenge, level, special }

/// مستويات ندرة الإنجازات
enum AchievementRarity { common, rare, epic, legendary }
