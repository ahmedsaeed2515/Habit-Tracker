import 'package:hive/hive.dart';

part 'performance_metrics.g.dart';

@HiveType(typeId: 105)
class PerformanceMetrics extends HiveObject {

  PerformanceMetrics({
    required this.id,
    required this.timestamp,
    required this.appPerformance,
    required this.databasePerformance,
    required this.memoryUsage,
    required this.networkPerformance,
    required this.uiPerformance,
    this.customMetrics = const {},
    required this.deviceInfo,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime timestamp;

  @HiveField(2)
  AppPerformanceData appPerformance;

  @HiveField(3)
  DatabasePerformanceData databasePerformance;

  @HiveField(4)
  MemoryUsageData memoryUsage;

  @HiveField(5)
  NetworkPerformanceData networkPerformance;

  @HiveField(6)
  UIPerformanceData uiPerformance;

  @HiveField(7)
  Map<String, dynamic> customMetrics;

  @HiveField(8)
  DeviceInfo deviceInfo;

  // الحصول على النقاط الإجمالية للأداء
  double get overallPerformanceScore {
    final scores = [
      appPerformance.performanceScore,
      databasePerformance.performanceScore,
      memoryUsage.performanceScore,
      networkPerformance.performanceScore,
      uiPerformance.performanceScore,
    ];
    
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  // فحص ما إذا كان الأداء جيد
  bool get isPerformanceGood => overallPerformanceScore >= 80.0;

  // الحصول على مستوى الأداء
  PerformanceLevel get performanceLevel {
    final score = overallPerformanceScore;
    if (score >= 90) return PerformanceLevel.excellent;
    if (score >= 80) return PerformanceLevel.good;
    if (score >= 60) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  // الحصول على المشاكل المكتشفة
  List<PerformanceIssue> getDetectedIssues() {
    final issues = <PerformanceIssue>[];
    
    // فحص أداء التطبيق
    if (appPerformance.startupTime > 3000) {
      issues.add(PerformanceIssue(
        type: IssueType.slowStartup,
        severity: IssueSeverity.high,
        description: 'وقت بدء التطبيق بطيء (${appPerformance.startupTime}ms)',
        suggestion: 'قم بتحسين عملية التحميل الأولي',
      ));
    }
    
    // فحص أداء قاعدة البيانات
    if (databasePerformance.averageQueryTime > 100) {
      issues.add(PerformanceIssue(
        type: IssueType.slowDatabase,
        severity: IssueSeverity.medium,
        description: 'استعلامات قاعدة البيانات بطيئة (${databasePerformance.averageQueryTime}ms)',
        suggestion: 'فكر في إضافة فهارس أو تحسين الاستعلامات',
      ));
    }
    
    // فحص استخدام الذاكرة
    if (memoryUsage.memoryUsagePercentage > 80) {
      issues.add(PerformanceIssue(
        type: IssueType.highMemoryUsage,
        severity: IssueSeverity.high,
        description: 'استخدام الذاكرة مرتفع (${memoryUsage.memoryUsagePercentage}%)',
        suggestion: 'قم بتحسين إدارة الذاكرة وإزالة التسريبات',
      ));
    }
    
    // فحص أداء الواجهة
    if (uiPerformance.averageFrameTime > 16.67) {
      issues.add(PerformanceIssue(
        type: IssueType.uiLag,
        severity: IssueSeverity.medium,
        description: 'تأخر في الواجهة (${uiPerformance.averageFrameTime}ms)',
        suggestion: 'قم بتحسين الرسوم المتحركة والتخطيطات',
      ));
    }
    
    return issues;
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'appPerformance': appPerformance.toMap(),
      'databasePerformance': databasePerformance.toMap(),
      'memoryUsage': memoryUsage.toMap(),
      'networkPerformance': networkPerformance.toMap(),
      'uiPerformance': uiPerformance.toMap(),
      'customMetrics': customMetrics,
      'deviceInfo': deviceInfo.toMap(),
      'overallScore': overallPerformanceScore,
      'performanceLevel': performanceLevel.name,
    };
  }
}

@HiveType(typeId: 106)
class AppPerformanceData extends HiveObject { // إجمالي وقت الجلسة

  AppPerformanceData({
    this.startupTime = 0,
    this.cpuUsage = 0.0,
    this.batteryUsage = 0,
    this.crashCount = 0,
    this.featureUsageTimes = const {},
    this.totalSessionTime = 0,
  });
  @HiveField(0)
  int startupTime; // مللي ثانية

  @HiveField(1)
  double cpuUsage; // نسبة مئوية

  @HiveField(2)
  int batteryUsage; // mAh

  @HiveField(3)
  int crashCount; // عدد التعطلات

  @HiveField(4)
  Map<String, int> featureUsageTimes; // وقت استخدام كل ميزة

  @HiveField(5)
  int totalSessionTime;

  // حساب نقاط الأداء
  double get performanceScore {
    double score = 100.0;
    
    // خصم نقاط لوقت البدء البطيء
    if (startupTime > 2000) {
      score -= 20;
    } else if (startupTime > 1000) score -= 10;
    
    // خصم نقاط لاستخدام المعالج المرتفع
    if (cpuUsage > 80) {
      score -= 25;
    } else if (cpuUsage > 50) score -= 15;
    
    // خصم نقاط للتعطلات
    score -= (crashCount * 10).clamp(0, 30);
    
    return score.clamp(0, 100);
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'startupTime': startupTime,
      'cpuUsage': cpuUsage,
      'batteryUsage': batteryUsage,
      'crashCount': crashCount,
      'featureUsageTimes': featureUsageTimes,
      'totalSessionTime': totalSessionTime,
      'performanceScore': performanceScore,
    };
  }
}

@HiveType(typeId: 107)
class DatabasePerformanceData extends HiveObject { // حجم قاعدة البيانات بالبايت

  DatabasePerformanceData({
    this.averageQueryTime = 0.0,
    this.totalQueries = 0,
    this.slowQueries = 0,
    this.failedQueries = 0,
    this.queryMetrics = const {},
    this.databaseSize = 0,
  });
  @HiveField(0)
  double averageQueryTime; // مللي ثانية

  @HiveField(1)
  int totalQueries; // إجمالي عدد الاستعلامات

  @HiveField(2)
  int slowQueries; // الاستعلامات البطيئة (> 100ms)

  @HiveField(3)
  int failedQueries; // الاستعلامات الفاشلة

  @HiveField(4)
  Map<String, QueryMetrics> queryMetrics; // مقاييس كل استعلام

  @HiveField(5)
  int databaseSize;

  // حساب نقاط الأداء
  double get performanceScore {
    double score = 100.0;
    
    // خصم نقاط للاستعلامات البطيئة
    if (averageQueryTime > 100) {
      score -= 30;
    } else if (averageQueryTime > 50) score -= 15;
    
    // خصم نقاط للاستعلامات الفاشلة
    final failureRate = totalQueries > 0 ? (failedQueries / totalQueries) * 100 : 0;
    score -= failureRate * 2;
    
    // خصم نقاط لنسبة الاستعلامات البطيئة
    final slowRate = totalQueries > 0 ? (slowQueries / totalQueries) * 100 : 0;
    score -= slowRate;
    
    return score.clamp(0, 100);
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'averageQueryTime': averageQueryTime,
      'totalQueries': totalQueries,
      'slowQueries': slowQueries,
      'failedQueries': failedQueries,
      'queryMetrics': queryMetrics.map((k, v) => MapEntry(k, v.toMap())),
      'databaseSize': databaseSize,
      'performanceScore': performanceScore,
    };
  }
}

@HiveType(typeId: 108)
class QueryMetrics extends HiveObject {

  QueryMetrics({
    required this.queryType,
    this.averageTime = 0.0,
    this.executionCount = 0,
    this.minTime = double.infinity,
    this.maxTime = 0.0,
  });
  @HiveField(0)
  String queryType;

  @HiveField(1)
  double averageTime;

  @HiveField(2)
  int executionCount;

  @HiveField(3)
  double minTime;

  @HiveField(4)
  double maxTime;

  // تحديث المقاييس
  void updateMetrics(double executionTime) {
    final newTotal = (averageTime * executionCount) + executionTime;
    executionCount++;
    averageTime = newTotal / executionCount;
    
    if (executionTime < minTime) minTime = executionTime;
    if (executionTime > maxTime) maxTime = executionTime;
    
    save();
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'queryType': queryType,
      'averageTime': averageTime,
      'executionCount': executionCount,
      'minTime': minTime,
      'maxTime': maxTime,
    };
  }
}

@HiveType(typeId: 109)
class MemoryUsageData extends HiveObject { // استخدام الذاكرة لكل ميزة

  MemoryUsageData({
    this.usedMemory = 0,
    this.totalMemory = 0,
    this.memoryUsagePercentage = 0.0,
    this.snapshots = const [],
    this.memoryLeaks = 0,
    this.memoryByFeature = const {},
  });
  @HiveField(0)
  int usedMemory; // MB

  @HiveField(1)
  int totalMemory; // MB

  @HiveField(2)
  double memoryUsagePercentage;

  @HiveField(3)
  List<MemorySnapshot> snapshots;

  @HiveField(4)
  int memoryLeaks; // عدد تسريبات الذاكرة المكتشفة

  @HiveField(5)
  Map<String, int> memoryByFeature;

  // حساب نقاط الأداء
  double get performanceScore {
    double score = 100.0;
    
    // خصم نقاط لاستخدام الذاكرة المرتفع
    if (memoryUsagePercentage > 90) {
      score -= 40;
    } else if (memoryUsagePercentage > 80) score -= 25;
    else if (memoryUsagePercentage > 70) score -= 15;
    
    // خصم نقاط لتسريبات الذاكرة
    score -= (memoryLeaks * 5).clamp(0, 30);
    
    return score.clamp(0, 100);
  }

  // إضافة لقطة ذاكرة
  void addSnapshot(MemorySnapshot snapshot) {
    final newSnapshots = List<MemorySnapshot>.from(snapshots);
    newSnapshots.add(snapshot);
    
    // الحفاظ على آخر 50 لقطة فقط
    if (newSnapshots.length > 50) {
      newSnapshots.removeAt(0);
    }
    
    snapshots = newSnapshots;
    save();
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'usedMemory': usedMemory,
      'totalMemory': totalMemory,
      'memoryUsagePercentage': memoryUsagePercentage,
      'snapshots': snapshots.map((s) => s.toMap()).toList(),
      'memoryLeaks': memoryLeaks,
      'memoryByFeature': memoryByFeature,
      'performanceScore': performanceScore,
    };
  }
}

@HiveType(typeId: 110)
class MemorySnapshot extends HiveObject { // السياق الذي أخذت فيه اللقطة

  MemorySnapshot({
    required this.timestamp,
    required this.usedMemory,
    required this.context,
  });
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  int usedMemory;

  @HiveField(2)
  String context;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'usedMemory': usedMemory,
      'context': context,
    };
  }
}

@HiveType(typeId: 111)
class NetworkPerformanceData extends HiveObject {

  NetworkPerformanceData({
    this.averageResponseTime = 0.0,
    this.successfulRequests = 0,
    this.failedRequests = 0,
    this.totalDataTransferred = 0,
    this.endpointMetrics = const {},
    this.connectionType = ConnectionType.none,
  });
  @HiveField(0)
  double averageResponseTime; // مللي ثانية

  @HiveField(1)
  int successfulRequests;

  @HiveField(2)
  int failedRequests;

  @HiveField(3)
  int totalDataTransferred; // بايت

  @HiveField(4)
  Map<String, EndpointMetrics> endpointMetrics;

  @HiveField(5)
  ConnectionType connectionType;

  // حساب نقاط الأداء
  double get performanceScore {
    double score = 100.0;
    
    // خصم نقاط لوقت الاستجابة البطيء
    if (averageResponseTime > 2000) {
      score -= 30;
    } else if (averageResponseTime > 1000) score -= 20;
    else if (averageResponseTime > 500) score -= 10;
    
    // خصم نقاط للطلبات الفاشلة
    final totalRequests = successfulRequests + failedRequests;
    if (totalRequests > 0) {
      final failureRate = (failedRequests / totalRequests) * 100;
      score -= failureRate * 2;
    }
    
    return score.clamp(0, 100);
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'averageResponseTime': averageResponseTime,
      'successfulRequests': successfulRequests,
      'failedRequests': failedRequests,
      'totalDataTransferred': totalDataTransferred,
      'endpointMetrics': endpointMetrics.map((k, v) => MapEntry(k, v.toMap())),
      'connectionType': connectionType.name,
      'performanceScore': performanceScore,
    };
  }
}

@HiveType(typeId: 112)
class EndpointMetrics extends HiveObject {

  EndpointMetrics({
    required this.endpoint,
    this.averageResponseTime = 0.0,
    this.requestCount = 0,
    this.errorCount = 0,
  });
  @HiveField(0)
  String endpoint;

  @HiveField(1)
  double averageResponseTime;

  @HiveField(2)
  int requestCount;

  @HiveField(3)
  int errorCount;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'endpoint': endpoint,
      'averageResponseTime': averageResponseTime,
      'requestCount': requestCount,
      'errorCount': errorCount,
    };
  }
}

@HiveType(typeId: 113)
class UIPerformanceData extends HiveObject { // تأخر الرسوم المتحركة

  UIPerformanceData({
    this.averageFrameTime = 0.0,
    this.droppedFrames = 0,
    this.scrollPerformance = 0.0,
    this.screenMetrics = const {},
    this.animationLags = 0,
  });
  @HiveField(0)
  double averageFrameTime; // مللي ثانية

  @HiveField(1)
  int droppedFrames; // الإطارات المفقودة

  @HiveField(2)
  double scrollPerformance; // أداء التمرير

  @HiveField(3)
  Map<String, ScreenMetrics> screenMetrics;

  @HiveField(4)
  int animationLags;

  // حساب نقاط الأداء
  double get performanceScore {
    double score = 100.0;
    
    // خصم نقاط لوقت الإطار الطويل (المثالي 16.67ms للـ60 FPS)
    if (averageFrameTime > 33.33) {
      score -= 40; // أقل من 30 FPS
    } else if (averageFrameTime > 16.67) score -= 20; // أقل من 60 FPS
    
    // خصم نقاط للإطارات المفقودة
    if (droppedFrames > 100) {
      score -= 30;
    } else if (droppedFrames > 50) score -= 20;
    else if (droppedFrames > 20) score -= 10;
    
    // خصم نقاط لتأخر الرسوم المتحركة
    score -= (animationLags * 2).clamp(0, 20);
    
    return score.clamp(0, 100);
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'averageFrameTime': averageFrameTime,
      'droppedFrames': droppedFrames,
      'scrollPerformance': scrollPerformance,
      'screenMetrics': screenMetrics.map((k, v) => MapEntry(k, v.toMap())),
      'animationLags': animationLags,
      'performanceScore': performanceScore,
    };
  }
}

@HiveType(typeId: 114)
class ScreenMetrics extends HiveObject { // عدد التفاعلات

  ScreenMetrics({
    required this.screenName,
    this.loadTime = 0.0,
    this.renderTime = 0,
    this.interactionCount = 0,
  });
  @HiveField(0)
  String screenName;

  @HiveField(1)
  double loadTime; // وقت التحميل

  @HiveField(2)
  int renderTime; // وقت الرسم

  @HiveField(3)
  int interactionCount;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'screenName': screenName,
      'loadTime': loadTime,
      'renderTime': renderTime,
      'interactionCount': interactionCount,
    };
  }
}

@HiveType(typeId: 115)
class DeviceInfo extends HiveObject {

  DeviceInfo({
    required this.deviceModel,
    required this.osVersion,
    this.ramSize = 0,
    this.storageSize = 0,
    required this.cpuType,
    this.screenDensity = 0.0,
    required this.screenResolution,
  });
  @HiveField(0)
  String deviceModel;

  @HiveField(1)
  String osVersion;

  @HiveField(2)
  int ramSize; // MB

  @HiveField(3)
  int storageSize; // MB

  @HiveField(4)
  String cpuType;

  @HiveField(5)
  double screenDensity;

  @HiveField(6)
  String screenResolution;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'ramSize': ramSize,
      'storageSize': storageSize,
      'cpuType': cpuType,
      'screenDensity': screenDensity,
      'screenResolution': screenResolution,
    };
  }
}

@HiveType(typeId: 116)
enum PerformanceLevel {
  @HiveField(0)
  excellent, // ممتاز (90-100%)

  @HiveField(1)
  good, // جيد (80-89%)

  @HiveField(2)
  fair, // مقبول (60-79%)

  @HiveField(3)
  poor, // ضعيف (أقل من 60%)
}

@HiveType(typeId: 117)
class PerformanceIssue {

  PerformanceIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.suggestion,
  });
  final IssueType type;
  final IssueSeverity severity;
  final String description;
  final String suggestion;

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'severity': severity.name,
      'description': description,
      'suggestion': suggestion,
    };
  }
}

@HiveType(typeId: 118)
enum IssueType {
  @HiveField(0)
  slowStartup, // بدء بطيء

  @HiveField(1)
  slowDatabase, // قاعدة بيانات بطيئة

  @HiveField(2)
  highMemoryUsage, // استخدام ذاكرة مرتفع

  @HiveField(3)
  networkLatency, // بطء الشبكة

  @HiveField(4)
  uiLag, // تأخر الواجهة

  @HiveField(5)
  batterydrain, // استنزاف البطارية

  @HiveField(6)
  memoryLeak, // تسرب الذاكرة
}

@HiveType(typeId: 119)
enum IssueSeverity {
  @HiveField(0)
  low, // منخفضة

  @HiveField(1)
  medium, // متوسطة

  @HiveField(2)
  high, // عالية

  @HiveField(3)
  critical, // حرجة
}

@HiveType(typeId: 120)
enum ConnectionType {
  @HiveField(0)
  none, // لا توجد شبكة

  @HiveField(1)
  wifi, // واي فاي

  @HiveField(2)
  mobile, // شبكة محمولة

  @HiveField(3)
  ethernet, // إيثرنت

  @HiveField(4)
  other, // أخرى
}
