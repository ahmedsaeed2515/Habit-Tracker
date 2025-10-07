// lib/features/accessibility/helpers/accessibility_helper.dart
// مساعد لتحسين إمكانية الوصول في التطبيق

import 'package:flutter/material.dart';

/// مساعد لتحسين إمكانية الوصول في التطبيق
class AccessibilityHelper {
  /// إنشاء عنصر واجهة مستخدم مع تحسينات إمكانية الوصول
  static Widget makeAccessible({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      enabled: onTap != null,
      onTap: onTap,
      child: child,
    );
  }

  /// إنشاء زر مع تحسينات إمكانية الوصول
  static Widget accessibleButton({
    required Widget child,
    required String label,
    String? hint,
    required VoidCallback onPressed,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: true,
      excludeSemantics: excludeSemantics,
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }

  /// إنشاء نص مع تحسينات إمكانية الوصول
  static Widget accessibleText({
    required String text,
    TextStyle? style,
    String? semanticsLabel,
    TextAlign? textAlign,
  }) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }

  /// إنشاء أيقونة مع تحسينات إمكانية الوصول
  static Widget accessibleIcon({
    required IconData icon,
    required String label,
    String? hint,
    double? size,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: onTap != null,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }

  /// إنشاء حقل إدخال مع تحسينات إمكانية الوصول
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
    InputDecoration? decoration,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextField(
        controller: controller,
        decoration: decoration ?? InputDecoration(labelText: label, hintText: hint),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      ),
    );
  }

  /// تكبير حجم النص بناءً على إعدادات النظام
  static TextStyle getAccessibleTextStyle(BuildContext context, TextStyle baseStyle) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * textScaleFactor,
    );
  }
}