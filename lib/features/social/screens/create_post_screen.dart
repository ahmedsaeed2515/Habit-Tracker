import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../providers/social_providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  PostType _selectedType = PostType.achievement;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Type Selector
            Text(
              'Post Type',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PostType.values.map((type) {
                return ChoiceChip(
                  label: Text(_getPostTypeLabel(type)),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedType = type);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Title Field (for achievement and milestone posts)
            if (_selectedType == PostType.achievement ||
                _selectedType == PostType.milestone) ...[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'What did you achieve?',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
            ],

            // Content Field
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Share your thoughts',
                hintText: _getContentHint(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              maxLength: 1000,
            ),

            const SizedBox(height: 24),

            // Preview
            if (_contentController.text.isNotEmpty) ...[
              Text(
                'Preview',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_titleController.text.isNotEmpty) ...[
                      Text(
                        _titleController.text,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(_contentController.text),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getPostTypeIcon(_selectedType),
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getPostTypeLabel(_selectedType),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
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

  String _getContentHint() {
    switch (_selectedType) {
      case PostType.achievement:
        return 'Tell us about your achievement and how you feel...';
      case PostType.habitComplete:
        return 'Share your habit completion experience...';
      case PostType.milestone:
        return 'Describe this milestone and what it means to you...';
      case PostType.motivation:
        return 'Share your motivational thoughts...';
      case PostType.challenge:
        return 'Describe the challenge you\'re taking on...';
      default:
        return 'Share what\'s on your mind...';
    }
  }

  Future<void> _createPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please create a profile first')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final post = SocialPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: currentUser.id,
        content: _contentController.text.trim(),
        type: _selectedType,
        createdAt: DateTime.now(),
      );

      await ref.read(postsProvider.notifier).createPost(post);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating post: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
