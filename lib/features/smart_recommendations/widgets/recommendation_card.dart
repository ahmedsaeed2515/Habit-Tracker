import 'package:flutter/material.dart';
import '../models/habit_recommendation.dart';

class RecommendationCard extends StatelessWidget {
  final HabitRecommendation recommendation;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onView;
  final VoidCallback? onDelete;
  final bool isAccepted;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onAccept,
    this.onReject,
    this.onView,
    this.onDelete,
    this.isAccepted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: recommendation.isViewed ? 1 : 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onView,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 12),
              _buildContent(theme),
              const SizedBox(height: 12),
              _buildReasons(theme),
              const SizedBox(height: 16),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getCategoryColor(theme),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            recommendation.category,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor(theme),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getTypeIcon(), size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                _getTypeDisplayName(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildConfidenceIndicator(theme),
        if (!recommendation.isViewed) ...[
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recommendation.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: recommendation.isViewed
                ? theme.colorScheme.onSurface.withOpacity(0.8)
                : theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          recommendation.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildReasons(ThemeData theme) {
    if (recommendation.reasons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأسباب:',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        ...recommendation.reasons
            .take(3)
            .map(
              (reason) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reason,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      children: [
        _buildPriorityIndicator(theme),
        const SizedBox(width: 12),
        Text(
          _formatDate(recommendation.createdAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const Spacer(),
        if (!isAccepted && recommendation.isPending) ...[
          TextButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('رفض'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('قبول'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ] else if (isAccepted) ...[
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'حذف',
            iconSize: 20,
          ),
        ] else if (recommendation.isRejected) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  'مرفوضة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfidenceIndicator(ThemeData theme) {
    final percentage = (recommendation.confidenceScore * 100).round();
    final color = _getConfidenceColor(theme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: recommendation.confidenceScore,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$percentage%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < recommendation.priority ? Icons.star : Icons.star_outline,
          size: 16,
          color: index < recommendation.priority
              ? Colors.amber.shade600
              : theme.colorScheme.outline,
        );
      }),
    );
  }

  Color _getCategoryColor(ThemeData theme) {
    switch (recommendation.category) {
      case 'صحة':
        return Colors.green.shade600;
      case 'تعلم':
        return Colors.blue.shade600;
      case 'عمل':
        return Colors.orange.shade600;
      case 'شخصي':
        return Colors.purple.shade600;
      case 'تحسين':
        return Colors.teal.shade600;
      default:
        return theme.colorScheme.primary;
    }
  }

  Color _getTypeColor(ThemeData theme) {
    switch (recommendation.type) {
      case RecommendationType.newHabit:
        return Colors.blue.shade700;
      case RecommendationType.improvementSuggestion:
        return Colors.orange.shade700;
      case RecommendationType.timingOptimization:
        return Colors.purple.shade700;
      case RecommendationType.habitStacking:
        return Colors.teal.shade700;
      case RecommendationType.replacementHabit:
        return Colors.red.shade700;
      case RecommendationType.motivationalBoost:
        return Colors.pink.shade700;
    }
  }

  IconData _getTypeIcon() {
    switch (recommendation.type) {
      case RecommendationType.newHabit:
        return Icons.add_circle_outline;
      case RecommendationType.improvementSuggestion:
        return Icons.trending_up;
      case RecommendationType.timingOptimization:
        return Icons.schedule;
      case RecommendationType.habitStacking:
        return Icons.link;
      case RecommendationType.replacementHabit:
        return Icons.swap_horiz;
      case RecommendationType.motivationalBoost:
        return Icons.favorite;
    }
  }

  String _getTypeDisplayName() {
    switch (recommendation.type) {
      case RecommendationType.newHabit:
        return 'جديدة';
      case RecommendationType.improvementSuggestion:
        return 'تحسين';
      case RecommendationType.timingOptimization:
        return 'توقيت';
      case RecommendationType.habitStacking:
        return 'ربط';
      case RecommendationType.replacementHabit:
        return 'بديلة';
      case RecommendationType.motivationalBoost:
        return 'تحفيز';
    }
  }

  Color _getConfidenceColor(ThemeData theme) {
    if (recommendation.confidenceScore >= 0.8) {
      return Colors.green.shade600;
    } else if (recommendation.confidenceScore >= 0.6) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
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
      return 'منذ قليل';
    }
  }
}
