// lib/shared/widgets/modern_chip.dart
// رقاقة حديثة - Modern Chip

import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';

/// رقاقة حديثة بتصميم جذاب
class ModernChip extends StatelessWidget {
  const ModernChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.padding,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = selected
        ? (selectedColor ?? theme.colorScheme.primaryContainer)
        : (backgroundColor ?? theme.colorScheme.surface);
    final effectiveTextColor = selected
        ? theme.colorScheme.onPrimaryContainer
        : (textColor ?? theme.colorScheme.onSurface);

    return Material(
      color: effectiveBackgroundColor,
      borderRadius: AppDesignSystem.borderRadiusLarge,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDesignSystem.borderRadiusLarge,
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDesignSystem.spacingMedium,
                vertical: AppDesignSystem.spacingSmall,
              ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            borderRadius: AppDesignSystem.borderRadiusLarge,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: effectiveTextColor),
                const SizedBox(width: AppDesignSystem.spacingXSmall),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: effectiveTextColor,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: AppDesignSystem.spacingXSmall),
                InkWell(
                  onTap: onDeleted,
                  borderRadius: BorderRadius.circular(
                    AppDesignSystem.radiusCircular,
                  ),
                  child: Icon(Icons.close, size: 16, color: effectiveTextColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// شارة حديثة للعد
class ModernBadge extends StatelessWidget {
  const ModernBadge({
    super.key,
    required this.child,
    this.count,
    this.showBadge = true,
    this.badgeColor,
    this.textColor,
  });

  final Widget child;
  final int? count;
  final bool showBadge;
  final Color? badgeColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!showBadge || (count != null && count! <= 0)) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor ?? theme.colorScheme.error,
              borderRadius: BorderRadius.circular(
                AppDesignSystem.radiusCircular,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: Center(
              child: Text(
                count != null ? (count! > 99 ? '99+' : count.toString()) : '',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// مجموعة رقائق قابلة للاختيار
class ModernChipGroup extends StatelessWidget {
  const ModernChipGroup({
    super.key,
    required this.labels,
    required this.selectedIndices,
    required this.onSelectionChanged,
    this.multiSelect = false,
    this.spacing = AppDesignSystem.spacingSmall,
    this.runSpacing = AppDesignSystem.spacingSmall,
  });

  final List<String> labels;
  final Set<int> selectedIndices;
  final ValueChanged<Set<int>> onSelectionChanged;
  final bool multiSelect;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(labels.length, (index) {
        final isSelected = selectedIndices.contains(index);
        return ModernChip(
          label: labels[index],
          selected: isSelected,
          onTap: () {
            final newSelection = Set<int>.from(selectedIndices);
            if (multiSelect) {
              if (isSelected) {
                newSelection.remove(index);
              } else {
                newSelection.add(index);
              }
            } else {
              newSelection.clear();
              if (!isSelected) {
                newSelection.add(index);
              }
            }
            onSelectionChanged(newSelection);
          },
        );
      }),
    );
  }
}
