// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 250;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      attachments: (fields[4] as List).cast<NoteAttachment>(),
      links: (fields[5] as List).cast<NoteLink>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      isArchived: fields[8] as bool,
      isPinned: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.attachments)
      ..writeByte(5)
      ..write(obj.links)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isArchived)
      ..writeByte(9)
      ..write(obj.isPinned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteAttachmentAdapter extends TypeAdapter<NoteAttachment> {
  @override
  final int typeId = 251;

  @override
  NoteAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteAttachment(
      id: fields[0] as String,
      noteId: fields[1] as String,
      type: fields[2] as AttachmentType,
      path: fields[3] as String,
      sizeBytes: fields[4] as int,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NoteAttachment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.noteId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.sizeBytes)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteLinkAdapter extends TypeAdapter<NoteLink> {
  @override
  final int typeId = 252;

  @override
  NoteLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteLink(
      id: fields[0] as String,
      sourceNoteId: fields[1] as String,
      targetId: fields[2] as String,
      targetType: fields[3] as LinkTargetType,
      relation: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NoteLink obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceNoteId)
      ..writeByte(2)
      ..write(obj.targetId)
      ..writeByte(3)
      ..write(obj.targetType)
      ..writeByte(4)
      ..write(obj.relation)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentTypeAdapter extends TypeAdapter<AttachmentType> {
  @override
  final int typeId = 253;

  @override
  AttachmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttachmentType.image;
      case 1:
        return AttachmentType.audio;
      case 2:
        return AttachmentType.file;
      case 3:
        return AttachmentType.link;
      default:
        return AttachmentType.image;
    }
  }

  @override
  void write(BinaryWriter writer, AttachmentType obj) {
    switch (obj) {
      case AttachmentType.image:
        writer.writeByte(0);
        break;
      case AttachmentType.audio:
        writer.writeByte(1);
        break;
      case AttachmentType.file:
        writer.writeByte(2);
        break;
      case AttachmentType.link:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkTargetTypeAdapter extends TypeAdapter<LinkTargetType> {
  @override
  final int typeId = 254;

  @override
  LinkTargetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LinkTargetType.note;
      case 1:
        return LinkTargetType.task;
      case 2:
        return LinkTargetType.habit;
      case 3:
        return LinkTargetType.project;
      default:
        return LinkTargetType.note;
    }
  }

  @override
  void write(BinaryWriter writer, LinkTargetType obj) {
    switch (obj) {
      case LinkTargetType.note:
        writer.writeByte(0);
        break;
      case LinkTargetType.task:
        writer.writeByte(1);
        break;
      case LinkTargetType.habit:
        writer.writeByte(2);
        break;
      case LinkTargetType.project:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkTargetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
