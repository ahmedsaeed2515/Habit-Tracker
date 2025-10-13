// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeaAdapter extends TypeAdapter<Idea> {
  @override
  final int typeId = 271;

  @override
  Idea read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Idea(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      status: fields[5] as IdeaStatus,
      priority: fields[6] as IdeaPriority,
      categoryId: fields[7] as String?,
      tags: (fields[8] as List).cast<String>(),
      attachments: (fields[9] as List).cast<String>(),
      linkedItemId: fields[10] as String?,
      linkedItemType: fields[11] as LinkedItemType?,
      isFavorite: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Idea obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.attachments)
      ..writeByte(10)
      ..write(obj.linkedItemId)
      ..writeByte(11)
      ..write(obj.linkedItemType)
      ..writeByte(12)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdeaCategoryAdapter extends TypeAdapter<IdeaCategory> {
  @override
  final int typeId = 275;

  @override
  IdeaCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdeaCategory(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      colorHex: fields[3] as String,
      orderIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, IdeaCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.colorHex)
      ..writeByte(4)
      ..write(obj.orderIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InboxItemAdapter extends TypeAdapter<InboxItem> {
  @override
  final int typeId = 276;

  @override
  InboxItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InboxItem(
      id: fields[0] as String,
      content: fields[1] as String,
      createdAt: fields[2] as DateTime,
      type: fields[3] as InboxItemType,
      isProcessed: fields[4] as bool,
      convertedToId: fields[5] as String?,
      convertedToType: fields[6] as ConvertedToType?,
    );
  }

  @override
  void write(BinaryWriter writer, InboxItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isProcessed)
      ..writeByte(5)
      ..write(obj.convertedToId)
      ..writeByte(6)
      ..write(obj.convertedToType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InboxItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdeaStatusAdapter extends TypeAdapter<IdeaStatus> {
  @override
  final int typeId = 272;

  @override
  IdeaStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IdeaStatus.inbox;
      case 1:
        return IdeaStatus.reviewing;
      case 2:
        return IdeaStatus.planned;
      case 3:
        return IdeaStatus.converted;
      case 4:
        return IdeaStatus.archived;
      case 5:
        return IdeaStatus.discarded;
      default:
        return IdeaStatus.inbox;
    }
  }

  @override
  void write(BinaryWriter writer, IdeaStatus obj) {
    switch (obj) {
      case IdeaStatus.inbox:
        writer.writeByte(0);
        break;
      case IdeaStatus.reviewing:
        writer.writeByte(1);
        break;
      case IdeaStatus.planned:
        writer.writeByte(2);
        break;
      case IdeaStatus.converted:
        writer.writeByte(3);
        break;
      case IdeaStatus.archived:
        writer.writeByte(4);
        break;
      case IdeaStatus.discarded:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdeaPriorityAdapter extends TypeAdapter<IdeaPriority> {
  @override
  final int typeId = 273;

  @override
  IdeaPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IdeaPriority.low;
      case 1:
        return IdeaPriority.normal;
      case 2:
        return IdeaPriority.high;
      case 3:
        return IdeaPriority.urgent;
      default:
        return IdeaPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, IdeaPriority obj) {
    switch (obj) {
      case IdeaPriority.low:
        writer.writeByte(0);
        break;
      case IdeaPriority.normal:
        writer.writeByte(1);
        break;
      case IdeaPriority.high:
        writer.writeByte(2);
        break;
      case IdeaPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkedItemTypeAdapter extends TypeAdapter<LinkedItemType> {
  @override
  final int typeId = 274;

  @override
  LinkedItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LinkedItemType.task;
      case 1:
        return LinkedItemType.note;
      case 2:
        return LinkedItemType.project;
      default:
        return LinkedItemType.task;
    }
  }

  @override
  void write(BinaryWriter writer, LinkedItemType obj) {
    switch (obj) {
      case LinkedItemType.task:
        writer.writeByte(0);
        break;
      case LinkedItemType.note:
        writer.writeByte(1);
        break;
      case LinkedItemType.project:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkedItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InboxItemTypeAdapter extends TypeAdapter<InboxItemType> {
  @override
  final int typeId = 277;

  @override
  InboxItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InboxItemType.text;
      case 1:
        return InboxItemType.voice;
      case 2:
        return InboxItemType.link;
      case 3:
        return InboxItemType.image;
      default:
        return InboxItemType.text;
    }
  }

  @override
  void write(BinaryWriter writer, InboxItemType obj) {
    switch (obj) {
      case InboxItemType.text:
        writer.writeByte(0);
        break;
      case InboxItemType.voice:
        writer.writeByte(1);
        break;
      case InboxItemType.link:
        writer.writeByte(2);
        break;
      case InboxItemType.image:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InboxItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConvertedToTypeAdapter extends TypeAdapter<ConvertedToType> {
  @override
  final int typeId = 278;

  @override
  ConvertedToType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConvertedToType.idea;
      case 1:
        return ConvertedToType.task;
      case 2:
        return ConvertedToType.note;
      case 3:
        return ConvertedToType.project;
      default:
        return ConvertedToType.idea;
    }
  }

  @override
  void write(BinaryWriter writer, ConvertedToType obj) {
    switch (obj) {
      case ConvertedToType.idea:
        writer.writeByte(0);
        break;
      case ConvertedToType.task:
        writer.writeByte(1);
        break;
      case ConvertedToType.note:
        writer.writeByte(2);
        break;
      case ConvertedToType.project:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConvertedToTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
