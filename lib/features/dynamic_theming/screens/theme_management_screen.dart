import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_tab_bar.dart';
// import '../../../core/widgets/loading_widget.dart';
// import '../../../core/widgets/error_widget.dart';
import '../models/simple_theming_models.dart';
import '../providers/simple_theming_providers.dart';
import '../widgets/theme_widgets.dart';
import '../widgets/advanced_theme_settings.dart';

/// شاشة إدارة الثيمات
class ThemeManagementScreen extends ConsumerStatefulWidget {
  const ThemeManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ThemeManagementScreen> createState() => _ThemeManagementScreenState();
}

class _ThemeManagementScreenState extends ConsumerState<ThemeManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(currentThemeProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'إدارة الثيمات',
        actions: [
          IconButton(
            onPressed: () => _showThemePreview(context),
            icon: const Icon(Icons.preview),
            tooltip: 'معاينة الثيمات',
          ),
          IconButton(
            onPressed: () => _refreshThemes(),
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الثيم الحالي
          _buildCurrentThemeHeader(currentTheme),
          
          // التبويبات
          CustomTabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'الثيمات المتاحة', icon: Icon(Icons.palette)),
              Tab(text: 'ثيماتي', icon: Icon(Icons.person)),
              Tab(text: 'الإعدادات', icon: Icon(Icons.settings)),
            ],
          ),
          
          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableThemesTab(),
                _buildMyThemesTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewTheme(),
        icon: const Icon(Icons.add),
        label: const Text('ثيم جديد'),
      ),
    );
  }

  Widget _buildCurrentThemeHeader(ThemeState currentTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: currentTheme.currentTheme != null
          ? _buildThemeInfo(currentTheme.currentTheme!)
          : _buildNoThemeInfo(),
    );
  }

  Widget _buildThemeInfo(DynamicTheme theme) {
    return Row(
      children: [
        // معاينة مصغرة للثيم
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Color(theme.lightColorPalette.primary), 
                Color(theme.lightColorPalette.secondary)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.palette,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // معلومات الثيم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'الثيم الحالي: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      theme.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (theme.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  theme.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        
        // أيقونة مخصص
        if (theme.isCustom)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'مخصص',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoThemeInfo() {
    return const Row(
      children: [
        Icon(Icons.error_outline, color: Colors.orange),
        SizedBox(width: 12),
        Text('لم يتم تحديد ثيم'),
      ],
    );
  }

  Widget _buildAvailableThemesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // فلاتر البحث
          _buildThemeFilters(),
          const SizedBox(height: 16),
          
          // قائمة الثيمات المتاحة
          const ThemeList(),
        ],
      ),
    );
  }

  Widget _buildMyThemesTab() {
    final customThemesAsync = ref.watch(customThemesProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          customThemesAsync.when(
            data: (customThemes) => _buildQuickStats(customThemes),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('خطأ: $error'),
          ),
          const SizedBox(height: 16),
          
          // الثيمات المخصصة
          customThemesAsync.when(
            data: (customThemes) => customThemes.isEmpty
                ? _buildEmptyCustomThemes()
                : const ThemeList(showCustomOnly: true),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('خطأ في تحميل الثيمات: $error'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const AdvancedThemeSettings();
  }

  Widget _buildThemeFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تصفية الثيمات',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // أزرار الفلاتر
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('الكل', true, () {}),
              _buildFilterChip('فاتح', false, () {}),
              _buildFilterChip('داكن', false, () {}),
              _buildFilterChip('ملون', false, () {}),
              _buildFilterChip('طبيعي', false, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
    );
  }

  Widget _buildQuickStats(List<DynamicTheme> customThemes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.purple[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.palette,
            count: customThemes.length,
            label: 'ثيماتي',
            color: Colors.blue,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          _buildStatItem(
            icon: Icons.favorite,
            count: 0, // يمكن إضافة عداد المفضلة لاحقاً
            label: 'المفضلة',
            color: Colors.red,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          _buildStatItem(
            icon: Icons.download,
            count: 0, // يمكن إضافة عداد التحميلات لاحقاً
            label: 'المحملة',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCustomThemes() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.palette_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ثيمات مخصصة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإنشاء ثيم مخصص جديد\nليعكس شخصيتك الفريدة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'إنشاء ثيم جديد',
            onPressed: _createNewTheme,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  void _selectTheme(DynamicTheme theme) async {
    try {
      await ref.read(dynamicThemingServiceProvider).setTheme(theme.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تطبيق ثيم "${theme.name}" بنجاح'),
            backgroundColor: Color(theme.lightColorPalette.primary),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تطبيق الثيم: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createNewTheme() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ThemeEditorSheet(),
    );
  }

  void _showThemePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _ThemePreviewDialog(),
    );
  }

  void _refreshThemes() {
    ref.refresh(availableThemesProvider);
    ref.refresh(customThemesProvider);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

/// حوار معاينة الثيمات
class _ThemePreviewDialog extends ConsumerWidget {
  const _ThemePreviewDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableThemesAsync = ref.watch(availableThemesProvider);
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'معاينة الثيمات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: availableThemesAsync.when(
                data: (availableThemes) => PageView.builder(
                  itemCount: availableThemes.length,
                  itemBuilder: (context, index) {
                    final theme = availableThemes[index];
                    return _buildThemePreview(context, theme);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('خطأ: $error')),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context, DynamicTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(theme.lightColorPalette.background),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // شريط التطبيق
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(theme.lightColorPalette.primary),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu,
                  color: Color(theme.lightColorPalette.onPrimary),
                ),
                const SizedBox(width: 16),
                Text(
                  theme.name,
                  style: TextStyle(
                    color: Color(theme.lightColorPalette.onPrimary),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى المعاينة
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // بطاقة
                  Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(theme.lightColorPalette.surface),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عنوان البطاقة',
                          style: TextStyle(
                            color: Color(theme.lightColorPalette.onSurface),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'وصف البطاقة...',
                          style: TextStyle(
                            color: Color(theme.lightColorPalette.onSurface).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // زر
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(theme.lightColorPalette.secondary),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        'زر تجريبي',
                        style: TextStyle(
                          color: Color(theme.lightColorPalette.onSecondary),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}