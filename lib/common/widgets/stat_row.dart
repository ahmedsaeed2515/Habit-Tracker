// lib/common/widgets/stat_row.dart
// Widget لعرض صف إحصائية (تسمية وقيمة)

import 'package:flutter/material.dart';

/// Widget لعرض صف واحد من الإحصائيات
class StatRow extends StatelessWidget {

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.textColor,
  });
  /// تسمية الإحصائية
  final String label;

  /// قيمة الإحصائية
  final String value;

  /// أيقونة اختيارية تظهر بجانب القيمة
  final IconData? icon;

  /// لون النص
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textColor)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: textColor ?? Colors.grey),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
