// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineDataAdapter extends TypeAdapter<OfflineData> {
  @override
  final int typeId = 81;

  @override
  OfflineData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineData(
      id: fields[0] as String,
      collection: fields[1] as String,
      documentId: fields[2] as String,
      data: (fields[3] as Map).cast<String, dynamic>(),
      action: fields[4] as OfflineAction,
      timestamp: fields[5] as DateTime,
      status: fields[6] as OfflineStatus,
      retryCount: fields[7] as int,
      errorMessage: fields[8] as String?,
      metadata: (fields[9] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collection)
      ..writeByte(2)
      ..write(obj.documentId)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.errorMessage)
      ..writeByte(9)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineCacheAdapter extends TypeAdapter<OfflineCache> {
  @override
  final int typeId = 84;

  @override
  OfflineCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineCache(
      key: fields[0] as String,
      data: (fields[1] as Map).cast<String, dynamic>(),
      cachedAt: fields[2] as DateTime,
      validFor: fields[3] as Duration,
      accessCount: fields[4] as int,
      lastAccessed: fields[5] as DateTime,
      tags: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OfflineCache obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.validFor)
      ..writeByte(4)
      ..write(obj.accessCount)
      ..writeByte(5)
      ..write(obj.lastAccessed)
      ..writeByte(6)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncSessionAdapter extends TypeAdapter<SyncSession> {
  @override
  final int typeId = 85;

  @override
  SyncSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncSession(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      status: fields[3] as SyncStatus,
      totalOperations: fields[4] as int,
      successfulOperations: fields[5] as int,
      failedOperations: fields[6] as int,
      errors: (fields[7] as List).cast<String>(),
      statistics: (fields[8] as Map).cast<String, dynamic>(),
      trigger: fields[9] as SyncTrigger,
    );
  }

  @override
  void write(BinaryWriter writer, SyncSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.totalOperations)
      ..writeByte(5)
      ..write(obj.successfulOperations)
      ..writeByte(6)
      ..write(obj.failedOperations)
      ..writeByte(7)
      ..write(obj.errors)
      ..writeByte(8)
      ..write(obj.statistics)
      ..writeByte(9)
      ..write(obj.trigger);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NetworkStatusAdapter extends TypeAdapter<NetworkStatus> {
  @override
  final int typeId = 88;

  @override
  NetworkStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NetworkStatus(
      isConnected: fields[0] as bool,
      connectionType: fields[1] as ConnectionType,
      lastChecked: fields[2] as DateTime,
      signalStrength: fields[3] as int,
      isMetered: fields[4] as bool,
      additionalInfo: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, NetworkStatus obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isConnected)
      ..writeByte(1)
      ..write(obj.connectionType)
      ..writeByte(2)
      ..write(obj.lastChecked)
      ..writeByte(3)
      ..write(obj.signalStrength)
      ..writeByte(4)
      ..write(obj.isMetered)
      ..writeByte(5)
      ..write(obj.additionalInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConflictResolutionAdapter extends TypeAdapter<ConflictResolution> {
  @override
  final int typeId = 90;

  @override
  ConflictResolution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConflictResolution(
      id: fields[0] as String,
      collection: fields[1] as String,
      documentId: fields[2] as String,
      localData: (fields[3] as Map).cast<String, dynamic>(),
      remoteData: (fields[4] as Map).cast<String, dynamic>(),
      resolvedData: (fields[5] as Map?)?.cast<String, dynamic>(),
      strategy: fields[6] as ConflictResolutionStrategy,
      createdAt: fields[7] as DateTime,
      resolvedAt: fields[8] as DateTime?,
      isResolved: fields[9] as bool,
      resolutionNote: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConflictResolution obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collection)
      ..writeByte(2)
      ..write(obj.documentId)
      ..writeByte(3)
      ..write(obj.localData)
      ..writeByte(4)
      ..write(obj.remoteData)
      ..writeByte(5)
      ..write(obj.resolvedData)
      ..writeByte(6)
      ..write(obj.strategy)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.resolvedAt)
      ..writeByte(9)
      ..write(obj.isResolved)
      ..writeByte(10)
      ..write(obj.resolutionNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConflictResolutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineActionAdapter extends TypeAdapter<OfflineAction> {
  @override
  final int typeId = 82;

  @override
  OfflineAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OfflineAction.create;
      case 1:
        return OfflineAction.update;
      case 2:
        return OfflineAction.delete;
      default:
        return OfflineAction.create;
    }
  }

  @override
  void write(BinaryWriter writer, OfflineAction obj) {
    switch (obj) {
      case OfflineAction.create:
        writer.writeByte(0);
        break;
      case OfflineAction.update:
        writer.writeByte(1);
        break;
      case OfflineAction.delete:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineStatusAdapter extends TypeAdapter<OfflineStatus> {
  @override
  final int typeId = 83;

  @override
  OfflineStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OfflineStatus.pending;
      case 1:
        return OfflineStatus.syncing;
      case 2:
        return OfflineStatus.synced;
      case 3:
        return OfflineStatus.failed;
      case 4:
        return OfflineStatus.conflict;
      default:
        return OfflineStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OfflineStatus obj) {
    switch (obj) {
      case OfflineStatus.pending:
        writer.writeByte(0);
        break;
      case OfflineStatus.syncing:
        writer.writeByte(1);
        break;
      case OfflineStatus.synced:
        writer.writeByte(2);
        break;
      case OfflineStatus.failed:
        writer.writeByte(3);
        break;
      case OfflineStatus.conflict:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 86;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.running;
      case 1:
        return SyncStatus.completed;
      case 2:
        return SyncStatus.failed;
      case 3:
        return SyncStatus.cancelled;
      default:
        return SyncStatus.running;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.running:
        writer.writeByte(0);
        break;
      case SyncStatus.completed:
        writer.writeByte(1);
        break;
      case SyncStatus.failed:
        writer.writeByte(2);
        break;
      case SyncStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncTriggerAdapter extends TypeAdapter<SyncTrigger> {
  @override
  final int typeId = 87;

  @override
  SyncTrigger read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncTrigger.manual;
      case 1:
        return SyncTrigger.automatic;
      case 2:
        return SyncTrigger.network;
      case 3:
        return SyncTrigger.scheduled;
      case 4:
        return SyncTrigger.appStart;
      case 5:
        return SyncTrigger.appClose;
      default:
        return SyncTrigger.manual;
    }
  }

  @override
  void write(BinaryWriter writer, SyncTrigger obj) {
    switch (obj) {
      case SyncTrigger.manual:
        writer.writeByte(0);
        break;
      case SyncTrigger.automatic:
        writer.writeByte(1);
        break;
      case SyncTrigger.network:
        writer.writeByte(2);
        break;
      case SyncTrigger.scheduled:
        writer.writeByte(3);
        break;
      case SyncTrigger.appStart:
        writer.writeByte(4);
        break;
      case SyncTrigger.appClose:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConnectionTypeAdapter extends TypeAdapter<ConnectionType> {
  @override
  final int typeId = 89;

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

class ConflictResolutionStrategyAdapter
    extends TypeAdapter<ConflictResolutionStrategy> {
  @override
  final int typeId = 91;

  @override
  ConflictResolutionStrategy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConflictResolutionStrategy.localWins;
      case 1:
        return ConflictResolutionStrategy.remoteWins;
      case 2:
        return ConflictResolutionStrategy.mostRecent;
      case 3:
        return ConflictResolutionStrategy.merge;
      case 4:
        return ConflictResolutionStrategy.manual;
      default:
        return ConflictResolutionStrategy.localWins;
    }
  }

  @override
  void write(BinaryWriter writer, ConflictResolutionStrategy obj) {
    switch (obj) {
      case ConflictResolutionStrategy.localWins:
        writer.writeByte(0);
        break;
      case ConflictResolutionStrategy.remoteWins:
        writer.writeByte(1);
        break;
      case ConflictResolutionStrategy.mostRecent:
        writer.writeByte(2);
        break;
      case ConflictResolutionStrategy.merge:
        writer.writeByte(3);
        break;
      case ConflictResolutionStrategy.manual:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConflictResolutionStrategyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
