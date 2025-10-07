import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../providers/social_providers.dart';
import '../widgets/post_card.dart';
import '../screens/profile_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchingUsers = true; // true for users, false for posts

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search users and posts...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() => _searchQuery = value);
            if (_isSearchingUsers) {
              ref.read(usersProvider.notifier).searchUsers(value);
            }
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearchingUsers ? Icons.article : Icons.people),
            onPressed: () {
              setState(() => _isSearchingUsers = !_isSearchingUsers);
              if (_searchQuery.isNotEmpty) {
                if (_isSearchingUsers) {
                  ref.read(usersProvider.notifier).searchUsers(_searchQuery);
                } else {
                  // For posts, we'll filter locally since we don't have a search provider
                  // In a real app, you'd want a search provider for posts too
                }
              }
            },
            tooltip: _isSearchingUsers ? 'Search posts' : 'Search users',
          ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? const _SearchPromptWidget()
          : _isSearchingUsers
          ? _buildUsersSearch(usersAsync)
          : _buildPostsSearch(postsAsync),
    );
  }

  Widget _buildUsersSearch(List<SocialUser> users) {
    final filteredUsers = users.where((user) {
      final query = _searchQuery.toLowerCase();
      return user.username.toLowerCase().contains(query) ||
          user.displayName.toLowerCase().contains(query) ||
          user.bio.toLowerCase().contains(query);
    }).toList();

    if (filteredUsers.isEmpty) {
      return const _NoResultsWidget(type: 'users');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _UserSearchCard(user: user);
      },
    );
  }

  Widget _buildPostsSearch(List<SocialPost> posts) {
    final filteredPosts = posts.where((post) {
      final query = _searchQuery.toLowerCase();
      return post.content.toLowerCase().contains(query) ||
          post.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    if (filteredPosts.isEmpty) {
      return const _NoResultsWidget(type: 'posts');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return PostCard(post: post);
      },
    );
  }
}

class _UserSearchCard extends ConsumerWidget {

  const _UserSearchCard({required this.user});
  final SocialUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isFollowing = currentUser?.following.contains(user.id) ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen(userId: user.id)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.displayName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (user.bio.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.bio,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatChip(
                          label: '${user.followers.length} followers',
                          icon: Icons.people,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          label: 'Level ${user.level}',
                          icon: Icons.star,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Follow Button
              if (currentUser != null && currentUser.id != user.id)
                ElevatedButton(
                  onPressed: () {
                    if (isFollowing) {
                      ref
                          .read(suggestedUsersProvider.notifier)
                          .followUser(user.id);
                    } else {
                      ref
                          .read(suggestedUsersProvider.notifier)
                          .followUser(user.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: isFollowing
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(isFollowing ? 'Following' : 'Follow'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {

  const _StatChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPromptWidget extends StatelessWidget {
  const _SearchPromptWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Search for users and posts',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Find friends, discover content, and connect with the community',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResultsWidget extends StatelessWidget {

  const _NoResultsWidget({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No $type found',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
