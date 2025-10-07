import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_gamification_service.dart';
import 'core_gamification_providers.dart';

// مزود حالة الإنجازات
final achievementsStateProvider =
    StateNotifierProvider<
      AchievementsStateNotifier,
      List<Map<String, dynamic>>
    >((ref) {
      final service = ref.watch(unifiedGamificationServiceProvider);
      return AchievementsStateNotifier(service);
    });

// مدير حالة الإنجازات في نظام الألعاب
class AchievementsStateNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {

  AchievementsStateNotifier(this.service) : super([]);
  final UnifiedGamificationService service;

  // تحديث حالة الإنجازات
  Future<void> refresh() async {
    try {
      // هذا مجرد حل مؤقت، يجب تعديله لاستخدام خدمة حقيقية
      state = await Future.delayed(
        const Duration(milliseconds: 500),
        _getDefaultAchievements,
      );
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

  // بيانات افتراضية للإنجازات
  List<Map<String, dynamic>> _getDefaultAchievements() {
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
  }
}
