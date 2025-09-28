import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unified_gamification_provider.dart';
import '../models/unified_achievement.dart';
import '../models/unified_challenge.dart';

/// فئة لجميع الويدجات والأقسام المساعدة في الشاشة الرئيسية
class EnhancedGamificationWidgets {
  /// قسم أحدث الإنجازات
  static Widget buildRecentAchievementsSection(
    BuildContext context,
    bool isArabic,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final recentAchievements = ref.watch(recentAchievementsProvider);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'أحدث الإنجازات' : 'Recent Achievements',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // TODO: التنقل إلى تبويب الإنجازات
                        },
                        child: Text(isArabic ? 'عرض الكل' : 'View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (recentAchievements.isEmpty)
                    _buildEmptyAchievements(context, isArabic)
                  else
                    ...recentAchievements.take(3).map((achievement) {
                      try {
                        return _buildAchievementTile(
                          context,
                          isArabic,
                          UnifiedAchievement.fromMap(achievement),
                        );
                      } catch (e) {
                        debugPrint('خطأ في تحويل الإنجاز: $e');
                        return const SizedBox.shrink();
                      }
                    }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// قسم التحديات النشطة
  static Widget buildActiveChallengesSection(
    BuildContext context,
    bool isArabic,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final activeChallenges = ref.watch(activeChallengesProvider);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'التحديات النشطة' : 'Active Challenges',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // TODO: التنقل إلى تبويب التحديات
                        },
                        child: Text(isArabic ? 'عرض الكل' : 'View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (activeChallenges.isEmpty)
                    _buildEmptyChallenges(context, isArabic)
                  else
                    ...activeChallenges
                        .take(3)
                        .map(
                          (challenge) => _buildChallengeTile(
                            context,
                            isArabic,
                            UnifiedChallenge.fromMap(challenge),
                          ),
                        )
                        .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// قسم النصائح السريعة
  static Widget buildQuickTipsSection(BuildContext context, bool isArabic) {
    final tips = isArabic
        ? [
            'أكمل عاداتك يومياً لزيادة نقاطك',
            'حافظ على خط الإنجاز للحصول على مكافآت إضافية',
            'شارك في التحديات لكسب نقاط أكثر',
            'استلم مكافأتك اليومية كل يوم',
          ]
        : [
            'Complete habits daily to earn more points',
            'Maintain streaks for bonus rewards',
            'Participate in challenges for extra points',
            'Claim your daily reward every day',
          ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_rounded, color: Colors.amber[600]),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'نصائح سريعة' : 'Quick Tips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...tips
                  .map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tip,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  /// قسم الإنجازات النادرة
  static Widget buildRareAchievementsSection(
    BuildContext context,
    bool isArabic,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final rareAchievements = ref.watch(rareAchievementsProvider);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'الإنجازات النادرة' : 'Rare Achievements',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (rareAchievements.isEmpty)
                    _buildEmptyRareAchievements(context, isArabic)
                  else
                    ...rareAchievements
                        .take(5)
                        .map(
                          (achievement) => _buildRareAchievementTile(
                            context,
                            isArabic,
                            UnifiedAchievement.fromMap(achievement),
                          ),
                        )
                        .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// قسم تاريخ المكافآت
  static Widget buildRewardsHistorySection(
    BuildContext context,
    bool isArabic,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'تاريخ المكافآت' : 'Rewards History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.construction_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? 'قريباً...' : 'Coming Soon...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عرض قائمة الإعدادات
  static void showSettingsMenu(
    BuildContext context,
    bool isArabic,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? 'خيارات النظام' : 'System Options',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.file_download_rounded),
              title: Text(isArabic ? 'تصدير البيانات' : 'Export Data'),
              onTap: () => _exportData(context, isArabic),
            ),

            ListTile(
              leading: const Icon(Icons.file_upload_rounded),
              title: Text(isArabic ? 'استيراد البيانات' : 'Import Data'),
              onTap: () => _importData(context, isArabic),
            ),

            ListTile(
              leading: const Icon(Icons.cleaning_services_rounded),
              title: Text(
                isArabic ? 'تنظيف البيانات القديمة' : 'Cleanup Old Data',
              ),
              onTap: () => _cleanupData(context, isArabic, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// عرض حوار إنشاء تحدي جديد
  static void showCreateChallengeDialog(BuildContext context, bool isArabic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'ميزة إنشاء التحديات المخصصة قريباً'
              : 'Custom challenge creation coming soon',
        ),
      ),
    );
  }

  // ============== الطرق المساعدة الخاصة ==============

  /// بناء عنصر إنجاز فارغ
  static Widget _buildEmptyAchievements(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'لا توجد إنجازات بعد' : 'No achievements yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر تحديات فارغ
  static Widget _buildEmptyChallenges(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'لا توجد تحديات نشطة' : 'No active challenges',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر إنجازات نادرة فارغ
  static Widget _buildEmptyRareAchievements(
    BuildContext context,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'لا توجد إنجازات نادرة بعد' : 'No rare achievements yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// بناء عنصر إنجاز
  static Widget _buildAchievementTile(
    BuildContext context,
    bool isArabic,
    UnifiedAchievement achievement,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(
            int.parse(achievement.rarityColor.substring(1), radix: 16) +
                0xFF000000,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
      ),
      title: Text(
        achievement.getTitle(isArabic),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        achievement.getDescription(isArabic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '+${achievement.pointsReward}',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// بناء عنصر تحدي
  static Widget _buildChallengeTile(
    BuildContext context,
    bool isArabic,
    UnifiedChallenge challenge,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF${challenge.statusColor.substring(1)}')),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.flag, color: Colors.white, size: 20),
      ),
      title: Text(
        challenge.getTitle(isArabic),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: challenge.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(int.parse('0xFF${challenge.statusColor.substring(1)}')),
            ),
            minHeight: 3,
          ),
          const SizedBox(height: 4),
          Text(
            '${(challenge.progress * 100).toInt()}% • ${challenge.daysRemaining} ${isArabic ? 'أيام متبقية' : 'days left'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Text(
        '+${challenge.pointsReward}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// بناء عنصر إنجاز نادر
  static Widget _buildRareAchievementTile(
    BuildContext context,
    bool isArabic,
    UnifiedAchievement achievement,
  ) {
    final rarityColor = Color(
      int.parse('0xFF${achievement.rarityColor.substring(1)}'),
    );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [rarityColor, rarityColor.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: rarityColor, width: 2),
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
      ),
      title: Text(
        achievement.getTitle(isArabic),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        achievement.getRarityName(isArabic),
        style: TextStyle(color: rarityColor, fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: rarityColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rarityColor),
        ),
        child: Text(
          '+${achievement.pointsReward}',
          style: TextStyle(
            color: rarityColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ============== إجراءات الإعدادات ==============

  static void _exportData(BuildContext context, bool isArabic) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'ميزة تصدير البيانات قريباً' : 'Data export coming soon',
        ),
      ),
    );
  }

  static void _importData(BuildContext context, bool isArabic) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? 'ميزة استيراد البيانات قريباً' : 'Data import coming soon',
        ),
      ),
    );
  }

  static void _cleanupData(
    BuildContext context,
    bool isArabic,
    WidgetRef ref,
  ) async {
    Navigator.pop(context);
    try {
      final service = ref.read(unifiedGamificationServiceProvider);
      await service.cleanupOldData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'تم تنظيف البيانات القديمة بنجاح'
                : 'Old data cleaned successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'خطأ في تنظيف البيانات' : 'Error cleaning data',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
