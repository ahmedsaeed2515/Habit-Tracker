// lib/features/habit_builder/services/habit_builder_service.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../core/models/habit.dart';
import '../models/habit_template.dart';

class HabitBuilderService {
  static const String _templatesBoxName = 'habit_templates';
  static const String _profileBoxName = 'user_profile';

  late Box<HabitTemplate> _templatesBox;
  late Box<UserProfile> _profileBox;

  Future<void> initialize() async {
    try {
      _templatesBox = await Hive.openBox<HabitTemplate>(_templatesBoxName);
      _profileBox = await Hive.openBox<UserProfile>(_profileBoxName);

      // إضافة القوالب الافتراضية إذا كانت فارغة
      if (_templatesBox.isEmpty) {
        await _initializeDefaultTemplates();
      }
    } catch (e) {
      debugPrint('خطأ في تهيئة خدمة بناء العادات: $e');
      rethrow;
    }
  }

  // الحصول على القوالب المُوصى بها
  List<HabitTemplate> getRecommendedTemplates({
    HabitCategory? category,
    int? difficultyLevel,
    int limit = 10,
  }) {
    try {
      var templates = _templatesBox.values.where((template) {
        bool matches = true;

        if (category != null && template.category != category) {
          matches = false;
        }

        if (difficultyLevel != null &&
            template.difficultyLevel != difficultyLevel) {
          matches = false;
        }

        return matches;
      }).toList();

      // ترتيب حسب الشعبية والتوصية
      templates.sort((a, b) {
        if (a.isRecommended != b.isRecommended) {
          return a.isRecommended ? -1 : 1;
        }
        return b.popularityScore.compareTo(a.popularityScore);
      });

      return templates.take(limit).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على القوالب المُوصى بها: $e');
      return [];
    }
  }

  // الحصول على توصيات شخصية
  List<HabitTemplate> getPersonalizedRecommendations({
    required String userId,
    int limit = 5,
  }) {
    try {
      final profile = _profileBox.get(userId);
      if (profile == null) {
        return getRecommendedTemplates(limit: limit);
      }

      var templates = _templatesBox.values.toList();

      // حساب النقاط لكل قالب
      var scoredTemplates = templates.map((template) {
        double score = template.popularityScore;

        // زيادة النقاط للفئات المهتم بها المستخدم
        if (profile.interests.contains(template.category)) {
          score += 50;
        }

        // زيادة النقاط للعادات المناسبة لمستوى اللياقة
        if (template.category == HabitCategory.fitness) {
          int levelDiff = (template.difficultyLevel - profile.fitnessLevel)
              .abs();
          score += (5 - levelDiff) * 10;
        }

        // تقليل النقاط للعادات التي أكملها المستخدم كثيراً
        int completedCount =
            profile.completedHabits[template.category.toString()] ?? 0;
        if (completedCount > 3) {
          score -= completedCount * 5;
        }

        return MapEntry(template, score);
      }).toList();

      // ترتيب حسب النقاط
      scoredTemplates.sort((a, b) => b.value.compareTo(a.value));

      return scoredTemplates.take(limit).map((e) => e.key).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على التوصيات الشخصية: $e');
      return getRecommendedTemplates(limit: limit);
    }
  }

  // إنشاء عادة من قالب
  Habit createHabitFromTemplate({
    required HabitTemplate template,
    required String language,
    DateTime? startDate,
    List<int>? customDays,
  }) {
    try {
      return Habit(
        id: _generateId(),
        name: template.getName(language),
        description: template.getDescription(language),
        type: HabitType.boolean,
        unit: 'مرة',
        entries: [],
        createdAt: startDate ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint('خطأ في إنشاء عادة من القالب: $e');
      rethrow;
    }
  }

  // الحصول على ملف المستخدم
  UserProfile? getUserProfile(String userId) {
    try {
      return _profileBox.get(userId);
    } catch (e) {
      debugPrint('خطأ في الحصول على ملف المستخدم: $e');
      return null;
    }
  }

  // تحديث ملف المستخدم
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _profileBox.put(profile.id, profile);
    } catch (e) {
      debugPrint('خطأ في تحديث ملف المستخدم: $e');
      rethrow;
    }
  }

  // إنشاء ملف مستخدم جديد
  Future<UserProfile> createUserProfile({
    required String userId,
    required List<HabitCategory> interests,
    required int fitnessLevel,
    required List<String> availableTimes,
    required int motivationStyle,
    List<String> challenges = const [],
  }) async {
    try {
      final profile = UserProfile(
        id: userId,
        interests: interests,
        fitnessLevel: fitnessLevel,
        availableTimes: availableTimes,
        motivationStyle: motivationStyle,
        challenges: challenges,
        completedHabits: {},
        lastUpdated: DateTime.now(),
        experiencePoints: 0,
        achievements: [],
        preferences: {},
      );

      await _profileBox.put(userId, profile);
      return profile;
    } catch (e) {
      debugPrint('خطأ في إنشاء ملف مستخدم جديد: $e');
      rethrow;
    }
  }

  // البحث في القوالب
  List<HabitTemplate> searchTemplates(String query, {String language = 'ar'}) {
    try {
      query = query.toLowerCase().trim();

      return _templatesBox.values.where((template) {
        final name = template.getName(language).toLowerCase();
        final description = template.getDescription(language).toLowerCase();
        final tags = template.tags.map((tag) => tag.toLowerCase()).join(' ');

        return name.contains(query) ||
            description.contains(query) ||
            tags.contains(query);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في البحث في القوالب: $e');
      return [];
    }
  }

  // الحصول على القوالب حسب الفئة
  List<HabitTemplate> getTemplatesByCategory(HabitCategory category) {
    try {
      return _templatesBox.values
          .where((template) => template.category == category)
          .toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على القوالب حسب الفئة: $e');
      return [];
    }
  }

  // إضافة القوالب الافتراضية
  Future<void> _initializeDefaultTemplates() async {
    try {
      final defaultTemplates = _getDefaultTemplates();

      for (final template in defaultTemplates) {
        await _templatesBox.put(template.id, template);
      }
    } catch (e) {
      debugPrint('خطأ في إضافة القوالب الافتراضية: $e');
    }
  }

  List<HabitTemplate> _getDefaultTemplates() {
    return [
      // عادات صحية
      HabitTemplate(
        id: 'template_drink_water',
        nameAr: 'شرب الماء',
        nameEn: 'Drink Water',
        descriptionAr: 'شرب 8 أكواب من الماء يومياً للحفاظ على الترطيب',
        descriptionEn: 'Drink 8 glasses of water daily to stay hydrated',
        category: HabitCategory.health,
        recommendedFrequency: 7,
        tags: ['صحة', 'ماء', 'ترطيب'],
        iconName: 'local_drink',
        colorCode: '#2196F3',
        difficultyLevel: 1,
        tips: ['احتفظ بزجاجة ماء معك', 'اشرب كوباً عند الاستيقاظ'],
        estimatedDurationMinutes: 2,
        popularityScore: 95,
        prerequisites: [],
        isRecommended: true,
        createdAt: DateTime.now(),
      ),

      // عادات اللياقة البدنية
      HabitTemplate(
        id: 'template_morning_exercise',
        nameAr: 'تمارين الصباح',
        nameEn: 'Morning Exercise',
        descriptionAr: 'ممارسة التمارين الرياضية لمدة 30 دقيقة كل صباح',
        descriptionEn: 'Do 30 minutes of exercise every morning',
        category: HabitCategory.fitness,
        recommendedFrequency: 5,
        tags: ['رياضة', 'صباح', 'نشاط'],
        iconName: 'fitness_center',
        colorCode: '#FF5722',
        difficultyLevel: 3,
        tips: ['ابدأ بتمارين بسيطة', 'حدد وقتاً ثابتاً'],
        estimatedDurationMinutes: 30,
        popularityScore: 88,
        prerequisites: [],
        isRecommended: true,
        createdAt: DateTime.now(),
      ),

      // عادات الإنتاجية
      HabitTemplate(
        id: 'template_daily_planning',
        nameAr: 'التخطيط اليومي',
        nameEn: 'Daily Planning',
        descriptionAr: 'كتابة خطة اليوم والأهداف كل صباح',
        descriptionEn: 'Write daily plan and goals every morning',
        category: HabitCategory.productivity,
        recommendedFrequency: 7,
        tags: ['تخطيط', 'أهداف', 'إنتاجية'],
        iconName: 'schedule',
        colorCode: '#9C27B0',
        difficultyLevel: 2,
        tips: ['استخدم قوائم المهام', 'حدد 3 أهداف رئيسية'],
        estimatedDurationMinutes: 15,
        popularityScore: 82,
        prerequisites: [],
        isRecommended: true,
        createdAt: DateTime.now(),
      ),

      // عادات التعلم
      HabitTemplate(
        id: 'template_daily_reading',
        nameAr: 'القراءة اليومية',
        nameEn: 'Daily Reading',
        descriptionAr: 'قراءة 30 دقيقة يومياً لتطوير المعرفة',
        descriptionEn: 'Read for 30 minutes daily to develop knowledge',
        category: HabitCategory.learning,
        recommendedFrequency: 7,
        tags: ['قراءة', 'تعلم', 'كتب'],
        iconName: 'book',
        colorCode: '#607D8B',
        difficultyLevel: 2,
        tips: ['اختر كتاباً تحبه', 'اقرأ في مكان هادئ'],
        estimatedDurationMinutes: 30,
        popularityScore: 75,
        prerequisites: [],
        isRecommended: true,
        createdAt: DateTime.now(),
      ),

      // عادات روحانية
      HabitTemplate(
        id: 'template_meditation',
        nameAr: 'التأمل',
        nameEn: 'Meditation',
        descriptionAr: 'ممارسة التأمل لمدة 10 دقائق للاسترخاء',
        descriptionEn: 'Practice meditation for 10 minutes to relax',
        category: HabitCategory.spiritual,
        recommendedFrequency: 7,
        tags: ['تأمل', 'استرخاء', 'سكينة'],
        iconName: 'self_improvement',
        colorCode: '#4CAF50',
        difficultyLevel: 2,
        tips: ['ابدأ ب5 دقائق', 'اجلس في مكان هادئ'],
        estimatedDurationMinutes: 10,
        popularityScore: 70,
        prerequisites: [],
        isRecommended: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  String _generateId() {
    return 'habit_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  // تنظيف الموارد
  void dispose() {
    // Hive boxes will be closed automatically
  }
}
