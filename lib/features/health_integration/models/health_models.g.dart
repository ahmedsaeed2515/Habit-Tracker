// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthProfileAdapter extends TypeAdapter<HealthProfile> {
  @override
  final int typeId = 133;

  @override
  HealthProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthProfile(
      userId: fields[0] as String,
      lastSyncDate: fields[1] as DateTime?,
      isHealthKitConnected: fields[2] as bool,
      isGoogleFitConnected: fields[3] as bool,
      healthMetrics: (fields[4] as List?)?.cast<HealthMetric>(),
      dailyHealthData: (fields[5] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<HealthDataPoint>())),
      healthGoals: (fields[6] as List?)?.cast<HealthGoal>(),
      healthInsights: (fields[7] as List?)?.cast<HealthInsight>(),
      privacySettings: fields[8] as HealthPrivacySettings?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.lastSyncDate)
      ..writeByte(2)
      ..write(obj.isHealthKitConnected)
      ..writeByte(3)
      ..write(obj.isGoogleFitConnected)
      ..writeByte(4)
      ..write(obj.healthMetrics)
      ..writeByte(5)
      ..write(obj.dailyHealthData)
      ..writeByte(6)
      ..write(obj.healthGoals)
      ..writeByte(7)
      ..write(obj.healthInsights)
      ..writeByte(8)
      ..write(obj.privacySettings)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthMetricAdapter extends TypeAdapter<HealthMetric> {
  @override
  final int typeId = 134;

  @override
  HealthMetric read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthMetric(
      id: fields[0] as String,
      type: fields[1] as HealthMetricType,
      name: fields[2] as String,
      unit: fields[3] as String,
      currentValue: fields[4] as double,
      targetValue: fields[5] as double,
      minHealthyValue: fields[6] as double,
      maxHealthyValue: fields[7] as double,
      lastUpdated: fields[8] as DateTime?,
      trends: (fields[9] as List?)?.cast<HealthTrend>(),
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HealthMetric obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.currentValue)
      ..writeByte(5)
      ..write(obj.targetValue)
      ..writeByte(6)
      ..write(obj.minHealthyValue)
      ..writeByte(7)
      ..write(obj.maxHealthyValue)
      ..writeByte(8)
      ..write(obj.lastUpdated)
      ..writeByte(9)
      ..write(obj.trends)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthMetricAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthDataPointAdapter extends TypeAdapter<HealthDataPoint> {
  @override
  final int typeId = 135;

  @override
  HealthDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthDataPoint(
      id: fields[0] as String,
      type: fields[1] as HealthMetricType,
      value: fields[2] as double,
      unit: fields[3] as String,
      timestamp: fields[4] as DateTime,
      source: fields[5] as HealthDataSource,
      metadata: (fields[6] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthDataPoint obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.source)
      ..writeByte(6)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthGoalAdapter extends TypeAdapter<HealthGoal> {
  @override
  final int typeId = 136;

  @override
  HealthGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthGoal(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      metricType: fields[3] as HealthMetricType,
      targetValue: fields[4] as double,
      currentValue: fields[5] as double,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
      isCompleted: fields[8] as bool,
      isActive: fields[9] as bool,
      goalType: fields[10] as HealthGoalType,
      streakDays: fields[11] as int,
      lastAchievedDate: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthGoal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.metricType)
      ..writeByte(4)
      ..write(obj.targetValue)
      ..writeByte(5)
      ..write(obj.currentValue)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.goalType)
      ..writeByte(11)
      ..write(obj.streakDays)
      ..writeByte(12)
      ..write(obj.lastAchievedDate);
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

class HealthInsightAdapter extends TypeAdapter<HealthInsight> {
  @override
  final int typeId = 137;

  @override
  HealthInsight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthInsight(
      id: fields[0] as String,
      type: fields[1] as HealthInsightType,
      title: fields[2] as String,
      description: fields[3] as String,
      priority: fields[4] as HealthInsightPriority,
      relatedMetric: fields[5] as HealthMetricType?,
      createdAt: fields[6] as DateTime?,
      isRead: fields[7] as bool,
      isActionable: fields[8] as bool,
      actionText: fields[9] as String?,
      actionData: (fields[10] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HealthInsight obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.relatedMetric)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.isActionable)
      ..writeByte(9)
      ..write(obj.actionText)
      ..writeByte(10)
      ..write(obj.actionData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthInsightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthTrendAdapter extends TypeAdapter<HealthTrend> {
  @override
  final int typeId = 138;

  @override
  HealthTrend read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthTrend(
      timestamp: fields[0] as DateTime,
      value: fields[1] as double,
      direction: fields[2] as HealthTrendDirection,
      changePercentage: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HealthTrend obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.direction)
      ..writeByte(3)
      ..write(obj.changePercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthTrendAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthPrivacySettingsAdapter extends TypeAdapter<HealthPrivacySettings> {
  @override
  final int typeId = 139;

  @override
  HealthPrivacySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthPrivacySettings(
      allowDataSharing: fields[0] as bool,
      allowAnalytics: fields[1] as bool,
      allowInsights: fields[2] as bool,
      sharedMetrics: (fields[3] as List?)?.cast<HealthMetricType>(),
      requirePermissionForNewMetrics: fields[4] as bool,
      dataRetentionDays: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HealthPrivacySettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.allowDataSharing)
      ..writeByte(1)
      ..write(obj.allowAnalytics)
      ..writeByte(2)
      ..write(obj.allowInsights)
      ..writeByte(3)
      ..write(obj.sharedMetrics)
      ..writeByte(4)
      ..write(obj.requirePermissionForNewMetrics)
      ..writeByte(5)
      ..write(obj.dataRetentionDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthPrivacySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthMetricTypeAdapter extends TypeAdapter<HealthMetricType> {
  @override
  final int typeId = 140;

  @override
  HealthMetricType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthMetricType.steps;
      case 1:
        return HealthMetricType.sleep;
      case 2:
        return HealthMetricType.heartRate;
      case 3:
        return HealthMetricType.weight;
      case 4:
        return HealthMetricType.height;
      case 5:
        return HealthMetricType.bloodPressure;
      case 6:
        return HealthMetricType.bodyTemperature;
      case 7:
        return HealthMetricType.oxygenSaturation;
      case 8:
        return HealthMetricType.caloriesBurned;
      case 9:
        return HealthMetricType.activeMinutes;
      case 10:
        return HealthMetricType.waterIntake;
      case 11:
        return HealthMetricType.bloodSugar;
      case 12:
        return HealthMetricType.distance;
      case 13:
        return HealthMetricType.exercise;
      case 14:
        return HealthMetricType.meditation;
      case 15:
        return HealthMetricType.mood;
      case 16:
        return HealthMetricType.energy;
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
      case HealthMetricType.sleep:
        writer.writeByte(1);
        break;
      case HealthMetricType.heartRate:
        writer.writeByte(2);
        break;
      case HealthMetricType.weight:
        writer.writeByte(3);
        break;
      case HealthMetricType.height:
        writer.writeByte(4);
        break;
      case HealthMetricType.bloodPressure:
        writer.writeByte(5);
        break;
      case HealthMetricType.bodyTemperature:
        writer.writeByte(6);
        break;
      case HealthMetricType.oxygenSaturation:
        writer.writeByte(7);
        break;
      case HealthMetricType.caloriesBurned:
        writer.writeByte(8);
        break;
      case HealthMetricType.activeMinutes:
        writer.writeByte(9);
        break;
      case HealthMetricType.waterIntake:
        writer.writeByte(10);
        break;
      case HealthMetricType.bloodSugar:
        writer.writeByte(11);
        break;
      case HealthMetricType.distance:
        writer.writeByte(12);
        break;
      case HealthMetricType.exercise:
        writer.writeByte(13);
        break;
      case HealthMetricType.meditation:
        writer.writeByte(14);
        break;
      case HealthMetricType.mood:
        writer.writeByte(15);
        break;
      case HealthMetricType.energy:
        writer.writeByte(16);
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

class HealthDataSourceAdapter extends TypeAdapter<HealthDataSource> {
  @override
  final int typeId = 141;

  @override
  HealthDataSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthDataSource.manual;
      case 1:
        return HealthDataSource.healthKit;
      case 2:
        return HealthDataSource.googleFit;
      case 3:
        return HealthDataSource.device;
      case 4:
        return HealthDataSource.app;
      default:
        return HealthDataSource.manual;
    }
  }

  @override
  void write(BinaryWriter writer, HealthDataSource obj) {
    switch (obj) {
      case HealthDataSource.manual:
        writer.writeByte(0);
        break;
      case HealthDataSource.healthKit:
        writer.writeByte(1);
        break;
      case HealthDataSource.googleFit:
        writer.writeByte(2);
        break;
      case HealthDataSource.device:
        writer.writeByte(3);
        break;
      case HealthDataSource.app:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDataSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthTrendDirectionAdapter extends TypeAdapter<HealthTrendDirection> {
  @override
  final int typeId = 142;

  @override
  HealthTrendDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthTrendDirection.increasing;
      case 1:
        return HealthTrendDirection.decreasing;
      case 2:
        return HealthTrendDirection.stable;
      default:
        return HealthTrendDirection.increasing;
    }
  }

  @override
  void write(BinaryWriter writer, HealthTrendDirection obj) {
    switch (obj) {
      case HealthTrendDirection.increasing:
        writer.writeByte(0);
        break;
      case HealthTrendDirection.decreasing:
        writer.writeByte(1);
        break;
      case HealthTrendDirection.stable:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthTrendDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthGoalTypeAdapter extends TypeAdapter<HealthGoalType> {
  @override
  final int typeId = 143;

  @override
  HealthGoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthGoalType.target;
      case 1:
        return HealthGoalType.minimum;
      case 2:
        return HealthGoalType.maximum;
      case 3:
        return HealthGoalType.range;
      default:
        return HealthGoalType.target;
    }
  }

  @override
  void write(BinaryWriter writer, HealthGoalType obj) {
    switch (obj) {
      case HealthGoalType.target:
        writer.writeByte(0);
        break;
      case HealthGoalType.minimum:
        writer.writeByte(1);
        break;
      case HealthGoalType.maximum:
        writer.writeByte(2);
        break;
      case HealthGoalType.range:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthGoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthInsightTypeAdapter extends TypeAdapter<HealthInsightType> {
  @override
  final int typeId = 144;

  @override
  HealthInsightType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthInsightType.suggestion;
      case 1:
        return HealthInsightType.warning;
      case 2:
        return HealthInsightType.achievement;
      case 3:
        return HealthInsightType.trend;
      case 4:
        return HealthInsightType.recommendation;
      default:
        return HealthInsightType.suggestion;
    }
  }

  @override
  void write(BinaryWriter writer, HealthInsightType obj) {
    switch (obj) {
      case HealthInsightType.suggestion:
        writer.writeByte(0);
        break;
      case HealthInsightType.warning:
        writer.writeByte(1);
        break;
      case HealthInsightType.achievement:
        writer.writeByte(2);
        break;
      case HealthInsightType.trend:
        writer.writeByte(3);
        break;
      case HealthInsightType.recommendation:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthInsightTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthInsightPriorityAdapter extends TypeAdapter<HealthInsightPriority> {
  @override
  final int typeId = 145;

  @override
  HealthInsightPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthInsightPriority.low;
      case 1:
        return HealthInsightPriority.medium;
      case 2:
        return HealthInsightPriority.high;
      case 3:
        return HealthInsightPriority.critical;
      default:
        return HealthInsightPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, HealthInsightPriority obj) {
    switch (obj) {
      case HealthInsightPriority.low:
        writer.writeByte(0);
        break;
      case HealthInsightPriority.medium:
        writer.writeByte(1);
        break;
      case HealthInsightPriority.high:
        writer.writeByte(2);
        break;
      case HealthInsightPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthInsightPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
