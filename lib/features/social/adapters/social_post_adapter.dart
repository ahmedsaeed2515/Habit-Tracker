import 'package:hive/hive.dart';
import '../models/social_user.dart';

class SocialPostAdapter extends TypeAdapter<SocialPost> {
  @override
  final int typeId = 46;

  @override
  SocialPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SocialPost(
      id: fields[0] as String,
      authorId: fields[1] as String,
      content: fields[2] as String,
      type: fields[3] as PostType,
      createdAt: fields[4] as DateTime,
      likes: (fields[5] as List).cast<String>(),
      comments: (fields[6] as List).cast<String>(),
      metadata: fields[7] as Map<String, dynamic>,
      isPublic: fields[8] as bool,
      tags: (fields[9] as List).cast<String>(),
      imageUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SocialPost obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.comments)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.isPublic)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
