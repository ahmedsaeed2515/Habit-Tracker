import 'package:hive_flutter/hive_flutter.dart';
import '../models/social_user.dart';

class SocialService {
  static const String _usersBoxName = 'social_users';
  static const String _postsBoxName = 'social_posts';
  static const String _commentsBoxName = 'social_comments';

  Box<SocialUser>? _usersBox;
  Box<SocialPost>? _postsBox;
  Box<SocialComment>? _commentsBox;

  // تهيئة الخدمة
  Future<void> initialize() async {
    // تسجيل المحولات
    if (!Hive.isAdapterRegistered(45)) {
      Hive.registerAdapter(SocialUserAdapter());
    }
    if (!Hive.isAdapterRegistered(46)) {
      Hive.registerAdapter(SocialPostAdapter());
    }
    if (!Hive.isAdapterRegistered(47)) {
      Hive.registerAdapter(SocialCommentAdapter());
    }
    if (!Hive.isAdapterRegistered(48)) {
      Hive.registerAdapter(PostTypeAdapter());
    }

    _usersBox = await Hive.openBox<SocialUser>(_usersBoxName);
    _postsBox = await Hive.openBox<SocialPost>(_postsBoxName);
    _commentsBox = await Hive.openBox<SocialComment>(_commentsBoxName);
  }

  // إدارة المستخدمين
  Future<void> createUser(SocialUser user) async {
    await _usersBox?.put(user.id, user);
  }

  SocialUser? getUser(String userId) {
    return _usersBox?.get(userId);
  }

  Future<void> updateUser(SocialUser user) async {
    await user.save();
  }

  List<SocialUser> getAllUsers() {
    return _usersBox?.values.toList() ?? [];
  }

  // إدارة المنشورات
  Future<void> createPost(SocialPost post) async {
    await _postsBox?.put(post.id, post);
  }

  SocialPost? getPost(String postId) {
    return _postsBox?.get(postId);
  }

  Future<void> updatePost(SocialPost post) async {
    await post.save();
  }

  Future<void> deletePost(String postId) async {
    await _postsBox?.delete(postId);
  }

  List<SocialPost> getAllPosts() {
    return _postsBox?.values.toList() ?? [];
  }

  List<SocialPost> getPostsByUser(String userId) {
    return _postsBox?.values
            .where((post) => post.authorId == userId)
            .toList() ??
        [];
  }

  List<SocialPost> getPostsByType(PostType type) {
    return _postsBox?.values.where((post) => post.type == type).toList() ?? [];
  }

  // إدارة التعليقات
  Future<void> createComment(SocialComment comment) async {
    await _commentsBox?.put(comment.id, comment);
  }

  SocialComment? getComment(String commentId) {
    return _commentsBox?.get(commentId);
  }

  Future<void> deleteComment(String commentId) async {
    await _commentsBox?.delete(commentId);
  }

  List<SocialComment> getCommentsForPost(String postId) {
    return _commentsBox?.values
            .where((comment) => comment.postId == postId)
            .toList() ??
        [];
  }

  // تفاعلات اجتماعية
  Future<void> likePost(String postId, String userId) async {
    final post = getPost(postId);
    if (post != null) {
      post.addLike(userId);
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    final post = getPost(postId);
    if (post != null) {
      post.removeLike(userId);
    }
  }

  Future<void> followUser(String followerId, String followedId) async {
    final follower = getUser(followerId);
    final followed = getUser(followedId);

    if (follower != null && followed != null) {
      follower.following.add(followedId);
      followed.followers.add(followerId);
      await follower.save();
      await followed.save();
    }
  }

  Future<void> unfollowUser(String followerId, String followedId) async {
    final follower = getUser(followerId);
    final followed = getUser(followedId);

    if (follower != null && followed != null) {
      follower.following.remove(followedId);
      followed.followers.remove(followerId);
      await follower.save();
      await followed.save();
    }
  }

  // البحث والاكتشاف
  List<SocialUser> searchUsers(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _usersBox?.values
            .where(
              (user) =>
                  user.username.toLowerCase().contains(lowercaseQuery) ||
                  user.displayName.toLowerCase().contains(lowercaseQuery) ||
                  user.bio.toLowerCase().contains(lowercaseQuery),
            )
            .toList() ??
        [];
  }

  List<SocialPost> searchPosts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _postsBox?.values
            .where(
              (post) =>
                  post.content.toLowerCase().contains(lowercaseQuery) ||
                  post.tags.any(
                    (tag) => tag.toLowerCase().contains(lowercaseQuery),
                  ),
            )
            .toList() ??
        [];
  }

  // الخلاصات والتوصيات
  List<SocialPost> getFeedForUser(String userId) {
    final user = getUser(userId);
    if (user == null) return [];

    final followingIds = user.following;
    return _postsBox?.values
            .where(
              (post) =>
                  followingIds.contains(post.authorId) ||
                  post.authorId == userId,
            )
            .toList() ??
        [];
  }

  List<SocialUser> getSuggestedUsers(String userId) {
    final user = getUser(userId);
    if (user == null) return [];

    final followingIds = user.following.toSet();
    followingIds.add(userId); // لا نقترح المستخدم نفسه

    return _usersBox?.values
            .where(
              (otherUser) =>
                  !followingIds.contains(otherUser.id) && otherUser.isPublic,
            )
            .take(10)
            .toList() ??
        [];
  }

  // الإحصائيات
  Map<String, dynamic> getUserStats(String userId) {
    final user = getUser(userId);
    if (user == null) return {};

    final userPosts = getPostsByUser(userId);
    final totalLikes = userPosts.fold<int>(
      0,
      (sum, post) => sum + post.likesCount,
    );
    final totalComments = userPosts.fold<int>(
      0,
      (sum, post) => sum + getCommentsForPost(post.id).length,
    );

    return {
      'totalPosts': userPosts.length,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'followersCount': user.followers.length,
      'followingCount': user.following.length,
    };
  }

  // تنظيف البيانات
  Future<void> clearAllData() async {
    await _usersBox?.clear();
    await _postsBox?.clear();
    await _commentsBox?.clear();
  }
}
