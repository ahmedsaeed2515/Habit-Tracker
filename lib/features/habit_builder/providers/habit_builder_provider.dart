// lib/features/habit_builder/providers/habit_builder_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_template.dart';
import '../services/habit_builder_service.dart';
import '../../../core/models/habit.dart';

// خدمة بناء العادات
final habitBuilderServiceProvider = Provider<HabitBuilderService>((ref) {
  final service = HabitBuilderService();
  ref.onDispose(() => service.dispose());
  return service;
});

// الحالة الحالية لمعالج بناء العادات
class HabitBuilderState {
  final int currentStep;
  final UserProfile? userProfile;
  final List<HabitCategory> selectedCategories;
  final int selectedDifficulty;
  final List<String> selectedTimes;
  final int selectedMotivationStyle;
  final List<String> selectedChallenges;
  final List<HabitTemplate> recommendedTemplates;
  final List<HabitTemplate> selectedTemplates;
  final bool isLoading;
  final String? error;

  const HabitBuilderState({
    this.currentStep = 0,
    this.userProfile,
    this.selectedCategories = const [],
    this.selectedDifficulty = 2,
    this.selectedTimes = const [],
    this.selectedMotivationStyle = 1,
    this.selectedChallenges = const [],
    this.recommendedTemplates = const [],
    this.selectedTemplates = const [],
    this.isLoading = false,
    this.error,
  });

  HabitBuilderState copyWith({
    int? currentStep,
    UserProfile? userProfile,
    List<HabitCategory>? selectedCategories,
    int? selectedDifficulty,
    List<String>? selectedTimes,
    int? selectedMotivationStyle,
    List<String>? selectedChallenges,
    List<HabitTemplate>? recommendedTemplates,
    List<HabitTemplate>? selectedTemplates,
    bool? isLoading,
    String? error,
  }) {
    return HabitBuilderState(
      currentStep: currentStep ?? this.currentStep,
      userProfile: userProfile ?? this.userProfile,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedTimes: selectedTimes ?? this.selectedTimes,
      selectedMotivationStyle:
          selectedMotivationStyle ?? this.selectedMotivationStyle,
      selectedChallenges: selectedChallenges ?? this.selectedChallenges,
      recommendedTemplates: recommendedTemplates ?? this.recommendedTemplates,
      selectedTemplates: selectedTemplates ?? this.selectedTemplates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// مزود معالج بناء العادات
class HabitBuilderNotifier extends StateNotifier<HabitBuilderState> {
  final HabitBuilderService _service;

  HabitBuilderNotifier(this._service) : super(const HabitBuilderState());

  // تهيئة الخدمة
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _service.initialize();

      // محاولة تحميل ملف المستخدم الموجود
      final profile = _service.getUserProfile('default_user');
      if (profile != null) {
        state = state.copyWith(userProfile: profile);
        await _loadRecommendations();
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تهيئة معالج بناء العادات: $e',
      );
    }
  }

  // الانتقال للخطوة التالية
  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  // العودة للخطوة السابقة
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // تحديد الفئات المهتم بها
  void updateSelectedCategories(List<HabitCategory> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  // تحديد مستوى الصعوبة
  void updateDifficulty(int difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }

  // تحديد الأوقات المتاحة
  void updateAvailableTimes(List<String> times) {
    state = state.copyWith(selectedTimes: times);
  }

  // تحديد أسلوب التحفيز
  void updateMotivationStyle(int style) {
    state = state.copyWith(selectedMotivationStyle: style);
  }

  // تحديد التحديات
  void updateChallenges(List<String> challenges) {
    state = state.copyWith(selectedChallenges: challenges);
  }

  // تحميل التوصيات
  Future<void> _loadRecommendations() async {
    try {
      if (state.userProfile != null) {
        final recommendations = _service.getPersonalizedRecommendations(
          userId: state.userProfile!.id,
          limit: 10,
        );
        state = state.copyWith(recommendedTemplates: recommendations);
      }
    } catch (e) {
      print('خطأ في تحميل التوصيات: $e');
    }
  }

  // إنشاء ملف المستخدم والحصول على التوصيات
  Future<void> createProfileAndGetRecommendations() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final profile = await _service.createUserProfile(
        userId: 'default_user',
        interests: state.selectedCategories,
        fitnessLevel: state.selectedDifficulty,
        availableTimes: state.selectedTimes,
        motivationStyle: state.selectedMotivationStyle,
        challenges: state.selectedChallenges,
      );

      state = state.copyWith(userProfile: profile);
      await _loadRecommendations();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في إنشاء ملف المستخدم: $e',
      );
    }
  }

  // تحديد/إلغاء تحديد قالب
  void toggleTemplateSelection(HabitTemplate template) {
    final selected = List<HabitTemplate>.from(state.selectedTemplates);

    if (selected.contains(template)) {
      selected.remove(template);
    } else {
      selected.add(template);
    }

    state = state.copyWith(selectedTemplates: selected);
  }

  // إنشاء العادات من القوالب المحددة
  List<Habit> createHabitsFromSelectedTemplates({String language = 'ar'}) {
    try {
      return state.selectedTemplates.map((template) {
        return _service.createHabitFromTemplate(
          template: template,
          language: language,
          startDate: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      state = state.copyWith(error: 'فشل في إنشاء العادات: $e');
      return [];
    }
  }

  // البحث في القوالب
  List<HabitTemplate> searchTemplates(String query, {String language = 'ar'}) {
    return _service.searchTemplates(query, language: language);
  }

  // الحصول على القوالب حسب الفئة
  List<HabitTemplate> getTemplatesByCategory(HabitCategory category) {
    return _service.getTemplatesByCategory(category);
  }

  // إعادة تعيين المعالج
  void reset() {
    state = const HabitBuilderState();
  }
}

final habitBuilderProvider =
    StateNotifierProvider<HabitBuilderNotifier, HabitBuilderState>((ref) {
      final service = ref.read(habitBuilderServiceProvider);
      final notifier = HabitBuilderNotifier(service);

      // تهيئة الخدمة عند إنشاء المزود
      notifier.initialize();

      return notifier;
    });
