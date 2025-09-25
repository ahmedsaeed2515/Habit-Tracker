// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitTemplateAdapter extends TypeAdapter<HabitTemplate> {
  @override
  final int typeId = 21;

  @override
  HabitTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitTemplate(
      id: fields[0] as String,
      nameAr: fields[1] as String,
      nameEn: fields[2] as String,
      descriptionAr: fields[3] as String,
      descriptionEn: fields[4] as String,
      category: fields[5] as HabitCategory,
      recommendedFrequency: fields[6] as int,
      tags: (fields[7] as List).cast<String>(),
      iconName: fields[8] as String,
      colorCode: fields[9] as String,
      difficultyLevel: fields[10] as int,
      tips: (fields[11] as List).cast<String>(),
      estimatedDurationMinutes: fields[12] as int,
      popularityScore: fields[13] as double,
      prerequisites: (fields[14] as List).cast<String>(),
      isRecommended: fields[15] as bool,
      createdAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HabitTemplate obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameAr)
      ..writeByte(2)
      ..write(obj.nameEn)
      ..writeByte(3)
      ..write(obj.descriptionAr)
      ..writeByte(4)
      ..write(obj.descriptionEn)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.recommendedFrequency)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.iconName)
      ..writeByte(9)
      ..write(obj.colorCode)
      ..writeByte(10)
      ..write(obj.difficultyLevel)
      ..writeByte(11)
      ..write(obj.tips)
      ..writeByte(12)
      ..write(obj.estimatedDurationMinutes)
      ..writeByte(13)
      ..write(obj.popularityScore)
      ..writeByte(14)
      ..write(obj.prerequisites)
      ..writeByte(15)
      ..write(obj.isRecommended)
      ..writeByte(16)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 23;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      interests: (fields[1] as List).cast<HabitCategory>(),
      fitnessLevel: fields[2] as int,
      availableTimes: (fields[3] as List).cast<String>(),
      motivationStyle: fields[4] as int,
      challenges: (fields[5] as List).cast<String>(),
      completedHabits: (fields[6] as Map).cast<String, int>(),
      lastUpdated: fields[7] as DateTime,
      experiencePoints: fields[8] as int,
      achievements: (fields[9] as List).cast<String>(),
      preferences: (fields[10] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.interests)
      ..writeByte(2)
      ..write(obj.fitnessLevel)
      ..writeByte(3)
      ..write(obj.availableTimes)
      ..writeByte(4)
      ..write(obj.motivationStyle)
      ..writeByte(5)
      ..write(obj.challenges)
      ..writeByte(6)
      ..write(obj.completedHabits)
      ..writeByte(7)
      ..write(obj.lastUpdated)
      ..writeByte(8)
      ..write(obj.experiencePoints)
      ..writeByte(9)
      ..write(obj.achievements)
      ..writeByte(10)
      ..write(obj.preferences);
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

class HabitCategoryAdapter extends TypeAdapter<HabitCategory> {
  @override
  final int typeId = 22;

  @override
  HabitCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitCategory.health;
      case 1:
        return HabitCategory.fitness;
      case 2:
        return HabitCategory.productivity;
      case 3:
        return HabitCategory.learning;
      case 4:
        return HabitCategory.social;
      case 5:
        return HabitCategory.spiritual;
      case 6:
        return HabitCategory.creative;
      case 7:
        return HabitCategory.financial;
      case 8:
        return HabitCategory.environmental;
      case 9:
        return HabitCategory.personal;
      default:
        return HabitCategory.health;
    }
  }

  @override
  void write(BinaryWriter writer, HabitCategory obj) {
    switch (obj) {
      case HabitCategory.health:
        writer.writeByte(0);
        break;
      case HabitCategory.fitness:
        writer.writeByte(1);
        break;
      case HabitCategory.productivity:
        writer.writeByte(2);
        break;
      case HabitCategory.learning:
        writer.writeByte(3);
        break;
      case HabitCategory.social:
        writer.writeByte(4);
        break;
      case HabitCategory.spiritual:
        writer.writeByte(5);
        break;
      case HabitCategory.creative:
        writer.writeByte(6);
        break;
      case HabitCategory.financial:
        writer.writeByte(7);
        break;
      case HabitCategory.environmental:
        writer.writeByte(8);
        break;
      case HabitCategory.personal:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
