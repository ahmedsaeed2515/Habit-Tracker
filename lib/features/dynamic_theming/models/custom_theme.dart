import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'custom_theme.g.dart';

@HiveType(typeId: 43)
class CustomTheme extends HiveObject {

  CustomTheme({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.primaryColorValue,
    required this.secondaryColorValue,
    required this.backgroundColorValue,
    required this.surfaceColorValue,
    required this.errorColorValue,
    this.isDark = false,
    required this.createdAt,
    this.isDefault = false,
    this.isActive = false,
    this.category = 'custom',
    this.accentColors = const {},
  });

  // إنشاء من خريطة
  factory CustomTheme.fromMap(Map<String, dynamic> map) {
    return CustomTheme(
      id: map['id'],
      nameEn: map['nameEn'],
      nameAr: map['nameAr'],
      primaryColorValue: map['primaryColorValue'],
      secondaryColorValue: map['secondaryColorValue'],
      backgroundColorValue: map['backgroundColorValue'],
      surfaceColorValue: map['surfaceColorValue'],
      errorColorValue: map['errorColorValue'],
      isDark: map['isDark'],
      createdAt: DateTime.parse(map['createdAt']),
      isDefault: map['isDefault'],
      isActive: map['isActive'],
      category: map['category'],
      accentColors: Map<String, int>.from(map['accentColors'] ?? {}),
    );
  }
  @HiveField(0)
  String id;

  @HiveField(1)
  String nameEn;

  @HiveField(2)
  String nameAr;

  @HiveField(3)
  int primaryColorValue;

  @HiveField(4)
  int secondaryColorValue;

  @HiveField(5)
  int backgroundColorValue;

  @HiveField(6)
  int surfaceColorValue;

  @HiveField(7)
  int errorColorValue;

  @HiveField(8)
  bool isDark;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  bool isDefault;

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  String category; // nature, gradient, minimal, vibrant

  @HiveField(13)
  Map<String, int> accentColors;

  // تحويل إلى ألوان Flutter
  Color get primaryColor => Color(primaryColorValue);
  Color get secondaryColor => Color(secondaryColorValue);
  Color get backgroundColor => Color(backgroundColorValue);
  Color get surfaceColor => Color(surfaceColorValue);
  Color get errorColor => Color(errorColorValue);

  // الحصول على ألوان اللكنة
  Color getAccentColor(String key) {
    final colorValue = accentColors[key];
    return colorValue != null ? Color(colorValue) : primaryColor;
  }

  // إنشاء ColorScheme من الثيم
  ColorScheme toColorScheme() {
    if (isDark) {
      return ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: _getContrastColor(primaryColor),
        onSecondary: _getContrastColor(secondaryColor),
        onSurface: _getContrastColor(surfaceColor),
        onError: _getContrastColor(errorColor),
      );
    } else {
      return ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: _getContrastColor(primaryColor),
        onSecondary: _getContrastColor(secondaryColor),
        onSurface: _getContrastColor(surfaceColor),
        onError: _getContrastColor(errorColor),
      );
    }
  }

  // إنشاء ThemeData كامل
  ThemeData toThemeData() {
    final colorScheme = toColorScheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: _getContrastColor(surfaceColor),
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _getContrastColor(primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _getContrastColor(primaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: _getContrastColor(surfaceColor).withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // حساب اللون المتباين
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // نسخ الثيم مع تعديلات
  CustomTheme copyWith({
    String? id,
    String? nameEn,
    String? nameAr,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? errorColor,
    bool? isDark,
    DateTime? createdAt,
    bool? isDefault,
    bool? isActive,
    String? category,
    Map<String, int>? accentColors,
  }) {
    return CustomTheme(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      primaryColorValue: primaryColor?.value ?? primaryColorValue,
      secondaryColorValue: secondaryColor?.value ?? secondaryColorValue,
      backgroundColorValue: backgroundColor?.value ?? backgroundColorValue,
      surfaceColorValue: surfaceColor?.value ?? surfaceColorValue,
      errorColorValue: errorColor?.value ?? errorColorValue,
      isDark: isDark ?? this.isDark,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
      accentColors: accentColors ?? this.accentColors,
    );
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'primaryColorValue': primaryColorValue,
      'secondaryColorValue': secondaryColorValue,
      'backgroundColorValue': backgroundColorValue,
      'surfaceColorValue': surfaceColorValue,
      'errorColorValue': errorColorValue,
      'isDark': isDark,
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
      'isActive': isActive,
      'category': category,
      'accentColors': accentColors,
    };
  }
}

@HiveType(typeId: 44)
class ThemePreferences extends HiveObject {

  ThemePreferences({
    this.currentThemeId = 'default',
    this.useSystemTheme = true,
    this.adaptToWallpaper = false,
    this.themeBrightness = 1.0,
    this.enableAnimations = true,
    this.fontFamily = 'Cairo',
    this.fontSize = 14.0,
    required this.lastModified,
    this.customizations = const {},
  });
  @HiveField(0)
  String currentThemeId;

  @HiveField(1)
  bool useSystemTheme;

  @HiveField(2)
  bool adaptToWallpaper;

  @HiveField(3)
  double themeBrightness;

  @HiveField(4)
  bool enableAnimations;

  @HiveField(5)
  String fontFamily;

  @HiveField(6)
  double fontSize;

  @HiveField(7)
  DateTime lastModified;

  @HiveField(8)
  Map<String, dynamic> customizations;

  // تحديث التفضيلات
  void updatePreferences({
    String? currentThemeId,
    bool? useSystemTheme,
    bool? adaptToWallpaper,
    double? themeBrightness,
    bool? enableAnimations,
    String? fontFamily,
    double? fontSize,
    Map<String, dynamic>? customizations,
  }) {
    if (currentThemeId != null) this.currentThemeId = currentThemeId;
    if (useSystemTheme != null) this.useSystemTheme = useSystemTheme;
    if (adaptToWallpaper != null) this.adaptToWallpaper = adaptToWallpaper;
    if (themeBrightness != null) this.themeBrightness = themeBrightness;
    if (enableAnimations != null) this.enableAnimations = enableAnimations;
    if (fontFamily != null) this.fontFamily = fontFamily;
    if (fontSize != null) this.fontSize = fontSize;
    if (customizations != null) this.customizations = customizations;
    
    lastModified = DateTime.now();
    save();
  }
}