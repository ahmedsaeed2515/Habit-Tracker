// lib/shared/themes/app_colors.dart
// مجموعة شاملة من الألوان المستخدمة في التطبيق

import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF10B981); // Emerald  
  static const Color accent = Color(0xFFF59E0B); // Amber
  
  // ألوان الحالة
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF97316); // Orange
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // ألوان النظام الفاتح
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF1F2937);
  static const Color lightOnBackground = Color(0xFF374151);
  
  // ألوان النظام المظلم
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnBackground = Color(0xFFE5E7EB);
  
  // ألوان إضافية للمكونات
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE5E7EB);
  static const Color inactive = Color(0xFF9CA3AF);
  static const Color textSecondary = Color(0xFF6B7280);
  
  // ألوان متدرجة للإحصائيات والرسوم البيانية
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF97316), // Orange
    Color(0xFFEC4899), // Pink
  ];
  
  // ألوان خاصة بالعادات والتصنيفات
  static const Color healthCategory = Color(0xFF10B981); // Green
  static const Color fitnessCategory = Color(0xFFF97316); // Orange
  static const Color productivityCategory = Color(0xFF3B82F6); // Blue
  static const Color learningCategory = Color(0xFF8B5CF6); // Purple
  static const Color mindfulnessCategory = Color(0xFF06B6D4); // Cyan
  static const Color socialCategory = Color(0xFFEC4899); // Pink
  static const Color creativeCategory = Color(0xFFF59E0B); // Amber
  static const Color financialCategory = Color(0xFF6366F1); // Indigo
  static const Color environmentalCategory = Color(0xFF84CC16); // Lime
  static const Color personalCategory = Color(0xFF8B4513); // Brown-like
}