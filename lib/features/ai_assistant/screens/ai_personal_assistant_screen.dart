import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ai_personal_assistant_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class AIPersonalAssistantScreen extends ConsumerStatefulWidget {
  const AIPersonalAssistantScreen({super.key});

  @override
  ConsumerState<AIPersonalAssistantScreen> createState() =>
      _AIPersonalAssistantScreenState();
}

class _AIPersonalAssistantScreenState
    extends ConsumerState<AIPersonalAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(aiPersonalAssistantProvider.notifier).sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiPersonalAssistantProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الذكي'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              ref
                  .read(aiPersonalAssistantProvider.notifier)
                  .analyzeUserBehavior();
            },
            tooltip: 'تحليل السلوك',
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outlined),
            onPressed: () {
              ref
                  .read(aiPersonalAssistantProvider.notifier)
                  .generateSmartSuggestions();
            },
            tooltip: 'اقتراحات ذكية',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'tip':
                  ref
                      .read(aiPersonalAssistantProvider.notifier)
                      .sendRandomTip();
                  break;
                case 'motivation':
                  ref
                      .read(aiPersonalAssistantProvider.notifier)
                      .sendMotivationalQuote();
                  break;
                case 'stats':
                  ref.read(aiPersonalAssistantProvider.notifier).sendStats();
                  break;
                case 'clear':
                  _showClearDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'tip',
                child: ListTile(
                  leading: Icon(Icons.tips_and_updates),
                  title: Text('نصيحة عشوائية'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'motivation',
                child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('اقتباس تحفيزي'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('إحصائيات'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear_all, color: Colors.red),
                  title: Text(
                    'مسح المحادثة',
                    style: TextStyle(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && state.isTyping) {
                        return const TypingIndicator();
                      }

                      final messageIndex = state.isTyping ? index - 1 : index;
                      final message = state.messages[messageIndex];

                      return MessageBubble(
                        message: message,
                        onDelete: () => _showDeleteDialog(message.id),
                      );
                    },
                  ),
          ),
          _buildInputArea(theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'مرحباً! أنا مساعدك الذكي',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'يمكنني مساعدتك في تتبع عاداتك وتقديم النصائح والتحفيز. ابدأ محادثة معي!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickButton('نصيحة', Icons.lightbulb_outlined, () {
                ref.read(aiPersonalAssistantProvider.notifier).sendRandomTip();
              }),
              _buildQuickButton('تحفيز', Icons.favorite_outlined, () {
                ref
                    .read(aiPersonalAssistantProvider.notifier)
                    .sendMotivationalQuote();
              }),
              _buildQuickButton('إحصائيات', Icons.analytics_outlined, () {
                ref.read(aiPersonalAssistantProvider.notifier).sendStats();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        foregroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: _sendMessage,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الرسالة'),
        content: const Text('هل تريد حذف هذه الرسالة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(aiPersonalAssistantProvider.notifier)
                  .deleteMessage(messageId);
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل تريد مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref.read(aiPersonalAssistantProvider.notifier).clearMessages();
              Navigator.pop(context);
            },
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
