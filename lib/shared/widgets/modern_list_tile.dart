// lib/shared/widgets/modern_list_tile.dart
// عنصر قائمة حديث - Modern List Tile

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/app_design_system.dart';

/// عنصر قائمة حديث بتصميم جذاب
class ModernListTile extends StatelessWidget {
  const ModernListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.backgroundColor,
    this.padding,
    this.enableHapticFeedback = true,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDesignSystem.spacingSmall,
        vertical: AppDesignSystem.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (selected
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface),
        borderRadius: AppDesignSystem.borderRadiusMedium,
        border: Border.all(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled
              ? () {
                  if (enableHapticFeedback) {
                    HapticFeedback.lightImpact();
                  }
                  onTap?.call();
                }
              : null,
          onLongPress: enabled ? onLongPress : null,
          borderRadius: AppDesignSystem.borderRadiusMedium,
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppDesignSystem.spacingMedium,
                  vertical: AppDesignSystem.spacingMedium,
                ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const const SizedBox(width: AppDesignSystem.spacingMedium),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: AppDesignSystem.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: enabled
                              ? null
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                        child: title,
                      ),
                      if (subtitle != null) ...[
                        const const SizedBox(height: AppDesignSystem.spacingXSmall),
                        DefaultTextStyle(
                          style: AppDesignSystem.bodySmall(context).copyWith(
                            color: enabled
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  )
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                          ),
                          child: subtitle!,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const const SizedBox(width: AppDesignSystem.spacingMedium),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// عنصر قائمة مع أيقونة ملونة
class ModernIconListTile extends StatelessWidget {
  const ModernIconListTile({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.iconBackgroundColor,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              iconBackgroundColor ??
              theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: AppDesignSystem.borderRadiusSmall,
        ),
        child: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
      ),
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

/// عنصر قائمة بمفتاح تبديل
class ModernSwitchListTile extends StatelessWidget {
  const ModernSwitchListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: icon != null
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: AppDesignSystem.borderRadiusSmall,
              ),
              child: Icon(icon, color: iconColor ?? theme.colorScheme.primary),
            )
          : null,
      trailing: Switch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}
