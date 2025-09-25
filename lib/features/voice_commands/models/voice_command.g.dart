// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_command.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceCommandAdapter extends TypeAdapter<VoiceCommand> {
  @override
  final int typeId = 20;

  @override
  VoiceCommand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceCommand(
      id: fields[0] as String,
      originalText: fields[1] as String,
      processedText: fields[2] as String,
      type: fields[3] as VoiceCommandType,
      status: fields[4] as CommandStatus,
      parameters: (fields[5] as Map).cast<String, dynamic>(),
      response: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      executedAt: fields[8] as DateTime?,
      confidence: fields[9] as double,
      errorMessage: fields[10] as String?,
      isBookmarked: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceCommand obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.originalText)
      ..writeByte(2)
      ..write(obj.processedText)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.parameters)
      ..writeByte(6)
      ..write(obj.response)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.executedAt)
      ..writeByte(9)
      ..write(obj.confidence)
      ..writeByte(10)
      ..write(obj.errorMessage)
      ..writeByte(11)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceCommandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VoiceCommandTypeAdapter extends TypeAdapter<VoiceCommandType> {
  @override
  final int typeId = 18;

  @override
  VoiceCommandType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VoiceCommandType.habit;
      case 1:
        return VoiceCommandType.task;
      case 2:
        return VoiceCommandType.exercise;
      case 3:
        return VoiceCommandType.navigation;
      case 4:
        return VoiceCommandType.settings;
      case 5:
        return VoiceCommandType.analytics;
      case 6:
        return VoiceCommandType.general;
      default:
        return VoiceCommandType.habit;
    }
  }

  @override
  void write(BinaryWriter writer, VoiceCommandType obj) {
    switch (obj) {
      case VoiceCommandType.habit:
        writer.writeByte(0);
        break;
      case VoiceCommandType.task:
        writer.writeByte(1);
        break;
      case VoiceCommandType.exercise:
        writer.writeByte(2);
        break;
      case VoiceCommandType.navigation:
        writer.writeByte(3);
        break;
      case VoiceCommandType.settings:
        writer.writeByte(4);
        break;
      case VoiceCommandType.analytics:
        writer.writeByte(5);
        break;
      case VoiceCommandType.general:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceCommandTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommandStatusAdapter extends TypeAdapter<CommandStatus> {
  @override
  final int typeId = 19;

  @override
  CommandStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CommandStatus.pending;
      case 1:
        return CommandStatus.processing;
      case 2:
        return CommandStatus.completed;
      case 3:
        return CommandStatus.failed;
      default:
        return CommandStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, CommandStatus obj) {
    switch (obj) {
      case CommandStatus.pending:
        writer.writeByte(0);
        break;
      case CommandStatus.processing:
        writer.writeByte(1);
        break;
      case CommandStatus.completed:
        writer.writeByte(2);
        break;
      case CommandStatus.failed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommandStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
