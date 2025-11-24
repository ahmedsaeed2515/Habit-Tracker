import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../providers/social_providers.dart';
import '../screens/comments_screen.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});
  final SocialPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final commentsAsync = ref.watch(commentsProvider(post.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            _PostHeader(post: post),

            const SizedBox(height: 12),

            // Post Content
            _PostContent(post: post),

            const SizedBox(height: 12),

            // Post Actions
            _PostActions(
              post: post,
              currentUserId: currentUser?.id,
              commentsCount: commentsAsync.value?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends ConsumerWidget {
  const _PostHeader({required this.post});
  final SocialPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final author = users.firstWhere(
      (user) => user.id == post.authorId,
      orElse: () => SocialUser(
        id: post.authorId,
        username: 'Unknown',
        displayName: 'Unknown User',
        email: '',
        joinDate: DateTime.now(),
        lastActive: DateTime.now(),
      ),
    );

    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20,
          backgroundImage: author.avatarUrl != null
              ? NetworkImage(author.avatarUrl!)
              : null,
          child: author.avatarUrl == null
              ? Text(
                  author.displayName[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: 12),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _formatTimeAgo(post.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Post Type Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getPostTypeColor(post.type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getPostTypeIcon(post.type),
                size: 14,
                color: _getPostTypeColor(post.type),
              ),
              const SizedBox(width: 4),
              Text(
                _getPostTypeLabel(post.type),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getPostTypeColor(post.type),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Color _getPostTypeColor(PostType type) {
    switch (type) {
      case PostType.achievement:
        return Colors.orange;
      case PostType.habitComplete:
        return Colors.blue;
      case PostType.milestone:
        return Colors.green;
      case PostType.motivation:
        return Colors.purple;
      case PostType.challenge:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getPostTypeIcon(PostType type) {
    switch (type) {
      case PostType.achievement:
        return Icons.emoji_events;
      case PostType.habitComplete:
        return Icons.check_circle;
      case PostType.milestone:
        return Icons.flag;
      case PostType.motivation:
        return Icons.local_fire_department;
      case PostType.challenge:
        return Icons.sports_score;
      default:
        return Icons.post_add;
    }
  }

  String _getPostTypeLabel(PostType type) {
    switch (type) {
      case PostType.achievement:
        return 'Achievement';
      case PostType.habitComplete:
        return 'Habit Complete';
      case PostType.milestone:
        return 'Milestone';
      case PostType.motivation:
        return 'Motivation';
      case PostType.challenge:
        return 'Challenge';
      default:
        return 'Post';
    }
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({required this.post});
  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content
        Text(post.content, style: Theme.of(context).textTheme.bodyMedium),

        // Content
        Text(post.content, style: Theme.of(context).textTheme.bodyMedium),

        // Tags (if any)
        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: post.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _PostActions extends ConsumerWidget {
  const _PostActions({
    required this.post,
    required this.currentUserId,
    required this.commentsCount,
  });
  final SocialPost post;
  final String? currentUserId;
  final int commentsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = currentUserId != null && post.likes.contains(currentUserId);

    return Row(
      children: [
        // Like Button
        TextButton.icon(
          onPressed: currentUserId != null
              ? () {
                  if (isLiked) {
                    ref
                        .read(postsProvider.notifier)
                        .unlikePost(post.id, currentUserId!);
                  } else {
                    ref
                        .read(postsProvider.notifier)
                        .likePost(post.id, currentUserId!);
                  }
                }
              : null,
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
          label: Text('${post.likes.length}'),
        ),

        // Comment Button
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommentsScreen(postId: post.id),
              ),
            );
          },
          icon: const Icon(Icons.comment),
          label: Text('$commentsCount'),
        ),

        // Share Button
        TextButton.icon(
          onPressed: () {
            // Show share options
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: const Text('Copy link'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share via...'),
                      onTap: () {
                        Navigator.pop(context);
                        // Platform share functionality would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share functionality coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.share),
          label: const Text('Share'),
        ),

        const Spacer(),

        // More Options
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bookmark_border),
                      title: const Text('Save post'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post saved')),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.report_outlined),
                      title: const Text('Report post'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Report submitted')),
                        );
                      },
                    ),
                    if (post.authorId == 'current_user_id') ...[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit post'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit functionality coming soon'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text(
                          'Delete post',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete post?'),
                              content: const Text(
                                'This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post deleted'),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}
