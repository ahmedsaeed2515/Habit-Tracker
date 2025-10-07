// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 2;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      targetMuscles: (fields[4] as List).cast<String>(),
      equipment: fields[5] as String,
      sets: fields[6] as int,
      reps: fields[7] as int,
      durationSeconds: fields[8] as int,
      restSeconds: fields[9] as int,
      difficulty: fields[10] as String,
      instructions: fields[11] as String,
      tips: (fields[12] as List).cast<String>(),
      videoUrl: fields[13] as String?,
      imageUrl: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.targetMuscles)
      ..writeByte(5)
      ..write(obj.equipment)
      ..writeByte(6)
      ..write(obj.sets)
      ..writeByte(7)
      ..write(obj.reps)
      ..writeByte(8)
      ..write(obj.durationSeconds)
      ..writeByte(9)
      ..write(obj.restSeconds)
      ..writeByte(10)
      ..write(obj.difficulty)
      ..writeByte(11)
      ..write(obj.instructions)
      ..writeByte(12)
      ..write(obj.tips)
      ..writeByte(13)
      ..write(obj.videoUrl)
      ..writeByte(14)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
