// lib/features/widgets_system/providers/widgets_providers.dart
// مقدمات نظام الودجت

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/widget_config.dart';
import '../services/widgets_system_service.dart';

/// مقدم خدمة نظام الودجت
final widgetsServiceProvider = Provider<WidgetsSystemService>((ref) {
  return WidgetsSystemService();
});

/// مقدم جميع الودجت
final allWidgetsProvider = FutureProvider<List<WidgetConfig>>((ref) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getAllWidgets();
});

/// مقدم الودجt المفعلة فقط
final activeWidgetsProvider = FutureProvider<List<WidgetConfig>>((ref) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getActiveWidgets();
});

/// مقدم ودجت حسب المعرف
final widgetByIdProvider = FutureProvider.family<WidgetConfig?, String>((
  ref,
  id,
) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getWidget(id);
});

/// مقدم بيانات ودجت حسب المعرف
final widgetDataProvider = FutureProvider.family<WidgetData?, String>((
  ref,
  widgetId,
) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getWidgetData(widgetId);
});

/// مقدم الودجت حسب النوع
final widgetsByTypeProvider =
    FutureProvider.family<List<WidgetConfig>, WidgetType>((ref, type) async {
      final service = ref.watch(widgetsServiceProvider);
      return service.getWidgetsByType(type);
    });

/// مقدم جميع تخطيطات الودجت
final widgetLayoutsProvider = FutureProvider<List<WidgetLayout>>((ref) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getAllLayouts();
});

/// مقدم التخطيط الافتراضي
final defaultLayoutProvider = FutureProvider<WidgetLayout?>((ref) async {
  final service = ref.watch(widgetsServiceProvider);
  return service.getDefaultLayout();
});

/// مقدم حالة تحديث الودجت
class WidgetRefreshNotifier extends StateNotifier<AsyncValue<void>> {

  WidgetRefreshNotifier(this._service) : super(const AsyncValue.data(null));
  final WidgetsSystemService _service;

  /// تحديث ودجت واحد
  Future<void> refreshWidget(String widgetId) async {
    state = const AsyncValue.loading();
    try {
      await _service.refreshWidgetData(widgetId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// تحديث جميع الودجت
  Future<void> refreshAllWidgets() async {
    state = const AsyncValue.loading();
    try {
      await _service.refreshAllWidgetData();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// مقدم مُدير تحديث الودجت
final widgetRefreshProvider =
    StateNotifierProvider<WidgetRefreshNotifier, AsyncValue<void>>((ref) {
      final service = ref.watch(widgetsServiceProvider);
      return WidgetRefreshNotifier(service);
    });

/// مقدم إعدادات الودجت العامة
final widgetSettingsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'autoRefresh': true,
    'refreshInterval': 15, // دقائق
    'showAnimations': true,
    'compactMode': false,
  };
});

/// مقدم حالة التحميل العامة
final widgetsLoadingProvider = Provider<bool>((ref) {
  final allWidgets = ref.watch(allWidgetsProvider);
  final refreshState = ref.watch(widgetRefreshProvider);

  return allWidgets.isLoading || refreshState.isLoading;
});

/// مقدم حالة الأخطاء العامة
final widgetsErrorProvider = Provider<String?>((ref) {
  final allWidgets = ref.watch(allWidgetsProvider);
  final refreshState = ref.watch(widgetRefreshProvider);

  if (allWidgets.hasError) return allWidgets.error.toString();
  if (refreshState.hasError) return refreshState.error.toString();

  return null;
});
