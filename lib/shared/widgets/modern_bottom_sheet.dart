// lib/shared/widgets/modern_bottom_sheet.dart
// نافذة منبثقة حديثة من الأسفل - Modern Bottom Sheet

import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';

/// عرض نافذة منبثقة حديثة من الأسفل
Future<T?> showModernBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  double? maxHeight,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ModernBottomSheetContent(
      child: child,
      backgroundColor: backgroundColor,
      maxHeight: maxHeight,
    ),
  );
}

/// محتوى النافذة المنبثقة بتصميم حديث
class ModernBottomSheetContent extends StatelessWidget {
  const ModernBottomSheetContent({
    super.key,
    required this.child,
    this.backgroundColor,
    this.maxHeight,
  });

  final Widget child;
  final Color? backgroundColor;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight ?? screenHeight * 0.9),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesignSystem.radiusXLarge),
          topRight: Radius.circular(AppDesignSystem.radiusXLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Padding(
            padding: const EdgeInsets.all(AppDesignSystem.spacingMedium),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(
                  AppDesignSystem.radiusSmall,
                ),
              ),
            ),
          ),
          // Content
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// نافذة منبثقة بعنوان وإجراءات
class ModernBottomSheetWithHeader extends StatelessWidget {
  const ModernBottomSheetWithHeader({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.onClose,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppDesignSystem.spacingMedium),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: AppDesignSystem.titleLarge(context)),
              ),
              if (actions != null) ...actions!,
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose ?? () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDesignSystem.spacingMedium),
            child: child,
          ),
        ),
      ],
    );
  }
}
