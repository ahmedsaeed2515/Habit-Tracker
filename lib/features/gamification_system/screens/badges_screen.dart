import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/badge.dart'
    as game_badge;
import '../providers/gamification_providers.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Badges'), elevation: 0),
      body: badgesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading badges: $error')),
        data: (badges) => _BadgesGrid(badges: badges),
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {

  const _BadgesGrid({required this.badges});
  final List<game_badge.Badge> badges;

  @override
  Widget build(BuildContext context) {
    final earnedBadges = badges.where((b) => b.isEarned).toList();
    final unearnedBadges = badges.where((b) => !b.isEarned).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earned (${earnedBadges.length})',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (earnedBadges.isNotEmpty)
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  BadgeCard(badge: earnedBadges[index], isEarned: true),
              childCount: earnedBadges.length,
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const const SizedBox(height: 32),
                Text(
                  'Not Earned (${unearnedBadges.length})',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (unearnedBadges.isNotEmpty)
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  BadgeCard(badge: unearnedBadges[index], isEarned: false),
              childCount: unearnedBadges.length,
            ),
          ),
      ],
    );
  }
}

class BadgeCard extends StatelessWidget {

  const BadgeCard({super.key, required this.badge, required this.isEarned});
  final game_badge.Badge badge;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isEarned ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isEarned
              ? LinearGradient(
                  colors: [
                    _getRarityColor(badge.rarity).withValues(alpha: 0.2),
                    _getRarityColor(badge.rarity).withValues(alpha: 0.1),
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
                color: isEarned
                    ? _getRarityColor(badge.rarity)
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isEarned
                      ? _getRarityColor(badge.rarity).withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _getBadgeIcon(badge.type),
                color: isEarned
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 30,
              ),
            ),
            const const SizedBox(height: 12),
            Text(
              badge.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isEarned
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const const SizedBox(height: 8),
            Text(
              badge.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isEarned
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRarityColor(
                  badge.rarity,
                ).withValues(alpha: isEarned ? 1.0 : 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.rarity.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isEarned
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(game_badge.BadgeRarity rarity) {
    switch (rarity) {
      case game_badge.BadgeRarity.bronze:
        return const Color(0xFFCD7F32);
      case game_badge.BadgeRarity.silver:
        return const Color(0xFFC0C0C0);
      case game_badge.BadgeRarity.gold:
        return const Color(0xFFFFD700);
      case game_badge.BadgeRarity.platinum:
        return const Color(0xFFE5E4E2);
    }
  }

  IconData _getBadgeIcon(game_badge.BadgeType type) {
    switch (type) {
      case game_badge.BadgeType.streak:
        return Icons.local_fire_department;
      case game_badge.BadgeType.completion:
        return Icons.check_circle;
      case game_badge.BadgeType.milestone:
        return Icons.emoji_events;
      case game_badge.BadgeType.social:
        return Icons.people;
      case game_badge.BadgeType.special:
        return Icons.star;
    }
  }
}
