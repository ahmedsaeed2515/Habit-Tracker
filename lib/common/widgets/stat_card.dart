// lib/common/widgets/stat_card.dart
// Widget للبطاقات الإحصائية المستخدمة في التطبيق

import 'package:flutter/material.dart';

/// Widget لعرض إحصائية واحدة في شكل بطاقة
class StatCard extends StatelessWidget {
  /// أيقونة الإحصائية
  final IconData icon;

  /// عنوان الإحصائية
  final String title;

  /// القيمة الرقمية أو النصية
  final String value;

  /// لون الأيقونة والحواف (اختياري)
  final Color? color;

  /// دالة يتم استدعاؤها عند الضغط على البطاقة
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: cardColor),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
