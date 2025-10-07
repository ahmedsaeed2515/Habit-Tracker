import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 31)
class Challenge extends HiveObject { // Badge awarded upon completion

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.rewardPoints,
    required this.startDate,
    required this.endDate,
    this.status = ChallengeStatus.active,
    this.currentProgress = 0,
    required this.targetProgress,
    List<String>? participants,
    this.badgeId,
  }) : participants = participants ?? [];
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final ChallengeType type;

  @HiveField(4)
  final ChallengeDifficulty difficulty;

  @HiveField(5)
  final int rewardPoints;

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime endDate;

  @HiveField(8)
  final ChallengeStatus status;

  @HiveField(9)
  final int currentProgress;

  @HiveField(10)
  final int targetProgress;

  @HiveField(11)
  final List<String> participants; // User IDs

  @HiveField(12)
  final String? badgeId;

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    ChallengeDifficulty? difficulty,
    int? rewardPoints,
    DateTime? startDate,
    DateTime? endDate,
    ChallengeStatus? status,
    int? currentProgress,
    int? targetProgress,
    List<String>? participants,
    String? badgeId,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      participants: participants ?? this.participants,
      badgeId: badgeId ?? this.badgeId,
    );
  }

  double get progressPercentage =>
      targetProgress > 0 ? currentProgress / targetProgress : 0.0;

  bool get isCompleted => currentProgress >= targetProgress;

  bool get isExpired => DateTime.now().isAfter(endDate);

  Duration get timeRemaining => endDate.difference(DateTime.now());

  bool get isActive => status == ChallengeStatus.active && !isExpired;
}

@HiveType(typeId: 32)
enum ChallengeType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  seasonal,
  @HiveField(4)
  special,
}

@HiveType(typeId: 33)
enum ChallengeDifficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
  @HiveField(3)
  expert,
}

@HiveType(typeId: 34)
enum ChallengeStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  completed,
  @HiveField(2)
  failed,
  @HiveField(3)
  expired,
}
