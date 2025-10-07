// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      isUnlocked: fields[6] as bool,
      unlockedAt: fields[7] as DateTime?,
      rarity: fields[8] as RewardRarity,
      metadata: (fields[9] as Map?)?.cast<String, dynamic>(),
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

class RewardTypeAdapter extends TypeAdapter<RewardType> {
  @override
  final int typeId = 36;

  @override
  RewardType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RewardType.theme;
      case 1:
        return RewardType.avatar;
      case 2:
        return RewardType.sound;
      case 3:
        return RewardType.animation;
      case 4:
        return RewardType.feature;
      case 5:
        return RewardType.badge;
      case 6:
        return RewardType.title;
      default:
        return RewardType.theme;
    }
  }

  @override
  void write(BinaryWriter writer, RewardType obj) {
    switch (obj) {
      case RewardType.theme:
        writer.writeByte(0);
        break;
      case RewardType.avatar:
        writer.writeByte(1);
        break;
      case RewardType.sound:
        writer.writeByte(2);
        break;
      case RewardType.animation:
        writer.writeByte(3);
        break;
      case RewardType.feature:
        writer.writeByte(4);
        break;
      case RewardType.badge:
        writer.writeByte(5);
        break;
      case RewardType.title:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RewardRarityAdapter extends TypeAdapter<RewardRarity> {
  @override
  final int typeId = 37;

  @override
  RewardRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RewardRarity.common;
      case 1:
        return RewardRarity.rare;
      case 2:
        return RewardRarity.epic;
      case 3:
        return RewardRarity.legendary;
      default:
        return RewardRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, RewardRarity obj) {
    switch (obj) {
      case RewardRarity.common:
        writer.writeByte(0);
        break;
      case RewardRarity.rare:
        writer.writeByte(1);
        break;
      case RewardRarity.epic:
        writer.writeByte(2);
        break;
      case RewardRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
