import 'package:hive/hive.dart';

part 'simple_theming_models.g.dart';

@HiveType(typeId: 200)
enum ThemeCategory {
  @HiveField(0)
  light('فاتح'),
  @HiveField(1)
  dark('داكن'),
  @HiveField(2)
  colorful('ملون'),
  @HiveField(3)
  minimal('بسيط'),
  @HiveField(4)
  professional('مهني'),
  @HiveField(5)
  custom('مخصص');

  const ThemeCategory(this.displayName);
  final String displayName;
}

@HiveType(typeId: 201)
class ColorPalette {

  const ColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.error,
    required this.onError,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.shadow,
    required this.surfaceVariant,
    required this.background,
    required this.onBackground,
    required this.success,
    required this.warning,
    required this.info,
  });
  @HiveField(0)
  final int primary;
  @HiveField(1)
  final int onPrimary;
  @HiveField(2)
  final int secondary;
  @HiveField(3)
  final int onSecondary;
  @HiveField(4)
  final int tertiary;
  @HiveField(5)
  final int onTertiary;
  @HiveField(6)
  final int error;
  @HiveField(7)
  final int onError;
  @HiveField(8)
  final int surface;
  @HiveField(9)
  final int onSurface;
  @HiveField(10)
  final int onSurfaceVariant;
  @HiveField(11)
  final int outline;
  @HiveField(12)
  final int shadow;
  @HiveField(13)
  final int surfaceVariant;
  @HiveField(14)
  final int background;
  @HiveField(15)
  final int onBackground;
  @HiveField(16)
  final int success;
  @HiveField(17)
  final int warning;
  @HiveField(18)
  final int info;

  static ColorPalette defaultDark() {
    return const ColorPalette(
      primary: 0xFF90CAF9,
      onPrimary: 0xFF000000,
      secondary: 0xFFFFA726,
      onSecondary: 0xFF000000,
      tertiary: 0xFF81C784,
      onTertiary: 0xFF000000,
      error: 0xFFEF5350,
      onError: 0xFF000000,
      surface: 0xFF212121,
      onSurface: 0xFFFFFFFF,
      onSurfaceVariant: 0xFFBDBDBD,
      outline: 0xFF616161,
      shadow: 0xFF000000,
      surfaceVariant: 0xFF424242,
      background: 0xFF121212,
      onBackground: 0xFFFFFFFF,
      success: 0xFF66BB6A,
      warning: 0xFFFF7043,
      info: 0xFF42A5F5,
    );
  }
}

@HiveType(typeId: 202)
class DynamicTheme {

  const DynamicTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.lightColorPalette,
    required this.darkColorPalette,
    this.isCustom = false,
    required this.createdAt,
    required this.updatedAt,
  });
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final ThemeCategory category;
  @HiveField(4)
  final ColorPalette lightColorPalette;
  @HiveField(5)
  final ColorPalette darkColorPalette;
  @HiveField(6)
  final bool isCustom;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final DateTime updatedAt;

  DynamicTheme copyWith({
    String? id,
    String? name,
    String? description,
    ThemeCategory? category,
    ColorPalette? lightColorPalette,
    ColorPalette? darkColorPalette,
    bool? isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DynamicTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      lightColorPalette: lightColorPalette ?? this.lightColorPalette,
      darkColorPalette: darkColorPalette ?? this.darkColorPalette,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Simple theme state for the current theme
class ThemeState {

  const ThemeState({
    required this.themeId,
    this.currentTheme,
  });
  final String themeId;
  final DynamicTheme? currentTheme;
}

// Simple service interface
abstract class DynamicThemingService {
  Future<void> setTheme(String themeId);
  Future<void> deleteTheme(String themeId);
  Future<void> createTheme(DynamicTheme theme);
  Future<void> updateTheme(DynamicTheme theme);
}