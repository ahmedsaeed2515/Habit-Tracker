/// ملف التصدير الموحد لجميع مُقدِمات نظام التحفيز
/// تم تقسيم المُقدِمات إلى ملفات منفصلة لسهولة الصيانة
///
/// الملفات المُقسَّمة:
/// - core_gamification_providers.dart: المُقدِمات الأساسية
/// - user_game_data_notifier.dart: مدير بيانات المستخدم
/// - achievements_providers.dart: مُقدِمات الإنجازات
/// - challenges_providers.dart: مُقدِمات التحديات
/// - advanced_stats_providers.dart: الإحصائيات المتقدمة
library;

// تصدير جميع المُقدِمات من الملفات المُقسَّمة
export 'core_gamification_providers.dart';
export 'user_game_data_notifier.dart';
export 'achievements_providers.dart';
export 'challenges_providers.dart';
export 'advanced_stats_providers.dart';

// إعادة تصدير النماذج المطلوبة
export '../models/gamification_data.dart';
export '../services/unified_gamification_service.dart';
