// lib/features/budget/models/budget_models.dart
// نماذج نظام الميزانية الشخصية مع Hive

import 'package:hive/hive.dart';

part 'budget_models.g.dart';

@HiveType(typeId: 258)
class Expense extends HiveObject { // مسار إيصال اختياري

  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.description,
    this.tags = const [],
    this.receiptPath,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  double amount;
  @HiveField(2)
  String categoryId;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  String description;
  @HiveField(5)
  List<String> tags;
  @HiveField(6)
  String? receiptPath;
}

@HiveType(typeId: 259)
class Income extends HiveObject {

  Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.date,
    required this.description,
    this.isRecurring = false,
    this.recurrenceType,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  double amount;
  @HiveField(2)
  String source;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  String description;
  @HiveField(5)
  bool isRecurring;
  @HiveField(6)
  RecurrenceType? recurrenceType;
}

@HiveType(typeId: 260)
class BudgetCategory extends HiveObject { // نسبة مئوية (0-100)

  BudgetCategory({
    required this.id,
    required this.name,
    required this.monthlyLimit,
    required this.color,
    this.icon = '💰',
    this.alertEnabled = true,
    this.alertThreshold = 80.0,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double monthlyLimit;
  @HiveField(3)
  String color;
  @HiveField(4)
  String icon;
  @HiveField(5)
  bool alertEnabled;
  @HiveField(6)
  double alertThreshold;

  double getSpent(List<Expense> expenses, DateTime month) {
    return expenses
        .where(
          (e) =>
              e.categoryId == id &&
              e.date.year == month.year &&
              e.date.month == month.month,
        )
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double getProgress(double spent) {
    if (monthlyLimit <= 0) return 0;
    return (spent / monthlyLimit) * 100;
  }
}

@HiveType(typeId: 261)
class FinancialReport extends HiveObject {

  FinancialReport({
    required this.id,
    required this.period,
    required this.totalIncome,
    required this.totalExpenses,
    required this.expensesByCategory,
    required this.generatedAt,
  });
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime period; // أول يوم من الشهر
  @HiveField(2)
  double totalIncome;
  @HiveField(3)
  double totalExpenses;
  @HiveField(4)
  Map<String, double> expensesByCategory;
  @HiveField(5)
  DateTime generatedAt;

  double get balance => totalIncome - totalExpenses;
  double get savingsRate =>
      totalIncome > 0 ? ((totalIncome - totalExpenses) / totalIncome) * 100 : 0;
}

@HiveType(typeId: 262)
enum RecurrenceType {
  @HiveField(0)
  weekly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly,
}
