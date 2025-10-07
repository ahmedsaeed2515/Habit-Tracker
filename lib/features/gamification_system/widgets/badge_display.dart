import 'package:flutter/material.dart';
import '../models/badge.dart'
    as game_badge;

class BadgeDisplay extends StatelessWidget {

  const BadgeDisplay({
    super.key,
    required this.badge,
    this.size = 40,
    this.showLabel = false,
    this.onTap,
  });
  final game_badge.Badge badge;
  final double size;
  final bool showLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isEarned
                  ? _getRarityColor(badge.rarity)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: badge.isEarned
                    ? _getRarityColor(badge.rarity).withOpacity(0.5)
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: badge.isEarned
                  ? [
                      BoxShadow(
                        color: _getRarityColor(badge.rarity).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getBadgeIcon(badge.type),
              color: badge.isEarned
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: size * 0.5,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              badge.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: badge.isEarned
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
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
