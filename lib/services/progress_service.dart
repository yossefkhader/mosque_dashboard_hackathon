import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProgressService {
  static const String _progressKey = 'course_progress';
  static ProgressService? _instance;
  static ProgressService get instance => _instance ??= ProgressService._();
  ProgressService._();

  Map<String, Set<String>> _completedLessons = {};
  Map<String, Map<String, bool>> _checklistStates = {};
  Map<String, Map<String, int?>> _quizAnswers = {};

  // Load progress from storage
  Future<void> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString(_progressKey);

      if (progressJson != null) {
        final Map<String, dynamic> data = json.decode(progressJson);

        // Load completed lessons
        if (data['completedLessons'] != null) {
          final Map<String, dynamic> completed = data['completedLessons'];
          _completedLessons = completed.map(
            (courseId, lessons) => MapEntry(
              courseId,
              Set<String>.from(lessons),
            ),
          );
        }

        // Load checklist states
        if (data['checklistStates'] != null) {
          final Map<String, dynamic> checklists = data['checklistStates'];
          _checklistStates = checklists.map(
            (lessonId, states) => MapEntry(
              lessonId,
              Map<String, bool>.from(states),
            ),
          );
        }

        // Load quiz answers
        if (data['quizAnswers'] != null) {
          final Map<String, dynamic> quizzes = data['quizAnswers'];
          _quizAnswers = quizzes.map(
            (lessonId, answers) => MapEntry(
              lessonId,
              Map<String, int?>.from(answers),
            ),
          );
        }
      }
    } catch (e) {
      print('خطأ في تحميل التقدم: $e');
    }
  }

  // Save progress to storage
  Future<void> saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> data = {
        'completedLessons': _completedLessons.map(
          (courseId, lessons) => MapEntry(courseId, lessons.toList()),
        ),
        'checklistStates': _checklistStates,
        'quizAnswers': _quizAnswers,
      };

      await prefs.setString(_progressKey, json.encode(data));
    } catch (e) {
      print('خطأ في حفظ التقدم: $e');
    }
  }

  // Mark lesson as completed
  Future<void> markLessonCompleted(String courseId, String lessonId) async {
    _completedLessons.putIfAbsent(courseId, () => <String>{});
    _completedLessons[courseId]!.add(lessonId);
    await saveProgress();
  }

  // Mark lesson as incomplete
  Future<void> markLessonIncomplete(String courseId, String lessonId) async {
    _completedLessons[courseId]?.remove(lessonId);
    await saveProgress();
  }

  // Check if lesson is completed
  bool isLessonCompleted(String courseId, String lessonId) {
    return _completedLessons[courseId]?.contains(lessonId) ?? false;
  }

  // Get course progress (0.0 to 1.0)
  double getCourseProgress(String courseId, int totalLessons) {
    if (totalLessons == 0) return 0.0;
    final completedCount = _completedLessons[courseId]?.length ?? 0;
    return completedCount / totalLessons;
  }

  // Get completed lessons count for a course
  int getCompletedLessonsCount(String courseId) {
    return _completedLessons[courseId]?.length ?? 0;
  }

  // Checklist management
  void setChecklistItem(String lessonId, String item, bool checked) {
    _checklistStates.putIfAbsent(lessonId, () => <String, bool>{});
    _checklistStates[lessonId]![item] = checked;
    // Don't auto-save for checklist items to avoid too many writes
  }

  bool getChecklistItem(String lessonId, String item) {
    return _checklistStates[lessonId]?[item] ?? false;
  }

  Map<String, bool> getChecklistState(String lessonId) {
    return _checklistStates[lessonId] ?? <String, bool>{};
  }

  // Save checklist state manually
  Future<void> saveChecklistState() async {
    await saveProgress();
  }

  // Quiz management
  void setQuizAnswer(String lessonId, int? answerIndex) {
    _quizAnswers.putIfAbsent(lessonId, () => <String, int?>{});
    _quizAnswers[lessonId]!['answer'] = answerIndex;
  }

  int? getQuizAnswer(String lessonId) {
    return _quizAnswers[lessonId]?['answer'];
  }

  bool hasAnsweredQuiz(String lessonId) {
    return _quizAnswers[lessonId]?['answer'] != null;
  }

  // Save quiz answer
  Future<void> saveQuizAnswer(String lessonId, int answerIndex) async {
    setQuizAnswer(lessonId, answerIndex);
    await saveProgress();
  }

  // Get overall statistics
  Map<String, dynamic> getStatistics() {
    int totalCompleted = 0;
    int totalCourses = _completedLessons.length;

    for (final lessons in _completedLessons.values) {
      totalCompleted += lessons.length;
    }

    return {
      'totalCompletedLessons': totalCompleted,
      'coursesInProgress': totalCourses,
      'totalChecklistItems': _checklistStates.values
          .fold(0, (sum, checklist) => sum + checklist.length),
      'totalQuizzesAnswered':
          _quizAnswers.values.where((quiz) => quiz['answer'] != null).length,
    };
  }

  // Reset progress for a course
  Future<void> resetCourseProgress(String courseId) async {
    _completedLessons.remove(courseId);

    // Remove all lesson-specific data for this course
    final keysToRemove = <String>[];
    for (final key in _checklistStates.keys) {
      if (key.startsWith('${courseId}_')) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _checklistStates.remove(key);
    }

    keysToRemove.clear();
    for (final key in _quizAnswers.keys) {
      if (key.startsWith('${courseId}_')) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _quizAnswers.remove(key);
    }

    await saveProgress();
  }

  // Reset all progress
  Future<void> resetAllProgress() async {
    _completedLessons.clear();
    _checklistStates.clear();
    _quizAnswers.clear();
    await saveProgress();
  }
}
