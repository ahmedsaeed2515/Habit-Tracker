// lib/features/onboarding/models/onboarding_step.dart
// نموذج خطوة onboarding

class OnboardingStep {

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.imagePath,
    this.actionText,
  });
  final String title;
  final String description;
  final String imagePath;
  final String? actionText;
}
