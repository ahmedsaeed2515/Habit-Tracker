import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../providers/social_providers.dart';

class CommentsScreen extends ConsumerStatefulWidget {

  const CommentsScreen({super.key, required this.postId});
  final String postId;

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.postId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Comments'), elevation: 0),
      body: Column(
        children: [
          // Comments List
          Expanded(
            child: commentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (comments) => comments.isEmpty
                  ? const _EmptyCommentsWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return _CommentCard(comment: comment);
                      },
                    ),
            ),
          ),

          // Add Comment
          if (currentUser != null)
            _AddCommentWidget(
              controller: _commentController,
              onSend: _addComment,
              isLoading: _isLoading,
            ),
        ],
      ),
    );
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final comment = SocialComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.postId,
        authorId: currentUser.id,
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(socialServiceProvider).createComment(comment);

      _commentController.clear();
      ref.invalidate(commentsProvider(widget.postId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding comment: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _CommentCard extends ConsumerWidget {

  const _CommentCard({required this.comment});
  final SocialComment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final currentUser = ref.watch(currentUserProvider);
    final author = users.firstWhere(
      (user) => user.id == comment.authorId,
      orElse: () => SocialUser(
        id: comment.authorId,
        username: 'Unknown',
        displayName: 'Unknown User',
        email: '',
        joinDate: DateTime.now(),
        lastActive: DateTime.now(),
      ),
    );

    final isLiked =
        currentUser != null && comment.likes.contains(currentUser.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment Header
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: author.avatarUrl != null
                      ? NetworkImage(author.avatarUrl!)
                      : null,
                  child: author.avatarUrl == null
                      ? Text(
                          author.displayName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(comment.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const const SizedBox(height: 8),

            // Comment Content
            Text(comment.content),

            const const SizedBox(height: 8),

            // Comment Actions
            Row(
              children: [
                TextButton.icon(
                  onPressed: currentUser != null
                      ? () {
                          if (isLiked) {
                            // Unlike comment
                            comment.likes.remove(currentUser.id);
                            comment.save();
                            ref.invalidate(commentsProvider(comment.postId));
                          } else {
                            // Like comment
                            comment.likes.add(currentUser.id);
                            comment.save();
                            ref.invalidate(commentsProvider(comment.postId));
                          }
                        }
                      : null,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: isLiked ? Colors.red : null,
                  ),
                  label: Text('${comment.likes.length}'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
}

class _AddCommentWidget extends StatelessWidget {

  const _AddCommentWidget({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : onSend,
            icon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class _EmptyCommentsWidget extends StatelessWidget {
  const _EmptyCommentsWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.comment,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const const SizedBox(height: 16),
            Text(
              'No comments yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const const SizedBox(height: 8),
            Text(
              'Be the first to comment on this post!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
