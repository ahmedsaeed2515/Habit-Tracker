import 'package:hive/hive.dart';
import '../models/points.dart';

class PointsAdapter extends TypeAdapter<Points> {
  @override
  final int typeId = 26;

  @override
  Points read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Points(
      id: fields[0] as String,
      totalPoints: fields[1] as int? ?? 0,
      currentLevel: fields[2] as int? ?? 1,
      pointsToNextLevel: fields[3] as int? ?? 100,
      categoryPoints: (fields[4] as Map?)?.cast<String, int>() ?? {},
      transactions: (fields[5] as List?)?.cast<PointsTransaction>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, Points obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalPoints)
      ..writeByte(2)
      ..write(obj.currentLevel)
      ..writeByte(3)
      ..write(obj.pointsToNextLevel)
      ..writeByte(4)
      ..write(obj.categoryPoints)
      ..writeByte(5)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PointsTransactionAdapter extends TypeAdapter<PointsTransaction> {
  @override
  final int typeId = 27;

  @override
  PointsTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return PointsTransaction(
      id: fields[0] as String,
      amount: fields[1] as int,
      description: fields[2] as String,
      category: fields[3] as PointsCategory,
      timestamp: fields[4] as DateTime,
      relatedId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PointsTransaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.relatedId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
