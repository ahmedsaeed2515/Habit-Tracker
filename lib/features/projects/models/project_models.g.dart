// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 263;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      status: fields[7] as ProjectStatus,
      progress: fields[8] as int,
      tags: (fields[9] as List).cast<String>(),
      colorHex: fields[10] as String?,
      isArchived: fields[11] as bool,
      phaseIds: (fields[12] as List).cast<String>(),
      milestones: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.progress)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.colorHex)
      ..writeByte(11)
      ..write(obj.isArchived)
      ..writeByte(12)
      ..write(obj.phaseIds)
      ..writeByte(13)
      ..write(obj.milestones);
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

class ProjectPhaseAdapter extends TypeAdapter<ProjectPhase> {
  @override
  final int typeId = 265;

  @override
  ProjectPhase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectPhase(
      id: fields[0] as String,
      projectId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      orderIndex: fields[6] as int,
      status: fields[7] as PhaseStatus,
      taskIds: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectPhase obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.orderIndex)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.taskIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectPhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectTaskAdapter extends TypeAdapter<ProjectTask> {
  @override
  final int typeId = 267;

  @override
  ProjectTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectTask(
      id: fields[0] as String,
      phaseId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      createdAt: fields[4] as DateTime,
      dueDate: fields[5] as DateTime?,
      completedAt: fields[6] as DateTime?,
      priority: fields[7] as TaskPriority,
      status: fields[8] as TaskStatus,
      assignedTo: fields[9] as String?,
      dependencies: (fields[10] as List).cast<String>(),
      estimatedHours: fields[11] as int,
      actualHours: fields[12] as int,
      tags: (fields[13] as List).cast<String>(),
      attachments: (fields[14] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectTask obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phaseId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.assignedTo)
      ..writeByte(10)
      ..write(obj.dependencies)
      ..writeByte(11)
      ..write(obj.estimatedHours)
      ..writeByte(12)
      ..write(obj.actualHours)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectStatusAdapter extends TypeAdapter<ProjectStatus> {
  @override
  final int typeId = 264;

  @override
  ProjectStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectStatus.planning;
      case 1:
        return ProjectStatus.active;
      case 2:
        return ProjectStatus.onHold;
      case 3:
        return ProjectStatus.completed;
      case 4:
        return ProjectStatus.cancelled;
      default:
        return ProjectStatus.planning;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectStatus obj) {
    switch (obj) {
      case ProjectStatus.planning:
        writer.writeByte(0);
        break;
      case ProjectStatus.active:
        writer.writeByte(1);
        break;
      case ProjectStatus.onHold:
        writer.writeByte(2);
        break;
      case ProjectStatus.completed:
        writer.writeByte(3);
        break;
      case ProjectStatus.cancelled:
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

class PhaseStatusAdapter extends TypeAdapter<PhaseStatus> {
  @override
  final int typeId = 266;

  @override
  PhaseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PhaseStatus.pending;
      case 1:
        return PhaseStatus.inProgress;
      case 2:
        return PhaseStatus.completed;
      case 3:
        return PhaseStatus.blocked;
      default:
        return PhaseStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, PhaseStatus obj) {
    switch (obj) {
      case PhaseStatus.pending:
        writer.writeByte(0);
        break;
      case PhaseStatus.inProgress:
        writer.writeByte(1);
        break;
      case PhaseStatus.completed:
        writer.writeByte(2);
        break;
      case PhaseStatus.blocked:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhaseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 268;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.low;
      case 1:
        return TaskPriority.medium;
      case 2:
        return TaskPriority.high;
      case 3:
        return TaskPriority.urgent;
      default:
        return TaskPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.low:
        writer.writeByte(0);
        break;
      case TaskPriority.medium:
        writer.writeByte(1);
        break;
      case TaskPriority.high:
        writer.writeByte(2);
        break;
      case TaskPriority.urgent:
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
  final int typeId = 269;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.todo;
      case 1:
        return TaskStatus.inProgress;
      case 2:
        return TaskStatus.review;
      case 3:
        return TaskStatus.completed;
      case 4:
        return TaskStatus.blocked;
      default:
        return TaskStatus.todo;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.todo:
        writer.writeByte(0);
        break;
      case TaskStatus.inProgress:
        writer.writeByte(1);
        break;
      case TaskStatus.review:
        writer.writeByte(2);
        break;
      case TaskStatus.completed:
        writer.writeByte(3);
        break;
      case TaskStatus.blocked:
        writer.writeByte(4);
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

class ProjectViewModeAdapter extends TypeAdapter<ProjectViewMode> {
  @override
  final int typeId = 270;

  @override
  ProjectViewMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectViewMode.list;
      case 1:
        return ProjectViewMode.kanban;
      case 2:
        return ProjectViewMode.gantt;
      case 3:
        return ProjectViewMode.timeline;
      default:
        return ProjectViewMode.list;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectViewMode obj) {
    switch (obj) {
      case ProjectViewMode.list:
        writer.writeByte(0);
        break;
      case ProjectViewMode.kanban:
        writer.writeByte(1);
        break;
      case ProjectViewMode.gantt:
        writer.writeByte(2);
        break;
      case ProjectViewMode.timeline:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectViewModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
