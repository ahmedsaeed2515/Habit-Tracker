// lib/features/analytics/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/analytics_provider.dart';
import '../widgets/charts/heatmap_widget.dart';
import '../widgets/charts/line_chart_widget.dart';
import '../widgets/charts/pie_chart_widget.dart';
import '../widgets/kpi_cards.dart';

/// شاشة التحليلات المتقدمة
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '30'; // days

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalytics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAnalytics() {
    final analyticsNotifier = ref.read(analyticsProvider.notifier);
    analyticsNotifier.loadAnalyticsData(
      userId: 'current_user', // سيتم ربطه بنظام المصادقة لاحقاً
      days: int.parse(_selectedPeriod),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات المتقدمة'),
        actions: [
          _buildPeriodSelector(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'الملخص'),
            Tab(icon: Icon(Icons.show_chart), text: 'المخططات'),
            Tab(icon: Icon(Icons.calendar_view_month), text: 'الخريطة'),
            Tab(icon: Icon(Icons.insights), text: 'الرؤى'),
          ],
        ),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final analyticsState = ref.watch(analyticsProvider);

          if (analyticsState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (analyticsState.error != null) {
            return _buildErrorWidget(analyticsState.error!);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(analyticsState),
              _buildChartsTab(analyticsState),
              _buildHeatMapTab(analyticsState),
              _buildInsightsTab(analyticsState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return PopupMenuButton<String>(
      initialValue: _selectedPeriod,
      icon: const Icon(Icons.date_range),
      onSelected: (value) {
        setState(() {
          _selectedPeriod = value;
        });
        _loadAnalytics();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: '7', child: Text('آخر 7 أيام')),
        const PopupMenuItem(value: '30', child: Text('آخر 30 يوم')),
        const PopupMenuItem(value: '90', child: Text('آخر 3 شهور')),
        const PopupMenuItem(value: '365', child: Text('آخر سنة')),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل البيانات',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAnalytics,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AnalyticsState state) {
    final summaryStats = ref.watch(summaryStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الأداء',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          KpiCardsGrid(summaryStats: summaryStats),
          const SizedBox(height: 24),
          if (state.insights.isNotEmpty) ...[
            Text(
              'رؤى سريعة',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...state.insights
                .take(3)
                .map(
                  (insight) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.lightbulb, color: Colors.amber),
                      title: Text(insight),
                      dense: true,
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildChartsTab(AnalyticsState state) {
    final weeklyTrends = ref.watch(weeklyTrendsProvider);
    final topCategories = ref.watch(topCategoriesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // مخطط النقاط الأسبوعي
          if (weeklyTrends['scores']?.isNotEmpty ?? false)
            AnalyticsLineChart(
              data: weeklyTrends['scores']!,
              labels: _generateWeekLabels(),
              title: 'تطور النقاط الأسبوعية',
            ),

          const SizedBox(height: 16),

          // مخطط العادات والمهام
          if (weeklyTrends['habits']?.isNotEmpty ?? false)
            AnalyticsLineChart(
              data: weeklyTrends['habits']!,
              labels: _generateWeekLabels(),
              title: 'العادات المكتملة يومياً',
              lineColor: Colors.green,
              maxY: weeklyTrends['habits']!.reduce((a, b) => a > b ? a : b) + 2,
            ),

          const SizedBox(height: 16),

          // مخطط دائري للفئات
          if (topCategories.isNotEmpty)
            AnalyticsPieChart(
              data: Map.fromEntries(topCategories),
              title: 'أداء الفئات',
            ),
        ],
      ),
    );
  }

  Widget _buildHeatMapTab(AnalyticsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          HeatMapWidget(data: state.heatMapData, title: 'خريطة النشاط السنوية'),
          const SizedBox(height: 16),
          _buildHeatMapLegend(),
        ],
      ),
    );
  }

  Widget _buildHeatMapLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'دليل الألوان',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildLegendItem('0-20%', Colors.grey.shade100),
                _buildLegendItem('20-40%', Colors.green.withValues(alpha: 0.3)),
                _buildLegendItem('40-60%', Colors.green.withValues(alpha: 0.5)),
                _buildLegendItem('60-80%', Colors.green.withValues(alpha: 0.7)),
                _buildLegendItem('80-100%', Colors.green.withValues(alpha: 0.9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab(AnalyticsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'رؤى وتوصيات ذكية',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (state.insights.isEmpty)
            _buildEmptyInsights()
          else
            ...state.insights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;
              return _buildInsightCard(insight, index);
            }),

          const SizedBox(height: 16),
          _buildActionRecommendations(),
        ],
      ),
    );
  }

  Widget _buildEmptyInsights() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.psychology, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد رؤى متاحة حالياً',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'استمر في تسجيل أنشطتك للحصول على رؤى مخصصة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String insight, int index) {
    final icons = [
      Icons.star,
      Icons.trending_up,
      Icons.lightbulb,
      Icons.psychology,
      Icons.analytics,
    ];

    final colors = [
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors[index % colors.length].withValues(alpha: 0.1),
          child: Icon(
            icons[index % icons.length],
            color: colors[index % colors.length],
          ),
        ),
        title: Text(insight),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            // يمكن إضافة تفاصيل أكثر للرؤية
          },
        ),
      ),
    );
  }

  Widget _buildActionRecommendations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.recommend, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'توصيات للتحسين',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              'حدد أهداف يومية واضحة',
              'اجعل عاداتك محددة وقابلة للقياس',
              Icons.flag,
            ),
            _buildRecommendationItem(
              'راجع تقدمك أسبوعياً',
              'خصص وقتاً لمراجعة إنجازاتك',
              Icons.schedule,
            ),
            _buildRecommendationItem(
              'احتفل بالإنجازات الصغيرة',
              'كافئ نفسك عند تحقيق الأهداف',
              Icons.celebration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateWeekLabels() {
    final today = DateTime.now();
    final labels = <String>[];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      labels.add('${date.day}/${date.month}');
    }

    return labels;
  }
}
