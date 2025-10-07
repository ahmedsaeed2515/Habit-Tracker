import 'package:hive/hive.dart';
import '../models/social_user.dart';

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
      stats: fields[15] as Map<String, dynamic>,
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
