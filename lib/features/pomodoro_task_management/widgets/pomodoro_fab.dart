import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_models.dart';
import '../providers/pomodoro_providers.dart';

/// زر العمل العائم لنظام Pomodoro مع قائمة سريعة
class PomodoroFAB extends ConsumerWidget {
  const PomodoroFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
    
    return activeSession != null 
        ? _buildActiveSessionFAB(context, ref, activeSession)
        : _buildStartSessionFAB(context, ref);
  }

  /// زر العمل العائم عندما يكون هناك جلسة نشطة
  Widget _buildActiveSessionFAB(
    BuildContext context, 
    WidgetRef ref, 
    PomodoroSession session
  ) {
    return FloatingActionButton.extended(
      onPressed: () => _showActiveSessionActions(context, ref, session),
      backgroundColor: _getSessionColor(session.type),
      foregroundColor: Colors.white,
      icon: Icon(_getSessionIcon(session.status)),
      label: Text(
        _getSessionStatusText(session.status),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// زر العمل العائم لبدء جلسة جديدة
  Widget _buildStartSessionFAB(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showStartSessionMenu(context, ref),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.play_arrow),
      label: const Text(
        'بدء جلسة',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// عرض قائمة إجراءات الجلسة النشطة
  void _showActiveSessionActions(
    BuildContext context, 
    WidgetRef ref, 
    PomodoroSession session
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              'جلسة ${_getSessionTypeText(session.type)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getSessionColor(session.type),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (session.status == SessionStatus.active)
                  _buildActionButton(
                    context,
                    icon: Icons.pause,
                    label: 'إيقاف مؤقت',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSessionProvider.notifier).pauseSession();
                    },
                  )
                else if (session.status == SessionStatus.paused)
                  _buildActionButton(
                    context,
                    icon: Icons.play_arrow,
                    label: 'استئناف',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSessionProvider.notifier).resumeSession();
                    },
                  ),
                
                _buildActionButton(
                  context,
                  icon: Icons.stop,
                  label: 'إنهاء',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _showEndSessionConfirmation(context, ref);
                  },
                ),
                
                _buildActionButton(
                  context,
                  icon: Icons.skip_next,
                  label: 'تخطي',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(activeSessionProvider.notifier).skipSession();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// عرض قائمة بدء جلسة جديدة
  void _showStartSessionMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              'اختر نوع الجلسة',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Session Types
            _buildSessionTypeOption(
              context,
              ref,
              type: SessionType.focus,
              title: 'جلسة تركيز',
              subtitle: '25 دقيقة',
              icon: Icons.psychology,
              color: Colors.red,
            ),
            
            _buildSessionTypeOption(
              context,
              ref,
              type: SessionType.shortBreak,
              title: 'استراحة قصيرة',
              subtitle: '5 دقائق',
              icon: Icons.coffee,
              color: Colors.green,
            ),
            
            _buildSessionTypeOption(
              context,
              ref,
              type: SessionType.longBreak,
              title: 'استراحة طويلة',
              subtitle: '15 دقيقة',
              icon: Icons.self_improvement,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// بناء خيار نوع الجلسة
  Widget _buildSessionTypeOption(
    BuildContext context,
    WidgetRef ref, {
    required SessionType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            ref.read(activeSessionProvider.notifier).startSession(type: type);
            
            // إظهار رسالة تأكيد
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم بدء $title! 🍅'),
                backgroundColor: color,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء زر الإجراء
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// عرض تأكيد إنهاء الجلسة
  void _showEndSessionConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنهاء الجلسة'),
        content: const Text('هل تريد إنهاء الجلسة الحالية؟ سيتم حفظ التقدم المحرز.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeSessionProvider.notifier).completeSession();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('إنهاء'),
          ),
        ],
      ),
    );
  }

  /// الحصول على لون الجلسة
  Color _getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return Colors.red;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.blue;
      case SessionType.custom:
        return Colors.purple;
    }
  }

  /// الحصول على أيقونة حالة الجلسة
  IconData _getSessionIcon(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return Icons.timer;
      case SessionStatus.paused:
        return Icons.pause;
      case SessionStatus.waiting:
        return Icons.hourglass_empty;
      case SessionStatus.completed:
        return Icons.check;
      case SessionStatus.skipped:
        return Icons.skip_next;
      case SessionStatus.cancelled:
        return Icons.close;
    }
  }

  /// الحصول على نص حالة الجلسة
  String _getSessionStatusText(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return 'نشط';
      case SessionStatus.paused:
        return 'متوقف';
      case SessionStatus.waiting:
        return 'في الانتظار';
      case SessionStatus.completed:
        return 'مكتمل';
      case SessionStatus.skipped:
        return 'متخطى';
      case SessionStatus.cancelled:
        return 'ملغي';
    }
  }

  /// الحصول على نص نوع الجلسة
  String _getSessionTypeText(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return 'التركيز';
      case SessionType.shortBreak:
        return 'الاستراحة القصيرة';
      case SessionType.longBreak:
        return 'الاستراحة الطويلة';
      case SessionType.custom:
        return 'المخصص';
    }
  }
}