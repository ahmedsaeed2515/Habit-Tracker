// lib/features/habit_builder/screens/habit_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/habits_provider.dart';
import '../providers/habit_builder_provider.dart';
// import '../models/habit_template.dart';
import '../widgets/category_selection_widget.dart';
import '../widgets/template_card.dart';

class HabitBuilderScreen extends ConsumerStatefulWidget {
  const HabitBuilderScreen({super.key});

  @override
  ConsumerState<HabitBuilderScreen> createState() => _HabitBuilderScreenState();
}

class _HabitBuilderScreenState extends ConsumerState<HabitBuilderScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(habitBuilderProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بناء العادات الذكي'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? _buildErrorWidget(state.error!)
          : Column(
              children: [
                // مؤشر التقدم
                _buildProgressIndicator(state.currentStep),

                // محتوى الخطوات
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildWelcomeStep(),
                      _buildCategoriesStep(state),
                      _buildPreferencesStep(state),
                      _buildRecommendationsStep(state),
                      _buildSummaryStep(state),
                    ],
                  ),
                ),

                // أزرار التنقل
                _buildNavigationButtons(state),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    final theme = Theme.of(context);
    const totalSteps = 5;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              size: 6,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 80, color: theme.colorScheme.primary),
          const const SizedBox(height: 32),

          Text(
            'مرحباً بك في بناء العادات الذكي!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const const SizedBox(height: 16),

          Text(
            'سنقوم بمساعدتك في إنشاء خطة عادات شخصية مبنية على اهتماماتك وأهدافك.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const const SizedBox(height: 32),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const const SizedBox(width: 8),
                      Text(
                        'يستغرق الأمر 3-5 دقائق فقط',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const const SizedBox(width: 8),
                      Text(
                        'توصيات ذكية مخصصة لك',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const const SizedBox(width: 8),
                      Text(
                        'متابعة تلقائية للتقدم',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesStep(HabitBuilderState state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: CategorySelectionWidget(
          selectedCategories: state.selectedCategories,
          onSelectionChanged: (categories) {
            ref
                .read(habitBuilderProvider.notifier)
                .updateSelectedCategories(categories);
          },
        ),
      ),
    );
  }

  Widget _buildPreferencesStep(HabitBuilderState state) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أخبرنا المزيد عن تفضيلاتك',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const const SizedBox(height: 24),

            // مستوى اللياقة البدنية
            _buildSectionTitle('مستوى اللياقة البدنية الحالي'),
            const const SizedBox(height: 12),
            _buildFitnessLevelSelector(state.selectedDifficulty),
            const const SizedBox(height: 24),

            // الأوقات المتاحة
            _buildSectionTitle('الأوقات المتاحة للعادات'),
            const const SizedBox(height: 12),
            _buildTimeSelector(state.selectedTimes),
            const const SizedBox(height: 24),

            // أسلوب التحفيز
            _buildSectionTitle('أسلوب التحفيز المفضل'),
            const const SizedBox(height: 12),
            _buildMotivationSelector(state.selectedMotivationStyle),
            const const SizedBox(height: 24),

            // التحديات
            _buildSectionTitle('التحديات الحالية (اختياري)'),
            const const SizedBox(height: 12),
            _buildChallengesSelector(state.selectedChallenges),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsStep(HabitBuilderState state) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العادات الموصى بها لك',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const const SizedBox(height: 8),
                Text(
                  'اختر العادات التي تريد البدء بها (يمكنك اختيار عدة عادات)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const const SizedBox(height: 16),

          Expanded(
            child: state.recommendedTemplates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const const SizedBox(height: 16),
                        Text(
                          'لا توجد توصيات متاحة',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.recommendedTemplates.length,
                    itemBuilder: (context, index) {
                      final template = state.recommendedTemplates[index];
                      final isSelected = state.selectedTemplates.contains(
                        template,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TemplateCard(
                          template: template,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(habitBuilderProvider.notifier)
                                .toggleTemplateSelection(template);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(HabitBuilderState state) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص خطة العادات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const const SizedBox(height: 24),

          if (state.selectedTemplates.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const const SizedBox(height: 16),
                  Text(
                    'لم تختر أي عادات بعد',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.read(habitBuilderProvider.notifier).previousStep();
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('العودة لاختيار العادات'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const const SizedBox(width: 8),
                              Text(
                                'العادات المختارة: ${state.selectedTemplates.length}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const const SizedBox(height: 8),
                          Text(
                            'سيتم إضافة هذه العادات إلى قائمتك وستبدأ متابعتها اليوم.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: state.selectedTemplates.length,
                      itemBuilder: (context, index) {
                        final template = state.selectedTemplates[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                        template.colorCode.substring(1),
                                        radix: 16,
                                      ) |
                                      0xFF000000,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.star, // يمكن تحسينه لاحقاً
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              template.getName('ar'),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              template.category.getDisplayName('ar'),
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: Text(
                              '${template.recommendedFrequency}/7',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(HabitBuilderState state) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // زر الرجوع
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(habitBuilderProvider.notifier).previousStep();
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('السابق'),
              ),
            ),

          if (state.currentStep > 0) const const SizedBox(width: 16),

          // زر التالي/الإنهاء
          Expanded(
            flex: state.currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _getNextButtonAction(state),
              child: Text(_getNextButtonText(state)),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _getNextButtonAction(HabitBuilderState state) {
    switch (state.currentStep) {
      case 0:
        return () {
          ref.read(habitBuilderProvider.notifier).nextStep();
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        };
      case 1:
        return state.selectedCategories.isNotEmpty
            ? () {
                ref.read(habitBuilderProvider.notifier).nextStep();
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            : null;
      case 2:
        return () async {
          await ref
              .read(habitBuilderProvider.notifier)
              .createProfileAndGetRecommendations();
          ref.read(habitBuilderProvider.notifier).nextStep();
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        };
      case 3:
        return state.selectedTemplates.isNotEmpty
            ? () {
                ref.read(habitBuilderProvider.notifier).nextStep();
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            : null;
      case 4:
        return state.selectedTemplates.isNotEmpty
            ? () => _finishWizard(state)
            : null;
      default:
        return null;
    }
  }

  String _getNextButtonText(HabitBuilderState state) {
    switch (state.currentStep) {
      case 0:
        return 'ابدأ';
      case 1:
        return state.selectedCategories.isNotEmpty
            ? 'التالي'
            : 'اختر فئة واحدة على الأقل';
      case 2:
        return 'الحصول على التوصيات';
      case 3:
        return state.selectedTemplates.isNotEmpty
            ? 'مراجعة الاختيار'
            : 'اختر عادة واحدة على الأقل';
      case 4:
        return state.selectedTemplates.isNotEmpty
            ? 'إنشاء العادات'
            : 'اختر عادة واحدة على الأقل';
      default:
        return 'التالي';
    }
  }

  Future<void> _finishWizard(HabitBuilderState state) async {
    try {
      // إنشاء العادات من القوالب المحددة
      final habits = ref
          .read(habitBuilderProvider.notifier)
          .createHabitsFromSelectedTemplates();

      // إضافة العادات إلى قائمة العادات الرئيسية
      for (final habit in habits) {
        await ref.read(habitsProvider.notifier).addHabit(habit);
      }

      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إنشاء ${habits.length} عادات بنجاح!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // العودة إلى الشاشة الرئيسية
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في إنشاء العادات: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildErrorWidget(String error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(habitBuilderProvider.notifier).initialize();
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFitnessLevelSelector(int selectedLevel) {
    final theme = Theme.of(context);

    return Column(
      children: List.generate(5, (index) {
        final level = index + 1;
        final isSelected = selectedLevel == level;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              ref.read(habitBuilderProvider.notifier).updateDifficulty(level);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? theme.colorScheme.primaryContainer : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                  const const SizedBox(width: 12),
                  Text(
                    _getFitnessLevelText(level),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimeSelector(List<String> selectedTimes) {
    final theme = Theme.of(context);
    final availableTimes = [
      'الصباح الباكر',
      'الصباح',
      'الظهيرة',
      'بعد الظهر',
      'المساء',
      'الليل',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableTimes.map((time) {
        final isSelected = selectedTimes.contains(time);

        return FilterChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (selected) {
            final newTimes = List<String>.from(selectedTimes);
            if (selected) {
              newTimes.add(time);
            } else {
              newTimes.remove(time);
            }
            ref
                .read(habitBuilderProvider.notifier)
                .updateAvailableTimes(newTimes);
          },
          selectedColor: theme.colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }

  Widget _buildMotivationSelector(int selectedStyle) {
    final theme = Theme.of(context);
    final styles = [
      {
        'id': 1,
        'title': 'التذكيرات اللطيفة',
        'subtitle': 'تذكيرات هادئة ومشجعة',
      },
      {'id': 2, 'title': 'التحدي والمنافسة', 'subtitle': 'تحديات وأهداف طموحة'},
      {
        'id': 3,
        'title': 'الإنجازات والمكافآت',
        'subtitle': 'نقاط وشارات عند الإكمال',
      },
    ];

    return Column(
      children: styles.map((style) {
        final isSelected = selectedStyle == style['id'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              ref
                  .read(habitBuilderProvider.notifier)
                  .updateMotivationStyle(style['id']! as int);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? theme.colorScheme.primaryContainer : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style['title']! as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const const SizedBox(height: 4),
                  Text(
                    style['subtitle']! as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.7,
                            )
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChallengesSelector(List<String> selectedChallenges) {
    final theme = Theme.of(context);
    final challenges = [
      'قلة الوقت',
      'نقص الدافعية',
      'النسيان',
      'عدم الثبات',
      'الانشغال بالعمل',
      'المسؤوليات العائلية',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: challenges.map((challenge) {
        final isSelected = selectedChallenges.contains(challenge);

        return FilterChip(
          label: Text(challenge),
          selected: isSelected,
          onSelected: (selected) {
            final newChallenges = List<String>.from(selectedChallenges);
            if (selected) {
              newChallenges.add(challenge);
            } else {
              newChallenges.remove(challenge);
            }
            ref
                .read(habitBuilderProvider.notifier)
                .updateChallenges(newChallenges);
          },
          selectedColor: theme.colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }

  String _getFitnessLevelText(int level) {
    switch (level) {
      case 1:
        return 'مبتدئ - أبدأ من الصفر';
      case 2:
        return 'خفيف - أمارس الرياضة أحياناً';
      case 3:
        return 'متوسط - أمارس الرياضة بانتظام';
      case 4:
        return 'جيد - أحب التحديات الرياضية';
      case 5:
        return 'متقدم - رياضي محترف';
      default:
        return 'مستوى $level';
    }
  }
}
