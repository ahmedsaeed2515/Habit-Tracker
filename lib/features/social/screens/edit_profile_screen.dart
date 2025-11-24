import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_user.dart';
import '../providers/social_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isPublic = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _displayNameController.text = currentUser.displayName;
      _bioController.text = currentUser.bio;
      _countryController.text = currentUser.country;
      _cityController.text = currentUser.city ?? '';
      _isPublic = currentUser.isPublic;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: currentUser.avatarUrl != null
                              ? NetworkImage(currentUser.avatarUrl!)
                              : null,
                          child: currentUser.avatarUrl == null
                              ? Text(
                                  currentUser.displayName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () async {
                            try {
                              final result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );
                              
                              if (result != null && result.files.isNotEmpty) {
                                final file = result.files.first;
                                setState(() {
                                  _avatarUrl = file.path;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Image selected successfully!'),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error selecting image: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Change Photo'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Basic Information
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Display Name
                  TextField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      hintText: 'How others see you',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 16),

                  // Username (read-only)
                  TextField(
                    controller: TextEditingController(
                      text: currentUser.username,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Tell others about yourself',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    maxLength: 200,
                  ),

                  const SizedBox(height: 32),

                  // Location
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Country
                  TextField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      hintText: 'Your country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Your city (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Privacy Settings
                  Text(
                    'Privacy Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Public Profile Toggle
                  SwitchListTile(
                    title: const Text('Public Profile'),
                    subtitle: const Text('Allow others to find and follow you'),
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() => _isPublic = value);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Stats (read-only)
                  Text(
                    'Your Stats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _StatRow(
                          label: 'Level',
                          value: currentUser.level.toString(),
                          icon: Icons.star,
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: 'Total Points',
                          value: currentUser.totalPoints.toString(),
                          icon: Icons.emoji_events,
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: 'Achievements',
                          value: currentUser.achievements.length.toString(),
                          icon: Icons.military_tech,
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: 'Followers',
                          value: currentUser.followers.length.toString(),
                          icon: Icons.people,
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: 'Following',
                          value: currentUser.following.length.toString(),
                          icon: Icons.person_add,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _saveProfile() async {
    if (_displayNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final updatedUser = SocialUser(
        id: currentUser.id,
        username: currentUser.username,
        displayName: _displayNameController.text.trim(),
        email: currentUser.email,
        avatarUrl: currentUser.avatarUrl,
        bio: _bioController.text.trim(),
        totalPoints: currentUser.totalPoints,
        level: currentUser.level,
        achievements: currentUser.achievements,
        joinDate: currentUser.joinDate,
        lastActive: currentUser.lastActive,
        isPublic: _isPublic,
        friends: currentUser.friends,
        followers: currentUser.followers,
        following: currentUser.following,
        stats: currentUser.stats,
        country: _countryController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
      );

      await ref.read(currentUserProvider.notifier).updateUser(updatedUser);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _StatRow extends StatelessWidget {

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
