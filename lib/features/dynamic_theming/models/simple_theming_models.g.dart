// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_theming_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorPaletteAdapter extends TypeAdapter<ColorPalette> {
  @override
  final int typeId = 201;

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
      error: fields[6] as int,
      onError: fields[7] as int,
      surface: fields[8] as int,
      onSurface: fields[9] as int,
      onSurfaceVariant: fields[10] as int,
      outline: fields[11] as int,
      shadow: fields[12] as int,
      surfaceVariant: fields[13] as int,
      background: fields[14] as int,
      onBackground: fields[15] as int,
      success: fields[16] as int,
      warning: fields[17] as int,
      info: fields[18] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ColorPalette obj) {
    writer
      ..writeByte(19)
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
      ..write(obj.error)
      ..writeByte(7)
      ..write(obj.onError)
      ..writeByte(8)
      ..write(obj.surface)
      ..writeByte(9)
      ..write(obj.onSurface)
      ..writeByte(10)
      ..write(obj.onSurfaceVariant)
      ..writeByte(11)
      ..write(obj.outline)
      ..writeByte(12)
      ..write(obj.shadow)
      ..writeByte(13)
      ..write(obj.surfaceVariant)
      ..writeByte(14)
      ..write(obj.background)
      ..writeByte(15)
      ..write(obj.onBackground)
      ..writeByte(16)
      ..write(obj.success)
      ..writeByte(17)
      ..write(obj.warning)
      ..writeByte(18)
      ..write(obj.info);
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

class DynamicThemeAdapter extends TypeAdapter<DynamicTheme> {
  @override
  final int typeId = 202;

  @override
  DynamicTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicTheme(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as ThemeCategory,
      lightColorPalette: fields[4] as ColorPalette,
      darkColorPalette: fields[5] as ColorPalette,
      isCustom: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicTheme obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.lightColorPalette)
      ..writeByte(5)
      ..write(obj.darkColorPalette)
      ..writeByte(6)
      ..write(obj.isCustom)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
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

class ThemeCategoryAdapter extends TypeAdapter<ThemeCategory> {
  @override
  final int typeId = 200;

  @override
  ThemeCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeCategory.light;
      case 1:
        return ThemeCategory.dark;
      case 2:
        return ThemeCategory.colorful;
      case 3:
        return ThemeCategory.minimal;
      case 4:
        return ThemeCategory.professional;
      case 5:
        return ThemeCategory.custom;
      default:
        return ThemeCategory.light;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeCategory obj) {
    switch (obj) {
      case ThemeCategory.light:
        writer.writeByte(0);
        break;
      case ThemeCategory.dark:
        writer.writeByte(1);
        break;
      case ThemeCategory.colorful:
        writer.writeByte(2);
        break;
      case ThemeCategory.minimal:
        writer.writeByte(3);
        break;
      case ThemeCategory.professional:
        writer.writeByte(4);
        break;
      case ThemeCategory.custom:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
