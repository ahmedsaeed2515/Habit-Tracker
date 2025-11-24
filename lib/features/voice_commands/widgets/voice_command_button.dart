// lib/features/voice_commands/widgets/voice_command_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/voice_commands_provider.dart';

/// زر الأوامر الصوتية العائم
class VoiceCommandButton extends ConsumerWidget {
  const VoiceCommandButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceCommandsProvider);

    return FloatingActionButton(
      onPressed: voiceState.isProcessing
          ? null
          : () {
              if (voiceState.isListening) {
                ref.read(voiceCommandsProvider.notifier).stopListening();
              } else {
                ref.read(voiceCommandsProvider.notifier).startListening();
              }
            },
      backgroundColor: voiceState.isListening
          ? Colors.red
          : Theme.of(context).primaryColor,
      child: voiceState.isProcessing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Icon(
              voiceState.isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
    );
  }
}

/// زر الأوامر الصوتية المضغوط
class CompactVoiceCommandButton extends ConsumerWidget {

  const CompactVoiceCommandButton({
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceCommandsProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: voiceState.isProcessing
          ? null
          : () {
              if (voiceState.isListening) {
                ref.read(voiceCommandsProvider.notifier).stopListening();
              } else {
                ref.read(voiceCommandsProvider.notifier).startListening();
              }
            },
      child: Container(
        width: size ?? 48,
        height: size ?? 48,
        decoration: BoxDecoration(
          color: voiceState.isListening
              ? Colors.red.withValues(alpha: 0.9)
              : backgroundColor ?? theme.primaryColor.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: voiceState.isProcessing
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Icon(
                voiceState.isListening ? Icons.mic : Icons.mic_none,
                color: iconColor ?? Colors.white,
                size: (size ?? 48) * 0.5,
              ),
      ),
    );
  }
}

/// شريط الأوامر الصوتية السفلي
class VoiceCommandBottomBar extends ConsumerWidget {
  const VoiceCommandBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceCommandsProvider);

    if (!voiceState.isListening &&
        !voiceState.isProcessing &&
        voiceState.lastRecognizedText == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر الحالة
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: voiceState.isListening
                      ? Colors.red
                      : voiceState.isProcessing
                      ? Colors.orange
                      : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const const SizedBox(width: 8),
              Text(
                voiceState.isListening
                    ? 'جاري الاستماع...'
                    : voiceState.isProcessing
                    ? 'جاري المعالجة...'
                    : 'تم الانتهاء',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(voiceCommandsProvider.notifier).stopListening();
                },
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),

          const const SizedBox(height: 8),

          // النص المُعترف به
          if (voiceState.lastRecognizedText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                voiceState.lastRecognizedText!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.right,
              ),
            ),

          // الاستجابة
          if (voiceState.lastResponse != null)
            Column(
              children: [
                const const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    voiceState.lastResponse!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
