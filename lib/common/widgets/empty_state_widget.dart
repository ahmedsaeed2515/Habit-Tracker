// lib/common/widgets/empty_state_widget.dart
// Widget للحالة الفارغة - يستخدم في جميع أنحاء التطبيق

import 'package:flutter/material.dart';

/// Widget يعرض حالة فارغة مع أيقونة وعنوان ووصف وزر اختياري
class EmptyStateWidget extends StatelessWidget {

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.buttonText,
    this.onPressed,
    this.color,
    this.iconSize = 80,
  });
  /// أيقونة الحالة الفارغة
  final IconData icon;

  /// عنوان الحالة الفارغة
  final String title;

  /// وصف أو تفسير الحالة
  final String description;

  /// نص زر الإجراء (اختياري)
  final String? buttonText;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  final VoidCallback? onPressed;

  /// لون الأيقونة والعنوان
  final Color? color;

  /// حجم الأيقونة
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = color ?? theme.primaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // حاوية الأيقونة مع خلفية ملونة
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: defaultColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: defaultColor.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(icon, size: iconSize, color: defaultColor),
            ),
            const const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onPressed != null) ...[
              const const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: defaultColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: defaultColor.withValues(alpha: 0.3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
