import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// ويدجت التحكم السريع في إعدادات البومودورو
class PomodoroQuickSettingsWidget extends ConsumerWidget {
  const PomodoroQuickSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pomodoroSettingsProvider);
    final activeSession = ref.watch(activeSessionProvider);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tune,
                  size: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'إعدادات سريعة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (activeSession != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSessionColor(activeSession.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'جلسة نشطة',
                      style: TextStyle(
                        color: _getSessionColor(activeSession.type),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Settings Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Focus Duration
                _buildDurationSlider(
                  context,
                  ref,
                  'مدة التركيز',
                  Icons.timer,
                  Colors.blue,
                  settings.focusSession.inMinutes.toDouble(),
                  5,
                  60,
                  (value) {
                    ref.read(pomodoroSettingsProvider.notifier)
                        .updateFocusSession(Duration(minutes: value.round()));
                  },
                  enabled: activeSession == null,
                ),
                
                const SizedBox(height: 16),
                
                // Break Duration
                _buildDurationSlider(
                  context,
                  ref,
                  'مدة الاستراحة',
                  Icons.coffee,
                  Colors.brown,
                  settings.shortBreak.inMinutes.toDouble(),
                  1,
                  30,
                  (value) {
                    ref.read(pomodoroSettingsProvider.notifier)
                        .updateShortBreak(Duration(minutes: value.round()));
                  },
                  enabled: activeSession == null,
                ),
                
                const SizedBox(height: 16),
                
                // Quick Toggle Options
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleCard(
                        context,
                        ref,
                        'التبديل التلقائي',
                        Icons.autorenew,
                        Colors.green,
                        settings.autoStartBreak,
                        (value) {
                          ref.read(pomodoroSettingsProvider.notifier)
                              .updateAutoStartBreak(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildToggleCard(
                        context,
                        ref,
                        'التشغيل الخلفي',
                        Icons.layers,
                        Colors.purple,
                        settings.backgroundMode,
                        (value) {
                          ref.read(pomodoroSettingsProvider.notifier)
                              .updateBackgroundMode(value);
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleCard(
                        context,
                        ref,
                        'الأصوات',
                        Icons.volume_up,
                        Colors.orange,
                        settings.soundEnabled,
                        (value) {
                          ref.read(pomodoroSettingsProvider.notifier)
                              .updateSoundEnabled(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildToggleCard(
                        context,
                        ref,
                        'الاهتزاز',
                        Icons.vibration,
                        Colors.pink,
                        settings.vibrateEnabled,
                        (value) {
                          ref.read(pomodoroSettingsProvider.notifier)
                              .updateVibrateEnabled(value);
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Session Target
                _buildTargetSelector(context, ref, settings),
                
                const SizedBox(height: 16),
                
                // Preset Buttons
                _buildPresetButtons(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSlider(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    Color color,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.round()} دقيقة',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 4.0,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? color.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: value ? color : Colors.grey,
                size: 18,
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: color,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: value ? color : Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetSelector(
    BuildContext context,
    WidgetRef ref,
    PomodoroSettings settings,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.flag,
                color: Colors.blue,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'الهدف اليومي',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [2, 4, 6, 8, 10, 12].map((target) {
              final isSelected = settings.dailyGoal == target;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: isSelected
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      onTap: () {
                        ref.read(pomodoroSettingsProvider.notifier)
                            .updateDailyGoal(target);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$target',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButtons(BuildContext context, WidgetRef ref) {
    final presets = [
      {
        'name': 'تقليدي',
        'focus': 25,
        'short': 5,
        'long': 30,
        'color': Colors.red,
        'icon': Icons.access_time,
      },
      {
        'name': 'مكثف',
        'focus': 45,
        'short': 10,
        'long': 30,
        'color': Colors.orange,
        'icon': Icons.flash_on,
      },
      {
        'name': 'مريح',
        'focus': 15,
        'short': 3,
        'long': 15,
        'color': Colors.green,
        'icon': Icons.self_improvement,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.palette, color: Colors.purple, size: 18),
            SizedBox(width: 8),
            Text(
              'إعدادات جاهزة',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: presets.map((preset) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: (preset['color']! as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => _applyPreset(ref, preset),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Icon(
                            preset['icon']! as IconData,
                            color: preset['color']! as Color,
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preset['name']! as String,
                            style: TextStyle(
                              color: preset['color']! as Color,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${preset['focus']}/${preset['short']}',
                            style: TextStyle(
                              color: (preset['color']! as Color).withValues(alpha: 0.7),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _applyPreset(WidgetRef ref, Map<String, dynamic> preset) {
    final settingsNotifier = ref.read(pomodoroSettingsProvider.notifier);
    
    settingsNotifier.updateFocusSession(
      Duration(minutes: preset['focus'] as int),
    );
    settingsNotifier.updateShortBreak(
      Duration(minutes: preset['short'] as int),
    );
    settingsNotifier.updateLongBreak(
      Duration(minutes: preset['long'] as int),
    );
    
    // Show confirmation
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('تم تطبيق إعدادات ${preset['name']}'),
        duration: const Duration(seconds: 2),
        backgroundColor: preset['color'] as Color,
      ),
    );
  }

  Color _getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return Colors.blue;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

/// ويدجت التحكم السريع في الإشعارات
class NotificationQuickControlWidget extends ConsumerWidget {
  const NotificationQuickControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pomodoroSettingsProvider);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'إعدادات الإشعارات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Notification Types
          _buildNotificationToggle(
            context,
            ref,
            'إشعارات الجلسات',
            'تنبيه عند بداية ونهاية الجلسات',
            Icons.timer,
            Colors.blue,
            settings.showNotifications,
            (value) {
              ref.read(pomodoroSettingsProvider.notifier)
                  .updateShowNotifications(value);
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationToggle(
            context,
            ref,
            'تذكير المهام',
            'تذكير بالمهام المجدولة والمتأخرة',
            Icons.task,
            Colors.orange,
            settings.taskReminders,
            (value) {
              ref.read(pomodoroSettingsProvider.notifier)
                  .updateTaskReminders(value);
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationToggle(
            context,
            ref,
            'إنجازات جديدة',
            'تنبيه عند الحصول على إنجاز جديد',
            Icons.emoji_events,
            Colors.amber,
            settings.achievementNotifications,
            (value) {
              ref.read(pomodoroSettingsProvider.notifier)
                  .updateAchievementNotifications(value);
            },
          ),
          
          if (settings.showNotifications) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Sound Selection
            _buildSoundSelector(context, ref, settings),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context,
    WidgetRef ref,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? color.withValues(alpha: 0.05) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? color : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: value ? color : null,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSelector(
    BuildContext context,
    WidgetRef ref,
    PomodoroSettings settings,
  ) {
    final sounds = [
      {'name': 'نغمة لطيفة', 'file': 'gentle.mp3', 'icon': Icons.music_note},
      {'name': 'جرس', 'file': 'bell.mp3', 'icon': Icons.notifications},
      {'name': 'تنبيه', 'file': 'alert.mp3', 'icon': Icons.warning},
      {'name': 'صفير', 'file': 'whistle.mp3', 'icon': Icons.sports_soccer},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صوت الإشعار',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...sounds.map((sound) {
          final isSelected = settings.notificationSound == sound['file'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Material(
              color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  ref.read(pomodoroSettingsProvider.notifier)
                      .updateNotificationSound(sound['file']! as String);
                  // تشغيل الصوت للمعاينة
                  _playPreviewSound(sound['file']! as String);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        sound['icon']! as IconData,
                        color: isSelected ? Colors.blue : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          sound['name']! as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.blue : null,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _playPreviewSound(String soundFile) {
    // تشغيل معاينة للصوت
    // يمكن استخدام مكتبة audioplayers أو flutter/services
  }
}