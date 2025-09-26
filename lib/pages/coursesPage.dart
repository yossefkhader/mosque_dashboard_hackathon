import 'package:flutter/material.dart';
import '../appConsts.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../services/progress_service.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final CourseService _courseService = CourseService.instance;
  final ProgressService _progressService = ProgressService.instance;
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _progressService.loadProgress();
      final courses = await _courseService.loadCourses();

      setState(() {
        _courses = courses;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ في تحميل الدورات التعليمية';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوحدات التعليمية',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppConsts.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        if (!_isLoading && _courses.isNotEmpty)
          Text(
            'دورات تعليمية متخصصة لإدارة المساجد والأنشطة الدعوية',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConsts.secondaryColor),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_courses.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCoursesList();
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConsts.secondaryColor,
              foregroundColor: AppConsts.primaryColor,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.white38,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد دورات تعليمية متاحة حالياً',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppConsts.secondaryColor,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 300 / 160,
        ),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          return _buildCourseCard(_courses[index]);
        },
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final progress =
        _progressService.getCourseProgress(course.id, course.totalLessons);
    final completedLessons =
        _progressService.getCompletedLessonsCount(course.id);

    return Card(
      elevation: 4,
      color: AppConsts.polor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppConsts.secondaryColor, width: 1),
      ),
      child: InkWell(
        onTap: () => _navigateToCourseDetail(course),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseHeader(course),
              const SizedBox(height: 12),
              _buildCourseInfo(course),
              const SizedBox(height: 16),
              _buildProgressSection(course, progress, completedLessons),
              const Spacer(),
              _buildCourseFooter(course),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseHeader(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConsts.secondaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (course.level != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppConsts.secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              course.level!,
              style: const TextStyle(
                color: AppConsts.secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCourseInfo(Course course) {
    return Column(
      children: [
        _buildInfoRow(
          Icons.access_time,
          course.estimatedTimeDisplay.isNotEmpty
              ? course.estimatedTimeDisplay
              : 'غير محدد',
        ),
        const SizedBox(height: 4),
        _buildInfoRow(
          Icons.list_alt,
          '${course.modules.length} وحدات، ${course.totalLessons} درس',
        ),
        if (course.audience != null) ...[
          const SizedBox(height: 4),
          _buildInfoRow(
            Icons.group,
            course.audience!,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
      Course course, double progress, int completedLessons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'التقدم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$completedLessons/${course.totalLessons}',
              style: const TextStyle(
                color: AppConsts.secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppConsts.secondaryColor),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% مكتمل',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseFooter(Course course) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (course.outcomes?.isNotEmpty == true)
              _buildFeatureBadge(Icons.checklist, 'أهداف'),
            if (course.quickSizesGuide?.isNotEmpty == true) ...[
              const SizedBox(width: 6),
              _buildFeatureBadge(Icons.straighten, 'دليل سريع'),
            ],
            if (course.starterChecklists != null) ...[
              const SizedBox(width: 6),
              _buildFeatureBadge(Icons.task_alt, 'قوائم'),
            ],
          ],
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppConsts.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildFeatureBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white70,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCourseDetail(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    );
  }
}
