// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccessibilitySettingsAdapter extends TypeAdapter<AccessibilitySettings> {
  @override
  final int typeId = 92;

  @override
  AccessibilitySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilitySettings(
      id: fields[0] as String,
      reduceAnimations: fields[1] as bool,
      highContrast: fields[2] as bool,
      fontSize: fields[3] as FontSize,
      boldText: fields[4] as bool,
      screenReaderSupport: fields[5] as bool,
      voiceCommands: fields[6] as bool,
      hapticFeedback: fields[7] as bool,
      soundFeedback: fields[8] as bool,
      colorBlindnessType: fields[9] as ColorBlindnessType,
      motorImpairment: fields[10] as MotorImpairmentSettings,
      cognitiveAccessibility: fields[11] as CognitiveAccessibilitySettings,
      customSettings: (fields[12] as Map).cast<String, dynamic>(),
      lastUpdated: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilitySettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reduceAnimations)
      ..writeByte(2)
      ..write(obj.highContrast)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.boldText)
      ..writeByte(5)
      ..write(obj.screenReaderSupport)
      ..writeByte(6)
      ..write(obj.voiceCommands)
      ..writeByte(7)
      ..write(obj.hapticFeedback)
      ..writeByte(8)
      ..write(obj.soundFeedback)
      ..writeByte(9)
      ..write(obj.colorBlindnessType)
      ..writeByte(10)
      ..write(obj.motorImpairment)
      ..writeByte(11)
      ..write(obj.cognitiveAccessibility)
      ..writeByte(12)
      ..write(obj.customSettings)
      ..writeByte(13)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilitySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MotorImpairmentSettingsAdapter
    extends TypeAdapter<MotorImpairmentSettings> {
  @override
  final int typeId = 95;

  @override
  MotorImpairmentSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MotorImpairmentSettings(
      isEnabled: fields[0] as bool,
      largerTouchTargets: fields[1] as bool,
      stickyKeys: fields[2] as bool,
      slowKeys: fields[3] as bool,
      bounceKeys: fields[4] as bool,
      touchSensitivity: fields[5] as double,
      touchHoldDuration: fields[6] as int,
      oneHandedMode: fields[7] as bool,
      assistiveTouch: fields[8] as bool,
      preferredSwipeGesture: fields[9] as SwipeGesture,
    );
  }

  @override
  void write(BinaryWriter writer, MotorImpairmentSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.largerTouchTargets)
      ..writeByte(2)
      ..write(obj.stickyKeys)
      ..writeByte(3)
      ..write(obj.slowKeys)
      ..writeByte(4)
      ..write(obj.bounceKeys)
      ..writeByte(5)
      ..write(obj.touchSensitivity)
      ..writeByte(6)
      ..write(obj.touchHoldDuration)
      ..writeByte(7)
      ..write(obj.oneHandedMode)
      ..writeByte(8)
      ..write(obj.assistiveTouch)
      ..writeByte(9)
      ..write(obj.preferredSwipeGesture);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotorImpairmentSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CognitiveAccessibilitySettingsAdapter
    extends TypeAdapter<CognitiveAccessibilitySettings> {
  @override
  final int typeId = 97;

  @override
  CognitiveAccessibilitySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CognitiveAccessibilitySettings(
      isEnabled: fields[0] as bool,
      simplifiedInterface: fields[1] as bool,
      reducedClutter: fields[2] as bool,
      clearLabels: fields[3] as bool,
      consistentNavigation: fields[4] as bool,
      confirmationPrompts: fields[5] as bool,
      progressIndicators: fields[6] as bool,
      timeoutWarnings: fields[7] as bool,
      focusTimeout: fields[8] as int,
      audioDescriptions: fields[9] as bool,
      visualCues: fields[10] as bool,
      memoryAssistLevel: fields[11] as MemoryAssistLevel,
    );
  }

  @override
  void write(BinaryWriter writer, CognitiveAccessibilitySettings obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.simplifiedInterface)
      ..writeByte(2)
      ..write(obj.reducedClutter)
      ..writeByte(3)
      ..write(obj.clearLabels)
      ..writeByte(4)
      ..write(obj.consistentNavigation)
      ..writeByte(5)
      ..write(obj.confirmationPrompts)
      ..writeByte(6)
      ..write(obj.progressIndicators)
      ..writeByte(7)
      ..write(obj.timeoutWarnings)
      ..writeByte(8)
      ..write(obj.focusTimeout)
      ..writeByte(9)
      ..write(obj.audioDescriptions)
      ..writeByte(10)
      ..write(obj.visualCues)
      ..writeByte(11)
      ..write(obj.memoryAssistLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CognitiveAccessibilitySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessibilityAuditAdapter extends TypeAdapter<AccessibilityAudit> {
  @override
  final int typeId = 99;

  @override
  AccessibilityAudit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilityAudit(
      id: fields[0] as String,
      auditDate: fields[1] as DateTime,
      issues: (fields[2] as List).cast<AccessibilityIssue>(),
      recommendations: (fields[3] as List).cast<AccessibilityRecommendation>(),
      overallScore: fields[4] as double,
      categoryScores: (fields[5] as Map).cast<String, double>(),
      auditData: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilityAudit obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.auditDate)
      ..writeByte(2)
      ..write(obj.issues)
      ..writeByte(3)
      ..write(obj.recommendations)
      ..writeByte(4)
      ..write(obj.overallScore)
      ..writeByte(5)
      ..write(obj.categoryScores)
      ..writeByte(6)
      ..write(obj.auditData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityAuditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessibilityIssueAdapter extends TypeAdapter<AccessibilityIssue> {
  @override
  final int typeId = 100;

  @override
  AccessibilityIssue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilityIssue(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      severity: fields[3] as IssueSeverity,
      category: fields[4] as IssueCategory,
      location: fields[5] as String,
      isFixed: fields[6] as bool,
      fixedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilityIssue obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.severity)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.isFixed)
      ..writeByte(7)
      ..write(obj.fixedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessibilityRecommendationAdapter
    extends TypeAdapter<AccessibilityRecommendation> {
  @override
  final int typeId = 103;

  @override
  AccessibilityRecommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilityRecommendation(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      priority: fields[3] as RecommendationPriority,
      category: fields[4] as IssueCategory,
      steps: (fields[5] as List).cast<String>(),
      isImplemented: fields[6] as bool,
      implementedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilityRecommendation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.steps)
      ..writeByte(6)
      ..write(obj.isImplemented)
      ..writeByte(7)
      ..write(obj.implementedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityRecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FontSizeAdapter extends TypeAdapter<FontSize> {
  @override
  final int typeId = 93;

  @override
  FontSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FontSize.small;
      case 1:
        return FontSize.medium;
      case 2:
        return FontSize.large;
      case 3:
        return FontSize.extraLarge;
      case 4:
        return FontSize.huge;
      default:
        return FontSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, FontSize obj) {
    switch (obj) {
      case FontSize.small:
        writer.writeByte(0);
        break;
      case FontSize.medium:
        writer.writeByte(1);
        break;
      case FontSize.large:
        writer.writeByte(2);
        break;
      case FontSize.extraLarge:
        writer.writeByte(3);
        break;
      case FontSize.huge:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColorBlindnessTypeAdapter extends TypeAdapter<ColorBlindnessType> {
  @override
  final int typeId = 94;

  @override
  ColorBlindnessType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ColorBlindnessType.none;
      case 1:
        return ColorBlindnessType.deuteranopia;
      case 2:
        return ColorBlindnessType.protanopia;
      case 3:
        return ColorBlindnessType.tritanopia;
      case 4:
        return ColorBlindnessType.monochromacy;
      default:
        return ColorBlindnessType.none;
    }
  }

  @override
  void write(BinaryWriter writer, ColorBlindnessType obj) {
    switch (obj) {
      case ColorBlindnessType.none:
        writer.writeByte(0);
        break;
      case ColorBlindnessType.deuteranopia:
        writer.writeByte(1);
        break;
      case ColorBlindnessType.protanopia:
        writer.writeByte(2);
        break;
      case ColorBlindnessType.tritanopia:
        writer.writeByte(3);
        break;
      case ColorBlindnessType.monochromacy:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorBlindnessTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SwipeGestureAdapter extends TypeAdapter<SwipeGesture> {
  @override
  final int typeId = 96;

  @override
  SwipeGesture read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SwipeGesture.horizontal;
      case 1:
        return SwipeGesture.vertical;
      case 2:
        return SwipeGesture.disabled;
      default:
        return SwipeGesture.horizontal;
    }
  }

  @override
  void write(BinaryWriter writer, SwipeGesture obj) {
    switch (obj) {
      case SwipeGesture.horizontal:
        writer.writeByte(0);
        break;
      case SwipeGesture.vertical:
        writer.writeByte(1);
        break;
      case SwipeGesture.disabled:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwipeGestureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemoryAssistLevelAdapter extends TypeAdapter<MemoryAssistLevel> {
  @override
  final int typeId = 98;

  @override
  MemoryAssistLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MemoryAssistLevel.none;
      case 1:
        return MemoryAssistLevel.low;
      case 2:
        return MemoryAssistLevel.medium;
      case 3:
        return MemoryAssistLevel.high;
      default:
        return MemoryAssistLevel.none;
    }
  }

  @override
  void write(BinaryWriter writer, MemoryAssistLevel obj) {
    switch (obj) {
      case MemoryAssistLevel.none:
        writer.writeByte(0);
        break;
      case MemoryAssistLevel.low:
        writer.writeByte(1);
        break;
      case MemoryAssistLevel.medium:
        writer.writeByte(2);
        break;
      case MemoryAssistLevel.high:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryAssistLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueSeverityAdapter extends TypeAdapter<IssueSeverity> {
  @override
  final int typeId = 101;

  @override
  IssueSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueSeverity.low;
      case 1:
        return IssueSeverity.medium;
      case 2:
        return IssueSeverity.high;
      case 3:
        return IssueSeverity.critical;
      default:
        return IssueSeverity.low;
    }
  }

  @override
  void write(BinaryWriter writer, IssueSeverity obj) {
    switch (obj) {
      case IssueSeverity.low:
        writer.writeByte(0);
        break;
      case IssueSeverity.medium:
        writer.writeByte(1);
        break;
      case IssueSeverity.high:
        writer.writeByte(2);
        break;
      case IssueSeverity.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IssueCategoryAdapter extends TypeAdapter<IssueCategory> {
  @override
  final int typeId = 102;

  @override
  IssueCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueCategory.visual;
      case 1:
        return IssueCategory.motor;
      case 2:
        return IssueCategory.cognitive;
      case 3:
        return IssueCategory.hearing;
      case 4:
        return IssueCategory.navigation;
      case 5:
        return IssueCategory.content;
      default:
        return IssueCategory.visual;
    }
  }

  @override
  void write(BinaryWriter writer, IssueCategory obj) {
    switch (obj) {
      case IssueCategory.visual:
        writer.writeByte(0);
        break;
      case IssueCategory.motor:
        writer.writeByte(1);
        break;
      case IssueCategory.cognitive:
        writer.writeByte(2);
        break;
      case IssueCategory.hearing:
        writer.writeByte(3);
        break;
      case IssueCategory.navigation:
        writer.writeByte(4);
        break;
      case IssueCategory.content:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationPriorityAdapter
    extends TypeAdapter<RecommendationPriority> {
  @override
  final int typeId = 104;

  @override
  RecommendationPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecommendationPriority.low;
      case 1:
        return RecommendationPriority.medium;
      case 2:
        return RecommendationPriority.high;
      case 3:
        return RecommendationPriority.urgent;
      default:
        return RecommendationPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, RecommendationPriority obj) {
    switch (obj) {
      case RecommendationPriority.low:
        writer.writeByte(0);
        break;
      case RecommendationPriority.medium:
        writer.writeByte(1);
        break;
      case RecommendationPriority.high:
        writer.writeByte(2);
        break;
      case RecommendationPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
