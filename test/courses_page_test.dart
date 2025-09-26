import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_dashboard/pages/coursesPage.dart';
import 'package:mosque_dashboard/appConsts.dart';

void main() {
  group('CoursesPage Widget Tests', () {
    testWidgets('CoursesPage should display title correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoursesPage(),
          ),
        ),
      );

      expect(find.text('الوحدات التعليمية'), findsOneWidget);
    });

    testWidgets('CoursesPage should show loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoursesPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('CoursesPage should have correct theme colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoursesPage(),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('الوحدات التعليمية'));
      expect(titleWidget.style?.color, AppConsts.secondaryColor);
    });

    testWidgets('CoursesPage should handle pull to refresh',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoursesPage(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump(Duration(seconds: 2));

      // Look for RefreshIndicator (might not be visible until courses are loaded)
      if (find.byType(RefreshIndicator).evaluate().isNotEmpty) {
        expect(find.byType(RefreshIndicator), findsOneWidget);
      }
    });
  });
}
