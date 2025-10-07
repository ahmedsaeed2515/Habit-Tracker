import 'package:flutter/material.dart';
import '../../../shared/themes/app_theme.dart';
import '../../../shared/localization/app_localizations.dart';
import '../../gym_tracker/screens/gym_tracker_screen.dart';
import '../../daily_habits/screens/daily_habits_screen.dart';
import '../../smart_todo/screens/smart_todo_screen.dart';
import '../../morning_exercises/screens/morning_exercises_screen.dart';

/// ويدجت الإجراءات السريعة في لوحة التحكم
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.quickActions,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                title: 'إضافة تمرين',
                icon: Icons.add_circle,
                color: AppTheme.featureColors['gym']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GymTrackerScreen()),
                  );
                },
                semanticLabel: 'Add gym exercise',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                title: 'إضافة عادة',
                icon: Icons.add_task,
                color: AppTheme.featureColors['habits']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DailyHabitsScreen(),
                    ),
                  );
                },
                semanticLabel: 'Add daily habit',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                title: 'إضافة مهمة',
                icon: Icons.post_add,
                color: AppTheme.featureColors['todo']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SmartTodoScreen()),
                  );
                },
                semanticLabel: 'Add task',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                title: 'تمارين الصباح',
                icon: Icons.wb_sunny,
                color: AppTheme.featureColors['morning']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MorningExercisesScreen(),
                    ),
                  );
                },
                semanticLabel: 'Morning exercises',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// زر إجراء سريع
class ActionButton extends StatelessWidget {

  const ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.semanticLabel,
  });
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Semantics(
                  label: semanticLabel ?? title,
                  child: Icon(icon, color: color, size: 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
