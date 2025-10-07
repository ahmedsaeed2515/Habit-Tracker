// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      totalPoints: fields[1] as int,
      currentLevel: fields[2] as int,
      pointsToNextLevel: fields[3] as int,
      categoryPoints: (fields[4] as Map?)?.cast<String, int>(),
      transactions: (fields[5] as List?)?.cast<PointsTransaction>(),
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

class PointsCategoryAdapter extends TypeAdapter<PointsCategory> {
  @override
  final int typeId = 28;

  @override
  PointsCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PointsCategory.habitCompletion;
      case 1:
        return PointsCategory.streak;
      case 2:
        return PointsCategory.achievement;
      case 3:
        return PointsCategory.workout;
      case 4:
        return PointsCategory.social;
      case 5:
        return PointsCategory.bonus;
      default:
        return PointsCategory.habitCompletion;
    }
  }

  @override
  void write(BinaryWriter writer, PointsCategory obj) {
    switch (obj) {
      case PointsCategory.habitCompletion:
        writer.writeByte(0);
        break;
      case PointsCategory.streak:
        writer.writeByte(1);
        break;
      case PointsCategory.achievement:
        writer.writeByte(2);
        break;
      case PointsCategory.workout:
        writer.writeByte(3);
        break;
      case PointsCategory.social:
        writer.writeByte(4);
        break;
      case PointsCategory.bonus:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
