import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_gamification_service.dart';

// مدير حالة بيانات التحديات في نظام الألعاب
class ChallengesStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final UnifiedGamificationService service;

  ChallengesStateNotifier(this.service) : super([]);

  // تحديث حالة التحديات
  Future<void> refresh() async {
    try {
      final challenges = await service.getUserChallenges();
      state = challenges;
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
}
