import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/achievements_state_provider.dart';
import '../providers/challenges_state_provider.dart';
import '../providers/unified_gamification_provider.dart';
import 'enhanced_gamification_tabs.dart';
import 'enhanced_gamification_widgets.dart';

/// الشاشة الرئيسية المحسنة لنظام التحفيز
/// تم تقسيمها لسهولة الصيانة والتطوير
class EnhancedGamificationScreen extends ConsumerStatefulWidget {
  const EnhancedGamificationScreen({super.key});

  @override
  ConsumerState<EnhancedGamificationScreen> createState() =>
      _EnhancedGamificationScreenState();
}

class _EnhancedGamificationScreenState
    extends ConsumerState<EnhancedGamificationScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late AnimationController _refreshAnimationController;
  late AnimationController _achievementAnimationController;

  int _selectedIndex = 0;
  bool _isRefreshing = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _achievementAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    // الاستماع للإنجازات الجديدة
    _listenToAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshAnimationController.dispose();
    _achievementAnimationController.dispose();
    super.dispose();
  }

  void _listenToAchievements() {
    // يمكن إضافة استماع للإنجازات الجديدة هنا
    // ref.read(unifiedGamificationServiceProvider).newAchievementStream.listen((achievement) {
    //   _showAchievementDialog(achievement);
    // });
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshAnimationController.repeat();

    try {
      // تحديث البيانات
      ref.read(userGameDataProvider.notifier).refresh();
      ref.read(achievementsStateProvider.notifier).refresh();
      ref.read(challengesStateProvider.notifier).refresh();

      // إعطاء وقت للتحديث
      await Future.delayed(const Duration(milliseconds: 1500));
    } finally {
      _refreshAnimationController
        ..stop()
        ..reset();

      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.8),
              theme.colorScheme.secondary.withValues(alpha: 0.6),
              theme.colorScheme.tertiary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                // RTL Fix: استخدام expandedHeight بدلاً من block-size لأن SliverAppBar لا تدعم هذه الخاصية
                expandedHeight: 120,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    isArabic ? 'نظام الألعاب والتحفيز' : 'Gamification Hub',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.3),
                          theme.colorScheme.secondary.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RotationTransition(
                      turns: _refreshAnimationController,
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _isRefreshing ? null : _refresh,
                        tooltip: isArabic ? 'تحديث' : 'Refresh',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => _showSettingsMenu(context, isArabic),
                      tooltip: isArabic ? 'الإعدادات' : 'Settings',
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: const Icon(
                        Icons.dashboard_rounded,
                        color: Colors.white,
                      ),
                      text: isArabic ? 'لوحة التحكم' : 'Dashboard',
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                      ),
                      text: isArabic ? 'الإنجازات' : 'Achievements',
                    ),
                    Tab(
                      icon: const Icon(Icons.flag_rounded, color: Colors.white),
                      text: isArabic ? 'التحديات' : 'Challenges',
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.analytics_rounded,
                        color: Colors.white,
                      ),
                      text: isArabic ? 'الإحصائيات' : 'Statistics',
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.card_giftcard_rounded,
                        color: Colors.white,
                      ),
                      text: isArabic ? 'المكافآت' : 'Rewards',
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              EnhancedGamificationTabs.buildDashboardTab(
                context,
                isArabic,
                _refresh,
                onViewAllAchievements: () => _tabController.animateTo(1),
                onViewAllChallenges: () => _tabController.animateTo(2),
              ),
              EnhancedGamificationTabs.buildAchievementsTab(context, isArabic),
              EnhancedGamificationTabs.buildChallengesTab(context, isArabic),
              EnhancedGamificationTabs.buildStatisticsTab(
                context,
                isArabic,
                _refresh,
              ),
              EnhancedGamificationTabs.buildRewardsTab(context, isArabic),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 2
          ? DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _showCreateChallengeDialog(context, isArabic),
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  isArabic ? 'تحدي جديد' : 'New Challenge',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  void _showSettingsMenu(BuildContext context, bool isArabic) {
    EnhancedGamificationWidgets.showSettingsMenu(context, isArabic, ref);
  }

  void _showCreateChallengeDialog(BuildContext context, bool isArabic) {
    EnhancedGamificationWidgets.showCreateChallengeDialog(context, isArabic);
  }
}
