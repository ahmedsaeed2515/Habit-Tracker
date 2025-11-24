import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_recommendation.dart';
import '../providers/smart_recommendation_provider.dart';
import '../widgets/pattern_insights_widget.dart';
import '../widgets/recommendation_card.dart';

class SmartRecommendationsScreen extends ConsumerStatefulWidget {
  const SmartRecommendationsScreen({super.key});

  @override
  ConsumerState<SmartRecommendationsScreen> createState() =>
      _SmartRecommendationsScreenState();
}

class _SmartRecommendationsScreenState
    extends ConsumerState<SmartRecommendationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'الكل';
  RecommendationType? _selectedType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(smartRecommendationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التوصيات الذكية'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        actions: [
          IconButton(
            icon: state.isAnalyzing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.analytics_outlined),
            onPressed: state.isAnalyzing
                ? null
                : () => ref
                      .read(smartRecommendationProvider.notifier)
                      .analyzeAndGenerateRecommendations(),
            tooltip: 'إعادة التحليل',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('تحديث'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear_rejected',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('مسح المرفوضة'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('الإحصائيات'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'الجديدة (${state.pendingCount})',
              icon: const Icon(Icons.new_releases),
            ),
            Tab(
              text: 'المقبولة (${state.acceptedCount})',
              icon: const Icon(Icons.check_circle),
            ),
            const Tab(text: 'الأنماط', icon: Icon(Icons.insights)),
          ],
        ),
      ),
      body: state.error != null
          ? _buildErrorWidget(theme, state.error!)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(state),
                _buildAcceptedTab(state),
                _buildPatternsTab(state),
              ],
            ),
    );
  }

  Widget _buildPendingTab(SmartRecommendationState state) {
    final recommendations = _getFilteredRecommendations(
      state.pendingRecommendations,
    );

    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: recommendations.isEmpty
              ? _buildEmptyState(
                  'لا توجد توصيات جديدة',
                  'جرب إعادة التحليل للحصول على توصيات جديدة',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final recommendation = recommendations[index];
                    return RecommendationCard(
                      recommendation: recommendation,
                      onAccept: () => ref
                          .read(smartRecommendationProvider.notifier)
                          .acceptRecommendation(recommendation.id),
                      onReject: () => ref
                          .read(smartRecommendationProvider.notifier)
                          .rejectRecommendation(recommendation.id),
                      onView: () => ref
                          .read(smartRecommendationProvider.notifier)
                          .markRecommendationAsViewed(recommendation.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAcceptedTab(SmartRecommendationState state) {
    final recommendations = _getFilteredRecommendations(
      state.acceptedRecommendations,
    );

    return recommendations.isEmpty
        ? _buildEmptyState(
            'لا توجد توصيات مقبولة',
            'اقبل بعض التوصيات لتظهر هنا',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              return RecommendationCard(
                recommendation: recommendation,
                isAccepted: true,
                onDelete: () => _showDeleteDialog(recommendation),
              );
            },
          );
  }

  Widget _buildPatternsTab(SmartRecommendationState state) {
    return state.patterns.isEmpty
        ? _buildEmptyState(
            'لا توجد أنماط محللة',
            'انتظر حتى يتم جمع المزيد من البيانات',
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCard(state),
                const const SizedBox(height: 16),
                PatternInsightsWidget(patterns: state.patterns),
              ],
            ),
          );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تصفية حسب:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: ['الكل', 'صحة', 'تعلم', 'عمل', 'شخصي', 'تحسين']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'الكل';
                    });
                  },
                ),
              ),
              const const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<RecommendationType?>(
                  value: _selectedType,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(
                      child: Text('جميع الأنواع'),
                    ),
                    ...RecommendationType.values.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getTypeDisplayName(type)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(SmartRecommendationState state) {
    final stats = ref
        .read(smartRecommendationProvider.notifier)
        .getDetailedStats();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات التوصيات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'الإجمالي',
                  stats['total'].toString(),
                  Icons.dashboard,
                ),
                _buildStatItem(
                  'معلقة',
                  stats['pending'].toString(),
                  Icons.pending,
                ),
                _buildStatItem(
                  'مقبولة',
                  stats['accepted'].toString(),
                  Icons.check,
                ),
                _buildStatItem(
                  'مرفوضة',
                  stats['rejected'].toString(),
                  Icons.close,
                ),
              ],
            ),
            const const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.trending_up, color: theme.colorScheme.primary),
                const const SizedBox(width: 8),
                Text(
                  'متوسط الثقة: ${(stats['averageConfidence'] * 100).round()}%',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (state.lastAnalysis != null) ...[
              const const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: theme.colorScheme.primary),
                  const const SizedBox(width: 8),
                  Text(
                    'آخر تحليل: ${_formatDate(state.lastAnalysis!)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outlined,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(smartRecommendationProvider.notifier).clearError(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  List<HabitRecommendation> _getFilteredRecommendations(
    List<HabitRecommendation> recommendations,
  ) {
    return recommendations.where((rec) {
      final categoryMatch =
          _selectedCategory == 'الكل' || rec.category == _selectedCategory;
      final typeMatch = _selectedType == null || rec.type == _selectedType;
      return categoryMatch && typeMatch;
    }).toList();
  }

  String _getTypeDisplayName(RecommendationType type) {
    switch (type) {
      case RecommendationType.newHabit:
        return 'عادة جديدة';
      case RecommendationType.improvementSuggestion:
        return 'اقتراح تحسين';
      case RecommendationType.timingOptimization:
        return 'تحسين التوقيت';
      case RecommendationType.habitStacking:
        return 'ربط العادات';
      case RecommendationType.replacementHabit:
        return 'عادة بديلة';
      case RecommendationType.motivationalBoost:
        return 'تعزيز الدافع';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else {
      return '${difference.inMinutes} دقيقة';
    }
  }

  void _handleMenuAction(String action) {
    final notifier = ref.read(smartRecommendationProvider.notifier);

    switch (action) {
      case 'refresh':
        notifier.refresh();
        break;
      case 'clear_rejected':
        notifier.clearRejectedRecommendations();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم مسح التوصيات المرفوضة')),
        );
        break;
      case 'stats':
        _showStatsDialog();
        break;
    }
  }

  void _showDeleteDialog(HabitRecommendation recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التوصية'),
        content: Text('هل تريد حذف توصية "${recommendation.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(smartRecommendationProvider.notifier)
                  .deleteRecommendation(recommendation.id);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    final stats = ref
        .read(smartRecommendationProvider.notifier)
        .getDetailedStats();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إحصائيات مفصلة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إجمالي التوصيات: ${stats['total']}'),
              Text('المعلقة: ${stats['pending']}'),
              Text('المقبولة: ${stats['accepted']}'),
              Text('المرفوضة: ${stats['rejected']}'),
              Text(
                'متوسط الثقة: ${(stats['averageConfidence'] * 100).round()}%',
              ),
              const const SizedBox(height: 16),
              const Text(
                'التوزيع حسب الفئة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...((stats['categoryBreakdown'] as Map<String, int>).entries.map(
                (e) => Text('${e.key}: ${e.value}'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
