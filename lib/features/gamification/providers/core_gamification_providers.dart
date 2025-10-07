import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_gamification_service.dart';
import '../models/gamification_data.dart';
import 'user_game_data_notifier.dart';

/// مُقدِمات الخدمات الأساسية لنظام التحفيز
/// ملف يحتوي على المُقدِمات الأساسية فقط (أقل من 100 سطر)

// مقدم الخدمة الموحدة
final unifiedGamificationServiceProvider = Provider<UnifiedGamificationService>(
  (ref) {
    return UnifiedGamificationService();
  },
);

// مقدم بيانات المستخدم
final userGameDataProvider =
    StateNotifierProvider<UserGameDataNotifier, UserGameData>((ref) {
      final service = ref.watch(unifiedGamificationServiceProvider);
      return UserGameDataNotifier(service);
    });

// مقدم الإحصائيات الأساسية
final gamificationStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final service = ref.watch(unifiedGamificationServiceProvider);
  return service.getGamificationStats();
});

// مقدم المكافآت اليومية
final dailyRewardProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final service = ref.watch(unifiedGamificationServiceProvider);
  return service.getDailyReward();
});

// مقدم إحصائيات المستوى
final levelInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);

  return {
    'level': userData.currentLevel,
    'totalPoints': userData.totalPoints,
    'levelProgress': userData.levelProgress,
    'pointsToNext': userData.pointsNeededForNextLevel,
    'levelColor': _getLevelColor(userData.currentLevel),
    'levelTitle': _getLevelTitle(userData.currentLevel),
  };
});

// مقدم إحصائيات الخطوط
final streakInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final userData = ref.watch(userGameDataProvider);

  return {
    'current': userData.currentStreak,
    'longest': userData.longestStreak,
    'weekly': userData.weeklyPoints,
    'monthly': userData.monthlyPoints,
  };
});

// =========================== طرق مساعدة ===========================

String _getLevelColor(int level) {
  if (level >= 50) return '#FFD700'; // ذهبي
  if (level >= 25) return '#FF6B35'; // برتقالي محمر
  if (level >= 15) return '#9C27B0'; // بنفسجي
  if (level >= 10) return '#FF9800'; // برتقالي
  if (level >= 5) return '#2196F3'; // أزرق
  return '#4CAF50'; // أخضر
}

String _getLevelTitle(int level) {
  if (level >= 50) return 'أسطوري';
  if (level >= 25) return 'بطل';
  if (level >= 15) return 'خبير';
  if (level >= 10) return 'متقدم';
  if (level >= 5) return 'متوسط';
  return 'مبتدئ';
}
