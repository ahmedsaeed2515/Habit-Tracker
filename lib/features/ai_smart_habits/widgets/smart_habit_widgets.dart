import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../models/ai_models.dart';
import '../providers/ai_smart_habits_providers.dart';

/// بطاقة العادة الذكية
class SmartHabitCard extends ConsumerWidget {
  final SmartHabit habit;
  final VoidCallback? onTap;
  final VoidCallback? onAnalyze;
  final VoidCallback? onAdapt;

  const SmartHabitCard({
    Key? key,
    required this.habit,
    this.onTap,
    this.onAnalyze,
    this.onAdapt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _buildCategoryIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (habit.isAIGenerated) ...[
                          const SizedBox(width: 8),
                          _buildAIBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildSuccessProbabilityIndicator(),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Metrics Row
          Row(
            children: [
              _buildMetricChip(
                icon: Icons.trending_up,
                label: 'النجاح',
                value: '${(habit.successProbability * 100).toInt()}%',
                color: _getSuccessColor(habit.successProbability),
              ),
              const SizedBox(width: 8),
              _buildMetricChip(
                icon: Icons.speed,
                label: 'الصعوبة',
                value: '${habit.difficultyLevel}/10',
                color: _getDifficultyColor(habit.difficultyLevel),
              ),
              const SizedBox(width: 8),
              _buildMetricChip(
                icon: Icons.schedule,
                label: 'التكرار',
                value: '${habit.schedule.currentPattern.frequency}x',
                color: AppColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Insights Summary
          if (habit.insights.behaviorInsights.isNotEmpty ||
              habit.insights.performanceInsights.isNotEmpty ||
              habit.insights.patternInsights.isNotEmpty) ...[
            _buildInsightsSummary(context),
            const SizedBox(height: 12),
          ],
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'تحليل الأداء',
                  onPressed: onAnalyze,
                  icon: Icons.analytics_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'تكييف العادة',
                  onPressed: onAdapt,
                  icon: Icons.tune,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final iconData = _getCategoryIcon(habit.category);
    final color = _getCategoryColor(habit.category);
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildAIBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'AI',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSuccessProbabilityIndicator() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getSuccessColor(habit.successProbability).withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          '${(habit.successProbability * 100).toInt()}',
          style: TextStyle(
            color: _getSuccessColor(habit.successProbability),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSummary(BuildContext context) {
    final totalInsights = habit.insights.behaviorInsights.length +
        habit.insights.performanceInsights.length +
        habit.insights.patternInsights.length;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$totalInsights رؤية متاحة',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 12,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(SmartHabitCategory category) {
    switch (category) {
      case SmartHabitCategory.health:
        return Icons.health_and_safety;
      case SmartHabitCategory.fitness:
        return Icons.fitness_center;
      case SmartHabitCategory.productivity:
        return Icons.work_outline;
      case SmartHabitCategory.learning:
        return Icons.school;
      case SmartHabitCategory.mindfulness:
        return Icons.spa;
      case SmartHabitCategory.social:
        return Icons.people;
      case SmartHabitCategory.creative:
        return Icons.palette;
      case SmartHabitCategory.financial:
        return Icons.account_balance_wallet;
      case SmartHabitCategory.environmental:
        return Icons.eco;
      case SmartHabitCategory.personal:
        return Icons.person;
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

  Color _getSuccessColor(double probability) {
    if (probability >= 0.8) return Colors.green;
    if (probability >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getDifficultyColor(int difficulty) {
    if (difficulty <= 3) return Colors.green;
    if (difficulty <= 6) return Colors.orange;
    return Colors.red;
  }
}

/// قائمة العادات الذكية
class SmartHabitsList extends ConsumerWidget {
  final String userId;
  final SmartHabitCategory? filterCategory;
  final bool showAIGeneratedOnly;

  const SmartHabitsList({
    Key? key,
    required this.userId,
    this.filterCategory,
    this.showAIGeneratedOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allHabits = ref.watch(allSmartHabitsProvider);
    
    List<SmartHabit> filteredHabits = allHabits.where((habit) => habit.userId == userId).toList();
    
    if (filterCategory != null) {
      filteredHabits = filteredHabits.where((habit) => habit.category == filterCategory).toList();
    }
    
    if (showAIGeneratedOnly) {
      filteredHabits = filteredHabits.where((habit) => habit.isAIGenerated).toList();
    }

    if (filteredHabits.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      itemCount: filteredHabits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = filteredHabits[index];
        return SmartHabitCard(
          habit: habit,
          onTap: () => _showHabitDetails(context, habit),
          onAnalyze: () => _analyzeHabit(ref, habit.id),
          onAdapt: () => _adaptHabit(ref, habit.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عادات ذكية',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإنشاء عادات ذكية مدعومة بالذكاء الاصطناعي',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showHabitDetails(BuildContext context, SmartHabit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SmartHabitDetailsSheet(habit: habit),
    );
  }

  void _analyzeHabit(WidgetRef ref, String habitId) {
    ref.read(analyzeHabitPerformanceProvider(habitId));
  }

  void _adaptHabit(WidgetRef ref, String habitId) {
    ref.read(adaptHabitProvider(habitId));
  }
}

/// صفحة تفاصيل العادة الذكية
class SmartHabitDetailsSheet extends ConsumerWidget {
  final SmartHabit habit;

  const SmartHabitDetailsSheet({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewSection(context),
                  const SizedBox(height: 24),
                  _buildInsightsSection(context),
                  const SizedBox(height: 24),
                  _buildPredictionsSection(context),
                  const SizedBox(height: 24),
                  _buildTriggersSection(context),
                  const SizedBox(height: 24),
                  _buildRewardsSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نظرة عامة',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              _buildOverviewItem(
                'الوصف',
                habit.description,
                Icons.description,
              ),
              const Divider(),
              _buildOverviewItem(
                'الفئة',
                _getCategoryName(habit.category),
                Icons.category,
              ),
              const Divider(),
              _buildOverviewItem(
                'مستوى الصعوبة',
                '${habit.difficultyLevel}/10',
                Icons.speed,
              ),
              const Divider(),
              _buildOverviewItem(
                'احتمالية النجاح',
                '${(habit.successProbability * 100).toInt()}%',
                Icons.trending_up,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context) {
    final totalInsights = habit.insights.behaviorInsights.length +
        habit.insights.performanceInsights.length +
        habit.insights.patternInsights.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الرؤى والتحليلات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalInsights رؤية',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (totalInsights > 0) ...[
          ...habit.insights.behaviorInsights.take(3).map((insight) => _buildInsightCard(insight)),
          ...habit.insights.performanceInsights.take(3).map((insight) => _buildInsightCard(insight)),
          ...habit.insights.patternInsights.take(3).map((insight) => _buildInsightCard(insight)),
        ] else
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد رؤى متاحة',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'قم بتحليل الأداء للحصول على رؤى',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInsightCard(Insight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
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
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التنبؤات',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              _buildPredictionItem(
                'قصير المدى (7 أيام)',
                '${(habit.prediction.shortTermSuccessRate * 100).toInt()}%',
                habit.prediction.shortTermSuccessRate,
              ),
              const Divider(),
              _buildPredictionItem(
                'متوسط المدى (30 يوم)',
                '${(habit.prediction.mediumTermSuccessRate * 100).toInt()}%',
                habit.prediction.mediumTermSuccessRate,
              ),
              const Divider(),
              _buildPredictionItem(
                'طويل المدى (90 يوم)',
                '${(habit.prediction.longTermSuccessRate * 100).toInt()}%',
                habit.prediction.longTermSuccessRate,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionItem(String label, String value, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: rate,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getSuccessColor(rate),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              color: _getSuccessColor(rate),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المحفزات الذكية',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (habit.triggers.isNotEmpty)
          ...habit.triggers.map((trigger) => _buildTriggerCard(trigger))
        else
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لا توجد محفزات مضافة',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTriggerCard(SmartTrigger trigger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTriggerIcon(trigger.type),
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trigger.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الفعالية: ${(trigger.effectiveness * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: trigger.isActive,
              onChanged: (value) {
                // تحديث حالة المحفز
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المكافآت الذكية',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (habit.rewards.isNotEmpty)
          ...habit.rewards.map((reward) => _buildRewardCard(reward))
        else
          CustomCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'لا توجد مكافآت مضافة',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRewardCard(SmartReward reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: reward.isUnlocked 
                    ? Colors.amber.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                reward.isUnlocked ? Icons.star : Icons.star_border,
                color: reward.isUnlocked ? Colors.amber : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${reward.value}',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(SmartHabitCategory category) {
    switch (category) {
      case SmartHabitCategory.health:
        return 'الصحة';
      case SmartHabitCategory.fitness:
        return 'اللياقة البدنية';
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

  Color _getSuccessColor(double probability) {
    if (probability >= 0.8) return Colors.green;
    if (probability >= 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getTriggerIcon(TriggerType type) {
    switch (type) {
      case TriggerType.time:
        return Icons.schedule;
      case TriggerType.location:
        return Icons.location_on;
      case TriggerType.activity:
        return Icons.directions_run;
      case TriggerType.mood:
        return Icons.mood;
      case TriggerType.weather:
        return Icons.wb_sunny;
      case TriggerType.social:
        return Icons.people;
      case TriggerType.calendar:
        return Icons.calendar_today;
      case TriggerType.completion:
        return Icons.check_circle;
      case TriggerType.streak:
        return Icons.whatshot;
      case TriggerType.custom:
        return Icons.settings;
    }
  }
}