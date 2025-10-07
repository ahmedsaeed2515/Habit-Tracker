import 'package:hive/hive.dart';
import '../models/social_user.dart';

class PostTypeAdapter extends TypeAdapter<PostType> {
  @override
  final int typeId = 48;

  @override
  PostType read(BinaryReader reader) {
    final index = reader.readByte();
    return PostType.values[index];
  }

  @override
  void write(BinaryWriter writer, PostType obj) {
    writer.writeByte(obj.index);
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
