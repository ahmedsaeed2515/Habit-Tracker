import 'package:hive/hive.dart';
import '../models/social_user.dart';

class SocialCommentAdapter extends TypeAdapter<SocialComment> {
  @override
  final int typeId = 47;

  @override
  SocialComment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SocialComment(
      id: fields[0] as String,
      postId: fields[1] as String,
      authorId: fields[2] as String,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime,
      likes: (fields[5] as List).cast<String>(),
      replyToId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SocialComment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.postId)
      ..writeByte(2)
      ..write(obj.authorId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.replyToId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialCommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
