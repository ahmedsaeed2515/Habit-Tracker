// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 25;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      birthDate: fields[2] as DateTime,
      gender: fields[3] as String,
      height: fields[4] as double,
      weight: fields[5] as double,
      fitnessLevel: fields[6] as String,
      goals: (fields[7] as List).cast<String>(),
      restrictions: (fields[8] as List).cast<String>(),
      preferredExercises: (fields[9] as List).cast<String>(),
      availableEquipment: (fields[10] as List).cast<String>(),
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.fitnessLevel)
      ..writeByte(7)
      ..write(obj.goals)
      ..writeByte(8)
      ..write(obj.restrictions)
      ..writeByte(9)
      ..write(obj.preferredExercises)
      ..writeByte(10)
      ..write(obj.availableEquipment)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
