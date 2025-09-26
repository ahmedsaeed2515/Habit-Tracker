import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// شاشة إدارة الإنجازات والمكافآت
class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _celebrationController;
  late AnimationController _filterController;
  String _selectedFilter = 'all';
  
  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievements = ref.watch(achievementsProvider);
    final filteredAchievements = _filterAchievements(achievements);
    final stats = _calculateStats(achievements);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          // App Bar with Stats
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A0E21),
                      Colors.blue.withOpacity(0.2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'الإنجازات والمكافآت',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'المكتسبة',
                                '${stats['unlocked']}',
                                '/${achievements.length}',
                                Colors.green,
                                Icons.emoji_events,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'النقاط',
                                '${stats['totalPoints']}',
                                'نقطة',
                                Colors.amber,
                                Icons.stars,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'المستوى',
                                '${stats['level']}',
                                '',
                                Colors.purple,
                                Icons.military_tech,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('الكل', 'all', achievements.length),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'المكتسبة', 
                      'unlocked', 
                      achievements.where((a) => a.isUnlocked).length,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'متاحة', 
                      'available', 
                      achievements.where((a) => !a.isUnlocked).length,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'الجلسات', 
                      'sessions', 
                      achievements.where((a) => a.category == AchievementCategory.sessions).length,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'المهام', 
                      'tasks', 
                      achievements.where((a) => a.category == AchievementCategory.tasks).length,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Achievements Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final achievement = filteredAchievements[index];
                  return _buildAchievementCard(achievement);
                },
                childCount: filteredAchievements.length,
              ),
            ),
          ),

          // Progress Section
          if (_selectedFilter == 'available') ...[
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'قريباً من الإنجاز',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...filteredAchievements
                        .where((a) => !a.isUnlocked && a.progress > 0.5)
                        .map((a) => _buildProgressCard(a))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAchievementDialog(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.info, color: Colors.white),
        label: const Text(
          'كيفية الحصول على الإنجازات',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String suffix,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (suffix.isNotEmpty)
                Text(
                  suffix,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String title, String value, int count) {
    final isSelected = _selectedFilter == value;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          '$title ($count)',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
        ),
        selectedColor: Colors.blue,
        backgroundColor: Colors.white.withOpacity(0.1),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.3),
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final progress = achievement.progress;
    final isUnlocked = achievement.isUnlocked;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        color: isUnlocked 
            ? _getCategoryColor(achievement.category).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isUnlocked 
                ? _getCategoryColor(achievement.category)
                : Colors.grey.withOpacity(0.3),
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => _showAchievementDetails(achievement),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnlocked 
                            ? _getCategoryColor(achievement.category).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(achievement.category),
                        color: isUnlocked 
                            ? _getCategoryColor(achievement.category)
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'مكتسب',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white70 : Colors.grey,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const Spacer(),
                
                // Progress or Points
                if (isUnlocked) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${achievement.points} نقطة',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '${achievement.currentValue}/${achievement.targetValue}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCategoryColor(achievement.category),
                        ),
                        minHeight: 4,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(Achievement achievement) {
    final progress = achievement.progress;
    final remaining = achievement.targetValue - achievement.currentValue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getCategoryColor(achievement.category).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(achievement.category).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(achievement.category),
              color: _getCategoryColor(achievement.category),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'باقي $remaining ${_getUnitName(achievement.category)}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getCategoryColor(achievement.category),
                  ),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: _getCategoryColor(achievement.category),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Achievement> _filterAchievements(List<Achievement> achievements) {
    switch (_selectedFilter) {
      case 'unlocked':
        return achievements.where((a) => a.isUnlocked).toList();
      case 'available':
        return achievements.where((a) => !a.isUnlocked).toList();
      case 'sessions':
        return achievements.where((a) => a.category == AchievementCategory.sessions).toList();
      case 'tasks':
        return achievements.where((a) => a.category == AchievementCategory.tasks).toList();
      default:
        return achievements;
    }
  }

  Map<String, int> _calculateStats(List<Achievement> achievements) {
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    final totalPoints = achievements
        .where((a) => a.isUnlocked)
        .fold<int>(0, (sum, a) => sum + a.points);
    final level = (totalPoints / 100).floor() + 1;
    
    return {
      'unlocked': unlocked,
      'totalPoints': totalPoints,
      'level': level,
    };
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.sessions:
        return Colors.blue;
      case AchievementCategory.tasks:
        return Colors.green;
      case AchievementCategory.streaks:
        return Colors.orange;
      case AchievementCategory.time:
        return Colors.purple;
      case AchievementCategory.special:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.sessions:
        return Icons.timer;
      case AchievementCategory.tasks:
        return Icons.task_alt;
      case AchievementCategory.streaks:
        return Icons.local_fire_department;
      case AchievementCategory.time:
        return Icons.access_time;
      case AchievementCategory.special:
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }

  String _getUnitName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.sessions:
        return 'جلسة';
      case AchievementCategory.tasks:
        return 'مهمة';
      case AchievementCategory.streaks:
        return 'يوم';
      case AchievementCategory.time:
        return 'دقيقة';
      default:
        return '';
    }
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AchievementDetailsDialog(achievement: achievement),
    );
  }

  void _showAchievementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AchievementGuideDialog(),
    );
  }
}

/// حوار تفاصيل الإنجاز
class AchievementDetailsDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementDetailsDialog({
    Key? key,
    required this.achievement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1D1E33),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                achievement.isUnlocked ? Icons.emoji_events : Icons.lock,
                color: achievement.isUnlocked ? Colors.green : Colors.grey,
                size: 48,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              achievement.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              achievement.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Progress or Reward
            if (achievement.isUnlocked) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'حصلت على ${achievement.points} نقطة',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'التقدم: ${achievement.currentValue}/${achievement.targetValue}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: achievement.progress,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Close Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إغلاق',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// حوار دليل الإنجازات
class AchievementGuideDialog extends StatelessWidget {
  const AchievementGuideDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1D1E33),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'كيفية الحصول على الإنجازات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildGuideItem(
              Icons.timer,
              Colors.blue,
              'إنجازات الجلسات',
              'أكمل عدد معين من جلسات البومودورو',
            ),
            
            _buildGuideItem(
              Icons.task_alt,
              Colors.green,
              'إنجازات المهام',
              'أنجز مهامك اليومية والأسبوعية',
            ),
            
            _buildGuideItem(
              Icons.local_fire_department,
              Colors.orange,
              'إنجازات الاستمرارية',
              'حافظ على العمل لعدة أيام متتالية',
            ),
            
            _buildGuideItem(
              Icons.access_time,
              Colors.purple,
              'إنجازات الوقت',
              'اجمع ساعات معينة من التركيز',
            ),
            
            const SizedBox(height: 24),
            
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'فهمت',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(
    IconData icon,
    Color color,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}