import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class CourseService {
  static const List<String> _courseAssetPaths = [
    'lib/assets/mosque_media_course_v1.json',
    'lib/assets/mosque_budget_course_v1.json',
  ];

  static CourseService? _instance;
  static CourseService get instance => _instance ??= CourseService._();
  CourseService._();

  List<Course>? _cachedCourses;
  final Map<String, Course> _courseMap = {};

  // Load all courses from assets
  Future<List<Course>> loadCourses() async {
    if (_cachedCourses != null) {
      return _cachedCourses!;
    }

    final List<Course> courses = [];

    for (final assetPath in _courseAssetPaths) {
      try {
        final jsonString = await rootBundle.loadString(assetPath);
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        // Validate minimal required fields
        if (!_isValidCourseJson(jsonData)) {
          print('تخطي الدورة في $assetPath: بيانات غير صالحة');
          continue;
        }

        final course = Course.fromJson(jsonData);
        courses.add(course);
        _courseMap[course.id] = course;

        print('تم تحميل الدورة: ${course.title}');
      } catch (e) {
        print('خطأ في تحميل الدورة من $assetPath: $e');
        // Continue loading other courses even if one fails
      }
    }

    _cachedCourses = courses;
    return courses;
  }

  // Get a specific course by ID
  Course? getCourse(String courseId) {
    return _courseMap[courseId];
  }

  // Get course by ID with async loading if not cached
  Future<Course?> getCourseAsync(String courseId) async {
    if (_courseMap.containsKey(courseId)) {
      return _courseMap[courseId];
    }

    // If not cached, load all courses and try again
    await loadCourses();
    return _courseMap[courseId];
  }

  // Find a specific lesson within a course
  Lesson? getLesson(String courseId, String moduleId, String lessonId) {
    final course = getCourse(courseId);
    if (course == null) return null;

    final module = course.modules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => throw StateError('Module not found'),
    );

    try {
      return module.lessons.firstWhere((l) => l.id == lessonId);
    } catch (e) {
      return null;
    }
  }

  // Get all lessons for a course (flattened)
  List<Lesson> getAllLessons(String courseId) {
    final course = getCourse(courseId);
    if (course == null) return [];

    return course.modules.expand((module) => module.lessons).toList();
  }

  // Validate that JSON has required fields for a course
  bool _isValidCourseJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'].toString().isEmpty) return false;
    if (json['title'] == null || json['title'].toString().isEmpty) return false;
    if (json['modules'] == null || json['modules'] is! List) return false;

    final modules = json['modules'] as List;
    if (modules.isEmpty) return false;

    // Check that each module has required fields
    for (final module in modules) {
      if (module is! Map<String, dynamic>) return false;
      if (module['id'] == null || module['title'] == null) return false;
      if (module['lessons'] == null || module['lessons'] is! List) return false;
    }

    return true;
  }

  // Clear cache (for testing or refresh)
  void clearCache() {
    _cachedCourses = null;
    _courseMap.clear();
  }

  // Get course loading errors (for debugging)
  Future<List<String>> getLoadingErrors() async {
    final List<String> errors = [];

    for (final assetPath in _courseAssetPaths) {
      try {
        final jsonString = await rootBundle.loadString(assetPath);
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        if (!_isValidCourseJson(jsonData)) {
          errors.add('ملف غير صالح: $assetPath');
        }
      } catch (e) {
        errors.add('خطأ في تحميل $assetPath: $e');
      }
    }

    return errors;
  }

  // Get statistics about loaded courses
  Map<String, dynamic> getStatistics() {
    if (_cachedCourses == null) {
      return {
        'totalCourses': 0,
        'totalModules': 0,
        'totalLessons': 0,
        'totalEstimatedMinutes': 0,
      };
    }

    int totalModules = 0;
    int totalLessons = 0;
    int totalEstimatedMinutes = 0;

    for (final course in _cachedCourses!) {
      totalModules += course.modules.length;
      totalLessons += course.totalLessons;
      totalEstimatedMinutes += course.estimatedTotalTimeMin ?? 0;
    }

    return {
      'totalCourses': _cachedCourses!.length,
      'totalModules': totalModules,
      'totalLessons': totalLessons,
      'totalEstimatedMinutes': totalEstimatedMinutes,
    };
  }
}
