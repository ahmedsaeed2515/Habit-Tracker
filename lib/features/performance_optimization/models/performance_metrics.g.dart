// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_metrics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerformanceMetricsAdapter extends TypeAdapter<PerformanceMetrics> {
  @override
  final int typeId = 105;

  @override
  PerformanceMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PerformanceMetrics(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      appPerformance: fields[2] as AppPerformanceData,
      databasePerformance: fields[3] as DatabasePerformanceData,
      memoryUsage: fields[4] as MemoryUsageData,
      networkPerformance: fields[5] as NetworkPerformanceData,
      uiPerformance: fields[6] as UIPerformanceData,
      customMetrics: (fields[7] as Map).cast<String, dynamic>(),
      deviceInfo: fields[8] as DeviceInfo,
    );
  }

  @override
  void write(BinaryWriter writer, PerformanceMetrics obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.appPerformance)
      ..writeByte(3)
      ..write(obj.databasePerformance)
      ..writeByte(4)
      ..write(obj.memoryUsage)
      ..writeByte(5)
      ..write(obj.networkPerformance)
      ..writeByte(6)
      ..write(obj.uiPerformance)
      ..writeByte(7)
      ..write(obj.customMetrics)
      ..writeByte(8)
      ..write(obj.deviceInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppPerformanceDataAdapter extends TypeAdapter<AppPerformanceData> {
  @override
  final int typeId = 106;

  @override
  AppPerformanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPerformanceData(
      startupTime: fields[0] as int,
      cpuUsage: fields[1] as double,
      batteryUsage: fields[2] as int,
      crashCount: fields[3] as int,
      featureUsageTimes: (fields[4] as Map).cast<String, int>(),
      totalSessionTime: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppPerformanceData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.startupTime)
      ..writeByte(1)
      ..write(obj.cpuUsage)
      ..writeByte(2)
      ..write(obj.batteryUsage)
      ..writeByte(3)
      ..write(obj.crashCount)
      ..writeByte(4)
      ..write(obj.featureUsageTimes)
      ..writeByte(5)
      ..write(obj.totalSessionTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPerformanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DatabasePerformanceDataAdapter
    extends TypeAdapter<DatabasePerformanceData> {
  @override
  final int typeId = 107;

  @override
  DatabasePerformanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatabasePerformanceData(
      averageQueryTime: fields[0] as double,
      totalQueries: fields[1] as int,
      slowQueries: fields[2] as int,
      failedQueries: fields[3] as int,
      queryMetrics: (fields[4] as Map).cast<String, QueryMetrics>(),
      databaseSize: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DatabasePerformanceData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.averageQueryTime)
      ..writeByte(1)
      ..write(obj.totalQueries)
      ..writeByte(2)
      ..write(obj.slowQueries)
      ..writeByte(3)
      ..write(obj.failedQueries)
      ..writeByte(4)
      ..write(obj.queryMetrics)
      ..writeByte(5)
      ..write(obj.databaseSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabasePerformanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueryMetricsAdapter extends TypeAdapter<QueryMetrics> {
  @override
  final int typeId = 108;

  @override
  QueryMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueryMetrics(
      queryType: fields[0] as String,
      averageTime: fields[1] as double,
      executionCount: fields[2] as int,
      minTime: fields[3] as double,
      maxTime: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, QueryMetrics obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.queryType)
      ..writeByte(1)
      ..write(obj.averageTime)
      ..writeByte(2)
      ..write(obj.executionCount)
      ..writeByte(3)
      ..write(obj.minTime)
      ..writeByte(4)
      ..write(obj.maxTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemoryUsageDataAdapter extends TypeAdapter<MemoryUsageData> {
  @override
  final int typeId = 109;

  @override
  MemoryUsageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoryUsageData(
      usedMemory: fields[0] as int,
      totalMemory: fields[1] as int,
      memoryUsagePercentage: fields[2] as double,
      snapshots: (fields[3] as List).cast<MemorySnapshot>(),
      memoryLeaks: fields[4] as int,
      memoryByFeature: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, MemoryUsageData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.usedMemory)
      ..writeByte(1)
      ..write(obj.totalMemory)
      ..writeByte(2)
      ..write(obj.memoryUsagePercentage)
      ..writeByte(3)
      ..write(obj.snapshots)
      ..writeByte(4)
      ..write(obj.memoryLeaks)
      ..writeByte(5)
      ..write(obj.memoryByFeature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryUsageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemorySnapshotAdapter extends TypeAdapter<MemorySnapshot> {
  @override
  final int typeId = 110;

  @override
  MemorySnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemorySnapshot(
      timestamp: fields[0] as DateTime,
      usedMemory: fields[1] as int,
      context: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemorySnapshot obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.usedMemory)
      ..writeByte(2)
      ..write(obj.context);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemorySnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NetworkPerformanceDataAdapter
    extends TypeAdapter<NetworkPerformanceData> {
  @override
  final int typeId = 111;

  @override
  NetworkPerformanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NetworkPerformanceData(
      averageResponseTime: fields[0] as double,
      successfulRequests: fields[1] as int,
      failedRequests: fields[2] as int,
      totalDataTransferred: fields[3] as int,
      endpointMetrics: (fields[4] as Map).cast<String, EndpointMetrics>(),
      connectionType: fields[5] as ConnectionType,
    );
  }

  @override
  void write(BinaryWriter writer, NetworkPerformanceData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.averageResponseTime)
      ..writeByte(1)
      ..write(obj.successfulRequests)
      ..writeByte(2)
      ..write(obj.failedRequests)
      ..writeByte(3)
      ..write(obj.totalDataTransferred)
      ..writeByte(4)
      ..write(obj.endpointMetrics)
      ..writeByte(5)
      ..write(obj.connectionType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkPerformanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EndpointMetricsAdapter extends TypeAdapter<EndpointMetrics> {
  @override
  final int typeId = 112;

  @override
  EndpointMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EndpointMetrics(
      endpoint: fields[0] as String,
      averageResponseTime: fields[1] as double,
      requestCount: fields[2] as int,
      errorCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EndpointMetrics obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.endpoint)
      ..writeByte(1)
      ..write(obj.averageResponseTime)
      ..writeByte(2)
      ..write(obj.requestCount)
      ..writeByte(3)
      ..write(obj.errorCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UIPerformanceDataAdapter extends TypeAdapter<UIPerformanceData> {
  @override
  final int typeId = 113;

  @override
  UIPerformanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UIPerformanceData(
      averageFrameTime: fields[0] as double,
      droppedFrames: fields[1] as int,
      scrollPerformance: fields[2] as double,
      screenMetrics: (fields[3] as Map).cast<String, ScreenMetrics>(),
      animationLags: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UIPerformanceData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.averageFrameTime)
      ..writeByte(1)
      ..write(obj.droppedFrames)
      ..writeByte(2)
      ..write(obj.scrollPerformance)
      ..writeByte(3)
      ..write(obj.screenMetrics)
      ..writeByte(4)
      ..write(obj.animationLags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UIPerformanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScreenMetricsAdapter extends TypeAdapter<ScreenMetrics> {
  @override
  final int typeId = 114;

  @override
  ScreenMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScreenMetrics(
      screenName: fields[0] as String,
      loadTime: fields[1] as double,
      renderTime: fields[2] as int,
      interactionCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScreenMetrics obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.screenName)
      ..writeByte(1)
      ..write(obj.loadTime)
      ..writeByte(2)
      ..write(obj.renderTime)
      ..writeByte(3)
      ..write(obj.interactionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceInfoAdapter extends TypeAdapter<DeviceInfo> {
  @override
  final int typeId = 115;

  @override
  DeviceInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceInfo(
      deviceModel: fields[0] as String,
      osVersion: fields[1] as String,
      ramSize: fields[2] as int,
      storageSize: fields[3] as int,
      cpuType: fields[4] as String,
      screenDensity: fields[5] as double,
      screenResolution: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeviceInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.deviceModel)
      ..writeByte(1)
      ..write(obj.osVersion)
      ..writeByte(2)
      ..write(obj.ramSize)
      ..writeByte(3)
      ..write(obj.storageSize)
      ..writeByte(4)
      ..write(obj.cpuType)
      ..writeByte(5)
      ..write(obj.screenDensity)
      ..writeByte(6)
      ..write(obj.screenResolution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PerformanceIssueAdapter extends TypeAdapter<PerformanceIssue> {
  @override
  final int typeId = 117;

  @override
  PerformanceIssue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PerformanceIssue();
  }

  @override
  void write(BinaryWriter writer, PerformanceIssue obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PerformanceLevelAdapter extends TypeAdapter<PerformanceLevel> {
  @override
  final int typeId = 116;

  @override
  PerformanceLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PerformanceLevel.excellent;
      case 1:
        return PerformanceLevel.good;
      case 2:
        return PerformanceLevel.fair;
      case 3:
        return PerformanceLevel.poor;
      default:
        return PerformanceLevel.excellent;
    }
  }

  @override
  void write(BinaryWriter writer, PerformanceLevel obj) {
    switch (obj) {
      case PerformanceLevel.excellent:
        writer.writeByte(0);
        break;
      case PerformanceLevel.good:
        writer.writeByte(1);
        break;
      case PerformanceLevel.fair:
        writer.writeByte(2);
        break;
      case PerformanceLevel.poor:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueTypeAdapter extends TypeAdapter<IssueType> {
  @override
  final int typeId = 118;

  @override
  IssueType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueType.slowStartup;
      case 1:
        return IssueType.slowDatabase;
      case 2:
        return IssueType.highMemoryUsage;
      case 3:
        return IssueType.networkLatency;
      case 4:
        return IssueType.uiLag;
      case 5:
        return IssueType.batterydrain;
      case 6:
        return IssueType.memoryLeak;
      default:
        return IssueType.slowStartup;
    }
  }

  @override
  void write(BinaryWriter writer, IssueType obj) {
    switch (obj) {
      case IssueType.slowStartup:
        writer.writeByte(0);
        break;
      case IssueType.slowDatabase:
        writer.writeByte(1);
        break;
      case IssueType.highMemoryUsage:
        writer.writeByte(2);
        break;
      case IssueType.networkLatency:
        writer.writeByte(3);
        break;
      case IssueType.uiLag:
        writer.writeByte(4);
        break;
      case IssueType.batterydrain:
        writer.writeByte(5);
        break;
      case IssueType.memoryLeak:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueSeverityAdapter extends TypeAdapter<IssueSeverity> {
  @override
  final int typeId = 119;

  @override
  IssueSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueSeverity.low;
      case 1:
        return IssueSeverity.medium;
      case 2:
        return IssueSeverity.high;
      case 3:
        return IssueSeverity.critical;
      default:
        return IssueSeverity.low;
    }
  }

  @override
  void write(BinaryWriter writer, IssueSeverity obj) {
    switch (obj) {
      case IssueSeverity.low:
        writer.writeByte(0);
        break;
      case IssueSeverity.medium:
        writer.writeByte(1);
        break;
      case IssueSeverity.high:
        writer.writeByte(2);
        break;
      case IssueSeverity.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConnectionTypeAdapter extends TypeAdapter<ConnectionType> {
  @override
  final int typeId = 120;

  @override
  ConnectionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConnectionType.none;
      case 1:
        return ConnectionType.wifi;
      case 2:
        return ConnectionType.mobile;
      case 3:
        return ConnectionType.ethernet;
      case 4:
        return ConnectionType.other;
      default:
        return ConnectionType.none;
    }
  }

  @override
  void write(BinaryWriter writer, ConnectionType obj) {
    switch (obj) {
      case ConnectionType.none:
        writer.writeByte(0);
        break;
      case ConnectionType.wifi:
        writer.writeByte(1);
        break;
      case ConnectionType.mobile:
        writer.writeByte(2);
        break;
      case ConnectionType.ethernet:
        writer.writeByte(3);
        break;
      case ConnectionType.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
