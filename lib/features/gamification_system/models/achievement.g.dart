// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      isUnlocked: fields[7] as bool,
      unlockedAt: fields[8] as DateTime?,
      progress: fields[9] as int,
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

class AchievementCategoryAdapter extends TypeAdapter<AchievementCategory> {
  @override
  final int typeId = 21;

  @override
  AchievementCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementCategory.habitStreak;
      case 1:
        return AchievementCategory.habitCompletion;
      case 2:
        return AchievementCategory.workout;
      case 3:
        return AchievementCategory.social;
      case 4:
        return AchievementCategory.milestone;
      case 5:
        return AchievementCategory.special;
      default:
        return AchievementCategory.habitStreak;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementCategory obj) {
    switch (obj) {
      case AchievementCategory.habitStreak:
        writer.writeByte(0);
        break;
      case AchievementCategory.habitCompletion:
        writer.writeByte(1);
        break;
      case AchievementCategory.workout:
        writer.writeByte(2);
        break;
      case AchievementCategory.social:
        writer.writeByte(3);
        break;
      case AchievementCategory.milestone:
        writer.writeByte(4);
        break;
      case AchievementCategory.special:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementRarityAdapter extends TypeAdapter<AchievementRarity> {
  @override
  final int typeId = 22;

  @override
  AchievementRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementRarity.common;
      case 1:
        return AchievementRarity.rare;
      case 2:
        return AchievementRarity.epic;
      case 3:
        return AchievementRarity.legendary;
      default:
        return AchievementRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementRarity obj) {
    switch (obj) {
      case AchievementRarity.common:
        writer.writeByte(0);
        break;
      case AchievementRarity.rare:
        writer.writeByte(1);
        break;
      case AchievementRarity.epic:
        writer.writeByte(2);
        break;
      case AchievementRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
