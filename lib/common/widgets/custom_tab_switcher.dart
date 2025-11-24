// lib/common/widgets/custom_tab_switcher.dart
// Widget للتبديل بين التبويبات بتصميم مخصص

import 'package:flutter/material.dart';

/// تمثل خيار واحد في التبويبات
class TabOption {

  const TabOption({required this.text, this.icon});
  /// النص المعروض
  final String text;

  /// الأيقونة الاختيارية
  final IconData? icon;
}

/// Widget لعرض مجموعة تبويبات قابلة للتبديل
class CustomTabSwitcher extends StatelessWidget {

  const CustomTabSwitcher({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.backgroundColor,
    this.selectedColor,
  });
  /// قائمة الخيارات المتاحة
  final List<TabOption> options;

  /// فهرس الخيار المحدد حالياً
  final int selectedIndex;

  /// دالة يتم استدعاؤها عند تغيير التبويبة
  final Function(int) onChanged;

  /// لون الخلفية (اختياري)
  final Color? backgroundColor;

  /// لون التبويبة المحددة (اختياري)
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final selColor = selectedColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: bgColor,
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isSelected ? selColor : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const const SizedBox(width: 8),
                    ],
                    Text(
                      option.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
