import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/themes/app_theme.dart';
import '../models/ai_recommendation.dart';
import '../providers/workout_planner_providers.dart';

/// ودجت عرض التوصيات الذكية
class AIRecommendationsWidget extends ConsumerWidget {
  const AIRecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final recommendationsAsync = userProfileAsync.when(
      data: (userProfile) {
        if (userProfile == null) {
          return const AsyncValue<List<AIRecommendation>>.data([]);
        }
        return ref.watch(aiRecommendationsProvider(userProfile.id));
      },
      loading: () => const AsyncValue<List<AIRecommendation>>.loading(),
      error: AsyncValue<List<AIRecommendation>>.error,
    );

    return recommendationsAsync.when(
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return _buildNoRecommendationsCard(context);
        }

        return _buildRecommendationsList(context, recommendations, ref);
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.orange.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'خطأ في تحميل التوصيات: ${error.toString()}',
                  style: TextStyle(color: Colors.orange.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoRecommendationsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.grey[400], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توصيات ذكية',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'لا توجد توصيات حالياً. أنشئ خطة تمرين للحصول على توصيات مخصصة',
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

  Widget _buildRecommendationsList(
    BuildContext context,
    List<AIRecommendation> recommendations,
    WidgetRef ref,
  ) {
    // ترتيب التوصيات حسب الثقة (الأعلى أولاً)
    final sortedRecommendations =
        recommendations.where((rec) => !rec.isApplied).toList()
          ..sort((a, b) => b.confidence.compareTo(a.confidence));

    if (sortedRecommendations.isEmpty) {
      return _buildNoRecommendationsCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_fix_high, color: AppTheme.primaryColor, size: 24),
            const SizedBox(width: 8),
            Text(
              'توصيات ذكية',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...sortedRecommendations.take(3).map((recommendation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildRecommendationCard(context, recommendation, ref),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    AIRecommendation recommendation,
    WidgetRef ref,
  ) {
    return Card(
      elevation: 3,
      color: _getRecommendationColor(recommendation.confidence),
      child: InkWell(
        onTap: () => _showRecommendationDetails(context, recommendation, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getRecommendationIcon(recommendation.recommendationType),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recommendation.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(recommendation.confidence * 100).round()}%',
                      style: TextStyle(
                        color: _getConfidenceColor(recommendation.confidence),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recommendation.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    _formatDate(recommendation.createdAt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        _applyRecommendation(context, recommendation, ref),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                    child: const Text('تطبيق'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRecommendationColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green.shade100;
    } else if (confidence >= 0.6) {
      return Colors.blue.shade100;
    } else {
      return Colors.orange.shade100;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green.shade700;
    } else if (confidence >= 0.6) {
      return Colors.blue.shade700;
    } else {
      return Colors.orange.shade700;
    }
  }

  Widget _getRecommendationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'workout_plan':
        icon = Icons.fitness_center;
        color = Colors.blue.shade600;
        break;
      case 'exercise_modification':
        icon = Icons.edit;
        color = Colors.orange.shade600;
        break;
      case 'progress_adjustment':
        icon = Icons.trending_up;
        color = Colors.green.shade600;
        break;
      default:
        icon = Icons.lightbulb;
        color = Colors.grey.shade600;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return 'منذ أسبوع';
    }
  }

  void _showRecommendationDetails(
    BuildContext context,
    AIRecommendation recommendation,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _getRecommendationIcon(recommendation.recommendationType),
            const SizedBox(width: 12),
            Expanded(child: Text(recommendation.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.description),
            const SizedBox(height: 16),
            if (recommendation.parameters.isNotEmpty) ...[
              Text(
                'تفاصيل التوصية:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...recommendation.parameters.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('• ${entry.key}: ${entry.value}'),
                );
              }),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _applyRecommendation(context, recommendation, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('تطبيق التوصية'),
          ),
        ],
      ),
    );
  }

  Future<void> _applyRecommendation(
    BuildContext context,
    AIRecommendation recommendation,
    WidgetRef ref,
  ) async {
    try {
      final service = ref.read(aiWorkoutPlannerServiceProvider);
      await service.applyAIRecommendation(recommendation.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تطبيق التوصية: ${recommendation.title}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تطبيق التوصية: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
