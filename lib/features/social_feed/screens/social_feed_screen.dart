// lib/features/social_feed/screens/social_feed_screen.dart
// صفحة التفاعل الاجتماعي والتشجيع

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/firebase_user_service.dart';
import '../../../core/services/firebase_social_service.dart';

/// شاشة التفاعل الاجتماعي
class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseUserService _userService = FirebaseUserService();
  final FirebaseSocialService _socialService = FirebaseSocialService();

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
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isArabic ? 'التفاعل الاجتماعي' : 'Social Feed',
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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // البحث عن مستخدمين
              _showUsersSearch(context, isArabic);
            },
          ),
        ],
      ),
      body: DecoratedBox(
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
            const const SizedBox(height: 100),
            // Tabs
            _buildTabs(context, isArabic),
            const const SizedBox(height: 16),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAchievementsTab(context, isArabic),
                  _buildLeaderboardTab(context, isArabic),
                  _buildInteractionsTab(context, isArabic),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSendGiftDialog(context, isArabic);
        },
        icon: const Icon(Icons.card_giftcard),
        label: Text(isArabic ? 'إرسال هدية' : 'Send Gift'),
        backgroundColor: theme.colorScheme.primary,
      ),
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
            icon: const Icon(Icons.emoji_events),
            text: isArabic ? 'الإنجازات' : 'Achievements',
          ),
          Tab(
            icon: const Icon(Icons.leaderboard),
            text: isArabic ? 'المتصدرين' : 'Leaderboard',
          ),
          Tab(
            icon: const Icon(Icons.favorite),
            text: isArabic ? 'التفاعلات' : 'Interactions',
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(BuildContext context, bool isArabic) {
    return StreamBuilder<List<AchievementShare>>(
      stream: _socialService.getAchievementShares(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events_outlined, size: 64),
                const const SizedBox(height: 16),
                Text(
                  isArabic
                      ? 'لا توجد إنجازات مشتركة بعد'
                      : 'No shared achievements yet',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final share = snapshot.data![index];
            return _buildAchievementCard(context, share, isArabic);
          },
        );
      },
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    AchievementShare share,
    bool isArabic,
  ) {
    return FutureBuilder<FirebaseUserData?>(
      future: _userService.getUserData(share.userId),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      user?.name.isNotEmpty ?? false
                          ? user!.name[0].toUpperCase()
                          : '👤',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? (isArabic ? 'مستخدم' : 'User'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatTime(share.createdAt, isArabic),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const const SizedBox(height: 12),
              // Achievement caption
              Text(
                share.caption,
                style: const TextStyle(fontSize: 16),
              ),
              const const SizedBox(height: 12),
              // Actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      _socialService.likeShare(share.id);
                    },
                  ),
                  Text('${share.likes}'),
                  const const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      _showCommentDialog(context, share.id, isArabic);
                    },
                  ),
                  Text('${share.comments.length}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined),
                    onPressed: () {
                      _sendEncouragement(share.userId, isArabic);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab(BuildContext context, bool isArabic) {
    return StreamBuilder<List<FirebaseUserData>>(
      stream: _userService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.leaderboard_outlined, size: 64),
                const const SizedBox(height: 16),
                Text(
                  isArabic ? 'لا يوجد مستخدمين بعد' : 'No users yet',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final user = snapshot.data![index];
            return _buildLeaderboardCard(context, user, index + 1, isArabic);
          },
        );
      },
    );
  }

  Widget _buildLeaderboardCard(
    BuildContext context,
    FirebaseUserData user,
    int rank,
    bool isArabic,
  ) {
    final rankIcon = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : rank == 3
                ? '🥉'
                : '$rank';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rankIcon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const const SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('⭐'),
                    const const SizedBox(width: 4),
                    Text(
                      '${user.points} ${isArabic ? 'نقطة' : 'points'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              _showSendGiftToUserDialog(context, user.id, user.name, isArabic);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionsTab(BuildContext context, bool isArabic) {
    final currentUser = _firebaseService.currentUser;
    if (currentUser == null) {
      return Center(
        child: Text(
          isArabic ? 'يرجى تسجيل الدخول' : 'Please sign in',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<List<SocialInteraction>>(
      stream: _socialService.getUserInteractions(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 64),
                const const SizedBox(height: 16),
                Text(
                  isArabic ? 'لا توجد تفاعلات بعد' : 'No interactions yet',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final interaction = snapshot.data![index];
            return _buildInteractionCard(context, interaction, isArabic);
          },
        );
      },
    );
  }

  Widget _buildInteractionCard(
    BuildContext context,
    SocialInteraction interaction,
    bool isArabic,
  ) {
    final icon = interaction.type == 'encouragement'
        ? '💪'
        : interaction.type == 'gift'
            ? '🎁'
            : '👍';

    return FutureBuilder<FirebaseUserData?>(
      future: _userService.getUserData(interaction.fromUserId),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? (isArabic ? 'مستخدم' : 'User'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const const SizedBox(height: 4),
                    Text(
                      interaction.message ??
                          _getInteractionText(interaction.type, isArabic),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (interaction.points > 0) ...[
                      const const SizedBox(height: 4),
                      Text(
                        '+${interaction.points} ${isArabic ? 'نقطة' : 'points'}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                _formatTime(interaction.createdAt, isArabic),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getInteractionText(String type, bool isArabic) {
    switch (type) {
      case 'encouragement':
        return isArabic ? 'أرسل لك رسالة تشجيع' : 'Sent you encouragement';
      case 'gift':
        return isArabic ? 'أرسل لك هدية' : 'Sent you a gift';
      default:
        return isArabic ? 'تفاعل معك' : 'Interacted with you';
    }
  }

  String _formatTime(DateTime dateTime, bool isArabic) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return isArabic ? 'الآن' : 'Now';
    } else if (difference.inHours < 1) {
      return isArabic
          ? 'منذ ${difference.inMinutes} دقيقة'
          : '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return isArabic
          ? 'منذ ${difference.inHours} ساعة'
          : '${difference.inHours}h ago';
    } else {
      return isArabic
          ? 'منذ ${difference.inDays} يوم'
          : '${difference.inDays}d ago';
    }
  }

  Future<void> _sendEncouragement(String toUserId, bool isArabic) async {
    final currentUser = _firebaseService.currentUser;
    if (currentUser == null) return;

    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'إرسال تشجيع' : 'Send Encouragement'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isArabic ? 'اكتب رسالة تشجيع...' : 'Write encouragement...',
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(isArabic ? 'إرسال' : 'Send'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _socialService.sendEncouragement(
        currentUser.uid,
        toUserId,
        result,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? 'تم إرسال التشجيع' : 'Encouragement sent'),
          ),
        );
      }
    }
  }

  void _showSendGiftDialog(BuildContext context, bool isArabic) {
    _showUsersSearch(context, isArabic);
  }

  Future<void> _showSendGiftToUserDialog(
    BuildContext context,
    String userId,
    String userName,
    bool isArabic,
  ) async {
    final currentUser = _firebaseService.currentUser;
    if (currentUser == null) return;

    final gifts = [
      {'icon': '⭐', 'name': isArabic ? 'نجمة' : 'Star', 'points': 5},
      {'icon': '💎', 'name': isArabic ? 'ماسة' : 'Diamond', 'points': 10},
      {'icon': '🏆', 'name': isArabic ? 'كأس' : 'Trophy', 'points': 20},
      {'icon': '👑', 'name': isArabic ? 'تاج' : 'Crown', 'points': 50},
    ];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isArabic ? 'إرسال هدية إلى $userName' : 'Send gift to $userName',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: gifts.map((gift) {
            return ListTile(
              leading: Text(gift['icon']! as String,
                  style: const TextStyle(fontSize: 32)),
              title: Text(gift['name']! as String),
              subtitle: Text('${gift['points']} ${isArabic ? 'نقطة' : 'pts'}'),
              onTap: () => Navigator.pop(context, gift),
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      await _socialService.sendGift(
        currentUser.uid,
        userId,
        result['name'] as String,
        result['points'] as int,
      );
      
      await _userService.updatePoints(userId, result['points'] as int);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? 'تم إرسال الهدية' : 'Gift sent'),
          ),
        );
      }
    }
  }

  Future<void> _showUsersSearch(BuildContext context, bool isArabic) async {
    final controller = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: isArabic ? 'ابحث عن مستخدمين...' : 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  // البحث
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<FirebaseUserData>>(
                stream: _userService.getUsersStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '👤',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user.name),
                        subtitle: Text('${user.points} ${isArabic ? 'نقطة' : 'points'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.card_giftcard),
                          onPressed: () {
                            Navigator.pop(context);
                            _showSendGiftToUserDialog(
                              context,
                              user.id,
                              user.name,
                              isArabic,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCommentDialog(
    BuildContext context,
    String shareId,
    bool isArabic,
  ) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'إضافة تعليق' : 'Add Comment'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isArabic ? 'اكتب تعليقك...' : 'Write your comment...',
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(isArabic ? 'إضافة' : 'Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _socialService.addComment(shareId, result);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? 'تم إضافة التعليق' : 'Comment added'),
          ),
        );
      }
    }
  }
}
