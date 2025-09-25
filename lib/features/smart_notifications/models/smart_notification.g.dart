// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmartNotificationAdapter extends TypeAdapter<SmartNotification> {
  @override
  final int typeId = 10;

  @override
  SmartNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartNotification(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      type: fields[3] as NotificationType,
      scheduledTime: fields[4] as DateTime,
      habitId: fields[5] as String?,
      taskId: fields[6] as String?,
      isActive: fields[7] as bool,
      repeatDays: (fields[8] as List).cast<int>(),
      priority: fields[9] as NotificationPriority,
      customData: (fields[10] as Map).cast<String, String>(),
      createdAt: fields[11] as DateTime,
      lastSent: fields[12] as DateTime?,
      sentCount: fields[13] as int,
      isSmartTiming: fields[14] as bool,
      motivationalMessage: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SmartNotification obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.scheduledTime)
      ..writeByte(5)
      ..write(obj.habitId)
      ..writeByte(6)
      ..write(obj.taskId)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.repeatDays)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.customData)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.lastSent)
      ..writeByte(13)
      ..write(obj.sentCount)
      ..writeByte(14)
      ..write(obj.isSmartTiming)
      ..writeByte(15)
      ..write(obj.motivationalMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 11;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.habit;
      case 1:
        return NotificationType.task;
      case 2:
        return NotificationType.workout;
      case 3:
        return NotificationType.morningExercise;
      case 4:
        return NotificationType.motivational;
      case 5:
        return NotificationType.achievement;
      case 6:
        return NotificationType.streak;
      case 7:
        return NotificationType.reminder;
      case 8:
        return NotificationType.weeklyReport;
      default:
        return NotificationType.habit;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.habit:
        writer.writeByte(0);
        break;
      case NotificationType.task:
        writer.writeByte(1);
        break;
      case NotificationType.workout:
        writer.writeByte(2);
        break;
      case NotificationType.morningExercise:
        writer.writeByte(3);
        break;
      case NotificationType.motivational:
        writer.writeByte(4);
        break;
      case NotificationType.achievement:
        writer.writeByte(5);
        break;
      case NotificationType.streak:
        writer.writeByte(6);
        break;
      case NotificationType.reminder:
        writer.writeByte(7);
        break;
      case NotificationType.weeklyReport:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationPriorityAdapter extends TypeAdapter<NotificationPriority> {
  @override
  final int typeId = 12;

  @override
  NotificationPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationPriority.low;
      case 1:
        return NotificationPriority.normal;
      case 2:
        return NotificationPriority.high;
      case 3:
        return NotificationPriority.critical;
      default:
        return NotificationPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationPriority obj) {
    switch (obj) {
      case NotificationPriority.low:
        writer.writeByte(0);
        break;
      case NotificationPriority.normal:
        writer.writeByte(1);
        break;
      case NotificationPriority.high:
        writer.writeByte(2);
        break;
      case NotificationPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
