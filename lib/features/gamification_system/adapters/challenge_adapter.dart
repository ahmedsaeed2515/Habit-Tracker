import 'package:hive/hive.dart';
import '../models/challenge.dart';

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
      status: fields[8] as ChallengeStatus? ?? ChallengeStatus.active,
      currentProgress: fields[9] as int? ?? 0,
      targetProgress: fields[10] as int,
      participants: (fields[11] as List?)?.cast<String>() ?? [],
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
