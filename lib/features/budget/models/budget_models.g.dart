// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 258;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      amount: fields[1] as double,
      categoryId: fields[2] as String,
      date: fields[3] as DateTime,
      description: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
      receiptPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.receiptPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncomeAdapter extends TypeAdapter<Income> {
  @override
  final int typeId = 259;

  @override
  Income read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Income(
      id: fields[0] as String,
      amount: fields[1] as double,
      source: fields[2] as String,
      date: fields[3] as DateTime,
      description: fields[4] as String,
      isRecurring: fields[5] as bool,
      recurrenceType: fields[6] as RecurrenceType?,
    );
  }

  @override
  void write(BinaryWriter writer, Income obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.isRecurring)
      ..writeByte(6)
      ..write(obj.recurrenceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetCategoryAdapter extends TypeAdapter<BudgetCategory> {
  @override
  final int typeId = 260;

  @override
  BudgetCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetCategory(
      id: fields[0] as String,
      name: fields[1] as String,
      monthlyLimit: fields[2] as double,
      color: fields[3] as String,
      icon: fields[4] as String,
      alertEnabled: fields[5] as bool,
      alertThreshold: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetCategory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.monthlyLimit)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.alertEnabled)
      ..writeByte(6)
      ..write(obj.alertThreshold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FinancialReportAdapter extends TypeAdapter<FinancialReport> {
  @override
  final int typeId = 261;

  @override
  FinancialReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialReport(
      id: fields[0] as String,
      period: fields[1] as DateTime,
      totalIncome: fields[2] as double,
      totalExpenses: fields[3] as double,
      expensesByCategory: (fields[4] as Map).cast<String, double>(),
      generatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialReport obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.period)
      ..writeByte(2)
      ..write(obj.totalIncome)
      ..writeByte(3)
      ..write(obj.totalExpenses)
      ..writeByte(4)
      ..write(obj.expensesByCategory)
      ..writeByte(5)
      ..write(obj.generatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 262;

  @override
  RecurrenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceType.weekly;
      case 1:
        return RecurrenceType.monthly;
      case 2:
        return RecurrenceType.yearly;
      default:
        return RecurrenceType.weekly;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceType obj) {
    switch (obj) {
      case RecurrenceType.weekly:
        writer.writeByte(0);
        break;
      case RecurrenceType.monthly:
        writer.writeByte(1);
        break;
      case RecurrenceType.yearly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
