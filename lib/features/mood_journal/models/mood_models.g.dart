// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodEntryAdapter extends TypeAdapter<MoodEntry> {
  @override
  final int typeId = 255;

  @override
  MoodEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      moodLevel: fields[2] as int,
      tags: (fields[3] as List).cast<String>(),
      note: fields[4] as String?,
      relatedHabitIds: (fields[5] as List).cast<String>(),
      relatedTaskIds: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.moodLevel)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.relatedHabitIds)
      ..writeByte(6)
      ..write(obj.relatedTaskIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 256;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      content: fields[2] as String,
      moodEntryId: fields[3] as String?,
      linkedNoteIds: (fields[4] as List).cast<String>(),
      linkedTaskIds: (fields[5] as List).cast<String>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.moodEntryId)
      ..writeByte(4)
      ..write(obj.linkedNoteIds)
      ..writeByte(5)
      ..write(obj.linkedTaskIds)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodAnalyticsAdapter extends TypeAdapter<MoodAnalytics> {
  @override
  final int typeId = 257;

  @override
  MoodAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodAnalytics(
      id: fields[0] as String,
      generatedAt: fields[1] as DateTime,
      tagFrequency: (fields[2] as Map).cast<String, double>(),
      moodDistribution: (fields[3] as Map).cast<int, int>(),
      improvementSuggestions: (fields[4] as List).cast<String>(),
      habitCorrelation: (fields[5] as Map).cast<String, double>(),
      taskCorrelation: (fields[6] as Map).cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodAnalytics obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.generatedAt)
      ..writeByte(2)
      ..write(obj.tagFrequency)
      ..writeByte(3)
      ..write(obj.moodDistribution)
      ..writeByte(4)
      ..write(obj.improvementSuggestions)
      ..writeByte(5)
      ..write(obj.habitCorrelation)
      ..writeByte(6)
      ..write(obj.taskCorrelation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
