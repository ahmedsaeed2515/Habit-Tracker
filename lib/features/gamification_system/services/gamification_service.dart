import 'dart:async';
import 'package:hive/hive.dart';
import '../models/achievement.dart';
import '../models/badge.dart';
import '../models/points.dart';
import '../models/level.dart';
import '../models/challenge.dart';
import '../models/reward.dart';

class GamificationService {
  static const String achievementsBox = 'achievements';
  static const String badgesBox = 'badges';
  static const String pointsBox = 'points';
  static const String challengesBox = 'challenges';
  static const String rewardsBox = 'rewards';

  late Box<Achievement> _achievementsBox;
  late Box<Badge> _badgesBox;
  late Box<Points> _pointsBox;
  late Box<Challenge> _challengesBox;
  late Box<Reward> _rewardsBox;

  Future<void> init() async {
    _achievementsBox = await Hive.openBox<Achievement>(achievementsBox);
    _badgesBox = await Hive.openBox<Badge>(badgesBox);
    _pointsBox = await Hive.openBox<Points>(pointsBox);
    _challengesBox = await Hive.openBox<Challenge>(challengesBox);
    _rewardsBox = await Hive.openBox<Reward>(rewardsBox);

    await _initializeDefaultData();
  }

  Future<void> _initializeDefaultData() async {
    await _initializeAchievements();
    await _initializeBadges();
    await _initializeRewards();
    await _initializePoints();
  }

  Future<void> _initializeAchievements() async {
    if (_achievementsBox.isEmpty) {
      final defaultAchievements = _createDefaultAchievements();
      for (final achievement in defaultAchievements) {
        await _achievementsBox.put(achievement.id, achievement);
      }
    }
  }

  Future<void> _initializeBadges() async {
    if (_badgesBox.isEmpty) {
      final defaultBadges = _createDefaultBadges();
      for (final badge in defaultBadges) {
        await _badgesBox.put(badge.id, badge);
      }
    }
  }

  Future<void> _initializeRewards() async {
    if (_rewardsBox.isEmpty) {
      final defaultRewards = _createDefaultRewards();
      for (final reward in defaultRewards) {
        await _rewardsBox.put(reward.id, reward);
      }
    }
  }

  Future<void> _initializePoints() async {
    if (_pointsBox.isEmpty) {
      final points = Points(id: 'user_points');
      await _pointsBox.put(points.id, points);
    }
  }

  // Achievement Management
  Future<List<Achievement>> getAchievements() async {
    return _achievementsBox.values.toList();
  }

  Future<Achievement?> getAchievement(String id) async {
    return _achievementsBox.get(id);
  }

  Future<void> updateAchievementProgress(
    String achievementId,
    int progress,
  ) async {
    final achievement = await getAchievement(achievementId);
    if (achievement != null && !achievement.isUnlocked) {
      final updatedAchievement = achievement.copyWith(progress: progress);
      await _achievementsBox.put(achievementId, updatedAchievement);

      if (updatedAchievement.isCompleted) {
        await _unlockAchievement(achievementId);
      }
    }
  }

  Future<void> _unlockAchievement(String achievementId) async {
    final achievement = await getAchievement(achievementId);
    if (achievement != null && !achievement.isUnlocked) {
      final unlockedAchievement = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _achievementsBox.put(achievementId, unlockedAchievement);

      // Award points
      await addPoints(
        achievement.points,
        'Achievement unlocked: ${achievement.title}',
        PointsCategory.achievement,
        achievementId,
      );
    }
  }

  // Badge Management
  Future<List<Badge>> getBadges() async {
    return _badgesBox.values.toList();
  }

  Future<Badge?> getBadge(String id) async {
    return _badgesBox.get(id);
  }

  Future<void> earnBadge(String badgeId, String earnedBy) async {
    final badge = await getBadge(badgeId);
    if (badge != null && !badge.isEarned) {
      final earnedBadge = badge.copyWith(
        isEarned: true,
        earnedAt: DateTime.now(),
        earnedBy: earnedBy,
      );
      await _badgesBox.put(badgeId, earnedBadge);
    }
  }

  // Points Management
  Future<Points?> getPoints() async {
    return _pointsBox.get('user_points');
  }

  Future<void> addPoints(
    int amount,
    String description,
    PointsCategory category, [
    String? relatedId,
  ]) async {
    final points = await getPoints();
    if (points != null) {
      final transaction = PointsTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        description: description,
        category: category,
        timestamp: DateTime.now(),
        relatedId: relatedId,
      );

      final updatedTransactions = [...points.transactions, transaction];
      final newTotalPoints = points.totalPoints + amount;
      final newLevel = _calculateLevel(newTotalPoints);
      final pointsToNextLevel =
          Level.calculatePointsForLevel(newLevel + 1) - newTotalPoints;

      final updatedPoints = points.copyWith(
        totalPoints: newTotalPoints,
        currentLevel: newLevel,
        pointsToNextLevel: pointsToNextLevel,
        transactions: updatedTransactions,
      );

      await _pointsBox.put(points.id, updatedPoints);

      // Check for level up achievements
      await _checkLevelAchievements(newLevel);
    }
  }

  int _calculateLevel(int totalPoints) {
    int level = 1;
    while (Level.calculatePointsForLevel(level + 1) <= totalPoints) {
      level++;
    }
    return level;
  }

  // Challenge Management
  Future<List<Challenge>> getChallenges() async {
    return _challengesBox.values.toList();
  }

  Future<Challenge?> getChallenge(String id) async {
    return _challengesBox.get(id);
  }

  Future<void> updateChallengeProgress(String challengeId, int progress) async {
    final challenge = await getChallenge(challengeId);
    if (challenge != null && challenge.isActive) {
      final updatedChallenge = challenge.copyWith(currentProgress: progress);
      await _challengesBox.put(challengeId, updatedChallenge);

      if (updatedChallenge.isCompleted) {
        await _completeChallenge(challengeId);
      }
    }
  }

  Future<void> _completeChallenge(String challengeId) async {
    final challenge = await getChallenge(challengeId);
    if (challenge != null) {
      final completedChallenge = challenge.copyWith(
        status: ChallengeStatus.completed,
      );
      await _challengesBox.put(challengeId, completedChallenge);

      // Award points and check for badge
      await addPoints(
        challenge.rewardPoints,
        'Challenge completed: ${challenge.title}',
        PointsCategory.bonus,
        challengeId,
      );

      if (challenge.badgeId != null) {
        await earnBadge(challenge.badgeId!, challengeId);
      }
    }
  }

  // Reward Management
  Future<List<Reward>> getRewards() async {
    return _rewardsBox.values.toList();
  }

  Future<Reward?> getReward(String id) async {
    return _rewardsBox.get(id);
  }

  Future<bool> unlockReward(String rewardId) async {
    final reward = await getReward(rewardId);
    final points = await getPoints();

    if (reward != null &&
        points != null &&
        !reward.isUnlocked &&
        points.totalPoints >= reward.cost) {
      // Deduct points
      await addPoints(
        -reward.cost,
        'Reward unlocked: ${reward.name}',
        PointsCategory.bonus,
        rewardId,
      );

      final unlockedReward = reward.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _rewardsBox.put(rewardId, unlockedReward);
      return true;
    }
    return false;
  }

  // Helper methods
  Future<void> _checkLevelAchievements(int level) async {
    final achievements = await getAchievements();
    for (final achievement in achievements) {
      if (achievement.category == AchievementCategory.milestone &&
          achievement.id.contains('level') &&
          achievement.progress < level) {
        await updateAchievementProgress(achievement.id, level);
      }
    }
  }

  List<Achievement> _createDefaultAchievements() {
    return [
      Achievement(
        id: 'first_habit',
        title: 'First Steps',
        description: 'Complete your first habit',
        iconPath: 'assets/icons/achievements/first_habit.png',
        points: 10,
        category: AchievementCategory.habitCompletion,
        rarity: AchievementRarity.common,
        maxProgress: 1,
      ),
      Achievement(
        id: 'week_streak',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        iconPath: 'assets/icons/achievements/week_streak.png',
        points: 50,
        category: AchievementCategory.habitStreak,
        rarity: AchievementRarity.rare,
        maxProgress: 7,
      ),
      Achievement(
        id: 'level_5',
        title: 'Rising Star',
        description: 'Reach level 5',
        iconPath: 'assets/icons/achievements/level_5.png',
        points: 100,
        category: AchievementCategory.milestone,
        rarity: AchievementRarity.epic,
        maxProgress: 5,
      ),
    ];
  }

  List<Badge> _createDefaultBadges() {
    return [
      Badge(
        id: 'streak_master',
        name: 'Streak Master',
        description: 'Maintain a 30-day streak',
        iconPath: 'assets/icons/badges/streak_master.png',
        type: BadgeType.streak,
        rarity: BadgeRarity.gold,
      ),
      Badge(
        id: 'completion_king',
        name: 'Completion King',
        description: 'Complete 100 habits',
        iconPath: 'assets/icons/badges/completion_king.png',
        type: BadgeType.completion,
        rarity: BadgeRarity.platinum,
      ),
    ];
  }

  List<Reward> _createDefaultRewards() {
    return [
      Reward(
        id: 'dark_theme',
        name: 'Dark Theme',
        description: 'Unlock the dark theme',
        iconPath: 'assets/icons/rewards/dark_theme.png',
        type: RewardType.theme,
        cost: 200,
        rarity: RewardRarity.common,
      ),
      Reward(
        id: 'golden_avatar',
        name: 'Golden Avatar',
        description: 'Unlock the golden avatar frame',
        iconPath: 'assets/icons/rewards/golden_avatar.png',
        type: RewardType.avatar,
        cost: 500,
        rarity: RewardRarity.rare,
      ),
    ];
  }

  Future<void> dispose() async {
    await _achievementsBox.close();
    await _badgesBox.close();
    await _pointsBox.close();
    await _challengesBox.close();
    await _rewardsBox.close();
  }
}
