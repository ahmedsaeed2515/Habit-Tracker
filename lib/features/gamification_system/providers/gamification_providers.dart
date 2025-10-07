import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement.dart';
import '../models/badge.dart';
import '../models/points.dart';
import '../models/challenge.dart';
import '../models/reward.dart';
import '../services/gamification_service.dart';

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService();
});

final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, AsyncValue<List<Achievement>>>((
      ref,
    ) {
      final service = ref.watch(gamificationServiceProvider);
      return AchievementsNotifier(service);
    });

final badgesProvider =
    StateNotifierProvider<BadgesNotifier, AsyncValue<List<Badge>>>((ref) {
      final service = ref.watch(gamificationServiceProvider);
      return BadgesNotifier(service);
    });

final pointsProvider =
    StateNotifierProvider<PointsNotifier, AsyncValue<Points?>>((ref) {
      final service = ref.watch(gamificationServiceProvider);
      return PointsNotifier(service);
    });

final challengesProvider =
    StateNotifierProvider<ChallengesNotifier, AsyncValue<List<Challenge>>>((
      ref,
    ) {
      final service = ref.watch(gamificationServiceProvider);
      return ChallengesNotifier(service);
    });

final rewardsProvider =
    StateNotifierProvider<RewardsNotifier, AsyncValue<List<Reward>>>((ref) {
      final service = ref.watch(gamificationServiceProvider);
      return RewardsNotifier(service);
    });

class AchievementsNotifier
    extends StateNotifier<AsyncValue<List<Achievement>>> {

  AchievementsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadAchievements();
  }
  final GamificationService _service;

  Future<void> _loadAchievements() async {
    state = const AsyncValue.loading();
    try {
      final achievements = await _service.getAchievements();
      state = AsyncValue.data(achievements);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProgress(String achievementId, int progress) async {
    try {
      await _service.updateAchievementProgress(achievementId, progress);
      await _loadAchievements(); // Reload to get updated state
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadAchievements();
  }
}

class BadgesNotifier extends StateNotifier<AsyncValue<List<Badge>>> {

  BadgesNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadBadges();
  }
  final GamificationService _service;

  Future<void> _loadBadges() async {
    state = const AsyncValue.loading();
    try {
      final badges = await _service.getBadges();
      state = AsyncValue.data(badges);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> earnBadge(String badgeId, String earnedBy) async {
    try {
      await _service.earnBadge(badgeId, earnedBy);
      await _loadBadges(); // Reload to get updated state
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadBadges();
  }
}

class PointsNotifier extends StateNotifier<AsyncValue<Points?>> {

  PointsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadPoints();
  }
  final GamificationService _service;

  Future<void> _loadPoints() async {
    state = const AsyncValue.loading();
    try {
      final points = await _service.getPoints();
      state = AsyncValue.data(points);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPoints(
    int amount,
    String description,
    PointsCategory category, [
    String? relatedId,
  ]) async {
    try {
      await _service.addPoints(amount, description, category, relatedId);
      await _loadPoints(); // Reload to get updated state
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadPoints();
  }
}

class ChallengesNotifier extends StateNotifier<AsyncValue<List<Challenge>>> {

  ChallengesNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadChallenges();
  }
  final GamificationService _service;

  Future<void> _loadChallenges() async {
    state = const AsyncValue.loading();
    try {
      final challenges = await _service.getChallenges();
      state = AsyncValue.data(challenges);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProgress(String challengeId, int progress) async {
    try {
      await _service.updateChallengeProgress(challengeId, progress);
      await _loadChallenges(); // Reload to get updated state
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _loadChallenges();
  }
}

class RewardsNotifier extends StateNotifier<AsyncValue<List<Reward>>> {

  RewardsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadRewards();
  }
  final GamificationService _service;

  Future<void> _loadRewards() async {
    state = const AsyncValue.loading();
    try {
      final rewards = await _service.getRewards();
      state = AsyncValue.data(rewards);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> unlockReward(String rewardId) async {
    try {
      final success = await _service.unlockReward(rewardId);
      if (success) {
        await _loadRewards(); // Reload to get updated state
      }
      return success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> refresh() async {
    await _loadRewards();
  }
}
