import 'package:hive/hive.dart';

part 'social_user.g.dart';

@HiveType(typeId: 45)
class SocialUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String displayName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String? avatarUrl;

  @HiveField(5)
  String bio;

  @HiveField(6)
  int totalPoints;

  @HiveField(7)
  int level;

  @HiveField(8)
  List<String> achievements;

  @HiveField(9)
  DateTime joinDate;

  @HiveField(10)
  DateTime lastActive;

  @HiveField(11)
  bool isPublic;

  @HiveField(12)
  List<String> friends;

  @HiveField(13)
  List<String> followers;

  @HiveField(14)
  List<String> following;

  @HiveField(15)
  Map<String, dynamic> stats;

  @HiveField(16)
  String country;

  @HiveField(17)
  String? city;

  SocialUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.bio = '',
    this.totalPoints = 0,
    this.level = 1,
    this.achievements = const [],
    required this.joinDate,
    required this.lastActive,
    this.isPublic = true,
    this.friends = const [],
    this.followers = const [],
    this.following = const [],
    this.stats = const {},
    this.country = '',
    this.city,
  });

  // الحصول على إحصائيات المستخدم
  int get totalHabits => stats['totalHabits'] ?? 0;
  int get completedHabits => stats['completedHabits'] ?? 0;
  int get currentStreak => stats['currentStreak'] ?? 0;
  int get bestStreak => stats['bestStreak'] ?? 0;
  double get successRate => totalHabits > 0 ? (completedHabits / totalHabits) : 0.0;

  // تحديث الإحصائيات
  void updateStats(Map<String, dynamic> newStats) {
    final updatedStats = Map<String, dynamic>.from(stats);
    updatedStats.addAll(newStats);
    stats = updatedStats;
    lastActive = DateTime.now();
    save();
  }

  // إضافة صديق
  void addFriend(String friendId) {
    if (!friends.contains(friendId)) {
      final newFriends = List<String>.from(friends);
      newFriends.add(friendId);
      friends = newFriends;
      save();
    }
  }

  // إزالة صديق
  void removeFriend(String friendId) {
    final newFriends = List<String>.from(friends);
    newFriends.remove(friendId);
    friends = newFriends;
    save();
  }

  // متابعة مستخدم
  void followUser(String userId) {
    if (!following.contains(userId)) {
      final newFollowing = List<String>.from(following);
      newFollowing.add(userId);
      following = newFollowing;
      save();
    }
  }

  // إلغاء متابعة مستخدم
  void unfollowUser(String userId) {
    final newFollowing = List<String>.from(following);
    newFollowing.remove(userId);
    following = newFollowing;
    save();
  }

  // إضافة متابع
  void addFollower(String userId) {
    if (!followers.contains(userId)) {
      final newFollowers = List<String>.from(followers);
      newFollowers.add(userId);
      followers = newFollowers;
      save();
    }
  }

  // إزالة متابع
  void removeFollower(String userId) {
    final newFollowers = List<String>.from(followers);
    newFollowers.remove(userId);
    followers = newFollowers;
    save();
  }

  // إضافة إنجاز
  void addAchievement(String achievementId) {
    if (!achievements.contains(achievementId)) {
      final newAchievements = List<String>.from(achievements);
      newAchievements.add(achievementId);
      achievements = newAchievements;
      save();
    }
  }

  // الحصول على الرتبة
  String get rank {
    if (level >= 50) return 'Master';
    if (level >= 30) return 'Expert';
    if (level >= 20) return 'Advanced';
    if (level >= 10) return 'Intermediate';
    return 'Beginner';
  }

  // تحديث المستوى بناءً على النقاط
  void updateLevel() {
    final newLevel = (totalPoints / 1000).floor() + 1;
    if (newLevel != level) {
      level = newLevel;
      save();
    }
  }

  // تحويل إلى خريطة
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'totalPoints': totalPoints,
      'level': level,
      'achievements': achievements,
      'joinDate': joinDate.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'isPublic': isPublic,
      'friends': friends,
      'followers': followers,
      'following': following,
      'stats': stats,
      'country': country,
      'city': city,
    };
  }

  // إنشاء من خريطة
  factory SocialUser.fromMap(Map<String, dynamic> map) {
    return SocialUser(
      id: map['id'],
      username: map['username'],
      displayName: map['displayName'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      bio: map['bio'] ?? '',
      totalPoints: map['totalPoints'] ?? 0,
      level: map['level'] ?? 1,
      achievements: List<String>.from(map['achievements'] ?? []),
      joinDate: DateTime.parse(map['joinDate']),
      lastActive: DateTime.parse(map['lastActive']),
      isPublic: map['isPublic'] ?? true,
      friends: List<String>.from(map['friends'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      stats: Map<String, dynamic>.from(map['stats'] ?? {}),
      country: map['country'] ?? '',
      city: map['city'],
    );
  }
}

@HiveType(typeId: 46)
class SocialPost extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String authorId;

  @HiveField(2)
  String content;

  @HiveField(3)
  PostType type;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  List<String> likes;

  @HiveField(6)
  List<String> comments;

  @HiveField(7)
  Map<String, dynamic> metadata;

  @HiveField(8)
  bool isPublic;

  @HiveField(9)
  List<String> tags;

  @HiveField(10)
  String? imageUrl;

  SocialPost({
    required this.id,
    required this.authorId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
    this.metadata = const {},
    this.isPublic = true,
    this.tags = const [],
    this.imageUrl,
  });

  // إضافة إعجاب
  void addLike(String userId) {
    if (!likes.contains(userId)) {
      final newLikes = List<String>.from(likes);
      newLikes.add(userId);
      likes = newLikes;
      save();
    }
  }

  // إزالة إعجاب
  void removeLike(String userId) {
    final newLikes = List<String>.from(likes);
    newLikes.remove(userId);
    likes = newLikes;
    save();
  }

  // إضافة تعليق
  void addComment(String commentId) {
    final newComments = List<String>.from(comments);
    newComments.add(commentId);
    comments = newComments;
    save();
  }

  // الحصول على عدد الإعجابات
  int get likesCount => likes.length;

  // الحصول على عدد التعليقات
  int get commentsCount => comments.length;

  // فحص ما إذا كان المستخدم أعجب بالمنشور
  bool isLikedBy(String userId) => likes.contains(userId);
}

@HiveType(typeId: 47)
enum PostType {
  @HiveField(0)
  achievement,    // إنجاز

  @HiveField(1)
  habitComplete,  // إكمال عادة

  @HiveField(2)
  milestone,      // معلم مهم

  @HiveField(3)
  motivation,     // تحفيز

  @HiveField(4)
  challenge,      // تحدي

  @HiveField(5)
  general,        // عام
}

@HiveType(typeId: 48)
class SocialComment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String postId;

  @HiveField(2)
  String authorId;

  @HiveField(3)
  String content;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  List<String> likes;

  @HiveField(6)
  String? replyToId;

  SocialComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.likes = const [],
    this.replyToId,
  });

  // إضافة إعجاب
  void addLike(String userId) {
    if (!likes.contains(userId)) {
      final newLikes = List<String>.from(likes);
      newLikes.add(userId);
      likes = newLikes;
      save();
    }
  }

  // إزالة إعجاب
  void removeLike(String userId) {
    final newLikes = List<String>.from(likes);
    newLikes.remove(userId);
    likes = newLikes;
    save();
  }

  // الحصول على عدد الإعجابات
  int get likesCount => likes.length;

  // فحص ما إذا كان المستخدم أعجب بالتعليق
  bool isLikedBy(String userId) => likes.contains(userId);
}