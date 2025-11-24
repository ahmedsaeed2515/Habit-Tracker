import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_models.dart';
import '../providers/health_providers.dart';
import '../widgets/health_widgets.dart';

/// شاشة لوحة تحكم الصحة الرئيسية
class HealthDashboardScreen extends ConsumerStatefulWidget {

  const HealthDashboardScreen({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<HealthDashboardScreen> createState() =>
      _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends ConsumerState<HealthDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الصحة'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade800,
        actions: [
          // زر المزامنة
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () async {
                  await ref
                      .read(healthDataProvider(widget.userId).notifier)
                      .syncData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم بدء المزامنة')),
                  );
                },
              );
            },
          ),
          // زر الإعدادات
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(
              context,
              '/health/settings',
              arguments: widget.userId,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // بطاقة النقاط الصحية
          Container(
            margin: const EdgeInsets.all(16),
            child: Consumer(
              builder: (context, ref, child) {
                final healthScore = ref.watch(
                  healthScoreProvider(widget.userId),
                );

                return healthScore.when(
                  data: (score) => Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'النقاط الصحية',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const const SizedBox(height: 4),
                                Text(
                                  '${score.toInt()}/100',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircularProgressIndicator(
                            value: score / 100,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                            strokeWidth: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading: () => Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'جاري التحميل...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  error: (error, stack) => Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 16),
                          Text(
                            'خطأ في التحميل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // التبويبات
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTabButton(0, 'البيانات', Icons.show_chart),
                _buildTabButton(1, 'الأهداف', Icons.track_changes),
                _buildTabButton(2, 'الرؤى', Icons.lightbulb_outline),
              ],
            ),
          ),

          const const SizedBox(height: 16),

          // محتوى التبويبات
          Expanded(child: _buildTabContent()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.green.shade300 : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.green.shade700
                    : Colors.grey.shade600,
                size: 20,
              ),
              const const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Colors.green.shade700
                      : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _HealthDataTab(userId: widget.userId);
      case 1:
        return _HealthGoalsTab(userId: widget.userId);
      case 2:
        return _HealthInsightsTab(userId: widget.userId);
      default:
        return const SizedBox();
    }
  }

  Widget? _buildFloatingActionButton() {
    switch (_selectedTabIndex) {
      case 0:
        return FloatingActionButton(
          heroTag: 'add_health_data',
          onPressed: _showAddDataDialog,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 1:
        return FloatingActionButton(
          heroTag: 'add_health_goal',
          onPressed: _showAddGoalDialog,
          backgroundColor: Colors.green,
          child: const Icon(Icons.flag, color: Colors.white),
        );
      default:
        return null;
    }
  }

  void _showAddDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AddHealthDataDialog(userId: widget.userId),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AddHealthGoalDialog(userId: widget.userId),
    );
  }
}

/// تبويب البيانات الصحية
class _HealthDataTab extends ConsumerWidget {

  const _HealthDataTab({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(healthDataProvider(userId));

    return dataState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      syncing: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('جاري المزامنة...'),
          ],
        ),
      ),
      loaded: (data) => _buildDataList(context, ref, data),
      error: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const const SizedBox(height: 16),
            Text(
              'خطأ في تحميل البيانات',
              style: TextStyle(color: Colors.red.shade600, fontSize: 18),
            ),
            const const SizedBox(height: 8),
            Text(error, style: const TextStyle(color: Colors.grey)),
            const const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(healthDataProvider(userId)),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataList(
    BuildContext context,
    WidgetRef ref,
    List<HealthDataPoint> data,
  ) {
    if (data.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'لا توجد بيانات صحية',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة بعض البيانات الصحية أو قم بالمزامنة',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // تجميع البيانات حسب النوع
    final groupedData = <HealthMetricType, List<HealthDataPoint>>{};
    for (final point in data) {
      groupedData.putIfAbsent(point.type, () => []).add(point);
    }

    return Column(
      children: [
        // فلاتر البيانات
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<HealthMetricType?>(
                  decoration: const InputDecoration(
                    labelText: 'فلترة حسب النوع',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      child: Text('جميع الأنواع'),
                    ),
                    ...HealthMetricType.values.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getMetricDisplayName(type)),
                      ),
                    ),
                  ],
                  onChanged: (type) {
                    ref
                        .read(healthDataProvider(userId).notifier)
                        .filterByType(type);
                  },
                ),
              ),
            ],
          ),
        ),

        // قائمة البيانات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedData.keys.length,
            itemBuilder: (context, index) {
              final type = groupedData.keys.elementAt(index);
              final typeData = groupedData[type]!;

              return HealthMetricCard(
                metricType: type,
                dataPoints: typeData,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/health/metric_detail',
                  arguments: {'userId': userId, 'metricType': type},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMetricDisplayName(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.steps:
        return 'الخطوات';
      case HealthMetricType.waterIntake:
        return 'شرب الماء';
      case HealthMetricType.sleep:
        return 'النوم';
      case HealthMetricType.weight:
        return 'الوزن';
      case HealthMetricType.caloriesBurned:
        return 'السعرات المحروقة';
      case HealthMetricType.heartRate:
        return 'معدل ضربات القلب';
      case HealthMetricType.bloodPressure:
        return 'ضغط الدم';
      case HealthMetricType.bodyTemperature:
        return 'درجة الحرارة';
      case HealthMetricType.oxygenSaturation:
        return 'تشبع الأكسجين';
      case HealthMetricType.activeMinutes:
        return 'الدقائق النشطة';
      case HealthMetricType.bloodSugar:
        return 'سكر الدم';
      case HealthMetricType.distance:
        return 'المسافة';
      case HealthMetricType.exercise:
        return 'التمارين';
      case HealthMetricType.meditation:
        return 'التأمل';
      case HealthMetricType.mood:
        return 'المزاج';
      case HealthMetricType.energy:
        return 'الطاقة';
      case HealthMetricType.height:
        return 'الطول';
      default:
        return 'مقياس صحي';
    }
  }
}

/// تبويب الأهداف الصحية
class _HealthGoalsTab extends ConsumerWidget {

  const _HealthGoalsTab({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(healthGoalsProvider(userId));

    return goalsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (goals) => _buildGoalsList(context, ref, goals),
      error: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const const SizedBox(height: 16),
            Text(
              'خطأ في تحميل الأهداف',
              style: TextStyle(color: Colors.red.shade600, fontSize: 18),
            ),
            const const SizedBox(height: 8),
            Text(error, style: const TextStyle(color: Colors.grey)),
            const const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(healthGoalsProvider(userId)),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList(
    BuildContext context,
    WidgetRef ref,
    List<HealthGoal> goals,
  ) {
    if (goals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'لا توجد أهداف صحية',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة هدف صحي جديد',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return HealthGoalCard(
          goal: goal,
          onProgressUpdate: (progress) async {
            await ref
                .read(healthGoalsProvider(userId).notifier)
                .updateGoalProgress(goal.id, progress);
          },
          onToggleActive: () async {
            await ref
                .read(healthGoalsProvider(userId).notifier)
                .toggleGoalActive(goal.id);
          },
        );
      },
    );
  }
}

/// تبويب الرؤى الصحية
class _HealthInsightsTab extends ConsumerWidget {

  const _HealthInsightsTab({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsState = ref.watch(healthInsightsProvider(userId));

    return Column(
      children: [
        // زر توليد الرؤى
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text('توليد رؤى جديدة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: insightsState.maybeWhen(
                generating: (_) => null,
                orElse: () => () async {
                  await ref
                      .read(healthInsightsProvider(userId).notifier)
                      .generateInsights();
                },
              ),
            ),
          ),
        ),

        // قائمة الرؤى
        Expanded(
          child: insightsState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            generating: (previousInsights) => Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      const SizedBox(width: 16),
                      Text('جاري توليد الرؤى...'),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildInsightsList(context, ref, previousInsights),
                ),
              ],
            ),
            loaded: (insights) => _buildInsightsList(context, ref, insights),
            error: (error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const const SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل الرؤى',
                    style: TextStyle(color: Colors.red.shade600, fontSize: 18),
                  ),
                  const const SizedBox(height: 8),
                  Text(error, style: const TextStyle(color: Colors.grey)),
                  const const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(healthInsightsProvider(userId)),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsList(
    BuildContext context,
    WidgetRef ref,
    List<HealthInsight> insights,
  ) {
    if (insights.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'لا توجد رؤى صحية',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'قم بتوليد رؤى جديدة بناءً على بياناتك الصحية',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return HealthInsightCard(
          insight: insight,
          onMarkAsRead: () async {
            await ref
                .read(healthInsightsProvider(userId).notifier)
                .markInsightAsRead(insight.id);
          },
        );
      },
    );
  }
}
