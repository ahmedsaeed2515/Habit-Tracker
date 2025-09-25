// lib/common/widgets/empty_state_widget.dart
// Widget للحالة الفارغة - يستخدم في جميع أنحاء التطبيق

import 'package:flutter/material.dart';

/// Widget يعرض حالة فارغة مع أيقونة وعنوان ووصف وزر اختياري
class EmptyStateWidget extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Colors.grey;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: defaultColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: defaultColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
