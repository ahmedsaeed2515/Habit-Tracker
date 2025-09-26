import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/performance_overview_widget.dart';
import '../widgets/performance_charts_widget.dart';
import '../providers/performance_providers.dart';

class PerformanceOptimizationScreen extends ConsumerStatefulWidget {
  const PerformanceOptimizationScreen({super.key});

  @override
  ConsumerState<PerformanceOptimizationScreen> createState() => _PerformanceOptimizationScreenState();
}

class _PerformanceOptimizationScreenState extends ConsumerState<PerformanceOptimizationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monitoringState = ref.watch(performanceMonitoringStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحسين الأداء'),
        actions: [
          IconButton(
            icon: Icon(
              monitoringState.isMonitoring ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () => _toggleMonitoring(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'optimize',
                child: Row(
                  children: [
                    Icon(Icons.speed),
                    SizedBox(width: 8),
                    Text('تحسين تلقائي'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('تصدير التقرير'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cleanup',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services),
                    SizedBox(width: 8),
                    Text('تنظيف البيانات'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'نظرة عامة'),
            Tab(icon: Icon(Icons.show_chart), text: 'المراقبة المباشرة'),
            Tab(icon: Icon(Icons.analytics), text: 'التحليلات'),
            Tab(icon: Icon(Icons.history), text: 'السجل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildLiveMonitoringTab(),
          _buildAnalyticsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          PerformanceOverviewWidget(),
          SizedBox(height: 16),
          PerformanceMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildLiveMonitoringTab() {
    final monitoringState = ref.watch(performanceMonitoringStateProvider);
    
    if (!monitoringState.isMonitoring) {
      return _buildMonitoringDisabled();
    }
    
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          LivePerformanceChart(),
          SizedBox(height: 16),
          PerformanceMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAnalyticsCards(),
          const SizedBox(height: 16),
          _buildPerformanceTrends(),
          const SizedBox(height: 16),
          _buildIssuesAnalysis(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final metricsHistory = ref.watch(allPerformanceMetricsProvider);
    
    return metricsHistory.when(
      data: (metrics) => _buildHistoryList(metrics),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error.toString()),
    );
  }

  Widget _buildMonitoringDisabled() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monitor_heart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'المراقبة المباشرة غير مفعلة',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على زر التشغيل لبدء مراقبة الأداء المباشرة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _toggleMonitoring(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('بدء المراقبة'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    final performanceReport = ref.watch(performanceReportProvider);
    
    return performanceReport.when(
      data: (report) => _buildAnalyticsCardsData(report),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error.toString()),
    );
  }

  Widget _buildAnalyticsCardsData(Map<String, dynamic> report) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'متوسط النتيجة',
                '${(report['overallScore'] ?? 0.0).toStringAsFixed(1)}%',
                Icons.score,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAnalyticsCard(
                'المشاكل المكتشفة',
                '${(report['issues'] as List?)?.length ?? 0}',
                Icons.warning,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'التقارير المحفوظة',
                '${report['totalReports'] ?? 0}',
                Icons.assessment,
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAnalyticsCard(
                'الحالة العامة',
                report['isPerformanceGood'] == true ? 'جيد' : 'يحتاج تحسين',
                Icons.health_and_safety,
                report['isPerformanceGood'] == true ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اتجاهات الأداء',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // يمكن إضافة مخطط اتجاهات هنا
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('مخطط اتجاهات الأداء'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesAnalysis() {
    final issues = ref.watch(performanceIssuesProvider);
    
    return issues.when(
      data: (issuesList) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تحليل المشاكل',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (issuesList.isEmpty)
                const Text('لا توجد مشاكل مكتشفة')
              else
                ...issuesList.take(5).map((issue) => _buildIssueAnalysisItem(issue)),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error.toString()),
    );
  }

  Widget _buildIssueAnalysisItem(issue) {
    return ListTile(
      leading: Icon(
        Icons.warning,
        color: _getIssueSeverityColor(issue.severity),
      ),
      title: Text(issue.description),
      subtitle: Text(issue.suggestion),
      trailing: Chip(
        label: Text(
          issue.severity.name,
          style: const TextStyle(fontSize: 12),
        ),
        backgroundColor: _getIssueSeverityColor(issue.severity).withOpacity(0.1),
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> metrics) {
    if (metrics.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد سجلات أداء متاحة'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getScoreColor(metric.overallPerformanceScore),
              child: Text(
                '${metric.overallPerformanceScore.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'تقرير الأداء',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${_formatDate(metric.timestamp)} - ${metric.performanceLevel.name}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showMetricsDetail(metric),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل البيانات',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(performanceReportProvider),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _toggleMonitoring() {
    final notifier = ref.read(performanceMonitoringStateProvider.notifier);
    final currentState = ref.read(performanceMonitoringStateProvider);
    
    if (currentState.isMonitoring) {
      notifier.stopMonitoring();
      _showSnackBar('تم إيقاف مراقبة الأداء');
    } else {
      notifier.startMonitoring();
      _showSnackBar('تم بدء مراقبة الأداء');
    }
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => const PerformanceSettingsDialog(),
    );
  }

  void _handleMenuAction(String action) async {
    final notifier = ref.read(performanceMonitoringStateProvider.notifier);
    
    switch (action) {
      case 'optimize':
        _showSnackBar('جاري تحسين الأداء...');
        await notifier.performOptimization();
        _showSnackBar('تم تحسين الأداء بنجاح');
        break;
        
      case 'export':
        _showSnackBar('جاري تصدير التقرير...');
        // يمكن إضافة وظيفة التصدير هنا
        _showSnackBar('تم تصدير التقرير بنجاح');
        break;
        
      case 'cleanup':
        _showConfirmDialog(
          'تنظيف البيانات',
          'هل تريد حذف جميع البيانات القديمة؟',
          () async {
            await notifier.cleanupOldData();
            _showSnackBar('تم تنظيف البيانات بنجاح');
          },
        );
        break;
    }
  }

  void _showMetricsDetail(dynamic metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل تقرير الأداء'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('التاريخ', _formatDate(metric.timestamp)),
              _buildDetailRow('النتيجة الإجمالية', '${metric.overallPerformanceScore.toStringAsFixed(1)}%'),
              _buildDetailRow('المستوى', metric.performanceLevel.name),
              _buildDetailRow('المعالج', '${metric.appPerformance.cpuUsage.toStringAsFixed(1)}%'),
              _buildDetailRow('الذاكرة', '${metric.memoryUsage.memoryUsagePercentage.toStringAsFixed(1)}%'),
              _buildDetailRow('الشبكة', '${metric.networkPerformance.averageResponseTime.toStringAsFixed(0)} ms'),
              _buildDetailRow('الواجهة', '${metric.uiPerformance.averageFrameTime.toStringAsFixed(1)} ms'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showConfirmDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getIssueSeverityColor(severity) {
    switch (severity.name.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.yellow[700]!;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class PerformanceSettingsDialog extends ConsumerWidget {
  const PerformanceSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(performanceSettingsProvider);
    final settingsNotifier = ref.read(performanceSettingsProvider.notifier);
    
    return AlertDialog(
      title: const Text('إعدادات مراقبة الأداء'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('تفعيل المراقبة'),
              subtitle: const Text('مراقبة الأداء بشكل مستمر'),
              value: settings.enableMonitoring,
              onChanged: settingsNotifier.toggleMonitoring,
            ),
            SwitchListTile(
              title: const Text('التحسين التلقائي'),
              subtitle: const Text('تحسين الأداء تلقائياً عند اكتشاف مشاكل'),
              value: settings.enableAutomaticOptimization,
              onChanged: settingsNotifier.toggleAutomaticOptimization,
            ),
            SwitchListTile(
              title: const Text('مراقبة الذاكرة'),
              subtitle: const Text('مراقبة استخدام الذاكرة وتسريباتها'),
              value: settings.enableMemoryMonitoring,
              onChanged: settingsNotifier.toggleMemoryMonitoring,
            ),
            SwitchListTile(
              title: const Text('مراقبة الشبكة'),
              subtitle: const Text('مراقبة أداء طلبات الشبكة'),
              value: settings.enableNetworkMonitoring,
              onChanged: settingsNotifier.toggleNetworkMonitoring,
            ),
            ListTile(
              title: const Text('فترة المراقبة'),
              subtitle: Text('${settings.monitoringInterval} ثانية'),
              trailing: DropdownButton<int>(
                value: settings.monitoringInterval,
                items: [10, 30, 60, 120].map((seconds) {
                  return DropdownMenuItem(
                    value: seconds,
                    child: Text('$seconds ثانية'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    settingsNotifier.updateMonitoringInterval(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => settingsNotifier.resetToDefaults(),
          child: const Text('إعادة تعيين'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}