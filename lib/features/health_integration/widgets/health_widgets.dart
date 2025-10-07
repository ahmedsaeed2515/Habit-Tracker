import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_models.dart';
import '../providers/health_providers.dart';

String _metricDisplayNameFor(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return 'الخطوات';
    case HealthMetricType.sleep:
      return 'النوم';
    case HealthMetricType.heartRate:
      return 'معدل ضربات القلب';
    case HealthMetricType.weight:
      return 'الوزن';
    case HealthMetricType.height:
      return 'الطول';
    case HealthMetricType.bloodPressure:
      return 'ضغط الدم';
    case HealthMetricType.bodyTemperature:
      return 'درجة حرارة الجسم';
    case HealthMetricType.oxygenSaturation:
      return 'تشبع الأكسجين';
    case HealthMetricType.caloriesBurned:
      return 'السعرات الحرارية المحروقة';
    case HealthMetricType.activeMinutes:
      return 'الدقائق النشطة';
    case HealthMetricType.waterIntake:
      return 'شرب الماء';
    case HealthMetricType.bloodSugar:
      return 'سكر الدم';
    case HealthMetricType.distance:
      return 'المسافة المقطوعة';
    case HealthMetricType.exercise:
      return 'التمارين';
    case HealthMetricType.meditation:
      return 'التأمل';
    case HealthMetricType.mood:
      return 'المزاج';
    case HealthMetricType.energy:
      return 'الطاقة';
  }
}

String _metricUnitFor(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return 'خطوة';
    case HealthMetricType.sleep:
      return 'ساعة';
    case HealthMetricType.heartRate:
      return 'نبضة/دقيقة';
    case HealthMetricType.weight:
      return 'كيلوغرام';
    case HealthMetricType.height:
      return 'سم';
    case HealthMetricType.bloodPressure:
      return 'mmHg';
    case HealthMetricType.bodyTemperature:
      return '°C';
    case HealthMetricType.oxygenSaturation:
      return '%';
    case HealthMetricType.caloriesBurned:
      return 'سعرة';
    case HealthMetricType.activeMinutes:
      return 'دقيقة';
    case HealthMetricType.waterIntake:
      return 'كوب';
    case HealthMetricType.bloodSugar:
      return 'mg/dL';
    case HealthMetricType.distance:
      return 'كم';
    case HealthMetricType.exercise:
      return 'دقيقة';
    case HealthMetricType.meditation:
      return 'دقيقة';
    case HealthMetricType.mood:
      return '/10';
    case HealthMetricType.energy:
      return '/10';
  }
}

IconData _metricIconFor(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return Icons.directions_walk;
    case HealthMetricType.sleep:
      return Icons.bedtime;
    case HealthMetricType.heartRate:
      return Icons.favorite;
    case HealthMetricType.weight:
      return Icons.monitor_weight;
    case HealthMetricType.height:
      return Icons.straighten;
    case HealthMetricType.bloodPressure:
      return Icons.monitor_heart;
    case HealthMetricType.bodyTemperature:
      return Icons.device_thermostat;
    case HealthMetricType.oxygenSaturation:
      return Icons.bubble_chart;
    case HealthMetricType.caloriesBurned:
      return Icons.local_fire_department;
    case HealthMetricType.activeMinutes:
      return Icons.access_time;
    case HealthMetricType.waterIntake:
      return Icons.local_drink;
    case HealthMetricType.bloodSugar:
      return Icons.bloodtype;
    case HealthMetricType.distance:
      return Icons.route;
    case HealthMetricType.exercise:
      return Icons.fitness_center;
    case HealthMetricType.meditation:
      return Icons.self_improvement;
    case HealthMetricType.mood:
      return Icons.sentiment_satisfied;
    case HealthMetricType.energy:
      return Icons.flash_on;
  }
}

Color _metricColorFor(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return Colors.blue;
    case HealthMetricType.sleep:
      return Colors.indigo;
    case HealthMetricType.heartRate:
      return Colors.red;
    case HealthMetricType.weight:
      return Colors.purple;
    case HealthMetricType.height:
      return Colors.teal;
    case HealthMetricType.bloodPressure:
      return Colors.red.shade800;
    case HealthMetricType.bodyTemperature:
      return Colors.orange;
    case HealthMetricType.oxygenSaturation:
      return Colors.cyan;
    case HealthMetricType.caloriesBurned:
      return Colors.deepOrange;
    case HealthMetricType.activeMinutes:
      return Colors.green;
    case HealthMetricType.waterIntake:
      return Colors.lightBlue;
    case HealthMetricType.bloodSugar:
      return Colors.pink.shade400;
    case HealthMetricType.distance:
      return Colors.green.shade700;
    case HealthMetricType.exercise:
      return Colors.teal;
    case HealthMetricType.meditation:
      return Colors.deepPurple;
    case HealthMetricType.mood:
      return Colors.amber;
    case HealthMetricType.energy:
      return Colors.amber.shade700;
  }
}

double _metricDefaultTargetFor(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return 10000;
    case HealthMetricType.sleep:
      return 8;
    case HealthMetricType.heartRate:
      return 70;
    case HealthMetricType.weight:
      return 70;
    case HealthMetricType.height:
      return 170;
    case HealthMetricType.bloodPressure:
      return 120;
    case HealthMetricType.bodyTemperature:
      return 37;
    case HealthMetricType.oxygenSaturation:
      return 98;
    case HealthMetricType.caloriesBurned:
      return 2000;
    case HealthMetricType.activeMinutes:
      return 30;
    case HealthMetricType.waterIntake:
      return 8;
    case HealthMetricType.bloodSugar:
      return 110;
    case HealthMetricType.distance:
      return 5;
    case HealthMetricType.exercise:
      return 45;
    case HealthMetricType.meditation:
      return 15;
    case HealthMetricType.mood:
      return 8;
    case HealthMetricType.energy:
      return 8;
  }
}

/// بطاقة عرض مقياس صحي
class HealthMetricCard extends StatelessWidget {

  const HealthMetricCard({
    super.key,
    required this.metricType,
    required this.dataPoints,
    this.onTap,
  });
  final HealthMetricType metricType;
  final List<HealthDataPoint> dataPoints;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final latestPoint = dataPoints.isNotEmpty ? dataPoints.last : null;
    final averageValue = _calculateAverage();
    final trend = _calculateTrend();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getMetricColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getMetricIcon(),
                      color: _getMetricColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getMetricDisplayName(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (latestPoint != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'آخر تحديث: ${_formatDate(latestPoint.timestamp)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // اتجاه التغيير
                  if (trend != 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: trend > 0
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            trend > 0 ? Icons.trending_up : Icons.trending_down,
                            color: trend > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trend.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: trend > 0
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // القيم الرئيسية
              Row(
                children: [
                  Expanded(
                    child: _buildValueCard(
                      'القيمة الحالية',
                      latestPoint?.value.toStringAsFixed(1) ?? '--',
                      _getMetricUnit(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildValueCard(
                      'المتوسط (7 أيام)',
                      averageValue.toStringAsFixed(1),
                      _getMetricUnit(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildValueCard(
                      'عدد القراءات',
                      dataPoints.length.toString(),
                      'قراءة',
                    ),
                  ),
                ],
              ),

              // مؤشر الأداء البسيط
              if (dataPoints.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildPerformanceIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicator() {
    final performance = _calculatePerformance();
    final performanceText = _getPerformanceText(performance);
    final performanceColor = _getPerformanceColor(performance);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الأداء الأسبوعي',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              performanceText,
              style: TextStyle(
                fontSize: 12,
                color: performanceColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: performance,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(performanceColor),
        ),
      ],
    );
  }

  double _calculateAverage() {
    if (dataPoints.isEmpty) return 0;

    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentPoints = dataPoints
        .where((point) => point.timestamp.isAfter(weekAgo))
        .toList();

    if (recentPoints.isEmpty) return 0;

    final sum = recentPoints.fold<double>(0, (sum, point) => sum + point.value);
    return sum / recentPoints.length;
  }

  double _calculateTrend() {
    if (dataPoints.length < 2) return 0;

    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));

    final thisWeek = dataPoints
        .where((point) => point.timestamp.isAfter(weekAgo))
        .toList();

    final lastWeek = dataPoints
        .where(
          (point) =>
              point.timestamp.isAfter(twoWeeksAgo) &&
              point.timestamp.isBefore(weekAgo),
        )
        .toList();

    if (thisWeek.isEmpty || lastWeek.isEmpty) return 0;

    final thisWeekAvg =
        thisWeek.fold<double>(0, (sum, point) => sum + point.value) /
        thisWeek.length;
    final lastWeekAvg =
        lastWeek.fold<double>(0, (sum, point) => sum + point.value) /
        lastWeek.length;

    if (lastWeekAvg == 0) return 0;

    return ((thisWeekAvg - lastWeekAvg) / lastWeekAvg) * 100;
  }

  double _calculatePerformance() {
    final average = _calculateAverage();
    final target = _getTargetValue();

    if (target == 0) return 0.5; // متوسط افتراضي

    return (average / target).clamp(0.0, 1.0);
  }

  double _getTargetValue() {
    return _metricDefaultTargetFor(metricType);
  }

  String _getPerformanceText(double performance) {
    if (performance >= 0.9) return 'ممتاز';
    if (performance >= 0.7) return 'جيد';
    if (performance >= 0.5) return 'متوسط';
    if (performance >= 0.3) return 'يحتاج تحسين';
    return 'ضعيف';
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 0.7) return Colors.green;
    if (performance >= 0.4) return Colors.orange;
    return Colors.red;
  }

  String _getMetricDisplayName() => _metricDisplayNameFor(metricType);

  IconData _getMetricIcon() => _metricIconFor(metricType);

  Color _getMetricColor() => _metricColorFor(metricType);

  String _getMetricUnit() => _metricUnitFor(metricType);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

/// بطاقة عرض هدف صحي
class HealthGoalCard extends StatelessWidget {

  const HealthGoalCard({
    super.key,
    required this.goal,
    this.onProgressUpdate,
    this.onToggleActive,
  });
  final HealthGoal goal;
  final Function(double)? onProgressUpdate;
  final VoidCallback? onToggleActive;

  @override
  Widget build(BuildContext context) {
    final progressPercentage = goal.progressPercentage;
    final isAchieved = goal.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isAchieved ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isAchieved
                          ? Colors.green.shade100
                          : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isAchieved ? Icons.check_circle : _getGoalIcon(),
                      color: isAchieved
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGoalTitle(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getPeriodText(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // إعدادات الهدف
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'toggle':
                          onToggleActive?.call();
                          break;
                        case 'edit':
                          _showEditDialog(context);
                          break;
                        case 'delete':
                          _showDeleteDialog(context);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(goal.isActive ? 'إيقاف' : 'تفعيل'),
                      ),
                      const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      const PopupMenuItem(value: 'delete', child: Text('حذف')),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // شريط التقدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentValue.toStringAsFixed(1)} / ${goal.targetValue.toStringAsFixed(1)} ${_metricUnitFor(goal.metricType)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${progressPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: isAchieved
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progressPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      isAchieved ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),

              // معلومات إضافية
              if (goal.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    goal.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ],

              // تاريخ الإنجاز أو الوقت المتبقي
              const SizedBox(height: 8),
              if (isAchieved) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.green.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'تم تحقيقه في ${_formatDate(goal.lastAchievedDate)}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'تم الإنشاء: ${_formatDate(goal.startDate)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGoalIcon() => _metricIconFor(goal.metricType);

  String _getGoalTitle() {
    final metricName = _getMetricDisplayName();
    return 'هدف $metricName';
  }

  String _getMetricDisplayName() => _metricDisplayNameFor(goal.metricType);

  String _getPeriodText() {
    final difference = goal.endDate.difference(goal.startDate).inDays;
    if (difference <= 1) {
      return 'هدف يومي';
    } else if (difference <= 7) {
      return 'هدف أسبوعي';
    } else if (difference <= 31) {
      return 'هدف شهري';
    } else {
      return 'هدف طويل المدى';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context) {
    // تنفيذ حوار التعديل
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الهدف'),
        content: const Text('ميزة التعديل قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الهدف'),
        content: const Text('هل أنت متأكد من حذف هذا الهدف؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ حذف الهدف
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// بطاقة عرض رؤية صحية
class HealthInsightCard extends StatelessWidget {

  const HealthInsightCard({
    super.key,
    required this.insight,
    this.onMarkAsRead,
  });
  final HealthInsight insight;
  final VoidCallback? onMarkAsRead;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: insight.isRead ? 1 : 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: !insight.isRead
              ? Border.all(color: _getPriorityColor(), width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getInsightIcon(),
                      color: _getPriorityColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                insight.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: insight.isRead
                                      ? Colors.grey.shade700
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (!insight.isRead) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getPriorityText(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(insight.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // إعدادات الرؤية
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'mark_read':
                          onMarkAsRead?.call();
                          break;
                        case 'share':
                          _shareInsight();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (!insight.isRead) ...[
                        const PopupMenuItem(
                          value: 'mark_read',
                          child: Text('وضع علامة كمقروء'),
                        ),
                      ],
                      const PopupMenuItem(
                        value: 'share',
                        child: Text('مشاركة'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // محتوى الرؤية
              Text(
                insight.description,
                style: TextStyle(
                  fontSize: 13,
                  color: insight.isRead ? Colors.grey.shade600 : Colors.black87,
                  height: 1.4,
                ),
              ),

              // إجراء قابل للتنفيذ
              if (insight.isActionable && insight.actionText != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: _getPriorityColor(),
                    ),
                    label: Text(
                      insight.actionText!,
                      style: TextStyle(color: _getPriorityColor()),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _getPriorityColor()),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () {
                      // يمكن إضافة منطق إضافي هنا حسب نوع الـ insight
                      if (insight.actionData.isNotEmpty) {
                        // التعامل مع actionData
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (insight.priority) {
      case HealthInsightPriority.high:
        return Colors.red.shade600;
      case HealthInsightPriority.medium:
        return Colors.orange.shade600;
      case HealthInsightPriority.low:
        return Colors.green.shade600;
      case HealthInsightPriority.critical:
        return Colors.red.shade900;
    }
  }

  String _getPriorityText() {
    switch (insight.priority) {
      case HealthInsightPriority.high:
        return 'عالي';
      case HealthInsightPriority.medium:
        return 'متوسط';
      case HealthInsightPriority.low:
        return 'منخفض';
      case HealthInsightPriority.critical:
        return 'حرج';
    }
  }

  IconData _getInsightIcon() {
    switch (insight.type) {
      case HealthInsightType.suggestion:
        return Icons.lightbulb_outline;
      case HealthInsightType.trend:
        return Icons.show_chart;
      case HealthInsightType.achievement:
        return Icons.emoji_events;
      case HealthInsightType.warning:
        return Icons.warning_amber;
      case HealthInsightType.recommendation:
        return Icons.trending_up;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  void _shareInsight() {
    // تنفيذ مشاركة الرؤية
  }
}

/// حوار إضافة بيانات صحية
class AddHealthDataDialog extends ConsumerStatefulWidget {

  const AddHealthDataDialog({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<AddHealthDataDialog> createState() =>
      _AddHealthDataDialogState();
}

class _AddHealthDataDialogState extends ConsumerState<AddHealthDataDialog> {
  final _formKey = GlobalKey<FormState>();
  HealthMetricType _selectedType = HealthMetricType.steps;
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة بيانات صحية'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // نوع البيانات
            DropdownButtonFormField<HealthMetricType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع البيانات',
                border: OutlineInputBorder(),
              ),
              items: HealthMetricType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getMetricDisplayName(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),

            const SizedBox(height: 16),

            // القيمة
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'القيمة',
                suffixText: _getMetricUnit(_selectedType),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'الرجاء إدخال القيمة';
                }
                if (double.tryParse(value!) == null) {
                  return 'الرجاء إدخال رقم صحيح';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // التاريخ
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text('التاريخ: ${_formatDate(_selectedDate)}'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(onPressed: _saveData, child: const Text('حفظ')),
      ],
    );
  }

  Future<void> _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dataPoint = HealthDataPoint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        value: double.parse(_valueController.text),
        unit: _getMetricUnit(_selectedType),
        timestamp: _selectedDate,
        metadata: {},
      );

      await ref
          .read(healthDataProvider(widget.userId).notifier)
          .addDataPoint(dataPoint);

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ البيانات بنجاح')));
    }
  }

  String _getMetricDisplayName(HealthMetricType type) =>
      _metricDisplayNameFor(type);

  String _getMetricUnit(HealthMetricType type) => _metricUnitFor(type);

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// حوار إضافة هدف صحي
class AddHealthGoalDialog extends ConsumerStatefulWidget {

  const AddHealthGoalDialog({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<AddHealthGoalDialog> createState() =>
      _AddHealthGoalDialogState();
}

class _AddHealthGoalDialogState extends ConsumerState<AddHealthGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  HealthMetricType _selectedType = HealthMetricType.steps;
  final _targetController = TextEditingController();
  final _descriptionController = TextEditingController();
  GoalPeriod _selectedPeriod = GoalPeriod.daily;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة هدف صحي'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // نوع الهدف
            DropdownButtonFormField<HealthMetricType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع الهدف',
                border: OutlineInputBorder(),
              ),
              items: HealthMetricType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getMetricDisplayName(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),

            const SizedBox(height: 16),

            // القيمة المستهدفة
            TextFormField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'القيمة المستهدفة',
                suffixText: _getMetricUnit(_selectedType),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'الرجاء إدخال القيمة المستهدفة';
                }
                if (double.tryParse(value!) == null) {
                  return 'الرجاء إدخال رقم صحيح';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // فترة الهدف
            DropdownButtonFormField<GoalPeriod>(
              initialValue: _selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'فترة الهدف',
                border: OutlineInputBorder(),
              ),
              items: GoalPeriod.values
                  .map(
                    (period) => DropdownMenuItem(
                      value: period,
                      child: Text(_getPeriodDisplayName(period)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedPeriod = value!);
              },
            ),

            const SizedBox(height: 16),

            // الوصف (اختياري)
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(onPressed: _saveGoal, child: const Text('حفظ')),
      ],
    );
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(healthGoalsProvider(widget.userId).notifier)
          .createGoal(
            metricType: _selectedType,
            targetValue: double.parse(_targetController.text),
            unit: _getMetricUnit(_selectedType),
            period: _selectedPeriod,
            description: _descriptionController.text,
          );

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الهدف بنجاح')));
    }
  }

  String _getMetricDisplayName(HealthMetricType type) =>
      _metricDisplayNameFor(type);

  String _getMetricUnit(HealthMetricType type) => _metricUnitFor(type);

  String _getPeriodDisplayName(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.daily:
        return 'يومي';
      case GoalPeriod.weekly:
        return 'أسبوعي';
      case GoalPeriod.monthly:
        return 'شهري';
      case GoalPeriod.yearly:
        return 'سنوي';
    }
  }
}
