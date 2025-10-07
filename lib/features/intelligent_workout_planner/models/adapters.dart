import 'package:hive/hive.dart';

import '../../../core/models/user_profile.dart';
import '../models/ai_recommendation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 21;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return WorkoutPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      targetMuscles: (fields[3] as List).cast<String>(),
      durationWeeks: fields[4] as int,
      days: (fields[5] as List).cast<WorkoutDay>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      isActive: fields[8] as bool,
      difficulty: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.targetMuscles)
      ..writeByte(4)
      ..write(obj.durationWeeks)
      ..writeByte(5)
      ..write(obj.days)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutDayAdapter extends TypeAdapter<WorkoutDay> {
  @override
  final int typeId = 22;

  @override
  WorkoutDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return WorkoutDay(
      id: fields[0] as String,
      name: fields[1] as String,
      exercises: (fields[2] as List).cast<Exercise>(),
      dayNumber: fields[3] as int,
      isRestDay: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDay obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.dayNumber)
      ..writeByte(4)
      ..write(obj.isRestDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 23;

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

class AIRecommendationAdapter extends TypeAdapter<AIRecommendation> {
  @override
  final int typeId = 24;

  @override
  AIRecommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return AIRecommendation(
      id: fields[0] as String,
      userId: fields[1] as String,
      recommendationType: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      parameters: (fields[5] as Map).cast<String, dynamic>(),
      confidence: fields[6] as double,
      createdAt: fields[7] as DateTime,
      isApplied: fields[8] as bool,
      appliedAt: fields[9] as DateTime?,
      feedback: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AIRecommendation obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.recommendationType)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.parameters)
      ..writeByte(6)
      ..write(obj.confidence)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.isApplied)
      ..writeByte(9)
      ..write(obj.appliedAt)
      ..writeByte(10)
      ..write(obj.feedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIRecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
