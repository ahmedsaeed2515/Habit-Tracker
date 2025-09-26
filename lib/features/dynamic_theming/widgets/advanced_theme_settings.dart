import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/theming_models.dart';
import '../providers/dynamic_theming_providers.dart';

/// إعدادات الثيمات المتقدمة
class AdvancedThemeSettings extends ConsumerWidget {
  const AdvancedThemeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الإعدادات الأساسية
          _buildBasicSettings(context, ref, themeSettings),
          
          const SizedBox(height: 24),
          
          // إعدادات التخصيص
          _buildCustomizationSettings(context, ref, themeSettings),
          
          const SizedBox(height: 24),
          
          // إعدادات الأداء
          _buildPerformanceSettings(context, ref, themeSettings),
        ],
      ),
    );
  }

  Widget _buildBasicSettings(BuildContext context, WidgetRef ref, ThemeSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات الأساسية',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // تغيير تلقائي للثيمات
            SwitchListTile(
              title: const Text('التغيير التلقائي للثيمات'),
              subtitle: const Text('تغيير الثيمات حسب الوقت'),
              value: settings.enableTimeBasedTheme,
              onChanged: (value) {
                ref.read(themeSettingsProvider.notifier).state = 
                    settings.copyWith(enableTimeBasedTheme: value);
              },
            ),
            
            // إعدادات التوقيت (إذا كان التغيير التلقائي مفعل)
            if (settings.enableTimeBasedTheme) ...[
              const Divider(),
              ListTile(
                title: const Text('بداية الثيم النهاري'),
                subtitle: Text(
                  settings.dayStartTime != null 
                    ? TimeOfDay.fromDateTime(settings.dayStartTime!).format(context)
                    : 'غير محدد'
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: settings.dayStartTime != null
                      ? TimeOfDay.fromDateTime(settings.dayStartTime!)
                      : const TimeOfDay(hour: 6, minute: 0),
                  );
                  if (time != null) {
                    final dateTime = DateTime(2000, 1, 1, time.hour, time.minute);
                    ref.read(themeSettingsProvider.notifier).state = 
                        settings.copyWith(dayStartTime: dateTime);
                  }
                },
              ),
              ListTile(
                title: const Text('بداية الثيم الليلي'),
                subtitle: Text(
                  settings.nightStartTime != null 
                    ? TimeOfDay.fromDateTime(settings.nightStartTime!).format(context)
                    : 'غير محدد'
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: settings.nightStartTime != null
                      ? TimeOfDay.fromDateTime(settings.nightStartTime!)
                      : const TimeOfDay(hour: 18, minute: 0),
                  );
                  if (time != null) {
                    final dateTime = DateTime(2000, 1, 1, time.hour, time.minute);
                    ref.read(themeSettingsProvider.notifier).state = 
                        settings.copyWith(nightStartTime: dateTime);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSettings(BuildContext context, WidgetRef ref, ThemeSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات التخصيص',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // الألوان المفضلة
            ListTile(
              title: const Text('الألوان المفضلة'),
              subtitle: const Text('عرض وإدارة الألوان المفضلة'),
              trailing: const Icon(Icons.palette),
              onTap: () {
                // يمكن إضافة شاشة لإدارة الألوان المفضلة لاحقاً
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ميزة إدارة الألوان المفضلة قريباً')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSettings(BuildContext context, WidgetRef ref, ThemeSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الأداء',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // تفعيل الرسوم المتحركة
            SwitchListTile(
              title: const Text('الرسوم المتحركة'),
              subtitle: const Text('تفعيل انتقالات الثيمات المتحركة'),
              value: settings.enableAnimations,
              onChanged: (value) {
                ref.read(themeSettingsProvider.notifier).state = 
                    settings.copyWith(enableAnimations: value);
              },
            ),
            
            // سرعة الرسوم المتحركة
            if (settings.enableAnimations) ...[
              const Divider(),
              ListTile(
                title: const Text('سرعة الرسوم المتحركة'),
                subtitle: Slider(
                  value: settings.animationSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 3,
                  label: '${settings.animationSpeed}x',
                  onChanged: (value) {
                    ref.read(themeSettingsProvider.notifier).state = 
                        settings.copyWith(animationSpeed: value);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}