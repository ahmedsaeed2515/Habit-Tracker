// lib/features/habit_builder/models/habit_template.dart
import 'package:hive/hive.dart';

part 'habit_template.g.dart';

@HiveType(typeId: 21)
class HabitTemplate extends HiveObject {

  HabitTemplate({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.category,
    required this.recommendedFrequency,
    required this.tags,
    required this.iconName,
    required this.colorCode,
    required this.difficultyLevel,
    required this.tips,
    required this.estimatedDurationMinutes,
    required this.popularityScore,
    required this.prerequisites,
    required this.isRecommended,
    required this.createdAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String nameAr;

  @HiveField(2)
  String nameEn;

  @HiveField(3)
  String descriptionAr;

  @HiveField(4)
  String descriptionEn;

  @HiveField(5)
  HabitCategory category;

  @HiveField(6)
  int recommendedFrequency; // مرات في الأسبوع

  @HiveField(7)
  List<String> tags;

  @HiveField(8)
  String iconName;

  @HiveField(9)
  String colorCode;

  @HiveField(10)
  int difficultyLevel; // 1-5

  @HiveField(11)
  List<String> tips;

  @HiveField(12)
  int estimatedDurationMinutes;

  @HiveField(13)
  double popularityScore;

  @HiveField(14)
  List<String> prerequisites; // عادات أخرى يُنصح بتكوينها أولاً

  @HiveField(15)
  bool isRecommended;

  @HiveField(16)
  DateTime createdAt;

  // Helper methods
  String getName(String language) {
    return language == 'ar' ? nameAr : nameEn;
  }

  String getDescription(String language) {
    return language == 'ar' ? descriptionAr : descriptionEn;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'category': category.toString(),
      'recommendedFrequency': recommendedFrequency,
      'tags': tags,
      'iconName': iconName,
      'colorCode': colorCode,
      'difficultyLevel': difficultyLevel,
      'tips': tips,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'popularityScore': popularityScore,
      'prerequisites': prerequisites,
      'isRecommended': isRecommended,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

@HiveType(typeId: 22)
enum HabitCategory {
  @HiveField(0)
  health,

  @HiveField(1)
  fitness,

  @HiveField(2)
  productivity,

  @HiveField(3)
  learning,

  @HiveField(4)
  social,

  @HiveField(5)
  spiritual,

  @HiveField(6)
  creative,

  @HiveField(7)
  financial,

  @HiveField(8)
  environmental,

  @HiveField(9)
  personal;

  String getDisplayName(String language) {
    switch (this) {
      case HabitCategory.health:
        return language == 'ar' ? 'الصحة' : 'Health';
      case HabitCategory.fitness:
        return language == 'ar' ? 'اللياقة البدنية' : 'Fitness';
      case HabitCategory.productivity:
        return language == 'ar' ? 'الإنتاجية' : 'Productivity';
      case HabitCategory.learning:
        return language == 'ar' ? 'التعلم' : 'Learning';
      case HabitCategory.social:
        return language == 'ar' ? 'الاجتماعية' : 'Social';
      case HabitCategory.spiritual:
        return language == 'ar' ? 'الروحانية' : 'Spiritual';
      case HabitCategory.creative:
        return language == 'ar' ? 'الإبداع' : 'Creative';
      case HabitCategory.financial:
        return language == 'ar' ? 'المالية' : 'Financial';
      case HabitCategory.environmental:
        return language == 'ar' ? 'البيئة' : 'Environmental';
      case HabitCategory.personal:
        return language == 'ar' ? 'التطوير الشخصي' : 'Personal Development';
    }
  }
}

@HiveType(typeId: 23)
class UserProfile extends HiveObject {

  UserProfile({
    required this.id,
    required this.interests,
    required this.fitnessLevel,
    required this.availableTimes,
    required this.motivationStyle,
    required this.challenges,
    required this.completedHabits,
    required this.lastUpdated,
    required this.experiencePoints,
    required this.achievements,
    required this.preferences,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  List<HabitCategory> interests;

  @HiveField(2)
  int fitnessLevel; // 1-5

  @HiveField(3)
  List<String> availableTimes; // أوقات متاحة في اليوم

  @HiveField(4)
  int motivationStyle; // نمط التحفيز المفضل

  @HiveField(5)
  List<String> challenges; // التحديات الحالية

  @HiveField(6)
  Map<String, int> completedHabits; // عدد العادات المكتملة بكل فئة

  @HiveField(7)
  DateTime lastUpdated;

  @HiveField(8)
  int experiencePoints;

  @HiveField(9)
  List<String> achievements;

  @HiveField(10)
  Map<String, dynamic> preferences;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interests': interests.map((e) => e.toString()).toList(),
      'fitnessLevel': fitnessLevel,
      'availableTimes': availableTimes,
      'motivationStyle': motivationStyle,
      'challenges': challenges,
      'completedHabits': completedHabits,
      'lastUpdated': lastUpdated.toIso8601String(),
      'experiencePoints': experiencePoints,
      'achievements': achievements,
      'preferences': preferences,
    };
  }
}
