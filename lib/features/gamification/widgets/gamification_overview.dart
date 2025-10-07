import 'package:flutter/material.dart';

import 'points_actions.dart';
import 'points_statistics.dart';
import 'points_summary.dart';

/// النظرة الشاملة لنظام التحفيز - يجمع جميع المكونات المنفصلة
/// هذا الملف يربط بين جميع ملفات النقاط المختلفة
class GamificationOverview extends StatelessWidget {
  const GamificationOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // ملخص النقاط الأساسي
          PointsSummary(),

          // الإحصائيات المتقدمة
          PointsStatistics(),

          // عمليات وإجراءات النقاط
          PointsActions(),

          // مساحة إضافية في الأسفل
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
