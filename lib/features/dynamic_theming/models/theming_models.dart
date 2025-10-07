import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'theming_models.g.dart';

/// نموذج السمة الديناميكية الشاملة
@HiveType(typeId: 144)
class DynamicTheme extends HiveObject {

  DynamicTheme({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    this.mode = ThemeMode.system,
    required this.lightColorPalette,
    required this.darkColorPalette,
    required this.typography,
    required this.components,
    required this.animations,
    required this.layout,
    required this.accessibility,
    required this.createdAt,
    required this.updatedAt,
    this.isCustom = false,
    this.isActive = false,
    this.usageCount = 0,
    this.metadata = const {},
    this.category = ThemeCategory.basic,
  });

  /// إنشاء سمة افتراضية
  factory DynamicTheme.createDefault(String userId) {
    final now = DateTime.now();
    return DynamicTheme(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      name: 'الافتراضية',
      description: 'السمة الافتراضية للتطبيق',
      lightColorPalette: ColorPalette.defaultLight(),
      darkColorPalette: ColorPalette.defaultDark(),
      typography: TypographySettings.defaultSettings(),
      components: ComponentsStyle.defaultStyle(),
      animations: AnimationSettings.defaultSettings(),
      layout: LayoutSettings.defaultSettings(),
      accessibility: AccessibilitySettings.defaultSettings(),
      createdAt: now,
      updatedAt: now,
      isActive: true,
      category: ThemeCategory.basic,
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String description;

  @HiveField(4)
  ThemeMode mode;

  @HiveField(5)
  ColorPalette lightColorPalette;

  @HiveField(6)
  ColorPalette darkColorPalette;

  @HiveField(7)
  TypographySettings typography;

  @HiveField(8)
  ComponentsStyle components;

  @HiveField(9)
  AnimationSettings animations;

  @HiveField(10)
  LayoutSettings layout;

  @HiveField(11)
  AccessibilitySettings accessibility;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime updatedAt;

  @HiveField(14)
  bool isCustom;

  @HiveField(15)
  bool isActive;

  @HiveField(16)
  int usageCount;

  @HiveField(17)
  Map<String, dynamic> metadata;

  @HiveField(18)
  ThemeCategory category;

  /// تحديث وقت آخر تعديل
  void updateTimestamp() {
    updatedAt = DateTime.now();
    save();
  }

  /// زيادة عداد الاستخدام
  void incrementUsage() {
    usageCount++;
    updateTimestamp();
  }

  /// تفعيل السمة
  void activate() {
    isActive = true;
    updateTimestamp();
  }

  /// إلغاء تفعيل السمة
  void deactivate() {
    isActive = false;
    updateTimestamp();
  }

  /// نسخ السمة مع تعديلات
  DynamicTheme copyWith({
    String? name,
    String? description,
    ThemeMode? mode,
    ColorPalette? lightColorPalette,
    ColorPalette? darkColorPalette,
    TypographySettings? typography,
    ComponentsStyle? components,
    AnimationSettings? animations,
    LayoutSettings? layout,
    AccessibilitySettings? accessibility,
    ThemeCategory? category,
  }) {
    return DynamicTheme(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name ?? this.name,
      description: description ?? this.description,
      mode: mode ?? this.mode,
      lightColorPalette: lightColorPalette ?? this.lightColorPalette,
      darkColorPalette: darkColorPalette ?? this.darkColorPalette,
      typography: typography ?? this.typography,
      components: components ?? this.components,
      animations: animations ?? this.animations,
      layout: layout ?? this.layout,
      accessibility: accessibility ?? this.accessibility,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isCustom: true,
      category: category ?? this.category,
    );
  }

  /// تحويل إلى ThemeData للتطبيق
  ThemeData toThemeData(bool isDark) {
    final palette = isDark ? darkColorPalette : lightColorPalette;
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: _createColorScheme(palette, isDark),
      textTheme: typography.toTextTheme(),
      appBarTheme: components.createAppBarTheme(palette),
      elevatedButtonTheme: components.createElevatedButtonTheme(palette),
      outlinedButtonTheme: components.createOutlinedButtonTheme(palette),
      textButtonTheme: components.createTextButtonTheme(palette),
      inputDecorationTheme: components.createInputDecorationTheme(palette),
      cardTheme: components.createCardTheme(palette),
      listTileTheme: components.createListTileTheme(palette),
      bottomNavigationBarTheme: components.createBottomNavigationTheme(palette),
      tabBarTheme: components.createTabBarTheme(palette),
      dialogTheme: components.createDialogTheme(palette),
      snackBarTheme: components.createSnackBarTheme(palette),
      floatingActionButtonTheme: components.createFABTheme(palette),
      pageTransitionsTheme: animations.createPageTransitions(),
      visualDensity: layout.visualDensity,
    );
  }

  ColorScheme _createColorScheme(ColorPalette palette, bool isDark) {
    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: Color(palette.primary),
      onPrimary: Color(palette.onPrimary),
      secondary: Color(palette.secondary),
      onSecondary: Color(palette.onSecondary),
      tertiary: Color(palette.tertiary),
      onTertiary: Color(palette.onTertiary),
      surface: Color(palette.surface),
      onSurface: Color(palette.onSurface),
      surfaceContainerHighest: Color(palette.surfaceVariant),
      onSurfaceVariant: Color(palette.onSurfaceVariant),
      error: Color(palette.error),
      onError: Color(palette.onError),
      outline: Color(palette.outline),
      shadow: Color(palette.shadow),
    );
  }
}

/// لوحة الألوان
@HiveType(typeId: 145)
class ColorPalette extends HiveObject {

  ColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onError,
    required this.outline,
    required this.shadow,
    required this.success,
    required this.warning,
    required this.info,
    this.customColors = const {},
  });

  factory ColorPalette.defaultLight() {
    return ColorPalette(
      primary: 0xFF4CAF50,
      onPrimary: 0xFFFFFFFF,
      secondary: 0xFF81C784,
      onSecondary: 0xFF000000,
      tertiary: 0xFFA5D6A7,
      onTertiary: 0xFF000000,
      surface: 0xFFFFFFFF,
      onSurface: 0xFF000000,
      surfaceVariant: 0xFFF5F5F5,
      onSurfaceVariant: 0xFF424242,
      background: 0xFFFAFAFA,
      onBackground: 0xFF000000,
      error: 0xFFD32F2F,
      onError: 0xFFFFFFFF,
      outline: 0xFFBDBDBD,
      shadow: 0xFF000000,
      success: 0xFF388E3C,
      warning: 0xFFF57C00,
      info: 0xFF1976D2,
    );
  }

  factory ColorPalette.defaultDark() {
    return ColorPalette(
      primary: 0xFF66BB6A,
      onPrimary: 0xFF000000,
      secondary: 0xFF4CAF50,
      onSecondary: 0xFF000000,
      tertiary: 0xFF81C784,
      onTertiary: 0xFF000000,
      surface: 0xFF121212,
      onSurface: 0xFFFFFFFF,
      surfaceVariant: 0xFF1E1E1E,
      onSurfaceVariant: 0xFFE0E0E0,
      background: 0xFF000000,
      onBackground: 0xFFFFFFFF,
      error: 0xFFEF5350,
      onError: 0xFF000000,
      outline: 0xFF616161,
      shadow: 0xFF000000,
      success: 0xFF66BB6A,
      warning: 0xFFFFB74D,
      info: 0xFF42A5F5,
    );
  }

  /// إنشاء لوحة ألوان من لون أساسي
  factory ColorPalette.fromSeed(int seedColor, bool isDark) {
    if (isDark) {
      return ColorPalette(
        primary: seedColor,
        onPrimary: _getContrastColor(seedColor),
        secondary: _generateVariation(seedColor, 0.2),
        onSecondary: _getContrastColor(_generateVariation(seedColor, 0.2)),
        tertiary: _generateVariation(seedColor, 0.4),
        onTertiary: _getContrastColor(_generateVariation(seedColor, 0.4)),
        surface: 0xFF121212,
        onSurface: 0xFFFFFFFF,
        surfaceVariant: 0xFF1E1E1E,
        onSurfaceVariant: 0xFFE0E0E0,
        background: 0xFF000000,
        onBackground: 0xFFFFFFFF,
        error: 0xFFEF5350,
        onError: 0xFF000000,
        outline: 0xFF616161,
        shadow: 0xFF000000,
        success: 0xFF66BB6A,
        warning: 0xFFFFB74D,
        info: 0xFF42A5F5,
      );
    } else {
      return ColorPalette(
        primary: seedColor,
        onPrimary: _getContrastColor(seedColor),
        secondary: _generateVariation(seedColor, 0.2),
        onSecondary: _getContrastColor(_generateVariation(seedColor, 0.2)),
        tertiary: _generateVariation(seedColor, 0.4),
        onTertiary: _getContrastColor(_generateVariation(seedColor, 0.4)),
        surface: 0xFFFFFFFF,
        onSurface: 0xFF000000,
        surfaceVariant: 0xFFF5F5F5,
        onSurfaceVariant: 0xFF424242,
        background: 0xFFFAFAFA,
        onBackground: 0xFF000000,
        error: 0xFFD32F2F,
        onError: 0xFFFFFFFF,
        outline: 0xFFBDBDBD,
        shadow: 0xFF000000,
        success: 0xFF388E3C,
        warning: 0xFFF57C00,
        info: 0xFF1976D2,
      );
    }
  }
  @HiveField(0)
  int primary;

  @HiveField(1)
  int onPrimary;

  @HiveField(2)
  int secondary;

  @HiveField(3)
  int onSecondary;

  @HiveField(4)
  int tertiary;

  @HiveField(5)
  int onTertiary;

  @HiveField(6)
  int surface;

  @HiveField(7)
  int onSurface;

  @HiveField(8)
  int surfaceVariant;

  @HiveField(9)
  int onSurfaceVariant;

  @HiveField(10)
  int background;

  @HiveField(11)
  int onBackground;

  @HiveField(12)
  int error;

  @HiveField(13)
  int onError;

  @HiveField(14)
  int outline;

  @HiveField(15)
  int shadow;

  @HiveField(16)
  int success;

  @HiveField(17)
  int warning;

  @HiveField(18)
  int info;

  @HiveField(19)
  Map<String, int> customColors;

  static int _generateVariation(int baseColor, double factor) {
    final color = Color(baseColor);
    final hsl = HSLColor.fromColor(color);
    final newHsl = hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0));
    return newHsl.toColor().value;
  }

  static int _getContrastColor(int color) {
    final luminance = Color(color).computeLuminance();
    return luminance > 0.5 ? 0xFF000000 : 0xFFFFFFFF;
  }
}

/// إعدادات الطباعة
@HiveType(typeId: 146)
class TypographySettings extends HiveObject {

  TypographySettings({
    this.fontFamily = 'Cairo',
    this.scaleFactory = 1.0,
    this.headlineWeight = FontWeight.bold,
    this.bodyWeight = FontWeight.normal,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.4,
    this.useCustomFonts = false,
    this.customFontSettings = const {},
  });

  factory TypographySettings.defaultSettings() {
    return TypographySettings();
  }
  @HiveField(0)
  String fontFamily;

  @HiveField(1)
  double scaleFactory;

  @HiveField(2)
  FontWeight headlineWeight;

  @HiveField(3)
  FontWeight bodyWeight;

  @HiveField(4)
  double letterSpacing;

  @HiveField(5)
  double lineHeight;

  @HiveField(6)
  bool useCustomFonts;

  @HiveField(7)
  Map<TextStyle, FontSettings> customFontSettings;

  TextTheme toTextTheme() {
    return TextTheme(
      displayLarge: _createTextStyle(32.0 * scaleFactory, headlineWeight),
      displayMedium: _createTextStyle(28.0 * scaleFactory, headlineWeight),
      displaySmall: _createTextStyle(24.0 * scaleFactory, headlineWeight),
      headlineLarge: _createTextStyle(22.0 * scaleFactory, headlineWeight),
      headlineMedium: _createTextStyle(20.0 * scaleFactory, headlineWeight),
      headlineSmall: _createTextStyle(18.0 * scaleFactory, headlineWeight),
      titleLarge: _createTextStyle(16.0 * scaleFactory, FontWeight.w600),
      titleMedium: _createTextStyle(14.0 * scaleFactory, FontWeight.w600),
      titleSmall: _createTextStyle(12.0 * scaleFactory, FontWeight.w600),
      bodyLarge: _createTextStyle(16.0 * scaleFactory, bodyWeight),
      bodyMedium: _createTextStyle(14.0 * scaleFactory, bodyWeight),
      bodySmall: _createTextStyle(12.0 * scaleFactory, bodyWeight),
      labelLarge: _createTextStyle(14.0 * scaleFactory, FontWeight.w500),
      labelMedium: _createTextStyle(12.0 * scaleFactory, FontWeight.w500),
      labelSmall: _createTextStyle(10.0 * scaleFactory, FontWeight.w500),
    );
  }

  TextStyle _createTextStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }

  double get scaleFactor => scaleFactory;
  set scaleFactor(double value) => scaleFactory = value;
}

/// إعدادات المكونات
@HiveType(typeId: 147)
class ComponentsStyle extends HiveObject {

  ComponentsStyle({
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.iconSize = 24.0,
    required this.buttonStyle,
    required this.cardStyle,
    required this.inputStyle,
    required this.appBarStyle,
    this.customStyles = const {},
  });

  factory ComponentsStyle.defaultStyle() {
    return ComponentsStyle(
      buttonStyle: ButtonStyle.defaultStyle(),
      cardStyle: CardStyle.defaultStyle(),
      inputStyle: InputStyle.defaultStyle(),
      appBarStyle: AppBarStyle.defaultStyle(),
    );
  }
  @HiveField(0)
  double borderRadius;

  @HiveField(1)
  double elevation;

  @HiveField(2)
  EdgeInsetsGeometry padding;

  @HiveField(3)
  EdgeInsetsGeometry margin;

  @HiveField(4)
  double iconSize;

  @HiveField(5)
  ButtonStyle buttonStyle;

  @HiveField(6)
  CardStyle cardStyle;

  @HiveField(7)
  InputStyle inputStyle;

  @HiveField(8)
  AppBarStyle appBarStyle;

  @HiveField(9)
  Map<String, dynamic> customStyles;

  AppBarTheme createAppBarTheme(ColorPalette palette) {
    return AppBarTheme(
      backgroundColor: Color(palette.surface),
      foregroundColor: Color(palette.onSurface),
      elevation: appBarStyle.elevation,
      shadowColor: Color(palette.shadow),
      shape: appBarStyle.shape,
      centerTitle: appBarStyle.centerTitle,
      titleSpacing: appBarStyle.titleSpacing,
    );
  }

  ElevatedButtonThemeData createElevatedButtonTheme(ColorPalette palette) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(palette.primary),
        foregroundColor: Color(palette.onPrimary),
        elevation: buttonStyle.elevation,
        padding: buttonStyle.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
        ),
        textStyle: buttonStyle.textStyle,
      ),
    );
  }

  OutlinedButtonThemeData createOutlinedButtonTheme(ColorPalette palette) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(palette.primary),
        side: BorderSide(color: Color(palette.outline)),
        padding: buttonStyle.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
        ),
        textStyle: buttonStyle.textStyle,
      ),
    );
  }

  TextButtonThemeData createTextButtonTheme(ColorPalette palette) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(palette.primary),
        padding: buttonStyle.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
        ),
        textStyle: buttonStyle.textStyle,
      ),
    );
  }

  InputDecorationTheme createInputDecorationTheme(ColorPalette palette) {
    return InputDecorationTheme(
      filled: inputStyle.filled,
      fillColor: Color(palette.surface),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputStyle.borderRadius),
        borderSide: BorderSide(color: Color(palette.outline)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputStyle.borderRadius),
        borderSide: BorderSide(color: Color(palette.primary), width: 2),
      ),
      contentPadding: inputStyle.padding,
    );
  }

  CardThemeData createCardTheme(ColorPalette palette) {
    return CardThemeData(
      color: Color(palette.surface),
      shadowColor: Color(palette.shadow),
      elevation: cardStyle.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardStyle.borderRadius),
      ),
      margin: cardStyle.margin,
    );
  }

  ListTileThemeData createListTileTheme(ColorPalette palette) {
    return ListTileThemeData(
      tileColor: Color(palette.surface),
      textColor: Color(palette.onSurface),
      iconColor: Color(palette.onSurfaceVariant),
      contentPadding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  BottomNavigationBarThemeData createBottomNavigationTheme(ColorPalette palette) {
    return BottomNavigationBarThemeData(
      backgroundColor: Color(palette.surface),
      selectedItemColor: Color(palette.primary),
      unselectedItemColor: Color(palette.onSurfaceVariant),
      elevation: elevation,
    );
  }

  TabBarThemeData createTabBarTheme(ColorPalette palette) {
    return TabBarThemeData(
      labelColor: Color(palette.primary),
      unselectedLabelColor: Color(palette.onSurfaceVariant),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(palette.primary), width: 2),
      ),
    );
  }

  DialogThemeData createDialogTheme(ColorPalette palette) {
    return DialogThemeData(
      backgroundColor: Color(palette.surface),
      elevation: elevation * 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius * 2),
      ),
    );
  }

  SnackBarThemeData createSnackBarTheme(ColorPalette palette) {
    return SnackBarThemeData(
      backgroundColor: Color(palette.surfaceVariant),
      contentTextStyle: TextStyle(color: Color(palette.onSurfaceVariant)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  FloatingActionButtonThemeData createFABTheme(ColorPalette palette) {
    return FloatingActionButtonThemeData(
      backgroundColor: Color(palette.primary),
      foregroundColor: Color(palette.onPrimary),
      elevation: elevation * 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius * 2),
      ),
    );
  }
}

/// أنماط الأزرار
@HiveType(typeId: 148)
class ButtonStyle extends HiveObject {

  ButtonStyle({
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    required this.textStyle,
    this.minimumSize = const Size(64, 40),
  });

  factory ButtonStyle.defaultStyle() {
    return ButtonStyle(
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  @HiveField(0)
  double borderRadius;

  @HiveField(1)
  double elevation;

  @HiveField(2)
  EdgeInsetsGeometry padding;

  @HiveField(3)
  TextStyle textStyle;

  @HiveField(4)
  Size minimumSize;
}

/// أنماط البطاقات
@HiveType(typeId: 149)
class CardStyle extends HiveObject {

  CardStyle({
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(16.0),
  });

  factory CardStyle.defaultStyle() {
    return CardStyle();
  }
  @HiveField(0)
  double borderRadius;

  @HiveField(1)
  double elevation;

  @HiveField(2)
  EdgeInsetsGeometry margin;

  @HiveField(3)
  EdgeInsetsGeometry padding;
}

/// أنماط حقول الإدخال
@HiveType(typeId: 150)
class InputStyle extends HiveObject {

  InputStyle({
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    this.filled = true,
    this.borderWidth = 1.0,
  });

  factory InputStyle.defaultStyle() {
    return InputStyle();
  }
  @HiveField(0)
  double borderRadius;

  @HiveField(1)
  EdgeInsetsGeometry padding;

  @HiveField(2)
  bool filled;

  @HiveField(3)
  double borderWidth;
}

/// أنماط شريط التطبيق
@HiveType(typeId: 151)
class AppBarStyle extends HiveObject {

  AppBarStyle({
    this.elevation = 0.0,
    this.centerTitle = true,
    this.titleSpacing = 16.0,
    this.shape,
  });

  factory AppBarStyle.defaultStyle() {
    return AppBarStyle();
  }
  @HiveField(0)
  double elevation;

  @HiveField(1)
  bool centerTitle;

  @HiveField(2)
  double titleSpacing;

  @HiveField(3)
  ShapeBorder? shape;
}

/// إعدادات الرسوم المتحركة
@HiveType(typeId: 152)
class AnimationSettings extends HiveObject {

  AnimationSettings({
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
    this.enablePageTransitions = true,
    this.enableMicroInteractions = true,
    this.enableSharedElementTransitions = true,
    this.animationScale = 1.0,
  });

  factory AnimationSettings.defaultSettings() {
    return AnimationSettings();
  }
  @HiveField(0)
  Duration transitionDuration;

  @HiveField(1)
  Curve transitionCurve;

  @HiveField(2)
  bool enablePageTransitions;

  @HiveField(3)
  bool enableMicroInteractions;

  @HiveField(4)
  bool enableSharedElementTransitions;

  @HiveField(5)
  double animationScale;

  PageTransitionsTheme createPageTransitions() {
    if (!enablePageTransitions) {
      return const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );
    }

    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }
}

/// إعدادات التخطيط
@HiveType(typeId: 153)
class LayoutSettings extends HiveObject {

  LayoutSettings({
    this.visualDensity = VisualDensity.standard,
    this.spacing = 16.0,
    this.compactLayout = false,
    this.defaultPadding = const EdgeInsets.all(16.0),
    this.defaultMargin = const EdgeInsets.all(8.0),
  });

  factory LayoutSettings.defaultSettings() {
    return LayoutSettings();
  }
  @HiveField(0)
  VisualDensity visualDensity;

  @HiveField(1)
  double spacing;

  @HiveField(2)
  bool compactLayout;

  @HiveField(3)
  EdgeInsetsGeometry defaultPadding;

  @HiveField(4)
  EdgeInsetsGeometry defaultMargin;
}

/// إعدادات إمكانية الوصول
@HiveType(typeId: 154)
class AccessibilitySettings extends HiveObject {

  AccessibilitySettings({
    this.highContrast = false,
    this.reducedMotion = false,
    this.textScale = 1.0,
    this.boldText = false,
    this.screenReader = false,
  });

  factory AccessibilitySettings.defaultSettings() {
    return AccessibilitySettings();
  }
  @HiveField(0)
  bool highContrast;

  @HiveField(1)
  bool reducedMotion;

  @HiveField(2)
  double textScale;

  @HiveField(3)
  bool boldText;

  @HiveField(4)
  bool screenReader;
}

/// إعدادات الخط المخصص
@HiveType(typeId: 155)
class FontSettings extends HiveObject {

  FontSettings({
    required this.fontFamily,
    required this.fontWeight,
    required this.fontSize,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.4,
  });
  @HiveField(0)
  String fontFamily;

  @HiveField(1)
  FontWeight fontWeight;

  @HiveField(2)
  double fontSize;

  @HiveField(3)
  double letterSpacing;

  @HiveField(4)
  double lineHeight;
}

/// سمة مُعرّفة مسبقاً
@HiveType(typeId: 156)
class PresetTheme extends HiveObject {

  PresetTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.lightTheme,
    required this.darkTheme,
    this.previewImageUrl = '',
    this.tags = const [],
    this.isPremium = false,
    this.downloadCount = 0,
    this.rating = 0.0,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  @HiveField(4)
  DynamicTheme lightTheme;

  @HiveField(5)
  DynamicTheme darkTheme;

  @HiveField(6)
  String previewImageUrl;

  @HiveField(7)
  List<String> tags;

  @HiveField(8)
  bool isPremium;

  @HiveField(9)
  int downloadCount;

  @HiveField(10)
  double rating;
}

/// فئات السمات
enum ThemeCategory {
  nature,      // الطبيعة
  minimal,     // البساطة
  vibrant,     // الألوان الزاهية
  dark,        // المظلمة
  productivity, // الإنتاجية
  wellness,    // الصحة
  creative,    // الإبداعية
  professional, // المهنية
  warm,        // الدافئة
  cool,        // الباردة
  basic,       // الأساسية
  cosmic,      // الكونية
  custom,      // المخصصة
  event,       // المناسبات
}

/// حالة السمة
enum ThemeStatus {
  active,      // نشطة
  inactive,    // غير نشطة
  draft,       // مسودة
  archived,    // مؤرشفة
}

/// إعدادات السمة
@HiveType(typeId: 150)
class ThemeSettings extends HiveObject {

  ThemeSettings({
    this.enableAdaptiveTheme = false,
    this.enableTimeBasedTheme = false,
    this.followSystemTheme = true,
    this.dayStartTime,
    this.nightStartTime,
    this.enableAnimations = true,
    this.enableSounds = false,
    this.animationSpeed = 1.0,
  });
  @HiveField(0)
  final bool enableAdaptiveTheme;

  @HiveField(1)
  final bool enableTimeBasedTheme;

  @HiveField(2)
  final bool followSystemTheme;

  @HiveField(3)
  final DateTime? dayStartTime;

  @HiveField(4)
  final DateTime? nightStartTime;

  @HiveField(5)
  final bool enableAnimations;

  @HiveField(6)
  final bool enableSounds;

  @HiveField(7)
  final double animationSpeed;

  /// نسخ مع تعديل
  ThemeSettings copyWith({
    bool? enableAdaptiveTheme,
    bool? enableTimeBasedTheme,
    bool? followSystemTheme,
    DateTime? dayStartTime,
    DateTime? nightStartTime,
    bool? enableAnimations,
    bool? enableSounds,
    double? animationSpeed,
  }) {
    return ThemeSettings(
      enableAdaptiveTheme: enableAdaptiveTheme ?? this.enableAdaptiveTheme,
      enableTimeBasedTheme: enableTimeBasedTheme ?? this.enableTimeBasedTheme,
      followSystemTheme: followSystemTheme ?? this.followSystemTheme,
      dayStartTime: dayStartTime ?? this.dayStartTime,
      nightStartTime: nightStartTime ?? this.nightStartTime,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableSounds: enableSounds ?? this.enableSounds,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
}

/// تفضيلات السمة
@HiveType(typeId: 151)
class ThemePreferences extends HiveObject {

  ThemePreferences({
    this.currentThemeId = 'default_light',
    this.dayThemeId,
    this.nightThemeId,
    this.favoriteThemeIds = const [],
    DateTime? lastChanged,
    this.customSettings = const {},
  }) : lastChanged = lastChanged ?? DateTime.now();
  @HiveField(0)
  String currentThemeId;

  @HiveField(1)
  String? dayThemeId;

  @HiveField(2)
  String? nightThemeId;

  @HiveField(3)
  List<String> favoriteThemeIds;

  @HiveField(4)
  DateTime lastChanged;

  @HiveField(5)
  Map<String, dynamic> customSettings;

  /// تحديث التفضيلات
  void updatePreferences({
    String? currentThemeId,
    String? dayThemeId,
    String? nightThemeId,
    List<String>? favoriteThemeIds,
    Map<String, dynamic>? customSettings,
  }) {
    if (currentThemeId != null) this.currentThemeId = currentThemeId;
    if (dayThemeId != null) this.dayThemeId = dayThemeId;
    if (nightThemeId != null) this.nightThemeId = nightThemeId;
    if (favoriteThemeIds != null) this.favoriteThemeIds = favoriteThemeIds;
    if (customSettings != null) this.customSettings = customSettings;
    lastChanged = DateTime.now();
    save();
  }

  /// إضافة إلى المفضلة
  void addFavorite(String themeId) {
    if (!favoriteThemeIds.contains(themeId)) {
      favoriteThemeIds.add(themeId);
      lastChanged = DateTime.now();
      save();
    }
  }

  /// إزالة من المفضلة
  void removeFavorite(String themeId) {
    if (favoriteThemeIds.contains(themeId)) {
      favoriteThemeIds.remove(themeId);
      lastChanged = DateTime.now();
      save();
    }
  }
}