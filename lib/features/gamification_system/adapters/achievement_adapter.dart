import 'package:hive/hive.dart';
import '../models/achievement.dart';

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 20;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      iconPath: fields[3] as String,
      points: fields[4] as int,
      category: fields[5] as AchievementCategory,
      rarity: fields[6] as AchievementRarity,
      isUnlocked: fields[7] as bool? ?? false,
      unlockedAt: fields[8] as DateTime?,
      progress: fields[9] as int? ?? 0,
      maxProgress: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconPath)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.rarity)
      ..writeByte(7)
      ..write(obj.isUnlocked)
      ..writeByte(8)
      ..write(obj.unlockedAt)
      ..writeByte(9)
      ..write(obj.progress)
      ..writeByte(10)
      ..write(obj.maxProgress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
