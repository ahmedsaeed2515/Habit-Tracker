// lib/shared/widgets/modern_dialog.dart
// حوار حديث بتصميم عصري - Modern Dialog

import 'package:flutter/material.dart';
import '../design_system/app_design_system.dart';
import 'gradient_button.dart';

/// عرض حوار حديث
Future<T?> showModernDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) =>
        Dialog(backgroundColor: Colors.transparent, child: child),
  );
}

/// حوار حديث مع عنوان ومحتوى وأزرار
class ModernAlertDialog extends StatelessWidget {
  const ModernAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
  });

  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDesignSystem.borderRadiusLarge,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDesignSystem.spacingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          if (icon != null) ...[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: AppDesignSystem.spacingMedium),
          ],
          // Title
          if (title != null) ...[
            Text(
              title!,
              style: AppDesignSystem.titleLarge(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesignSystem.spacingMedium),
          ],
          // Content
          if (content != null) ...[
            DefaultTextStyle(
              style: AppDesignSystem.bodyLarge(context),
              textAlign: TextAlign.center,
              child: content!,
            ),
            const SizedBox(height: AppDesignSystem.spacingLarge),
          ],
          // Actions
          if (actions != null && actions!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppDesignSystem.spacingSmall,
                  ),
                  child: action,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

/// حوار تأكيد حديث
class ModernConfirmDialog extends StatelessWidget {
  const ModernConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModernAlertDialog(
      title: title,
      icon: icon ?? (isDestructive ? Icons.warning : Icons.help_outline),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        GradientButton(
          onPressed: () => Navigator.pop(context, true),
          gradient: isDestructive
              ? LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade800],
                )
              : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingLarge,
            vertical: AppDesignSystem.spacingSmall,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// حوار نجاح
Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showModernDialog(
    context: context,
    child: ModernAlertDialog(
      title: title,
      icon: Icons.check_circle,
      content: Text(message),
      actions: [
        GradientButton(
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingLarge,
            vertical: AppDesignSystem.spacingSmall,
          ),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}

/// حوار خطأ
Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  return showModernDialog(
    context: context,
    child: ModernAlertDialog(
      title: title,
      icon: Icons.error_outline,
      content: Text(message),
      actions: [
        GradientButton(
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(
            colors: [Colors.red.shade600, Colors.red.shade800],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignSystem.spacingLarge,
            vertical: AppDesignSystem.spacingSmall,
          ),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}
