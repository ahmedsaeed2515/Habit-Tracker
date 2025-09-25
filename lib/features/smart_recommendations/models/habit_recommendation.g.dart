// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitRecommendationAdapter extends TypeAdapter<HabitRecommendation> {
  @override
  final int typeId = 28;

  @override
  HabitRecommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitRecommendation(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      confidenceScore: fields[4] as double,
      type: fields[5] as RecommendationType,
      reasons: (fields[6] as List).cast<String>(),
      metadata: (fields[7] as Map).cast<String, dynamic>(),
      createdAt: fields[8] as DateTime,
      acceptedAt: fields[9] as DateTime?,
      rejectedAt: fields[10] as DateTime?,
      isViewed: fields[11] as bool,
      priority: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HabitRecommendation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.confidenceScore)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.reasons)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.acceptedAt)
      ..writeByte(10)
      ..write(obj.rejectedAt)
      ..writeByte(11)
      ..write(obj.isViewed)
      ..writeByte(12)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitRecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserBehaviorPatternAdapter extends TypeAdapter<UserBehaviorPattern> {
  @override
  final int typeId = 30;

  @override
  UserBehaviorPattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBehaviorPattern(
      id: fields[0] as String,
      userId: fields[1] as String,
      patternType: fields[2] as PatternType,
      description: fields[3] as String,
      strength: fields[4] as double,
      frequency: fields[5] as int,
      firstObserved: fields[6] as DateTime,
      lastObserved: fields[7] as DateTime,
      data: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserBehaviorPattern obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.patternType)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.strength)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.firstObserved)
      ..writeByte(7)
      ..write(obj.lastObserved)
      ..writeByte(8)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBehaviorPatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationTypeAdapter extends TypeAdapter<RecommendationType> {
  @override
  final int typeId = 29;

  @override
  RecommendationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecommendationType.newHabit;
      case 1:
        return RecommendationType.improvementSuggestion;
      case 2:
        return RecommendationType.timingOptimization;
      case 3:
        return RecommendationType.habitStacking;
      case 4:
        return RecommendationType.replacementHabit;
      case 5:
        return RecommendationType.motivationalBoost;
      default:
        return RecommendationType.newHabit;
    }
  }

  @override
  void write(BinaryWriter writer, RecommendationType obj) {
    switch (obj) {
      case RecommendationType.newHabit:
        writer.writeByte(0);
        break;
      case RecommendationType.improvementSuggestion:
        writer.writeByte(1);
        break;
      case RecommendationType.timingOptimization:
        writer.writeByte(2);
        break;
      case RecommendationType.habitStacking:
        writer.writeByte(3);
        break;
      case RecommendationType.replacementHabit:
        writer.writeByte(4);
        break;
      case RecommendationType.motivationalBoost:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatternTypeAdapter extends TypeAdapter<PatternType> {
  @override
  final int typeId = 31;

  @override
  PatternType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PatternType.consistentTiming;
      case 1:
        return PatternType.weekdayPreference;
      case 2:
        return PatternType.consecutiveSuccess;
      case 3:
        return PatternType.dropoffPattern;
      case 4:
        return PatternType.recoveryPattern;
      case 5:
        return PatternType.seasonalVariation;
      case 6:
        return PatternType.categoryPreference;
      default:
        return PatternType.consistentTiming;
    }
  }

  @override
  void write(BinaryWriter writer, PatternType obj) {
    switch (obj) {
      case PatternType.consistentTiming:
        writer.writeByte(0);
        break;
      case PatternType.weekdayPreference:
        writer.writeByte(1);
        break;
      case PatternType.consecutiveSuccess:
        writer.writeByte(2);
        break;
      case PatternType.dropoffPattern:
        writer.writeByte(3);
        break;
      case PatternType.recoveryPattern:
        writer.writeByte(4);
        break;
      case PatternType.seasonalVariation:
        writer.writeByte(5);
        break;
      case PatternType.categoryPreference:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
