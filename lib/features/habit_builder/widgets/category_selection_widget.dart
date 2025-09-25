// lib/features/habit_builder/widgets/category_selection_widget.dart
import 'package:flutter/material.dart';
import '../models/habit_template.dart';

class CategorySelectionWidget extends StatelessWidget {
  final List<HabitCategory> selectedCategories;
  final Function(List<HabitCategory>) onSelectionChanged;
  final String language;

  const CategorySelectionWidget({
    super.key,
    required this.selectedCategories,
    required this.onSelectionChanged,
    this.language = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = HabitCategory.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language == 'ar'
              ? 'اختر الفئات التي تهمك:'
              : 'Choose categories that interest you:',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          language == 'ar'
              ? 'يمكنك اختيار عدة فئات لتخصيص تجربتك'
              : 'You can select multiple categories to customize your experience',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((category) {
            final isSelected = selectedCategories.contains(category);
            return _buildCategoryChip(context, category, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    HabitCategory category,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 18,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 8),
          Text(
            category.getDisplayName(language),
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        final newSelection = List<HabitCategory>.from(selectedCategories);
        if (selected) {
          newSelection.add(category);
        } else {
          newSelection.remove(category);
        }
        onSelectionChanged(newSelection);
      },
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  IconData _getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.productivity:
        return Icons.trending_up;
      case HabitCategory.learning:
        return Icons.school;
      case HabitCategory.social:
        return Icons.people;
      case HabitCategory.spiritual:
        return Icons.self_improvement;
      case HabitCategory.creative:
        return Icons.palette;
      case HabitCategory.financial:
        return Icons.attach_money;
      case HabitCategory.environmental:
        return Icons.eco;
      case HabitCategory.personal:
        return Icons.person;
    }
  }
}
