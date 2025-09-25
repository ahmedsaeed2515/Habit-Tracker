// lib/features/dashboard/screens/dashboard_screen.dart
// شاشة لوحة التحكم الرئيسية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/localization/app_localizations.dart';
import '../widgets/widgets.dart';

/// شاشة لوحة التحكم الرئيسية
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboard),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: فتح صفحة الإشعارات
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الترحيب
            WelcomeSection(),
            SizedBox(height: 24),

            // الملخص السريع
            QuickSummary(),
            SizedBox(height: 24),

            // الإجراءات السريعة
            QuickActions(),
            SizedBox(height: 24),

            // النشاط الأخير
            RecentActivity(),
            SizedBox(height: 24),

            // الإحصائيات الأسبوعية
            WeeklyStats(),
          ],
        ),
      ),
    );
  }
}