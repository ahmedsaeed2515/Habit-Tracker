// lib/features/daily_habits/widgets/habit_dialog.dart
// Dialog لإضافة أو تعديل العادات اليومية

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/habit.dart';
import '../../../core/providers/habits_provider.dart';

/// Dialog لإضافة عادة يومية جديدة أو تعديل عادة موجودة
class HabitDialog extends ConsumerStatefulWidget {

  const HabitDialog({super.key, this.habit});
  /// العادة المراد تعديلها (null للإضافة الجديدة)
  final Habit? habit;

  @override
  ConsumerState<HabitDialog> createState() => _HabitDialogState();
}

class _HabitDialogState extends ConsumerState<HabitDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetValueController;
  late final TextEditingController _unitController;

  HabitType _selectedType = HabitType.boolean;
  String _selectedIcon = '⭐';

  /// قائمة الأيقونات المتاحة
  final List<String> _availableIcons = [
    '⭐',
    '💪',
    '🏃',
    '📚',
    '💡',
    '🎯',
    '⏰',
    '🌱',
    '🏆',
    '💎',
    '🔥',
    '⚡',
    '🌟',
    '🎨',
    '🎵',
    '💻',
    '☕',
    '🧘',
    '🚀',
    '🎪',
    '🌈',
    '🎈',
    '🎭',
    '🎲',
  ];

  /// قائمة العادات الافتراضية
  final List<Map<String, dynamic>> _defaultHabits = [
    {
      'name': 'شرب الماء',
      'icon': '💧',
      'type': HabitType.numeric,
      'target': 8,
      'unit': 'أكواب',
    },
    {
      'name': 'قراءة الكتب',
      'icon': '📚',
      'type': HabitType.duration,
      'target': 30,
      'unit': 'دقيقة',
    },
    {
      'name': 'التمرين الرياضي',
      'icon': '💪',
      'type': HabitType.boolean,
      'target': 1,
      'unit': '',
    },
    {
      'name': 'التأمل',
      'icon': '🧘',
      'type': HabitType.duration,
      'target': 15,
      'unit': 'دقيقة',
    },
    {
      'name': 'النوم مبكراً',
      'icon': '😴',
      'type': HabitType.boolean,
      'target': 1,
      'unit': '',
    },
    {
      'name': 'تناول الفواكه',
      'icon': '🍎',
      'type': HabitType.numeric,
      'target': 3,
      'unit': 'حبات',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  /// تهيئة المتحكمات بالبيانات الموجودة أو القيم الافتراضية
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.habit?.description ?? '',
    );
    _targetValueController = TextEditingController(
      text: widget.habit?.targetValue.toString() ?? '1',
    );
    _unitController = TextEditingController(text: widget.habit?.unit ?? '');

    if (widget.habit != null) {
      _selectedType = widget.habit!.type;
      _selectedIcon = widget.habit!.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return AlertDialog(
      title: Text(isEditing ? 'تعديل العادة' : 'إضافة عادة جديدة'),
      content: _buildDialogContent(isEditing),
      actions: _buildDialogActions(isEditing),
    );
  }

  /// بناء محتوى الـ Dialog
  Widget _buildDialogContent(bool isEditing) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isEditing) _buildQuickHabitSelector(),
            _buildNameField(),
            const const SizedBox(height: 16),
            _buildDescriptionField(),
            const const SizedBox(height: 16),
            _buildIconSelector(),
            const const SizedBox(height: 16),
            _buildHabitTypeSelector(),
            const const SizedBox(height: 16),
            _buildTargetAndUnitFields(),
          ],
        ),
      ),
    );
  }

  /// بناء محدد العادات السريعة
  Widget _buildQuickHabitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر عادة سريعة:'),
        const const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _defaultHabits.map((habit) {
            return ActionChip(
              avatar: Text(habit['icon']),
              label: Text(habit['name']),
              onPressed: () {
                _nameController.text = habit['name'];
                _selectedIcon = habit['icon'];
                _selectedType = habit['type'];
                _targetValueController.text = habit['target'].toString();
                _unitController.text = habit['unit'];
                setState(() {});
              },
            );
          }).toList(),
        ),
        const const SizedBox(height: 16),
        const Text('أو اكتب عادة مخصصة:'),
        const const SizedBox(height: 8),
      ],
    );
  }

  /// حقل اسم العادة
  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'اسم العادة',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.label),
      ),
    );
  }

  /// حقل وصف العادة
  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'وصف العادة (اختياري)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
    );
  }

  /// محدد الأيقونة
  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر أيقونة:'),
        const const SizedBox(height: 8),
        Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _availableIcons.length,
            itemBuilder: (context, index) {
              final icon = _availableIcons[index];
              final isSelected = icon == _selectedIcon;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withValues(alpha: 0.3) : null,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// محدد نوع العادة
  Widget _buildHabitTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('نوع العادة:'),
        const const SizedBox(height: 8),
        SegmentedButton<HabitType>(
          segments: const [
            ButtonSegment(
              value: HabitType.boolean,
              label: Text('نعم/لا'),
              icon: Icon(Icons.check_circle),
            ),
            ButtonSegment(
              value: HabitType.numeric,
              label: Text('رقمية'),
              icon: Icon(Icons.numbers),
            ),
            ButtonSegment(
              value: HabitType.duration,
              label: Text('مدة'),
              icon: Icon(Icons.timer),
            ),
          ],
          selected: {_selectedType},
          onSelectionChanged: (Set<HabitType> newSelection) {
            setState(() {
              _selectedType = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  /// حقول الهدف والوحدة
  Widget _buildTargetAndUnitFields() {
    if (_selectedType == HabitType.boolean) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _targetValueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الهدف',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.flag),
            ),
          ),
        ),
        const const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: TextField(
            controller: _unitController,
            decoration: InputDecoration(
              labelText: 'الوحدة',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.straighten),
              hintText: _selectedType == HabitType.duration ? 'دقيقة' : 'مرات',
            ),
          ),
        ),
      ],
    );
  }

  /// بناء أزرار الـ Dialog
  List<Widget> _buildDialogActions(bool isEditing) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('إلغاء'),
      ),
      ElevatedButton(
        onPressed: _canSave() ? _saveHabit : null,
        child: Text(isEditing ? 'حفظ' : 'إضافة'),
      ),
    ];
  }

  /// التحقق من إمكانية الحفظ
  bool _canSave() {
    return _nameController.text.isNotEmpty;
  }

  /// حفظ العادة
  void _saveHabit() {
    final habit = Habit(
      id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      icon: _selectedIcon,
      type: _selectedType,
      targetValue: int.tryParse(_targetValueController.text) ?? 1,
      unit: _unitController.text,
      entries: widget.habit?.entries ?? [],
      createdAt: widget.habit?.createdAt ?? DateTime.now(),
      isActive: widget.habit?.isActive ?? true,
      currentStreak: widget.habit?.currentStreak ?? 0,
      longestStreak: widget.habit?.longestStreak ?? 0,
    );

    if (widget.habit == null) {
      // إضافة عادة جديدة
      ref.read(habitsProvider.notifier).addHabit(habit);
    } else {
      // تحديث عادة موجودة
      ref.read(habitsProvider.notifier).updateHabit(habit);
    }

    Navigator.of(context).pop();
  }
}
