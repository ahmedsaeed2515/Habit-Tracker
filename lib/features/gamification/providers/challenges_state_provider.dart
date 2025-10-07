import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_gamification_service.dart';
import 'core_gamification_providers.dart';

// مزود حالة التحديات
final challengesStateProvider =
    StateNotifierProvider<ChallengesStateNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      final service = ref.watch(unifiedGamificationServiceProvider);
      return ChallengesStateNotifier(service);
    });

// مدير حالة بيانات التحديات في نظام الألعاب
class ChallengesStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {

  ChallengesStateNotifier(this.service) : super([]);
  final UnifiedGamificationService service;

  // تحديث حالة التحديات
  Future<void> refresh() async {
    try {
      // هذا مجرد حل مؤقت، يجب تعديله لاستخدام خدمة حقيقية
      state = await Future.delayed(
        const Duration(milliseconds: 500),
        _getDefaultChallenges,
      );
    } catch (e) {
      // التعامل مع الأخطاء
    }
  }

  // إضافة تحدي جديد
  void addChallenge(Map<String, dynamic> challenge) {
    state = [...state, challenge];
  }

  // تعيين التحديات (للاختبار)
  void setChallenges(List<Map<String, dynamic>> challenges) {
    state = challenges;
  }

  // تحديث تقدم تحدي
  void updateChallengeProgress(String id, int progress) {
    state = state.map((challenge) {
      if (challenge['id'] == id) {
        return {
          ...challenge,
          'currentProgress': progress,
          'isCompleted': progress >= (challenge['targetValue'] as int),
          'completedAt': progress >= (challenge['targetValue'] as int)
              ? DateTime.now()
              : null,
          'status': progress >= (challenge['targetValue'] as int)
              ? 'completed'
              : challenge['status'],
        };
      }
      return challenge;
    }).toList();
  }

  // بيانات افتراضية للتحديات
  List<Map<String, dynamic>> _getDefaultChallenges() {
    final now = DateTime.now();

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
  }
}
