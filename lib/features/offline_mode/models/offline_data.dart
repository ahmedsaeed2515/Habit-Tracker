import 'package:hive/hive.dart';

part 'offline_data.g.dart';

@HiveType(typeId: 81)
class OfflineData extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String collection; // اسم المجموعة (habits, completions, etc.)

  @HiveField(2)
  String documentId; // معرف الوثيقة

  @HiveField(3)
  Map<String, dynamic> data; // البيانات الفعلية

  @HiveField(4)
  OfflineAction action; // نوع العملية

  @HiveField(5)
  DateTime timestamp; // وقت إنشاء العملية

  @HiveField(6)
  OfflineStatus status; // حالة العملية

  @HiveField(7)
  int retryCount; // عدد محاولات المزامنة

  @HiveField(8)
  String? errorMessage; // رسالة الخطأ إن وجدت

  @HiveField(9)
  Map<String, dynamic> metadata; // بيانات إضافية

  OfflineData({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.data,
    required this.action,
    required this.timestamp,
    this.status = OfflineStatus.pending,
    this.retryCount = 0,
    this.errorMessage,
    this.metadata = const {},
  });

  // تحديث حالة العملية
  void updateStatus(OfflineStatus newStatus, {String? error}) {
    status = newStatus;
    if (error != null) {
      errorMessage = error;
    }
    save();
  }

  // زيادة عدد المحاولات
  void incrementRetryCount() {
    retryCount++;
    save();
  }

  // فحص ما إذا كانت العملية قابلة للإعادة
  bool get canRetry => retryCount < 3 && status == OfflineStatus.failed;

  // فحص ما إذا كانت العملية منتهية الصلاحية
  bool get isExpired {
    final maxAge = const Duration(days: 7);
    return DateTime.now().difference(timestamp) > maxAge;
  }

  // الحصول على أولوية العملية
  int get priority {
    switch (action) {
      case OfflineAction.create:
        return 1;
      case OfflineAction.update:
        return 2;
      case OfflineAction.delete:
        return 3;
    }
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collection': collection,
      'documentId': documentId,
      'data': data,
      'action': action.name,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'retryCount': retryCount,
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }

  // إنشاء من خريطة
  factory OfflineData.fromMap(Map<String, dynamic> map) {
    return OfflineData(
      id: map['id'],
      collection: map['collection'],
      documentId: map['documentId'],
      data: Map<String, dynamic>.from(map['data']),
      action: OfflineAction.values.firstWhere((a) => a.name == map['action']),
      timestamp: DateTime.parse(map['timestamp']),
      status: OfflineStatus.values.firstWhere((s) => s.name == map['status']),
      retryCount: map['retryCount'] ?? 0,
      errorMessage: map['errorMessage'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }
}

@HiveType(typeId: 82)
enum OfflineAction {
  @HiveField(0)
  create, // إنشاء

  @HiveField(1)
  update, // تحديث

  @HiveField(2)
  delete, // حذف
}

@HiveType(typeId: 83)
enum OfflineStatus {
  @HiveField(0)
  pending, // في الانتظار

  @HiveField(1)
  syncing, // قيد المزامنة

  @HiveField(2)
  synced, // تمت المزامنة

  @HiveField(3)
  failed, // فشلت

  @HiveField(4)
  conflict, // تعارض
}

@HiveType(typeId: 84)
class OfflineCache extends HiveObject {
  @HiveField(0)
  String key;

  @HiveField(1)
  Map<String, dynamic> data;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  Duration validFor; // مدة صلاحية البيانات

  @HiveField(4)
  int accessCount; // عدد مرات الوصول

  @HiveField(5)
  DateTime lastAccessed;

  @HiveField(6)
  Map<String, dynamic> tags; // وسوم للتصنيف

  OfflineCache({
    required this.key,
    required this.data,
    required this.cachedAt,
    this.validFor = const Duration(hours: 1),
    this.accessCount = 0,
    required this.lastAccessed,
    this.tags = const {},
  });

  // فحص صلاحية البيانات
  bool get isValid {
    return DateTime.now().difference(cachedAt) <= validFor;
  }

  // فحص انتهاء الصلاحية
  bool get isExpired => !isValid;

  // تسجيل وصول جديد
  void recordAccess() {
    accessCount++;
    lastAccessed = DateTime.now();
    save();
  }

  // تحديث البيانات
  void updateData(Map<String, dynamic> newData) {
    data = newData;
    cachedAt = DateTime.now();
    recordAccess();
  }

  // إضافة وسم
  void addTag(String key, dynamic value) {
    final newTags = Map<String, dynamic>.from(tags);
    newTags[key] = value;
    tags = newTags;
    save();
  }

  // إزالة وسم
  void removeTag(String key) {
    final newTags = Map<String, dynamic>.from(tags);
    newTags.remove(key);
    tags = newTags;
    save();
  }

  // الحصول على حجم البيانات المقدر
  int get estimatedSize {
    return data.toString().length * 2; // تقدير تقريبي
  }
}

@HiveType(typeId: 85)
class SyncSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime? endTime;

  @HiveField(3)
  SyncStatus status;

  @HiveField(4)
  int totalOperations;

  @HiveField(5)
  int successfulOperations;

  @HiveField(6)
  int failedOperations;

  @HiveField(7)
  List<String> errors;

  @HiveField(8)
  Map<String, dynamic> statistics;

  @HiveField(9)
  SyncTrigger trigger; // ما الذي تسبب في المزامنة

  SyncSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.status = SyncStatus.running,
    this.totalOperations = 0,
    this.successfulOperations = 0,
    this.failedOperations = 0,
    this.errors = const [],
    this.statistics = const {},
    this.trigger = SyncTrigger.manual,
  });

  // إنهاء جلسة المزامنة
  void complete(SyncStatus finalStatus) {
    endTime = DateTime.now();
    status = finalStatus;
    save();
  }

  // إضافة عملية ناجحة
  void addSuccess() {
    successfulOperations++;
    save();
  }

  // إضافة عملية فاشلة
  void addFailure(String error) {
    failedOperations++;
    final newErrors = List<String>.from(errors);
    newErrors.add(error);
    errors = newErrors;
    save();
  }

  // الحصول على مدة المزامنة
  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }

  // الحصول على معدل النجاح
  double get successRate {
    if (totalOperations == 0) return 0.0;
    return successfulOperations / totalOperations;
  }

  // فحص ما إذا كانت المزامنة قيد التشغيل
  bool get isRunning => status == SyncStatus.running;

  // فحص ما إذا كانت المزامنة مكتملة
  bool get isCompleted => status == SyncStatus.completed;

  // فحص ما إذا كانت المزامنة فشلت
  bool get isFailed => status == SyncStatus.failed;
}

@HiveType(typeId: 86)
enum SyncStatus {
  @HiveField(0)
  running, // قيد التشغيل

  @HiveField(1)
  completed, // مكتملة

  @HiveField(2)
  failed, // فشلت

  @HiveField(3)
  cancelled, // ألغيت
}

@HiveType(typeId: 87)
enum SyncTrigger {
  @HiveField(0)
  manual, // يدوي

  @HiveField(1)
  automatic, // تلقائي

  @HiveField(2)
  network, // عند توفر الشبكة

  @HiveField(3)
  scheduled, // مجدول

  @HiveField(4)
  appStart, // عند بدء التطبيق

  @HiveField(5)
  appClose, // عند إغلاق التطبيق
}

@HiveType(typeId: 88)
class NetworkStatus extends HiveObject {
  @HiveField(0)
  bool isConnected;

  @HiveField(1)
  ConnectionType connectionType;

  @HiveField(2)
  DateTime lastChecked;

  @HiveField(3)
  int signalStrength; // قوة الإشارة (0-100)

  @HiveField(4)
  bool isMetered; // ما إذا كانت الشبكة محدودة البيانات

  @HiveField(5)
  Map<String, dynamic> additionalInfo;

  NetworkStatus({
    this.isConnected = false,
    this.connectionType = ConnectionType.none,
    required this.lastChecked,
    this.signalStrength = 0,
    this.isMetered = false,
    this.additionalInfo = const {},
  });

  // تحديث حالة الشبكة
  void updateStatus({
    bool? connected,
    ConnectionType? type,
    int? strength,
    bool? metered,
  }) {
    if (connected != null) isConnected = connected;
    if (type != null) connectionType = type;
    if (strength != null) signalStrength = strength;
    if (metered != null) isMetered = metered;
    lastChecked = DateTime.now();
    save();
  }

  // فحص ما إذا كانت الشبكة جيدة للمزامنة
  bool get isSuitableForSync {
    return isConnected &&
        signalStrength > 20 &&
        (connectionType == ConnectionType.wifi || !isMetered);
  }

  // فحص ما إذا كانت حالة الشبكة قديمة
  bool get isStale {
    return DateTime.now().difference(lastChecked) > const Duration(minutes: 1);
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'isConnected': isConnected,
      'connectionType': connectionType.name,
      'lastChecked': lastChecked.toIso8601String(),
      'signalStrength': signalStrength,
      'isMetered': isMetered,
      'additionalInfo': additionalInfo,
    };
  }
}

@HiveType(typeId: 89)
enum ConnectionType {
  @HiveField(0)
  none, // لا توجد شبكة

  @HiveField(1)
  wifi, // WiFi

  @HiveField(2)
  mobile, // بيانات الهاتف

  @HiveField(3)
  ethernet, // إيثرنت

  @HiveField(4)
  other, // أخرى
}

@HiveType(typeId: 90)
class ConflictResolution extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String collection;

  @HiveField(2)
  String documentId;

  @HiveField(3)
  Map<String, dynamic> localData; // البيانات المحلية

  @HiveField(4)
  Map<String, dynamic> remoteData; // البيانات البعيدة

  @HiveField(5)
  Map<String, dynamic>? resolvedData; // البيانات المحلولة

  @HiveField(6)
  ConflictResolutionStrategy strategy; // استراتيجية الحل

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? resolvedAt;

  @HiveField(9)
  bool isResolved;

  @HiveField(10)
  String? resolutionNote; // ملاحظة الحل

  ConflictResolution({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.localData,
    required this.remoteData,
    this.resolvedData,
    this.strategy = ConflictResolutionStrategy.manual,
    required this.createdAt,
    this.resolvedAt,
    this.isResolved = false,
    this.resolutionNote,
  });

  // حل التعارض
  void resolve(Map<String, dynamic> resolution, {String? note}) {
    resolvedData = resolution;
    resolvedAt = DateTime.now();
    isResolved = true;
    resolutionNote = note;
    save();
  }

  // تطبيق استراتيجية الحل التلقائي
  Map<String, dynamic>? applyAutoResolution() {
    switch (strategy) {
      case ConflictResolutionStrategy.localWins:
        return localData;
      case ConflictResolutionStrategy.remoteWins:
        return remoteData;
      case ConflictResolutionStrategy.mostRecent:
        final localTimestamp = localData['updatedAt'] as String?;
        final remoteTimestamp = remoteData['updatedAt'] as String?;

        if (localTimestamp != null && remoteTimestamp != null) {
          final localTime = DateTime.parse(localTimestamp);
          final remoteTime = DateTime.parse(remoteTimestamp);
          return localTime.isAfter(remoteTime) ? localData : remoteData;
        }
        return localData;
      case ConflictResolutionStrategy.merge:
        return _mergeData();
      case ConflictResolutionStrategy.manual:
        return null; // يتطلب تدخل المستخدم
    }
  }

  // دمج البيانات
  Map<String, dynamic> _mergeData() {
    final merged = Map<String, dynamic>.from(localData);

    remoteData.forEach((key, value) {
      if (!merged.containsKey(key) || merged[key] == null) {
        merged[key] = value;
      }
    });

    return merged;
  }

  // الحصول على الاختلافات
  Map<String, dynamic> getDifferences() {
    final differences = <String, dynamic>{};

    final allKeys = {...localData.keys, ...remoteData.keys};

    for (final key in allKeys) {
      final localValue = localData[key];
      final remoteValue = remoteData[key];

      if (localValue != remoteValue) {
        differences[key] = {'local': localValue, 'remote': remoteValue};
      }
    }

    return differences;
  }
}

@HiveType(typeId: 91)
enum ConflictResolutionStrategy {
  @HiveField(0)
  localWins, // المحلي يفوز

  @HiveField(1)
  remoteWins, // البعيد يفوز

  @HiveField(2)
  mostRecent, // الأحدث يفوز

  @HiveField(3)
  merge, // دمج

  @HiveField(4)
  manual, // يدوي
}
