// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BackupDataAdapter extends TypeAdapter<BackupData> {
  @override
  final int typeId = 49;

  @override
  BackupData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackupData(
      id: fields[0] as String,
      userId: fields[1] as String,
      createdAt: fields[2] as DateTime,
      version: fields[3] as String,
      habitsData: (fields[4] as Map).cast<String, dynamic>(),
      analyticsData: (fields[5] as Map).cast<String, dynamic>(),
      settingsData: (fields[6] as Map).cast<String, dynamic>(),
      gamificationData: (fields[7] as Map).cast<String, dynamic>(),
      healthData: (fields[8] as Map).cast<String, dynamic>(),
      themingData: (fields[9] as Map).cast<String, dynamic>(),
      dataSize: fields[10] as int,
      type: fields[11] as BackupType,
      status: fields[12] as BackupStatus,
      cloudPath: fields[13] as String?,
      errorMessage: fields[14] as String?,
      lastSync: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BackupData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.version)
      ..writeByte(4)
      ..write(obj.habitsData)
      ..writeByte(5)
      ..write(obj.analyticsData)
      ..writeByte(6)
      ..write(obj.settingsData)
      ..writeByte(7)
      ..write(obj.gamificationData)
      ..writeByte(8)
      ..write(obj.healthData)
      ..writeByte(9)
      ..write(obj.themingData)
      ..writeByte(10)
      ..write(obj.dataSize)
      ..writeByte(11)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.cloudPath)
      ..writeByte(14)
      ..write(obj.errorMessage)
      ..writeByte(15)
      ..write(obj.lastSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncSettingsAdapter extends TypeAdapter<SyncSettings> {
  @override
  final int typeId = 52;

  @override
  SyncSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncSettings(
      enableAutoSync: fields[0] as bool,
      syncIntervalHours: fields[1] as int,
      syncOnWiFiOnly: fields[2] as bool,
      syncHabits: fields[3] as bool,
      syncAnalytics: fields[4] as bool,
      syncSettings: fields[5] as bool,
      syncGamification: fields[6] as bool,
      syncHealth: fields[7] as bool,
      syncTheming: fields[8] as bool,
      lastAutoSync: fields[9] as DateTime,
      cloudProvider: fields[10] as String,
      maxBackups: fields[11] as int,
      deleteOldBackups: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SyncSettings obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.enableAutoSync)
      ..writeByte(1)
      ..write(obj.syncIntervalHours)
      ..writeByte(2)
      ..write(obj.syncOnWiFiOnly)
      ..writeByte(3)
      ..write(obj.syncHabits)
      ..writeByte(4)
      ..write(obj.syncAnalytics)
      ..writeByte(5)
      ..write(obj.syncSettings)
      ..writeByte(6)
      ..write(obj.syncGamification)
      ..writeByte(7)
      ..write(obj.syncHealth)
      ..writeByte(8)
      ..write(obj.syncTheming)
      ..writeByte(9)
      ..write(obj.lastAutoSync)
      ..writeByte(10)
      ..write(obj.cloudProvider)
      ..writeByte(11)
      ..write(obj.maxBackups)
      ..writeByte(12)
      ..write(obj.deleteOldBackups);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConflictResolutionAdapter extends TypeAdapter<ConflictResolution> {
  @override
  final int typeId = 53;

  @override
  ConflictResolution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConflictResolution(
      id: fields[0] as String,
      dataType: fields[1] as String,
      localData: (fields[2] as Map).cast<String, dynamic>(),
      remoteData: (fields[3] as Map).cast<String, dynamic>(),
      conflictTime: fields[4] as DateTime,
      resolution: fields[5] as ResolutionStrategy?,
      isResolved: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ConflictResolution obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dataType)
      ..writeByte(2)
      ..write(obj.localData)
      ..writeByte(3)
      ..write(obj.remoteData)
      ..writeByte(4)
      ..write(obj.conflictTime)
      ..writeByte(5)
      ..write(obj.resolution)
      ..writeByte(6)
      ..write(obj.isResolved);
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

class BackupTypeAdapter extends TypeAdapter<BackupType> {
  @override
  final int typeId = 50;

  @override
  BackupType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BackupType.manual;
      case 1:
        return BackupType.automatic;
      case 2:
        return BackupType.scheduled;
      case 3:
        return BackupType.imported;
      default:
        return BackupType.manual;
    }
  }

  @override
  void write(BinaryWriter writer, BackupType obj) {
    switch (obj) {
      case BackupType.manual:
        writer.writeByte(0);
        break;
      case BackupType.automatic:
        writer.writeByte(1);
        break;
      case BackupType.scheduled:
        writer.writeByte(2);
        break;
      case BackupType.imported:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BackupStatusAdapter extends TypeAdapter<BackupStatus> {
  @override
  final int typeId = 51;

  @override
  BackupStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BackupStatus.pending;
      case 1:
        return BackupStatus.inProgress;
      case 2:
        return BackupStatus.completed;
      case 3:
        return BackupStatus.failed;
      case 4:
        return BackupStatus.cancelled;
      default:
        return BackupStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, BackupStatus obj) {
    switch (obj) {
      case BackupStatus.pending:
        writer.writeByte(0);
        break;
      case BackupStatus.inProgress:
        writer.writeByte(1);
        break;
      case BackupStatus.completed:
        writer.writeByte(2);
        break;
      case BackupStatus.failed:
        writer.writeByte(3);
        break;
      case BackupStatus.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResolutionStrategyAdapter extends TypeAdapter<ResolutionStrategy> {
  @override
  final int typeId = 54;

  @override
  ResolutionStrategy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResolutionStrategy.useLocal;
      case 1:
        return ResolutionStrategy.useRemote;
      case 2:
        return ResolutionStrategy.merge;
      case 3:
        return ResolutionStrategy.useLatest;
      default:
        return ResolutionStrategy.useLocal;
    }
  }

  @override
  void write(BinaryWriter writer, ResolutionStrategy obj) {
    switch (obj) {
      case ResolutionStrategy.useLocal:
        writer.writeByte(0);
        break;
      case ResolutionStrategy.useRemote:
        writer.writeByte(1);
        break;
      case ResolutionStrategy.merge:
        writer.writeByte(2);
        break;
      case ResolutionStrategy.useLatest:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolutionStrategyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
