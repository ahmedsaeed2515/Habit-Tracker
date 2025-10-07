import 'package:hive/hive.dart';

part 'accessibility_settings.g.dart';

@HiveType(typeId: 92)
class AccessibilitySettings extends HiveObject {

  AccessibilitySettings({
    required this.id,
    this.reduceAnimations = false,
    this.highContrast = false,
    this.fontSize = FontSize.medium,
    this.boldText = false,
    this.screenReaderSupport = false,
    this.voiceCommands = false,
    this.hapticFeedback = true,
    this.soundFeedback = true,
    this.colorBlindnessType = ColorBlindnessType.none,
    required this.motorImpairment,
    required this.cognitiveAccessibility,
    this.customSettings = const {},
    required this.lastUpdated,
  });

  // إنشاء من خريطة
  factory AccessibilitySettings.fromMap(Map<String, dynamic> map) {
    return AccessibilitySettings(
      id: map['id'],
      reduceAnimations: map['reduceAnimations'] ?? false,
      highContrast: map['highContrast'] ?? false,
      fontSize: FontSize.values.firstWhere(
        (f) => f.name == map['fontSize'],
        orElse: () => FontSize.medium,
      ),
      boldText: map['boldText'] ?? false,
      screenReaderSupport: map['screenReaderSupport'] ?? false,
      voiceCommands: map['voiceCommands'] ?? false,
      hapticFeedback: map['hapticFeedback'] ?? true,
      soundFeedback: map['soundFeedback'] ?? true,
      colorBlindnessType: ColorBlindnessType.values.firstWhere(
        (c) => c.name == map['colorBlindnessType'],
        orElse: () => ColorBlindnessType.none,
      ),
      motorImpairment: MotorImpairmentSettings.fromMap(map['motorImpairment'] ?? {}),
      cognitiveAccessibility: CognitiveAccessibilitySettings.fromMap(map['cognitiveAccessibility'] ?? {}),
      customSettings: Map<String, dynamic>.from(map['customSettings'] ?? {}),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  bool reduceAnimations;

  @HiveField(2)
  bool highContrast;

  @HiveField(3)
  FontSize fontSize;

  @HiveField(4)
  bool boldText;

  @HiveField(5)
  bool screenReaderSupport;

  @HiveField(6)
  bool voiceCommands;

  @HiveField(7)
  bool hapticFeedback;

  @HiveField(8)
  bool soundFeedback;

  @HiveField(9)
  ColorBlindnessType colorBlindnessType;

  @HiveField(10)
  MotorImpairmentSettings motorImpairment;

  @HiveField(11)
  CognitiveAccessibilitySettings cognitiveAccessibility;

  @HiveField(12)
  Map<String, dynamic> customSettings;

  @HiveField(13)
  DateTime lastUpdated;

  // تحديث إعدادات إمكانية الوصول
  void updateSettings({
    bool? reduceAnimations,
    bool? highContrast,
    FontSize? fontSize,
    bool? boldText,
    bool? screenReaderSupport,
    bool? voiceCommands,
    bool? hapticFeedback,
    bool? soundFeedback,
    ColorBlindnessType? colorBlindnessType,
    MotorImpairmentSettings? motorImpairment,
    CognitiveAccessibilitySettings? cognitiveAccessibility,
  }) {
    if (reduceAnimations != null) this.reduceAnimations = reduceAnimations;
    if (highContrast != null) this.highContrast = highContrast;
    if (fontSize != null) this.fontSize = fontSize;
    if (boldText != null) this.boldText = boldText;
    if (screenReaderSupport != null) this.screenReaderSupport = screenReaderSupport;
    if (voiceCommands != null) this.voiceCommands = voiceCommands;
    if (hapticFeedback != null) this.hapticFeedback = hapticFeedback;
    if (soundFeedback != null) this.soundFeedback = soundFeedback;
    if (colorBlindnessType != null) this.colorBlindnessType = colorBlindnessType;
    if (motorImpairment != null) this.motorImpairment = motorImpairment;
    if (cognitiveAccessibility != null) this.cognitiveAccessibility = cognitiveAccessibility;
    
    lastUpdated = DateTime.now();
    save();
  }

  // تحديث إعداد مخصص
  void updateCustomSetting(String key, value) {
    final newSettings = Map<String, dynamic>.from(customSettings);
    newSettings[key] = value;
    customSettings = newSettings;
    lastUpdated = DateTime.now();
    save();
  }

  // الحصول على إعداد مخصص
  T? getCustomSetting<T>(String key) {
    return customSettings[key] as T?;
  }

  // الحصول على مقياس الخط
  double get fontScale {
    switch (fontSize) {
      case FontSize.small:
        return 0.8;
      case FontSize.medium:
        return 1.0;
      case FontSize.large:
        return 1.2;
      case FontSize.extraLarge:
        return 1.5;
      case FontSize.huge:
        return 2.0;
    }
  }

  // فحص ما إذا كانت ميزات إمكانية الوصول مفعلة
  bool get hasAccessibilityFeatures {
    return reduceAnimations ||
           highContrast ||
           fontSize != FontSize.medium ||
           boldText ||
           screenReaderSupport ||
           voiceCommands ||
           colorBlindnessType != ColorBlindnessType.none ||
           motorImpairment.isEnabled ||
           cognitiveAccessibility.isEnabled;
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reduceAnimations': reduceAnimations,
      'highContrast': highContrast,
      'fontSize': fontSize.name,
      'boldText': boldText,
      'screenReaderSupport': screenReaderSupport,
      'voiceCommands': voiceCommands,
      'hapticFeedback': hapticFeedback,
      'soundFeedback': soundFeedback,
      'colorBlindnessType': colorBlindnessType.name,
      'motorImpairment': motorImpairment.toMap(),
      'cognitiveAccessibility': cognitiveAccessibility.toMap(),
      'customSettings': customSettings,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

@HiveType(typeId: 93)
enum FontSize {
  @HiveField(0)
  small,        // صغير

  @HiveField(1)
  medium,       // متوسط

  @HiveField(2)
  large,        // كبير

  @HiveField(3)
  extraLarge,   // كبير جداً

  @HiveField(4)
  huge,         // ضخم
}

@HiveType(typeId: 94)
enum ColorBlindnessType {
  @HiveField(0)
  none,           // لا يوجد

  @HiveField(1)
  deuteranopia,   // عمى الألوان الأحمر-الأخضر (الأخضر)

  @HiveField(2)
  protanopia,     // عمى الألوان الأحمر-الأخضر (الأحمر)

  @HiveField(3)
  tritanopia,     // عمى الألوان الأزرق-الأصفر

  @HiveField(4)
  monochromacy,   // عمى الألوان الكامل
}

@HiveType(typeId: 95)
class MotorImpairmentSettings extends HiveObject { // اتجاه السحب المفضل

  MotorImpairmentSettings({
    this.isEnabled = false,
    this.largerTouchTargets = false,
    this.stickyKeys = false,
    this.slowKeys = false,
    this.bounceKeys = false,
    this.touchSensitivity = 1.0,
    this.touchHoldDuration = 500,
    this.oneHandedMode = false,
    this.assistiveTouch = false,
    this.preferredSwipeGesture = SwipeGesture.horizontal,
  });

  // إنشاء من خريطة
  factory MotorImpairmentSettings.fromMap(Map<String, dynamic> map) {
    return MotorImpairmentSettings(
      isEnabled: map['isEnabled'] ?? false,
      largerTouchTargets: map['largerTouchTargets'] ?? false,
      stickyKeys: map['stickyKeys'] ?? false,
      slowKeys: map['slowKeys'] ?? false,
      bounceKeys: map['bounceKeys'] ?? false,
      touchSensitivity: (map['touchSensitivity'] ?? 1.0).toDouble(),
      touchHoldDuration: map['touchHoldDuration'] ?? 500,
      oneHandedMode: map['oneHandedMode'] ?? false,
      assistiveTouch: map['assistiveTouch'] ?? false,
      preferredSwipeGesture: SwipeGesture.values.firstWhere(
        (s) => s.name == map['preferredSwipeGesture'],
        orElse: () => SwipeGesture.horizontal,
      ),
    );
  }
  @HiveField(0)
  bool isEnabled;

  @HiveField(1)
  bool largerTouchTargets; // أهداف لمس أكبر

  @HiveField(2)
  bool stickyKeys; // مفاتيح لاصقة

  @HiveField(3)
  bool slowKeys; // مفاتيح بطيئة

  @HiveField(4)
  bool bounceKeys; // منع الارتداد

  @HiveField(5)
  double touchSensitivity; // حساسية اللمس (0.1 - 2.0)

  @HiveField(6)
  int touchHoldDuration; // مدة الضغط المطولة (مللي ثانية)

  @HiveField(7)
  bool oneHandedMode; // وضع اليد الواحدة

  @HiveField(8)
  bool assistiveTouch; // لمس مساعد

  @HiveField(9)
  SwipeGesture preferredSwipeGesture;

  // تحديث الإعدادات
  void updateSettings({
    bool? enabled,
    bool? largerTargets,
    bool? sticky,
    bool? slow,
    bool? bounce,
    double? sensitivity,
    int? holdDuration,
    bool? oneHanded,
    bool? assistive,
    SwipeGesture? swipeGesture,
  }) {
    if (enabled != null) isEnabled = enabled;
    if (largerTargets != null) largerTouchTargets = largerTargets;
    if (sticky != null) stickyKeys = sticky;
    if (slow != null) slowKeys = slow;
    if (bounce != null) bounceKeys = bounce;
    if (sensitivity != null) touchSensitivity = sensitivity.clamp(0.1, 2.0);
    if (holdDuration != null) touchHoldDuration = holdDuration.clamp(100, 2000);
    if (oneHanded != null) oneHandedMode = oneHanded;
    if (assistive != null) assistiveTouch = assistive;
    if (swipeGesture != null) preferredSwipeGesture = swipeGesture;
    save();
  }

  // الحصول على حجم الهدف المناسب
  double get touchTargetSize {
    return largerTouchTargets ? 56.0 : 44.0;
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'isEnabled': isEnabled,
      'largerTouchTargets': largerTouchTargets,
      'stickyKeys': stickyKeys,
      'slowKeys': slowKeys,
      'bounceKeys': bounceKeys,
      'touchSensitivity': touchSensitivity,
      'touchHoldDuration': touchHoldDuration,
      'oneHandedMode': oneHandedMode,
      'assistiveTouch': assistiveTouch,
      'preferredSwipeGesture': preferredSwipeGesture.name,
    };
  }
}

@HiveType(typeId: 96)
enum SwipeGesture {
  @HiveField(0)
  horizontal,   // أفقي

  @HiveField(1)
  vertical,     // عمودي

  @HiveField(2)
  disabled,     // معطل
}

@HiveType(typeId: 97)
class CognitiveAccessibilitySettings extends HiveObject { // مستوى المساعدة في الذاكرة

  CognitiveAccessibilitySettings({
    this.isEnabled = false,
    this.simplifiedInterface = false,
    this.reducedClutter = false,
    this.clearLabels = false,
    this.consistentNavigation = false,
    this.confirmationPrompts = false,
    this.progressIndicators = false,
    this.timeoutWarnings = false,
    this.focusTimeout = 30,
    this.audioDescriptions = false,
    this.visualCues = false,
    this.memoryAssistLevel = MemoryAssistLevel.none,
  });

  // إنشاء من خريطة
  factory CognitiveAccessibilitySettings.fromMap(Map<String, dynamic> map) {
    return CognitiveAccessibilitySettings(
      isEnabled: map['isEnabled'] ?? false,
      simplifiedInterface: map['simplifiedInterface'] ?? false,
      reducedClutter: map['reducedClutter'] ?? false,
      clearLabels: map['clearLabels'] ?? false,
      consistentNavigation: map['consistentNavigation'] ?? false,
      confirmationPrompts: map['confirmationPrompts'] ?? false,
      progressIndicators: map['progressIndicators'] ?? false,
      timeoutWarnings: map['timeoutWarnings'] ?? false,
      focusTimeout: map['focusTimeout'] ?? 30,
      audioDescriptions: map['audioDescriptions'] ?? false,
      visualCues: map['visualCues'] ?? false,
      memoryAssistLevel: MemoryAssistLevel.values.firstWhere(
        (m) => m.name == map['memoryAssistLevel'],
        orElse: () => MemoryAssistLevel.none,
      ),
    );
  }
  @HiveField(0)
  bool isEnabled;

  @HiveField(1)
  bool simplifiedInterface; // واجهة مبسطة

  @HiveField(2)
  bool reducedClutter; // تقليل الفوضى

  @HiveField(3)
  bool clearLabels; // تسميات واضحة

  @HiveField(4)
  bool consistentNavigation; // تنقل ثابت

  @HiveField(5)
  bool confirmationPrompts; // مطالبات التأكيد

  @HiveField(6)
  bool progressIndicators; // مؤشرات التقدم

  @HiveField(7)
  bool timeoutWarnings; // تحذيرات انتهاء الوقت

  @HiveField(8)
  int focusTimeout; // مهلة التركيز (ثوان)

  @HiveField(9)
  bool audioDescriptions; // أوصاف صوتية

  @HiveField(10)
  bool visualCues; // إشارات بصرية

  @HiveField(11)
  MemoryAssistLevel memoryAssistLevel;

  // تحديث الإعدادات
  void updateSettings({
    bool? enabled,
    bool? simplified,
    bool? reduced,
    bool? clear,
    bool? consistent,
    bool? confirmations,
    bool? progress,
    bool? timeouts,
    int? timeout,
    bool? audio,
    bool? visual,
    MemoryAssistLevel? memoryLevel,
  }) {
    if (enabled != null) isEnabled = enabled;
    if (simplified != null) simplifiedInterface = simplified;
    if (reduced != null) reducedClutter = reduced;
    if (clear != null) clearLabels = clear;
    if (consistent != null) consistentNavigation = consistent;
    if (confirmations != null) confirmationPrompts = confirmations;
    if (progress != null) progressIndicators = progress;
    if (timeouts != null) timeoutWarnings = timeouts;
    if (timeout != null) focusTimeout = timeout.clamp(5, 300);
    if (audio != null) audioDescriptions = audio;
    if (visual != null) visualCues = visual;
    if (memoryLevel != null) memoryAssistLevel = memoryLevel;
    save();
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'isEnabled': isEnabled,
      'simplifiedInterface': simplifiedInterface,
      'reducedClutter': reducedClutter,
      'clearLabels': clearLabels,
      'consistentNavigation': consistentNavigation,
      'confirmationPrompts': confirmationPrompts,
      'progressIndicators': progressIndicators,
      'timeoutWarnings': timeoutWarnings,
      'focusTimeout': focusTimeout,
      'audioDescriptions': audioDescriptions,
      'visualCues': visualCues,
      'memoryAssistLevel': memoryAssistLevel.name,
    };
  }
}

@HiveType(typeId: 98)
enum MemoryAssistLevel {
  @HiveField(0)
  none,     // لا يوجد

  @HiveField(1)
  low,      // منخفض

  @HiveField(2)
  medium,   // متوسط

  @HiveField(3)
  high,     // عالي
}

@HiveType(typeId: 99)
class AccessibilityAudit extends HiveObject {

  AccessibilityAudit({
    required this.id,
    required this.auditDate,
    this.issues = const [],
    this.recommendations = const [],
    this.overallScore = 0.0,
    this.categoryScores = const {},
    this.auditData = const {},
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime auditDate;

  @HiveField(2)
  List<AccessibilityIssue> issues;

  @HiveField(3)
  List<AccessibilityRecommendation> recommendations;

  @HiveField(4)
  double overallScore; // نقاط من 0 إلى 100

  @HiveField(5)
  Map<String, double> categoryScores;

  @HiveField(6)
  Map<String, dynamic> auditData;

  // إضافة مشكلة
  void addIssue(AccessibilityIssue issue) {
    final newIssues = List<AccessibilityIssue>.from(issues);
    newIssues.add(issue);
    issues = newIssues;
    save();
  }

  // إضافة توصية
  void addRecommendation(AccessibilityRecommendation recommendation) {
    final newRecommendations = List<AccessibilityRecommendation>.from(recommendations);
    newRecommendations.add(recommendation);
    recommendations = newRecommendations;
    save();
  }

  // حساب النقاط الإجمالية
  void calculateScore() {
    final totalIssues = issues.length;
    final highPriorityIssues = issues.where((i) => i.severity == IssueSeverity.high).length;
    final mediumPriorityIssues = issues.where((i) => i.severity == IssueSeverity.medium).length;
    
    // حساب النقاط على أساس شدة المشاكل
    final penalty = (highPriorityIssues * 20) + (mediumPriorityIssues * 10) + ((totalIssues - highPriorityIssues - mediumPriorityIssues) * 5);
    overallScore = (100 - penalty).clamp(0.0, 100.0).toDouble();
    save();
  }
}

@HiveType(typeId: 100)
class AccessibilityIssue extends HiveObject {

  AccessibilityIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.location,
    this.isFixed = false,
    this.fixedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  IssueSeverity severity;

  @HiveField(4)
  IssueCategory category;

  @HiveField(5)
  String location; // مكان المشكلة في التطبيق

  @HiveField(6)
  bool isFixed;

  @HiveField(7)
  DateTime? fixedAt;

  // تعيين المشكلة كمحلولة
  void markAsFixed() {
    isFixed = true;
    fixedAt = DateTime.now();
    save();
  }
}

@HiveType(typeId: 101)
enum IssueSeverity {
  @HiveField(0)
  low,      // منخفضة

  @HiveField(1)
  medium,   // متوسطة

  @HiveField(2)
  high,     // عالية

  @HiveField(3)
  critical, // حرجة
}

@HiveType(typeId: 102)
enum IssueCategory {
  @HiveField(0)
  visual,       // بصرية

  @HiveField(1)
  motor,        // حركية

  @HiveField(2)
  cognitive,    // معرفية

  @HiveField(3)
  hearing,      // سمعية

  @HiveField(4)
  navigation,   // تنقل

  @HiveField(5)
  content,      // محتوى
}

@HiveType(typeId: 103)
class AccessibilityRecommendation extends HiveObject {

  AccessibilityRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    this.steps = const [],
    this.isImplemented = false,
    this.implementedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  RecommendationPriority priority;

  @HiveField(4)
  IssueCategory category;

  @HiveField(5)
  List<String> steps; // خطوات التنفيذ

  @HiveField(6)
  bool isImplemented;

  @HiveField(7)
  DateTime? implementedAt;

  // تعيين التوصية كمنفذة
  void markAsImplemented() {
    isImplemented = true;
    implementedAt = DateTime.now();
    save();
  }
}

@HiveType(typeId: 104)
enum RecommendationPriority {
  @HiveField(0)
  low,      // منخفضة

  @HiveField(1)
  medium,   // متوسطة

  @HiveField(2)
  high,     // عالية

  @HiveField(3)
  urgent,   // عاجلة
}