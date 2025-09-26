import 'package:hive/hive.dart';

part 'backup_data.g.dart';

@HiveType(typeId: 49)
class BackupData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String version;

  @HiveField(4)
  Map<String, dynamic> habitsData;

  @HiveField(5)
  Map<String, dynamic> analyticsData;

  @HiveField(6)
  Map<String, dynamic> settingsData;

  @HiveField(7)
  Map<String, dynamic> gamificationData;

  @HiveField(8)
  Map<String, dynamic> healthData;

  @HiveField(9)
  Map<String, dynamic> themingData;

  @HiveField(10)
  int dataSize;

  @HiveField(11)
  BackupType type;

  @HiveField(12)
  BackupStatus status;

  @HiveField(13)
  String? cloudPath;

  @HiveField(14)
  String? errorMessage;

  @HiveField(15)
  DateTime? lastSync;

  BackupData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.version,
    this.habitsData = const {},
    this.analyticsData = const {},
    this.settingsData = const {},
    this.gamificationData = const {},
    this.healthData = const {},
    this.themingData = const {},
    this.dataSize = 0,
    this.type = BackupType.manual,
    this.status = BackupStatus.pending,
    this.cloudPath,
    this.errorMessage,
    this.lastSync,
  });

  // الحصول على حجم البيانات بصيغة مقروءة
  String get formattedSize {
    if (dataSize < 1024) {
      return '$dataSize B';
    } else if (dataSize < 1024 * 1024) {
      return '${(dataSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(dataSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // فحص ما إذا كانت البيانات محدثة
  bool get isUpToDate {
    if (lastSync == null) return false;
    final daysSinceSync = DateTime.now().difference(lastSync!).inDays;
    return daysSinceSync < 7; // اعتبار البيانات محدثة لمدة أسبوع
  }

  // تحديث حالة النسخ الاحتياطي
  void updateStatus(BackupStatus newStatus, {String? error}) {
    status = newStatus;
    if (error != null) {
      errorMessage = error;
    }
    if (newStatus == BackupStatus.completed) {
      lastSync = DateTime.now();
      errorMessage = null;
    }
    save();
  }

  // دمج البيانات الجديدة
  void mergeData({
    Map<String, dynamic>? habits,
    Map<String, dynamic>? analytics,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? gamification,
    Map<String, dynamic>? health,
    Map<String, dynamic>? theming,
  }) {
    if (habits != null) {
      final newHabitsData = Map<String, dynamic>.from(habitsData);
      newHabitsData.addAll(habits);
      habitsData = newHabitsData;
    }
    
    if (analytics != null) {
      final newAnalyticsData = Map<String, dynamic>.from(analyticsData);
      newAnalyticsData.addAll(analytics);
      analyticsData = newAnalyticsData;
    }
    
    if (settings != null) {
      final newSettingsData = Map<String, dynamic>.from(settingsData);
      newSettingsData.addAll(settings);
      settingsData = newSettingsData;
    }
    
    if (gamification != null) {
      final newGamificationData = Map<String, dynamic>.from(gamificationData);
      newGamificationData.addAll(gamification);
      gamificationData = newGamificationData;
    }
    
    if (health != null) {
      final newHealthData = Map<String, dynamic>.from(healthData);
      newHealthData.addAll(health);
      healthData = newHealthData;
    }
    
    if (theming != null) {
      final newThemingData = Map<String, dynamic>.from(themingData);
      newThemingData.addAll(theming);
      themingData = newThemingData;
    }
    
    _calculateDataSize();
    save();
  }

  // حساب حجم البيانات
  void _calculateDataSize() {
    final allData = {
      'habits': habitsData,
      'analytics': analyticsData,
      'settings': settingsData,
      'gamification': gamificationData,
      'health': healthData,
      'theming': themingData,
    };
    
    final jsonString = allData.toString();
    dataSize = jsonString.length;
  }

  // تحويل إلى خريطة للتصدير
  Map<String, dynamic> toExportMap() {
    return {
      'metadata': {
        'id': id,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'version': version,
        'dataSize': dataSize,
      },
      'habits': habitsData,
      'analytics': analyticsData,
      'settings': settingsData,
      'gamification': gamificationData,
      'health': healthData,
      'theming': themingData,
    };
  }

  // إنشاء من خريطة مستوردة
  factory BackupData.fromImportMap(Map<String, dynamic> map) {
    final metadata = map['metadata'] ?? {};
    
    return BackupData(
      id: metadata['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: metadata['userId'] ?? 'imported',
      createdAt: metadata['createdAt'] != null 
          ? DateTime.parse(metadata['createdAt']) 
          : DateTime.now(),
      version: metadata['version'] ?? '1.0.0',
      habitsData: Map<String, dynamic>.from(map['habits'] ?? {}),
      analyticsData: Map<String, dynamic>.from(map['analytics'] ?? {}),
      settingsData: Map<String, dynamic>.from(map['settings'] ?? {}),
      gamificationData: Map<String, dynamic>.from(map['gamification'] ?? {}),
      healthData: Map<String, dynamic>.from(map['health'] ?? {}),
      themingData: Map<String, dynamic>.from(map['theming'] ?? {}),
      dataSize: metadata['dataSize'] ?? 0,
      type: BackupType.imported,
      status: BackupStatus.completed,
    );
  }
}

@HiveType(typeId: 50)
enum BackupType {
  @HiveField(0)
  manual,     // يدوي

  @HiveField(1)
  automatic,  // تلقائي

  @HiveField(2)
  scheduled,  // مجدول

  @HiveField(3)
  imported,   // مستورد
}

@HiveType(typeId: 51)
enum BackupStatus {
  @HiveField(0)
  pending,    // في الانتظار

  @HiveField(1)
  inProgress, // قيد التنفيذ

  @HiveField(2)
  completed,  // مكتمل

  @HiveField(3)
  failed,     // فشل

  @HiveField(4)
  cancelled,  // ملغي
}

@HiveType(typeId: 52)
class SyncSettings extends HiveObject {
  @HiveField(0)
  bool enableAutoSync;

  @HiveField(1)
  int syncIntervalHours;

  @HiveField(2)
  bool syncOnWiFiOnly;

  @HiveField(3)
  bool syncHabits;

  @HiveField(4)
  bool syncAnalytics;

  @HiveField(5)
  bool syncSettings;

  @HiveField(6)
  bool syncGamification;

  @HiveField(7)
  bool syncHealth;

  @HiveField(8)
  bool syncTheming;

  @HiveField(9)
  DateTime lastAutoSync;

  @HiveField(10)
  String cloudProvider; // 'google_drive', 'icloud', 'dropbox'

  @HiveField(11)
  int maxBackups;

  @HiveField(12)
  bool deleteOldBackups;

  SyncSettings({
    this.enableAutoSync = true,
    this.syncIntervalHours = 24,
    this.syncOnWiFiOnly = true,
    this.syncHabits = true,
    this.syncAnalytics = true,
    this.syncSettings = true,
    this.syncGamification = true,
    this.syncHealth = false,
    this.syncTheming = true,
    required this.lastAutoSync,
    this.cloudProvider = 'google_drive',
    this.maxBackups = 10,
    this.deleteOldBackups = true,
  });

  // فحص ما إذا كان وقت المزامنة التلقائية
  bool get isTimeForAutoSync {
    if (!enableAutoSync) return false;
    
    final hoursSinceLastSync = DateTime.now().difference(lastAutoSync).inHours;
    return hoursSinceLastSync >= syncIntervalHours;
  }

  // تحديث وقت آخر مزامنة
  void updateLastAutoSync() {
    lastAutoSync = DateTime.now();
    save();
  }

  // الحصول على قائمة البيانات للمزامنة
  List<String> get dataTypesToSync {
    final types = <String>[];
    if (syncHabits) types.add('habits');
    if (syncAnalytics) types.add('analytics');
    if (syncSettings) types.add('settings');
    if (syncGamification) types.add('gamification');
    if (syncHealth) types.add('health');
    if (syncTheming) types.add('theming');
    return types;
  }
}

@HiveType(typeId: 53)
class ConflictResolution extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String dataType;

  @HiveField(2)
  Map<String, dynamic> localData;

  @HiveField(3)
  Map<String, dynamic> remoteData;

  @HiveField(4)
  DateTime conflictTime;

  @HiveField(5)
  ResolutionStrategy? resolution;

  @HiveField(6)
  bool isResolved;

  ConflictResolution({
    required this.id,
    required this.dataType,
    required this.localData,
    required this.remoteData,
    required this.conflictTime,
    this.resolution,
    this.isResolved = false,
  });

  // تطبيق الحل
  Map<String, dynamic> applyResolution() {
    switch (resolution) {
      case ResolutionStrategy.useLocal:
        return localData;
      case ResolutionStrategy.useRemote:
        return remoteData;
      case ResolutionStrategy.merge:
        return _mergeData();
      case ResolutionStrategy.useLatest:
        return _useLatestData();
      default:
        return localData;
    }
  }

  // دمج البيانات
  Map<String, dynamic> _mergeData() {
    final merged = Map<String, dynamic>.from(localData);
    
    for (final entry in remoteData.entries) {
      if (!merged.containsKey(entry.key)) {
        merged[entry.key] = entry.value;
      } else if (entry.value is Map && merged[entry.key] is Map) {
        // دمج العمق العميق للخرائط
        final localMap = Map<String, dynamic>.from(merged[entry.key]);
        final remoteMap = Map<String, dynamic>.from(entry.value);
        localMap.addAll(remoteMap);
        merged[entry.key] = localMap;
      }
    }
    
    return merged;
  }

  // استخدام البيانات الأحدث
  Map<String, dynamic> _useLatestData() {
    final localTime = localData['lastModified'] as String?;
    final remoteTime = remoteData['lastModified'] as String?;
    
    if (localTime != null && remoteTime != null) {
      final localDateTime = DateTime.parse(localTime);
      final remoteDateTime = DateTime.parse(remoteTime);
      
      return localDateTime.isAfter(remoteDateTime) ? localData : remoteData;
    }
    
    return remoteData;
  }
}

@HiveType(typeId: 54)
enum ResolutionStrategy {
  @HiveField(0)
  useLocal,   // استخدام البيانات المحلية

  @HiveField(1)
  useRemote,  // استخدام البيانات البعيدة

  @HiveField(2)
  merge,      // دمج البيانات

  @HiveField(3)
  useLatest,  // استخدام الأحدث
}