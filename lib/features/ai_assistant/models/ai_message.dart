import 'package:hive/hive.dart';

part 'ai_message.g.dart';

@HiveType(typeId: 24)
class AIMessage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isFromUser;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  AIMessageType type;

  @HiveField(5)
  Map<String, dynamic>? metadata;

  @HiveField(6)
  String? relatedHabitId;

  @HiveField(7)
  double? confidence;

  AIMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.type = AIMessageType.text,
    this.metadata,
    this.relatedHabitId,
    this.confidence,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.index,
      'metadata': metadata,
      'relatedHabitId': relatedHabitId,
      'confidence': confidence,
    };
  }

  factory AIMessage.fromMap(Map<String, dynamic> map) {
    return AIMessage(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      isFromUser: map['isFromUser'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      type: AIMessageType.values[map['type'] ?? 0],
      metadata: map['metadata'],
      relatedHabitId: map['relatedHabitId'],
      confidence: map['confidence']?.toDouble(),
    );
  }
}

@HiveType(typeId: 25)
enum AIMessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  suggestion,
  @HiveField(2)
  reminder,
  @HiveField(3)
  insight,
  @HiveField(4)
  motivational,
  @HiveField(5)
  warning,
  @HiveField(6)
  celebration,
}

@HiveType(typeId: 26)
class AIPersonalityProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  PersonalityType personalityType;

  @HiveField(3)
  Map<String, double> traits; // خصائص الشخصية (انطوائي/اجتماعي، منظم/مرن، إلخ)

  @HiveField(4)
  List<String> preferredMotivationMethods;

  @HiveField(5)
  List<String> interests;

  @HiveField(6)
  String communicationStyle;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime lastUpdated;

  AIPersonalityProfile({
    required this.id,
    required this.name,
    required this.personalityType,
    required this.traits,
    required this.preferredMotivationMethods,
    required this.interests,
    required this.communicationStyle,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'personalityType': personalityType.index,
      'traits': traits,
      'preferredMotivationMethods': preferredMotivationMethods,
      'interests': interests,
      'communicationStyle': communicationStyle,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory AIPersonalityProfile.fromMap(Map<String, dynamic> map) {
    return AIPersonalityProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      personalityType: PersonalityType.values[map['personalityType'] ?? 0],
      traits: Map<String, double>.from(map['traits'] ?? {}),
      preferredMotivationMethods: List<String>.from(
        map['preferredMotivationMethods'] ?? [],
      ),
      interests: List<String>.from(map['interests'] ?? []),
      communicationStyle: map['communicationStyle'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'] ?? 0),
    );
  }
}

@HiveType(typeId: 27)
enum PersonalityType {
  @HiveField(0)
  achiever, // المنجز
  @HiveField(1)
  explorer, // المستكشف
  @HiveField(2)
  socializer, // الاجتماعي
  @HiveField(3)
  competitor, // المنافس
  @HiveField(4)
  perfectionist, // الكمالي
  @HiveField(5)
  balanced, // المتوازن
}
