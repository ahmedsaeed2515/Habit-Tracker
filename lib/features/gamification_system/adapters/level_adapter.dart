import 'package:hive/hive.dart';
import '../models/level.dart';

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
      rewards: (fields[5] as List?)?.cast<String>() ?? [],
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
