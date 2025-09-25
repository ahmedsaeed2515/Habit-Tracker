// lib/features/habit_builder/widgets/template_card.dart
import 'package:flutter/material.dart';
import '../models/habit_template.dart';

class TemplateCard extends StatelessWidget {
  final HabitTemplate template;
  final bool isSelected;
  final VoidCallback onTap;
  final String language;

  const TemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
    this.language = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرأس
              Row(
                children: [
                  // الأيقونة
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(template.colorCode.substring(1), radix: 16) |
                            0xFF000000,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconData(template.iconName),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // العنوان والفئة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.getName(language),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          template.category.getDisplayName(language),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.7)
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // علامة الاختيار
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // الوصف
              Text(
                template.getDescription(language),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.8,
                        )
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // معلومات إضافية
              Row(
                children: [
                  // مستوى الصعوبة
                  _buildInfoChip(
                    context,
                    Icons.trending_up,
                    language == 'ar'
                        ? 'المستوى ${template.difficultyLevel}'
                        : 'Level ${template.difficultyLevel}',
                  ),
                  const SizedBox(width: 8),

                  // المدة المقدرة
                  _buildInfoChip(
                    context,
                    Icons.access_time,
                    '${template.estimatedDurationMinutes} ${language == 'ar' ? 'دقيقة' : 'min'}',
                  ),
                  const SizedBox(width: 8),

                  // التكرار الموصى به
                  _buildInfoChip(
                    context,
                    Icons.repeat,
                    '${template.recommendedFrequency}/7',
                  ),
                ],
              ),

              // الكلمات المفتاحية
              if (template.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: template.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_drink':
        return Icons.local_drink;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'schedule':
        return Icons.schedule;
      case 'book':
        return Icons.book;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'favorite':
        return Icons.favorite;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'palette':
        return Icons.palette;
      case 'attach_money':
        return Icons.attach_money;
      case 'eco':
        return Icons.eco;
      case 'person':
        return Icons.person;
      default:
        return Icons.star;
    }
  }
}
