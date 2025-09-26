import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unified_gamification_provider.dart';
import '../providers/achievements_state_provider.dart';
import '../providers/challenges_state_provider.dart';
import 'enhanced_gamification_tabs.dart';
import 'enhanced_gamification_widgets.dart';

/// الشاشة الرئيسية المحسنة لنظام التحفيز
/// تم تقسيمها لسهولة الصيانة والتطوير
class EnhancedGamificationScreen extends ConsumerStatefulWidget {
  const EnhancedGamificationScreen({Key? key}) : super(key: key);

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
      _refreshAnimationController.stop();
      _refreshAnimationController.reset();

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
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // RTL Fix: استخدام expandedHeight بدلاً من block-size لأن SliverAppBar لا تدعم هذه الخاصية
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  isArabic ? 'نظام الألعاب والتحفيز' : 'Gamification Hub',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                RotationTransition(
                  turns: _refreshAnimationController,
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _isRefreshing ? null : _refresh,
                    tooltip: isArabic ? 'تحديث' : 'Refresh',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showSettingsMenu(context, isArabic),
                  tooltip: isArabic ? 'الإعدادات' : 'Settings',
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: theme.textTheme.bodyMedium,
                indicatorColor: theme.colorScheme.primary,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.dashboard_rounded),
                    text: isArabic ? 'لوحة التحكم' : 'Dashboard',
                  ),
                  Tab(
                    icon: const Icon(Icons.emoji_events_rounded),
                    text: isArabic ? 'الإنجازات' : 'Achievements',
                  ),
                  Tab(
                    icon: const Icon(Icons.flag_rounded),
                    text: isArabic ? 'التحديات' : 'Challenges',
                  ),
                  Tab(
                    icon: const Icon(Icons.analytics_rounded),
                    text: isArabic ? 'الإحصائيات' : 'Statistics',
                  ),
                  Tab(
                    icon: const Icon(Icons.card_giftcard_rounded),
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
      floatingActionButton: _buildFloatingActionButton(context, isArabic),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isArabic) {
    if (_selectedIndex != 2) return const SizedBox(); // فقط في تبويب التحديات

    return FloatingActionButton.extended(
      onPressed: () => _showCreateChallengeDialog(context, isArabic),
      icon: const Icon(Icons.add_rounded),
      label: Text(isArabic ? 'تحدي جديد' : 'New Challenge'),
    );
  }

  void _showSettingsMenu(BuildContext context, bool isArabic) {
    EnhancedGamificationWidgets.showSettingsMenu(context, isArabic, ref);
  }

  void _showCreateChallengeDialog(BuildContext context, bool isArabic) {
    EnhancedGamificationWidgets.showCreateChallengeDialog(context, isArabic);
  }
}
