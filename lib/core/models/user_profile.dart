import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 25)
class UserProfile extends HiveObject {

  UserProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    this.fitnessLevel = 'beginner',
    this.goals = const [],
    this.restrictions = const [],
    this.preferredExercises = const [],
    this.availableEquipment = const ['bodyweight'],
    required this.createdAt,
    this.updatedAt,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final String gender; // 'male', 'female', 'other'

  @HiveField(4)
  final double height; // in cm

  @HiveField(5)
  final double weight; // in kg

  @HiveField(6)
  final String fitnessLevel; // 'beginner', 'intermediate', 'advanced'

  @HiveField(7)
  final List<String> goals;

  @HiveField(8)
  final List<String> restrictions;

  @HiveField(9)
  final List<String> preferredExercises;

  @HiveField(10)
  final List<String> availableEquipment;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? goals,
    List<String>? restrictions,
    List<String>? preferredExercises,
    List<String>? availableEquipment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goals: goals ?? this.goals,
      restrictions: restrictions ?? this.restrictions,
      preferredExercises: preferredExercises ?? this.preferredExercises,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
