// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'morning_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MorningExerciseAdapter extends TypeAdapter<MorningExercise> {
  @override
  final int typeId = 2;

  @override
  MorningExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MorningExercise(
      id: fields[0] as String,
      type: fields[1] as ExerciseType,
      date: fields[2] as DateTime,
      reps: fields[3] as int,
      isCompleted: fields[4] as bool,
      name: fields[5] as String,
      targetReps: fields[6] as int,
      targetSets: fields[7] as int,
      caloriesBurned: fields[8] as int,
      actualReps: fields[9] as int?,
      actualSets: fields[10] as int?,
      completedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MorningExercise obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.targetReps)
      ..writeByte(7)
      ..write(obj.targetSets)
      ..writeByte(8)
      ..write(obj.caloriesBurned)
      ..writeByte(9)
      ..write(obj.actualReps)
      ..writeByte(10)
      ..write(obj.actualSets)
      ..writeByte(11)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorningExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseGoalAdapter extends TypeAdapter<ExerciseGoal> {
  @override
  final int typeId = 4;

  @override
  ExerciseGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseGoal(
      type: fields[0] as ExerciseType,
      targetReps: fields[1] as int,
      currentReps: fields[2] as int,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseGoal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.targetReps)
      ..writeByte(2)
      ..write(obj.currentReps)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 3;

  @override
  ExerciseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseType.squat;
      case 1:
        return ExerciseType.pushUp;
      case 2:
        return ExerciseType.pullUp;
      case 3:
        return ExerciseType.custom;
      default:
        return ExerciseType.squat;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    switch (obj) {
      case ExerciseType.squat:
        writer.writeByte(0);
        break;
      case ExerciseType.pushUp:
        writer.writeByte(1);
        break;
      case ExerciseType.pullUp:
        writer.writeByte(2);
        break;
      case ExerciseType.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
