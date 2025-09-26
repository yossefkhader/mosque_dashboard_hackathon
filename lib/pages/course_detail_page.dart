import 'package:flutter/material.dart';
import '../appConsts.dart';
import '../models/course.dart';
import '../services/progress_service.dart';
import 'lesson_reader_page.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final ProgressService _progressService = ProgressService.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.course.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppConsts.primaryColor,
        appBar: AppBar(
          backgroundColor: AppConsts.primaryColor,
          foregroundColor: AppConsts.secondaryColor,
          title: Text(
            widget.course.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _showCourseInfo,
              icon: const Icon(Icons.info_outline),
              tooltip: 'معلومات الدورة',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildCourseHeader(),
            Expanded(
              child: _buildModulesList(),
            ),
          ],
        ),
        floatingActionButton: _buildQuickActions(),
      ),
    );
  }

  Widget _buildCourseHeader() {
    final progress = _progressService.getCourseProgress(
      widget.course.id,
      widget.course.totalLessons,
    );
    final completedLessons =
        _progressService.getCompletedLessonsCount(widget.course.id);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConsts.polor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConsts.secondaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.course.level != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppConsts.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.course.level!,
                          style: const TextStyle(
                            color: AppConsts.secondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Text(
                      widget.course.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConsts.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConsts.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppConsts.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(
                  Icons.access_time, widget.course.estimatedTimeDisplay),
              const SizedBox(width: 8),
              _buildStatChip(
                  Icons.list_alt, '${widget.course.modules.length} وحدة'),
              const SizedBox(width: 8),
              _buildStatChip(Icons.school, '${widget.course.totalLessons} درس'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'التقدم: $completedLessons/${widget.course.totalLessons} درس',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppConsts.secondaryColor),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.course.modules.length,
      itemBuilder: (context, index) {
        return _buildModuleCard(widget.course.modules[index], index);
      },
    );
  }

  Widget _buildModuleCard(Module module, int moduleIndex) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppConsts.polor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppConsts.secondaryColor.withOpacity(0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                onSurface: Colors.white,
              ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppConsts.secondaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${moduleIndex + 1}',
                style: const TextStyle(
                  color: AppConsts.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          title: Text(
            module.title,
            style: const TextStyle(
              color: AppConsts.secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (module.summary != null) ...[
                const SizedBox(height: 4),
                Text(
                  module.summary!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  if (module.timeDisplay.isNotEmpty) ...[
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      module.timeDisplay,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Icon(
                    Icons.list_alt,
                    size: 14,
                    color: Colors.white60,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${module.lessons.length} درس',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            _buildLessonsList(module),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsList(Module module) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < module.lessons.length; i++)
            _buildLessonItem(module.lessons[i], module.id, i),
        ],
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson, String moduleId, int lessonIndex) {
    final isCompleted =
        _progressService.isLessonCompleted(widget.course.id, lesson.id);
    final contentIndicators = lesson.contentIndicators;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppConsts.secondaryColor.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? AppConsts.secondaryColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        onTap: () => _navigateToLesson(lesson, moduleId),
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppConsts.secondaryColor
                : Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: AppConsts.primaryColor,
                    size: 16,
                  )
                : Text(
                    '${lessonIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            color: isCompleted ? AppConsts.secondaryColor : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: contentIndicators.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 4,
                  children: contentIndicators.map((indicator) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        indicator,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isCompleted ? AppConsts.secondaryColor : Colors.white38,
        ),
      ),
    );
  }

  Widget? _buildQuickActions() {
    final hasQuickGuides = widget.course.quickSizesGuide?.isNotEmpty == true;
    final hasChecklists = widget.course.starterChecklists != null;

    if (!hasQuickGuides && !hasChecklists) return null;

    return FloatingActionButton(
      onPressed: _showQuickActions,
      backgroundColor: AppConsts.secondaryColor,
      foregroundColor: AppConsts.primaryColor,
      child: const Icon(Icons.more_vert),
    );
  }

  void _navigateToLesson(Lesson lesson, String moduleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonReaderPage(
          course: widget.course,
          moduleId: moduleId,
          lesson: lesson,
          onLessonCompleted: (completed) {
            setState(() {
              if (completed) {
                _progressService.markLessonCompleted(
                    widget.course.id, lesson.id);
              } else {
                _progressService.markLessonIncomplete(
                    widget.course.id, lesson.id);
              }
            });
          },
        ),
      ),
    );
  }

  void _showCourseInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConsts.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'معلومات الدورة',
          style: TextStyle(color: AppConsts.secondaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.course.audience != null) ...[
              const Text(
                'الجمهور المستهدف:',
                style: TextStyle(
                  color: AppConsts.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.course.audience!,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
            ],
            if (widget.course.outcomes?.isNotEmpty == true) ...[
              const Text(
                'أهداف التعلم:',
                style: TextStyle(
                  color: AppConsts.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.course.outcomes!.map((outcome) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppConsts.secondaryColor)),
                        Expanded(
                          child: Text(
                            outcome,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق',
                style: TextStyle(color: AppConsts.secondaryColor)),
          ),
        ],
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConsts.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildQuickActionsSheet(),
    );
  }

  Widget _buildQuickActionsSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أدوات مساعدة',
            style: TextStyle(
              color: AppConsts.secondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.course.quickSizesGuide?.isNotEmpty == true)
            _buildQuickActionTile(
              Icons.straighten,
              'دليل المقاسات السريع',
              'مقاسات وأبعاد للتصميم',
              () => _showQuickSizesGuide(),
            ),
          if (widget.course.starterChecklists != null)
            _buildQuickActionTile(
              Icons.task_alt,
              'قوائم التحقق',
              'قوائم جاهزة للبدء والتطبيق',
              () => _showStarterChecklists(),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConsts.secondaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppConsts.secondaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppConsts.secondaryColor,
        ),
        tileColor: AppConsts.polor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showQuickSizesGuide() {
    Navigator.pop(context); // Close bottom sheet

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConsts.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'دليل المقاسات السريع',
          style: TextStyle(color: AppConsts.secondaryColor),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                border: TableBorder.all(color: Colors.white24),
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: AppConsts.polor),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'النوع',
                          style: TextStyle(
                            color: AppConsts.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'المقاس',
                          style: TextStyle(
                            color: AppConsts.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'الاستخدام',
                          style: TextStyle(
                            color: AppConsts.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...widget.course.quickSizesGuide!.map((guide) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              guide.name,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              guide.size,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              guide.use,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق',
                style: TextStyle(color: AppConsts.secondaryColor)),
          ),
        ],
      ),
    );
  }

  void _showStarterChecklists() {
    Navigator.pop(context); // Close bottom sheet

    final checklists = widget.course.starterChecklists!;
    final tabs = <Tab>[];
    final tabViews = <Widget>[];

    if (checklists.setup?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'إعداد'));
      tabViews.add(_buildChecklistView(checklists.setup!));
    }
    if (checklists.weekly?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'أسبوعي'));
      tabViews.add(_buildChecklistView(checklists.weekly!));
    }
    if (checklists.monthly?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'شهري'));
      tabViews.add(_buildChecklistView(checklists.monthly!));
    }
    if (checklists.quarterly?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'ربع سنوي'));
      tabViews.add(_buildChecklistView(checklists.quarterly!));
    }
    if (checklists.yearEnd?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'نهاية السنة'));
      tabViews.add(_buildChecklistView(checklists.yearEnd!));
    }
    if (checklists.assets?.isNotEmpty == true) {
      tabs.add(const Tab(text: 'أصول'));
      tabViews.add(_buildChecklistView(checklists.assets!));
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppConsts.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                const Text(
                  'قوائم التحقق',
                  style: TextStyle(
                    color: AppConsts.secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  tabs: tabs,
                  labelColor: AppConsts.secondaryColor,
                  unselectedLabelColor: Colors.white60,
                  indicatorColor: AppConsts.secondaryColor,
                  isScrollable: true,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(children: tabViews),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق',
                      style: TextStyle(color: AppConsts.secondaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistView(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_box_outline_blank,
                color: AppConsts.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  items[index],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
