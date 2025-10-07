// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 29;

  @override
  Level read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      levelNumber: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      pointsRequired: fields[3] as int,
      iconPath: fields[4] as String,
      rewards: (fields[5] as List?)?.cast<String>(),
      theme: fields[6] as LevelTheme,
    );
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.levelNumber)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pointsRequired)
      ..writeByte(4)
      ..write(obj.iconPath)
      ..writeByte(5)
      ..write(obj.rewards)
      ..writeByte(6)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LevelThemeAdapter extends TypeAdapter<LevelTheme> {
  @override
  final int typeId = 30;

  @override
  LevelTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LevelTheme.bronze;
      case 1:
        return LevelTheme.silver;
      case 2:
        return LevelTheme.gold;
      case 3:
        return LevelTheme.platinum;
      case 4:
        return LevelTheme.diamond;
      case 5:
        return LevelTheme.master;
      default:
        return LevelTheme.bronze;
    }
  }

  @override
  void write(BinaryWriter writer, LevelTheme obj) {
    switch (obj) {
      case LevelTheme.bronze:
        writer.writeByte(0);
        break;
      case LevelTheme.silver:
        writer.writeByte(1);
        break;
      case LevelTheme.gold:
        writer.writeByte(2);
        break;
      case LevelTheme.platinum:
        writer.writeByte(3);
        break;
      case LevelTheme.diamond:
        writer.writeByte(4);
        break;
      case LevelTheme.master:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
