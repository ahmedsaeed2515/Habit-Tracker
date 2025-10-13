import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../shared/themes/app_colors.dart';
import '../models/ai_models.dart';
import '../providers/ai_smart_habits_providers.dart';
import '../widgets/smart_habit_widgets.dart';

/// شاشة العادات الذكية الرئيسية
class AISmartHabitsScreen extends ConsumerStatefulWidget {

  const AISmartHabitsScreen({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<AISmartHabitsScreen> createState() =>
      _AISmartHabitsScreenState();
}

class _AISmartHabitsScreenState extends ConsumerState<AISmartHabitsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SmartHabitCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(aiSmartHabitsInitProvider);

    return initState.when(
      data: (_) => _buildMainScaffold(),
      loading: () => const Scaffold(body: Center(child: LoadingWidget())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: CustomErrorWidget(
            message: 'تعذر تهيئة العادات الذكية',
            onRetry: () => ref.refresh(aiSmartHabitsInitProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العادات الذكية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showCreateHabitOptions,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _showInsights,
            icon: const Icon(Icons.lightbulb_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'مولدة بـ AI'),
            Tab(text: 'الإحصائيات'),
            Tab(text: 'التوصيات'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllHabitsTab(),
                _buildAIHabitsTab(),
                _buildStatsTab(),
                _buildRecommendationsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateAIHabits,
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.psychology),
        label: const Text('توليد عادات ذكية'),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: SmartHabitCategory.values.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip(
              label: 'الكل',
              isSelected: _selectedCategory == null,
              onTap: () => setState(() => _selectedCategory = null),
            );
          }

          final category = SmartHabitCategory.values[index - 1];
          return _buildCategoryChip(
            label: _getCategoryName(category),
            isSelected: _selectedCategory == category,
            onTap: () => setState(() => _selectedCategory = category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withOpacity(0.2),
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAllHabitsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SmartHabitsList(
        userId: widget.userId,
        filterCategory: _selectedCategory,
      ),
    );
  }

  Widget _buildAIHabitsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SmartHabitsList(
        userId: widget.userId,
        filterCategory: _selectedCategory,
        showAIGeneratedOnly: true,
      ),
    );
  }

  Widget _buildStatsTab() {
    final statsProvider = ref.watch(smartHabitsStatsProvider(widget.userId));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsOverview(statsProvider),
          const SizedBox(height: 24),
          _buildPerformanceAnalysis(),
          const SizedBox(height: 24),
          _buildHabitsDistribution(statsProvider),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(SmartHabitsStats stats) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'إجمالي العادات',
                  '${stats.totalHabits}',
                  Icons.psychology,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'مولدة بـ AI',
                  '${stats.aiGeneratedHabits}',
                  Icons.auto_awesome,
                  AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'متوسط النجاح',
                  '${(stats.averageSuccessProbability * 100).toInt()}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'نسبة الـ AI',
                  '${stats.aiGeneratedPercentage.toInt()}%',
                  Icons.pie_chart,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalysis() {
    final highPerformanceHabits = ref.watch(
      highPerformanceHabitsProvider(widget.userId),
    );
    final lowPerformanceHabits = ref.watch(
      lowPerformanceHabitsProvider(widget.userId),
    );

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحليل الأداء',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceItem(
                  'عادات عالية الأداء',
                  highPerformanceHabits.length,
                  Colors.green,
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildPerformanceItem(
                  'عادات تحتاج تحسين',
                  lowPerformanceHabits.length,
                  Colors.orange,
                  Icons.trending_down,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(
    String label,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsDistribution(SmartHabitsStats stats) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توزيع العادات حسب الفئة',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...stats.categoriesDistribution.entries.map(
            (entry) => _buildCategoryDistributionItem(
              entry.key,
              entry.value,
              stats.totalHabits,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistributionItem(
    SmartHabitCategory category,
    int count,
    int total,
  ) {
    final percentage = total > 0 ? (count / total) : 0.0;
    final color = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getCategoryName(category),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text('$count'),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    final recommendationsAsync = ref.watch(
      personalizedRecommendationsProvider(widget.userId),
    );

    return recommendationsAsync.when(
      data: _buildRecommendationsList,
      loading: () => const LoadingWidget(),
      error: (error, stack) => CustomErrorWidget(
        message: 'خطأ في تحميل التوصيات',
        onRetry: () =>
            ref.refresh(personalizedRecommendationsProvider(widget.userId)),
      ),
    );
  }

  Widget _buildRecommendationsList(List<Recommendation> recommendations) {
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد توصيات',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'استخدم العادات الذكية أكثر للحصول على توصيات مخصصة',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: recommendations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final recommendation = recommendations[index];
          return _buildRecommendationCard(recommendation);
        },
      ),
    );
  }

  Widget _buildRecommendationCard(Recommendation recommendation) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getRecommendationTypeColor(
                    recommendation.type,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getRecommendationTypeIcon(recommendation.type),
                  color: _getRecommendationTypeColor(recommendation.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(
                        recommendation.priority,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'أولوية ${recommendation.priority}',
                      style: TextStyle(
                        color: _getPriorityColor(recommendation.priority),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تأثير: ${(recommendation.expectedImpact * 100).toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          if (recommendation.actionSteps.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'خطوات العمل:',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ...recommendation.actionSteps
                .take(3)
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 12),
          CustomButton(
            text: 'تطبيق التوصية',
            onPressed: () => _implementRecommendation(recommendation),
          ),
        ],
      ),
    );
  }

  void _showCreateHabitOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'إضافة عادة ذكية',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'إنشاء عادة يدوياً',
              onPressed: () {
                Navigator.pop(context);
                _createManualHabit();
              },
              icon: Icons.edit,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'توليد عادات بالذكاء الاصطناعي',
              onPressed: () {
                Navigator.pop(context);
                _generateAIHabits();
              },
              icon: Icons.psychology,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'تحدي ذكي',
              onPressed: () {
                Navigator.pop(context);
                _generateSmartChallenge();
              },
              icon: Icons.emoji_events,
            ),
          ],
        ),
      ),
    );
  }

  void _showInsights() {
    final insights = ref.watch(activeInsightsProvider(widget.userId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'الرؤى والتحليلات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: insights.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد رؤى متاحة',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: insights.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildInsightCard(insights[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(Insight insight) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSeverityColor(insight.severity).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSeverityIcon(insight.severity),
              color: _getSeverityColor(insight.severity),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(insight.confidence * 100).toInt()}%',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _createManualHabit() {
    // تنفيذ إنشاء العادة اليدوي
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة شاشة إنشاء العادة اليدوي')),
    );
  }

  Future<void> _generateAIHabits() async {
    try {
      final preferences = <String, dynamic>{
        'experience_level': 'intermediate',
        'focus_areas': ['health', 'productivity'],
        'time_availability': 'moderate',
      };

      await ref.read(
        generateAIHabitsProvider(
          GenerateAIHabitsParams(
            userId: widget.userId,
            preferences: preferences,
          ),
        ).future,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم توليد عادات ذكية جديدة بنجاح!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في توليد العادات: $e')));
      }
    }
  }

  Future<void> _generateSmartChallenge() async {
    try {
      await ref.read(
        smartChallengesProvider(
          GenerateSmartChallengesParams(
            userId: widget.userId,
            duration: const Duration(days: 30),
          ),
        ).future,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم توليد تحدي ذكي جديد!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في توليد التحدي: $e')));
      }
    }
  }

  void _implementRecommendation(Recommendation recommendation) {
    // تنفيذ التوصية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تطبيق التوصية: ${recommendation.title}')),
    );
  }

  // === الطرق المساعدة ===

  String _getCategoryName(SmartHabitCategory category) {
    switch (category) {
      case SmartHabitCategory.health:
        return 'الصحة';
      case SmartHabitCategory.fitness:
        return 'اللياقة';
      case SmartHabitCategory.productivity:
        return 'الإنتاجية';
      case SmartHabitCategory.learning:
        return 'التعلم';
      case SmartHabitCategory.mindfulness:
        return 'الوعي';
      case SmartHabitCategory.social:
        return 'الاجتماعية';
      case SmartHabitCategory.creative:
        return 'الإبداع';
      case SmartHabitCategory.financial:
        return 'المالية';
      case SmartHabitCategory.environmental:
        return 'البيئة';
      case SmartHabitCategory.personal:
        return 'الشخصية';
    }
  }

  Color _getCategoryColor(SmartHabitCategory category) {
    switch (category) {
      case SmartHabitCategory.health:
        return Colors.green;
      case SmartHabitCategory.fitness:
        return Colors.orange;
      case SmartHabitCategory.productivity:
        return Colors.blue;
      case SmartHabitCategory.learning:
        return Colors.purple;
      case SmartHabitCategory.mindfulness:
        return Colors.teal;
      case SmartHabitCategory.social:
        return Colors.pink;
      case SmartHabitCategory.creative:
        return Colors.amber;
      case SmartHabitCategory.financial:
        return Colors.indigo;
      case SmartHabitCategory.environmental:
        return Colors.lightGreen;
      case SmartHabitCategory.personal:
        return Colors.brown;
    }
  }

  Color _getRecommendationTypeColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.scheduling:
        return Colors.blue;
      case RecommendationType.difficulty:
        return Colors.orange;
      case RecommendationType.environment:
        return Colors.green;
      case RecommendationType.motivation:
        return Colors.red;
      case RecommendationType.social:
        return Colors.pink;
      case RecommendationType.health:
        return Colors.teal;
      case RecommendationType.productivity:
        return Colors.indigo;
      case RecommendationType.learning:
        return Colors.purple;
    }
  }

  IconData _getRecommendationTypeIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.scheduling:
        return Icons.schedule;
      case RecommendationType.difficulty:
        return Icons.speed;
      case RecommendationType.environment:
        return Icons.location_on;
      case RecommendationType.motivation:
        return Icons.emoji_emotions;
      case RecommendationType.social:
        return Icons.people;
      case RecommendationType.health:
        return Icons.health_and_safety;
      case RecommendationType.productivity:
        return Icons.work;
      case RecommendationType.learning:
        return Icons.school;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getSeverityColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.low:
        return Colors.green;
      case InsightSeverity.medium:
        return Colors.orange;
      case InsightSeverity.high:
        return Colors.red;
      case InsightSeverity.critical:
        return Colors.red[900]!;
    }
  }

  IconData _getSeverityIcon(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.low:
        return Icons.info_outline;
      case InsightSeverity.medium:
        return Icons.warning_outlined;
      case InsightSeverity.high:
        return Icons.priority_high;
      case InsightSeverity.critical:
        return Icons.dangerous;
    }
  }
}
