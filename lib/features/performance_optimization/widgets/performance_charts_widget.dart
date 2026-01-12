import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/performance_providers.dart';

class LivePerformanceChart extends ConsumerStatefulWidget {
  const LivePerformanceChart({super.key});

  @override
  ConsumerState<LivePerformanceChart> createState() => _LivePerformanceChartState();
}

class _LivePerformanceChartState extends ConsumerState<LivePerformanceChart> {
  final List<FlSpot> cpuDataPoints = [];
  final List<FlSpot> memoryDataPoints = [];
  final List<FlSpot> networkDataPoints = [];
  
  int dataPointCounter = 0;
  static const int maxDataPoints = 20;

  @override
  Widget build(BuildContext context) {
    final liveStats = ref.watch(livePerformanceStatsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مراقبة الأداء المباشرة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const const SizedBox(height: 16),
            liveStats.when(
              data: (stats) {
                _updateDataPoints(stats);
                return _buildChart(context);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDataPoints(stats) {
    setState(() {
      final x = dataPointCounter.toDouble();
      
      // إضافة نقاط البيانات الجديدة
      cpuDataPoints.add(FlSpot(x, stats.cpuUsage));
      memoryDataPoints.add(FlSpot(x, stats.memoryUsage));
      networkDataPoints.add(FlSpot(x, stats.networkLatency / 10)); // تقسيم على 10 للتناسب مع المقياس
      
      // الحفاظ على عدد محدود من النقاط
      if (cpuDataPoints.length > maxDataPoints) {
        cpuDataPoints.removeAt(0);
        memoryDataPoints.removeAt(0);
        networkDataPoints.removeAt(0);
        
        // إعادة ترقيم النقاط
        for (int i = 0; i < cpuDataPoints.length; i++) {
          cpuDataPoints[i] = FlSpot(i.toDouble(), cpuDataPoints[i].y);
          memoryDataPoints[i] = FlSpot(i.toDouble(), memoryDataPoints[i].y);
          networkDataPoints[i] = FlSpot(i.toDouble(), networkDataPoints[i].y);
        }
        dataPointCounter = maxDataPoints - 1;
      }
      
      dataPointCounter++;
    });
  }

  Widget _buildChart(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: maxDataPoints.toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            // خط المعالج
            LineChartBarData(
              spots: cpuDataPoints,
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withValues(alpha: 0.1),
              ),
            ),
            // خط الذاكرة
            LineChartBarData(
              spots: memoryDataPoints,
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.1),
              ),
            ),
            // خط الشبكة (مقسوم على 10)
            LineChartBarData(
              spots: networkDataPoints,
              isCurved: true,
              color: Colors.green,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 48),
          const const SizedBox(height: 16),
          Text(
            'خطأ في تحميل بيانات الأداء',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PerformanceGaugeWidget extends ConsumerWidget {
  
  const PerformanceGaugeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.color,
    this.unit = '%',
  });
  final String title;
  final double value;
  final double maxValue;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentage = (value / maxValue * 100).clamp(0.0, 100.0);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const const SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  // الدائرة الخلفية
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.1)),
                  ),
                  // الدائرة الأمامية
                  CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                  // النص المركزي
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          unit,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const const SizedBox(height: 8),
            Text(
              _getStatusText(percentage),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStatusColor(percentage),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(double percentage) {
    if (percentage < 30) return 'ممتاز';
    if (percentage < 60) return 'جيد';
    if (percentage < 80) return 'متوسط';
    return 'يحتاج تحسين';
  }

  Color _getStatusColor(double percentage) {
    if (percentage < 30) return Colors.green;
    if (percentage < 60) return Colors.blue;
    if (percentage < 80) return Colors.orange;
    return Colors.red;
  }
}

class PerformanceMetricsGrid extends ConsumerWidget {
  const PerformanceMetricsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cpuUsage = ref.watch(cpuUsageProvider);
    final memoryUsage = ref.watch(memoryUsageProvider);
    final networkLatency = ref.watch(networkLatencyProvider);
    final frameTime = ref.watch(frameTimeProvider);
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: cpuUsage.when(
                data: (cpu) => PerformanceGaugeWidget(
                  title: 'المعالج',
                  value: cpu,
                  maxValue: 100,
                  color: Colors.red,
                ),
                loading: () => const _LoadingGaugeWidget(title: 'المعالج'),
                error: (_, __) => const _ErrorGaugeWidget(title: 'المعالج'),
              ),
            ),
            const const SizedBox(width: 8),
            Expanded(
              child: memoryUsage.when(
                data: (memory) => PerformanceGaugeWidget(
                  title: 'الذاكرة',
                  value: memory,
                  maxValue: 100,
                  color: Colors.blue,
                ),
                loading: () => const _LoadingGaugeWidget(title: 'الذاكرة'),
                error: (_, __) => const _ErrorGaugeWidget(title: 'الذاكرة'),
              ),
            ),
          ],
        ),
        const const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: networkLatency.when(
                data: (latency) => PerformanceGaugeWidget(
                  title: 'الشبكة',
                  value: latency,
                  maxValue: 1000,
                  color: Colors.green,
                  unit: 'ms',
                ),
                loading: () => const _LoadingGaugeWidget(title: 'الشبكة'),
                error: (_, __) => const _ErrorGaugeWidget(title: 'الشبكة'),
              ),
            ),
            const const SizedBox(width: 8),
            Expanded(
              child: frameTime.when(
                data: (frames) => PerformanceGaugeWidget(
                  title: 'الإطارات',
                  value: frames,
                  maxValue: 33.33, // 30 FPS
                  color: Colors.purple,
                  unit: 'ms',
                ),
                loading: () => const _LoadingGaugeWidget(title: 'الإطارات'),
                error: (_, __) => const _ErrorGaugeWidget(title: 'الإطارات'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingGaugeWidget extends StatelessWidget {
  
  const _LoadingGaugeWidget({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const const SizedBox(height: 16),
            const SizedBox(
              width: 120,
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            const const SizedBox(height: 8),
            Text(
              'تحميل...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorGaugeWidget extends StatelessWidget {
  
  const _ErrorGaugeWidget({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const const SizedBox(height: 16),
            SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: 48,
                ),
              ),
            ),
            const const SizedBox(height: 8),
            Text(
              'خطأ في التحميل',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}