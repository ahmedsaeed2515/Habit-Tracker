import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reward.dart';
import '../providers/gamification_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsAsync = ref.watch(rewardsProvider);
    final pointsAsync = ref.watch(pointsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards Store'), elevation: 0),
      body: rewardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading rewards: $error')),
        data: (rewards) => pointsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error loading points: $error')),
          data: (points) => _RewardsGrid(
            rewards: rewards,
            userPoints: points?.totalPoints ?? 0,
            onUnlockReward: (rewardId) async {
              final success = await ref
                  .read(rewardsProvider.notifier)
                  .unlockReward(rewardId);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reward unlocked successfully!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not enough points to unlock this reward'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _RewardsGrid extends StatelessWidget {

  const _RewardsGrid({
    required this.rewards,
    required this.userPoints,
    required this.onUnlockReward,
  });
  final List<Reward> rewards;
  final int userPoints;
  final Function(String) onUnlockReward;

  @override
  Widget build(BuildContext context) {
    final unlockedRewards = rewards.where((r) => r.isUnlocked).toList();
    final lockedRewards = rewards.where((r) => !r.isUnlocked).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Points: $userPoints',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (unlockedRewards.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unlocked (${unlockedRewards.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => RewardCard(
                  reward: unlockedRewards[index],
                  userPoints: userPoints,
                  onUnlock: onUnlockReward,
                  isUnlocked: true,
                ),
                childCount: unlockedRewards.length,
              ),
            ),
          ),
        ],
        if (lockedRewards.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Available (${lockedRewards.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => RewardCard(
                  reward: lockedRewards[index],
                  userPoints: userPoints,
                  onUnlock: onUnlockReward,
                  isUnlocked: false,
                ),
                childCount: lockedRewards.length,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class RewardCard extends StatelessWidget {

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onUnlock,
    required this.isUnlocked,
  });
  final Reward reward;
  final int userPoints;
  final Function(String) onUnlock;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final canAfford = userPoints >= reward.cost;

    return Card(
      elevation: isUnlocked ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [
                    _getRarityColor(reward.rarity).withOpacity(0.2),
                    _getRarityColor(reward.rarity).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? _getRarityColor(reward.rarity)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isUnlocked
                      ? _getRarityColor(reward.rarity).withOpacity(0.5)
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _getRewardIcon(reward.type),
                color: isUnlocked
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              reward.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              reward.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUnlocked
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            if (!isUnlocked) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stars,
                    size: 16,
                    color: canAfford
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${reward.cost}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: canAfford
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canAfford ? () => onUnlock(reward.id) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    foregroundColor: canAfford
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(canAfford ? 'Unlock' : 'Not enough points'),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRarityColor(reward.rarity).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'UNLOCKED',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getRarityColor(reward.rarity),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(RewardRarity rarity) {
    switch (rarity) {
      case RewardRarity.common:
        return Colors.grey;
      case RewardRarity.rare:
        return Colors.blue;
      case RewardRarity.epic:
        return Colors.purple;
      case RewardRarity.legendary:
        return Colors.orange;
    }
  }

  IconData _getRewardIcon(RewardType type) {
    switch (type) {
      case RewardType.theme:
        return Icons.palette;
      case RewardType.avatar:
        return Icons.account_circle;
      case RewardType.sound:
        return Icons.volume_up;
      case RewardType.animation:
        return Icons.animation;
      case RewardType.feature:
        return Icons.star;
      case RewardType.badge:
        return Icons.military_tech;
      case RewardType.title:
        return Icons.title;
    }
  }
}
