// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsDataAdapter extends TypeAdapter<AnalyticsData> {
  @override
  final int typeId = 13;

  @override
  AnalyticsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsData(
      id: fields[0] as String,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
      habitCompletions: (fields[3] as Map).cast<String, int>(),
      taskCompletions: (fields[4] as Map).cast<String, int>(),
      totalHabitsCompleted: fields[5] as int,
      totalTasksCompleted: fields[6] as int,
      categoryScores: (fields[7] as Map).cast<String, double>(),
      overallScore: fields[8] as double,
      streakCount: fields[9] as int,
      exerciseMinutes: fields[10] as int,
      focusMinutes: fields[11] as int,
      customMetrics: (fields[12] as Map).cast<String, dynamic>(),
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.habitCompletions)
      ..writeByte(4)
      ..write(obj.taskCompletions)
      ..writeByte(5)
      ..write(obj.totalHabitsCompleted)
      ..writeByte(6)
      ..write(obj.totalTasksCompleted)
      ..writeByte(7)
      ..write(obj.categoryScores)
      ..writeByte(8)
      ..write(obj.overallScore)
      ..writeByte(9)
      ..write(obj.streakCount)
      ..writeByte(10)
      ..write(obj.exerciseMinutes)
      ..writeByte(11)
      ..write(obj.focusMinutes)
      ..writeByte(12)
      ..write(obj.customMetrics)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnalyticsSummaryAdapter extends TypeAdapter<AnalyticsSummary> {
  @override
  final int typeId = 15;

  @override
  AnalyticsSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsSummary(
      id: fields[0] as String,
      period: fields[1] as AnalyticsPeriod,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      averageScore: fields[4] as double,
      totalHabitsCompleted: fields[5] as int,
      totalTasksCompleted: fields[6] as int,
      longestStreak: fields[7] as int,
      currentStreak: fields[8] as int,
      categoryAverages: (fields[9] as Map).cast<String, double>(),
      topPerformingHabits: (fields[10] as List).cast<String>(),
      improvementAreas: (fields[11] as List).cast<String>(),
      generatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsSummary obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.period)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.averageScore)
      ..writeByte(5)
      ..write(obj.totalHabitsCompleted)
      ..writeByte(6)
      ..write(obj.totalTasksCompleted)
      ..writeByte(7)
      ..write(obj.longestStreak)
      ..writeByte(8)
      ..write(obj.currentStreak)
      ..writeByte(9)
      ..write(obj.categoryAverages)
      ..writeByte(10)
      ..write(obj.topPerformingHabits)
      ..writeByte(11)
      ..write(obj.improvementAreas)
      ..writeByte(12)
      ..write(obj.generatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnalyticsPeriodAdapter extends TypeAdapter<AnalyticsPeriod> {
  @override
  final int typeId = 14;

  @override
  AnalyticsPeriod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnalyticsPeriod.daily;
      case 1:
        return AnalyticsPeriod.weekly;
      case 2:
        return AnalyticsPeriod.monthly;
      case 3:
        return AnalyticsPeriod.yearly;
      case 4:
        return AnalyticsPeriod.custom;
      default:
        return AnalyticsPeriod.daily;
    }
  }

  @override
  void write(BinaryWriter writer, AnalyticsPeriod obj) {
    switch (obj) {
      case AnalyticsPeriod.daily:
        writer.writeByte(0);
        break;
      case AnalyticsPeriod.weekly:
        writer.writeByte(1);
        break;
      case AnalyticsPeriod.monthly:
        writer.writeByte(2);
        break;
      case AnalyticsPeriod.yearly:
        writer.writeByte(3);
        break;
      case AnalyticsPeriod.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
