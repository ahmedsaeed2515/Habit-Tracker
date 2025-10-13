// lib/core/services/firebase_achievements_service.dart
// خدمة إدارة الإنجازات والمكافآت

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// نموذج الإنجاز
class Achievement {

  Achievement({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    required this.points,
    required this.category,
    required this.requiredCount,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      icon: map['icon'] ?? '🏆',
      points: map['points'] ?? 0,
      category: map['category'] ?? 'general',
      requiredCount: map['requiredCount'] ?? 1,
    );
  }
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String icon;
  final int points;
  final String category;
  final int requiredCount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'icon': icon,
      'points': points,
      'category': category,
      'requiredCount': requiredCount,
    };
  }
}

/// نموذج إنجاز المستخدم
class UserAchievement {

  UserAchievement({
    required this.achievementId,
    required this.userId,
    required this.unlockedAt,
    required this.progress,
  });

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      achievementId: map['achievementId'] ?? '',
      userId: map['userId'] ?? '',
      unlockedAt: DateTime.parse(map['unlockedAt']),
      progress: map['progress'] ?? 0,
    );
  }
  final String achievementId;
  final String userId;
  final DateTime unlockedAt;
  final int progress;

  Map<String, dynamic> toMap() {
    return {
      'achievementId': achievementId,
      'userId': userId,
      'unlockedAt': unlockedAt.toIso8601String(),
      'progress': progress,
    };
  }
}

/// خدمة الإنجازات
class FirebaseAchievementsService {
  factory FirebaseAchievementsService() => _instance;
  FirebaseAchievementsService._internal();
  final FirebaseService _firebase = FirebaseService();
  
  static final FirebaseAchievementsService _instance = 
      FirebaseAchievementsService._internal();

  CollectionReference get _achievementsCollection =>
      _firebase.firestore.collection('achievements');

  CollectionReference get _userAchievementsCollection =>
      _firebase.firestore.collection('user_achievements');

  /// الحصول على جميع الإنجازات
  Future<List<Achievement>> getAllAchievements() async {
    try {
      final snapshot = await _achievementsCollection.get();
      return snapshot.docs.map((doc) {
        return Achievement.fromMap(doc.data()! as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على الإنجازات: $e');
      return _getDefaultAchievements();
    }
  }

  /// الحصول على إنجازات المستخدم
  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    try {
      final snapshot = await _userAchievementsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs.map((doc) {
        return UserAchievement.fromMap(doc.data()! as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في الحصول على إنجازات المستخدم: $e');
      return [];
    }
  }

  /// فتح إنجاز جديد
  Future<void> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      final docId = '${userId}_$achievementId';
      await _userAchievementsCollection.doc(docId).set(
        UserAchievement(
          achievementId: achievementId,
          userId: userId,
          unlockedAt: DateTime.now(),
          progress: 100,
        ).toMap(),
      );
    } catch (e) {
      debugPrint('خطأ في فتح الإنجاز: $e');
    }
  }

  /// تحديث تقدم الإنجاز
  Future<void> updateProgress(
    String userId,
    String achievementId,
    int progress,
  ) async {
    try {
      final docId = '${userId}_$achievementId';
      await _userAchievementsCollection.doc(docId).set({
        'achievementId': achievementId,
        'userId': userId,
        'progress': progress,
        'unlockedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('خطأ في تحديث تقدم الإنجاز: $e');
    }
  }

  /// الإنجازات الافتراضية
  List<Achievement> _getDefaultAchievements() {
    return [
      Achievement(
        id: 'first_habit',
        nameAr: 'العادة الأولى',
        nameEn: 'First Habit',
        descriptionAr: 'أكمل عادتك الأولى',
        descriptionEn: 'Complete your first habit',
        icon: '🎯',
        points: 10,
        category: 'habits',
        requiredCount: 1,
      ),
      Achievement(
        id: 'week_streak',
        nameAr: 'أسبوع متواصل',
        nameEn: 'Week Streak',
        descriptionAr: 'حافظ على عادة لمدة 7 أيام',
        descriptionEn: 'Maintain a habit for 7 days',
        icon: '🔥',
        points: 50,
        category: 'habits',
        requiredCount: 7,
      ),
      Achievement(
        id: 'month_master',
        nameAr: 'سيد الشهر',
        nameEn: 'Month Master',
        descriptionAr: 'حافظ على عادة لمدة 30 يوم',
        descriptionEn: 'Maintain a habit for 30 days',
        icon: '👑',
        points: 200,
        category: 'habits',
        requiredCount: 30,
      ),
      Achievement(
        id: 'social_butterfly',
        nameAr: 'اجتماعي نشط',
        nameEn: 'Social Butterfly',
        descriptionAr: 'شجع 10 مستخدمين',
        descriptionEn: 'Encourage 10 users',
        icon: '🦋',
        points: 30,
        category: 'social',
        requiredCount: 10,
      ),
      Achievement(
        id: 'generous_giver',
        nameAr: 'كريم معطاء',
        nameEn: 'Generous Giver',
        descriptionAr: 'أرسل 5 هدايا',
        descriptionEn: 'Send 5 gifts',
        icon: '🎁',
        points: 40,
        category: 'social',
        requiredCount: 5,
      ),
    ];
  }

  /// تهيئة الإنجازات الافتراضية
  Future<void> initializeDefaultAchievements() async {
    try {
      final achievements = _getDefaultAchievements();
      for (final achievement in achievements) {
        await _achievementsCollection
            .doc(achievement.id)
            .set(achievement.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('خطأ في تهيئة الإنجازات الافتراضية: $e');
    }
  }
}
