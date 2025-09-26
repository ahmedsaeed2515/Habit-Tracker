import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../services/unified_gamification_service.dart';
import 'core_gamification_providers.dart';

/// مُقدِمات التحديات - ملف منفصل للصيانة (أقل من 200 سطر)
/// يحتوي على جميع المُقدِمات والمديرين المتعلقين بالتحديات

// ملاحظة: هذه النماذج ستحتاج للتعريف لاحقاً
// typedef UnifiedChallenge = Map<String, dynamic>;
// enum ChallengeType { daily, weekly, monthly, custom }
// enum ChallengeStatus { active, completed, expired, pending }
// enum ChallengeDifficulty { easy, medium, hard, expert }

// مقدم التحديات (مبسط للآن)
final challengesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final now = DateTime.now();

  // تحديات افتراضية للاختبار
  return [
    {
      'id': 'daily_habits',
      'title': 'عادات يومية',
      'description': 'أكمل 3 عادات في يوم واحد',
      'type': 'daily',
      'status': 'active',
      'difficulty': 'easy',
      'targetValue': 3,
      'currentProgress': 1,
      'pointsReward': 50,
      'startDate': now.subtract(const Duration(days: 1)),
      'endDate': now.add(const Duration(hours: 12)),
      'isActive': true,
      'isCompleted': false,
      'completedAt': null,
    },
    {
      'id': 'weekly_streak',
      'title': 'خط أسبوعي',
      'description': 'حافظ على خط لمدة 7 أيام',
      'type': 'weekly',
      'status': 'active',
      'difficulty': 'medium',
      'targetValue': 7,
      'currentProgress': 3,
      'pointsReward': 200,
      'startDate': now.subtract(const Duration(days: 3)),
      'endDate': now.add(const Duration(days: 4)),
      'isActive': true,
      'isCompleted': false,
      'completedAt': null,
    },
    {
      'id': 'points_challenge',
      'title': 'جامع النقاط',
      'description': 'اجمع 500 نقطة في الشهر',
      'type': 'monthly',
      'status': 'completed',
      'difficulty': 'hard',
      'targetValue': 500,
      'currentProgress': 500,
      'pointsReward': 1000,
      'startDate': now.subtract(const Duration(days: 30)),
      'endDate': now.subtract(const Duration(days: 1)),
      'isActive': false,
      'isCompleted': true,
      'completedAt': now.subtract(const Duration(days: 1)),
    },
  ];
});

// مقدم التحديات النشطة
final activeChallengesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final challenges = ref.watch(challengesProvider);
  return challenges.where((c) => c['isActive'] == true).toList();
});

// مقدم التحديات المكتملة
final completedChallengesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final challenges = ref.watch(challengesProvider);
  return challenges.where((c) => c['isCompleted'] == true).toList();
});

// مقدم التحديات المنتهية الصلاحية
final expiredChallengesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final challenges = ref.watch(challengesProvider);
  final now = DateTime.now();

  return challenges.where((c) {
    final endDate = c['endDate'] as DateTime;
    return c['status'] == 'active' && endDate.isBefore(now);
  }).toList();
});

// مقدم التحديات حسب النوع
final challengesByTypeProvider =
    Provider<Map<String, List<Map<String, dynamic>>>>((ref) {
      final challenges = ref.watch(challengesProvider);
      final groupedChallenges = <String, List<Map<String, dynamic>>>{};

      for (final challenge in challenges) {
        final type = challenge['type'] as String;
        if (!groupedChallenges.containsKey(type)) {
          groupedChallenges[type] = [];
        }
        groupedChallenges[type]!.add(challenge);
      }

      return groupedChallenges;
    });

// مقدم إحصائيات التحديات
final challengesStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final challenges = ref.watch(challengesProvider);
  final completedCount = challenges
      .where((c) => c['isCompleted'] == true)
      .length;
  final activeCount = challenges.where((c) => c['isActive'] == true).length;
  final totalCount = challenges.length;

  return {
    'total': totalCount,
    'active': activeCount,
    'completed': completedCount,
    'completionRate': totalCount > 0 ? completedCount / totalCount : 0.0,
    'byType': _groupChallengesByType(challenges),
    'byDifficulty': _groupChallengesByDifficulty(challenges),
  };
});

// طرق مساعدة للتحديات
Map<String, int> _groupChallengesByType(List<Map<String, dynamic>> challenges) {
  final groups = <String, int>{};
  for (final challenge in challenges) {
    final type = challenge['type'] as String;
    groups[type] = (groups[type] ?? 0) + 1;
  }
  return groups;
}

Map<String, int> _groupChallengesByDifficulty(
  List<Map<String, dynamic>> challenges,
) {
  final groups = <String, int>{};
  for (final challenge in challenges) {
    final difficulty = challenge['difficulty'] as String;
    groups[difficulty] = (groups[difficulty] ?? 0) + 1;
  }
  return groups;
}

// دالات للتفاعل مع التحديات
final challengeActionsProvider = Provider<ChallengeActions>((ref) {
  final service = ref.watch(unifiedGamificationServiceProvider);
  return ChallengeActions(service);
});

class ChallengeActions {
  final UnifiedGamificationService _service;

  ChallengeActions(this._service);

  // إنشاء تحدي مخصص
  Future<Map<String, dynamic>?> createCustomChallenge({
    required String titleEn,
    required String titleAr,
    required String descriptionEn,
    required String descriptionAr,
    required String type,
    required DateTime endDate,
    required int targetValue,
    required int pointsReward,
    String difficulty = 'medium',
    String iconPath = 'assets/challenges/custom.png',
  }) async {
    try {
      // منطق إنشاء التحدي المخصص
      // سيتم تطويره لاحقاً
      final challengeId = 'custom_${DateTime.now().millisecondsSinceEpoch}';

      return {
        'id': challengeId,
        'title': titleAr,
        'description': descriptionAr,
        'type': type,
        'status': 'active',
        'difficulty': difficulty,
        'targetValue': targetValue,
        'currentProgress': 0,
        'pointsReward': pointsReward,
        'startDate': DateTime.now(),
        'endDate': endDate,
        'isActive': true,
        'isCompleted': false,
        'completedAt': null,
        'iconPath': iconPath,
      };
    } catch (e) {
      debugPrint('Error creating custom challenge: $e');
      return null;
    }
  }

  // تحديث تقدم التحدي
  Future<bool> updateProgress(String challengeId, int progressValue) async {
    try {
      // منطق تحديث التقدم
      // سيتم تطويره لاحقاً
      debugPrint(
        'Updating progress for challenge $challengeId: $progressValue',
      );
      return true;
    } catch (e) {
      debugPrint('Error updating challenge progress: $e');
      return false;
    }
  }

  // إكمال التحدي
  Future<bool> completeChallenge(String challengeId) async {
    try {
      // منطق إكمال التحدي
      // سيتم تطويره لاحقاً
      debugPrint('Completing challenge: $challengeId');
      return true;
    } catch (e) {
      debugPrint('Error completing challenge: $e');
      return false;
    }
  }

  // حساب نقاط التحديات
  int calculateChallengePoints(List<Map<String, dynamic>> challenges) {
    return challenges
        .where((c) => c['isCompleted'] == true)
        .map((c) => c['pointsReward'] as int)
        .fold(0, (sum, points) => sum + points);
  }
}
