// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocialUserAdapter extends TypeAdapter<SocialUser> {
  @override
  final int typeId = 45;

  @override
  SocialUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocialUser(
      id: fields[0] as String,
      username: fields[1] as String,
      displayName: fields[2] as String,
      email: fields[3] as String,
      avatarUrl: fields[4] as String?,
      bio: fields[5] as String,
      totalPoints: fields[6] as int,
      level: fields[7] as int,
      achievements: (fields[8] as List).cast<String>(),
      joinDate: fields[9] as DateTime,
      lastActive: fields[10] as DateTime,
      isPublic: fields[11] as bool,
      friends: (fields[12] as List).cast<String>(),
      followers: (fields[13] as List).cast<String>(),
      following: (fields[14] as List).cast<String>(),
      stats: (fields[15] as Map).cast<String, dynamic>(),
      country: fields[16] as String,
      city: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SocialUser obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.bio)
      ..writeByte(6)
      ..write(obj.totalPoints)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.achievements)
      ..writeByte(9)
      ..write(obj.joinDate)
      ..writeByte(10)
      ..write(obj.lastActive)
      ..writeByte(11)
      ..write(obj.isPublic)
      ..writeByte(12)
      ..write(obj.friends)
      ..writeByte(13)
      ..write(obj.followers)
      ..writeByte(14)
      ..write(obj.following)
      ..writeByte(15)
      ..write(obj.stats)
      ..writeByte(16)
      ..write(obj.country)
      ..writeByte(17)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      metadata: (fields[7] as Map).cast<String, dynamic>(),
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

class SocialCommentAdapter extends TypeAdapter<SocialComment> {
  @override
  final int typeId = 48;

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

class PostTypeAdapter extends TypeAdapter<PostType> {
  @override
  final int typeId = 47;

  @override
  PostType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PostType.achievement;
      case 1:
        return PostType.habitComplete;
      case 2:
        return PostType.milestone;
      case 3:
        return PostType.motivation;
      case 4:
        return PostType.challenge;
      case 5:
        return PostType.general;
      default:
        return PostType.achievement;
    }
  }

  @override
  void write(BinaryWriter writer, PostType obj) {
    switch (obj) {
      case PostType.achievement:
        writer.writeByte(0);
        break;
      case PostType.habitComplete:
        writer.writeByte(1);
        break;
      case PostType.milestone:
        writer.writeByte(2);
        break;
      case PostType.motivation:
        writer.writeByte(3);
        break;
      case PostType.challenge:
        writer.writeByte(4);
        break;
      case PostType.general:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
