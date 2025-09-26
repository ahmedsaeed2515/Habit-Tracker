// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WidgetConfigAdapter extends TypeAdapter<WidgetConfig> {
  @override
  final int typeId = 73;

  @override
  WidgetConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetConfig(
      id: fields[0] as String,
      type: fields[1] as WidgetType,
      title: fields[2] as String,
      size: fields[3] as WidgetSize,
      settings: (fields[4] as Map).cast<String, dynamic>(),
      isEnabled: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      priority: fields[8] as int,
      habitIds: (fields[9] as List).cast<String>(),
      theme: fields[10] as WidgetTheme,
      displayOptions: (fields[11] as Map).cast<String, dynamic>(),
      refreshInterval: fields[12] as RefreshInterval,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetConfig obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.settings)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.habitIds)
      ..writeByte(10)
      ..write(obj.theme)
      ..writeByte(11)
      ..write(obj.displayOptions)
      ..writeByte(12)
      ..write(obj.refreshInterval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetDataAdapter extends TypeAdapter<WidgetData> {
  @override
  final int typeId = 78;

  @override
  WidgetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetData(
      widgetId: fields[0] as String,
      data: (fields[1] as Map).cast<String, dynamic>(),
      lastUpdate: fields[2] as DateTime,
      isValid: fields[3] as bool,
      errorMessage: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.widgetId)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.lastUpdate)
      ..writeByte(3)
      ..write(obj.isValid)
      ..writeByte(4)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetLayoutAdapter extends TypeAdapter<WidgetLayout> {
  @override
  final int typeId = 79;

  @override
  WidgetLayout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetLayout(
      id: fields[0] as String,
      name: fields[1] as String,
      positions: (fields[2] as List).cast<WidgetPosition>(),
      isDefault: fields[3] as bool,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetLayout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.positions)
      ..writeByte(3)
      ..write(obj.isDefault)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetLayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetPositionAdapter extends TypeAdapter<WidgetPosition> {
  @override
  final int typeId = 80;

  @override
  WidgetPosition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetPosition(
      widgetId: fields[0] as String,
      x: fields[1] as int,
      y: fields[2] as int,
      width: fields[3] as int,
      height: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetPosition obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.widgetId)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetPositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetTypeAdapter extends TypeAdapter<WidgetType> {
  @override
  final int typeId = 74;

  @override
  WidgetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WidgetType.habitProgress;
      case 1:
        return WidgetType.todayTasks;
      case 2:
        return WidgetType.weeklyProgress;
      case 3:
        return WidgetType.motivationalQuote;
      case 4:
        return WidgetType.streakCounter;
      case 5:
        return WidgetType.statisticsOverview;
      case 6:
        return WidgetType.upcomingReminders;
      case 7:
        return WidgetType.achievementsBadges;
      default:
        return WidgetType.habitProgress;
    }
  }

  @override
  void write(BinaryWriter writer, WidgetType obj) {
    switch (obj) {
      case WidgetType.habitProgress:
        writer.writeByte(0);
        break;
      case WidgetType.todayTasks:
        writer.writeByte(1);
        break;
      case WidgetType.weeklyProgress:
        writer.writeByte(2);
        break;
      case WidgetType.motivationalQuote:
        writer.writeByte(3);
        break;
      case WidgetType.streakCounter:
        writer.writeByte(4);
        break;
      case WidgetType.statisticsOverview:
        writer.writeByte(5);
        break;
      case WidgetType.upcomingReminders:
        writer.writeByte(6);
        break;
      case WidgetType.achievementsBadges:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetSizeAdapter extends TypeAdapter<WidgetSize> {
  @override
  final int typeId = 75;

  @override
  WidgetSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WidgetSize.small;
      case 1:
        return WidgetSize.medium;
      case 2:
        return WidgetSize.large;
      default:
        return WidgetSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, WidgetSize obj) {
    switch (obj) {
      case WidgetSize.small:
        writer.writeByte(0);
        break;
      case WidgetSize.medium:
        writer.writeByte(1);
        break;
      case WidgetSize.large:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetThemeAdapter extends TypeAdapter<WidgetTheme> {
  @override
  final int typeId = 76;

  @override
  WidgetTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WidgetTheme.system;
      case 1:
        return WidgetTheme.light;
      case 2:
        return WidgetTheme.dark;
      case 3:
        return WidgetTheme.custom;
      default:
        return WidgetTheme.system;
    }
  }

  @override
  void write(BinaryWriter writer, WidgetTheme obj) {
    switch (obj) {
      case WidgetTheme.system:
        writer.writeByte(0);
        break;
      case WidgetTheme.light:
        writer.writeByte(1);
        break;
      case WidgetTheme.dark:
        writer.writeByte(2);
        break;
      case WidgetTheme.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RefreshIntervalAdapter extends TypeAdapter<RefreshInterval> {
  @override
  final int typeId = 77;

  @override
  RefreshInterval read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RefreshInterval.manual;
      case 1:
        return RefreshInterval.minutes1;
      case 2:
        return RefreshInterval.minutes5;
      case 3:
        return RefreshInterval.minutes15;
      case 4:
        return RefreshInterval.minutes30;
      case 5:
        return RefreshInterval.hour1;
      default:
        return RefreshInterval.manual;
    }
  }

  @override
  void write(BinaryWriter writer, RefreshInterval obj) {
    switch (obj) {
      case RefreshInterval.manual:
        writer.writeByte(0);
        break;
      case RefreshInterval.minutes1:
        writer.writeByte(1);
        break;
      case RefreshInterval.minutes5:
        writer.writeByte(2);
        break;
      case RefreshInterval.minutes15:
        writer.writeByte(3);
        break;
      case RefreshInterval.minutes30:
        writer.writeByte(4);
        break;
      case RefreshInterval.hour1:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefreshIntervalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
