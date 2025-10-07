import 'package:hive/hive.dart';
import '../models/badge.dart';

class BadgeAdapter extends TypeAdapter<Badge> {
  @override
  final int typeId = 23;

  @override
  Badge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Badge(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconPath: fields[3] as String,
      type: fields[4] as BadgeType,
      rarity: fields[5] as BadgeRarity,
      isEarned: fields[6] as bool? ?? false,
      earnedAt: fields[7] as DateTime?,
      earnedBy: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Badge obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.rarity)
      ..writeByte(6)
      ..write(obj.isEarned)
      ..writeByte(7)
      ..write(obj.earnedAt)
      ..writeByte(8)
      ..write(obj.earnedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
