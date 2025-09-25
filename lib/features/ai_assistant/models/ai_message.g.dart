// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIMessageAdapter extends TypeAdapter<AIMessage> {
  @override
  final int typeId = 24;

  @override
  AIMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIMessage(
      id: fields[0] as String,
      content: fields[1] as String,
      isFromUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      type: fields[4] as AIMessageType,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
      relatedHabitId: fields[6] as String?,
      confidence: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, AIMessage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isFromUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.relatedHabitId)
      ..writeByte(7)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIPersonalityProfileAdapter extends TypeAdapter<AIPersonalityProfile> {
  @override
  final int typeId = 26;

  @override
  AIPersonalityProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIPersonalityProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      personalityType: fields[2] as PersonalityType,
      traits: (fields[3] as Map).cast<String, double>(),
      preferredMotivationMethods: (fields[4] as List).cast<String>(),
      interests: (fields[5] as List).cast<String>(),
      communicationStyle: fields[6] as String,
      createdAt: fields[7] as DateTime,
      lastUpdated: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AIPersonalityProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.personalityType)
      ..writeByte(3)
      ..write(obj.traits)
      ..writeByte(4)
      ..write(obj.preferredMotivationMethods)
      ..writeByte(5)
      ..write(obj.interests)
      ..writeByte(6)
      ..write(obj.communicationStyle)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIPersonalityProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIMessageTypeAdapter extends TypeAdapter<AIMessageType> {
  @override
  final int typeId = 25;

  @override
  AIMessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AIMessageType.text;
      case 1:
        return AIMessageType.suggestion;
      case 2:
        return AIMessageType.reminder;
      case 3:
        return AIMessageType.insight;
      case 4:
        return AIMessageType.motivational;
      case 5:
        return AIMessageType.warning;
      case 6:
        return AIMessageType.celebration;
      default:
        return AIMessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, AIMessageType obj) {
    switch (obj) {
      case AIMessageType.text:
        writer.writeByte(0);
        break;
      case AIMessageType.suggestion:
        writer.writeByte(1);
        break;
      case AIMessageType.reminder:
        writer.writeByte(2);
        break;
      case AIMessageType.insight:
        writer.writeByte(3);
        break;
      case AIMessageType.motivational:
        writer.writeByte(4);
        break;
      case AIMessageType.warning:
        writer.writeByte(5);
        break;
      case AIMessageType.celebration:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIMessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalityTypeAdapter extends TypeAdapter<PersonalityType> {
  @override
  final int typeId = 27;

  @override
  PersonalityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PersonalityType.achiever;
      case 1:
        return PersonalityType.explorer;
      case 2:
        return PersonalityType.socializer;
      case 3:
        return PersonalityType.competitor;
      case 4:
        return PersonalityType.perfectionist;
      case 5:
        return PersonalityType.balanced;
      default:
        return PersonalityType.achiever;
    }
  }

  @override
  void write(BinaryWriter writer, PersonalityType obj) {
    switch (obj) {
      case PersonalityType.achiever:
        writer.writeByte(0);
        break;
      case PersonalityType.explorer:
        writer.writeByte(1);
        break;
      case PersonalityType.socializer:
        writer.writeByte(2);
        break;
      case PersonalityType.competitor:
        writer.writeByte(3);
        break;
      case PersonalityType.perfectionist:
        writer.writeByte(4);
        break;
      case PersonalityType.balanced:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
