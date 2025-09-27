// lib/core/database/adapters/duration_adapter.dart
// محولات Duration للاستخدام مع Hive

import 'package:hive/hive.dart';

/// محول Duration
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final typeId = 104; // TypeId مختلف عن DateTime

  @override
  Duration read(BinaryReader reader) {
    final microseconds = reader.read() as int;
    return Duration(microseconds: microseconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.write(obj.inMicroseconds);
  }
}

/// محول Duration nullable
class NullableDurationAdapter extends TypeAdapter<Duration?> {
  @override
  final typeId = 105; // TypeId مختلف

  @override
  Duration? read(BinaryReader reader) {
    final microseconds = reader.read() as int?;
    return microseconds != null ? Duration(microseconds: microseconds) : null;
  }

  @override
  void write(BinaryWriter writer, Duration? obj) {
    writer.write(obj?.inMicroseconds);
  }
}
