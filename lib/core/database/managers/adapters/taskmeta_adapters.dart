// lib/core/database/managers/adapters/taskmeta_adapters.dart
// محولات ميزات Task Meta الجديدة (الملاحظات، المزاج، الميزانية، المشاريع)

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../features/budget/models/budget_models.dart';
import '../../../features/inbox/models/inbox_models.dart';
import '../../../features/mood_journal/models/mood_models.dart';
import '../../../features/notes/models/note_models.dart';
import '../../../features/projects/models/project_models.dart';

/// محولات ميزات Task Meta
class TaskMetaAdaptersRegistrar {
  /// تسجيل محولات الملاحظات (IDs: 250-254)
  static void registerNotesAdapters() {
    try {
      if (!Hive.isAdapterRegistered(250)) Hive.registerAdapter(NoteAdapter());
      if (!Hive.isAdapterRegistered(251)) Hive.registerAdapter(NoteAttachmentAdapter());
      if (!Hive.isAdapterRegistered(252)) Hive.registerAdapter(NoteLinkAdapter());
      if (!Hive.isAdapterRegistered(253)) Hive.registerAdapter(AttachmentTypeAdapter());
      if (!Hive.isAdapterRegistered(254)) Hive.registerAdapter(LinkTargetTypeAdapter());
      debugPrint('✅ تم تسجيل محولات الملاحظات (typeIds: 250-254)');
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الملاحظات: $e');
    }
  }

  /// تسجيل محولات المزاج واليومية (IDs: 255-257)
  static void registerMoodJournalAdapters() {
    try {
      if (!Hive.isAdapterRegistered(255)) Hive.registerAdapter(MoodEntryAdapter());
      if (!Hive.isAdapterRegistered(256)) Hive.registerAdapter(JournalEntryAdapter());
      if (!Hive.isAdapterRegistered(257)) Hive.registerAdapter(MoodAnalyticsAdapter());
      debugPrint('✅ تم تسجيل محولات المزاج (typeIds: 255-257)');
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المزاج والمذكرات: $e');
    }
  }

  /// تسجيل محولات الميزانية (IDs: 258-262)
  static void registerBudgetAdapters() {
    try {
      if (!Hive.isAdapterRegistered(258)) Hive.registerAdapter(ExpenseAdapter());
      if (!Hive.isAdapterRegistered(259)) Hive.registerAdapter(IncomeAdapter());
      if (!Hive.isAdapterRegistered(260)) Hive.registerAdapter(BudgetCategoryAdapter());
      if (!Hive.isAdapterRegistered(261)) Hive.registerAdapter(FinancialReportAdapter());
      if (!Hive.isAdapterRegistered(262)) Hive.registerAdapter(RecurrenceTypeAdapter());
      debugPrint('✅ تم تسجيل محولات الميزانية (typeIds: 258-262)');
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات الميزانية: $e');
    }
  }

  /// تسجيل محولات المشاريع (IDs: 263-270)
  static void registerProjectsAdapters() {
    try {
      if (!Hive.isAdapterRegistered(263)) Hive.registerAdapter(ProjectAdapter());
      if (!Hive.isAdapterRegistered(264)) Hive.registerAdapter(ProjectStatusAdapter());
      if (!Hive.isAdapterRegistered(265)) Hive.registerAdapter(ProjectPhaseAdapter());
      if (!Hive.isAdapterRegistered(266)) Hive.registerAdapter(PhaseStatusAdapter());
      if (!Hive.isAdapterRegistered(267)) Hive.registerAdapter(ProjectTaskAdapter());
      if (!Hive.isAdapterRegistered(268)) Hive.registerAdapter(TaskPriorityAdapter());
      if (!Hive.isAdapterRegistered(269)) Hive.registerAdapter(TaskStatusAdapter());
      if (!Hive.isAdapterRegistered(270)) Hive.registerAdapter(ProjectViewModeAdapter());
      debugPrint('✅ تم تسجيل محولات المشاريع (typeIds: 263-270)');
    } catch (e) {
      debugPrint('⚠️ فشل تسجيل محولات المشاريع: $e');
    }
  }

  /// تسجيل محولات Inbox/Ideas (IDs: 271-278)
  static void registerInboxAdapters() {
    try {
      if (!Hive.isAdapterRegistered(271)) Hive.registerAdapter(IdeaAdapter());
      if (!Hive.isAdapterRegistered(272)) Hive.registerAdapter(IdeaStatusAdapter());
      if (!Hive.isAdapterRegistered(273)) Hive.registerAdapter(IdeaPriorityAdapter());
      if (!Hive.isAdapterRegistered(274)) Hive.registerAdapter(LinkedItemTypeAdapter());
      if (!Hive.isAdapterRegistered(275)) Hive.registerAdapter(IdeaCategoryAdapter());
      if (!Hive.isAdapterRegistered(276)) Hive.registerAdapter(InboxItemAdapter());
      if (!Hive.isAdapterRegistered(277)) Hive.registerAdapter(InboxItemTypeAdapter());
      if (!Hive.isAdapterRegistered(278)) Hive.registerAdapter(ConvertedToTypeAdapter());
      debugPrint('✅ تم تسجيل محولات Inbox (typeIds: 271-278)');
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
    debugPrint('✅ تم تسجيل جميع محولات Task Meta بنجاح');
  }
}
