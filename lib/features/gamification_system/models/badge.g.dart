// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      isEarned: fields[6] as bool,
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

class BadgeTypeAdapter extends TypeAdapter<BadgeType> {
  @override
  final int typeId = 24;

  @override
  BadgeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeType.streak;
      case 1:
        return BadgeType.completion;
      case 2:
        return BadgeType.milestone;
      case 3:
        return BadgeType.social;
      case 4:
        return BadgeType.special;
      default:
        return BadgeType.streak;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeType obj) {
    switch (obj) {
      case BadgeType.streak:
        writer.writeByte(0);
        break;
      case BadgeType.completion:
        writer.writeByte(1);
        break;
      case BadgeType.milestone:
        writer.writeByte(2);
        break;
      case BadgeType.social:
        writer.writeByte(3);
        break;
      case BadgeType.special:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeRarityAdapter extends TypeAdapter<BadgeRarity> {
  @override
  final int typeId = 25;

  @override
  BadgeRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BadgeRarity.bronze;
      case 1:
        return BadgeRarity.silver;
      case 2:
        return BadgeRarity.gold;
      case 3:
        return BadgeRarity.platinum;
      default:
        return BadgeRarity.bronze;
    }
  }

  @override
  void write(BinaryWriter writer, BadgeRarity obj) {
    switch (obj) {
      case BadgeRarity.bronze:
        writer.writeByte(0);
        break;
      case BadgeRarity.silver:
        writer.writeByte(1);
        break;
      case BadgeRarity.gold:
        writer.writeByte(2);
        break;
      case BadgeRarity.platinum:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
