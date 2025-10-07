// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIRecommendationAdapter extends TypeAdapter<AIRecommendation> {
  @override
  final int typeId = 3;

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
