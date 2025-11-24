import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';
import '../widgets/quick_stats_widget.dart';

/// نطاق التواريخ للتحليلات
enum DateRange {
  day,     // اليوم
  week,    // الأسبوع
  month,   // الشهر
  year,    // السنة
  custom,  // مخصص
}

/// شاشة الإحصائيات والتحليلات المتقدمة
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateRange _selectedRange = DateRange.week;
  
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'الإحصائيات والتحليلات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _buildRangeSelector(),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareStats,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'نظرة عامة'),
            Tab(icon: Icon(Icons.trending_up), text: 'الإنتاجية'),
            Tab(icon: Icon(Icons.emoji_events), text: 'الإنجازات'),
            Tab(icon: Icon(Icons.insights), text: 'التوصيات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProductivityTab(),
          _buildAchievementsTab(),
          _buildRecommendationsTab(),
        ],
      ),
    );
  }

  Widget _buildRangeSelector() {
    return PopupMenuButton<DateRange>(
      icon: const Icon(Icons.date_range, color: Colors.white),
      onSelected: (range) {
        setState(() {
          _selectedRange = range;
        });
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: DateRange.day,
          child: Text('اليوم'),
        ),
        const PopupMenuItem(
          value: DateRange.week,
          child: Text('الأسبوع'),
        ),
        const PopupMenuItem(
          value: DateRange.month,
          child: Text('الشهر'),
        ),
        const PopupMenuItem(
          value: DateRange.year,
          child: Text('السنة'),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final statsNotifier = ref.watch(pomodoroStatsProvider.notifier);
    final stats = statsNotifier.getStatsForRange(_selectedRange);
    final analysis = ref.watch(productivityAnalysisProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          QuickStatsWidget(stats: stats, analysis: analysis),
          
          const SizedBox(height: 20),
          
          // Sessions Chart
          _buildSessionsChart(stats),
          
          const SizedBox(height: 20),
          
          // Focus Time Distribution
          _buildFocusTimeChart(stats),
          
          const SizedBox(height: 20),
          
          // Daily Pattern
          _buildDailyPatternChart(),
          
          const SizedBox(height: 20),
          
          // Task Categories
          _buildTaskCategoriesChart(),
        ],
      ),
    );
  }

  Widget _buildProductivityTab() {
    final analysis = ref.watch(productivityAnalysisProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Productivity Score
          _buildProductivityScoreCard(analysis),
          
          const SizedBox(height: 20),
          
          // Productivity Trends
          _buildProductivityTrendsChart(),
          
          const SizedBox(height: 20),
          
          // Focus Quality
          _buildFocusQualityMetrics(analysis),
          
          const SizedBox(height: 20),
          
          // Break Efficiency
          _buildBreakEfficiencyCard(analysis),
          
          const SizedBox(height: 20),
          
          // Time of Day Analysis
          _buildTimeOfDayAnalysis(),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    final achievements = ref.watch(achievementsProvider);
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();
    final lockedAchievements = achievements.where((a) => !a.isUnlocked).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Achievement Summary
          _buildAchievementSummary(unlockedAchievements, achievements.length),
          
          const SizedBox(height: 20),
          
          // Unlocked Achievements
          _buildAchievementSection(
            'الإنجازات المكتسبة',
            unlockedAchievements,
            true,
          ),
          
          const SizedBox(height: 20),
          
          // Locked Achievements
          _buildAchievementSection(
            'الإنجازات المتاحة',
            lockedAchievements,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    final recommendations = ref.watch(smartRecommendationsProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Insights Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.2),
                  Colors.blue.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحليل ذكي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'توصيات مخصصة لتحسين إنتاجيتك',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Recommendations List
          ...recommendations.map(_buildRecommendationCard),
          
          if (recommendations.isEmpty)
            _buildEmptyRecommendations(),
        ],
      ),
    );
  }

  Widget _buildSessionsChart(PomodoroStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الجلسات المكتملة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];
                        if (value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateWeeklySpots(stats),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                    dotData: FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusTimeChart(PomodoroStats stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'توزيع وقت التركيز',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: stats.totalFocusTime.inMinutes.toDouble(),
                          title: 'تركيز',
                          color: Colors.blue,
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: stats.totalBreakTime.inMinutes.toDouble(),
                          title: 'استراحة',
                          color: Colors.green,
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      'وقت التركيز',
                      '${stats.totalFocusTime.inHours}:${(stats.totalFocusTime.inMinutes % 60).toString().padLeft(2, '0')}',
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      'وقت الاستراحة',
                      '${stats.totalBreakTime.inHours}:${(stats.totalBreakTime.inMinutes % 60).toString().padLeft(2, '0')}',
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      'النسبة',
                      '${((stats.totalFocusTime.inMinutes / (stats.totalFocusTime.inMinutes + stats.totalBreakTime.inMinutes)) * 100).toInt()}%',
                      Colors.amber,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityScoreCard(ProductivityAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.2),
            Colors.blue.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'نقاط الإنتاجية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getScoreColor(analysis.todayScore).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getScoreLabel(analysis.todayScore),
                  style: TextStyle(
                    color: _getScoreColor(analysis.todayScore),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${analysis.todayScore.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '/100',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: analysis.todayScore / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getScoreColor(analysis.todayScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            analysis.todayScore > analysis.averageScore
                ? 'أداء ممتاز! تحسنت بنسبة ${((analysis.todayScore - analysis.averageScore) / analysis.averageScore * 100).toInt()}%'
                : 'يمكنك تحسين الأداء بمراجعة التوصيات',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
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

  String _getScoreLabel(double score) {
    if (score >= 80) return 'ممتاز';
    if (score >= 60) return 'جيد';
    return 'يحتاج تحسين';
  }

  List<FlSpot> _generateWeeklySpots(PomodoroStats stats) {
    // Generate mock data for demonstration
    return [
      const FlSpot(0, 4),
      const FlSpot(1, 6),
      const FlSpot(2, 3),
      const FlSpot(3, 8),
      const FlSpot(4, 7),
      const FlSpot(5, 5),
      const FlSpot(6, 9),
    ];
  }

  void _shareStats() {
    // Implement stats sharing functionality
  }

  Widget _buildDailyPatternChart() {
    // Implementation for daily pattern chart
    return const SizedBox.shrink();
  }

  Widget _buildTaskCategoriesChart() {
    // Implementation for task categories chart  
    return const SizedBox.shrink();
  }

  Widget _buildProductivityTrendsChart() {
    // Implementation for productivity trends chart
    return const SizedBox.shrink();
  }

  Widget _buildFocusQualityMetrics(ProductivityAnalysis analysis) {
    // Implementation for focus quality metrics
    return const SizedBox.shrink();
  }

  Widget _buildBreakEfficiencyCard(ProductivityAnalysis analysis) {
    // Implementation for break efficiency card
    return const SizedBox.shrink();
  }

  Widget _buildTimeOfDayAnalysis() {
    // Implementation for time of day analysis
    return const SizedBox.shrink();
  }

  Widget _buildAchievementSummary(List<Achievement> unlocked, int total) {
    // Implementation for achievement summary
    return const SizedBox.shrink();
  }

  Widget _buildAchievementSection(String title, List<Achievement> achievements, bool isUnlocked) {
    // Implementation for achievement section
    return const SizedBox.shrink();
  }

  Widget _buildRecommendationCard(SmartRecommendation recommendation) {
    // Implementation for recommendation card
    return const SizedBox.shrink();
  }

  Widget _buildEmptyRecommendations() {
    // Implementation for empty recommendations state
    return const SizedBox.shrink();
  }
}