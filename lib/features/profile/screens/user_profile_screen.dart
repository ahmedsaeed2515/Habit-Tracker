// lib/features/profile/screens/user_profile_screen.dart
// صفحة الملف الشخصي الشاملة مع Firebase

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/firebase_user_service.dart';
import '../../../core/services/firebase_achievements_service.dart';
import '../../../core/services/firebase_social_service.dart';

/// شاشة الملف الشخصي
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseUserService _userService = FirebaseUserService();
  final FirebaseAchievementsService _achievementsService =
      FirebaseAchievementsService();
  final FirebaseSocialService _socialService = FirebaseSocialService();

  FirebaseUserData? _userData;
  List<Achievement> _achievements = [];
  List<UserAchievement> _userAchievements = [];
  Map<String, int> _interactionStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      // تهيئة Firebase إذا لم يكن مهيأ
      if (!_firebaseService.isInitialized) {
        await _firebaseService.initialize();
      }

      // الحصول على المستخدم الحالي أو تسجيل دخول ضيف
      var currentUser = _firebaseService.currentUser;
      if (currentUser == null) {
        await _firebaseService.signInAnonymously();
        currentUser = _firebaseService.currentUser;
      }

      if (currentUser != null) {
        // الحصول على بيانات المستخدم
        var userData = await _userService.getUserData(currentUser.uid);
        
        // إنشاء ملف مستخدم جديد إذا لم يكن موجود
        if (userData == null) {
          userData = FirebaseUserData(
            id: currentUser.uid,
            name: currentUser.displayName ?? 'مستخدم جديد',
            email: currentUser.email ?? 'guest@habittracker.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _userService.saveUserData(userData);
        }

        // الحصول على الإنجازات
        final achievements = await _achievementsService.getAllAchievements();
        final userAchievements =
            await _achievementsService.getUserAchievements(currentUser.uid);

        // الحصول على إحصائيات التفاعل
        final interactionStats =
            await _socialService.getInteractionStats(currentUser.uid);

        setState(() {
          _userData = userData;
          _achievements = achievements;
          _userAchievements = userAchievements;
          _interactionStats = interactionStats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تحميل بيانات المستخدم: $e');
      // العمل بدون Firebase
      setState(() {
        _userData = FirebaseUserData(
          id: 'offline_user',
          name: 'مستخدم محلي',
          email: 'offline@local.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الملف الشخصي' : 'Profile',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // تعديل الملف الشخصي
              _showEditProfileDialog(context, isArabic);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        isArabic
                            ? 'فشل تحميل البيانات'
                            : 'Failed to load data',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
                      ),
                    ],
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                        theme.colorScheme.secondary.withValues(alpha: 0.6),
                        theme.colorScheme.tertiary.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      // Header Card
                      _buildHeaderCard(context, isArabic),
                      const SizedBox(height: 16),
                      // Tabs
                      _buildTabs(context, isArabic),
                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildInfoTab(context, isArabic),
                            _buildAchievementsTab(context, isArabic),
                            _buildStatsTab(context, isArabic),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isArabic) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _userData!.name.isNotEmpty
                    ? _userData!.name[0].toUpperCase()
                    : '👤',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            _userData!.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            _userData!.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Level & Points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                icon: '🏆',
                label: isArabic ? 'المستوى' : 'Level',
                value: _userData!.level.toString(),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildStatItem(
                context,
                icon: '⭐',
                label: isArabic ? 'النقاط' : 'Points',
                value: _userData!.points.toString(),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildStatItem(
                context,
                icon: '🎯',
                label: isArabic ? 'الإنجازات' : 'Achievements',
                value: _userAchievements.length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, bool isArabic) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        tabs: [
          Tab(
            icon: const Icon(Icons.info_outline),
            text: isArabic ? 'المعلومات' : 'Info',
          ),
          Tab(
            icon: const Icon(Icons.emoji_events),
            text: isArabic ? 'الإنجازات' : 'Achievements',
          ),
          Tab(
            icon: const Icon(Icons.bar_chart),
            text: isArabic ? 'الإحصائيات' : 'Stats',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, bool isArabic) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(
              context,
              icon: Icons.person,
              label: isArabic ? 'الاسم' : 'Name',
              value: _userData!.name,
            ),
            const Divider(height: 32),
            _buildInfoItem(
              context,
              icon: Icons.email,
              label: isArabic ? 'البريد الإلكتروني' : 'Email',
              value: _userData!.email,
            ),
            const Divider(height: 32),
            _buildInfoItem(
              context,
              icon: Icons.info,
              label: isArabic ? 'عني' : 'Bio',
              value: _userData!.bio ?? (isArabic ? 'لا يوجد' : 'No bio'),
            ),
            const Divider(height: 32),
            _buildInfoItem(
              context,
              icon: Icons.calendar_today,
              label: isArabic ? 'تاريخ الانضمام' : 'Joined',
              value:
                  '${_userData!.createdAt.day}/${_userData!.createdAt.month}/${_userData!.createdAt.year}',
            ),
            const Divider(height: 32),
            _buildInfoItem(
              context,
              icon: Icons.cloud,
              label: isArabic ? 'حالة الاتصال' : 'Connection Status',
              value: _firebaseService.isInitialized
                  ? (isArabic ? 'متصل' : 'Connected')
                  : (isArabic ? 'غير متصل - وضع محلي' : 'Offline - Local Mode'),
              valueColor: _firebaseService.isInitialized
                  ? Colors.green
                  : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab(BuildContext context, bool isArabic) {
    final unlockedIds = _userAchievements.map((ua) => ua.achievementId).toSet();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _achievements.isEmpty
          ? Center(
              child: Text(
                isArabic ? 'لا توجد إنجازات بعد' : 'No achievements yet',
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievements[index];
                final isUnlocked = unlockedIds.contains(achievement.id);
                
                return _buildAchievementCard(
                  context,
                  achievement,
                  isUnlocked,
                  isArabic,
                );
              },
            ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    Achievement achievement,
    bool isUnlocked,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isUnlocked
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            achievement.icon,
            style: TextStyle(
              fontSize: 40,
              color: isUnlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? achievement.nameAr : achievement.nameEn,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? null : Colors.grey,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${achievement.points} ${isArabic ? 'نقطة' : 'pts'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(BuildContext context, bool isArabic) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'إحصائيات التفاعل' : 'Interaction Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildStatCard(
              context,
              icon: '📤',
              label: isArabic ? 'التفاعلات المرسلة' : 'Sent Interactions',
              value: _interactionStats['sent']?.toString() ?? '0',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              icon: '📥',
              label: isArabic ? 'التفاعلات المستلمة' : 'Received Interactions',
              value: _interactionStats['received']?.toString() ?? '0',
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              icon: '💪',
              label: isArabic ? 'رسائل التشجيع' : 'Encouragements',
              value: _interactionStats['encouragements']?.toString() ?? '0',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              icon: '🎁',
              label: isArabic ? 'الهدايا المرسلة' : 'Gifts Sent',
              value: _interactionStats['gifts']?.toString() ?? '0',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, bool isArabic) {
    final nameController = TextEditingController(text: _userData!.name);
    final bioController = TextEditingController(text: _userData!.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isArabic ? 'الاسم' : 'Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: isArabic ? 'عني' : 'Bio',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedData = _userData!.copyWith(
                name: nameController.text,
                bio: bioController.text,
              );
              
              await _userService.saveUserData(updatedData);
              
              setState(() {
                _userData = updatedData;
              });
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic ? 'تم التحديث بنجاح' : 'Updated successfully',
                    ),
                  ),
                );
              }
            },
            child: Text(isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }
}
