import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/offline_data.dart';
import '../../../core/database/database_helper.dart';

class OfflineModeService {
  factory OfflineModeService() => _instance;
  OfflineModeService._internal();
  static final OfflineModeService _instance = OfflineModeService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  NetworkStatus? _currentNetworkStatus;
  final _networkStatusController = StreamController<NetworkStatus>.broadcast();
  final _syncStatusController = StreamController<bool>.broadcast();

  bool _isInitialized = false;
  bool _isSyncing = false;

  // تهيئة الخدمة
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // تهيئة حالة الشبكة
      await _initializeNetworkStatus();

      // مراقبة تغييرات الشبكة
      _startNetworkMonitoring();

      // بدء المزامنة التلقائية إذا كانت الشبكة متاحة
      if (_currentNetworkStatus?.isSuitableForSync ?? false) {
        _startAutoSync();
      }

      _isInitialized = true;
      debugPrint('تم تهيئة خدمة العمل بدون اتصال بنجاح');
    } catch (e) {
      debugPrint('خطأ في تهيئة خدمة العمل بدون اتصال: $e');
    }
  }

  // تهيئة حالة الشبكة
  Future<void> _initializeNetworkStatus() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final primaryResult = connectivityResults.isNotEmpty
          ? connectivityResults.first
          : ConnectivityResult.none;
      final isConnected = primaryResult != ConnectivityResult.none;

      _currentNetworkStatus = NetworkStatus(
        isConnected: isConnected,
        connectionType: _mapConnectionType(primaryResult),
        lastChecked: DateTime.now(),
        signalStrength: isConnected ? 75 : 0, // قيمة افتراضية
      );

      // حفظ حالة الشبكة
      final box = await _databaseHelper.openBox<NetworkStatus>(
        'network_status',
      );
      await box.put('current', _currentNetworkStatus!);

      _networkStatusController.add(_currentNetworkStatus!);
    } catch (e) {
      debugPrint('خطأ في تهيئة حالة الشبكة: $e');
    }
  }

  // بدء مراقبة الشبكة
  void _startNetworkMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateNetworkStatus);
  }

  // تحديث حالة الشبكة
  Future<void> _updateNetworkStatus(List<ConnectivityResult> results) async {
    try {
      final primaryResult = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      final isConnected = primaryResult != ConnectivityResult.none;

      _currentNetworkStatus?.updateStatus(
        connected: isConnected,
        type: _mapConnectionType(primaryResult),
        strength: isConnected ? 75 : 0,
      );

      if (_currentNetworkStatus != null) {
        _networkStatusController.add(_currentNetworkStatus!);

        // بدء المزامنة عند توفر الشبكة
        if (isConnected && _currentNetworkStatus!.isSuitableForSync) {
          await syncPendingOperations();
        }
      }
    } catch (e) {
      debugPrint('خطأ في تحديث حالة الشبكة: $e');
    }
  }

  // تحويل نوع الاتصال
  ConnectionType _mapConnectionType(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.none:
        return ConnectionType.none;
      default:
        return ConnectionType.other;
    }
  }

  // إضافة عملية للطابور المحلي
  Future<bool> queueOperation({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    required OfflineAction action,
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      final operationId =
          '${collection}_${documentId}_${DateTime.now().millisecondsSinceEpoch}';

      final offlineData = OfflineData(
        id: operationId,
        collection: collection,
        documentId: documentId,
        data: data,
        action: action,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      final box = await _databaseHelper.openBox<OfflineData>(
        'offline_operations',
      );
      await box.put(operationId, offlineData);

      debugPrint('تمت إضافة العملية إلى الطابور المحلي: $operationId');

      // محاولة المزامنة الفورية إذا كانت الشبكة متاحة
      if (_currentNetworkStatus?.isSuitableForSync ?? false) {
        await syncPendingOperations();
      }

      return true;
    } catch (e) {
      debugPrint('خطأ في إضافة العملية للطابور: $e');
      return false;
    }
  }

  // مزامنة العمليات المعلقة
  Future<bool> syncPendingOperations() async {
    if (_isSyncing) {
      debugPrint('المزامنة قيد التشغيل بالفعل');
      return false;
    }

    if (!(_currentNetworkStatus?.isSuitableForSync ?? false)) {
      debugPrint('الشبكة غير مناسبة للمزامنة');
      return false;
    }

    try {
      _isSyncing = true;
      _syncStatusController.add(true);

      // إنشاء جلسة مزامنة جديدة
      final session = await _createSyncSession(SyncTrigger.manual);

      final box = await _databaseHelper.openBox<OfflineData>(
        'offline_operations',
      );
      final pendingOperations = box.values
          .where((op) => op.status == OfflineStatus.pending || op.canRetry)
          .toList();

      // ترتيب العمليات حسب الأولوية والوقت
      pendingOperations.sort((a, b) {
        final priorityDiff = a.priority.compareTo(b.priority);
        return priorityDiff != 0
            ? priorityDiff
            : a.timestamp.compareTo(b.timestamp);
      });

      session.totalOperations = pendingOperations.length;
      await session.save();

      debugPrint('بدء مزامنة ${pendingOperations.length} عملية معلقة');

      for (final operation in pendingOperations) {
        try {
          operation.updateStatus(OfflineStatus.syncing);

          // محاكاة المزامنة مع الخادم
          final success = await _syncOperation(operation);

          if (success) {
            operation.updateStatus(OfflineStatus.synced);
            session.addSuccess();
            debugPrint('تمت مزامنة العملية بنجاح: ${operation.id}');
          } else {
            operation.incrementRetryCount();
            operation.updateStatus(
              OfflineStatus.failed,
              error: 'فشل في المزامنة',
            );
            session.addFailure('فشل في مزامنة العملية: ${operation.id}');
          }
        } catch (e) {
          operation.incrementRetryCount();
          operation.updateStatus(OfflineStatus.failed, error: e.toString());
          session.addFailure('خطأ في مزامنة العملية ${operation.id}: $e');
          debugPrint('خطأ في مزامنة العملية ${operation.id}: $e');
        }

        // توقف قصير بين العمليات
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // إنهاء جلسة المزامنة
      final finalStatus =
          session.successfulOperations == session.totalOperations
          ? SyncStatus.completed
          : SyncStatus.failed;
      session.complete(finalStatus);

      debugPrint(
        'انتهت المزامنة: ${session.successfulOperations}/${session.totalOperations} عملية نجحت',
      );

      // تنظيف العمليات المزامنة والمنتهية الصلاحية
      await _cleanupSyncedOperations();

      return finalStatus == SyncStatus.completed;
    } catch (e) {
      debugPrint('خطأ في مزامنة العمليات المعلقة: $e');
      return false;
    } finally {
      _isSyncing = false;
      _syncStatusController.add(false);
    }
  }

  // مزامنة عملية واحدة
  Future<bool> _syncOperation(OfflineData operation) async {
    try {
      // محاكاة طلب HTTP للخادم
      await Future.delayed(
        Duration(milliseconds: 100 + (operation.retryCount * 50)),
      );

      // محاكاة معدل نجاح 90%
      final random = DateTime.now().millisecondsSinceEpoch % 100;
      final shouldSucceed = random < 90;

      if (!shouldSucceed) {
        throw Exception('فشل محاكي في المزامنة');
      }

      // في التطبيق الحقيقي، ستتم المزامنة الفعلية مع الخادم هنا
      switch (operation.action) {
        case OfflineAction.create:
          debugPrint('إنشاء ${operation.collection}/${operation.documentId}');
          break;
        case OfflineAction.update:
          debugPrint('تحديث ${operation.collection}/${operation.documentId}');
          break;
        case OfflineAction.delete:
          debugPrint('حذف ${operation.collection}/${operation.documentId}');
          break;
      }

      return true;
    } catch (e) {
      debugPrint('خطأ في مزامنة العملية: $e');
      return false;
    }
  }

  // إنشاء جلسة مزامنة جديدة
  Future<SyncSession> _createSyncSession(SyncTrigger trigger) async {
    final sessionId = 'sync_${DateTime.now().millisecondsSinceEpoch}';

    final session = SyncSession(
      id: sessionId,
      startTime: DateTime.now(),
      trigger: trigger,
    );

    final box = await _databaseHelper.openBox<SyncSession>('sync_sessions');
    await box.put(sessionId, session);

    return session;
  }

  // تنظيف العمليات المزامنة
  Future<void> _cleanupSyncedOperations() async {
    try {
      final box = await _databaseHelper.openBox<OfflineData>(
        'offline_operations',
      );
      final operationsToRemove = <String>[];

      for (final operation in box.values) {
        if (operation.status == OfflineStatus.synced || operation.isExpired) {
          operationsToRemove.add(operation.id);
        }
      }

      for (final operationId in operationsToRemove) {
        await box.delete(operationId);
      }

      debugPrint('تم تنظيف ${operationsToRemove.length} عملية');
    } catch (e) {
      debugPrint('خطأ في تنظيف العمليات: $e');
    }
  }

  // الحصول على العمليات المعلقة
  Future<List<OfflineData>> getPendingOperations() async {
    try {
      final box = await _databaseHelper.openBox<OfflineData>(
        'offline_operations',
      );
      return box.values
          .where((op) => op.status == OfflineStatus.pending || op.canRetry)
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      debugPrint('خطأ في الحصول على العمليات المعلقة: $e');
      return [];
    }
  }

  // الحصول على إحصائيات المزامنة
  Future<Map<String, dynamic>> getSyncStatistics() async {
    try {
      final operationsBox = await _databaseHelper.openBox<OfflineData>(
        'offline_operations',
      );
      final sessionsBox = await _databaseHelper.openBox<SyncSession>(
        'sync_sessions',
      );

      final allOperations = operationsBox.values.toList();
      final pendingCount = allOperations
          .where((op) => op.status == OfflineStatus.pending)
          .length;
      final syncedCount = allOperations
          .where((op) => op.status == OfflineStatus.synced)
          .length;
      final failedCount = allOperations
          .where((op) => op.status == OfflineStatus.failed)
          .length;

      final allSessions = sessionsBox.values.toList();
      final lastSession = allSessions.isNotEmpty
          ? allSessions.reduce(
              (a, b) => a.startTime.isAfter(b.startTime) ? a : b,
            )
          : null;

      return {
        'totalOperations': allOperations.length,
        'pendingOperations': pendingCount,
        'syncedOperations': syncedCount,
        'failedOperations': failedCount,
        'lastSyncTime': lastSession?.startTime.toIso8601String(),
        'lastSyncStatus': lastSession?.status.name,
        'networkStatus': _currentNetworkStatus?.toMap(),
        'isSyncing': _isSyncing,
      };
    } catch (e) {
      debugPrint('خطأ في الحصول على إحصائيات المزامنة: $e');
      return {};
    }
  }

  // إدارة ذاكرة التخزين المؤقت
  Future<void> cacheData(
    String key,
    Map<String, dynamic> data, {
    Duration? validFor,
  }) async {
    try {
      final cache = OfflineCache(
        key: key,
        data: data,
        cachedAt: DateTime.now(),
        validFor: validFor ?? const Duration(hours: 1),
        lastAccessed: DateTime.now(),
      );

      final box = await _databaseHelper.openBox<OfflineCache>('offline_cache');
      await box.put(key, cache);
    } catch (e) {
      debugPrint('خطأ في حفظ البيانات في الذاكرة المؤقتة: $e');
    }
  }

  // الحصول على البيانات من الذاكرة المؤقتة
  Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final box = await _databaseHelper.openBox<OfflineCache>('offline_cache');
      final cache = box.get(key);

      if (cache != null) {
        if (cache.isValid) {
          cache.recordAccess();
          return cache.data;
        } else {
          // حذف البيانات منتهية الصلاحية
          await box.delete(key);
        }
      }

      return null;
    } catch (e) {
      debugPrint('خطأ في الحصول على البيانات من الذاكرة المؤقتة: $e');
      return null;
    }
  }

  // تنظيف الذاكرة المؤقتة
  Future<void> cleanupCache() async {
    try {
      final box = await _databaseHelper.openBox<OfflineCache>('offline_cache');
      final expiredKeys = <String>[];

      for (final cache in box.values) {
        if (cache.isExpired) {
          expiredKeys.add(cache.key);
        }
      }

      for (final key in expiredKeys) {
        await box.delete(key);
      }

      debugPrint('تم تنظيف ${expiredKeys.length} عنصر من الذاكرة المؤقتة');
    } catch (e) {
      debugPrint('خطأ في تنظيف الذاكرة المؤقتة: $e');
    }
  }

  // بدء المزامنة التلقائية
  void _startAutoSync() {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (_currentNetworkStatus?.isSuitableForSync ?? false) {
        await syncPendingOperations();
      }
    });
  }

  // إدارة تعارضات البيانات
  Future<ConflictResolution> createConflictResolution({
    required String collection,
    required String documentId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.manual,
  }) async {
    try {
      final conflictId =
          'conflict_${collection}_${documentId}_${DateTime.now().millisecondsSinceEpoch}';

      final conflict = ConflictResolution(
        id: conflictId,
        collection: collection,
        documentId: documentId,
        localData: localData,
        remoteData: remoteData,
        strategy: strategy,
        createdAt: DateTime.now(),
      );

      // محاولة الحل التلقائي
      if (strategy != ConflictResolutionStrategy.manual) {
        final resolution = conflict.applyAutoResolution();
        if (resolution != null) {
          conflict.resolve(
            resolution,
            note: 'حل تلقائي باستخدام استراتيجية ${strategy.name}',
          );
        }
      }

      final box = await _databaseHelper.openBox<ConflictResolution>(
        'conflicts',
      );
      await box.put(conflictId, conflict);

      return conflict;
    } catch (e) {
      debugPrint('خطأ في إنشاء حل التعارض: $e');
      rethrow;
    }
  }

  // الحصول على التعارضات غير المحلولة
  Future<List<ConflictResolution>> getUnresolvedConflicts() async {
    try {
      final box = await _databaseHelper.openBox<ConflictResolution>(
        'conflicts',
      );
      return box.values.where((c) => !c.isResolved).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      debugPrint('خطأ في الحصول على التعارضات غير المحلولة: $e');
      return [];
    }
  }

  // حل تعارض يدوياً
  Future<bool> resolveConflict(
    String conflictId,
    Map<String, dynamic> resolution, {
    String? note,
  }) async {
    try {
      final box = await _databaseHelper.openBox<ConflictResolution>(
        'conflicts',
      );
      final conflict = box.get(conflictId);

      if (conflict != null && !conflict.isResolved) {
        conflict.resolve(resolution, note: note);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('خطأ في حل التعارض: $e');
      return false;
    }
  }

  // الحصول على تدفق حالة الشبكة
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  // الحصول على تدفق حالة المزامنة
  Stream<bool> get syncStatusStream => _syncStatusController.stream;

  // الحصول على حالة الشبكة الحالية
  NetworkStatus? get currentNetworkStatus => _currentNetworkStatus;

  // فحص ما إذا كانت المزامنة قيد التشغيل
  bool get isSyncing => _isSyncing;

  // تنظيف الموارد
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
    _syncStatusController.close();
  }
}
