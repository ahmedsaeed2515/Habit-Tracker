// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroSessionAdapter extends TypeAdapter<PomodoroSession> {
  @override
  final int typeId = 231;

  @override
  PomodoroSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSession(
      id: fields[0] as String,
      taskId: fields[1] as String?,
      type: fields[2] as SessionType,
      duration: fields[3] as Duration,
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime?,
      status: fields[6] as SessionStatus,
      isCompleted: fields[7] as bool,
      actualDuration: fields[8] as Duration?,
      cycleNumber: fields[9] as int,
      metadata: (fields[10] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSession obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.actualDuration)
      ..writeByte(9)
      ..write(obj.cycleNumber)
      ..writeByte(10)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PomodoroSettingsAdapter extends TypeAdapter<PomodoroSettings> {
  @override
  final int typeId = 234;

  @override
  PomodoroSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSettings(
      focusSession: fields[0] as Duration,
      shortBreak: fields[1] as Duration,
      longBreak: fields[2] as Duration,
      longBreakInterval: fields[3] as int,
      autoStartBreaks: fields[4] as bool,
      autoStartFocus: fields[5] as bool,
      enableNotifications: fields[6] as bool,
      enableBackgroundMode: fields[7] as bool,
      focusSound: fields[8] as String,
      breakSound: fields[9] as String,
      soundVolume: fields[10] as double,
      enableVibration: fields[11] as bool,
      motivationalQuotes: (fields[12] as List).cast<String>(),
      customSettings: (fields[13] as Map).cast<String, dynamic>(),
      dailyGoal: fields[14] as int,
      taskReminders: fields[15] as bool,
      achievementNotifications: fields[16] as bool,
      notificationSound: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSettings obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.focusSession)
      ..writeByte(1)
      ..write(obj.shortBreak)
      ..writeByte(2)
      ..write(obj.longBreak)
      ..writeByte(3)
      ..write(obj.longBreakInterval)
      ..writeByte(4)
      ..write(obj.autoStartBreaks)
      ..writeByte(5)
      ..write(obj.autoStartFocus)
      ..writeByte(6)
      ..write(obj.enableNotifications)
      ..writeByte(7)
      ..write(obj.enableBackgroundMode)
      ..writeByte(8)
      ..write(obj.focusSound)
      ..writeByte(9)
      ..write(obj.breakSound)
      ..writeByte(10)
      ..write(obj.soundVolume)
      ..writeByte(11)
      ..write(obj.enableVibration)
      ..writeByte(12)
      ..write(obj.motivationalQuotes)
      ..writeByte(13)
      ..write(obj.customSettings)
      ..writeByte(14)
      ..write(obj.dailyGoal)
      ..writeByte(15)
      ..write(obj.taskReminders)
      ..writeByte(16)
      ..write(obj.achievementNotifications)
      ..writeByte(17)
      ..write(obj.notificationSound);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdvancedTaskAdapter extends TypeAdapter<AdvancedTask> {
  @override
  final int typeId = 235;

  @override
  AdvancedTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdvancedTask(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      priority: fields[3] as TaskPriority,
      tags: (fields[4] as List).cast<String>(),
      dueDate: fields[5] as DateTime?,
      reminderTime: fields[6] as DateTime?,
      estimatedDuration: fields[7] as Duration?,
      actualDuration: fields[8] as Duration,
      status: fields[9] as TaskStatus,
      subtasks: (fields[10] as List).cast<Subtask>(),
      recurrence: fields[11] as RecurrenceRule?,
      projectId: fields[12] as String?,
      collaborators: (fields[13] as List).cast<String>(),
      pomodoroSessions: fields[14] as int,
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
      metadata: (fields[17] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdvancedTask obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.reminderTime)
      ..writeByte(7)
      ..write(obj.estimatedDuration)
      ..writeByte(8)
      ..write(obj.actualDuration)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.subtasks)
      ..writeByte(11)
      ..write(obj.recurrence)
      ..writeByte(12)
      ..write(obj.projectId)
      ..writeByte(13)
      ..write(obj.collaborators)
      ..writeByte(14)
      ..write(obj.pomodoroSessions)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvancedTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubtaskAdapter extends TypeAdapter<Subtask> {
  @override
  final int typeId = 238;

  @override
  Subtask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subtask(
      id: fields[0] as String,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      dueDate: fields[3] as DateTime?,
      estimatedDuration: fields[4] as Duration?,
      order: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Subtask obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.estimatedDuration)
      ..writeByte(5)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceRuleAdapter extends TypeAdapter<RecurrenceRule> {
  @override
  final int typeId = 239;

  @override
  RecurrenceRule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurrenceRule(
      type: fields[0] as RecurrenceType,
      interval: fields[1] as int,
      daysOfWeek: (fields[2] as List).cast<int>(),
      endDate: fields[3] as DateTime?,
      maxOccurrences: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurrenceRule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.daysOfWeek)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.maxOccurrences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceRuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 241;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      color: fields[3] as Color,
      icon: fields[4] as String?,
      dueDate: fields[5] as DateTime?,
      status: fields[6] as ProjectStatus,
      memberIds: (fields[7] as List).cast<String>(),
      isShared: fields[8] as bool,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.memberIds)
      ..writeByte(8)
      ..write(obj.isShared)
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
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PomodoroStatsAdapter extends TypeAdapter<PomodoroStats> {
  @override
  final int typeId = 243;

  @override
  PomodoroStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroStats(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      completedSessions: fields[2] as int,
      skippedSessions: fields[3] as int,
      totalFocusTime: fields[4] as Duration,
      totalBreakTime: fields[5] as Duration,
      completedTasks: fields[6] as int,
      streakDays: fields[7] as int,
      productivityScore: fields[8] as double,
      tagStats: (fields[9] as Map).cast<String, int>(),
      priorityStats: (fields[10] as Map).cast<TaskPriority, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroStats obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.completedSessions)
      ..writeByte(3)
      ..write(obj.skippedSessions)
      ..writeByte(4)
      ..write(obj.totalFocusTime)
      ..writeByte(5)
      ..write(obj.totalBreakTime)
      ..writeByte(6)
      ..write(obj.completedTasks)
      ..writeByte(7)
      ..write(obj.streakDays)
      ..writeByte(8)
      ..write(obj.productivityScore)
      ..writeByte(9)
      ..write(obj.tagStats)
      ..writeByte(10)
      ..write(obj.priorityStats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 244;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      type: fields[4] as AchievementType,
      targetValue: fields[5] as int,
      currentValue: fields[6] as int,
      isUnlocked: fields[7] as bool,
      unlockedAt: fields[8] as DateTime?,
      color: fields[9] as Color,
      points: fields[10] as int,
      category: fields[11] as AchievementCategory,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.targetValue)
      ..writeByte(6)
      ..write(obj.currentValue)
      ..writeByte(7)
      ..write(obj.isUnlocked)
      ..writeByte(8)
      ..write(obj.unlockedAt)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.points)
      ..writeByte(11)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MultiTimerAdapter extends TypeAdapter<MultiTimer> {
  @override
  final int typeId = 246;

  @override
  MultiTimer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MultiTimer(
      id: fields[0] as String,
      name: fields[1] as String,
      sessions: (fields[2] as List).cast<PomodoroSession>(),
      currentSessionIndex: fields[3] as int,
      isActive: fields[4] as bool,
      startedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MultiTimer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sessions)
      ..writeByte(3)
      ..write(obj.currentSessionIndex)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.startedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiTimerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AITaskSuggestionAdapter extends TypeAdapter<AITaskSuggestion> {
  @override
  final int typeId = 247;

  @override
  AITaskSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AITaskSuggestion(
      id: fields[0] as String,
      taskId: fields[1] as String,
      type: fields[2] as SuggestionType,
      suggestion: fields[3] as String,
      confidence: fields[4] as double,
      reasons: (fields[5] as List).cast<String>(),
      data: (fields[6] as Map).cast<String, dynamic>(),
      createdAt: fields[7] as DateTime,
      isApplied: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AITaskSuggestion obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.suggestion)
      ..writeByte(4)
      ..write(obj.confidence)
      ..writeByte(5)
      ..write(obj.reasons)
      ..writeByte(6)
      ..write(obj.data)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.isApplied);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AITaskSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PomodoroThemeAdapter extends TypeAdapter<PomodoroTheme> {
  @override
  final int typeId = 249;

  @override
  PomodoroTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroTheme(
      id: fields[0] as String,
      name: fields[1] as String,
      style: fields[2] as ThemeStyle,
      primaryColor: fields[3] as Color,
      secondaryColor: fields[4] as Color,
      backgroundColor: fields[5] as Color,
      surfaceColor: fields[6] as Color,
      isDark: fields[7] as bool,
      customColors: (fields[8] as Map).cast<String, Color>(),
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroTheme obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.style)
      ..writeByte(3)
      ..write(obj.primaryColor)
      ..writeByte(4)
      ..write(obj.secondaryColor)
      ..writeByte(5)
      ..write(obj.backgroundColor)
      ..writeByte(6)
      ..write(obj.surfaceColor)
      ..writeByte(7)
      ..write(obj.isDark)
      ..writeByte(8)
      ..write(obj.customColors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreakSuggestionAdapter extends TypeAdapter<BreakSuggestion> {
  @override
  final int typeId = 251;

  @override
  BreakSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreakSuggestion(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      duration: fields[3] as Duration,
      type: fields[4] as BreakType,
      instructions: (fields[5] as List).cast<String>(),
      imageUrl: fields[6] as String?,
      isActive: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BreakSuggestion obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.instructions)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 232;

  @override
  SessionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionType.focus;
      case 1:
        return SessionType.shortBreak;
      case 2:
        return SessionType.longBreak;
      case 3:
        return SessionType.custom;
      default:
        return SessionType.focus;
    }
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    switch (obj) {
      case SessionType.focus:
        writer.writeByte(0);
        break;
      case SessionType.shortBreak:
        writer.writeByte(1);
        break;
      case SessionType.longBreak:
        writer.writeByte(2);
        break;
      case SessionType.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionStatusAdapter extends TypeAdapter<SessionStatus> {
  @override
  final int typeId = 233;

  @override
  SessionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionStatus.waiting;
      case 1:
        return SessionStatus.active;
      case 2:
        return SessionStatus.paused;
      case 3:
        return SessionStatus.completed;
      case 4:
        return SessionStatus.skipped;
      case 5:
        return SessionStatus.cancelled;
      default:
        return SessionStatus.waiting;
    }
  }

  @override
  void write(BinaryWriter writer, SessionStatus obj) {
    switch (obj) {
      case SessionStatus.waiting:
        writer.writeByte(0);
        break;
      case SessionStatus.active:
        writer.writeByte(1);
        break;
      case SessionStatus.paused:
        writer.writeByte(2);
        break;
      case SessionStatus.completed:
        writer.writeByte(3);
        break;
      case SessionStatus.skipped:
        writer.writeByte(4);
        break;
      case SessionStatus.cancelled:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 236;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.urgent;
      case 1:
        return TaskPriority.high;
      case 2:
        return TaskPriority.medium;
      case 3:
        return TaskPriority.low;
      default:
        return TaskPriority.urgent;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.urgent:
        writer.writeByte(0);
        break;
      case TaskPriority.high:
        writer.writeByte(1);
        break;
      case TaskPriority.medium:
        writer.writeByte(2);
        break;
      case TaskPriority.low:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 237;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.pending;
      case 1:
        return TaskStatus.inProgress;
      case 2:
        return TaskStatus.completed;
      case 3:
        return TaskStatus.cancelled;
      case 4:
        return TaskStatus.onHold;
      case 5:
        return TaskStatus.archived;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending:
        writer.writeByte(0);
        break;
      case TaskStatus.inProgress:
        writer.writeByte(1);
        break;
      case TaskStatus.completed:
        writer.writeByte(2);
        break;
      case TaskStatus.cancelled:
        writer.writeByte(3);
        break;
      case TaskStatus.onHold:
        writer.writeByte(4);
        break;
      case TaskStatus.archived:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 240;

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
      case 4:
        return RecurrenceType.weekdays;
      case 5:
        return RecurrenceType.custom;
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
      case RecurrenceType.weekdays:
        writer.writeByte(4);
        break;
      case RecurrenceType.custom:
        writer.writeByte(5);
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

class ProjectStatusAdapter extends TypeAdapter<ProjectStatus> {
  @override
  final int typeId = 242;

  @override
  ProjectStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectStatus.active;
      case 1:
        return ProjectStatus.completed;
      case 2:
        return ProjectStatus.onHold;
      case 3:
        return ProjectStatus.cancelled;
      case 4:
        return ProjectStatus.archived;
      default:
        return ProjectStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectStatus obj) {
    switch (obj) {
      case ProjectStatus.active:
        writer.writeByte(0);
        break;
      case ProjectStatus.completed:
        writer.writeByte(1);
        break;
      case ProjectStatus.onHold:
        writer.writeByte(2);
        break;
      case ProjectStatus.cancelled:
        writer.writeByte(3);
        break;
      case ProjectStatus.archived:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementCategoryAdapter extends TypeAdapter<AchievementCategory> {
  @override
  final int typeId = 253;

  @override
  AchievementCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementCategory.productivity;
      case 1:
        return AchievementCategory.focus;
      case 2:
        return AchievementCategory.consistency;
      case 3:
        return AchievementCategory.milestone;
      case 4:
        return AchievementCategory.social;
      case 5:
        return AchievementCategory.sessions;
      case 6:
        return AchievementCategory.tasks;
      case 7:
        return AchievementCategory.streaks;
      case 8:
        return AchievementCategory.time;
      case 9:
        return AchievementCategory.special;
      default:
        return AchievementCategory.productivity;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementCategory obj) {
    switch (obj) {
      case AchievementCategory.productivity:
        writer.writeByte(0);
        break;
      case AchievementCategory.focus:
        writer.writeByte(1);
        break;
      case AchievementCategory.consistency:
        writer.writeByte(2);
        break;
      case AchievementCategory.milestone:
        writer.writeByte(3);
        break;
      case AchievementCategory.social:
        writer.writeByte(4);
        break;
      case AchievementCategory.sessions:
        writer.writeByte(5);
        break;
      case AchievementCategory.tasks:
        writer.writeByte(6);
        break;
      case AchievementCategory.streaks:
        writer.writeByte(7);
        break;
      case AchievementCategory.time:
        writer.writeByte(8);
        break;
      case AchievementCategory.special:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementTypeAdapter extends TypeAdapter<AchievementType> {
  @override
  final int typeId = 245;

  @override
  AchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementType.sessionsCompleted;
      case 1:
        return AchievementType.focusTime;
      case 2:
        return AchievementType.tasksCompleted;
      case 3:
        return AchievementType.streak;
      case 4:
        return AchievementType.productivity;
      case 5:
        return AchievementType.consistency;
      case 6:
        return AchievementType.milestone;
      default:
        return AchievementType.sessionsCompleted;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementType obj) {
    switch (obj) {
      case AchievementType.sessionsCompleted:
        writer.writeByte(0);
        break;
      case AchievementType.focusTime:
        writer.writeByte(1);
        break;
      case AchievementType.tasksCompleted:
        writer.writeByte(2);
        break;
      case AchievementType.streak:
        writer.writeByte(3);
        break;
      case AchievementType.productivity:
        writer.writeByte(4);
        break;
      case AchievementType.consistency:
        writer.writeByte(5);
        break;
      case AchievementType.milestone:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SuggestionTypeAdapter extends TypeAdapter<SuggestionType> {
  @override
  final int typeId = 248;

  @override
  SuggestionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SuggestionType.taskPriority;
      case 1:
        return SuggestionType.taskBreakdown;
      case 2:
        return SuggestionType.timeEstimation;
      case 3:
        return SuggestionType.scheduling;
      case 4:
        return SuggestionType.taskOptimization;
      case 5:
        return SuggestionType.focusImprovement;
      default:
        return SuggestionType.taskPriority;
    }
  }

  @override
  void write(BinaryWriter writer, SuggestionType obj) {
    switch (obj) {
      case SuggestionType.taskPriority:
        writer.writeByte(0);
        break;
      case SuggestionType.taskBreakdown:
        writer.writeByte(1);
        break;
      case SuggestionType.timeEstimation:
        writer.writeByte(2);
        break;
      case SuggestionType.scheduling:
        writer.writeByte(3);
        break;
      case SuggestionType.taskOptimization:
        writer.writeByte(4);
        break;
      case SuggestionType.focusImprovement:
        writer.writeByte(5);
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

class ThemeStyleAdapter extends TypeAdapter<ThemeStyle> {
  @override
  final int typeId = 250;

  @override
  ThemeStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeStyle.minimal;
      case 1:
        return ThemeStyle.neon;
      case 2:
        return ThemeStyle.glassmorphism;
      case 3:
        return ThemeStyle.nature;
      case 4:
        return ThemeStyle.dark;
      case 5:
        return ThemeStyle.colorful;
      default:
        return ThemeStyle.minimal;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeStyle obj) {
    switch (obj) {
      case ThemeStyle.minimal:
        writer.writeByte(0);
        break;
      case ThemeStyle.neon:
        writer.writeByte(1);
        break;
      case ThemeStyle.glassmorphism:
        writer.writeByte(2);
        break;
      case ThemeStyle.nature:
        writer.writeByte(3);
        break;
      case ThemeStyle.dark:
        writer.writeByte(4);
        break;
      case ThemeStyle.colorful:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BreakTypeAdapter extends TypeAdapter<BreakType> {
  @override
  final int typeId = 252;

  @override
  BreakType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BreakType.stretch;
      case 1:
        return BreakType.hydration;
      case 2:
        return BreakType.breathing;
      case 3:
        return BreakType.eyeRest;
      case 4:
        return BreakType.walk;
      case 5:
        return BreakType.meditation;
      case 6:
        return BreakType.snack;
      default:
        return BreakType.stretch;
    }
  }

  @override
  void write(BinaryWriter writer, BreakType obj) {
    switch (obj) {
      case BreakType.stretch:
        writer.writeByte(0);
        break;
      case BreakType.hydration:
        writer.writeByte(1);
        break;
      case BreakType.breathing:
        writer.writeByte(2);
        break;
      case BreakType.eyeRest:
        writer.writeByte(3);
        break;
      case BreakType.walk:
        writer.writeByte(4);
        break;
      case BreakType.meditation:
        writer.writeByte(5);
        break;
      case BreakType.snack:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
