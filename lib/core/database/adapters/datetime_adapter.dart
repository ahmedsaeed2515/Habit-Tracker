// lib/core/database/adapters/datetime_adapter.dart
// محول DateTime مخصص لـ Hive

import 'package:hive/hive.dart';

/// محول DateTime لـ Hive
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 102;

  @override
  DateTime read(BinaryReader reader) {
    return DateTime.fromMillisecondsSinceEpoch(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}

/// محول DateTime اختياري لـ Hive
class NullableDateTimeAdapter extends TypeAdapter<DateTime?> {
  @override
  final int typeId = 103;

  @override
  DateTime? read(BinaryReader reader) {
    final millis = reader.readInt();
    return millis == 0 ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  void write(BinaryWriter writer, DateTime? obj) {
    writer.writeInt(obj?.millisecondsSinceEpoch ?? 0);
  }
}
