// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGameDataAdapter extends TypeAdapter<UserGameData> {
  @override
  final int typeId = 20;

  @override
  UserGameData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserGameData(
      totalPoints: fields[0] as int,
      currentLevel: fields[1] as int,
      currentStreak: fields[2] as int,
      longestStreak: fields[3] as int,
      lastActive: fields[4] as DateTime?,
      categoryPoints: (fields[5] as Map?)?.cast<String, int>(),
      completedChallenges: (fields[6] as List?)?.cast<String>(),
      weeklyPoints: fields[7] as int,
      monthlyPoints: fields[8] as int,
      lastStreakUpdate: fields[9] as DateTime?,
      pointsHistory: (fields[10] as Map?)?.cast<String, int>(),
      pointsInCurrentLevel: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserGameData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.totalPoints)
      ..writeByte(1)
      ..write(obj.currentLevel)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.longestStreak)
      ..writeByte(4)
      ..write(obj.lastActive)
      ..writeByte(5)
      ..write(obj.categoryPoints)
      ..writeByte(6)
      ..write(obj.completedChallenges)
      ..writeByte(7)
      ..write(obj.weeklyPoints)
      ..writeByte(8)
      ..write(obj.monthlyPoints)
      ..writeByte(9)
      ..write(obj.lastStreakUpdate)
      ..writeByte(10)
      ..write(obj.pointsHistory)
      ..writeByte(11)
      ..write(obj.pointsInCurrentLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGameDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
