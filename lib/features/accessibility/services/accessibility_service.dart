import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/accessibility_settings.dart';
import '../../../core/database/database_helper.dart';

class AccessibilityService {
  static final AccessibilityService _instance = AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  AccessibilitySettings? _currentSettings;

  // تهيئة الخدمة
  Future<void> initialize() async {
    try {
      await _loadSettings();
      await _applySystemSettings();
      debugPrint('تم تهيئة خدمة إمكانية الوصول بنجاح');
    } catch (e) {
      debugPrint('خطأ في تهيئة خدمة إمكانية الوصول: $e');
    }
  }

  // تحميل الإعدادات
  Future<void> _loadSettings() async {
    try {
      final box = await _databaseHelper.openBox<AccessibilitySettings>('accessibility_settings');
      _currentSettings = box.get('default');
      
      if (_currentSettings == null) {
        _currentSettings = _createDefaultSettings();
        await box.put('default', _currentSettings!);
      }
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات إمكانية الوصول: $e');
      _currentSettings = _createDefaultSettings();
    }
  }

  // إنشاء إعدادات افتراضية
  AccessibilitySettings _createDefaultSettings() {
    return AccessibilitySettings(
      id: 'default',
      motorImpairment: MotorImpairmentSettings(),
      cognitiveAccessibility: CognitiveAccessibilitySettings(),
      lastUpdated: DateTime.now(),
    );
  }

  // تطبيق إعدادات النظام
  Future<void> _applySystemSettings() async {
    if (_currentSettings == null) return;

    try {
      // تطبيق إعدادات إمكانية الوصول على النظام
      await _configureSystemAccessibility();
    } catch (e) {
      debugPrint('خطأ في تطبيق إعدادات النظام: $e');
    }
  }

  // تكوين إعدادات النظام
  Future<void> _configureSystemAccessibility() async {
    // في التطبيق الحقيقي، ستتم تهيئة إعدادات النظام هنا
    // مثل تفعيل قارئ الشاشة، تغيير حجم الخط، إلخ
  }

  // الحصول على الإعدادات الحالية
  AccessibilitySettings get currentSettings => _currentSettings ?? _createDefaultSettings();

  // تحديث الإعدادات
  Future<bool> updateSettings(AccessibilitySettings settings) async {
    try {
      final box = await _databaseHelper.openBox<AccessibilitySettings>('accessibility_settings');
      await box.put('default', settings);
      _currentSettings = settings;
      
      await _applySystemSettings();
      return true;
    } catch (e) {
      debugPrint('خطأ في تحديث إعدادات إمكانية الوصول: $e');
      return false;
    }
  }

  // تحديث إعداد معين
  Future<bool> updateSetting<T>(String key, T value) async {
    try {
      final settings = currentSettings;
      
      switch (key) {
        case 'reduceAnimations':
          settings.reduceAnimations = value as bool;
          break;
        case 'highContrast':
          settings.highContrast = value as bool;
          break;
        case 'fontSize':
          settings.fontSize = value as FontSize;
          break;
        case 'boldText':
          settings.boldText = value as bool;
          break;
        case 'screenReaderSupport':
          settings.screenReaderSupport = value as bool;
          break;
        case 'voiceCommands':
          settings.voiceCommands = value as bool;
          break;
        case 'hapticFeedback':
          settings.hapticFeedback = value as bool;
          break;
        case 'soundFeedback':
          settings.soundFeedback = value as bool;
          break;
        case 'colorBlindnessType':
          settings.colorBlindnessType = value as ColorBlindnessType;
          break;
        default:
          settings.updateCustomSetting(key, value);
      }
      
      return await updateSettings(settings);
    } catch (e) {
      debugPrint('خطأ في تحديث الإعداد $key: $e');
      return false;
    }
  }

  // تشغيل الاهتزاز إذا كان مفعلاً
  void triggerHapticFeedback({HapticFeedbackType type = HapticFeedbackType.lightImpact}) {
    if (currentSettings.hapticFeedback) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
        case HapticFeedbackType.selectionClick:
          HapticFeedback.selectionClick();
          break;
        case HapticFeedbackType.vibrate:
          HapticFeedback.vibrate();
          break;
      }
    }
  }

  // تشغيل صوت النظام إذا كان مفعلاً
  void triggerSystemSound(SystemSoundType sound) {
    if (currentSettings.soundFeedback) {
      SystemSound.play(sound);
    }
  }

  // الحصول على الألوان المعدلة لعمى الألوان
  Color adjustColorForColorBlindness(Color originalColor) {
    final colorBlindnessType = currentSettings.colorBlindnessType;
    
    if (colorBlindnessType == ColorBlindnessType.none) {
      return originalColor;
    }
    
    final hsl = HSLColor.fromColor(originalColor);
    
    switch (colorBlindnessType) {
      case ColorBlindnessType.deuteranopia:
        // تعديل للعمى الأخضر
        return _adjustForDeuteranopia(hsl).toColor();
      
      case ColorBlindnessType.protanopia:
        // تعديل للعمى الأحمر
        return _adjustForProtanopia(hsl).toColor();
      
      case ColorBlindnessType.tritanopia:
        // تعديل للعمى الأزرق
        return _adjustForTritanopia(hsl).toColor();
      
      case ColorBlindnessType.monochromacy:
        // تحويل للرمادي
        final gray = originalColor.computeLuminance();
        return Color.fromRGBO((gray * 255).round(), (gray * 255).round(), (gray * 255).round(), originalColor.opacity);
      
      default:
        return originalColor;
    }
  }

  // تعديل للعمى الأخضر
  HSLColor _adjustForDeuteranopia(HSLColor hsl) {
    // تحويل الأخضر إلى ألوان يمكن تمييزها
    if (hsl.hue >= 60 && hsl.hue <= 180) {
      return hsl.withHue((hsl.hue - 60) * 0.7 + 200);
    }
    return hsl;
  }

  // تعديل للعمى الأحمر
  HSLColor _adjustForProtanopia(HSLColor hsl) {
    // تحويل الأحمر إلى ألوان يمكن تمييزها
    if (hsl.hue >= 0 && hsl.hue <= 60 || hsl.hue >= 300 && hsl.hue <= 360) {
      return hsl.withHue(hsl.hue > 180 ? 240 : 120);
    }
    return hsl;
  }

  // تعديل للعمى الأزرق
  HSLColor _adjustForTritanopia(HSLColor hsl) {
    // تحويل الأزرق إلى ألوان يمكن تمييزها
    if (hsl.hue >= 180 && hsl.hue <= 300) {
      return hsl.withHue((hsl.hue - 180) * 0.5 + 60);
    }
    return hsl;
  }

  // الحصول على حجم الهدف المناسب للمس
  double getTouchTargetSize() {
    return currentSettings.motorImpairment.touchTargetSize;
  }

  // الحصول على مقياس الخط
  double getFontScale() {
    return currentSettings.fontScale;
  }

  // فحص ما إذا كانت الرسوم المتحركة مقللة
  bool shouldReduceAnimations() {
    return currentSettings.reduceAnimations;
  }

  // فحص ما إذا كان التباين العالي مفعلاً
  bool isHighContrastEnabled() {
    return currentSettings.highContrast;
  }

  // الحصول على مدة الرسوم المتحركة المناسبة
  Duration getAnimationDuration(Duration defaultDuration) {
    return shouldReduceAnimations() 
        ? Duration(milliseconds: (defaultDuration.inMilliseconds * 0.3).round())
        : defaultDuration;
  }

  // إجراء تدقيق لإمكانية الوصول
  Future<AccessibilityAudit> performAccessibilityAudit() async {
    try {
      final auditId = 'audit_${DateTime.now().millisecondsSinceEpoch}';
      final audit = AccessibilityAudit(
        id: auditId,
        auditDate: DateTime.now(),
      );
      
      // فحص المشاكل المحتملة
      final issues = await _detectAccessibilityIssues();
      final recommendations = await _generateRecommendations(issues);
      
      for (final issue in issues) {
        audit.addIssue(issue);
      }
      
      for (final recommendation in recommendations) {
        audit.addRecommendation(recommendation);
      }
      
      audit.calculateScore();
      
      // حفظ التدقيق
      final box = await _databaseHelper.openBox<AccessibilityAudit>('accessibility_audits');
      await box.put(auditId, audit);
      
      return audit;
    } catch (e) {
      debugPrint('خطأ في إجراء تدقيق إمكانية الوصول: $e');
      rethrow;
    }
  }

  // اكتشاف مشاكل إمكانية الوصول
  Future<List<AccessibilityIssue>> _detectAccessibilityIssues() async {
    final issues = <AccessibilityIssue>[];
    
    // فحص الإعدادات الحالية
    final settings = currentSettings;
    
    // فحص حجم الخط
    if (settings.fontSize == FontSize.small) {
      issues.add(AccessibilityIssue(
        id: 'small_font_issue',
        title: 'حجم خط صغير',
        description: 'حجم الخط قد يكون صغيراً جداً للمستخدمين الذين يعانون من ضعف البصر',
        severity: IssueSeverity.medium,
        category: IssueCategory.visual,
        location: 'إعدادات الخط',
      ));
    }
    
    // فحص التباين
    if (!settings.highContrast) {
      issues.add(AccessibilityIssue(
        id: 'low_contrast_issue',
        title: 'تباين منخفض',
        description: 'قد يحتاج المستخدمون إلى تباين أعلى لرؤية أفضل',
        severity: IssueSeverity.low,
        category: IssueCategory.visual,
        location: 'إعدادات العرض',
      ));
    }
    
    // فحص دعم قارئ الشاشة
    if (!settings.screenReaderSupport) {
      issues.add(AccessibilityIssue(
        id: 'no_screen_reader_issue',
        title: 'عدم دعم قارئ الشاشة',
        description: 'قارئ الشاشة غير مفعل، مما قد يؤثر على المستخدمين المكفوفين',
        severity: IssueSeverity.high,
        category: IssueCategory.visual,
        location: 'إعدادات إمكانية الوصول',
      ));
    }
    
    // فحص أهداف اللمس
    if (!settings.motorImpairment.largerTouchTargets) {
      issues.add(AccessibilityIssue(
        id: 'small_touch_targets_issue',
        title: 'أهداف لمس صغيرة',
        description: 'أهداف اللمس قد تكون صغيرة للمستخدمين الذين يعانون من صعوبات حركية',
        severity: IssueSeverity.medium,
        category: IssueCategory.motor,
        location: 'إعدادات الحركة',
      ));
    }
    
    return issues;
  }

  // توليد التوصيات
  Future<List<AccessibilityRecommendation>> _generateRecommendations(List<AccessibilityIssue> issues) async {
    final recommendations = <AccessibilityRecommendation>[];
    
    for (final issue in issues) {
      switch (issue.id) {
        case 'small_font_issue':
          recommendations.add(AccessibilityRecommendation(
            id: 'increase_font_size',
            title: 'زيادة حجم الخط',
            description: 'يُنصح بزيادة حجم الخط إلى متوسط أو كبير لتحسين القراءة',
            priority: RecommendationPriority.medium,
            category: IssueCategory.visual,
            steps: [
              'اذهب إلى الإعدادات',
              'اختر إعدادات إمكانية الوصول',
              'قم بتغيير حجم الخط إلى متوسط أو أكبر',
            ],
          ));
          break;
          
        case 'low_contrast_issue':
          recommendations.add(AccessibilityRecommendation(
            id: 'enable_high_contrast',
            title: 'تفعيل التباين العالي',
            description: 'تفعيل التباين العالي يحسن الرؤية للمستخدمين الذين يعانون من ضعف البصر',
            priority: RecommendationPriority.low,
            category: IssueCategory.visual,
            steps: [
              'اذهب إلى إعدادات العرض',
              'فعّل خيار التباين العالي',
            ],
          ));
          break;
          
        case 'no_screen_reader_issue':
          recommendations.add(AccessibilityRecommendation(
            id: 'enable_screen_reader',
            title: 'تفعيل دعم قارئ الشاشة',
            description: 'تفعيل دعم قارئ الشاشة أساسي للمستخدمين المكفوفين',
            priority: RecommendationPriority.high,
            category: IssueCategory.visual,
            steps: [
              'اذهب إلى إعدادات إمكانية الوصول',
              'فعّل دعم قارئ الشاشة',
              'اختبر التنقل باستخدام قارئ الشاشة',
            ],
          ));
          break;
          
        case 'small_touch_targets_issue':
          recommendations.add(AccessibilityRecommendation(
            id: 'increase_touch_targets',
            title: 'زيادة حجم أهداف اللمس',
            description: 'زيادة حجم أهداف اللمس يساعد المستخدمين الذين يعانون من صعوبات حركية',
            priority: RecommendationPriority.medium,
            category: IssueCategory.motor,
            steps: [
              'اذهب إلى إعدادات الحركة',
              'فعّل أهداف اللمس الكبيرة',
              'اختبر سهولة اللمس',
            ],
          ));
          break;
      }
    }
    
    return recommendations;
  }

  // الحصول على جميع التدقيقات
  Future<List<AccessibilityAudit>> getAllAudits() async {
    try {
      final box = await _databaseHelper.openBox<AccessibilityAudit>('accessibility_audits');
      return box.values.toList()
        ..sort((a, b) => b.auditDate.compareTo(a.auditDate));
    } catch (e) {
      debugPrint('خطأ في الحصول على التدقيقات: $e');
      return [];
    }
  }

  // الحصول على آخر تدقيق
  Future<AccessibilityAudit?> getLatestAudit() async {
    try {
      final audits = await getAllAudits();
      return audits.isNotEmpty ? audits.first : null;
    } catch (e) {
      debugPrint('خطأ في الحصول على آخر تدقيق: $e');
      return null;
    }
  }

  // تطبيق توصية
  Future<bool> implementRecommendation(String recommendationId) async {
    try {
      final audits = await getAllAudits();
      
      for (final audit in audits) {
        final recommendation = audit.recommendations.cast<AccessibilityRecommendation?>().firstWhere(
          (r) => r?.id == recommendationId,
          orElse: () => null,
        );
        
        if (recommendation != null && !recommendation.isImplemented) {
          // تطبيق التوصية
          await _applyRecommendation(recommendation);
          recommendation.markAsImplemented();
          await audit.save();
          return true;
        }
      }
      
      return false;
    } catch (e) {
      debugPrint('خطأ في تطبيق التوصية: $e');
      return false;
    }
  }

  // تطبيق التوصية
  Future<void> _applyRecommendation(AccessibilityRecommendation recommendation) async {
    switch (recommendation.id) {
      case 'increase_font_size':
        await updateSetting('fontSize', FontSize.large);
        break;
      case 'enable_high_contrast':
        await updateSetting('highContrast', true);
        break;
      case 'enable_screen_reader':
        await updateSetting('screenReaderSupport', true);
        break;
      case 'increase_touch_targets':
        final settings = currentSettings;
        settings.motorImpairment.updateSettings(largerTargets: true);
        await updateSettings(settings);
        break;
    }
  }

  // إنشاء تقرير إمكانية الوصول
  Future<Map<String, dynamic>> generateAccessibilityReport() async {
    try {
      final audit = await performAccessibilityAudit();
      final settings = currentSettings;
      
      return {
        'auditId': audit.id,
        'auditDate': audit.auditDate.toIso8601String(),
        'overallScore': audit.overallScore,
        'totalIssues': audit.issues.length,
        'highPriorityIssues': audit.issues.where((i) => i.severity == IssueSeverity.high).length,
        'recommendations': audit.recommendations.length,
        'implementedRecommendations': audit.recommendations.where((r) => r.isImplemented).length,
        'currentSettings': settings.toMap(),
        'hasAccessibilityFeatures': settings.hasAccessibilityFeatures,
        'issues': audit.issues.map((i) => {
          'id': i.id,
          'title': i.title,
          'severity': i.severity.name,
          'category': i.category.name,
          'isFixed': i.isFixed,
        }).toList(),
        'recommendations': audit.recommendations.map((r) => {
          'id': r.id,
          'title': r.title,
          'priority': r.priority.name,
          'category': r.category.name,
          'isImplemented': r.isImplemented,
        }).toList(),
      };
    } catch (e) {
      debugPrint('خطأ في إنشاء تقرير إمكانية الوصول: $e');
      return {};
    }
  }

  // تصدير إعدادات إمكانية الوصول
  Map<String, dynamic> exportSettings() {
    return currentSettings.toMap();
  }

  // استيراد إعدادات إمكانية الوصول
  Future<bool> importSettings(Map<String, dynamic> settingsMap) async {
    try {
      final settings = AccessibilitySettings.fromMap(settingsMap);
      return await updateSettings(settings);
    } catch (e) {
      debugPrint('خطأ في استيراد الإعدادات: $e');
      return false;
    }
  }
}

// تعداد لأنواع الاهتزاز
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}
