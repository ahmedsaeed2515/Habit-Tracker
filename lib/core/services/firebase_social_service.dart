// lib/core/services/firebase_social_service.dart
// خدمة التفاعل الاجتماعي والتشجيع

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// نموذج التفاعل
class SocialInteraction {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String type; // 'encouragement', 'gift', 'like', 'comment'
  final String? message;
  final int points;
  final String? giftType;
  final DateTime createdAt;

  SocialInteraction({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.type,
    this.message,
    this.points = 0,
    this.giftType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'type': type,
      'message': message,
      'points': points,
      'giftType': giftType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SocialInteraction.fromMap(Map<String, dynamic> map) {
    return SocialInteraction(
      id: map['id'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      type: map['type'] ?? '',
      message: map['message'],
      points: map['points'] ?? 0,
      giftType: map['giftType'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

/// نموذج مشاركة الإنجاز
class AchievementShare {
  final String id;
  final String userId;
  final String achievementId;
  final String caption;
  final int likes;
  final List<String> comments;
  final DateTime createdAt;

  AchievementShare({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.caption,
    this.likes = 0,
    this.comments = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'achievementId': achievementId,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AchievementShare.fromMap(Map<String, dynamic> map) {
    return AchievementShare(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      achievementId: map['achievementId'] ?? '',
      caption: map['caption'] ?? '',
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

/// خدمة التفاعل الاجتماعي
class FirebaseSocialService {
  final FirebaseService _firebase = FirebaseService();
  
  static final FirebaseSocialService _instance = 
      FirebaseSocialService._internal();
  factory FirebaseSocialService() => _instance;
  FirebaseSocialService._internal();

  CollectionReference get _interactionsCollection =>
      _firebase.firestore.collection('social_interactions');

  CollectionReference get _sharesCollection =>
      _firebase.firestore.collection('achievement_shares');

  /// إرسال تشجيع
  Future<void> sendEncouragement(
    String fromUserId,
    String toUserId,
    String message,
  ) async {
    try {
      final interaction = SocialInteraction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: fromUserId,
        toUserId: toUserId,
        type: 'encouragement',
        message: message,
        points: 5,
        createdAt: DateTime.now(),
      );

      await _interactionsCollection.doc(interaction.id).set(interaction.toMap());
    } catch (e) {
      debugPrint('خطأ في إرسال التشجيع: $e');
    }
  }

  /// إرسال هدية
  Future<void> sendGift(
    String fromUserId,
    String toUserId,
    String giftType,
    int points,
  ) async {
    try {
      final interaction = SocialInteraction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: fromUserId,
        toUserId: toUserId,
        type: 'gift',
        giftType: giftType,
        points: points,
        createdAt: DateTime.now(),
      );

      await _interactionsCollection.doc(interaction.id).set(interaction.toMap());
    } catch (e) {
      debugPrint('خطأ في إرسال الهدية: $e');
    }
  }

  /// مشاركة إنجاز
  Future<void> shareAchievement(
    String userId,
    String achievementId,
    String caption,
  ) async {
    try {
      final share = AchievementShare(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        achievementId: achievementId,
        caption: caption,
        createdAt: DateTime.now(),
      );

      await _sharesCollection.doc(share.id).set(share.toMap());
    } catch (e) {
      debugPrint('خطأ في مشاركة الإنجاز: $e');
    }
  }

  /// الحصول على تفاعلات المستخدم
  Stream<List<SocialInteraction>> getUserInteractions(String userId) {
    try {
      return _interactionsCollection
          .where('toUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return SocialInteraction.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('خطأ في الحصول على التفاعلات: $e');
      return Stream.value([]);
    }
  }

  /// الحصول على مشاركات الإنجازات
  Stream<List<AchievementShare>> getAchievementShares() {
    try {
      return _sharesCollection
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return AchievementShare.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('خطأ في الحصول على المشاركات: $e');
      return Stream.value([]);
    }
  }

  /// إضافة إعجاب على مشاركة
  Future<void> likeShare(String shareId) async {
    try {
      await _sharesCollection.doc(shareId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('خطأ في إضافة الإعجاب: $e');
    }
  }

  /// إضافة تعليق على مشاركة
  Future<void> addComment(String shareId, String comment) async {
    try {
      await _sharesCollection.doc(shareId).update({
        'comments': FieldValue.arrayUnion([comment]),
      });
    } catch (e) {
      debugPrint('خطأ في إضافة التعليق: $e');
    }
  }

  /// الحصول على إحصائيات التفاعل
  Future<Map<String, int>> getInteractionStats(String userId) async {
    try {
      final sentSnapshot = await _interactionsCollection
          .where('fromUserId', isEqualTo: userId)
          .get();

      final receivedSnapshot = await _interactionsCollection
          .where('toUserId', isEqualTo: userId)
          .get();

      return {
        'sent': sentSnapshot.docs.length,
        'received': receivedSnapshot.docs.length,
        'encouragements': sentSnapshot.docs
            .where((doc) => (doc.data() as Map)['type'] == 'encouragement')
            .length,
        'gifts': sentSnapshot.docs
            .where((doc) => (doc.data() as Map)['type'] == 'gift')
            .length,
      };
    } catch (e) {
      debugPrint('خطأ في الحصول على إحصائيات التفاعل: $e');
      return {
        'sent': 0,
        'received': 0,
        'encouragements': 0,
        'gifts': 0,
      };
    }
  }
}
