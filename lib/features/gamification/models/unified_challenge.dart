/// نموذج التحدي الموحد
/// يمثل تحدياً واحداً في نظام التحفيز
class UnifiedChallenge {

  const UnifiedChallenge({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.status,
    required this.difficulty,
    required this.startDate,
    required this.endDate,
    required this.targetValue,
    this.currentValue = 0,
    required this.pointsReward,
    required this.iconPath,
    required this.statusColor,
    this.requirements = const [],
    this.isCustom = false,
  });

  /// إنشاء من Map
  factory UnifiedChallenge.fromMap(Map<String, dynamic> map) {
    return UnifiedChallenge(
      id: map['id'] ?? '',
      titleEn: map['titleEn'] ?? '',
      titleAr: map['titleAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      type: ChallengeType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ChallengeType.daily,
      ),
      status: ChallengeStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ChallengeStatus.active,
      ),
      difficulty: ChallengeDifficulty.values.firstWhere(
        (e) => e.name == map['difficulty'],
        orElse: () => ChallengeDifficulty.medium,
      ),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] ?? 0),
      targetValue: map['targetValue']?.toInt() ?? 1,
      currentValue: map['currentValue']?.toInt() ?? 0,
      pointsReward: map['pointsReward']?.toInt() ?? 0,
      iconPath: map['iconPath'] ?? '',
      statusColor: map['statusColor'] ?? '#4CAF50',
      requirements: List<String>.from(map['requirements'] ?? []),
      isCustom: map['isCustom'] ?? false,
    );
  }
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final ChallengeType type;
  final ChallengeStatus status;
  final ChallengeDifficulty difficulty;
  final DateTime startDate;
  final DateTime endDate;
  final int targetValue;
  final int currentValue;
  final int pointsReward;
  final String iconPath;
  final String statusColor;
  final List<String> requirements;
  final bool isCustom;

  /// الحصول على العنوان حسب اللغة
  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  /// الحصول على الوصف حسب اللغة
  String getDescription(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;

  /// نسبة التقدم (0.0 - 1.0)
  double get progress => targetValue > 0 ? currentValue / targetValue : 0.0;

  /// هل التحدي نشط؟
  bool get isActive => status == ChallengeStatus.active;

  /// هل التحدي مكتمل؟
  bool get isCompleted => status == ChallengeStatus.completed;

  /// عدد الأيام المتبقية
  int get daysRemaining {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    return endDate.difference(now).inDays;
  }

  /// اسم حالة التحدي حسب اللغة
  String getStatusName(bool isArabic) {
    switch (status) {
      case ChallengeStatus.active:
        return isArabic ? 'نشط' : 'Active';
      case ChallengeStatus.completed:
        return isArabic ? 'مكتمل' : 'Completed';
      case ChallengeStatus.failed:
        return isArabic ? 'فشل' : 'Failed';
      case ChallengeStatus.expired:
        return isArabic ? 'منتهي الصلاحية' : 'Expired';
    }
  }

  /// اسم صعوبة التحدي حسب اللغة
  String getDifficultyName(bool isArabic) {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return isArabic ? 'سهل' : 'Easy';
      case ChallengeDifficulty.medium:
        return isArabic ? 'متوسط' : 'Medium';
      case ChallengeDifficulty.hard:
        return isArabic ? 'صعب' : 'Hard';
    }
  }

  /// نسخ مع تحديث القيم
  UnifiedChallenge copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    ChallengeType? type,
    ChallengeStatus? status,
    ChallengeDifficulty? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    int? targetValue,
    int? currentValue,
    int? pointsReward,
    String? iconPath,
    String? statusColor,
    List<String>? requirements,
    bool? isCustom,
  }) {
    return UnifiedChallenge(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      type: type ?? this.type,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      pointsReward: pointsReward ?? this.pointsReward,
      iconPath: iconPath ?? this.iconPath,
      statusColor: statusColor ?? this.statusColor,
      requirements: requirements ?? this.requirements,
      isCustom: isCustom ?? this.isCustom,
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
      'status': status.name,
      'difficulty': difficulty.name,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'pointsReward': pointsReward,
      'iconPath': iconPath,
      'statusColor': statusColor,
      'requirements': requirements,
      'isCustom': isCustom,
    };
  }
}

/// أنواع التحديات
enum ChallengeType {
  daily,
  weekly,
  monthly,
  habit,
  streak,
  points,
  special,
  custom,
}

/// حالات التحدي
enum ChallengeStatus { active, completed, failed, expired }

/// مستويات صعوبة التحدي
enum ChallengeDifficulty { easy, medium, hard }
