// lib/features/budget/providers/budget_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/budget_repository.dart';
import '../models/budget_models.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

final budgetInitProvider = FutureProvider<void>((ref) async {
  await ref.read(budgetRepositoryProvider).init();
});

final expensesProvider = FutureProvider<List<Expense>>((ref) async {
  await ref.watch(budgetInitProvider.future);
  return ref.read(budgetRepositoryProvider).getExpenses();
});

final incomesProvider = FutureProvider<List<Income>>((ref) async {
  await ref.watch(budgetInitProvider.future);
  return ref.read(budgetRepositoryProvider).getIncomes();
});

final categoriesProvider = FutureProvider<List<BudgetCategory>>((ref) async {
  await ref.watch(budgetInitProvider.future);
  return ref.read(budgetRepositoryProvider).getCategories();
});

final currentMonthReportProvider = FutureProvider<FinancialReport>((ref) async {
  await ref.watch(budgetInitProvider.future);
  final now = DateTime.now();
  final repo = ref.read(budgetRepositoryProvider);
  var report = await repo.getReport(now);
  report ??= await repo.generateMonthlyReport(now);
  return report;
});
