// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthDataAdapter extends TypeAdapter<HealthData> {
  @override
  final int typeId = 38;

  @override
  HealthData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthData(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      steps: fields[2] as int,
      distance: fields[3] as double,
      calories: fields[4] as int,
      activeMinutes: fields[5] as int,
      heartRate: fields[6] as int,
      sleepHours: fields[7] as double,
      weight: fields[8] as double,
      dataSource: fields[9] as String,
      lastSync: fields[10] as DateTime,
      additionalMetrics: (fields[11] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.calories)
      ..writeByte(5)
      ..write(obj.activeMinutes)
      ..writeByte(6)
      ..write(obj.heartRate)
      ..writeByte(7)
      ..write(obj.sleepHours)
      ..writeByte(8)
      ..write(obj.weight)
      ..writeByte(9)
      ..write(obj.dataSource)
      ..writeByte(10)
      ..write(obj.lastSync)
      ..writeByte(11)
      ..write(obj.additionalMetrics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthGoalAdapter extends TypeAdapter<HealthGoal> {
  @override
  final int typeId = 41;

  @override
  HealthGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthGoal(
      id: fields[0] as String,
      nameEn: fields[1] as String,
      nameAr: fields[2] as String,
      type: fields[3] as HealthMetricType,
      targetValue: fields[4] as double,
      unit: fields[5] as String,
      createdAt: fields[6] as DateTime,
      isActive: fields[7] as bool,
      achievedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthGoal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameEn)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.targetValue)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.achievedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityLevelAdapter extends TypeAdapter<ActivityLevel> {
  @override
  final int typeId = 39;

  @override
  ActivityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityLevel.sedentary;
      case 1:
        return ActivityLevel.low;
      case 2:
        return ActivityLevel.medium;
      case 3:
        return ActivityLevel.high;
      default:
        return ActivityLevel.sedentary;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityLevel obj) {
    switch (obj) {
      case ActivityLevel.sedentary:
        writer.writeByte(0);
        break;
      case ActivityLevel.low:
        writer.writeByte(1);
        break;
      case ActivityLevel.medium:
        writer.writeByte(2);
        break;
      case ActivityLevel.high:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepQualityAdapter extends TypeAdapter<SleepQuality> {
  @override
  final int typeId = 40;

  @override
  SleepQuality read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SleepQuality.poor;
      case 1:
        return SleepQuality.fair;
      case 2:
        return SleepQuality.good;
      case 3:
        return SleepQuality.excellent;
      default:
        return SleepQuality.poor;
    }
  }

  @override
  void write(BinaryWriter writer, SleepQuality obj) {
    switch (obj) {
      case SleepQuality.poor:
        writer.writeByte(0);
        break;
      case SleepQuality.fair:
        writer.writeByte(1);
        break;
      case SleepQuality.good:
        writer.writeByte(2);
        break;
      case SleepQuality.excellent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepQualityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthMetricTypeAdapter extends TypeAdapter<HealthMetricType> {
  @override
  final int typeId = 42;

  @override
  HealthMetricType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthMetricType.steps;
      case 1:
        return HealthMetricType.distance;
      case 2:
        return HealthMetricType.calories;
      case 3:
        return HealthMetricType.activeMinutes;
      case 4:
        return HealthMetricType.sleep;
      case 5:
        return HealthMetricType.weight;
      case 6:
        return HealthMetricType.heartRate;
      default:
        return HealthMetricType.steps;
    }
  }

  @override
  void write(BinaryWriter writer, HealthMetricType obj) {
    switch (obj) {
      case HealthMetricType.steps:
        writer.writeByte(0);
        break;
      case HealthMetricType.distance:
        writer.writeByte(1);
        break;
      case HealthMetricType.calories:
        writer.writeByte(2);
        break;
      case HealthMetricType.activeMinutes:
        writer.writeByte(3);
        break;
      case HealthMetricType.sleep:
        writer.writeByte(4);
        break;
      case HealthMetricType.weight:
        writer.writeByte(5);
        break;
      case HealthMetricType.heartRate:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthMetricTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
