// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmartHabitAdapter extends TypeAdapter<SmartHabit> {
  @override
  final int typeId = 157;

  @override
  SmartHabit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartHabit(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      category: fields[4] as SmartHabitCategory,
      difficultyLevel: fields[5] as int,
      triggers: (fields[6] as List).cast<SmartTrigger>(),
      rewards: (fields[7] as List).cast<SmartReward>(),
      schedule: fields[8] as AdaptiveSchedule,
      personalization: fields[9] as HabitPersonalization,
      insights: fields[10] as AIInsights,
      prediction: fields[11] as ProgressPrediction,
      smartReminders: (fields[12] as List).cast<SmartReminder>(),
      contextualData: fields[13] as ContextualData,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
      isAIGenerated: fields[16] as bool,
      successProbability: fields[17] as double,
      aiMetadata: (fields[18] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SmartHabit obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.difficultyLevel)
      ..writeByte(6)
      ..write(obj.triggers)
      ..writeByte(7)
      ..write(obj.rewards)
      ..writeByte(8)
      ..write(obj.schedule)
      ..writeByte(9)
      ..write(obj.personalization)
      ..writeByte(10)
      ..write(obj.insights)
      ..writeByte(11)
      ..write(obj.prediction)
      ..writeByte(12)
      ..write(obj.smartReminders)
      ..writeByte(13)
      ..write(obj.contextualData)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.isAIGenerated)
      ..writeByte(17)
      ..write(obj.successProbability)
      ..writeByte(18)
      ..write(obj.aiMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartHabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartTriggerAdapter extends TypeAdapter<SmartTrigger> {
  @override
  final int typeId = 159;

  @override
  SmartTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartTrigger(
      id: fields[0] as String,
      type: fields[1] as TriggerType,
      description: fields[2] as String,
      conditions: (fields[3] as Map).cast<String, dynamic>(),
      effectiveness: fields[4] as double,
      isActive: fields[5] as bool,
      lastTriggered: fields[6] as DateTime,
      triggerCount: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SmartTrigger obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.conditions)
      ..writeByte(4)
      ..write(obj.effectiveness)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.lastTriggered)
      ..writeByte(7)
      ..write(obj.triggerCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartRewardAdapter extends TypeAdapter<SmartReward> {
  @override
  final int typeId = 161;

  @override
  SmartReward read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartReward(
      id: fields[0] as String,
      type: fields[1] as RewardType,
      title: fields[2] as String,
      description: fields[3] as String,
      value: fields[4] as int,
      criteria: (fields[5] as Map).cast<String, dynamic>(),
      isUnlocked: fields[6] as bool,
      unlockedAt: fields[7] as DateTime?,
      motivationImpact: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SmartReward obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.value)
      ..writeByte(5)
      ..write(obj.criteria)
      ..writeByte(6)
      ..write(obj.isUnlocked)
      ..writeByte(7)
      ..write(obj.unlockedAt)
      ..writeByte(8)
      ..write(obj.motivationImpact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartRewardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdaptiveScheduleAdapter extends TypeAdapter<AdaptiveSchedule> {
  @override
  final int typeId = 163;

  @override
  AdaptiveSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdaptiveSchedule(
      habitId: fields[0] as String,
      currentPattern: fields[1] as SchedulePattern,
      optimalTimeSlots: (fields[2] as List).cast<TimeSlot>(),
      triedPatterns: (fields[3] as List).cast<SchedulePattern>(),
      flexibility: fields[4] as double,
      weekdayPreferences: (fields[5] as Map).cast<int, double>(),
      adjustments: (fields[6] as List).cast<ScheduleAdjustment>(),
      lastAdaptation: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AdaptiveSchedule obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.habitId)
      ..writeByte(1)
      ..write(obj.currentPattern)
      ..writeByte(2)
      ..write(obj.optimalTimeSlots)
      ..writeByte(3)
      ..write(obj.triedPatterns)
      ..writeByte(4)
      ..write(obj.flexibility)
      ..writeByte(5)
      ..write(obj.weekdayPreferences)
      ..writeByte(6)
      ..write(obj.adjustments)
      ..writeByte(7)
      ..write(obj.lastAdaptation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchedulePatternAdapter extends TypeAdapter<SchedulePattern> {
  @override
  final int typeId = 164;

  @override
  SchedulePattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchedulePattern(
      type: fields[0] as PatternType,
      frequency: fields[1] as int,
      interval: fields[2] as Duration,
      daysOfWeek: (fields[3] as List).cast<int>(),
      timesOfDay: (fields[4] as List).cast<TimeOfDay>(),
      isFlexible: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SchedulePattern obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.interval)
      ..writeByte(3)
      ..write(obj.daysOfWeek)
      ..writeByte(4)
      ..write(obj.timesOfDay)
      ..writeByte(5)
      ..write(obj.isFlexible);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchedulePatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeSlotAdapter extends TypeAdapter<TimeSlot> {
  @override
  final int typeId = 166;

  @override
  TimeSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeSlot(
      startTime: fields[0] as TimeOfDay,
      endTime: fields[1] as TimeOfDay,
      dayOfWeek: fields[2] as int,
      successRate: fields[3] as double,
      completionCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeSlot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.dayOfWeek)
      ..writeByte(3)
      ..write(obj.successRate)
      ..writeByte(4)
      ..write(obj.completionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 167;

  @override
  TimeOfDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeOfDay(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScheduleAdjustmentAdapter extends TypeAdapter<ScheduleAdjustment> {
  @override
  final int typeId = 168;

  @override
  ScheduleAdjustment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleAdjustment(
      timestamp: fields[0] as DateTime,
      type: fields[1] as AdjustmentType,
      reason: fields[2] as String,
      oldValues: (fields[3] as Map).cast<String, dynamic>(),
      newValues: (fields[4] as Map).cast<String, dynamic>(),
      impactScore: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleAdjustment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.oldValues)
      ..writeByte(4)
      ..write(obj.newValues)
      ..writeByte(5)
      ..write(obj.impactScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdjustmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitPersonalizationAdapter extends TypeAdapter<HabitPersonalization> {
  @override
  final int typeId = 170;

  @override
  HabitPersonalization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitPersonalization(
      personalityProfile: fields[0] as PersonalityProfile,
      motivationFactors: (fields[1] as List).cast<MotivationFactor>(),
      learningStyle: fields[2] as LearningStyle,
      preferences: (fields[3] as List).cast<Preference>(),
      successFactors: (fields[4] as Map).cast<String, double>(),
      personalChallenges: (fields[5] as List).cast<Challenge>(),
    );
  }

  @override
  void write(BinaryWriter writer, HabitPersonalization obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.personalityProfile)
      ..writeByte(1)
      ..write(obj.motivationFactors)
      ..writeByte(2)
      ..write(obj.learningStyle)
      ..writeByte(3)
      ..write(obj.preferences)
      ..writeByte(4)
      ..write(obj.successFactors)
      ..writeByte(5)
      ..write(obj.personalChallenges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitPersonalizationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalityProfileAdapter extends TypeAdapter<PersonalityProfile> {
  @override
  final int typeId = 171;

  @override
  PersonalityProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalityProfile(
      type: fields[0] as PersonalityType,
      traits: (fields[1] as Map).cast<String, double>(),
      strengths: (fields[2] as List).cast<String>(),
      weaknesses: (fields[3] as List).cast<String>(),
      lastAssessment: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalityProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.traits)
      ..writeByte(2)
      ..write(obj.strengths)
      ..writeByte(3)
      ..write(obj.weaknesses)
      ..writeByte(4)
      ..write(obj.lastAssessment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalityProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MotivationFactorAdapter extends TypeAdapter<MotivationFactor> {
  @override
  final int typeId = 173;

  @override
  MotivationFactor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MotivationFactor(
      name: fields[0] as String,
      type: fields[1] as MotivationType,
      impact: fields[2] as double,
      isActive: fields[3] as bool,
      parameters: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MotivationFactor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.impact)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.parameters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotivationFactorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LearningStyleAdapter extends TypeAdapter<LearningStyle> {
  @override
  final int typeId = 175;

  @override
  LearningStyle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningStyle(
      primaryType: fields[0] as LearningType,
      secondaryTypes: (fields[1] as List).cast<LearningType>(),
      adaptabilityScore: fields[2] as double,
      effectivenessScores: (fields[3] as Map).cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, LearningStyle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.primaryType)
      ..writeByte(1)
      ..write(obj.secondaryTypes)
      ..writeByte(2)
      ..write(obj.adaptabilityScore)
      ..writeByte(3)
      ..write(obj.effectivenessScores);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PreferenceAdapter extends TypeAdapter<Preference> {
  @override
  final int typeId = 177;

  @override
  Preference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preference(
      key: fields[0] as String,
      value: fields[1] as dynamic,
      type: fields[2] as PreferenceType,
      importance: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Preference obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.importance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 179;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      name: fields[0] as String,
      type: fields[1] as ChallengeType,
      description: fields[2] as String,
      severity: fields[3] as double,
      strategies: (fields[4] as List).cast<String>(),
      isActive: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.severity)
      ..writeByte(4)
      ..write(obj.strategies)
      ..writeByte(5)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIInsightsAdapter extends TypeAdapter<AIInsights> {
  @override
  final int typeId = 181;

  @override
  AIInsights read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AIInsights(
      behaviorInsights: (fields[0] as List).cast<Insight>(),
      performanceInsights: (fields[1] as List).cast<Insight>(),
      patternInsights: (fields[2] as List).cast<Insight>(),
      recommendations: (fields[3] as List).cast<Recommendation>(),
      lastAnalysis: fields[4] as DateTime,
      confidenceScore: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AIInsights obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.behaviorInsights)
      ..writeByte(1)
      ..write(obj.performanceInsights)
      ..writeByte(2)
      ..write(obj.patternInsights)
      ..writeByte(3)
      ..write(obj.recommendations)
      ..writeByte(4)
      ..write(obj.lastAnalysis)
      ..writeByte(5)
      ..write(obj.confidenceScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIInsightsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightAdapter extends TypeAdapter<Insight> {
  @override
  final int typeId = 182;

  @override
  Insight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Insight(
      id: fields[0] as String,
      category: fields[1] as InsightCategory,
      title: fields[2] as String,
      description: fields[3] as String,
      severity: fields[4] as InsightSeverity,
      confidence: fields[5] as double,
      data: (fields[6] as Map).cast<String, dynamic>(),
      generatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Insight obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.severity)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.data)
      ..writeByte(7)
      ..write(obj.generatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationAdapter extends TypeAdapter<Recommendation> {
  @override
  final int typeId = 185;

  @override
  Recommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recommendation(
      id: fields[0] as String,
      type: fields[1] as RecommendationType,
      title: fields[2] as String,
      description: fields[3] as String,
      actionSteps: (fields[4] as List).cast<String>(),
      expectedImpact: fields[5] as double,
      priority: fields[6] as int,
      isImplemented: fields[7] as bool,
      generatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Recommendation obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.actionSteps)
      ..writeByte(5)
      ..write(obj.expectedImpact)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.isImplemented)
      ..writeByte(8)
      ..write(obj.generatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgressPredictionAdapter extends TypeAdapter<ProgressPrediction> {
  @override
  final int typeId = 187;

  @override
  ProgressPrediction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressPrediction(
      shortTermSuccessRate: fields[0] as double,
      mediumTermSuccessRate: fields[1] as double,
      longTermSuccessRate: fields[2] as double,
      predictedMilestones: (fields[3] as List).cast<Milestone>(),
      riskFactors: (fields[4] as List).cast<RiskFactor>(),
      lastUpdate: fields[5] as DateTime,
      modelAccuracy: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressPrediction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.shortTermSuccessRate)
      ..writeByte(1)
      ..write(obj.mediumTermSuccessRate)
      ..writeByte(2)
      ..write(obj.longTermSuccessRate)
      ..writeByte(3)
      ..write(obj.predictedMilestones)
      ..writeByte(4)
      ..write(obj.riskFactors)
      ..writeByte(5)
      ..write(obj.lastUpdate)
      ..writeByte(6)
      ..write(obj.modelAccuracy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressPredictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MilestoneAdapter extends TypeAdapter<Milestone> {
  @override
  final int typeId = 188;

  @override
  Milestone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Milestone(
      name: fields[0] as String,
      predictedDate: fields[1] as DateTime,
      probability: fields[2] as double,
      description: fields[3] as String,
      isAchieved: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Milestone obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.predictedDate)
      ..writeByte(2)
      ..write(obj.probability)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isAchieved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RiskFactorAdapter extends TypeAdapter<RiskFactor> {
  @override
  final int typeId = 189;

  @override
  RiskFactor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiskFactor(
      name: fields[0] as String,
      level: fields[1] as RiskLevel,
      probability: fields[2] as double,
      description: fields[3] as String,
      mitigationStrategies: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RiskFactor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.probability)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.mitigationStrategies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiskFactorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartReminderAdapter extends TypeAdapter<SmartReminder> {
  @override
  final int typeId = 191;

  @override
  SmartReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartReminder(
      id: fields[0] as String,
      type: fields[1] as ReminderType,
      message: fields[2] as String,
      conditions: (fields[3] as Map).cast<String, dynamic>(),
      effectiveness: fields[4] as double,
      isActive: fields[5] as bool,
      lastSent: fields[6] as DateTime,
      sentCount: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SmartReminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.conditions)
      ..writeByte(4)
      ..write(obj.effectiveness)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.lastSent)
      ..writeByte(7)
      ..write(obj.sentCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContextualDataAdapter extends TypeAdapter<ContextualData> {
  @override
  final int typeId = 193;

  @override
  ContextualData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContextualData(
      environmentalFactors: (fields[0] as Map).cast<String, dynamic>(),
      socialContext: (fields[1] as Map).cast<String, dynamic>(),
      temporalContext: (fields[2] as Map).cast<String, dynamic>(),
      personalContext: (fields[3] as Map).cast<String, dynamic>(),
      lastUpdate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ContextualData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.environmentalFactors)
      ..writeByte(1)
      ..write(obj.socialContext)
      ..writeByte(2)
      ..write(obj.temporalContext)
      ..writeByte(3)
      ..write(obj.personalContext)
      ..writeByte(4)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextualDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartHabitCategoryAdapter extends TypeAdapter<SmartHabitCategory> {
  @override
  final int typeId = 158;

  @override
  SmartHabitCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SmartHabitCategory.health;
      case 1:
        return SmartHabitCategory.fitness;
      case 2:
        return SmartHabitCategory.productivity;
      case 3:
        return SmartHabitCategory.learning;
      case 4:
        return SmartHabitCategory.mindfulness;
      case 5:
        return SmartHabitCategory.social;
      case 6:
        return SmartHabitCategory.creative;
      case 7:
        return SmartHabitCategory.financial;
      case 8:
        return SmartHabitCategory.environmental;
      case 9:
        return SmartHabitCategory.personal;
      default:
        return SmartHabitCategory.health;
    }
  }

  @override
  void write(BinaryWriter writer, SmartHabitCategory obj) {
    switch (obj) {
      case SmartHabitCategory.health:
        writer.writeByte(0);
        break;
      case SmartHabitCategory.fitness:
        writer.writeByte(1);
        break;
      case SmartHabitCategory.productivity:
        writer.writeByte(2);
        break;
      case SmartHabitCategory.learning:
        writer.writeByte(3);
        break;
      case SmartHabitCategory.mindfulness:
        writer.writeByte(4);
        break;
      case SmartHabitCategory.social:
        writer.writeByte(5);
        break;
      case SmartHabitCategory.creative:
        writer.writeByte(6);
        break;
      case SmartHabitCategory.financial:
        writer.writeByte(7);
        break;
      case SmartHabitCategory.environmental:
        writer.writeByte(8);
        break;
      case SmartHabitCategory.personal:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartHabitCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TriggerTypeAdapter extends TypeAdapter<TriggerType> {
  @override
  final int typeId = 160;

  @override
  TriggerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TriggerType.time;
      case 1:
        return TriggerType.location;
      case 2:
        return TriggerType.activity;
      case 3:
        return TriggerType.mood;
      case 4:
        return TriggerType.weather;
      case 5:
        return TriggerType.social;
      case 6:
        return TriggerType.calendar;
      case 7:
        return TriggerType.completion;
      case 8:
        return TriggerType.streak;
      case 9:
        return TriggerType.custom;
      default:
        return TriggerType.time;
    }
  }

  @override
  void write(BinaryWriter writer, TriggerType obj) {
    switch (obj) {
      case TriggerType.time:
        writer.writeByte(0);
        break;
      case TriggerType.location:
        writer.writeByte(1);
        break;
      case TriggerType.activity:
        writer.writeByte(2);
        break;
      case TriggerType.mood:
        writer.writeByte(3);
        break;
      case TriggerType.weather:
        writer.writeByte(4);
        break;
      case TriggerType.social:
        writer.writeByte(5);
        break;
      case TriggerType.calendar:
        writer.writeByte(6);
        break;
      case TriggerType.completion:
        writer.writeByte(7);
        break;
      case TriggerType.streak:
        writer.writeByte(8);
        break;
      case TriggerType.custom:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriggerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RewardTypeAdapter extends TypeAdapter<RewardType> {
  @override
  final int typeId = 162;

  @override
  RewardType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RewardType.points;
      case 1:
        return RewardType.badge;
      case 2:
        return RewardType.achievement;
      case 3:
        return RewardType.privilege;
      case 4:
        return RewardType.content;
      case 5:
        return RewardType.social;
      case 6:
        return RewardType.virtual;
      case 7:
        return RewardType.real;
      default:
        return RewardType.points;
    }
  }

  @override
  void write(BinaryWriter writer, RewardType obj) {
    switch (obj) {
      case RewardType.points:
        writer.writeByte(0);
        break;
      case RewardType.badge:
        writer.writeByte(1);
        break;
      case RewardType.achievement:
        writer.writeByte(2);
        break;
      case RewardType.privilege:
        writer.writeByte(3);
        break;
      case RewardType.content:
        writer.writeByte(4);
        break;
      case RewardType.social:
        writer.writeByte(5);
        break;
      case RewardType.virtual:
        writer.writeByte(6);
        break;
      case RewardType.real:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PatternTypeAdapter extends TypeAdapter<PatternType> {
  @override
  final int typeId = 165;

  @override
  PatternType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PatternType.daily;
      case 1:
        return PatternType.weekly;
      case 2:
        return PatternType.biweekly;
      case 3:
        return PatternType.monthly;
      case 4:
        return PatternType.custom;
      case 5:
        return PatternType.adaptive;
      default:
        return PatternType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, PatternType obj) {
    switch (obj) {
      case PatternType.daily:
        writer.writeByte(0);
        break;
      case PatternType.weekly:
        writer.writeByte(1);
        break;
      case PatternType.biweekly:
        writer.writeByte(2);
        break;
      case PatternType.monthly:
        writer.writeByte(3);
        break;
      case PatternType.custom:
        writer.writeByte(4);
        break;
      case PatternType.adaptive:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdjustmentTypeAdapter extends TypeAdapter<AdjustmentType> {
  @override
  final int typeId = 169;

  @override
  AdjustmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AdjustmentType.timeShift;
      case 1:
        return AdjustmentType.frequencyChange;
      case 2:
        return AdjustmentType.dayChange;
      case 3:
        return AdjustmentType.difficultyAdjust;
      case 4:
        return AdjustmentType.contextUpdate;
      default:
        return AdjustmentType.timeShift;
    }
  }

  @override
  void write(BinaryWriter writer, AdjustmentType obj) {
    switch (obj) {
      case AdjustmentType.timeShift:
        writer.writeByte(0);
        break;
      case AdjustmentType.frequencyChange:
        writer.writeByte(1);
        break;
      case AdjustmentType.dayChange:
        writer.writeByte(2);
        break;
      case AdjustmentType.difficultyAdjust:
        writer.writeByte(3);
        break;
      case AdjustmentType.contextUpdate:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdjustmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalityTypeAdapter extends TypeAdapter<PersonalityType> {
  @override
  final int typeId = 172;

  @override
  PersonalityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PersonalityType.achiever;
      case 1:
        return PersonalityType.socializer;
      case 2:
        return PersonalityType.explorer;
      case 3:
        return PersonalityType.killer;
      case 4:
        return PersonalityType.analytical;
      case 5:
        return PersonalityType.creative;
      case 6:
        return PersonalityType.practical;
      case 7:
        return PersonalityType.contemplative;
      default:
        return PersonalityType.achiever;
    }
  }

  @override
  void write(BinaryWriter writer, PersonalityType obj) {
    switch (obj) {
      case PersonalityType.achiever:
        writer.writeByte(0);
        break;
      case PersonalityType.socializer:
        writer.writeByte(1);
        break;
      case PersonalityType.explorer:
        writer.writeByte(2);
        break;
      case PersonalityType.killer:
        writer.writeByte(3);
        break;
      case PersonalityType.analytical:
        writer.writeByte(4);
        break;
      case PersonalityType.creative:
        writer.writeByte(5);
        break;
      case PersonalityType.practical:
        writer.writeByte(6);
        break;
      case PersonalityType.contemplative:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MotivationTypeAdapter extends TypeAdapter<MotivationType> {
  @override
  final int typeId = 174;

  @override
  MotivationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MotivationType.intrinsic;
      case 1:
        return MotivationType.extrinsic;
      case 2:
        return MotivationType.social;
      case 3:
        return MotivationType.competitive;
      case 4:
        return MotivationType.achievement;
      case 5:
        return MotivationType.progress;
      case 6:
        return MotivationType.recognition;
      case 7:
        return MotivationType.autonomy;
      default:
        return MotivationType.intrinsic;
    }
  }

  @override
  void write(BinaryWriter writer, MotivationType obj) {
    switch (obj) {
      case MotivationType.intrinsic:
        writer.writeByte(0);
        break;
      case MotivationType.extrinsic:
        writer.writeByte(1);
        break;
      case MotivationType.social:
        writer.writeByte(2);
        break;
      case MotivationType.competitive:
        writer.writeByte(3);
        break;
      case MotivationType.achievement:
        writer.writeByte(4);
        break;
      case MotivationType.progress:
        writer.writeByte(5);
        break;
      case MotivationType.recognition:
        writer.writeByte(6);
        break;
      case MotivationType.autonomy:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotivationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LearningTypeAdapter extends TypeAdapter<LearningType> {
  @override
  final int typeId = 176;

  @override
  LearningType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LearningType.visual;
      case 1:
        return LearningType.auditory;
      case 2:
        return LearningType.kinesthetic;
      case 3:
        return LearningType.reading;
      case 4:
        return LearningType.social;
      case 5:
        return LearningType.solitary;
      case 6:
        return LearningType.logical;
      case 7:
        return LearningType.verbal;
      default:
        return LearningType.visual;
    }
  }

  @override
  void write(BinaryWriter writer, LearningType obj) {
    switch (obj) {
      case LearningType.visual:
        writer.writeByte(0);
        break;
      case LearningType.auditory:
        writer.writeByte(1);
        break;
      case LearningType.kinesthetic:
        writer.writeByte(2);
        break;
      case LearningType.reading:
        writer.writeByte(3);
        break;
      case LearningType.social:
        writer.writeByte(4);
        break;
      case LearningType.solitary:
        writer.writeByte(5);
        break;
      case LearningType.logical:
        writer.writeByte(6);
        break;
      case LearningType.verbal:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PreferenceTypeAdapter extends TypeAdapter<PreferenceType> {
  @override
  final int typeId = 178;

  @override
  PreferenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PreferenceType.time;
      case 1:
        return PreferenceType.frequency;
      case 2:
        return PreferenceType.duration;
      case 3:
        return PreferenceType.difficulty;
      case 4:
        return PreferenceType.environment;
      case 5:
        return PreferenceType.social;
      case 6:
        return PreferenceType.reward;
      case 7:
        return PreferenceType.reminder;
      default:
        return PreferenceType.time;
    }
  }

  @override
  void write(BinaryWriter writer, PreferenceType obj) {
    switch (obj) {
      case PreferenceType.time:
        writer.writeByte(0);
        break;
      case PreferenceType.frequency:
        writer.writeByte(1);
        break;
      case PreferenceType.duration:
        writer.writeByte(2);
        break;
      case PreferenceType.difficulty:
        writer.writeByte(3);
        break;
      case PreferenceType.environment:
        writer.writeByte(4);
        break;
      case PreferenceType.social:
        writer.writeByte(5);
        break;
      case PreferenceType.reward:
        writer.writeByte(6);
        break;
      case PreferenceType.reminder:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 180;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.motivation;
      case 1:
        return ChallengeType.time;
      case 2:
        return ChallengeType.consistency;
      case 3:
        return ChallengeType.environment;
      case 4:
        return ChallengeType.social;
      case 5:
        return ChallengeType.physical;
      case 6:
        return ChallengeType.mental;
      case 7:
        return ChallengeType.emotional;
      default:
        return ChallengeType.motivation;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.motivation:
        writer.writeByte(0);
        break;
      case ChallengeType.time:
        writer.writeByte(1);
        break;
      case ChallengeType.consistency:
        writer.writeByte(2);
        break;
      case ChallengeType.environment:
        writer.writeByte(3);
        break;
      case ChallengeType.social:
        writer.writeByte(4);
        break;
      case ChallengeType.physical:
        writer.writeByte(5);
        break;
      case ChallengeType.mental:
        writer.writeByte(6);
        break;
      case ChallengeType.emotional:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightCategoryAdapter extends TypeAdapter<InsightCategory> {
  @override
  final int typeId = 183;

  @override
  InsightCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightCategory.behavior;
      case 1:
        return InsightCategory.performance;
      case 2:
        return InsightCategory.pattern;
      case 3:
        return InsightCategory.prediction;
      case 4:
        return InsightCategory.optimization;
      default:
        return InsightCategory.behavior;
    }
  }

  @override
  void write(BinaryWriter writer, InsightCategory obj) {
    switch (obj) {
      case InsightCategory.behavior:
        writer.writeByte(0);
        break;
      case InsightCategory.performance:
        writer.writeByte(1);
        break;
      case InsightCategory.pattern:
        writer.writeByte(2);
        break;
      case InsightCategory.prediction:
        writer.writeByte(3);
        break;
      case InsightCategory.optimization:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightSeverityAdapter extends TypeAdapter<InsightSeverity> {
  @override
  final int typeId = 184;

  @override
  InsightSeverity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightSeverity.low;
      case 1:
        return InsightSeverity.medium;
      case 2:
        return InsightSeverity.high;
      case 3:
        return InsightSeverity.critical;
      default:
        return InsightSeverity.low;
    }
  }

  @override
  void write(BinaryWriter writer, InsightSeverity obj) {
    switch (obj) {
      case InsightSeverity.low:
        writer.writeByte(0);
        break;
      case InsightSeverity.medium:
        writer.writeByte(1);
        break;
      case InsightSeverity.high:
        writer.writeByte(2);
        break;
      case InsightSeverity.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightSeverityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationTypeAdapter extends TypeAdapter<RecommendationType> {
  @override
  final int typeId = 186;

  @override
  RecommendationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecommendationType.scheduling;
      case 1:
        return RecommendationType.difficulty;
      case 2:
        return RecommendationType.environment;
      case 3:
        return RecommendationType.motivation;
      case 4:
        return RecommendationType.social;
      case 5:
        return RecommendationType.health;
      case 6:
        return RecommendationType.productivity;
      case 7:
        return RecommendationType.learning;
      default:
        return RecommendationType.scheduling;
    }
  }

  @override
  void write(BinaryWriter writer, RecommendationType obj) {
    switch (obj) {
      case RecommendationType.scheduling:
        writer.writeByte(0);
        break;
      case RecommendationType.difficulty:
        writer.writeByte(1);
        break;
      case RecommendationType.environment:
        writer.writeByte(2);
        break;
      case RecommendationType.motivation:
        writer.writeByte(3);
        break;
      case RecommendationType.social:
        writer.writeByte(4);
        break;
      case RecommendationType.health:
        writer.writeByte(5);
        break;
      case RecommendationType.productivity:
        writer.writeByte(6);
        break;
      case RecommendationType.learning:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RiskLevelAdapter extends TypeAdapter<RiskLevel> {
  @override
  final int typeId = 190;

  @override
  RiskLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RiskLevel.low;
      case 1:
        return RiskLevel.medium;
      case 2:
        return RiskLevel.high;
      case 3:
        return RiskLevel.critical;
      default:
        return RiskLevel.low;
    }
  }

  @override
  void write(BinaryWriter writer, RiskLevel obj) {
    switch (obj) {
      case RiskLevel.low:
        writer.writeByte(0);
        break;
      case RiskLevel.medium:
        writer.writeByte(1);
        break;
      case RiskLevel.high:
        writer.writeByte(2);
        break;
      case RiskLevel.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiskLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 192;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.scheduled;
      case 1:
        return ReminderType.contextual;
      case 2:
        return ReminderType.adaptive;
      case 3:
        return ReminderType.motivational;
      case 4:
        return ReminderType.recovery;
      case 5:
        return ReminderType.celebration;
      case 6:
        return ReminderType.warning;
      case 7:
        return ReminderType.social;
      default:
        return ReminderType.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.scheduled:
        writer.writeByte(0);
        break;
      case ReminderType.contextual:
        writer.writeByte(1);
        break;
      case ReminderType.adaptive:
        writer.writeByte(2);
        break;
      case ReminderType.motivational:
        writer.writeByte(3);
        break;
      case ReminderType.recovery:
        writer.writeByte(4);
        break;
      case ReminderType.celebration:
        writer.writeByte(5);
        break;
      case ReminderType.warning:
        writer.writeByte(6);
        break;
      case ReminderType.social:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
