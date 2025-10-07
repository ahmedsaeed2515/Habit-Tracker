import 'package:hive/hive.dart';
import '../models/reward.dart';

class RewardAdapter extends TypeAdapter<Reward> {
  @override
  final int typeId = 35;

  @override
  Reward read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Reward(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconPath: fields[3] as String,
      type: fields[4] as RewardType,
      cost: fields[5] as int,
      isUnlocked: fields[6] as bool? ?? false,
      unlockedAt: fields[7] as DateTime?,
      rarity: fields[8] as RewardRarity,
      metadata: (fields[9] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  @override
  void write(BinaryWriter writer, Reward obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconPath)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.isUnlocked)
      ..writeByte(7)
      ..write(obj.unlockedAt)
      ..writeByte(8)
      ..write(obj.rarity)
      ..writeByte(9)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
