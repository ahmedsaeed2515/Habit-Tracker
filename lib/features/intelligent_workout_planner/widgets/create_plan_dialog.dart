import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/themes/app_theme.dart';
import '../providers/workout_planner_providers.dart';

/// حوار إنشاء خطة تمرين جديدة
class CreatePlanDialog extends ConsumerStatefulWidget {
  const CreatePlanDialog({super.key});

  @override
  ConsumerState<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends ConsumerState<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _goalsController = TextEditingController();
  final _restrictionsController = TextEditingController();
  final _preferredExercisesController = TextEditingController();

  String _fitnessLevel = 'intermediate';
  int _durationWeeks = 4;
  final List<String> _selectedEquipment = ['bodyweight'];
  final List<String> _selectedGoals = [];

  final List<String> _availableGoals = [
    'weight_loss',
    'muscle_gain',
    'endurance',
    'flexibility',
    'strength',
    'general_fitness',
  ];

  final List<String> _availableEquipment = [
    'bodyweight',
    'dumbbells',
    'barbell',
    'resistance_bands',
    'kettlebell',
    'pull_up_bar',
    'bench',
    'treadmill',
    'bike',
  ];

  @override
  void dispose() {
    _goalsController.dispose();
    _restrictionsController.dispose();
    _preferredExercisesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(workoutPlansProvider).isLoading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الحوار
                Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'إنشاء خطة تمرين ذكية',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'سوف يقوم الذكاء الاصطناعي بإنشاء خطة مخصصة لك',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // مستوى اللياقة البدنية
                Text(
                  'مستوى اللياقة البدنية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFitnessLevelSelector(),
                const SizedBox(height: 20),

                // الأهداف
                Text(
                  'الأهداف الرياضية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGoalsSelector(),
                const SizedBox(height: 20),

                // مدة البرنامج
                Text(
                  'مدة البرنامج (بالأسابيع)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDurationSelector(),
                const SizedBox(height: 20),

                // المعدات المتاحة
                Text(
                  'المعدات المتاحة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildEquipmentSelector(),
                const SizedBox(height: 20),

                // القيود والحساسية
                Text(
                  'القيود أو الحساسية (اختياري)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _restrictionsController,
                  decoration: InputDecoration(
                    hintText: 'مثال: إصابة في الكتف، حساسية من تمرين معين...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // أزرار الحوار
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isCreating
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: isCreating ? null : _createPlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isCreating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_fix_high, size: 18),
                                SizedBox(width: 8),
                                Text('إنشاء الخطة'),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessLevelSelector() {
    return Row(
      children: [
        _buildLevelButton('مبتدئ', 'beginner'),
        const SizedBox(width: 8),
        _buildLevelButton('متوسط', 'intermediate'),
        const SizedBox(width: 8),
        _buildLevelButton('متقدم', 'advanced'),
      ],
    );
  }

  Widget _buildLevelButton(String label, String value) {
    final isSelected = _fitnessLevel == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _fitnessLevel = value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableGoals.map((goal) {
        final isSelected = _selectedGoals.contains(goal);
        return FilterChip(
          label: Text(_getGoalDisplayName(goal)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedGoals.add(goal);
              } else {
                _selectedGoals.remove(goal);
              }
            });
          },
          backgroundColor: Colors.grey[100],
          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      children: [
        IconButton(
          onPressed: _durationWeeks > 1
              ? () => setState(() => _durationWeeks--)
              : null,
          icon: const Icon(Icons.remove),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_durationWeeks أسبوع${_durationWeeks > 1 ? '' : ''}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        IconButton(
          onPressed: _durationWeeks < 12
              ? () => setState(() => _durationWeeks++)
              : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildEquipmentSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableEquipment.map((equipment) {
        final isSelected = _selectedEquipment.contains(equipment);
        return FilterChip(
          label: Text(_getEquipmentDisplayName(equipment)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedEquipment.add(equipment);
              } else {
                _selectedEquipment.remove(equipment);
              }
            });
          },
          backgroundColor: Colors.grey[100],
          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }

  String _getGoalDisplayName(String goal) {
    final goalNames = {
      'weight_loss': 'فقدان الوزن',
      'muscle_gain': 'زيادة العضلات',
      'endurance': 'تحسين التحمل',
      'flexibility': 'زيادة المرونة',
      'strength': 'زيادة القوة',
      'general_fitness': 'اللياقة العامة',
    };
    return goalNames[goal] ?? goal;
  }

  String _getEquipmentDisplayName(String equipment) {
    final equipmentNames = {
      'bodyweight': 'الوزن الطبيعي',
      'dumbbells': 'الدمبل',
      'barbell': 'البار',
      'resistance_bands': 'أشرطة المقاومة',
      'kettlebell': 'الكيتل بيل',
      'pull_up_bar': 'حلقة الشد',
      'bench': 'المقعد',
      'treadmill': 'المشاية',
      'bike': 'الدراجة',
    };
    return equipmentNames[equipment] ?? equipment;
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار هدف رياضي واحد على الأقل'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final userProfileAsync = ref.read(userProfileProvider);
    final userProfile = userProfileAsync.value;

    if (userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إكمال ملف المستخدم أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final workoutPlansNotifier = ref.read(workoutPlansProvider.notifier);
      await workoutPlansNotifier.createPersonalizedPlan(
        userProfile: userProfile,
        goals: _selectedGoals,
        fitnessLevel: _fitnessLevel,
        durationWeeks: _durationWeeks,
        availableEquipment: _selectedEquipment,
        preferredExercises: _preferredExercisesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        restrictions: _restrictionsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الخطة بنجاح! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء الخطة: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
