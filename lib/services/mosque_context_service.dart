import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MosqueContextService {
  static const String _storageKey = 'mosque_context';

  // Load mosque context data
  Future<Map<String, dynamic>?> loadMosqueContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData != null) {
        return json.decode(savedData);
      }
      return null;
    } catch (e) {
      print('Error loading mosque context: $e');
      return null;
    }
  }

  // Save mosque context data
  Future<void> saveMosqueContext(Map<String, dynamic> context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, json.encode(context));
    } catch (e) {
      print('Error saving mosque context: $e');
      throw e;
    }
  }

  // Get context summary for AI
  Future<String> getContextSummary() async {
    final context = await loadMosqueContext();
    if (context == null) {
      return 'لم يتم تعبئة معلومات المسجد بعد. يرجى الذهاب إلى الإعدادات لإدخال المعلومات.';
    }

    final buffer = StringBuffer();
    buffer.writeln('معلومات المسجد:');

    if (context['priorities']?.isNotEmpty == true) {
      buffer.writeln('الأولويات: ${context['priorities']}');
    }

    if (context['audiences']?.isNotEmpty == true) {
      buffer.writeln('الشرائح المستهدفة: ${context['audiences']}');
    }

    if (context['specialNeeds']?.isNotEmpty == true) {
      buffer.writeln('الاحتياجات الخاصة: ${context['specialNeeds']}');
    }

    if (context['capacity']?.isNotEmpty == true) {
      buffer.writeln('السعة والمرافق: ${context['capacity']}');
    }

    if (context['notes']?.isNotEmpty == true) {
      buffer.writeln('ملاحظات إضافية: ${context['notes']}');
    }

    return buffer.toString();
  }

  // Check if context is configured
  Future<bool> isContextConfigured() async {
    final context = await loadMosqueContext();
    return context != null &&
        (context['priorities']?.isNotEmpty == true ||
            context['audiences']?.isNotEmpty == true ||
            context['capacity']?.isNotEmpty == true);
  }

  // Get personalized greeting based on context
  Future<String> getPersonalizedGreeting() async {
    final context = await loadMosqueContext();
    if (context == null) {
      return 'مرحباً! يمكنني مساعدتك في تنظيم فعاليات المسجد. لتقديم اقتراحات أفضل، يرجى تعبئة معلومات المسجد في الإعدادات.';
    }

    final priorities = context['priorities'] as String?;
    final audiences = context['audiences'] as String?;

    String greeting = 'مرحباً! بناءً على معلومات مسجدكم';

    if (priorities?.isNotEmpty == true) {
      final priorityList = priorities!.split(',').take(2).join(' و ').trim();
      greeting += ' مع التركيز على $priorityList';
    }

    if (audiences?.isNotEmpty == true) {
      final audienceList = audiences!.split(',').take(3).join(' و ').trim();
      greeting += ' للفئات: $audienceList';
    }

    greeting += '، كيف يمكنني مساعدتك في تنظيم فعاليات مناسبة؟';

    return greeting;
  }

  // Generate context-aware event suggestions
  Future<List<String>> getContextualSuggestions() async {
    final context = await loadMosqueContext();
    List<String> suggestions = [];

    if (context == null) {
      return [
        // TODO: Add default suggestions
      ];
    }

    final priorities = context['priorities'] as String?;
    final audiences = context['audiences'] as String?;

    // Add suggestions based on priorities
    if (priorities?.contains('تحفيظ') == true ||
        priorities?.contains('قرآن') == true) {
      suggestions.add('برنامج تحفيظ القرآن');
    }

    if (priorities?.contains('أسرة') == true ||
        priorities?.contains('عائل') == true) {
      suggestions.add('فعاليات عائلية');
    }

    if (priorities?.contains('شباب') == true) {
      suggestions.add('برنامج للشباب');
    }

    // Add suggestions based on audiences
    if (audiences?.contains('أطفال') == true) {
      suggestions.add('أنشطة للأطفال');
    }

    if (audiences?.contains('نساء') == true ||
        audiences?.contains('أخوات') == true) {
      suggestions.add('برامج نسائية');
    }

    if (audiences?.contains('كبار') == true ||
        audiences?.contains('مسن') == true) {
      suggestions.add('فعاليات لكبار السن');
    }

    if (audiences?.contains('جدد') == true ||
        audiences?.contains('جديد') == true) {
      suggestions.add('برنامج تعريفي للمسلمين الجدد');
    }

    // Default suggestions if none match
    if (suggestions.isEmpty) {
      suggestions = [
        'برنامج تعليمي عام',
        'فعاليات اجتماعية',
        'أنشطة ثقافية',
      ];
    }

    return suggestions.take(4).toList();
  }
}
