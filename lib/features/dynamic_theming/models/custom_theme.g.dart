// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomThemeAdapter extends TypeAdapter<CustomTheme> {
  @override
  final int typeId = 43;

  @override
  CustomTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomTheme(
      id: fields[0] as String,
      nameEn: fields[1] as String,
      nameAr: fields[2] as String,
      primaryColorValue: fields[3] as int,
      secondaryColorValue: fields[4] as int,
      backgroundColorValue: fields[5] as int,
      surfaceColorValue: fields[6] as int,
      errorColorValue: fields[7] as int,
      isDark: fields[8] as bool,
      createdAt: fields[9] as DateTime,
      isDefault: fields[10] as bool,
      isActive: fields[11] as bool,
      category: fields[12] as String,
      accentColors: (fields[13] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomTheme obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameEn)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.primaryColorValue)
      ..writeByte(4)
      ..write(obj.secondaryColorValue)
      ..writeByte(5)
      ..write(obj.backgroundColorValue)
      ..writeByte(6)
      ..write(obj.surfaceColorValue)
      ..writeByte(7)
      ..write(obj.errorColorValue)
      ..writeByte(8)
      ..write(obj.isDark)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isDefault)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.category)
      ..writeByte(13)
      ..write(obj.accentColors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemePreferencesAdapter extends TypeAdapter<ThemePreferences> {
  @override
  final int typeId = 44;

  @override
  ThemePreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemePreferences(
      currentThemeId: fields[0] as String,
      useSystemTheme: fields[1] as bool,
      adaptToWallpaper: fields[2] as bool,
      themeBrightness: fields[3] as double,
      enableAnimations: fields[4] as bool,
      fontFamily: fields[5] as String,
      fontSize: fields[6] as double,
      lastModified: fields[7] as DateTime,
      customizations: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ThemePreferences obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.currentThemeId)
      ..writeByte(1)
      ..write(obj.useSystemTheme)
      ..writeByte(2)
      ..write(obj.adaptToWallpaper)
      ..writeByte(3)
      ..write(obj.themeBrightness)
      ..writeByte(4)
      ..write(obj.enableAnimations)
      ..writeByte(5)
      ..write(obj.fontFamily)
      ..writeByte(6)
      ..write(obj.fontSize)
      ..writeByte(7)
      ..write(obj.lastModified)
      ..writeByte(8)
      ..write(obj.customizations);
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
