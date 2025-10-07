import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit_recommendation.dart';
import '../services/smart_recommendation_service.dart';
import '../../../core/providers/habits_provider.dart';

final smartRecommendationProvider =
    StateNotifierProvider<
      SmartRecommendationNotifier,
      SmartRecommendationState
    >((ref) {
      return SmartRecommendationNotifier(ref);
    });

class SmartRecommendationState {

  const SmartRecommendationState({
    this.recommendations = const [],
    this.patterns = const [],
    this.isLoading = false,
    this.isAnalyzing = false,
    this.error,
    this.lastAnalysis,
  });
  final List<HabitRecommendation> recommendations;
  final List<UserBehaviorPattern> patterns;
  final bool isLoading;
  final bool isAnalyzing;
  final String? error;
  final DateTime? lastAnalysis;

  SmartRecommendationState copyWith({
    List<HabitRecommendation>? recommendations,
    List<UserBehaviorPattern>? patterns,
    bool? isLoading,
    bool? isAnalyzing,
    String? error,
    DateTime? lastAnalysis,
  }) {
    return SmartRecommendationState(
      recommendations: recommendations ?? this.recommendations,
      patterns: patterns ?? this.patterns,
      isLoading: isLoading ?? this.isLoading,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
      lastAnalysis: lastAnalysis ?? this.lastAnalysis,
    );
  }

  // مرشحات التوصيات
  List<HabitRecommendation> get pendingRecommendations =>
      recommendations.where((r) => r.isPending).toList();

  List<HabitRecommendation> get acceptedRecommendations =>
      recommendations.where((r) => r.isAccepted).toList();

  List<HabitRecommendation> get rejectedRecommendations =>
      recommendations.where((r) => r.isRejected).toList();

  List<HabitRecommendation> get highConfidenceRecommendations =>
      recommendations.where((r) => r.confidenceScore >= 0.8).toList();

  List<HabitRecommendation> get unviewedRecommendations =>
      recommendations.where((r) => !r.isViewed).toList();

  // إحصائيات
  int get totalRecommendations => recommendations.length;
  int get pendingCount => pendingRecommendations.length;
  int get acceptedCount => acceptedRecommendations.length;
  int get rejectedCount => rejectedRecommendations.length;

  double get averageConfidence {
    if (recommendations.isEmpty) return 0.0;
    final total = recommendations
        .map((r) => r.confidenceScore)
        .reduce((a, b) => a + b);
    return total / recommendations.length;
  }
}

class SmartRecommendationNotifier
    extends StateNotifier<SmartRecommendationState> {
  SmartRecommendationNotifier(this._ref)
    : super(const SmartRecommendationState()) {
    _init();
  }

  final Ref _ref;
  final SmartRecommendationService _service = SmartRecommendationService();

  void _init() {
    // تحميل البيانات المحفوظة
    _loadRecommendations();
    _loadPatterns();

    // تحليل أولي إذا لم يكن هناك تحليل حديث
    if (state.lastAnalysis == null ||
        DateTime.now().difference(state.lastAnalysis!).inDays > 1) {
      analyzeAndGenerateRecommendations();
    }
  }

  void _loadRecommendations() {
    // TODO: تحميل التوصيات من Hive
    state = state.copyWith(isLoading: false);
  }

  void _loadPatterns() {
    // TODO: تحميل الأنماط من Hive
  }

  // تحليل السلوك وتوليد التوصيات
  Future<void> analyzeAndGenerateRecommendations() async {
    if (state.isAnalyzing) return;

    state = state.copyWith(isAnalyzing: true);

    try {
      // الحصول على العادات الحالية
      final habits = _ref.read(habitsProvider);

      // تحليل الأنماط السلوكية
      final patterns = _service.analyzeUserBehavior(habits);

      // توليد التوصيات
      final newRecommendations = _service.generateSmartRecommendations(
        habits,
        patterns,
      );

      // دمج التوصيات الجديدة مع الموجودة
      final updatedRecommendations = [...state.recommendations];

      // إضافة التوصيات الجديدة (تجنب التكرار)
      for (final newRec in newRecommendations) {
        final exists = updatedRecommendations.any(
          (r) => r.title == newRec.title && r.category == newRec.category,
        );
        if (!exists) {
          updatedRecommendations.add(newRec);
        }
      }

      state = state.copyWith(
        recommendations: updatedRecommendations,
        patterns: patterns,
        isAnalyzing: false,
        lastAnalysis: DateTime.now(),
      );

      // حفظ البيانات
      _saveRecommendations();
      _savePatterns();
    } catch (e) {
      state = state.copyWith(
        error: 'حدث خطأ في تحليل البيانات: $e',
        isAnalyzing: false,
      );
    }
  }

  // قبول توصية
  void acceptRecommendation(String recommendationId) {
    final updatedRecommendations = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        r.accept();
        return r;
      }
      return r;
    }).toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // رفض توصية
  void rejectRecommendation(String recommendationId) {
    final updatedRecommendations = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        r.reject();
        return r;
      }
      return r;
    }).toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // تمييز توصية كمقروءة
  void markRecommendationAsViewed(String recommendationId) {
    final updatedRecommendations = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        r.markAsViewed();
        return r;
      }
      return r;
    }).toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // حذف توصية
  void deleteRecommendation(String recommendationId) {
    final updatedRecommendations = state.recommendations
        .where((r) => r.id != recommendationId)
        .toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // مسح التوصيات المرفوضة
  void clearRejectedRecommendations() {
    final updatedRecommendations = state.recommendations
        .where((r) => !r.isRejected)
        .toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // مسح جميع التوصيات
  void clearAllRecommendations() {
    state = state.copyWith(recommendations: []);
    _saveRecommendations();
  }

  // الحصول على توصيات بفئة معينة
  List<HabitRecommendation> getRecommendationsByCategory(String category) {
    return state.recommendations.where((r) => r.category == category).toList();
  }

  // الحصول على توصيات بنوع معين
  List<HabitRecommendation> getRecommendationsByType(RecommendationType type) {
    return state.recommendations.where((r) => r.type == type).toList();
  }

  // الحصول على أفضل التوصيات
  List<HabitRecommendation> getTopRecommendations({int limit = 5}) {
    final sortedRecommendations = [...state.pendingRecommendations];
    sortedRecommendations.sort((a, b) {
      final scoreA = a.priority * a.confidenceScore;
      final scoreB = b.priority * b.confidenceScore;
      return scoreB.compareTo(scoreA);
    });

    return sortedRecommendations.take(limit).toList();
  }

  // إعادة تحليل أنماط محددة
  Future<void> reanalyzePatterns() async {
    if (state.isAnalyzing) return;

    state = state.copyWith(isAnalyzing: true);

    try {
      final habits = _ref.read(habitsProvider);
      final patterns = _service.analyzeUserBehavior(habits);

      state = state.copyWith(
        patterns: patterns,
        isAnalyzing: false,
        lastAnalysis: DateTime.now(),
      );

      _savePatterns();
    } catch (e) {
      state = state.copyWith(
        error: 'حدث خطأ في تحليل الأنماط: $e',
        isAnalyzing: false,
      );
    }
  }

  // تحديث أولوية توصية
  void updateRecommendationPriority(String recommendationId, int newPriority) {
    final updatedRecommendations = state.recommendations.map((r) {
      if (r.id == recommendationId) {
        r.priority = newPriority.clamp(1, 5);
        return r;
      }
      return r;
    }).toList();

    state = state.copyWith(recommendations: updatedRecommendations);
    _saveRecommendations();
  }

  // الحصول على إحصائيات مفصلة
  Map<String, dynamic> getDetailedStats() {
    final stats = <String, dynamic>{};

    stats['total'] = state.totalRecommendations;
    stats['pending'] = state.pendingCount;
    stats['accepted'] = state.acceptedCount;
    stats['rejected'] = state.rejectedCount;
    stats['averageConfidence'] = state.averageConfidence;

    // إحصائيات الفئات
    final categoryStats = <String, int>{};
    for (final rec in state.recommendations) {
      categoryStats[rec.category] = (categoryStats[rec.category] ?? 0) + 1;
    }
    stats['categoryBreakdown'] = categoryStats;

    // إحصائيات الأنواع
    final typeStats = <String, int>{};
    for (final rec in state.recommendations) {
      final typeName = rec.type.name;
      typeStats[typeName] = (typeStats[typeName] ?? 0) + 1;
    }
    stats['typeBreakdown'] = typeStats;

    stats['lastAnalysis'] = state.lastAnalysis;
    stats['patternCount'] = state.patterns.length;

    return stats;
  }

  // حفظ التوصيات
  void _saveRecommendations() {
    // TODO: حفظ في Hive
  }

  // حفظ الأنماط
  void _savePatterns() {
    // TODO: حفظ في Hive
  }

  // إزالة رسالة الخطأ
  void clearError() {
    state = state.copyWith();
  }

  // تحديث يدوي
  Future<void> refresh() async {
    await analyzeAndGenerateRecommendations();
  }
}
