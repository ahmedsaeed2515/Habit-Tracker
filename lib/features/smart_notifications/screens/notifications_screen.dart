// lib/features/smart_notifications/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/smart_notification.dart';
import '../providers/smart_notifications_provider.dart';
import '../widgets/notification_card.dart';
import '../../../common/widgets/empty_state_widget.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  NotificationType? _selectedTypeFilter;

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
    final state = ref.watch(smartNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإشعارات'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSettingsSheet(context),
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('إضافة إشعار'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'motivational',
                child: ListTile(
                  leading: Icon(Icons.auto_awesome),
                  title: Text('تفعيل الرسائل التحفيزية'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('حذف جميع الإشعارات'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'نشطة', icon: Icon(Icons.notifications_active)),
            Tab(text: 'جميع الإشعارات', icon: Icon(Icons.notifications)),
            Tab(text: 'الإحصائيات', icon: Icon(Icons.analytics)),
          ],
        ),
      ),

      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
          ? _buildErrorState(state.errorMessage!)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveNotifications(state.notifications),
                _buildAllNotifications(state.notifications),
                _buildStatistics(state.notifications),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNotificationDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveNotifications(List<SmartNotification> notifications) {
    final activeNotifications = notifications.where((n) => n.isActive).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    return _buildNotificationsList(
      activeNotifications,
      emptyMessage: 'لا توجد إشعارات نشطة',
      emptyDescription: 'جميع الإشعارات معطلة حالياً',
      showFilter: true,
    );
  }

  Widget _buildAllNotifications(List<SmartNotification> notifications) {
    var filteredNotifications = notifications.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (_selectedTypeFilter != null) {
      filteredNotifications = filteredNotifications
          .where((n) => n.type == _selectedTypeFilter)
          .toList();
    }

    return _buildNotificationsList(
      filteredNotifications,
      emptyMessage: 'لا توجد إشعارات',
      emptyDescription: 'لم يتم إنشاء أي إشعارات بعد',
      showFilter: true,
    );
  }

  Widget _buildNotificationsList(
    List<SmartNotification> notifications, {
    required String emptyMessage,
    required String emptyDescription,
    bool showFilter = false,
  }) {
    return Column(
      children: [
        if (showFilter) _buildFilterChips(),

        Expanded(
          child: notifications.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.notifications_none,
                  title: emptyMessage,
                  description: emptyDescription,
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    // تحديث القائمة
                    ref.invalidate(smartNotificationsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) =>
                        NotificationCard(notification: notifications[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: _selectedTypeFilter == null,
            onSelected: (selected) {
              setState(() {
                _selectedTypeFilter = null;
              });
            },
          ),
          const SizedBox(width: 8),
          ...NotificationType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Text(type.icon),
                label: Text(type.displayName),
                selected: _selectedTypeFilter == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedTypeFilter = selected ? type : null;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(List<SmartNotification> notifications) {
    final activeCount = notifications.where((n) => n.isActive).length;
    final totalSent = notifications.fold<int>(0, (sum, n) => sum + n.sentCount);
    final typeStats = <NotificationType, int>{};

    for (final notification in notifications) {
      typeStats[notification.type] = (typeStats[notification.type] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات عامة
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات عامة',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildStatRow(
                    'إجمالي الإشعارات',
                    '${notifications.length}',
                    Icons.notifications,
                  ),
                  _buildStatRow(
                    'الإشعارات النشطة',
                    '$activeCount',
                    Icons.notifications_active,
                  ),
                  _buildStatRow('إجمالي المرسلة', '$totalSent', Icons.send),
                  _buildStatRow(
                    'متوسط الإرسال',
                    notifications.isEmpty
                        ? '0'
                        : '${(totalSent / notifications.length).toStringAsFixed(1)}',
                    Icons.analytics,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // إحصائيات حسب النوع
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات حسب النوع',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...typeStats.entries.map(
                    (entry) => _buildStatRow(
                      '${entry.key.icon} ${entry.key.displayName}',
                      '${entry.value}',
                      Icons.category,
                    ),
                  ),

                  if (typeStats.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('لا توجد بيانات لعرضها'),
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

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(smartNotificationsProvider.notifier).clearError();
              ref.invalidate(smartNotificationsProvider);
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showAddNotificationDialog(BuildContext context) {
    // TODO: فتح حوار إضافة إشعار جديد
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة إشعار جديد'),
        content: const Text('هذه الميزة قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    final theme = Theme.of(context);
    final notifier = ref.read(smartNotificationsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'إعدادات الإشعارات',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // إعدادات تفعيل الإشعارات
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(smartNotificationsProvider);

                  return Column(
                    children: [
                      _buildSettingTile(
                        'إشعارات العادات',
                        'تذكيرات للعادات اليومية',
                        Icons.task_alt,
                        state.notificationSettings['habits'] ?? true,
                        (value) => notifier.setSetting('habits', value),
                      ),

                      _buildSettingTile(
                        'إشعارات المهام',
                        'تذكيرات للمهام والأعمال',
                        Icons.assignment,
                        state.notificationSettings['tasks'] ?? true,
                        (value) => notifier.setSetting('tasks', value),
                      ),

                      _buildSettingTile(
                        'إشعارات التمارين',
                        'تذكيرات للتمارين والنشاط',
                        Icons.fitness_center,
                        state.notificationSettings['workouts'] ?? true,
                        (value) => notifier.setSetting('workouts', value),
                      ),

                      _buildSettingTile(
                        'الرسائل التحفيزية',
                        'رسائل إيجابية وتحفيزية',
                        Icons.auto_awesome,
                        state.notificationSettings['motivational'] ?? true,
                        (value) => notifier.setSetting('motivational', value),
                      ),

                      _buildSettingTile(
                        'إشعارات الإنجازات',
                        'إشعارات عند تحقيق الأهداف',
                        Icons.emoji_events,
                        state.notificationSettings['achievements'] ?? true,
                        (value) => notifier.setSetting('achievements', value),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => notifier.openSystemSettings(),
                      icon: const Icon(Icons.settings),
                      label: const Text('إعدادات النظام'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final hasPermissions = await notifier
                            .checkPermissions();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                hasPermissions
                                    ? 'الأذونات ممنوحة ✅'
                                    : 'يرجى منح الأذونات المطلوبة',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('فحص الأذونات'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch.adaptive(value: value, onChanged: onChanged),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    );
  }

  void _handleMenuAction(String action) {
    final notifier = ref.read(smartNotificationsProvider.notifier);

    switch (action) {
      case 'add':
        _showAddNotificationDialog(context);
        break;

      case 'motivational':
        notifier.createDailyMotivationalNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تفعيل الرسائل التحفيزية اليومية ✅')),
        );
        break;

      case 'clear':
        _showClearAllDialog();
        break;
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف جميع الإشعارات'),
        content: const Text(
          'هل أنت متأكد من حذف جميع الإشعارات؟\n'
          'هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(smartNotificationsProvider.notifier)
                  .clearAllNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف جميع الإشعارات')),
              );
            },
            child: const Text('حذف الكل'),
          ),
        ],
      ),
    );
  }
}
