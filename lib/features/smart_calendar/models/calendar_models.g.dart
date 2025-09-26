// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarEventAdapter extends TypeAdapter<CalendarEvent> {
  @override
  final int typeId = 194;

  @override
  CalendarEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      startDateTime: fields[3] as DateTime,
      endDateTime: fields[4] as DateTime,
      type: fields[5] as CalendarEventType,
      habitId: fields[6] as String?,
      priority: fields[7] as CalendarEventPriority,
      location: fields[8] as String?,
      participants: (fields[9] as List).cast<String>(),
      reminder: fields[10] as EventReminder?,
      isCompleted: fields[11] as bool,
      metadata: (fields[12] as Map).cast<String, dynamic>(),
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
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
      ..write(obj.startDateTime)
      ..writeByte(4)
      ..write(obj.endDateTime)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.habitId)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.participants)
      ..writeByte(10)
      ..write(obj.reminder)
      ..writeByte(11)
      ..write(obj.isCompleted)
      ..writeByte(12)
      ..write(obj.metadata)
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
      other is CalendarEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventReminderAdapter extends TypeAdapter<EventReminder> {
  @override
  final int typeId = 197;

  @override
  EventReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventReminder(
      beforeEvent: fields[0] as Duration,
      isEnabled: fields[1] as bool,
      type: fields[2] as ReminderType,
      customMessage: fields[3] as String?,
      methods: (fields[4] as List).cast<ReminderMethod>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventReminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.beforeEvent)
      ..writeByte(1)
      ..write(obj.isEnabled)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.customMessage)
      ..writeByte(4)
      ..write(obj.methods);
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

class SmartCalendarAdapter extends TypeAdapter<SmartCalendar> {
  @override
  final int typeId = 200;

  @override
  SmartCalendar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartCalendar(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as CalendarType,
      color: fields[4] as String,
      isVisible: fields[5] as bool,
      isDefault: fields[6] as bool,
      settings: fields[7] as CalendarSettings,
      syncSettings: (fields[8] as Map).cast<String, dynamic>(),
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SmartCalendar obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.isVisible)
      ..writeByte(6)
      ..write(obj.isDefault)
      ..writeByte(7)
      ..write(obj.settings)
      ..writeByte(8)
      ..write(obj.syncSettings)
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
      other is SmartCalendarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarSettingsAdapter extends TypeAdapter<CalendarSettings> {
  @override
  final int typeId = 202;

  @override
  CalendarSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarSettings(
      autoCreateFromHabits: fields[0] as bool,
      smartScheduling: fields[1] as bool,
      conflictDetection: fields[2] as bool,
      defaultEventDuration: fields[3] as Duration,
      defaultReminder: fields[4] as EventReminder?,
      defaultPriority: fields[5] as CalendarEventPriority,
      workingHours: fields[6] as WorkingHours?,
      preferences: (fields[7] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.autoCreateFromHabits)
      ..writeByte(1)
      ..write(obj.smartScheduling)
      ..writeByte(2)
      ..write(obj.conflictDetection)
      ..writeByte(3)
      ..write(obj.defaultEventDuration)
      ..writeByte(4)
      ..write(obj.defaultReminder)
      ..writeByte(5)
      ..write(obj.defaultPriority)
      ..writeByte(6)
      ..write(obj.workingHours)
      ..writeByte(7)
      ..write(obj.preferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkingHoursAdapter extends TypeAdapter<WorkingHours> {
  @override
  final int typeId = 203;

  @override
  WorkingHours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkingHours(
      startTime: fields[0] as TimeOfDay,
      endTime: fields[1] as TimeOfDay,
      workingDays: (fields[2] as List).cast<int>(),
      breaks: (fields[3] as List).cast<BreakTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkingHours obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.workingDays)
      ..writeByte(3)
      ..write(obj.breaks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkingHoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreakTimeAdapter extends TypeAdapter<BreakTime> {
  @override
  final int typeId = 204;

  @override
  BreakTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreakTime(
      startTime: fields[0] as TimeOfDay,
      endTime: fields[1] as TimeOfDay,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BreakTime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarViewAdapter extends TypeAdapter<CalendarView> {
  @override
  final int typeId = 205;

  @override
  CalendarView read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarView(
      id: fields[0] as String,
      type: fields[1] as CalendarViewType,
      currentDate: fields[2] as DateTime,
      visibleCalendars: (fields[3] as List).cast<String>(),
      visibleEventTypes: (fields[4] as Map).cast<CalendarEventType, bool>(),
      settings: fields[5] as CalendarViewSettings,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarView obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.currentDate)
      ..writeByte(3)
      ..write(obj.visibleCalendars)
      ..writeByte(4)
      ..write(obj.visibleEventTypes)
      ..writeByte(5)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarViewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarViewSettingsAdapter extends TypeAdapter<CalendarViewSettings> {
  @override
  final int typeId = 207;

  @override
  CalendarViewSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarViewSettings(
      showWeekends: fields[0] as bool,
      show24HourFormat: fields[1] as bool,
      firstDayOfWeek: fields[2] as int,
      showCompletedEvents: fields[3] as bool,
      groupEventsByType: fields[4] as bool,
      customizations: (fields[5] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarViewSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.showWeekends)
      ..writeByte(1)
      ..write(obj.show24HourFormat)
      ..writeByte(2)
      ..write(obj.firstDayOfWeek)
      ..writeByte(3)
      ..write(obj.showCompletedEvents)
      ..writeByte(4)
      ..write(obj.groupEventsByType)
      ..writeByte(5)
      ..write(obj.customizations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarViewSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarAnalyticsAdapter extends TypeAdapter<CalendarAnalytics> {
  @override
  final int typeId = 208;

  @override
  CalendarAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarAnalytics(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      totalEvents: fields[2] as int,
      completedEvents: fields[3] as int,
      missedEvents: fields[4] as int,
      totalTimeSpent: fields[5] as Duration,
      eventTypeStats: (fields[6] as Map).cast<CalendarEventType, int>(),
      priorityStats: (fields[7] as Map).cast<CalendarEventPriority, int>(),
      productivityScore: fields[8] as double,
      busySlots: (fields[9] as List).cast<TimeSlot>(),
      freeSlots: (fields[10] as List).cast<TimeSlot>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarAnalytics obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalEvents)
      ..writeByte(3)
      ..write(obj.completedEvents)
      ..writeByte(4)
      ..write(obj.missedEvents)
      ..writeByte(5)
      ..write(obj.totalTimeSpent)
      ..writeByte(6)
      ..write(obj.eventTypeStats)
      ..writeByte(7)
      ..write(obj.priorityStats)
      ..writeByte(8)
      ..write(obj.productivityScore)
      ..writeByte(9)
      ..write(obj.busySlots)
      ..writeByte(10)
      ..write(obj.freeSlots);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeSlotAdapter extends TypeAdapter<TimeSlot> {
  @override
  final int typeId = 209;

  @override
  TimeSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeSlot(
      startTime: fields[0] as DateTime,
      endTime: fields[1] as DateTime,
      description: fields[2] as String?,
      metadata: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimeSlot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartScheduleSuggestionAdapter
    extends TypeAdapter<SmartScheduleSuggestion> {
  @override
  final int typeId = 210;

  @override
  SmartScheduleSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartScheduleSuggestion(
      id: fields[0] as String,
      eventId: fields[1] as String,
      suggestedStartTime: fields[2] as DateTime,
      suggestedEndTime: fields[3] as DateTime,
      confidenceScore: fields[4] as double,
      reasons: (fields[5] as List).cast<String>(),
      type: fields[6] as SuggestionType,
      context: (fields[7] as Map).cast<String, dynamic>(),
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SmartScheduleSuggestion obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.suggestedStartTime)
      ..writeByte(3)
      ..write(obj.suggestedEndTime)
      ..writeByte(4)
      ..write(obj.confidenceScore)
      ..writeByte(5)
      ..write(obj.reasons)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.context)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartScheduleSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarConflictAdapter extends TypeAdapter<CalendarConflict> {
  @override
  final int typeId = 212;

  @override
  CalendarConflict read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarConflict(
      id: fields[0] as String,
      conflictingEventIds: (fields[1] as List).cast<String>(),
      type: fields[2] as ConflictType,
      severity: fields[3] as ConflictSeverity,
      detectedAt: fields[4] as DateTime,
      isResolved: fields[5] as bool,
      resolution: fields[6] as String?,
      suggestedResolutions: (fields[7] as List).cast<ConflictResolution>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalendarConflict obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.conflictingEventIds)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.severity)
      ..writeByte(4)
      ..write(obj.detectedAt)
      ..writeByte(5)
      ..write(obj.isResolved)
      ..writeByte(6)
      ..write(obj.resolution)
      ..writeByte(7)
      ..write(obj.suggestedResolutions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarConflictAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConflictResolutionAdapter extends TypeAdapter<ConflictResolution> {
  @override
  final int typeId = 215;

  @override
  ConflictResolution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConflictResolution(
      id: fields[0] as String,
      type: fields[1] as ResolutionType,
      description: fields[2] as String,
      parameters: (fields[3] as Map).cast<String, dynamic>(),
      feasibilityScore: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ConflictResolution obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.parameters)
      ..writeByte(4)
      ..write(obj.feasibilityScore);
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

class CalendarSyncAdapter extends TypeAdapter<CalendarSync> {
  @override
  final int typeId = 217;

  @override
  CalendarSync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarSync(
      id: fields[0] as String,
      calendarId: fields[1] as String,
      provider: fields[2] as SyncProvider,
      credentials: (fields[3] as Map).cast<String, dynamic>(),
      settings: fields[4] as SyncSettings,
      lastSyncAt: fields[5] as DateTime?,
      status: fields[6] as SyncStatus,
      lastError: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarSync obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.calendarId)
      ..writeByte(2)
      ..write(obj.provider)
      ..writeByte(3)
      ..write(obj.credentials)
      ..writeByte(4)
      ..write(obj.settings)
      ..writeByte(5)
      ..write(obj.lastSyncAt)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.lastError);
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

class SyncSettingsAdapter extends TypeAdapter<SyncSettings> {
  @override
  final int typeId = 219;

  @override
  SyncSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncSettings(
      autoSync: fields[0] as bool,
      syncInterval: fields[1] as Duration,
      direction: fields[2] as SyncDirection,
      syncCompleted: fields[3] as bool,
      syncDeleted: fields[4] as bool,
      excludeEventTypes: (fields[5] as List).cast<CalendarEventType>(),
      filterRules: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.autoSync)
      ..writeByte(1)
      ..write(obj.syncInterval)
      ..writeByte(2)
      ..write(obj.direction)
      ..writeByte(3)
      ..write(obj.syncCompleted)
      ..writeByte(4)
      ..write(obj.syncDeleted)
      ..writeByte(5)
      ..write(obj.excludeEventTypes)
      ..writeByte(6)
      ..write(obj.filterRules);
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

class CalendarPatternAdapter extends TypeAdapter<CalendarPattern> {
  @override
  final int typeId = 222;

  @override
  CalendarPattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarPattern(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as PatternType,
      rules: (fields[3] as Map).cast<String, dynamic>(),
      eventIds: (fields[4] as List).cast<String>(),
      confidence: fields[5] as double,
      discoveredAt: fields[6] as DateTime,
      lastSeenAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarPattern obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.rules)
      ..writeByte(4)
      ..write(obj.eventIds)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.discoveredAt)
      ..writeByte(7)
      ..write(obj.lastSeenAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarPatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveTimeOfDayAdapter extends TypeAdapter<HiveTimeOfDay> {
  @override
  final int typeId = 224;

  @override
  HiveTimeOfDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTimeOfDay(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTimeOfDay obj) {
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
      other is HiveTimeOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarEventTypeAdapter extends TypeAdapter<CalendarEventType> {
  @override
  final int typeId = 195;

  @override
  CalendarEventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalendarEventType.habit;
      case 1:
        return CalendarEventType.reminder;
      case 2:
        return CalendarEventType.appointment;
      case 3:
        return CalendarEventType.deadline;
      case 4:
        return CalendarEventType.meeting;
      case 5:
        return CalendarEventType.workout;
      case 6:
        return CalendarEventType.meal;
      case 7:
        return CalendarEventType.medication;
      case 8:
        return CalendarEventType.social;
      case 9:
        return CalendarEventType.work;
      case 10:
        return CalendarEventType.personal;
      case 11:
        return CalendarEventType.entertainment;
      case 12:
        return CalendarEventType.travel;
      case 13:
        return CalendarEventType.health;
      case 14:
        return CalendarEventType.education;
      case 15:
        return CalendarEventType.other;
      default:
        return CalendarEventType.habit;
    }
  }

  @override
  void write(BinaryWriter writer, CalendarEventType obj) {
    switch (obj) {
      case CalendarEventType.habit:
        writer.writeByte(0);
        break;
      case CalendarEventType.reminder:
        writer.writeByte(1);
        break;
      case CalendarEventType.appointment:
        writer.writeByte(2);
        break;
      case CalendarEventType.deadline:
        writer.writeByte(3);
        break;
      case CalendarEventType.meeting:
        writer.writeByte(4);
        break;
      case CalendarEventType.workout:
        writer.writeByte(5);
        break;
      case CalendarEventType.meal:
        writer.writeByte(6);
        break;
      case CalendarEventType.medication:
        writer.writeByte(7);
        break;
      case CalendarEventType.social:
        writer.writeByte(8);
        break;
      case CalendarEventType.work:
        writer.writeByte(9);
        break;
      case CalendarEventType.personal:
        writer.writeByte(10);
        break;
      case CalendarEventType.entertainment:
        writer.writeByte(11);
        break;
      case CalendarEventType.travel:
        writer.writeByte(12);
        break;
      case CalendarEventType.health:
        writer.writeByte(13);
        break;
      case CalendarEventType.education:
        writer.writeByte(14);
        break;
      case CalendarEventType.other:
        writer.writeByte(15);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarEventPriorityAdapter extends TypeAdapter<CalendarEventPriority> {
  @override
  final int typeId = 196;

  @override
  CalendarEventPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalendarEventPriority.low;
      case 1:
        return CalendarEventPriority.medium;
      case 2:
        return CalendarEventPriority.high;
      case 3:
        return CalendarEventPriority.critical;
      default:
        return CalendarEventPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, CalendarEventPriority obj) {
    switch (obj) {
      case CalendarEventPriority.low:
        writer.writeByte(0);
        break;
      case CalendarEventPriority.medium:
        writer.writeByte(1);
        break;
      case CalendarEventPriority.high:
        writer.writeByte(2);
        break;
      case CalendarEventPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEventPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 198;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.simple;
      case 1:
        return ReminderType.detailed;
      case 2:
        return ReminderType.motivational;
      case 3:
        return ReminderType.gentle;
      case 4:
        return ReminderType.urgent;
      default:
        return ReminderType.simple;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.simple:
        writer.writeByte(0);
        break;
      case ReminderType.detailed:
        writer.writeByte(1);
        break;
      case ReminderType.motivational:
        writer.writeByte(2);
        break;
      case ReminderType.gentle:
        writer.writeByte(3);
        break;
      case ReminderType.urgent:
        writer.writeByte(4);
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

class ReminderMethodAdapter extends TypeAdapter<ReminderMethod> {
  @override
  final int typeId = 199;

  @override
  ReminderMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderMethod.notification;
      case 1:
        return ReminderMethod.email;
      case 2:
        return ReminderMethod.sound;
      case 3:
        return ReminderMethod.vibration;
      case 4:
        return ReminderMethod.popup;
      default:
        return ReminderMethod.notification;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderMethod obj) {
    switch (obj) {
      case ReminderMethod.notification:
        writer.writeByte(0);
        break;
      case ReminderMethod.email:
        writer.writeByte(1);
        break;
      case ReminderMethod.sound:
        writer.writeByte(2);
        break;
      case ReminderMethod.vibration:
        writer.writeByte(3);
        break;
      case ReminderMethod.popup:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarTypeAdapter extends TypeAdapter<CalendarType> {
  @override
  final int typeId = 201;

  @override
  CalendarType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalendarType.personal;
      case 1:
        return CalendarType.work;
      case 2:
        return CalendarType.habits;
      case 3:
        return CalendarType.health;
      case 4:
        return CalendarType.fitness;
      case 5:
        return CalendarType.social;
      case 6:
        return CalendarType.education;
      case 7:
        return CalendarType.family;
      case 8:
        return CalendarType.travel;
      case 9:
        return CalendarType.projects;
      default:
        return CalendarType.personal;
    }
  }

  @override
  void write(BinaryWriter writer, CalendarType obj) {
    switch (obj) {
      case CalendarType.personal:
        writer.writeByte(0);
        break;
      case CalendarType.work:
        writer.writeByte(1);
        break;
      case CalendarType.habits:
        writer.writeByte(2);
        break;
      case CalendarType.health:
        writer.writeByte(3);
        break;
      case CalendarType.fitness:
        writer.writeByte(4);
        break;
      case CalendarType.social:
        writer.writeByte(5);
        break;
      case CalendarType.education:
        writer.writeByte(6);
        break;
      case CalendarType.family:
        writer.writeByte(7);
        break;
      case CalendarType.travel:
        writer.writeByte(8);
        break;
      case CalendarType.projects:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalendarViewTypeAdapter extends TypeAdapter<CalendarViewType> {
  @override
  final int typeId = 206;

  @override
  CalendarViewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalendarViewType.day;
      case 1:
        return CalendarViewType.week;
      case 2:
        return CalendarViewType.month;
      case 3:
        return CalendarViewType.agenda;
      case 4:
        return CalendarViewType.timeline;
      default:
        return CalendarViewType.day;
    }
  }

  @override
  void write(BinaryWriter writer, CalendarViewType obj) {
    switch (obj) {
      case CalendarViewType.day:
        writer.writeByte(0);
        break;
      case CalendarViewType.week:
        writer.writeByte(1);
        break;
      case CalendarViewType.month:
        writer.writeByte(2);
        break;
      case CalendarViewType.agenda:
        writer.writeByte(3);
        break;
      case CalendarViewType.timeline:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarViewTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SuggestionTypeAdapter extends TypeAdapter<SuggestionType> {
  @override
  final int typeId = 211;

  @override
  SuggestionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SuggestionType.optimal;
      case 1:
        return SuggestionType.alternative;
      case 2:
        return SuggestionType.fallback;
      case 3:
        return SuggestionType.emergency;
      default:
        return SuggestionType.optimal;
    }
  }

  @override
  void write(BinaryWriter writer, SuggestionType obj) {
    switch (obj) {
      case SuggestionType.optimal:
        writer.writeByte(0);
        break;
      case SuggestionType.alternative:
        writer.writeByte(1);
        break;
      case SuggestionType.fallback:
        writer.writeByte(2);
        break;
      case SuggestionType.emergency:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConflictTypeAdapter extends TypeAdapter<ConflictType> {
  @override
  final int typeId = 213;

  @override
  ConflictType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConflictType.timeOverlap;
      case 1:
        return ConflictType.locationConflict;
      case 2:
        return ConflictType.resourceConflict;
      case 3:
        return ConflictType.priorityConflict;
      case 4:
        return ConflictType.habitConflict;
      default:
        return ConflictType.timeOverlap;
    }
  }

  @override
  void write(BinaryWriter writer, ConflictType obj) {
    switch (obj) {
      case ConflictType.timeOverlap:
        writer.writeByte(0);
        break;
      case ConflictType.locationConflict:
        writer.writeByte(1);
        break;
      case ConflictType.resourceConflict:
        writer.writeByte(2);
        break;
      case ConflictType.priorityConflict:
        writer.writeByte(3);
        break;
      case ConflictType.habitConflict:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConflictTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConflictSeverityAdapter extends TypeAdapter<ConflictSeverity> {
  @override
  final int typeId = 214;

  @override
  ConflictSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConflictSeverity.low;
      case 1:
        return ConflictSeverity.medium;
      case 2:
        return ConflictSeverity.high;
      case 3:
        return ConflictSeverity.critical;
      default:
        return ConflictSeverity.low;
    }
  }

  @override
  void write(BinaryWriter writer, ConflictSeverity obj) {
    switch (obj) {
      case ConflictSeverity.low:
        writer.writeByte(0);
        break;
      case ConflictSeverity.medium:
        writer.writeByte(1);
        break;
      case ConflictSeverity.high:
        writer.writeByte(2);
        break;
      case ConflictSeverity.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConflictSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResolutionTypeAdapter extends TypeAdapter<ResolutionType> {
  @override
  final int typeId = 216;

  @override
  ResolutionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResolutionType.reschedule;
      case 1:
        return ResolutionType.cancel;
      case 2:
        return ResolutionType.delegate;
      case 3:
        return ResolutionType.merge;
      case 4:
        return ResolutionType.split;
      case 5:
        return ResolutionType.relocate;
      default:
        return ResolutionType.reschedule;
    }
  }

  @override
  void write(BinaryWriter writer, ResolutionType obj) {
    switch (obj) {
      case ResolutionType.reschedule:
        writer.writeByte(0);
        break;
      case ResolutionType.cancel:
        writer.writeByte(1);
        break;
      case ResolutionType.delegate:
        writer.writeByte(2);
        break;
      case ResolutionType.merge:
        writer.writeByte(3);
        break;
      case ResolutionType.split:
        writer.writeByte(4);
        break;
      case ResolutionType.relocate:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolutionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncProviderAdapter extends TypeAdapter<SyncProvider> {
  @override
  final int typeId = 218;

  @override
  SyncProvider read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncProvider.googleCalendar;
      case 1:
        return SyncProvider.outlookCalendar;
      case 2:
        return SyncProvider.appleCalendar;
      case 3:
        return SyncProvider.exchangeCalendar;
      case 4:
        return SyncProvider.caldav;
      case 5:
        return SyncProvider.icalendar;
      default:
        return SyncProvider.googleCalendar;
    }
  }

  @override
  void write(BinaryWriter writer, SyncProvider obj) {
    switch (obj) {
      case SyncProvider.googleCalendar:
        writer.writeByte(0);
        break;
      case SyncProvider.outlookCalendar:
        writer.writeByte(1);
        break;
      case SyncProvider.appleCalendar:
        writer.writeByte(2);
        break;
      case SyncProvider.exchangeCalendar:
        writer.writeByte(3);
        break;
      case SyncProvider.caldav:
        writer.writeByte(4);
        break;
      case SyncProvider.icalendar:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncProviderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncDirectionAdapter extends TypeAdapter<SyncDirection> {
  @override
  final int typeId = 220;

  @override
  SyncDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncDirection.upload;
      case 1:
        return SyncDirection.download;
      case 2:
        return SyncDirection.bidirectional;
      default:
        return SyncDirection.upload;
    }
  }

  @override
  void write(BinaryWriter writer, SyncDirection obj) {
    switch (obj) {
      case SyncDirection.upload:
        writer.writeByte(0);
        break;
      case SyncDirection.download:
        writer.writeByte(1);
        break;
      case SyncDirection.bidirectional:
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

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 221;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.idle;
      case 1:
        return SyncStatus.syncing;
      case 2:
        return SyncStatus.success;
      case 3:
        return SyncStatus.error;
      case 4:
        return SyncStatus.paused;
      case 5:
        return SyncStatus.disabled;
      default:
        return SyncStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.idle:
        writer.writeByte(0);
        break;
      case SyncStatus.syncing:
        writer.writeByte(1);
        break;
      case SyncStatus.success:
        writer.writeByte(2);
        break;
      case SyncStatus.error:
        writer.writeByte(3);
        break;
      case SyncStatus.paused:
        writer.writeByte(4);
        break;
      case SyncStatus.disabled:
        writer.writeByte(5);
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

class PatternTypeAdapter extends TypeAdapter<PatternType> {
  @override
  final int typeId = 223;

  @override
  PatternType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PatternType.recurring;
      case 1:
        return PatternType.seasonal;
      case 2:
        return PatternType.behavioral;
      case 3:
        return PatternType.temporal;
      case 4:
        return PatternType.contextual;
      default:
        return PatternType.recurring;
    }
  }

  @override
  void write(BinaryWriter writer, PatternType obj) {
    switch (obj) {
      case PatternType.recurring:
        writer.writeByte(0);
        break;
      case PatternType.seasonal:
        writer.writeByte(1);
        break;
      case PatternType.behavioral:
        writer.writeByte(2);
        break;
      case PatternType.temporal:
        writer.writeByte(3);
        break;
      case PatternType.contextual:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
