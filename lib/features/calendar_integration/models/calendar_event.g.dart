// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarEventAdapter extends TypeAdapter<CalendarEvent> {
  @override
  final int typeId = 63;

  @override
  CalendarEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      type: fields[5] as EventType,
      habitId: fields[6] as String?,
      isAllDay: fields[7] as bool,
      recurrence: fields[8] as EventRecurrence?,
      reminders: (fields[9] as List).cast<EventReminder>(),
      color: fields[10] as String,
      status: fields[11] as EventStatus,
      metadata: (fields[12] as Map).cast<String, dynamic>(),
      location: fields[13] as String?,
      attendees: (fields[14] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarEvent obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.habitId)
      ..writeByte(7)
      ..write(obj.isAllDay)
      ..writeByte(8)
      ..write(obj.recurrence)
      ..writeByte(9)
      ..write(obj.reminders)
      ..writeByte(10)
      ..write(obj.color)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.metadata)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.attendees);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventRecurrenceAdapter extends TypeAdapter<EventRecurrence> {
  @override
  final int typeId = 66;

  @override
  EventRecurrence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventRecurrence(
      type: fields[0] as RecurrenceType,
      interval: fields[1] as int,
      daysOfWeek: (fields[2] as List).cast<int>(),
      dayOfMonth: fields[3] as int?,
      endDate: fields[4] as DateTime?,
      occurrences: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EventRecurrence obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.daysOfWeek)
      ..writeByte(3)
      ..write(obj.dayOfMonth)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.occurrences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventRecurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventReminderAdapter extends TypeAdapter<EventReminder> {
  @override
  final int typeId = 68;

  @override
  EventReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventReminder(
      id: fields[0] as String,
      type: fields[1] as ReminderType,
      minutesBefore: fields[2] as int,
      message: fields[3] as String,
      isEnabled: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EventReminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.minutesBefore)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarSyncAdapter extends TypeAdapter<CalendarSync> {
  @override
  final int typeId = 70;

  @override
  CalendarSync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarSync(
      id: fields[0] as String,
      name: fields[1] as String,
      provider: fields[2] as CalendarProvider,
      calendarId: fields[3] as String,
      isEnabled: fields[4] as bool,
      lastSync: fields[5] as DateTime,
      direction: fields[6] as SyncDirection,
      syncedTypes: (fields[7] as List).cast<EventType>(),
      settings: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarSync obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.provider)
      ..writeByte(3)
      ..write(obj.calendarId)
      ..writeByte(4)
      ..write(obj.isEnabled)
      ..writeByte(5)
      ..write(obj.lastSync)
      ..writeByte(6)
      ..write(obj.direction)
      ..writeByte(7)
      ..write(obj.syncedTypes)
      ..writeByte(8)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 64;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.habit;
      case 1:
        return EventType.reminder;
      case 2:
        return EventType.appointment;
      case 3:
        return EventType.task;
      case 4:
        return EventType.workout;
      case 5:
        return EventType.meal;
      case 6:
        return EventType.meeting;
      case 7:
        return EventType.personal;
      case 8:
        return EventType.other;
      default:
        return EventType.habit;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.habit:
        writer.writeByte(0);
        break;
      case EventType.reminder:
        writer.writeByte(1);
        break;
      case EventType.appointment:
        writer.writeByte(2);
        break;
      case EventType.task:
        writer.writeByte(3);
        break;
      case EventType.workout:
        writer.writeByte(4);
        break;
      case EventType.meal:
        writer.writeByte(5);
        break;
      case EventType.meeting:
        writer.writeByte(6);
        break;
      case EventType.personal:
        writer.writeByte(7);
        break;
      case EventType.other:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventStatusAdapter extends TypeAdapter<EventStatus> {
  @override
  final int typeId = 65;

  @override
  EventStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventStatus.scheduled;
      case 1:
        return EventStatus.completed;
      case 2:
        return EventStatus.missed;
      case 3:
        return EventStatus.cancelled;
      case 4:
        return EventStatus.postponed;
      default:
        return EventStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, EventStatus obj) {
    switch (obj) {
      case EventStatus.scheduled:
        writer.writeByte(0);
        break;
      case EventStatus.completed:
        writer.writeByte(1);
        break;
      case EventStatus.missed:
        writer.writeByte(2);
        break;
      case EventStatus.cancelled:
        writer.writeByte(3);
        break;
      case EventStatus.postponed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 67;

  @override
  RecurrenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceType.daily;
      case 1:
        return RecurrenceType.weekly;
      case 2:
        return RecurrenceType.monthly;
      case 3:
        return RecurrenceType.yearly;
      default:
        return RecurrenceType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceType obj) {
    switch (obj) {
      case RecurrenceType.daily:
        writer.writeByte(0);
        break;
      case RecurrenceType.weekly:
        writer.writeByte(1);
        break;
      case RecurrenceType.monthly:
        writer.writeByte(2);
        break;
      case RecurrenceType.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 69;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.notification;
      case 1:
        return ReminderType.email;
      case 2:
        return ReminderType.sms;
      case 3:
        return ReminderType.alarm;
      default:
        return ReminderType.notification;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.notification:
        writer.writeByte(0);
        break;
      case ReminderType.email:
        writer.writeByte(1);
        break;
      case ReminderType.sms:
        writer.writeByte(2);
        break;
      case ReminderType.alarm:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarProviderAdapter extends TypeAdapter<CalendarProvider> {
  @override
  final int typeId = 71;

  @override
  CalendarProvider read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalendarProvider.google;
      case 1:
        return CalendarProvider.apple;
      case 2:
        return CalendarProvider.outlook;
      case 3:
        return CalendarProvider.exchange;
      case 4:
        return CalendarProvider.caldav;
      default:
        return CalendarProvider.google;
    }
  }

  @override
  void write(BinaryWriter writer, CalendarProvider obj) {
    switch (obj) {
      case CalendarProvider.google:
        writer.writeByte(0);
        break;
      case CalendarProvider.apple:
        writer.writeByte(1);
        break;
      case CalendarProvider.outlook:
        writer.writeByte(2);
        break;
      case CalendarProvider.exchange:
        writer.writeByte(3);
        break;
      case CalendarProvider.caldav:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncDirectionAdapter extends TypeAdapter<SyncDirection> {
  @override
  final int typeId = 72;

  @override
  SyncDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncDirection.bidirectional;
      case 1:
        return SyncDirection.import_only;
      case 2:
        return SyncDirection.export_only;
      default:
        return SyncDirection.bidirectional;
    }
  }

  @override
  void write(BinaryWriter writer, SyncDirection obj) {
    switch (obj) {
      case SyncDirection.bidirectional:
        writer.writeByte(0);
        break;
      case SyncDirection.import_only:
        writer.writeByte(1);
        break;
      case SyncDirection.export_only:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
