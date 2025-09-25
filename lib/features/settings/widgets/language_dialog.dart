import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/localization/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';

/// حوار اختيار اللغة
class LanguageDialog extends ConsumerWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return AlertDialog(
      title: Text(localizations.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('العربية'),
            leading: const Icon(Icons.language),
            onTap: () {
              settingsNotifier.changeLanguage('ar');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('English'),
            leading: const Icon(Icons.language),
            onTap: () {
              settingsNotifier.changeLanguage('en');
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
      ],
    );
  }
}
