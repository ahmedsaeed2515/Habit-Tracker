import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_gamification_service.dart';
import 'core_gamification_providers.dart';

// مدير حالة بيانات المستخدم في نظام الألعاب
class AchievementsStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final UnifiedGamificationService service;

  AchievementsStateNotifier(this.service) : super([]);

  // تحديث حالة الإنجازات
  Future<void> refresh() async {
    try {
      final achievements = await service.getUserAchievements();
      state = achievements;
    } catch (e) {
      // التعامل مع الأخطاء
    }
  }

  // إضافة إنجاز جديد (للاختبار)
  void addAchievement(Map<String, dynamic> achievement) {
    state = [...state, achievement];
  }

  // تعيين الإنجازات (للاختبار)
  void setAchievements(List<Map<String, dynamic>> achievements) {
    state = achievements;
  }
}

// مزود حالة الإنجازات
final achievementsStateProvider =
    StateNotifierProvider<
      AchievementsStateNotifier,
      List<Map<String, dynamic>>
    >((ref) {
      final service = ref.watch(unifiedGamificationServiceProvider);
      return AchievementsStateNotifier(service);
    });
