import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../services/social_service.dart';

// مزود خدمة التواصل الاجتماعي
final socialServiceProvider = Provider<SocialService>((ref) {
  return SocialService();
});

// مزود المستخدم الحالي
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, SocialUser?>((ref) {
      return CurrentUserNotifier(ref.watch(socialServiceProvider));
    });

class CurrentUserNotifier extends StateNotifier<SocialUser?> {

  CurrentUserNotifier(this._socialService) : super(null);
  final SocialService _socialService;

  Future<void> loadUser(String userId) async {
    final user = _socialService.getUser(userId);
    state = user;
  }

  Future<void> createUser(SocialUser user) async {
    await _socialService.createUser(user);
    state = user;
  }

  Future<void> updateUser(SocialUser user) async {
    await _socialService.updateUser(user);
    state = user;
  }
}

// مزود قائمة المستخدمين
final usersProvider = StateNotifierProvider<UsersNotifier, List<SocialUser>>((
  ref,
) {
  return UsersNotifier(ref.watch(socialServiceProvider));
});

class UsersNotifier extends StateNotifier<List<SocialUser>> {

  UsersNotifier(this._socialService) : super([]) {
    _loadUsers();
  }
  final SocialService _socialService;

  Future<void> _loadUsers() async {
    final users = _socialService.getAllUsers();
    state = users;
  }

  Future<void> refreshUsers() async {
    await _loadUsers();
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      await _loadUsers();
    } else {
      final users = _socialService.searchUsers(query);
      state = users;
    }
  }
}

// مزود قائمة المنشورات
final postsProvider = StateNotifierProvider<PostsNotifier, List<SocialPost>>((
  ref,
) {
  return PostsNotifier(ref.watch(socialServiceProvider));
});

class PostsNotifier extends StateNotifier<List<SocialPost>> {

  PostsNotifier(this._socialService) : super([]) {
    _loadPosts();
  }
  final SocialService _socialService;

  Future<void> _loadPosts() async {
    final posts = _socialService.getAllPosts();
    state = posts;
  }

  Future<void> refreshPosts() async {
    await _loadPosts();
  }

  Future<void> createPost(SocialPost post) async {
    await _socialService.createPost(post);
    await _loadPosts();
  }

  Future<void> likePost(String postId, String userId) async {
    await _socialService.likePost(postId, userId);
    await _loadPosts();
  }

  Future<void> unlikePost(String postId, String userId) async {
    await _socialService.unlikePost(postId, userId);
    await _loadPosts();
  }
}

// مزود الخلاصة الاجتماعية
final feedProvider = StateNotifierProvider<FeedNotifier, List<SocialPost>>((
  ref,
) {
  return FeedNotifier(
    ref.watch(socialServiceProvider),
    ref.watch(currentUserProvider),
  );
});

class FeedNotifier extends StateNotifier<List<SocialPost>> {

  FeedNotifier(this._socialService, this._currentUser) : super([]) {
    _loadFeed();
  }
  final SocialService _socialService;
  final SocialUser? _currentUser;

  Future<void> _loadFeed() async {
    if (_currentUser != null) {
      final feed = _socialService.getFeedForUser(_currentUser.id);
      state = feed;
    }
  }

  Future<void> refreshFeed() async {
    await _loadFeed();
  }
}

// مزود المستخدمين المقترحين
final suggestedUsersProvider =
    StateNotifierProvider<SuggestedUsersNotifier, List<SocialUser>>((ref) {
      return SuggestedUsersNotifier(
        ref.watch(socialServiceProvider),
        ref.watch(currentUserProvider),
      );
    });

class SuggestedUsersNotifier extends StateNotifier<List<SocialUser>> {

  SuggestedUsersNotifier(this._socialService, this._currentUser) : super([]) {
    _loadSuggestions();
  }
  final SocialService _socialService;
  final SocialUser? _currentUser;

  Future<void> _loadSuggestions() async {
    if (_currentUser != null) {
      final suggestions = _socialService.getSuggestedUsers(_currentUser.id);
      state = suggestions;
    }
  }

  Future<void> refreshSuggestions() async {
    await _loadSuggestions();
  }

  Future<void> followUser(String userId) async {
    if (_currentUser != null) {
      await _socialService.followUser(_currentUser.id, userId);
      await _loadSuggestions();
    }
  }
}

// مزود التعليقات لمنشور معين
final commentsProvider = FutureProvider.family<List<SocialComment>, String>((
  ref,
  postId,
) async {
  final socialService = ref.watch(socialServiceProvider);
  return socialService.getCommentsForPost(postId);
});

// مزود إحصائيات المستخدم
final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  userId,
) async {
  final socialService = ref.watch(socialServiceProvider);
  return socialService.getUserStats(userId);
});
