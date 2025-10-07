import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_providers.dart';
import '../models/budget_models.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(currentMonthReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانية'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ملخص'),
            Tab(text: 'المصروفات'),
            Tab(text: 'الدخل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(reportAsync),
          _buildExpensesTab(),
          _buildIncomesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryTab(AsyncValue<FinancialReport> reportAsync) {
    return reportAsync.when(
      data: (report) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'إجمالي الدخل',
                        report.totalIncome,
                        Colors.green,
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        'إجمالي المصروفات',
                        report.totalExpenses,
                        Colors.red,
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        'الرصيد',
                        report.balance,
                        report.balance >= 0 ? Colors.blue : Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'المصروفات حسب الفئة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ref
                    .watch(categoriesProvider)
                    .when(
                      data: (categories) {
                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final spent =
                                report.expensesByCategory[cat.id] ?? 0;
                            final progress = cat.getProgress(spent);
                            return Card(
                              child: ListTile(
                                leading: Text(
                                  cat.icon,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                title: Text(cat.name),
                                subtitle: LinearProgressIndicator(
                                  value: progress / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation(
                                    progress > 100
                                        ? Colors.red
                                        : progress > cat.alertThreshold
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                                trailing: Text(
                                  '${spent.toStringAsFixed(0)} / ${cat.monthlyLimit.toStringAsFixed(0)}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (e, _) => Center(child: Text('خطأ: $e')),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
              ),
            ],
          ),
        );
      },
      error: (e, _) => Center(child: Text('خطأ: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesTab() {
    final expensesAsync = ref.watch(expensesProvider);
    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(child: Text('لا توجد مصروفات'));
        }
        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final exp = expenses[index];
            return ListTile(
              title: Text(exp.description),
              subtitle: Text(
                '${exp.date.day}/${exp.date.month}/${exp.date.year}',
              ),
              trailing: Text(
                '-${exp.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
      error: (e, _) => Center(child: Text('خطأ: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildIncomesTab() {
    final incomesAsync = ref.watch(incomesProvider);
    return incomesAsync.when(
      data: (incomes) {
        if (incomes.isEmpty) {
          return const Center(child: Text('لا توجد إيرادات'));
        }
        return ListView.builder(
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final inc = incomes[index];
            return ListTile(
              title: Text(inc.description),
              subtitle: Text(
                '${inc.date.day}/${inc.date.month}/${inc.date.year} - ${inc.source}',
              ),
              trailing: Text(
                '+${inc.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
      error: (e, _) => Center(child: Text('خطأ: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_circle, color: Colors.red),
              title: const Text('مصروف'),
              onTap: () {
                Navigator.pop(ctx);
                _showExpenseDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: const Text('دخل'),
              onTap: () {
                Navigator.pop(ctx);
                _showIncomeDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExpenseDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? selectedCat;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مصروف جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
            ref
                .watch(categoriesProvider)
                .when(
                  data: (cats) {
                    selectedCat ??= cats.first.id;
                    return DropdownButton<String>(
                      value: selectedCat,
                      items: cats
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => selectedCat = v,
                    );
                  },
                  error: (_, __) => const Text('خطأ'),
                  loading: () => const CircularProgressIndicator(),
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountCtrl.text) ?? 0;
              if (amt <= 0 || selectedCat == null) return;
              final exp = Expense(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: amt,
                categoryId: selectedCat!,
                date: DateTime.now(),
                description: descCtrl.text.trim().isEmpty
                    ? 'مصروف'
                    : descCtrl.text.trim(),
              );
              await ref.read(budgetRepositoryProvider).addExpense(exp);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ref.invalidate(expensesProvider);
                ref.invalidate(currentMonthReportProvider);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showIncomeDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final sourceCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('دخل جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ'),
            ),
            TextField(
              controller: sourceCtrl,
              decoration: const InputDecoration(labelText: 'المصدر'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'الوصف'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountCtrl.text) ?? 0;
              if (amt <= 0) return;
              final inc = Income(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: amt,
                source: sourceCtrl.text.trim().isEmpty
                    ? 'مصدر'
                    : sourceCtrl.text.trim(),
                date: DateTime.now(),
                description: descCtrl.text.trim().isEmpty
                    ? 'دخل'
                    : descCtrl.text.trim(),
              );
              await ref.read(budgetRepositoryProvider).addIncome(inc);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ref.invalidate(incomesProvider);
                ref.invalidate(currentMonthReportProvider);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
