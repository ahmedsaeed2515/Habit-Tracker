// lib/features/onboarding/widgets/onboarding_step_widget.dart
// ويدجت عرض خطوة onboarding

import 'package:flutter/material.dart';

import '../../../shared/themes/app_theme.dart';
import '../models/onboarding_step.dart';

class OnboardingStepWidget extends StatelessWidget {

  const OnboardingStepWidget({super.key, required this.step});
  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الصورة التوضيحية
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: _buildImage(),
            ),
          ),

          // العنوان
          Expanded(
            child: Column(
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // الوصف
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // نص الإجراء (اختياري)
                if (step.actionText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      step.actionText!,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // محاولة تحميل Lottie animation أولاً، ثم صورة عادية كبديل
    try {
      // في التطبيق الحقيقي، يمكن استخدام Lottie أو SVG
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Icon(_getStepIcon(), size: 120, color: AppTheme.primaryColor),
      );
    } catch (e) {
      // في حالة فشل تحميل الصورة
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(_getStepIcon(), size: 80, color: AppTheme.primaryColor),
      );
    }
  }

  IconData _getStepIcon() {
    if (step.imagePath.contains('welcome')) {
      return Icons.waving_hand;
    } else if (step.imagePath.contains('habits')) {
      return Icons.track_changes;
    } else if (step.imagePath.contains('workout')) {
      return Icons.fitness_center;
    } else if (step.imagePath.contains('analytics')) {
      return Icons.analytics;
    } else if (step.imagePath.contains('community')) {
      return Icons.people;
    }
    return Icons.star;
  }
}
