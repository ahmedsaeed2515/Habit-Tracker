import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unified_gamification_provider.dart';
import 'enhanced_gamification_widgets.dart';

/// فئة لبناء جميع علامات التبويب في الشاشة الرئيسية
class EnhancedGamificationTabs {
  /// علامة تبويب لوحة التحكم المحسنة
  static Widget buildDashboardTab(
    BuildContext context,
    bool isArabic,
    Future<void> Function() refresh,
  ) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ويدجت مستوى المستخدم المحسن (placeholder)
            _buildUserLevelCard(context, isArabic),
            const SizedBox(height: 20),

            // ملخص النقاط المحسن (placeholder)
            _buildPointsSummaryCard(context, isArabic),
            const SizedBox(height: 20),

            // المكافأة اليومية (placeholder)
            _buildDailyRewardCard(context, isArabic),
            const SizedBox(height: 20),

            // أحدث الإنجازات
            EnhancedGamificationWidgets.buildRecentAchievementsSection(
              context,
              isArabic,
            ),
            const SizedBox(height: 20),

            // التحديات النشطة
            EnhancedGamificationWidgets.buildActiveChallengesSection(
              context,
              isArabic,
            ),
            const SizedBox(height: 20),

            // نصائح سريعة
            EnhancedGamificationWidgets.buildQuickTipsSection(
              context,
              isArabic,
            ),
          ],
        ),
      ),
    );
  }

  /// علامة تبويب الإنجازات المحسنة
  static Widget buildAchievementsTab(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildAchievementsGrid(context, isArabic),
    );
  }

  /// علامة تبويب التحديات المحسنة
  static Widget buildChallengesTab(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildChallengesList(context, isArabic),
    );
  }

  /// علامة تبويب الإحصائيات
  static Widget buildStatisticsTab(
    BuildContext context,
    bool isArabic,
    Future<void> Function() refresh,
  ) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            final statsAsync = ref.watch(gamificationStatsProvider);
            final advancedStats = ref.watch(advancedStatsProvider);

            return statsAsync.when(
              data: (stats) =>
                  _buildStatsContent(context, isArabic, stats, advancedStats),
              loading: () => _buildStatsLoading(),
              error: (error, stack) =>
                  _buildStatsError(context, isArabic, error),
            );
          },
        ),
      ),
    );
  }

  /// علامة تبويب المكافآت
  static Widget buildRewardsTab(BuildContext context, bool isArabic) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المكافأة اليومية الكبيرة
            _buildDailyRewardCard(context, isArabic),
            const SizedBox(height: 20),

            // الإنجازات النادرة
            EnhancedGamificationWidgets.buildRareAchievementsSection(
              context,
              isArabic,
            ),
            const SizedBox(height: 20),

            // تاريخ المكافآت
            EnhancedGamificationWidgets.buildRewardsHistorySection(
              context,
              isArabic,
            ),
          ],
        ),
      ),
    );
  }

  // ============== الطرق المساعدة الخاصة ==============

  /// بناء بطاقة مستوى المستخدم (placeholder)
  static Widget _buildUserLevelCard(BuildContext context, bool isArabic) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.person_rounded, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'مستوى المستخدم' : 'User Level',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'سيتم تحديث هذا القسم قريباً' : 'Will be updated soon',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء بطاقة ملخص النقاط (placeholder)
  static Widget _buildPointsSummaryCard(BuildContext context, bool isArabic) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.star_rounded, size: 48, color: Colors.amber),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'ملخص النقاط' : 'Points Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'سيتم تحديث هذا القسم قريباً' : 'Will be updated soon',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء بطاقة المكافأة اليومية (placeholder)
  static Widget _buildDailyRewardCard(BuildContext context, bool isArabic) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.card_giftcard_rounded, size: 48, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'المكافأة اليومية' : 'Daily Reward',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? 'سيتم تحديث هذا القسم قريباً' : 'Will be updated soon',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شبكة الإنجازات (placeholder)
  static Widget _buildAchievementsGrid(BuildContext context, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'شبكة الإنجازات' : 'Achievements Grid',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'سيتم تطوير هذا القسم قريباً' : 'Coming Soon',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// بناء قائمة التحديات (placeholder)
  static Widget _buildChallengesList(BuildContext context, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'قائمة التحديات' : 'Challenges List',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'سيتم تطوير هذا القسم قريباً' : 'Coming Soon',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// محتوى الإحصائيات
  static Widget _buildStatsContent(
    BuildContext context,
    bool isArabic,
    Map<String, dynamic> stats,
    Map<String, dynamic> advancedStats,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // بطاقة الإحصائيات الرئيسية
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'الإحصائيات العامة' : 'General Statistics',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // شبكة الإحصائيات
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildStatCard(
                      context,
                      isArabic,
                      Icons.star_rounded,
                      Colors.amber,
                      '${stats['user']?['totalPoints'] ?? 0}',
                      isArabic ? 'إجمالي النقاط' : 'Total Points',
                    ),
                    _buildStatCard(
                      context,
                      isArabic,
                      Icons.trending_up_rounded,
                      Colors.green,
                      '${stats['user']?['currentLevel'] ?? 1}',
                      isArabic ? 'المستوى الحالي' : 'Current Level',
                    ),
                    _buildStatCard(
                      context,
                      isArabic,
                      Icons.emoji_events_rounded,
                      Colors.purple,
                      '${stats['achievements']?['unlocked'] ?? 0}',
                      isArabic ? 'الإنجازات' : 'Achievements',
                    ),
                    _buildStatCard(
                      context,
                      isArabic,
                      Icons.flag_rounded,
                      Colors.blue,
                      '${stats['challenges']?['completed'] ?? 0}',
                      isArabic ? 'التحديات' : 'Challenges',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // إحصائيات التقدم
        Consumer(
          builder: (context, ref, child) {
            final levelInfo = ref.watch(levelInfoProvider);
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'التقدم' : 'Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'التقدم للمستوى التالي'
                                    : 'Next Level Progress',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: levelInfo['levelProgress'] ?? 0.0,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${((levelInfo['levelProgress'] ?? 0.0) * 100).toInt()}%',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${levelInfo['pointsToNext'] ?? 0} ${isArabic ? 'نقطة متبقية' : 'points to go'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static Widget _buildStatCard(
    BuildContext context,
    bool isArabic,
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget _buildStatsLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget _buildStatsError(
    BuildContext context,
    bool isArabic,
    dynamic error,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'خطأ في تحميل الإحصائيات' : 'Error loading statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
