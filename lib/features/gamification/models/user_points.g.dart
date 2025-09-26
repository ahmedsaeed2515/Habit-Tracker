// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_points.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPointsAdapter extends TypeAdapter<UserPoints> {
  @override
  final int typeId = 35;

  @override
  UserPoints read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPoints(
      totalPoints: fields[0] as int,
      currentLevel: fields[1] as int,
      pointsInCurrentLevel: fields[2] as int,
      lastUpdated: fields[3] as DateTime,
      pointsHistory: (fields[4] as Map?)?.cast<String, int>(),
      weeklyPoints: fields[5] as int,
      monthlyPoints: fields[6] as int,
      dailyStreak: fields[7] as int,
      bestStreak: fields[8] as int,
      lastPointsEarned: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPoints obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.totalPoints)
      ..writeByte(1)
      ..write(obj.currentLevel)
      ..writeByte(2)
      ..write(obj.pointsInCurrentLevel)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.pointsHistory)
      ..writeByte(5)
      ..write(obj.weeklyPoints)
      ..writeByte(6)
      ..write(obj.monthlyPoints)
      ..writeByte(7)
      ..write(obj.dailyStreak)
      ..writeByte(8)
      ..write(obj.bestStreak)
      ..writeByte(9)
      ..write(obj.lastPointsEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
