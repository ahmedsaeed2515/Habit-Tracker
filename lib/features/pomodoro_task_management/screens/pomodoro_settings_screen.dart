import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// شاشة إعدادات Pomodoro
class PomodoroSettingsScreen extends ConsumerStatefulWidget {
  const PomodoroSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends ConsumerState<PomodoroSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(pomodoroSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات Pomodoro'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Timer Settings Section
          _buildSectionTitle('إعدادات المؤقت'),
          _buildTimerSettingsCard(context, settings),
          
          const SizedBox(height: 20),
          
          // Automation Settings Section
          _buildSectionTitle('الإعدادات التلقائية'),
          _buildAutomationSettingsCard(context, settings),
          
          const SizedBox(height: 20),
          
          // Notification Settings Section
          _buildSectionTitle('إعدادات الإشعارات'),
          _buildNotificationSettingsCard(context, settings),
          
          const SizedBox(height: 20),
          
          // Audio Settings Section
          _buildSectionTitle('إعدادات الصوت'),
          _buildAudioSettingsCard(context, settings),
          
          const SizedBox(height: 20),
          
          // Advanced Settings Section
          _buildSectionTitle('الإعدادات المتقدمة'),
          _buildAdvancedSettingsCard(context, settings),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildTimerSettingsCard(BuildContext context, PomodoroSettings settings) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDurationSetting(
              'مدة جلسة التركيز',
              settings.focusSession,
              Icons.psychology,
              Colors.red,
              (duration) => ref.read(pomodoroSettingsProvider.notifier)
                  .updateFocusSession(duration),
            ),
            
            const Divider(),
            
            _buildDurationSetting(
              'مدة الاستراحة القصيرة',
              settings.shortBreak,
              Icons.coffee,
              Colors.green,
              (duration) => ref.read(pomodoroSettingsProvider.notifier)
                  .updateShortBreak(duration),
            ),
            
            const Divider(),
            
            _buildDurationSetting(
              'مدة الاستراحة الطويلة',
              settings.longBreak,
              Icons.self_improvement,
              Colors.blue,
              (duration) => ref.read(pomodoroSettingsProvider.notifier)
                  .updateLongBreak(duration),
            ),
            
            const Divider(),
            
            _buildIntervalSetting(
              'فترة الاستراحة الطويلة',
              'بعد كم جلسة تركيز',
              settings.longBreakInterval,
              Icons.repeat,
              Colors.purple,
              (interval) => ref.read(pomodoroSettingsProvider.notifier)
                  .updateLongBreakInterval(interval),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationSettingsCard(BuildContext context, PomodoroSettings settings) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchSetting(
              'بدء تلقائي للاستراحات',
              'يبدأ الاستراحة تلقائياً بعد انتهاء جلسة التركيز',
              settings.autoStartBreaks,
              Icons.play_circle,
              Colors.green,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .toggleAutoStartBreaks(),
            ),
            
            const Divider(height: 24),
            
            _buildSwitchSetting(
              'بدء تلقائي لجلسات التركيز',
              'يبدأ جلسة التركيز تلقائياً بعد انتهاء الاستراحة',
              settings.autoStartFocus,
              Icons.psychology,
              Colors.red,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .toggleAutoStartFocus(),
            ),
            
            const Divider(height: 24),
            
            _buildSwitchSetting(
              'الوضع في الخلفية',
              'استمرار عمل المؤقت في الخلفية',
              settings.enableBackgroundMode,
              Icons.cloud_queue,
              Colors.blue,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .toggleBackgroundMode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettingsCard(BuildContext context, PomodoroSettings settings) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchSetting(
              'تفعيل الإشعارات',
              'إظهار إشعارات عند بداية ونهاية الجلسات',
              settings.enableNotifications,
              Icons.notifications,
              Colors.orange,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .toggleNotifications(),
            ),
            
            const Divider(height: 24),
            
            _buildSwitchSetting(
              'الاهتزاز',
              'اهتزاز الهاتف مع الإشعارات',
              settings.enableVibration,
              Icons.vibration,
              Colors.purple,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .toggleVibration(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioSettingsCard(BuildContext context, PomodoroSettings settings) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSliderSetting(
              'مستوى الصوت',
              settings.soundVolume,
              Icons.volume_up,
              Colors.indigo,
              0.0,
              1.0,
              (value) => ref.read(pomodoroSettingsProvider.notifier)
                  .updateSoundVolume(value),
            ),
            
            const SizedBox(height: 16),
            
            _buildSoundSelection(
              'صوت جلسة التركيز',
              settings.focusSound,
              Icons.psychology,
              Colors.red,
            ),
            
            const Divider(height: 24),
            
            _buildSoundSelection(
              'صوت الاستراحة',
              settings.breakSound,
              Icons.coffee,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettingsCard(BuildContext context, PomodoroSettings settings) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.restore, color: Colors.grey[600]),
              title: const Text('استعادة الإعدادات الافتراضية'),
              subtitle: const Text('إعادة تعيين جميع الإعدادات إلى القيم الافتراضية'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showResetConfirmation(context),
            ),
            
            const Divider(),
            
            ListTile(
              leading: Icon(Icons.file_download, color: Colors.grey[600]),
              title: const Text('تصدير الإعدادات'),
              subtitle: const Text('حفظ الإعدادات في ملف'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _exportSettings(),
            ),
            
            const Divider(),
            
            ListTile(
              leading: Icon(Icons.file_upload, color: Colors.grey[600]),
              title: const Text('استيراد الإعدادات'),
              subtitle: const Text('تحميل الإعدادات من ملف'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _importSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSetting(
    String title,
    Duration duration,
    IconData icon,
    Color color,
    Function(Duration) onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${duration.inMinutes} دقيقة',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: duration.inMinutes > 1
                  ? () => onChanged(Duration(minutes: duration.inMinutes - 1))
                  : null,
              icon: const Icon(Icons.remove),
              color: color,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${duration.inMinutes}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: duration.inMinutes < 120
                  ? () => onChanged(Duration(minutes: duration.inMinutes + 1))
                  : null,
              icon: const Icon(Icons.add),
              color: color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntervalSetting(
    String title,
    String subtitle,
    int value,
    IconData icon,
    Color color,
    Function(int) onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 2
                  ? () => onChanged(value - 1)
                  : null,
              icon: const Icon(Icons.remove),
              color: color,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: value < 10
                  ? () => onChanged(value + 1)
                  : null,
              icon: const Icon(Icons.add),
              color: color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Color color,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    IconData icon,
    Color color,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 10,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSoundSelection(
    String title,
    String currentSound,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getSoundDisplayName(currentSound),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _showSoundSelection(title, currentSound, color),
          icon: const Icon(Icons.music_note),
          color: color,
        ),
      ],
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة الإعدادات الافتراضية'),
        content: const Text(
          'هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟\n'
          'سيتم فقدان جميع الإعدادات المخصصة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetToDefaults();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    ref.read(pomodoroSettingsProvider.notifier)
        .updateSettings(const PomodoroSettings());
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إعادة تعيين الإعدادات إلى القيم الافتراضية'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم تنفيذ تصدير الإعدادات قريباً'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _importSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم تنفيذ استيراد الإعدادات قريباً'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showSoundSelection(String title, String currentSound, Color color) {
    final sounds = [
      'default_focus.mp3',
      'bell.mp3',
      'chime.mp3',
      'notification.mp3',
      'soft_bell.mp3',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر صوت $title',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            ...sounds.map((sound) => ListTile(
              title: Text(_getSoundDisplayName(sound)),
              leading: Icon(
                currentSound == sound ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: color,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _playSound(sound),
                color: color,
              ),
              onTap: () {
                Navigator.pop(context);
                // Update sound setting here
              },
            )),
          ],
        ),
      ),
    );
  }

  String _getSoundDisplayName(String soundFile) {
    switch (soundFile) {
      case 'default_focus.mp3':
        return 'الصوت الافتراضي';
      case 'bell.mp3':
        return 'جرس';
      case 'chime.mp3':
        return 'رنين';
      case 'notification.mp3':
        return 'إشعار';
      case 'soft_bell.mp3':
        return 'جرس ناعم';
      default:
        return soundFile;
    }
  }

  void _playSound(String soundFile) {
    // Play sound preview
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تشغيل ${_getSoundDisplayName(soundFile)}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}