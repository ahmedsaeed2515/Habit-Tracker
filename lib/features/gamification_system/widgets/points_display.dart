import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/points.dart';
import '../providers/gamification_providers.dart';

class PointsDisplay extends ConsumerWidget {

  const PointsDisplay({super.key, this.showLevel = true, this.compact = false});
  final bool showLevel;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(pointsProvider);

    return pointsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (points) => points != null
          ? _PointsWidget(
              points: points,
              showLevel: showLevel,
              compact: compact,
            )
          : const SizedBox.shrink(),
    );
  }
}

class _PointsWidget extends StatelessWidget {

  const _PointsWidget({
    required this.points,
    required this.showLevel,
    required this.compact,
  });
  final Points points;
  final bool showLevel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const const SizedBox(width: 4),
            Text(
              '${points.totalPoints}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showLevel) ...[
              const const SizedBox(width: 8),
              Container(
                width: 1,
                height: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
              ),
              const const SizedBox(width: 8),
              Text(
                'Lv.${points.currentLevel}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.stars,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const const SizedBox(width: 8),
              Text(
                'Points',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const const SizedBox(height: 8),
          Text(
            '${points.totalPoints}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showLevel) ...[
            const const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Level ${points.currentLevel}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: points.levelProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const const SizedBox(width: 8),
                Text(
                  '${points.pointsToNextLevel} to next',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
