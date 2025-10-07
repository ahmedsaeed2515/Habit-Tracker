// lib/features/onboarding/screens/onboarding_screen.dart
// شاشة onboarding للمستخدمين الجدد

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/themes/app_theme.dart';
import '../models/onboarding_step.dart';
import '../widgets/onboarding_step_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [
    const OnboardingStep(
      title: 'مرحباً بك في تطبيق العادات الشامل',
      description:
          'ابدأ رحلتك نحو بناء عادات صحية ومستدامة مع مساعد ذكي وتحليلات متقدمة',
      imagePath: 'assets/images/onboarding/welcome.png',
    ),
    const OnboardingStep(
      title: 'تتبع عاداتك اليومية',
      description:
          'أنشئ وتتبع عاداتك اليومية بسهولة مع تذكيرات ذكية وإحصائيات مفصلة',
      imagePath: 'assets/images/onboarding/habits.png',
    ),
    const OnboardingStep(
      title: 'تمارين رياضية مخصصة',
      description:
          'خطط تمارينك الرياضية مع ذكاء اصطناعي يتكيف مع مستواك وأهدافك',
      imagePath: 'assets/images/onboarding/workout.png',
    ),
    const OnboardingStep(
      title: 'تحليلات وإحصائيات متقدمة',
      description: 'تابع تقدمك مع رسوم بيانية تفاعلية وتحليلات سلوكية متطورة',
      imagePath: 'assets/images/onboarding/analytics.png',
    ),
    const OnboardingStep(
      title: 'مجتمع داعم',
      description:
          'انضم لمجتمع المستخدمين، شارك إنجازاتك، واحصل على إلهام من الآخرين',
      imagePath: 'assets/images/onboarding/community.png',
      actionText: 'ابدأ الآن',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // شريط العلوي مع زر تخطي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // رقم الصفحة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_currentPage + 1}/${_steps.length}',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // زر تخطي
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      isArabic ? 'تخطي' : 'Skip',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // محتوى الصفحات
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: OnboardingStepWidget(step: _steps[index]),
                  );
                },
              ),
            ),

            // مؤشر الصفحات
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _steps.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: AppTheme.primaryColor.withOpacity(0.3),
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),

            // زر التالي/إنهاء
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _currentPage == _steps.length - 1
                          ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                          : (isArabic ? 'التالي' : 'Next'),
                      key: ValueKey<int>(_currentPage),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
