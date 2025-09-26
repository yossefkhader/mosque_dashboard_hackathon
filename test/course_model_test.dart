import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_dashboard/models/course.dart';

void main() {
  group('Course Model Tests', () {
    test('Course fromJson should parse valid JSON correctly', () {
      final json = {
        'id': 'test_course',
        'title': 'Test Course',
        'lang': 'ar',
        'rtl': true,
        'level': 'مبتدئ',
        'estimatedTotalTimeMin': 120,
        'audience': 'Test audience',
        'outcomes': ['Outcome 1', 'Outcome 2'],
        'modules': [
          {
            'id': 'module1',
            'title': 'Module 1',
            'timeMin': 60,
            'summary': 'Test module',
            'lessons': [
              {
                'id': 'lesson1',
                'title': 'Lesson 1',
                'objectives': ['Objective 1'],
                'steps': ['Step 1', 'Step 2'],
              }
            ]
          }
        ]
      };

      final course = Course.fromJson(json);

      expect(course.id, 'test_course');
      expect(course.title, 'Test Course');
      expect(course.lang, 'ar');
      expect(course.rtl, true);
      expect(course.level, 'مبتدئ');
      expect(course.estimatedTotalTimeMin, 120);
      expect(course.modules.length, 1);
      expect(course.modules[0].lessons.length, 1);
    });

    test('Course totalLessons should count correctly', () {
      final course = Course(
        id: 'test',
        title: 'Test',
        lang: 'ar',
        rtl: true,
        modules: [
          Module(
            id: 'module1',
            title: 'Module 1',
            lessons: [
              Lesson(id: 'lesson1', title: 'Lesson 1'),
              Lesson(id: 'lesson2', title: 'Lesson 2'),
            ],
          ),
          Module(
            id: 'module2',
            title: 'Module 2',
            lessons: [
              Lesson(id: 'lesson3', title: 'Lesson 3'),
            ],
          ),
        ],
      );

      expect(course.totalLessons, 3);
    });

    test('Course estimatedTimeDisplay should format correctly', () {
      final course1 = Course(
        id: 'test1',
        title: 'Test 1',
        lang: 'ar',
        rtl: true,
        estimatedTotalTimeMin: 90,
        modules: [],
      );

      final course2 = Course(
        id: 'test2',
        title: 'Test 2',
        lang: 'ar',
        rtl: true,
        estimatedTotalTimeMin: 30,
        modules: [],
      );

      final course3 = Course(
        id: 'test3',
        title: 'Test 3',
        lang: 'ar',
        rtl: true,
        modules: [],
      );

      expect(course1.estimatedTimeDisplay, '1 س 30 د');
      expect(course2.estimatedTimeDisplay, '30 د');
      expect(course3.estimatedTimeDisplay, '');
    });
  });

  group('Lesson Model Tests', () {
    test('Lesson contentIndicators should return correct indicators', () {
      final lesson = Lesson(
        id: 'test_lesson',
        title: 'Test Lesson',
        objectives: ['Objective 1'],
        steps: ['Step 1'],
        checklist: ['Item 1'],
        assignment: 'Do something',
        quiz: Quiz(
          type: 'single-choice',
          question: 'Question?',
          choices: ['A', 'B'],
          answerIndex: 0,
        ),
        downloadables: [
          Downloadable(
            type: 'text-template',
            filename: 'test.txt',
            content: 'content',
          ),
        ],
      );

      final indicators = lesson.contentIndicators;
      expect(indicators.contains('أهداف'), true);
      expect(indicators.contains('خطوات'), true);
      expect(indicators.contains('قائمة تحقق'), true);
      expect(indicators.contains('مهمة'), true);
      expect(indicators.contains('اختبار'), true);
      expect(indicators.contains('تحميلات'), true);
    });

    test('Lesson contentIndicators should handle empty content', () {
      final lesson = Lesson(
        id: 'test_lesson',
        title: 'Test Lesson',
      );

      expect(lesson.contentIndicators.isEmpty, true);
    });
  });

  group('Quiz Model Tests', () {
    test('Quiz fromJson should parse correctly', () {
      final json = {
        'type': 'single-choice',
        'question': 'What is 2 + 2?',
        'choices': ['3', '4', '5'],
        'answerIndex': 1,
      };

      final quiz = Quiz.fromJson(json);

      expect(quiz.type, 'single-choice');
      expect(quiz.question, 'What is 2 + 2?');
      expect(quiz.choices.length, 3);
      expect(quiz.answerIndex, 1);
    });
  });

  group('Downloadable Model Tests', () {
    test('Downloadable fromJson should parse correctly', () {
      final json = {
        'type': 'csv-template',
        'filename': 'template.csv',
        'content': 'header1,header2\nvalue1,value2',
      };

      final downloadable = Downloadable.fromJson(json);

      expect(downloadable.type, 'csv-template');
      expect(downloadable.filename, 'template.csv');
      expect(downloadable.content.contains('header1'), true);
    });
  });
}
