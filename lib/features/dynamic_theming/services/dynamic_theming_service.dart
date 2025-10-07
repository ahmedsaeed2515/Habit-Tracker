import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/theming_models.dart';

/// خدمة إدارة الثيمات الديناميكية
class DynamicThemingService {
  static const String _themesBoxName = 'themes';
  static const String _customThemesBoxName = 'custom_themes';
  static const String _themePreferencesBoxName = 'theme_preferences';
  static const String _settingsBoxName = 'theme_settings';

  Box<DynamicTheme>? _themesBox;
  Box<DynamicTheme>? _customThemesBox;
  Box<ThemePreferences>? _themePreferencesBox;
  Box<ThemeSettings>? _settingsBox;

  /// تهيئة الخدمة
  Future<void> initialize() async {
    _themesBox = await Hive.openBox<DynamicTheme>(_themesBoxName);
    _customThemesBox = await Hive.openBox<DynamicTheme>(_customThemesBoxName);
    _themePreferencesBox = await Hive.openBox<ThemePreferences>(_themePreferencesBoxName);
    _settingsBox = await Hive.openBox<ThemeSettings>(_settingsBoxName);
    
    await _initializeDefaultThemes();
    await _initializeSettings();
  }

  /// الحصول على الثيم الحالي
  Future<DynamicTheme> getCurrentTheme() async {
    final preferences = themePreferences;
    final theme = await getThemeById(preferences.currentThemeId);
    if (theme != null) {
      return theme;
    } else {
      return _getDefaultTheme();
    }
  }

  /// الحصول على الثيم بالمعرف
  Future<DynamicTheme?> getThemeById(String id) async {
    // البحث في الثيمات الجاهزة
    final presetTheme = _themesBox?.get(id);
    if (presetTheme != null) return presetTheme;
    
    // البحث في الثيمات المخصصة
    final customTheme = _customThemesBox?.get(id);
    return customTheme;
  }

  /// الحصول على جميع الثيمات
  Future<List<DynamicTheme>> getAllThemes() async {
    final presetThemes = _themesBox?.values.toList() ?? [];
    final customThemes = _customThemesBox?.values.toList() ?? [];
    return [...presetThemes, ...customThemes];
  }

  /// الحصول على الثيمات المخصصة
  Future<List<DynamicTheme>> getCustomThemes() async {
    return _customThemesBox?.values.toList() ?? [];
  }

  /// تفضيلات الثيم
  ThemePreferences get themePreferences {
    return _themePreferencesBox?.get('preferences') ?? ThemePreferences();
  }

  /// إعدادات الثيم
  ThemeSettings get themeSettings {
    return _settingsBox?.get('settings') ?? ThemeSettings();
  }

  /// تغيير الثيم
  Future<void> changeTheme(String themeId) async {
    final theme = await getThemeById(themeId);
    if (theme != null) {
      final prefs = themePreferences;
      prefs.updatePreferences(currentThemeId: themeId);
      await _themePreferencesBox?.put('preferences', prefs);
      
      // تحديث عداد الاستخدام
      theme.incrementUsage();
    }
  }

  /// إنشاء ثيم مخصص
  Future<DynamicTheme> createCustomTheme({
    required String name,
    required ColorPalette lightPalette,
    required ColorPalette darkPalette,
    ThemeMode mode = ThemeMode.system,
    ThemeCategory category = ThemeCategory.custom,
    TypographySettings? typography,
    ComponentsStyle? components,
    AnimationSettings? animations,
    LayoutSettings? layout,
    AccessibilitySettings? accessibility,
  }) async {
    final theme = DynamicTheme(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user',
      name: name,
      description: 'ثيم مخصص',
      mode: mode,
      lightColorPalette: lightPalette,
      darkColorPalette: darkPalette,
      typography: typography ?? TypographySettings.defaultSettings(),
      components: components ?? ComponentsStyle.defaultStyle(),
      animations: animations ?? AnimationSettings.defaultSettings(),
      layout: layout ?? LayoutSettings.defaultSettings(),
      accessibility: accessibility ?? AccessibilitySettings.defaultSettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isCustom: true,
      category: category,
    );

    await _customThemesBox?.put(theme.id, theme);
    return theme;
  }

  /// حذف ثيم مخصص
  Future<bool> deleteCustomTheme(String themeId) async {
    final theme = await getThemeById(themeId);
    if (theme != null && theme.isCustom) {
      await _customThemesBox?.delete(themeId);
      return true;
    }
    return false;
  }

  /// الحصول على الثيمات حسب الموسم
  Future<List<DynamicTheme>> getThemesByCategory(ThemeCategory category) async {
    final allThemes = await getAllThemes();
    return allThemes.where((t) => t.category == category).toList();
  }

  /// تهيئة الثيمات الافتراضية
  Future<void> _initializeDefaultThemes() async {
    if (_themesBox?.isEmpty ?? true) {
      final defaultThemes = _createPresetThemes();
      for (final theme in defaultThemes) {
        await _themesBox?.put(theme.id, theme);
      }
    }
  }

  /// تهيئة الإعدادات
  Future<void> _initializeSettings() async {
    if (_settingsBox?.get('settings') == null) {
      final defaultSettings = ThemeSettings();
      await _settingsBox?.put('settings', defaultSettings);
    }
  }

  /// إنشاء الثيمات الجاهزة
  List<DynamicTheme> _createPresetThemes() {
    return [
      // ثيم الغروب
      DynamicTheme(
        id: 'sunset_orange',
        userId: 'system',
        name: 'غروب برتقالي',
        description: 'ثيم مستوحى من غروب الشمس',
        mode: ThemeMode.light,
        lightColorPalette: ColorPalette(
          primary: 0xFFFF9800,
          onPrimary: 0xFFFFFFFF,
          secondary: 0xFFFF5722,
          onSecondary: 0xFFFFFFFF,
          tertiary: 0xFFFFAB91,
          onTertiary: 0xFF000000,
          surface: 0xFFFFE0B2,
          onSurface: 0xFFE65100,
          surfaceVariant: 0xFFFFF3E0,
          onSurfaceVariant: 0xFFE65100,
          background: 0xFFFFF3E0,
          onBackground: 0xFFE65100,
          error: 0xFFD32F2F,
          onError: 0xFFFFFFFF,
          outline: 0xFFBDBDBD,
          shadow: 0xFF000000,
          success: 0xFF388E3C,
          warning: 0xFFF57C00,
          info: 0xFF1976D2,
        ),
        darkColorPalette: ColorPalette.defaultDark(),
        typography: TypographySettings.defaultSettings(),
        components: ComponentsStyle.defaultStyle(),
        animations: AnimationSettings.defaultSettings(),
        layout: LayoutSettings.defaultSettings(),
        accessibility: AccessibilitySettings.defaultSettings(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: ThemeCategory.warm,
      ),

      // ثيم الليل المتألق
      DynamicTheme(
        id: 'starry_night',
        userId: 'system',
        name: 'ليل متألق',
        description: 'ثيم مستوحى من الليل المرصع بالنجوم',
        mode: ThemeMode.dark,
        lightColorPalette: ColorPalette.defaultLight(),
        darkColorPalette: ColorPalette(
          primary: 0xFF9C27B0,
          onPrimary: 0xFFFFFFFF,
          secondary: 0xFF673AB7,
          onSecondary: 0xFFFFFFFF,
          tertiary: 0xFFE1BEE7,
          onTertiary: 0xFF000000,
          surface: 0xFF1A1A2E,
          onSurface: 0xFFE1BEE7,
          surfaceVariant: 0xFF16213E,
          onSurfaceVariant: 0xFFE1BEE7,
          background: 0xFF0A0A0A,
          onBackground: 0xFFE1BEE7,
          error: 0xFFD32F2F,
          onError: 0xFFFFFFFF,
          outline: 0xFF757575,
          shadow: 0xFF000000,
          success: 0xFF4CAF50,
          warning: 0xFFFF9800,
          info: 0xFF2196F3,
        ),
        typography: TypographySettings.defaultSettings(),
        components: ComponentsStyle.defaultStyle(),
        animations: AnimationSettings.defaultSettings(),
        layout: LayoutSettings.defaultSettings(),
        accessibility: AccessibilitySettings.defaultSettings(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: ThemeCategory.cosmic,
      ),
    ];
  }

  /// الحصول على الثيم الافتراضي
  DynamicTheme _getDefaultTheme() {
    return DynamicTheme(
      id: 'fallback_default',
      userId: 'system',
      name: 'افتراضي',
      description: 'ثيم افتراضي احتياطي',
      lightColorPalette: ColorPalette(
        primary: 0xFF6200EE,
        onPrimary: 0xFFFFFFFF,
        secondary: 0xFF03DAC6,
        onSecondary: 0xFF000000,
        tertiary: 0xFF018786,
        onTertiary: 0xFFFFFFFF,
        surface: 0xFFFAFAFA,
        onSurface: 0xFF000000,
        surfaceVariant: 0xFFF5F5F5,
        onSurfaceVariant: 0xFF000000,
        background: 0xFFFFFFFF,
        onBackground: 0xFF000000,
        error: 0xFFD32F2F,
        onError: 0xFFFFFFFF,
        outline: 0xFFBDBDBD,
        shadow: 0xFF000000,
        success: 0xFF388E3C,
        warning: 0xFFF57C00,
        info: 0xFF1976D2,
      ),
      darkColorPalette: ColorPalette.defaultDark(),
      typography: TypographySettings.defaultSettings(),
      components: ComponentsStyle.defaultStyle(),
      animations: AnimationSettings.defaultSettings(),
      layout: LayoutSettings.defaultSettings(),
      accessibility: AccessibilitySettings.defaultSettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// إغلاق الصناديق
  Future<void> dispose() async {
    await _customThemesBox?.close();
    await _themePreferencesBox?.close();
    await _themesBox?.close();
    await _settingsBox?.close();
  }
}