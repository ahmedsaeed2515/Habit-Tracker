import 'package:hive/hive.dart';

part 'report_data.g.dart';

@HiveType(typeId: 55)
class ReportData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titleEn;

  @HiveField(2)
  String titleAr;

  @HiveField(3)
  ReportType type;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  DateTime endDate;

  @HiveField(7)
  Map<String, dynamic> data;

  @HiveField(8)
  List<String> insights;

  @HiveField(9)
  List<String> recommendations;

  @HiveField(10)
  double overallScore;

  @HiveField(11)
  Map<String, double> categoryScores;

  @HiveField(12)
  ReportStatus status;

  @HiveField(13)
  String? filePath;

  ReportData({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.type,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    this.data = const {},
    this.insights = const [],
    this.recommendations = const [],
    this.overallScore = 0.0,
    this.categoryScores = const {},
    this.status = ReportStatus.generating,
    this.filePath,
  });

  // الحصول على مدة التقرير بالأيام
  int get durationInDays => endDate.difference(startDate).inDays + 1;

  // الحصول على متوسط النقاط اليومية
  double get averageDailyScore => overallScore / durationInDays;

  // الحصول على أفضل فئة
  String? get topCategory {
    if (categoryScores.isEmpty) return null;
    return categoryScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // الحصول على أضعف فئة
  String? get weakestCategory {
    if (categoryScores.isEmpty) return null;
    return categoryScores.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  // تحديث بيانات التقرير
  void updateData(Map<String, dynamic> newData) {
    final updatedData = Map<String, dynamic>.from(data);
    updatedData.addAll(newData);
    data = updatedData;
    save();
  }

  // إضافة رؤية جديدة
  void addInsight(String insight) {
    final newInsights = List<String>.from(insights);
    newInsights.add(insight);
    insights = newInsights;
    save();
  }

  // إضافة توصية جديدة
  void addRecommendation(String recommendation) {
    final newRecommendations = List<String>.from(recommendations);
    newRecommendations.add(recommendation);
    recommendations = newRecommendations;
    save();
  }

  // تحديث النقاط
  void updateScores(double overall, Map<String, double> categories) {
    overallScore = overall;
    categoryScores = Map<String, double>.from(categories);
    save();
  }

  // تحديث حالة التقرير
  void updateStatus(ReportStatus newStatus, {String? file}) {
    status = newStatus;
    if (file != null) filePath = file;
    save();
  }

  // تحويل إلى خريطة للتصدير
  Map<String, dynamic> toExportMap() {
    return {
      'metadata': {
        'id': id,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'type': type.name,
        'createdAt': createdAt.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'overallScore': overallScore,
        'status': status.name,
      },
      'data': data,
      'insights': insights,
      'recommendations': recommendations,
      'categoryScores': categoryScores,
    };
  }
}

@HiveType(typeId: 56)
enum ReportType {
  @HiveField(0)
  daily,      // يومي

  @HiveField(1)
  weekly,     // أسبوعي

  @HiveField(2)
  monthly,    // شهري

  @HiveField(3)
  quarterly,  // ربعي

  @HiveField(4)
  yearly,     // سنوي

  @HiveField(5)
  custom,     // مخصص
}

@HiveType(typeId: 57)
enum ReportStatus {
  @HiveField(0)
  generating, // قيد الإنشاء

  @HiveField(1)
  ready,      // جاهز

  @HiveField(2)
  exported,   // مُصدّر

  @HiveField(3)
  shared,     // مشارك

  @HiveField(4)
  archived,   // مؤرشف
}

@HiveType(typeId: 58)
class ReportTemplate extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nameEn;

  @HiveField(2)
  String nameAr;

  @HiveField(3)
  String descriptionEn;

  @HiveField(4)
  String descriptionAr;

  @HiveField(5)
  ReportType type;

  @HiveField(6)
  List<String> sections;

  @HiveField(7)
  List<String> charts;

  @HiveField(8)
  Map<String, dynamic> settings;

  @HiveField(9)
  bool isDefault;

  @HiveField(10)
  DateTime createdAt;

  ReportTemplate({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    this.sections = const [],
    this.charts = const [],
    this.settings = const {},
    this.isDefault = false,
    required this.createdAt,
  });

  // إضافة قسم جديد
  void addSection(String section) {
    final newSections = List<String>.from(sections);
    newSections.add(section);
    sections = newSections;
    save();
  }

  // إزالة قسم
  void removeSection(String section) {
    final newSections = List<String>.from(sections);
    newSections.remove(section);
    sections = newSections;
    save();
  }

  // إضافة مخطط
  void addChart(String chart) {
    final newCharts = List<String>.from(charts);
    newCharts.add(chart);
    charts = newCharts;
    save();
  }

  // تحديث الإعدادات
  void updateSettings(Map<String, dynamic> newSettings) {
    final updatedSettings = Map<String, dynamic>.from(settings);
    updatedSettings.addAll(newSettings);
    settings = updatedSettings;
    save();
  }
}

@HiveType(typeId: 59)
class InsightData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titleEn;

  @HiveField(2)
  String titleAr;

  @HiveField(3)
  String descriptionEn;

  @HiveField(4)
  String descriptionAr;

  @HiveField(5)
  InsightType type;

  @HiveField(6)
  InsightPriority priority;

  @HiveField(7)
  DateTime discoveredAt;

  @HiveField(8)
  Map<String, dynamic> context;

  @HiveField(9)
  List<String> actionItems;

  @HiveField(10)
  bool isRead;

  @HiveField(11)
  bool isActionTaken;

  InsightData({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    this.priority = InsightPriority.medium,
    required this.discoveredAt,
    this.context = const {},
    this.actionItems = const [],
    this.isRead = false,
    this.isActionTaken = false,
  });

  // تحديد كقروء
  void markAsRead() {
    isRead = true;
    save();
  }

  // تحديد كمُنجز
  void markAsActionTaken() {
    isActionTaken = true;
    save();
  }

  // إضافة عنصر عمل
  void addActionItem(String item) {
    final newActionItems = List<String>.from(actionItems);
    newActionItems.add(item);
    actionItems = newActionItems;
    save();
  }

  // الحصول على أيقونة الأولوية
  String get priorityIcon {
    switch (priority) {
      case InsightPriority.low:
        return '🟢';
      case InsightPriority.medium:
        return '🟡';
      case InsightPriority.high:
        return '🟠';
      case InsightPriority.critical:
        return '🔴';
    }
  }
}

@HiveType(typeId: 60)
enum InsightType {
  @HiveField(0)
  trend,          // اتجاه

  @HiveField(1)
  pattern,        // نمط

  @HiveField(2)
  anomaly,        // شذوذ

  @HiveField(3)
  achievement,    // إنجاز

  @HiveField(4)
  opportunity,    // فرصة

  @HiveField(5)
  warning,        // تحذير
}

@HiveType(typeId: 61)
enum InsightPriority {
  @HiveField(0)
  low,        // منخفض

  @HiveField(1)
  medium,     // متوسط

  @HiveField(2)
  high,       // عالي

  @HiveField(3)
  critical,   // حرج
}

@HiveType(typeId: 62)
class MetricData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double value;

  @HiveField(3)
  String unit;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  Map<String, dynamic> metadata;

  @HiveField(6)
  double? previousValue;

  @HiveField(7)
  String category;

  MetricData({
    required this.id,
    required this.name,
    required this.value,
    this.unit = '',
    required this.timestamp,
    this.metadata = const {},
    this.previousValue,
    this.category = 'general',
  });

  // حساب التغيير المئوي
  double? get percentChange {
    if (previousValue == null || previousValue == 0) return null;
    return ((value - previousValue!) / previousValue!) * 100;
  }

  // الحصول على اتجاه التغيير
  String get trendDirection {
    final change = percentChange;
    if (change == null) return 'stable';
    if (change > 5) return 'increasing';
    if (change < -5) return 'decreasing';
    return 'stable';
  }

  // الحصول على أيقونة الاتجاه
  String get trendIcon {
    switch (trendDirection) {
      case 'increasing':
        return '📈';
      case 'decreasing':
        return '📉';
      default:
        return '➡️';
    }
  }
}