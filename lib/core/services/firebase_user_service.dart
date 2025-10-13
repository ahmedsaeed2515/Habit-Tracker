// lib/core/services/firebase_user_service.dart
// خدمة إدارة المستخدمين عبر Firebase

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// نموذج بيانات المستخدم
class FirebaseUserData {

  FirebaseUserData({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    this.points = 0,
    this.level = 1,
    this.achievements = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory FirebaseUserData.fromMap(Map<String, dynamic> map) {
    return FirebaseUserData(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      points: map['points'] ?? 0,
      level: map['level'] ?? 1,
      achievements: List<String>.from(map['achievements'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final int points;
  final int level;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'points': points,
      'level': level,
      'achievements': achievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FirebaseUserData copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    int? points,
    int? level,
    List<String>? achievements,
  }) {
    return FirebaseUserData(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      level: level ?? this.level,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// خدمة إدارة المستخدمين
class FirebaseUserService {
  factory FirebaseUserService() => _instance;
  FirebaseUserService._internal();
  final FirebaseService _firebase = FirebaseService();
  
  static final FirebaseUserService _instance = FirebaseUserService._internal();

  CollectionReference get _usersCollection =>
      _firebase.firestore.collection('users');

  /// الحصول على بيانات المستخدم
  Future<FirebaseUserData?> getUserData(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return FirebaseUserData.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('خطأ في الحصول على بيانات المستخدم: $e');
      return null;
    }
  }

  /// إنشاء أو تحديث بيانات المستخدم
  Future<void> saveUserData(FirebaseUserData userData) async {
    try {
      await _usersCollection.doc(userData.id).set(
        userData.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('خطأ في حفظ بيانات المستخدم: $e');
      rethrow;
    }
  }

  /// تحديث النقاط
  Future<void> updatePoints(String userId, int points) async {
    try {
      await _usersCollection.doc(userId).update({
        'points': FieldValue.increment(points),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('خطأ في تحديث النقاط: $e');
    }
  }

  /// إضافة إنجاز
  Future<void> addAchievement(String userId, String achievementId) async {
    try {
      await _usersCollection.doc(userId).update({
        'achievements': FieldValue.arrayUnion([achievementId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('خطأ في إضافة الإنجاز: $e');
    }
  }

  /// الحصول على قائمة المستخدمين
  Stream<List<FirebaseUserData>> getUsersStream() {
    try {
      return _usersCollection
          .orderBy('points', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return FirebaseUserData.fromMap(doc.data()! as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('خطأ في الحصول على قائمة المستخدمين: $e');
      return Stream.value([]);
    }
  }

  /// البحث عن المستخدمين
  Future<List<FirebaseUserData>> searchUsers(String query) async {
    try {
      final snapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        return FirebaseUserData.fromMap(doc.data()! as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('خطأ في البحث عن المستخدمين: $e');
      return [];
    }
  }
}
