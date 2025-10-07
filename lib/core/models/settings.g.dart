// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 13;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      language: fields[0] as String,
      isDarkMode: fields[1] as bool,
      notificationsEnabled: fields[2] as bool,
      dailyReminderTime: fields[3] as AppTimeOfDay?,
      alarmEnabled: fields[4] as bool,
      alarmTime: fields[5] as AppTimeOfDay?,
      customAlarmSoundPath: fields[6] as String?,
      alarmVolume: fields[7] as double,
      vibrationEnabled: fields[8] as bool,
      defaultAlarmSound: fields[9] as String,
      weekendAlarmsEnabled: fields[10] as bool,
      alarmDays: (fields[11] as List).cast<int>(),
      autoBackupEnabled: fields[12] as bool,
      lastBackupDate: fields[13] as DateTime?,
      isFirstTime: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.isDarkMode)
      ..writeByte(2)
      ..write(obj.notificationsEnabled)
      ..writeByte(3)
      ..write(obj.dailyReminderTime)
      ..writeByte(4)
      ..write(obj.alarmEnabled)
      ..writeByte(5)
      ..write(obj.alarmTime)
      ..writeByte(6)
      ..write(obj.customAlarmSoundPath)
      ..writeByte(7)
      ..write(obj.alarmVolume)
      ..writeByte(8)
      ..write(obj.vibrationEnabled)
      ..writeByte(9)
      ..write(obj.defaultAlarmSound)
      ..writeByte(10)
      ..write(obj.weekendAlarmsEnabled)
      ..writeByte(11)
      ..write(obj.alarmDays)
      ..writeByte(12)
      ..write(obj.autoBackupEnabled)
      ..writeByte(13)
      ..write(obj.lastBackupDate)
      ..writeByte(14)
      ..write(obj.isFirstTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppTimeOfDayAdapter extends TypeAdapter<AppTimeOfDay> {
  @override
  final int typeId = 14;

  @override
  AppTimeOfDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppTimeOfDay(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppTimeOfDay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTimeOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
