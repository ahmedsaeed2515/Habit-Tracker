import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/simple_theming_models.dart';
import '../providers/simple_theming_providers.dart';

// Extension to add copyWith method to ColorPalette
extension ColorPaletteExtension on ColorPalette {
  ColorPalette copyWith({
    int? primary,
    int? onPrimary,
    int? secondary,
    int? onSecondary,
    int? tertiary,
    int? onTertiary,
    int? error,
    int? onError,
    int? surface,
    int? onSurface,
    int? onSurfaceVariant,
    int? outline,
    int? shadow,
    int? surfaceVariant,
    int? background,
    int? onBackground,
    int? success,
    int? warning,
    int? info,
  }) {
    return ColorPalette(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      shadow: shadow ?? this.shadow,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }
}

/// Widget للبطاقة المخصصة
class CustomCard extends StatelessWidget {
  
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );
  }
}

/// Widget لعرض قائمة الثيمات المتاحة
class ThemeList extends ConsumerWidget {

  const ThemeList({
    super.key,
    this.showCustomOnly = false,
    this.filterCategory,
  });
  final bool showCustomOnly;
  final ThemeCategory? filterCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<DynamicTheme>> themesAsync;
    
    if (showCustomOnly) {
      themesAsync = ref.watch(customThemesProvider);
    } else {
      themesAsync = ref.watch(availableThemesProvider);
    }

    return themesAsync.when(
      data: (themes) {
        List<DynamicTheme> filteredThemes = themes;
        
        if (filterCategory != null) {
          filteredThemes = themes.where((theme) => theme.category == filterCategory).toList();
        }

        if (filteredThemes.isEmpty) {
          return _buildEmptyState();
        }

        return _buildThemeGrid(filteredThemes);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('خطأ: $error')),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.palette_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'لا توجد ثيمات متاحة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإضافة ثيم جديد أو تغيير الفلتر',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeGrid(List<DynamicTheme> themes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        return ThemeCard(theme: themes[index]);
      },
    );
  }
}

/// Widget لعرض بطاقة ثيم واحد
class ThemeCard extends ConsumerWidget {

  const ThemeCard({
    super.key,
    required this.theme,
  });
  final DynamicTheme theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(currentThemeProvider);
    final isSelected = currentTheme.themeId == theme.id;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected 
          ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _selectTheme(ref),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // معاينة الألوان
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color(theme.lightColorPalette.primary).withValues(alpha: 0.8),
                      Color(theme.lightColorPalette.secondary).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          theme.category.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Positioned(
                        bottom: 8,
                        left: 8,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
              
              const const SizedBox(height: 12),
              
              // اسم الثيم
              Text(
                theme.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              
              const const SizedBox(height: 4),
              
              // وصف الثيم
              if (theme.description.isNotEmpty)
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              
              const Spacer(),
              
              // أزرار الإجراءات
              Row(
                children: [
                  if (theme.isCustom) ...[ 
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _editTheme(context, ref),
                        tooltip: 'تعديل',
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => _deleteTheme(context, ref),
                        tooltip: 'حذف',
                      ),
                    ),
                  ] else
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () => _duplicateTheme(context, ref),
                        tooltip: 'نسخ',
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTheme(WidgetRef ref) {
    ref.read(dynamicThemingServiceProvider).setTheme(theme.id);
  }

  void _editTheme(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemeEditorSheet(theme: theme),
    );
  }

  void _deleteTheme(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الثيم'),
        content: Text('هل أنت متأكد من حذف ثيم "${theme.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              ref.read(dynamicThemingServiceProvider).deleteTheme(theme.id);
              Navigator.of(context).pop();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _duplicateTheme(BuildContext context, WidgetRef ref) {
    final duplicatedTheme = theme.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${theme.name} - نسخة',
      isCustom: true,
    );
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ThemeEditorSheet(theme: duplicatedTheme),
    );
  }
}

/// Widget لعرض قائمة فئات الثيمات
class ThemeCategoryFilter extends ConsumerWidget {

  const ThemeCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });
  final ThemeCategory? selectedCategory;
  final ValueChanged<ThemeCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip(
            context,
            label: 'الكل',
            isSelected: selectedCategory == null,
            onTap: () => onCategoryChanged(null),
          ),
          const const SizedBox(width: 8),
          ...ThemeCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryChip(
                context,
                label: category.displayName,
                isSelected: selectedCategory == category,
                onTap: () => onCategoryChanged(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.transparent,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
    );
  }
}

/// Widget لإنشاء/تعديل الثيمات
class ThemeEditorSheet extends ConsumerStatefulWidget {

  const ThemeEditorSheet({
    super.key,
    this.theme,
  });
  final DynamicTheme? theme;

  @override
  ConsumerState<ThemeEditorSheet> createState() => _ThemeEditorSheetState();
}

class _ThemeEditorSheetState extends ConsumerState<ThemeEditorSheet> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late ThemeCategory _selectedCategory;
  late ColorPalette _lightPalette;
  late ColorPalette _darkPalette;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.theme?.name ?? '');
    _descriptionController = TextEditingController(text: widget.theme?.description ?? '');
    _selectedCategory = widget.theme?.category ?? ThemeCategory.custom;
    _lightPalette = widget.theme?.lightColorPalette ?? _createDefaultPalette();
    _darkPalette = widget.theme?.darkColorPalette ?? _createDefaultPalette();
  }

  ColorPalette _createDefaultPalette() {
    return ColorPalette(
      primary: Colors.blue.value,
      onPrimary: Colors.white.value,
      secondary: Colors.blueAccent.value,
      onSecondary: Colors.white.value,
      tertiary: Colors.lightBlue.value,
      onTertiary: Colors.white.value,
      error: Colors.red.value,
      onError: Colors.white.value,
      surface: Colors.white.value,
      onSurface: Colors.black.value,
      onSurfaceVariant: Colors.grey.value,
      outline: Colors.grey.value,
      shadow: Colors.black26.value,
      surfaceVariant: Colors.grey.shade200.value,
      background: Colors.white.value,
      onBackground: Colors.black.value,
      success: Colors.green.value,
      warning: Colors.orange.value,
      info: Colors.lightBlue.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
                const const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.theme == null ? 'إنشاء ثيم جديد' : 'تعديل الثيم',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomButton(
                  text: 'حفظ',
                  onPressed: _saveTheme,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Basic Info
                  _buildBasicInfo(),
                  const const SizedBox(height: 16),
                  
                  // Light Theme Colors
                  _buildLightThemeColors(),
                  const const SizedBox(height: 16),

                  // Dark Theme Colors  
                  _buildDarkThemeColors(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المعلومات الأساسية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const const SizedBox(height: 16),
          
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الثيم',
              border: OutlineInputBorder(),
            ),
          ),
          
          const const SizedBox(height: 16),
          
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'الوصف',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          
          const const SizedBox(height: 16),
          
          DropdownButtonFormField<ThemeCategory>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'الفئة',
              border: OutlineInputBorder(),
            ),
            items: ThemeCategory.values.map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              ),
            ).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLightThemeColors() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ألوان الثيم الفاتح',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const const SizedBox(height: 16),
          _buildColorPaletteEditor(
            palette: _lightPalette,
            onChanged: (newPalette) {
              setState(() {
                _lightPalette = newPalette;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDarkThemeColors() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ألوان الثيم الداكن',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const const SizedBox(height: 16),
          _buildColorPaletteEditor(
            palette: _darkPalette,
            onChanged: (newPalette) {
              setState(() {
                _darkPalette = newPalette;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorPaletteEditor({
    required ColorPalette palette,
    required ValueChanged<ColorPalette> onChanged,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildColorField('الأساسي', Color(palette.primary), (color) {
          onChanged(palette.copyWith(primary: color.value));
        }),
        _buildColorField('على الأساسي', Color(palette.onPrimary), (color) {
          onChanged(palette.copyWith(onPrimary: color.value));
        }),
        _buildColorField('الثانوي', Color(palette.secondary), (color) {
          onChanged(palette.copyWith(secondary: color.value));
        }),
        _buildColorField('على الثانوي', Color(palette.onSecondary), (color) {
          onChanged(palette.copyWith(onSecondary: color.value));
        }),
        _buildColorField('السطح', Color(palette.surface), (color) {
          onChanged(palette.copyWith(surface: color.value));
        }),
        _buildColorField('على السطح', Color(palette.onSurface), (color) {
          onChanged(palette.copyWith(onSurface: color.value));
        }),
      ],
    );
  }

  Widget _buildColorField(String label, Color currentColor, ValueChanged<Color> onChanged) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _pickColor(currentColor, onChanged),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickColor(Color currentColor, ValueChanged<Color> onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر لون'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: GridView.count(
            crossAxisCount: 6,
            children: [
              Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
              Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
              Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
              Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
              Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
              Colors.white, Colors.red.shade100, Colors.blue.shade100, Colors.green.shade100,
            ].map((color) => GestureDetector(
              onTap: () {
                onChanged(color);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: currentColor == color ? Colors.black : Colors.grey.shade300,
                    width: currentColor == color ? 2 : 1,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTheme() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم الثيم')),
      );
      return;
    }

    final theme = DynamicTheme(
      id: widget.theme?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      lightColorPalette: _lightPalette,
      darkColorPalette: _darkPalette,
      isCustom: true,
      createdAt: widget.theme?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.theme == null) {
        await ref.read(dynamicThemingServiceProvider).createTheme(theme);
      } else {
        await ref.read(dynamicThemingServiceProvider).updateTheme(theme);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ الثيم "${theme.name}" بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في حفظ الثيم: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}