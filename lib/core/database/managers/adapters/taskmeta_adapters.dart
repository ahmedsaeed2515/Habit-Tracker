// lib/core/database/managers/adapters/taskmeta_adapters.dart
// محولات ميزات Task Meta الجديدة (الملاحظات، المزاج، الميزانية، المشاريع)

import 'package:flutter/foundation.dart';

/// محولات ميزات Task Meta
class TaskMetaAdaptersRegistrar {
  /// تسجيل محولات الملاحظات (IDs: 250-254)
  static void registerNotesAdapters() {
    try {
      // سيتم تفعيلها بعد تشغيل build_runner
      debugPrint('⏳ محولات الملاحظات جاهزة للتسجيل (typeIds: 250-254)');
      // if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());
      // if (!Hive.isAdapterRegistered(251)) Hive.registerAdapter(NoteAttachmentAdapter());
      // if (!Hive.isAdapterRegistered(252)) Hive.registerAdapter(NoteLinkAdapter());
      // if (!Hive.isAdapterRegistered(253)) Hive.registerAdapter(AttachmentTypeAdapter());
      // if (!Hive.isAdapterRegistered(254)) Hive.registerAdapter(LinkTargetTypeAdapter());
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الملاحظات: $e');
    }
  }

  /// تسجيل محولات المزاج واليومية (IDs: 255-257)
  static void registerMoodJournalAdapters() {
    try {
      debugPrint('⏳ محولات المزاج جاهزة للتسجيل (typeIds: 255-257)');
      // if (!Hive.isAdapterRegistered(255)) Hive.registerAdapter(MoodEntryAdapter());
      // if (!Hive.isAdapterRegistered(256)) Hive.registerAdapter(JournalEntryAdapter());
      // if (!Hive.isAdapterRegistered(257)) Hive.registerAdapter(MoodAnalyticsAdapter());
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المزاج والمذكرات: $e');
    }
  }

  /// تسجيل محولات الميزانية (IDs: 258-262)
  static void registerBudgetAdapters() {
    try {
      debugPrint('⏳ محولات الميزانية جاهزة للتسجيل (typeIds: 258-262)');
      // if (!Hive.isAdapterRegistered(258)) Hive.registerAdapter(ExpenseAdapter());
      // if (!Hive.isAdapterRegistered(259)) Hive.registerAdapter(IncomeAdapter());
      // if (!Hive.isAdapterRegistered(260)) Hive.registerAdapter(BudgetCategoryAdapter());
      // if (!Hive.isAdapterRegistered(261)) Hive.registerAdapter(FinancialReportAdapter());
      // if (!Hive.isAdapterRegistered(262)) Hive.registerAdapter(RecurrenceTypeAdapter());
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الميزانية: $e');
    }
  }

  /// تسجيل محولات المشاريع (IDs: 263-270)
  static void registerProjectsAdapters() {
    try {
      debugPrint('⏳ محولات المشاريع جاهزة للتسجيل (typeIds: 263-270)');
      // if (!Hive.isAdapterRegistered(263)) Hive.registerAdapter(ProjectAdapter());
      // if (!Hive.isAdapterRegistered(264)) Hive.registerAdapter(ProjectStatusAdapter());
      // if (!Hive.isAdapterRegistered(265)) Hive.registerAdapter(ProjectPhaseAdapter());
      // if (!Hive.isAdapterRegistered(266)) Hive.registerAdapter(PhaseStatusAdapter());
      // if (!Hive.isAdapterRegistered(267)) Hive.registerAdapter(ProjectTaskAdapter());
      // if (!Hive.isAdapterRegistered(268)) Hive.registerAdapter(TaskPriorityAdapter());
      // if (!Hive.isAdapterRegistered(269)) Hive.registerAdapter(TaskStatusAdapter());
      // if (!Hive.isAdapterRegistered(270)) Hive.registerAdapter(ProjectViewModeAdapter());
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المشاريع: $e');
    }
  }

  /// تسجيل محولات Inbox/Ideas (IDs: 271-278)
  static void registerInboxAdapters() {
    try {
      debugPrint('⏳ محولات Inbox جاهزة للتسجيل (typeIds: 271-278)');
      // سيتم إضافتها لاحقاً
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات Inbox: $e');
    }
  }

  /// تسجيل جميع محولات Task Meta
  static void registerAll() {
    registerNotesAdapters();
    registerMoodJournalAdapters();
    registerBudgetAdapters();
    registerProjectsAdapters();
    registerInboxAdapters();
    debugPrint('✅ تم تسجيل محولات Task Meta (معلقة لحين build_runner)');
  }
}
