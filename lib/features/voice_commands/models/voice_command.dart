// lib/features/voice_commands/models/voice_command.dart
import 'package:hive/hive.dart';

part 'voice_command.g.dart';

/// أنواع الأوامر الصوتية
@HiveType(typeId: 18)
enum VoiceCommandType {
  @HiveField(0)
  habit,
  @HiveField(1)
  task,
  @HiveField(2)
  exercise,
  @HiveField(3)
  navigation,
  @HiveField(4)
  settings,
  @HiveField(5)
  analytics,
  @HiveField(6)
  general,
}

/// حالة الأمر الصوتي
@HiveType(typeId: 19)
enum CommandStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
}

/// نموذج الأمر الصوتي
@HiveType(typeId: 20)
class VoiceCommand extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String originalText;

  @HiveField(2)
  String processedText;

  @HiveField(3)
  VoiceCommandType type;

  @HiveField(4)
  CommandStatus status;

  @HiveField(5)
  Map<String, dynamic> parameters;

  @HiveField(6)
  String? response;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? executedAt;

  @HiveField(9)
  double confidence;

  @HiveField(10)
  String? errorMessage;

  @HiveField(11)
  bool isBookmarked;

  VoiceCommand({
    required this.id,
    required this.originalText,
    required this.processedText,
    required this.type,
    this.status = CommandStatus.pending,
    this.parameters = const {},
    this.response,
    required this.createdAt,
    this.executedAt,
    this.confidence = 0.0,
    this.errorMessage,
    this.isBookmarked = false,
  });

  VoiceCommand copyWith({
    String? id,
    String? originalText,
    String? processedText,
    VoiceCommandType? type,
    CommandStatus? status,
    Map<String, dynamic>? parameters,
    String? response,
    DateTime? createdAt,
    DateTime? executedAt,
    double? confidence,
    String? errorMessage,
    bool? isBookmarked,
  }) {
    return VoiceCommand(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      processedText: processedText ?? this.processedText,
      type: type ?? this.type,
      status: status ?? this.status,
      parameters: parameters ?? this.parameters,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      executedAt: executedAt ?? this.executedAt,
      confidence: confidence ?? this.confidence,
      errorMessage: errorMessage ?? this.errorMessage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'originalText': originalText,
    'processedText': processedText,
    'type': type.index,
    'status': status.index,
    'parameters': parameters,
    'response': response,
    'createdAt': createdAt.toIso8601String(),
    'executedAt': executedAt?.toIso8601String(),
    'confidence': confidence,
    'errorMessage': errorMessage,
    'isBookmarked': isBookmarked,
  };

  /// تحويل من JSON
  static VoiceCommand fromJson(Map<String, dynamic> json) => VoiceCommand(
    id: json['id'],
    originalText: json['originalText'],
    processedText: json['processedText'],
    type: VoiceCommandType.values[json['type']],
    status: CommandStatus.values[json['status'] ?? 0],
    parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    response: json['response'],
    createdAt: DateTime.parse(json['createdAt']),
    executedAt: json['executedAt'] != null
        ? DateTime.parse(json['executedAt'])
        : null,
    confidence: json['confidence']?.toDouble() ?? 0.0,
    errorMessage: json['errorMessage'],
    isBookmarked: json['isBookmarked'] ?? false,
  );

  /// الحصول على أيقونة نوع الأمر
  String get typeIcon {
    switch (type) {
      case VoiceCommandType.habit:
        return '🔄';
      case VoiceCommandType.task:
        return '✅';
      case VoiceCommandType.exercise:
        return '💪';
      case VoiceCommandType.navigation:
        return '🧭';
      case VoiceCommandType.settings:
        return '⚙️';
      case VoiceCommandType.analytics:
        return '📊';
      case VoiceCommandType.general:
        return '💬';
    }
  }

  /// الحصول على اسم نوع الأمر
  String get typeName {
    switch (type) {
      case VoiceCommandType.habit:
        return 'عادة';
      case VoiceCommandType.task:
        return 'مهمة';
      case VoiceCommandType.exercise:
        return 'تمرين';
      case VoiceCommandType.navigation:
        return 'تنقل';
      case VoiceCommandType.settings:
        return 'إعدادات';
      case VoiceCommandType.analytics:
        return 'تحليلات';
      case VoiceCommandType.general:
        return 'عام';
    }
  }

  /// الحصول على وصف حالة الأمر
  String get statusText {
    switch (status) {
      case CommandStatus.pending:
        return 'في الانتظار';
      case CommandStatus.processing:
        return 'جاري المعالجة';
      case CommandStatus.completed:
        return 'مكتمل';
      case CommandStatus.failed:
        return 'فشل';
    }
  }

  /// تحديد مستوى الثقة
  String get confidenceLevel {
    if (confidence >= 0.8) return 'عالي';
    if (confidence >= 0.6) return 'متوسط';
    if (confidence >= 0.4) return 'منخفض';
    return 'ضعيف جداً';
  }

  @override
  String toString() {
    return 'VoiceCommand(id: $id, text: $originalText, type: $type, status: $status)';
  }
}
