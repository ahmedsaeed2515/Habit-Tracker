import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/performance_metrics.dart';
import '../providers/performance_providers.dart';

class PerformanceOverviewWidget extends ConsumerWidget {
  const PerformanceOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceReport = ref.watch(performanceReportProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظرة عامة على الأداء',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            performanceReport.when(
              data: (report) => _buildPerformanceOverview(context, report),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview(BuildContext context, Map<String, dynamic> report) {
    if (report.containsKey('error')) {
      return _buildErrorWidget(report['error'].toString());
    }

    final overallScore = report['overallScore'] ?? 0.0;
    final performanceLevel = report['performanceLevel'] ?? 'ضعيف';
    final isGood = report['isPerformanceGood'] ?? false;

    return Column(
      children: [
        // نتيجة الأداء الإجمالية
        Row(
          children: [
            Expanded(
              child: _buildScoreCircle(overallScore, isGood),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مستوى الأداء: $performanceLevel',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: overallScore / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(overallScore),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${overallScore.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // تفاصيل الأداء
        if (report.containsKey('breakdown'))
          _buildPerformanceBreakdown(context, report['breakdown']),
        
        const SizedBox(height: 16),
        
        // المشاكل المكتشفة
        if (report.containsKey('issues'))
          _buildIssuesSection(context, report['issues']),
      ],
    );
  }

  Widget _buildScoreCircle(double score, bool isGood) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getScoreColor(score),
          width: 4,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              score.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score),
              ),
            ),
            Icon(
              isGood ? Icons.trending_up : Icons.trending_down,
              color: _getScoreColor(score),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBreakdown(BuildContext context, Map<String, dynamic> breakdown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل الأداء',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        // أداء التطبيق
        if (breakdown.containsKey('app'))
          _buildPerformanceItem(
            context,
            'التطبيق',
            breakdown['app']['score']?.toDouble() ?? 0.0,
            Icons.phone_android,
            '${breakdown['app']['startupTime']} ms وقت البدء',
          ),
        
        // أداء قاعدة البيانات
        if (breakdown.containsKey('database'))
          _buildPerformanceItem(
            context,
            'قاعدة البيانات',
            breakdown['database']['score']?.toDouble() ?? 0.0,
            Icons.storage,
            '${breakdown['database']['averageQueryTime']?.toStringAsFixed(1)} ms متوسط الاستعلام',
          ),
        
        // أداء الذاكرة
        if (breakdown.containsKey('memory'))
          _buildPerformanceItem(
            context,
            'الذاكرة',
            breakdown['memory']['score']?.toDouble() ?? 0.0,
            Icons.memory,
            '${breakdown['memory']['usagePercentage']?.toStringAsFixed(1)}% استخدام',
          ),
        
        // أداء الشبكة
        if (breakdown.containsKey('network'))
          _buildPerformanceItem(
            context,
            'الشبكة',
            breakdown['network']['score']?.toDouble() ?? 0.0,
            Icons.wifi,
            '${breakdown['network']['averageResponseTime']?.toStringAsFixed(0)} ms استجابة',
          ),
        
        // أداء الواجهة
        if (breakdown.containsKey('ui'))
          _buildPerformanceItem(
            context,
            'الواجهة',
            breakdown['ui']['score']?.toDouble() ?? 0.0,
            Icons.visibility,
            '${breakdown['ui']['averageFrameTime']?.toStringAsFixed(1)} ms إطار',
          ),
      ],
    );
  }

  Widget _buildPerformanceItem(
    BuildContext context,
    String title,
    double score,
    IconData icon,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: _getScoreColor(score), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getScoreColor(score).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${score.toStringAsFixed(0)}%',
              style: TextStyle(
                color: _getScoreColor(score),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuesSection(BuildContext context, List<dynamic> issues) {
    if (issues.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600]),
            const SizedBox(width: 8),
            Text(
              'لم يتم اكتشاف أي مشاكل في الأداء',
              style: TextStyle(color: Colors.green[700]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المشاكل المكتشفة (${issues.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...issues.take(3).map((issue) => _buildIssueItem(context, issue)),
        if (issues.length > 3)
          TextButton(
            onPressed: () => _showAllIssues(context, issues),
            child: Text('عرض جميع المشاكل (${issues.length})'),
          ),
      ],
    );
  }

  Widget _buildIssueItem(BuildContext context, issue) {
    final severity = issue['severity'] ?? 'متوسطة';
    final description = issue['description'] ?? 'مشكلة غير معروفة';
    final suggestion = issue['suggestion'] ?? 'لا توجد اقتراحات';

    Color severityColor;
    IconData severityIcon;

    switch (severity.toLowerCase()) {
      case 'high':
      case 'عالية':
        severityColor = Colors.red;
        severityIcon = Icons.error;
        break;
      case 'medium':
      case 'متوسطة':
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        break;
      default:
        severityColor = Colors.yellow[700]!;
        severityIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(severityIcon, color: severityColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red[700]),
            ),
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

  void _showAllIssues(BuildContext context, List<dynamic> issues) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('جميع مشاكل الأداء'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) => _buildIssueItem(context, issues[index]),
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
}