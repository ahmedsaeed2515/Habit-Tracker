// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 31;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as ChallengeType,
      difficulty: fields[4] as ChallengeDifficulty,
      rewardPoints: fields[5] as int,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
      status: fields[8] as ChallengeStatus,
      currentProgress: fields[9] as int,
      targetProgress: fields[10] as int,
      participants: (fields[11] as List?)?.cast<String>(),
      badgeId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.rewardPoints)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.currentProgress)
      ..writeByte(10)
      ..write(obj.targetProgress)
      ..writeByte(11)
      ..write(obj.participants)
      ..writeByte(12)
      ..write(obj.badgeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 32;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.daily;
      case 1:
        return ChallengeType.weekly;
      case 2:
        return ChallengeType.monthly;
      case 3:
        return ChallengeType.seasonal;
      case 4:
        return ChallengeType.special;
      default:
        return ChallengeType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.daily:
        writer.writeByte(0);
        break;
      case ChallengeType.weekly:
        writer.writeByte(1);
        break;
      case ChallengeType.monthly:
        writer.writeByte(2);
        break;
      case ChallengeType.seasonal:
        writer.writeByte(3);
        break;
      case ChallengeType.special:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeDifficultyAdapter extends TypeAdapter<ChallengeDifficulty> {
  @override
  final int typeId = 33;

  @override
  ChallengeDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeDifficulty.easy;
      case 1:
        return ChallengeDifficulty.medium;
      case 2:
        return ChallengeDifficulty.hard;
      case 3:
        return ChallengeDifficulty.expert;
      default:
        return ChallengeDifficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeDifficulty obj) {
    switch (obj) {
      case ChallengeDifficulty.easy:
        writer.writeByte(0);
        break;
      case ChallengeDifficulty.medium:
        writer.writeByte(1);
        break;
      case ChallengeDifficulty.hard:
        writer.writeByte(2);
        break;
      case ChallengeDifficulty.expert:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeStatusAdapter extends TypeAdapter<ChallengeStatus> {
  @override
  final int typeId = 34;

  @override
  ChallengeStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeStatus.active;
      case 1:
        return ChallengeStatus.completed;
      case 2:
        return ChallengeStatus.failed;
      case 3:
        return ChallengeStatus.expired;
      default:
        return ChallengeStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeStatus obj) {
    switch (obj) {
      case ChallengeStatus.active:
        writer.writeByte(0);
        break;
      case ChallengeStatus.completed:
        writer.writeByte(1);
        break;
      case ChallengeStatus.failed:
        writer.writeByte(2);
        break;
      case ChallengeStatus.expired:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
