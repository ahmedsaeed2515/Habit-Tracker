import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/unified_gamification_service.dart';
import 'core_gamification_providers.dart';

/// مُقدِمات الإنجازات - ملف منفصل للصيانة (أقل من 200 سطر)
/// يحتوي على جميع المُقدِمات والمديرين المتعلقين بالإنجازات

// ملاحظة: هذه النماذج ستحتاج للتعريف لاحقاً
// typedef UnifiedAchievement = Map<String, dynamic>;
// enum AchievementType { habit, streak, points, level, challenge }
// enum AchievementRarity { common, rare, epic, legendary }

// مقدم الإنجازات (مبسط للآن)
final achievementsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  // إنجازات افتراضية للاختبار
  return [
    {
      'id': 'first_habit',
      'title': 'العادة الأولى',
      'description': 'أكمل أول عادة',
      'isUnlocked': true,
      'type': 'habit',
      'rarity': 'common',
      'points': 10,
      'unlockedAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'week_streak',
      'title': 'أسبوع متواصل',
      'description': 'حافظ على خط لأسبوع كامل',
      'isUnlocked': false,
      'type': 'streak',
      'rarity': 'rare',
      'points': 100,
      'unlockedAt': null,
    },
    {
      'id': 'hundred_points',
      'title': 'مئة نقطة',
      'description': 'اجمع 100 نقطة',
      'isUnlocked': false,
      'type': 'points',
      'rarity': 'common',
      'points': 50,
      'unlockedAt': null,
    },
  ];
});

// مقدم الإنجازات المفتوحة
final unlockedAchievementsProvider = Provider<List<Map<String, dynamic>>>((
  ref,
) {
  final achievements = ref.watch(achievementsProvider);
  return achievements.where((a) => a['isUnlocked'] == true).toList();
});

// مقدم الإنجازات الأخيرة
final recentAchievementsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final unlockedAchievements = ref.watch(unlockedAchievementsProvider);
  final sortedAchievements = List<Map<String, dynamic>>.from(
    unlockedAchievements,
  );

  sortedAchievements.sort((a, b) {
    final dateA = a['unlockedAt'] as DateTime?;
    final dateB = b['unlockedAt'] as DateTime?;

    if (dateA == null || dateB == null) return 0;
    return dateB.compareTo(dateA);
  });

  return sortedAchievements.take(5).toList();
});

// مقدم الإنجازات النادرة
final rareAchievementsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final unlockedAchievements = ref.watch(unlockedAchievementsProvider);
  return unlockedAchievements
      .where(
        (a) =>
            a['rarity'] == 'rare' ||
            a['rarity'] == 'epic' ||
            a['rarity'] == 'legendary',
      )
      .toList();
});

// مقدم الإنجازات حسب النوع
final achievementsByTypeProvider =
    Provider<Map<String, List<Map<String, dynamic>>>>((ref) {
      final achievements = ref.watch(achievementsProvider);
      final groupedAchievements = <String, List<Map<String, dynamic>>>{};

      for (final achievement in achievements) {
        final type = achievement['type'] as String;
        if (!groupedAchievements.containsKey(type)) {
          groupedAchievements[type] = [];
        }
        groupedAchievements[type]!.add(achievement);
      }

      return groupedAchievements;
    });

// مقدم إحصائيات الإنجازات
final achievementsStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final achievements = ref.watch(achievementsProvider);
  final unlockedCount = achievements
      .where((a) => a['isUnlocked'] == true)
      .length;
  final totalCount = achievements.length;

  return {
    'total': totalCount,
    'unlocked': unlockedCount,
    'completionRate': totalCount > 0 ? unlockedCount / totalCount : 0.0,
    'byType': _groupAchievementsByType(achievements),
    'byRarity': _groupAchievementsByRarity(achievements),
  };
});

// طرق مساعدة للإنجازات
Map<String, int> _groupAchievementsByType(
  List<Map<String, dynamic>> achievements,
) {
  final groups = <String, int>{};
  for (final achievement in achievements.where(
    (a) => a['isUnlocked'] == true,
  )) {
    final type = achievement['type'] as String;
    groups[type] = (groups[type] ?? 0) + 1;
  }
  return groups;
}

Map<String, int> _groupAchievementsByRarity(
  List<Map<String, dynamic>> achievements,
) {
  final groups = <String, int>{};
  for (final achievement in achievements.where(
    (a) => a['isUnlocked'] == true,
  )) {
    final rarity = achievement['rarity'] as String;
    groups[rarity] = (groups[rarity] ?? 0) + 1;
  }
  return groups;
}

// دالات للتفاعل مع الإنجازات
final achievementActionsProvider = Provider<AchievementActions>((ref) {
  final service = ref.watch(unifiedGamificationServiceProvider);
  return AchievementActions(service);
});

class AchievementActions {

  AchievementActions(this._service);
  final UnifiedGamificationService _service;

  // إلغاء قفل إنجاز يدوياً
  Future<bool> unlockAchievement(String achievementId) async {
    try {
      await _service.unlockAchievement(achievementId);
      return true;
    } catch (e) {
      debugPrint('Error unlocking achievement: $e');
      return false;
    }
  }

  // التحقق من الإنجازات الجديدة
  Future<List<Map<String, dynamic>>> checkForNewAchievements() async {
    // منطق التحقق من الإنجازات الجديدة
    // سيتم تطويره لاحقاً
    return [];
  }

  // حساب نقاط الإنجازات
  int calculateAchievementPoints(List<Map<String, dynamic>> achievements) {
    return achievements
        .where((a) => a['isUnlocked'] == true)
        .map((a) => a['points'] as int)
        .fold(0, (sum, points) => sum + points);
  }
}
