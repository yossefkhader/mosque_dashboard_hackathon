import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_dashboard/services/course_service.dart';

void main() {
  group('CourseService Tests', () {
    late CourseService courseService;

    setUp(() {
      courseService = CourseService.instance;
      courseService.clearCache(); // Clear cache between tests
    });

    test('CourseService should be singleton', () {
      final instance1 = CourseService.instance;
      final instance2 = CourseService.instance;
      expect(identical(instance1, instance2), true);
    });

    test('getStatistics should return correct initial values', () {
      final stats = courseService.getStatistics();
      expect(stats['totalCourses'], 0);
      expect(stats['totalModules'], 0);
      expect(stats['totalLessons'], 0);
      expect(stats['totalEstimatedMinutes'], 0);
    });

    test('clearCache should reset all cached data', () {
      courseService.clearCache();
      final stats = courseService.getStatistics();
      expect(stats['totalCourses'], 0);
    });

    test('getCourse should return null for non-existent course', () {
      final course = courseService.getCourse('non_existent_id');
      expect(course, null);
    });

    test('getLesson should return null for non-existent lesson', () {
      final lesson =
          courseService.getLesson('course_id', 'module_id', 'lesson_id');
      expect(lesson, null);
    });

    test('getAllLessons should return empty list for non-existent course', () {
      final lessons = courseService.getAllLessons('non_existent_id');
      expect(lessons.isEmpty, true);
    });
  });
}
