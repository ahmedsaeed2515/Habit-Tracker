// lib/features/voice_commands/screens/voice_commands_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_commands_provider.dart';
import '../widgets/voice_command_button.dart';
import '../widgets/voice_commands_history.dart';

/// شاشة الأوامر الصوتية
class VoiceCommandsScreen extends ConsumerStatefulWidget {
  const VoiceCommandsScreen({super.key});

  @override
  ConsumerState<VoiceCommandsScreen> createState() =>
      _VoiceCommandsScreenState();
}

class _VoiceCommandsScreenState extends ConsumerState<VoiceCommandsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize voice commands service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceCommandsProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceCommandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأوامر الصوتية'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.mic), text: 'الأوامر'),
            Tab(icon: Icon(Icons.history), text: 'السجل'),
          ],
        ),
        actions: [
          // زر مسح السجل
          IconButton(
            onPressed: voiceState.recentCommands.isNotEmpty
                ? _showClearHistoryDialog
                : null,
            icon: const Icon(Icons.clear_all),
            tooltip: 'مسح السجل',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الحالة والأخطاء
          if (voiceState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      voiceState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(voiceCommandsProvider.notifier).clearError();
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                    iconSize: 20,
                  ),
                ],
              ),
            ),

          // المحتوى الرئيسي
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // تبويب الأوامر
                _buildCommandsTab(),
                // تبويب السجل
                const VoiceCommandsHistory(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const VoiceCommandButton(),
      bottomSheet:
          voiceState.isListening ||
              voiceState.isProcessing ||
              voiceState.lastRecognizedText != null
          ? const VoiceCommandBottomBar()
          : null,
    );
  }

  /// تبويب الأوامر الرئيسي
  Widget _buildCommandsTab() {
    final voiceState = ref.watch(voiceCommandsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // كارد الحالة
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        voiceState.isInitialized
                            ? Icons.check_circle
                            : Icons.error,
                        color: voiceState.isInitialized
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        voiceState.isInitialized
                            ? 'جاهز للاستخدام'
                            : 'غير مهيأ',
                        style: TextStyle(
                          color: voiceState.isInitialized
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (!voiceState.isInitialized)
                    ElevatedButton(
                      onPressed: () {
                        ref.read(voiceCommandsProvider.notifier).initialize();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // الأوامر المتاحة
          Text(
            'الأوامر المتاحة',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // قائمة الأوامر المتاحة
          ..._buildAvailableCommands(context),
        ],
      ),
    );
  }

  /// بناء قائمة الأوامر المتاحة
  List<Widget> _buildAvailableCommands(BuildContext context) {
    final commands = [
      {
        'category': 'العادات',
        'icon': Icons.task_alt,
        'color': Colors.green,
        'commands': [
          'أكمل عادة القراءة',
          'ابدأ عادة التمرين',
          'عرض عاداتي',
          'أضف عادة جديدة',
        ],
      },
      {
        'category': 'المهام',
        'icon': Icons.checklist,
        'color': Colors.blue,
        'commands': [
          'أضف مهمة جديدة',
          'أكمل المهمة',
          'عرض مهامي',
          'احذف المهمة',
        ],
      },
      {
        'category': 'التمارين',
        'icon': Icons.fitness_center,
        'color': Colors.orange,
        'commands': [
          'ابدأ تمرين الجري',
          'أكمل التمرين',
          'عرض تماريني',
          'أضف تمرين يوغا',
        ],
      },
      {
        'category': 'التنقل',
        'icon': Icons.navigation,
        'color': Colors.purple,
        'commands': [
          'اذهب إلى العادات',
          'افتح الإعدادات',
          'عرض التحليلات',
          'ارجع إلى الرئيسية',
        ],
      },
    ];

    return commands.map((category) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          leading: Icon(
            category['icon']! as IconData,
            color: category['color']! as Color,
          ),
          title: Text(
            category['category']! as String,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: category['color']! as Color,
            ),
          ),
          children: (category['commands']! as List<String>)
              .map(
                (command) => ListTile(
                  leading: const Icon(Icons.mic, size: 20),
                  title: Text(command),
                  trailing: IconButton(
                    onPressed: () => _testCommand(command),
                    icon: const Icon(Icons.play_arrow),
                    tooltip: 'تجربة الأمر',
                  ),
                ),
              )
              .toList(),
        ),
      );
    }).toList();
  }

  /// تجربة أمر صوتي
  void _testCommand(String command) {
    ref.read(voiceCommandsProvider.notifier).stopListening();
    // Simulate voice input
    // This would normally come from the speech recognition
    // ref.read(voiceCommandsProvider.notifier)._processVoiceInput(command);
  }

  /// حوار مسح السجل
  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح السجل'),
        content: const Text('هل تريد مسح جميع الأوامر الصوتية السابقة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(voiceCommandsProvider.notifier).clearRecentCommands();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }
}
