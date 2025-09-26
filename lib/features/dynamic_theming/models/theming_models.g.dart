// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theming_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicThemeAdapter extends TypeAdapter<DynamicTheme> {
  @override
  final int typeId = 144;

  @override
  DynamicTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicTheme(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      mode: fields[4] as ThemeMode,
      lightColorPalette: fields[5] as ColorPalette,
      darkColorPalette: fields[6] as ColorPalette,
      typography: fields[7] as TypographySettings,
      components: fields[8] as ComponentsStyle,
      animations: fields[9] as AnimationSettings,
      layout: fields[10] as LayoutSettings,
      accessibility: fields[11] as AccessibilitySettings,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      isCustom: fields[14] as bool,
      isActive: fields[15] as bool,
      usageCount: fields[16] as int,
      metadata: (fields[17] as Map).cast<String, dynamic>(),
      category: fields[18] as ThemeCategory,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicTheme obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.mode)
      ..writeByte(5)
      ..write(obj.lightColorPalette)
      ..writeByte(6)
      ..write(obj.darkColorPalette)
      ..writeByte(7)
      ..write(obj.typography)
      ..writeByte(8)
      ..write(obj.components)
      ..writeByte(9)
      ..write(obj.animations)
      ..writeByte(10)
      ..write(obj.layout)
      ..writeByte(11)
      ..write(obj.accessibility)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.isCustom)
      ..writeByte(15)
      ..write(obj.isActive)
      ..writeByte(16)
      ..write(obj.usageCount)
      ..writeByte(17)
      ..write(obj.metadata)
      ..writeByte(18)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColorPaletteAdapter extends TypeAdapter<ColorPalette> {
  @override
  final int typeId = 145;

  @override
  ColorPalette read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorPalette(
      primary: fields[0] as int,
      onPrimary: fields[1] as int,
      secondary: fields[2] as int,
      onSecondary: fields[3] as int,
      tertiary: fields[4] as int,
      onTertiary: fields[5] as int,
      surface: fields[6] as int,
      onSurface: fields[7] as int,
      surfaceVariant: fields[8] as int,
      onSurfaceVariant: fields[9] as int,
      background: fields[10] as int,
      onBackground: fields[11] as int,
      error: fields[12] as int,
      onError: fields[13] as int,
      outline: fields[14] as int,
      shadow: fields[15] as int,
      success: fields[16] as int,
      warning: fields[17] as int,
      info: fields[18] as int,
      customColors: (fields[19] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ColorPalette obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.primary)
      ..writeByte(1)
      ..write(obj.onPrimary)
      ..writeByte(2)
      ..write(obj.secondary)
      ..writeByte(3)
      ..write(obj.onSecondary)
      ..writeByte(4)
      ..write(obj.tertiary)
      ..writeByte(5)
      ..write(obj.onTertiary)
      ..writeByte(6)
      ..write(obj.surface)
      ..writeByte(7)
      ..write(obj.onSurface)
      ..writeByte(8)
      ..write(obj.surfaceVariant)
      ..writeByte(9)
      ..write(obj.onSurfaceVariant)
      ..writeByte(10)
      ..write(obj.background)
      ..writeByte(11)
      ..write(obj.onBackground)
      ..writeByte(12)
      ..write(obj.error)
      ..writeByte(13)
      ..write(obj.onError)
      ..writeByte(14)
      ..write(obj.outline)
      ..writeByte(15)
      ..write(obj.shadow)
      ..writeByte(16)
      ..write(obj.success)
      ..writeByte(17)
      ..write(obj.warning)
      ..writeByte(18)
      ..write(obj.info)
      ..writeByte(19)
      ..write(obj.customColors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPaletteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypographySettingsAdapter extends TypeAdapter<TypographySettings> {
  @override
  final int typeId = 146;

  @override
  TypographySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TypographySettings(
      fontFamily: fields[0] as String,
      scaleFactory: fields[1] as double,
      headlineWeight: fields[2] as FontWeight,
      bodyWeight: fields[3] as FontWeight,
      letterSpacing: fields[4] as double,
      lineHeight: fields[5] as double,
      useCustomFonts: fields[6] as bool,
      customFontSettings: (fields[7] as Map).cast<TextStyle, FontSettings>(),
    );
  }

  @override
  void write(BinaryWriter writer, TypographySettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.fontFamily)
      ..writeByte(1)
      ..write(obj.scaleFactory)
      ..writeByte(2)
      ..write(obj.headlineWeight)
      ..writeByte(3)
      ..write(obj.bodyWeight)
      ..writeByte(4)
      ..write(obj.letterSpacing)
      ..writeByte(5)
      ..write(obj.lineHeight)
      ..writeByte(6)
      ..write(obj.useCustomFonts)
      ..writeByte(7)
      ..write(obj.customFontSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypographySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ComponentsStyleAdapter extends TypeAdapter<ComponentsStyle> {
  @override
  final int typeId = 147;

  @override
  ComponentsStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComponentsStyle(
      borderRadius: fields[0] as double,
      elevation: fields[1] as double,
      padding: fields[2] as EdgeInsetsGeometry,
      margin: fields[3] as EdgeInsetsGeometry,
      iconSize: fields[4] as double,
      buttonStyle: fields[5] as ButtonStyle,
      cardStyle: fields[6] as CardStyle,
      inputStyle: fields[7] as InputStyle,
      appBarStyle: fields[8] as AppBarStyle,
      customStyles: (fields[9] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ComponentsStyle obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.borderRadius)
      ..writeByte(1)
      ..write(obj.elevation)
      ..writeByte(2)
      ..write(obj.padding)
      ..writeByte(3)
      ..write(obj.margin)
      ..writeByte(4)
      ..write(obj.iconSize)
      ..writeByte(5)
      ..write(obj.buttonStyle)
      ..writeByte(6)
      ..write(obj.cardStyle)
      ..writeByte(7)
      ..write(obj.inputStyle)
      ..writeByte(8)
      ..write(obj.appBarStyle)
      ..writeByte(9)
      ..write(obj.customStyles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentsStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ButtonStyleAdapter extends TypeAdapter<ButtonStyle> {
  @override
  final int typeId = 148;

  @override
  ButtonStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ButtonStyle(
      borderRadius: fields[0] as double,
      elevation: fields[1] as double,
      padding: fields[2] as EdgeInsetsGeometry,
      textStyle: fields[3] as TextStyle,
      minimumSize: fields[4] as Size,
    );
  }

  @override
  void write(BinaryWriter writer, ButtonStyle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.borderRadius)
      ..writeByte(1)
      ..write(obj.elevation)
      ..writeByte(2)
      ..write(obj.padding)
      ..writeByte(3)
      ..write(obj.textStyle)
      ..writeByte(4)
      ..write(obj.minimumSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CardStyleAdapter extends TypeAdapter<CardStyle> {
  @override
  final int typeId = 149;

  @override
  CardStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardStyle(
      borderRadius: fields[0] as double,
      elevation: fields[1] as double,
      margin: fields[2] as EdgeInsetsGeometry,
      padding: fields[3] as EdgeInsetsGeometry,
    );
  }

  @override
  void write(BinaryWriter writer, CardStyle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.borderRadius)
      ..writeByte(1)
      ..write(obj.elevation)
      ..writeByte(2)
      ..write(obj.margin)
      ..writeByte(3)
      ..write(obj.padding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InputStyleAdapter extends TypeAdapter<InputStyle> {
  @override
  final int typeId = 150;

  @override
  InputStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InputStyle(
      borderRadius: fields[0] as double,
      padding: fields[1] as EdgeInsetsGeometry,
      filled: fields[2] as bool,
      borderWidth: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InputStyle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.borderRadius)
      ..writeByte(1)
      ..write(obj.padding)
      ..writeByte(2)
      ..write(obj.filled)
      ..writeByte(3)
      ..write(obj.borderWidth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppBarStyleAdapter extends TypeAdapter<AppBarStyle> {
  @override
  final int typeId = 151;

  @override
  AppBarStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppBarStyle(
      elevation: fields[0] as double,
      centerTitle: fields[1] as bool,
      titleSpacing: fields[2] as double,
      shape: fields[3] as ShapeBorder?,
    );
  }

  @override
  void write(BinaryWriter writer, AppBarStyle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.elevation)
      ..writeByte(1)
      ..write(obj.centerTitle)
      ..writeByte(2)
      ..write(obj.titleSpacing)
      ..writeByte(3)
      ..write(obj.shape);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBarStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnimationSettingsAdapter extends TypeAdapter<AnimationSettings> {
  @override
  final int typeId = 152;

  @override
  AnimationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnimationSettings(
      transitionDuration: fields[0] as Duration,
      transitionCurve: fields[1] as Curve,
      enablePageTransitions: fields[2] as bool,
      enableMicroInteractions: fields[3] as bool,
      enableSharedElementTransitions: fields[4] as bool,
      animationScale: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AnimationSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.transitionDuration)
      ..writeByte(1)
      ..write(obj.transitionCurve)
      ..writeByte(2)
      ..write(obj.enablePageTransitions)
      ..writeByte(3)
      ..write(obj.enableMicroInteractions)
      ..writeByte(4)
      ..write(obj.enableSharedElementTransitions)
      ..writeByte(5)
      ..write(obj.animationScale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LayoutSettingsAdapter extends TypeAdapter<LayoutSettings> {
  @override
  final int typeId = 153;

  @override
  LayoutSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayoutSettings(
      visualDensity: fields[0] as VisualDensity,
      spacing: fields[1] as double,
      compactLayout: fields[2] as bool,
      defaultPadding: fields[3] as EdgeInsetsGeometry,
      defaultMargin: fields[4] as EdgeInsetsGeometry,
    );
  }

  @override
  void write(BinaryWriter writer, LayoutSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.visualDensity)
      ..writeByte(1)
      ..write(obj.spacing)
      ..writeByte(2)
      ..write(obj.compactLayout)
      ..writeByte(3)
      ..write(obj.defaultPadding)
      ..writeByte(4)
      ..write(obj.defaultMargin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessibilitySettingsAdapter extends TypeAdapter<AccessibilitySettings> {
  @override
  final int typeId = 154;

  @override
  AccessibilitySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilitySettings(
      highContrast: fields[0] as bool,
      reducedMotion: fields[1] as bool,
      textScale: fields[2] as double,
      boldText: fields[3] as bool,
      screenReader: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilitySettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.highContrast)
      ..writeByte(1)
      ..write(obj.reducedMotion)
      ..writeByte(2)
      ..write(obj.textScale)
      ..writeByte(3)
      ..write(obj.boldText)
      ..writeByte(4)
      ..write(obj.screenReader);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilitySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FontSettingsAdapter extends TypeAdapter<FontSettings> {
  @override
  final int typeId = 155;

  @override
  FontSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FontSettings(
      fontFamily: fields[0] as String,
      fontWeight: fields[1] as FontWeight,
      fontSize: fields[2] as double,
      letterSpacing: fields[3] as double,
      lineHeight: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FontSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fontFamily)
      ..writeByte(1)
      ..write(obj.fontWeight)
      ..writeByte(2)
      ..write(obj.fontSize)
      ..writeByte(3)
      ..write(obj.letterSpacing)
      ..writeByte(4)
      ..write(obj.lineHeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PresetThemeAdapter extends TypeAdapter<PresetTheme> {
  @override
  final int typeId = 156;

  @override
  PresetTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PresetTheme(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      lightTheme: fields[4] as DynamicTheme,
      darkTheme: fields[5] as DynamicTheme,
      previewImageUrl: fields[6] as String,
      tags: (fields[7] as List).cast<String>(),
      isPremium: fields[8] as bool,
      downloadCount: fields[9] as int,
      rating: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PresetTheme obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.lightTheme)
      ..writeByte(5)
      ..write(obj.darkTheme)
      ..writeByte(6)
      ..write(obj.previewImageUrl)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.isPremium)
      ..writeByte(9)
      ..write(obj.downloadCount)
      ..writeByte(10)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresetThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final int typeId = 150;

  @override
  ThemeSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettings(
      enableAdaptiveTheme: fields[0] as bool,
      enableTimeBasedTheme: fields[1] as bool,
      followSystemTheme: fields[2] as bool,
      dayStartTime: fields[3] as DateTime?,
      nightStartTime: fields[4] as DateTime?,
      enableAnimations: fields[5] as bool,
      enableSounds: fields[6] as bool,
      animationSpeed: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.enableAdaptiveTheme)
      ..writeByte(1)
      ..write(obj.enableTimeBasedTheme)
      ..writeByte(2)
      ..write(obj.followSystemTheme)
      ..writeByte(3)
      ..write(obj.dayStartTime)
      ..writeByte(4)
      ..write(obj.nightStartTime)
      ..writeByte(5)
      ..write(obj.enableAnimations)
      ..writeByte(6)
      ..write(obj.enableSounds)
      ..writeByte(7)
      ..write(obj.animationSpeed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemePreferencesAdapter extends TypeAdapter<ThemePreferences> {
  @override
  final int typeId = 151;

  @override
  ThemePreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemePreferences(
      currentThemeId: fields[0] as String,
      dayThemeId: fields[1] as String?,
      nightThemeId: fields[2] as String?,
      favoriteThemeIds: (fields[3] as List).cast<String>(),
      lastChanged: fields[4] as DateTime?,
      customSettings: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ThemePreferences obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currentThemeId)
      ..writeByte(1)
      ..write(obj.dayThemeId)
      ..writeByte(2)
      ..write(obj.nightThemeId)
      ..writeByte(3)
      ..write(obj.favoriteThemeIds)
      ..writeByte(4)
      ..write(obj.lastChanged)
      ..writeByte(5)
      ..write(obj.customSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
