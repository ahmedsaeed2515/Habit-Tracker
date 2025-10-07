import 'package:hive/hive.dart';

part 'widget_config.g.dart';

@HiveType(typeId: 73)
class WidgetConfig extends HiveObject {

  WidgetConfig({
    required this.id,
    required this.type,
    required this.title,
    required this.size,
    this.settings = const {},
    this.isEnabled = true,
    required this.createdAt,
    required this.updatedAt,
    this.priority = 0,
    this.habitIds = const [],
    this.theme = WidgetTheme.system,
    this.displayOptions = const {},
    this.refreshInterval = RefreshInterval.minutes15,
  });

  // إنشاء من خريطة
  factory WidgetConfig.fromMap(Map<String, dynamic> map) {
    return WidgetConfig(
      id: map['id'],
      type: WidgetType.values.firstWhere((t) => t.name == map['type']),
      title: map['title'],
      size: WidgetSize.values.firstWhere((s) => s.name == map['size']),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      isEnabled: map['isEnabled'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      priority: map['priority'] ?? 0,
      habitIds: List<String>.from(map['habitIds'] ?? []),
      theme: WidgetTheme.values.firstWhere((t) => t.name == map['theme'], orElse: () => WidgetTheme.system),
      displayOptions: Map<String, dynamic>.from(map['displayOptions'] ?? {}),
      refreshInterval: RefreshInterval.values.firstWhere((r) => r.name == map['refreshInterval'], orElse: () => RefreshInterval.minutes15),
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  WidgetType type;

  @HiveField(2)
  String title;

  @HiveField(3)
  WidgetSize size;

  @HiveField(4)
  Map<String, dynamic> settings;

  @HiveField(5)
  bool isEnabled;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  @HiveField(8)
  int priority;

  @HiveField(9)
  List<String> habitIds; // العادات المرتبطة بالودجت

  @HiveField(10)
  WidgetTheme theme;

  @HiveField(11)
  Map<String, dynamic> displayOptions;

  @HiveField(12)
  RefreshInterval refreshInterval;

  // تحديث الإعدادات
  void updateSettings(Map<String, dynamic> newSettings) {
    settings = {...settings, ...newSettings};
    updatedAt = DateTime.now();
    save();
  }

  // تفعيل/إلغاء تفعيل الودجت
  void toggleEnabled() {
    isEnabled = !isEnabled;
    updatedAt = DateTime.now();
    save();
  }

  // إضافة عادة إلى الودجت
  void addHabitId(String habitId) {
    if (!habitIds.contains(habitId)) {
      final newHabitIds = List<String>.from(habitIds);
      newHabitIds.add(habitId);
      habitIds = newHabitIds;
      updatedAt = DateTime.now();
      save();
    }
  }

  // إزالة عادة من الودجت
  void removeHabitId(String habitId) {
    final newHabitIds = List<String>.from(habitIds);
    newHabitIds.remove(habitId);
    habitIds = newHabitIds;
    updatedAt = DateTime.now();
    save();
  }

  // تحديث خيارات العرض
  void updateDisplayOptions(Map<String, dynamic> options) {
    displayOptions = {...displayOptions, ...options};
    updatedAt = DateTime.now();
    save();
  }

  // الحصول على إعداد معين
  T? getSetting<T>(String key) {
    return settings[key] as T?;
  }

  // تحديد إعداد معين
  void setSetting(String key, value) {
    final newSettings = Map<String, dynamic>.from(settings);
    newSettings[key] = value;
    settings = newSettings;
    updatedAt = DateTime.now();
    save();
  }

  // فحص ما إذا كان الودجت يدعم حجم معين
  bool supportsSize(WidgetSize size) {
    switch (type) {
      case WidgetType.habitProgress:
        return [WidgetSize.small, WidgetSize.medium, WidgetSize.large].contains(size);
      case WidgetType.todayTasks:
        return [WidgetSize.medium, WidgetSize.large].contains(size);
      case WidgetType.weeklyProgress:
        return [WidgetSize.large].contains(size);
      case WidgetType.motivationalQuote:
        return [WidgetSize.small, WidgetSize.medium].contains(size);
      case WidgetType.streakCounter:
        return [WidgetSize.small, WidgetSize.medium].contains(size);
      case WidgetType.statisticsOverview:
        return [WidgetSize.large].contains(size);
      case WidgetType.upcomingReminders:
        return [WidgetSize.medium, WidgetSize.large].contains(size);
      case WidgetType.achievementsBadges:
        return [WidgetSize.medium].contains(size);
    }
  }

  // الحصول على فترة التحديث بالمللي ثانية
  int getRefreshIntervalMs() {
    switch (refreshInterval) {
      case RefreshInterval.minutes1:
        return 60 * 1000;
      case RefreshInterval.minutes5:
        return 5 * 60 * 1000;
      case RefreshInterval.minutes15:
        return 15 * 60 * 1000;
      case RefreshInterval.minutes30:
        return 30 * 60 * 1000;
      case RefreshInterval.hour1:
        return 60 * 60 * 1000;
      case RefreshInterval.manual:
        return -1; // لا يتم التحديث تلقائياً
    }
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'size': size.name,
      'settings': settings,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'priority': priority,
      'habitIds': habitIds,
      'theme': theme.name,
      'displayOptions': displayOptions,
      'refreshInterval': refreshInterval.name,
    };
  }
}

@HiveType(typeId: 74)
enum WidgetType {
  @HiveField(0)
  habitProgress,         // تقدم العادات

  @HiveField(1)
  todayTasks,           // مهام اليوم

  @HiveField(2)
  weeklyProgress,       // التقدم الأسبوعي

  @HiveField(3)
  motivationalQuote,    // اقتباس تحفيزي

  @HiveField(4)
  streakCounter,        // عداد السلاسل

  @HiveField(5)
  statisticsOverview,   // نظرة عامة على الإحصائيات

  @HiveField(6)
  upcomingReminders,    // التذكيرات القادمة

  @HiveField(7)
  achievementsBadges,   // شارات الإنجازات
}

@HiveType(typeId: 75)
enum WidgetSize {
  @HiveField(0)
  small,    // صغير (2x2)

  @HiveField(1)
  medium,   // متوسط (4x2)

  @HiveField(2)
  large,    // كبير (4x4)
}

@HiveType(typeId: 76)
enum WidgetTheme {
  @HiveField(0)
  system,   // حسب النظام

  @HiveField(1)
  light,    // فاتح

  @HiveField(2)
  dark,     // داكن

  @HiveField(3)
  custom,   // مخصص
}

@HiveType(typeId: 77)
enum RefreshInterval {
  @HiveField(0)
  manual,       // يدوي

  @HiveField(1)
  minutes1,     // كل دقيقة

  @HiveField(2)
  minutes5,     // كل 5 دقائق

  @HiveField(3)
  minutes15,    // كل 15 دقيقة

  @HiveField(4)
  minutes30,    // كل 30 دقيقة

  @HiveField(5)
  hour1,        // كل ساعة
}

@HiveType(typeId: 78)
class WidgetData extends HiveObject {

  WidgetData({
    required this.widgetId,
    this.data = const {},
    required this.lastUpdate,
    this.isValid = true,
    this.errorMessage,
  });
  @HiveField(0)
  String widgetId;

  @HiveField(1)
  Map<String, dynamic> data;

  @HiveField(2)
  DateTime lastUpdate;

  @HiveField(3)
  bool isValid;

  @HiveField(4)
  String? errorMessage;

  // تحديث البيانات
  void updateData(Map<String, dynamic> newData) {
    data = newData;
    lastUpdate = DateTime.now();
    isValid = true;
    errorMessage = null;
    save();
  }

  // تسجيل خطأ
  void setError(String error) {
    errorMessage = error;
    isValid = false;
    lastUpdate = DateTime.now();
    save();
  }

  // فحص ما إذا كانت البيانات منتهية الصلاحية
  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(lastUpdate) > maxAge;
  }

  // الحصول على قيمة معينة من البيانات
  T? getValue<T>(String key) {
    return data[key] as T?;
  }

  // تحديد قيمة معينة في البيانات
  void setValue(String key, value) {
    final newData = Map<String, dynamic>.from(data);
    newData[key] = value;
    data = newData;
    lastUpdate = DateTime.now();
    save();
  }
}

@HiveType(typeId: 79)
class WidgetLayout extends HiveObject {

  WidgetLayout({
    required this.id,
    required this.name,
    this.positions = const [],
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<WidgetPosition> positions;

  @HiveField(3)
  bool isDefault;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  // إضافة موقع ودجت
  void addWidgetPosition(WidgetPosition position) {
    final newPositions = List<WidgetPosition>.from(positions);
    newPositions.add(position);
    positions = newPositions;
    updatedAt = DateTime.now();
    save();
  }

  // إزالة موقع ودجت
  void removeWidgetPosition(String widgetId) {
    final newPositions = List<WidgetPosition>.from(positions);
    newPositions.removeWhere((p) => p.widgetId == widgetId);
    positions = newPositions;
    updatedAt = DateTime.now();
    save();
  }

  // تحديث موقع ودجت
  void updateWidgetPosition(String widgetId, int x, int y) {
    final newPositions = List<WidgetPosition>.from(positions);
    final index = newPositions.indexWhere((p) => p.widgetId == widgetId);
    
    if (index != -1) {
      newPositions[index] = newPositions[index].copyWith(x: x, y: y);
      positions = newPositions;
      updatedAt = DateTime.now();
      save();
    }
  }

  // الحصول على موقع ودجت
  WidgetPosition? getWidgetPosition(String widgetId) {
    return positions.cast<WidgetPosition?>().firstWhere(
      (p) => p?.widgetId == widgetId,
      orElse: () => null,
    );
  }
}

@HiveType(typeId: 80)
class WidgetPosition extends HiveObject {

  WidgetPosition({
    required this.widgetId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
  @HiveField(0)
  String widgetId;

  @HiveField(1)
  int x;

  @HiveField(2)
  int y;

  @HiveField(3)
  int width;

  @HiveField(4)
  int height;

  // إنشاء نسخة مع تعديل بعض القيم
  WidgetPosition copyWith({
    String? widgetId,
    int? x,
    int? y,
    int? width,
    int? height,
  }) {
    return WidgetPosition(
      widgetId: widgetId ?? this.widgetId,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  // فحص التداخل مع موقع آخر
  bool overlaps(WidgetPosition other) {
    return !(x + width <= other.x ||
             other.x + other.width <= x ||
             y + height <= other.y ||
             other.y + other.height <= y);
  }

  // فحص ما إذا كان الموقع يحتوي على نقطة معينة
  bool contains(int pointX, int pointY) {
    return pointX >= x && pointX < x + width &&
           pointY >= y && pointY < y + height;
  }
}