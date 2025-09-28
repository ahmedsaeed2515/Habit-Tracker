import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import '../models/theming_models.dart';
import '../services/dynamic_theming_service.dart';

/// موفر خدمة التصميم الديناميكي
final dynamicThemingServiceProvider = Provider<DynamicThemingService>((ref) {
  return DynamicThemingService();
});

/// موفر تهيئة خدمة التصميم الديناميكي
final dynamicThemingInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(dynamicThemingServiceProvider);
  await service.initialize();
});

/// موفر الثيم الحالي
final currentThemeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((
  ref,
) {
  final service = ref.read(dynamicThemingServiceProvider);
  return ThemeNotifier(service);
});

/// موفر جميع الثيمات المتاحة
final availableThemesProvider = FutureProvider<List<DynamicTheme>>((ref) async {
  final service = ref.read(dynamicThemingServiceProvider);
  return await service.getAllThemes();
});

/// موفر الثيمات المخصصة
final customThemesProvider = FutureProvider<List<DynamicTheme>>((ref) async {
  final allThemes = await ref.watch(availableThemesProvider.future);
  return allThemes.where((theme) => theme.isCustom).toList();
});

/// موفر الثيمات الجاهزة
final presetThemesProvider = FutureProvider<List<DynamicTheme>>((ref) async {
  final allThemes = await ref.watch(availableThemesProvider.future);
  return allThemes.where((theme) => !theme.isCustom).toList();
});

/// موفر إعدادات الثيم - مبسط
final themeSettingsProvider = StateProvider<ThemeSettings>(
  (ref) => ThemeSettings(),
);

/// موفر حالة التحميل
final themeLoadingProvider = Provider<bool>((ref) {
  final currentTheme = ref.watch(currentThemeProvider);
  return currentTheme is ThemeLoading;
});

// === مُدير حالة الثيم ===

class ThemeNotifier extends StateNotifier<ThemeState> {
  final DynamicThemingService _service;

  ThemeNotifier(this._service) : super(ThemeState.loading()) {
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    try {
      final theme = await _service.getCurrentTheme();
      state = ThemeState.loaded(theme);
    } catch (e) {
      state = ThemeState.error(e.toString());
    }
  }

  Future<void> changeTheme(String themeId) async {
    if (state is! ThemeLoaded) return;

    try {
      state = ThemeState.changing((state as ThemeLoaded).theme, themeId);
      await _service.changeTheme(themeId);

      final newTheme = await _service.getThemeById(themeId);
      if (newTheme != null) {
        state = ThemeState.loaded(newTheme);
      } else {
        state = ThemeState.error('الثيم غير موجود');
      }
    } catch (e) {
      state = ThemeState.error(e.toString());
    }
  }

  Future<void> createCustomTheme({
    required String name,
    required ColorPalette lightPalette,
    required ColorPalette darkPalette,
    TypographySettings? typography,
    ComponentsStyle? components,
    AnimationSettings? animations,
  }) async {
    try {
      final theme = await _service.createCustomTheme(
        name: name,
        lightPalette: lightPalette,
        darkPalette: darkPalette,
        typography: typography,
        components: components,
        animations: animations,
      );

      state = ThemeState.loaded(theme);
    } catch (e) {
      state = ThemeState.error(e.toString());
    }
  }
}

// === حالات الثيم ===

abstract class ThemeState {
  const ThemeState();

  factory ThemeState.loading() = ThemeLoading;
  factory ThemeState.loaded(DynamicTheme theme) = ThemeLoaded;
  factory ThemeState.changing(DynamicTheme currentTheme, String newThemeId) =
      ThemeChanging;
  factory ThemeState.error(String message) = ThemeError;
}

class ThemeLoading extends ThemeState {
  const ThemeLoading();
}

class ThemeLoaded extends ThemeState {
  final DynamicTheme theme;
  const ThemeLoaded(this.theme);
}

class ThemeChanging extends ThemeState {
  final DynamicTheme currentTheme;
  final String newThemeId;
  const ThemeChanging(this.currentTheme, this.newThemeId);
}

class ThemeError extends ThemeState {
  final String message;
  const ThemeError(this.message);
}
