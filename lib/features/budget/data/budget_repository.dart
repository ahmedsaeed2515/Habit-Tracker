// lib/features/budget/data/budget_repository.dart
import 'package:hive/hive.dart';
import '../models/budget_models.dart';

class BudgetRepository {
  static const String expensesBoxName = 'expenses_box';
  static const String incomesBoxName = 'incomes_box';
  static const String categoriesBoxName = 'budget_categories_box';
  static const String reportsBoxName = 'financial_reports_box';

  Box<Expense>? _expensesBox;
  Box<Income>? _incomesBox;
  Box<BudgetCategory>? _categoriesBox;
  Box<FinancialReport>? _reportsBox;

  Future<void> init() async {
    _expensesBox ??= await Hive.openBox<Expense>(expensesBoxName);
    _incomesBox ??= await Hive.openBox<Income>(incomesBoxName);
    _categoriesBox ??= await Hive.openBox<BudgetCategory>(categoriesBoxName);
    _reportsBox ??= await Hive.openBox<FinancialReport>(reportsBoxName);
    await _ensureDefaultCategories();
  }

  Future<void> _ensureDefaultCategories() async {
    if (_categoriesBox!.isEmpty) {
      final defaults = [
        BudgetCategory(
          id: 'cat_food',
          name: 'طعام',
          monthlyLimit: 1000,
          color: '#FF5722',
          icon: '🍔',
        ),
        BudgetCategory(
          id: 'cat_transport',
          name: 'مواصلات',
          monthlyLimit: 500,
          color: '#2196F3',
          icon: '🚗',
        ),
        BudgetCategory(
          id: 'cat_bills',
          name: 'فواتير',
          monthlyLimit: 800,
          color: '#FFC107',
          icon: '📄',
        ),
        BudgetCategory(
          id: 'cat_entertainment',
          name: 'ترفيه',
          monthlyLimit: 300,
          color: '#9C27B0',
          icon: '🎮',
        ),
        BudgetCategory(
          id: 'cat_other',
          name: 'أخرى',
          monthlyLimit: 500,
          color: '#607D8B',
          icon: '💼',
        ),
      ];
      for (final cat in defaults) {
        await _categoriesBox!.put(cat.id, cat);
      }
    }
  }

  Future<List<Expense>> getExpenses({DateTime? start, DateTime? end}) async {
    var expenses = _expensesBox!.values.toList();
    if (start != null) {
      expenses = expenses.where((e) => !e.date.isBefore(start)).toList();
    }
    if (end != null) {
      expenses = expenses.where((e) => !e.date.isAfter(end)).toList();
    }
    return expenses..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Income>> getIncomes({DateTime? start, DateTime? end}) async {
    var incomes = _incomesBox!.values.toList();
    if (start != null) {
      incomes = incomes.where((i) => !i.date.isBefore(start)).toList();
    }
    if (end != null) {
      incomes = incomes.where((i) => !i.date.isAfter(end)).toList();
    }
    return incomes..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addExpense(Expense expense) async =>
      _expensesBox!.put(expense.id, expense);
  Future<void> addIncome(Income income) async =>
      _incomesBox!.put(income.id, income);
  Future<void> deleteExpense(String id) async => _expensesBox!.delete(id);
  Future<void> deleteIncome(String id) async => _incomesBox!.delete(id);

  List<BudgetCategory> getCategories() => _categoriesBox!.values.toList();
  Future<void> addCategory(BudgetCategory cat) async =>
      _categoriesBox!.put(cat.id, cat);
  Future<void> updateCategory(BudgetCategory cat) async => cat.save();

  Future<FinancialReport> generateMonthlyReport(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    final expenses = await getExpenses(start: start, end: end);
    final incomes = await getIncomes(start: start, end: end);
    final totalExp = expenses.fold<double>(0, (s, e) => s + e.amount);
    final totalInc = incomes.fold<double>(0, (s, i) => s + i.amount);
    final byCategory = <String, double>{};
    for (final e in expenses) {
      byCategory[e.categoryId] = (byCategory[e.categoryId] ?? 0) + e.amount;
    }
    final report = FinancialReport(
      id: '${month.year}_${month.month}',
      period: start,
      totalIncome: totalInc,
      totalExpenses: totalExp,
      expensesByCategory: byCategory,
      generatedAt: DateTime.now(),
    );
    await _reportsBox!.put(report.id, report);
    return report;
  }

  Future<FinancialReport?> getReport(DateTime month) async {
    final id = '${month.year}_${month.month}';
    return _reportsBox!.get(id);
  }
}
