import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/calendar_event.dart';
import 'mosque_context_service.dart';
import 'event_service.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o';

  // You should store this securely, not in code
  // Consider using flutter_dotenv or secure storage
  static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';
  final MosqueContextService _contextService = MosqueContextService();
  final EventService _eventService = EventService();

  Future<Map<String, dynamic>> sendMessage(String userMessage) async {
    try {
      // Prepare context
      final context = await _prepareContext();

      // Create system prompt
      final systemPrompt = await _createSystemPrompt(context);

      // Prepare messages
      final messages = [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userMessage}
      ];

      // Make API call
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': messages,
          'max_tokens': 2000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;

        // Parse response to determine if it's text or events
        return _parseAIResponse(aiResponse);
      } else {
        throw Exception(
            'OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calling OpenAI API: $e');
    }
  }

  Future<String> _prepareContext() async {
    final buffer = StringBuffer();

    try {
      // Add AI context from file
      final aiContext =
          await rootBundle.loadString('lib/assets/ai_context.txt');
      buffer.writeln('السياق العام:');
      buffer.writeln(aiContext);
      buffer.writeln('\n---\n');

      // Add mosque-specific context
      final mosqueContext = await _contextService.loadMosqueContext();
      if (mosqueContext != null) {
        buffer.writeln('معلومات المسجد:');
        if (mosqueContext['priorities']?.isNotEmpty == true) {
          buffer.writeln('الأولويات: ${mosqueContext['priorities']}');
        }
        if (mosqueContext['audiences']?.isNotEmpty == true) {
          buffer.writeln('الفئات المستهدفة: ${mosqueContext['audiences']}');
        }
        if (mosqueContext['specialNeeds']?.isNotEmpty == true) {
          buffer.writeln('الاحتياجات الخاصة: ${mosqueContext['specialNeeds']}');
        }
        if (mosqueContext['capacity']?.isNotEmpty == true) {
          buffer.writeln('السعة والمرافق: ${mosqueContext['capacity']}');
        }
        if (mosqueContext['notes']?.isNotEmpty == true) {
          buffer.writeln('ملاحظات: ${mosqueContext['notes']}');
        }
        buffer.writeln('\n---\n');
      }

      // Add existing events context
      final events = await _eventService.loadEvents();
      if (events.isNotEmpty) {
        buffer.writeln('الأحداث الحالية في البرنامج:');
        for (final event in events.take(10)) {
          // Limit to avoid token overuse
          buffer.writeln(
              '- ${event.title}: ${event.startTime.day}/${event.startTime.month}/${event.startTime.year}');
        }
        if (events.length > 10) {
          buffer.writeln('... و ${events.length - 10} حدث آخر');
        }
        buffer.writeln('\n---\n');
      }
    } catch (e) {
      print('Error preparing context: $e');
    }

    return buffer.toString();
  }

  Future<String> _createSystemPrompt(String context) async {
    return '''
$context

تعليمات الاستجابة:
1. إذا كان المستخدم يطلب فعاليات أو أحداث محددة، أجب بتنسيق JSON كما يلي:
{
  "type": "events",
  "message": "رسالة تفسيرية",
  "events": [
    {
      "title": "عنوان الحدث",
      "description": "وصف مفصل",
      "startTime": "YYYY-MM-DDTHH:mm:ss.sssZ",
      "endTime": "YYYY-MM-DDTHH:mm:ss.sssZ",
      "location": "المكان",
      "colorIndex": 0,
      "isAllDay": false
    }
  ]
}

2. للاستفسارات العامة أو النصائح أو التوضيحات، أجب بتنسيق JSON:
{
  "type": "text",
  "message": "الرسالة النصية المفصلة"
}

مهم:
- استخدم التواريخ المستقبلية فقط (بدءاً من اليوم)
- اجعل الأوقات مناسبة لطبيعة الحدث
- راعِ المعلومات المتوفرة عن المسجد
- استخدم اللغة العربية في جميع النصوص
- تأكد من صحة تنسيق JSON
''';
  }

  Map<String, dynamic> _parseAIResponse(String response) {
    try {
      // Try to parse as JSON first
      // Remove any markdown formatting that might be in the response
      final cleanResponse = response
          .replaceAll(RegExp(r'^```json\n|^```\n|```$', multiLine: true), '')
          .trim();
      final jsonResponse = json.decode(cleanResponse);

      if (jsonResponse['type'] == 'events' && jsonResponse['events'] != null) {
        // Parse events
        final List<CalendarEvent> events = [];
        for (final eventData in jsonResponse['events']) {
          try {
            final event = CalendarEvent(
              id: _eventService.generateEventId(),
              title: eventData['title'] ?? 'حدث',
              description: eventData['description'] ?? '',
              startTime: DateTime.parse(eventData['startTime']),
              endTime: DateTime.parse(eventData['endTime']),
              location: eventData['location'],
              colorIndex: eventData['colorIndex'] ?? 0,
              isAllDay: eventData['isAllDay'] ?? false,
            );
            events.add(event);
          } catch (e) {
            print('Error parsing event: $e');
          }
        }

        return {
          'type': 'events',
          'message': jsonResponse['message'] ?? 'إليك الأحداث المقترحة:',
          'events': events,
        };
      } else if (jsonResponse['type'] == 'text') {
        return {
          'type': 'text',
          'message': jsonResponse['message'] ?? response,
        };
      }
    } catch (e) {
      print('Error parsing JSON response: $e');
    }

    // Fallback to text response
    return {
      'type': 'text',
      'message': response,
    };
  }

  // Helper method to check if API key is configured
  static bool isConfigured() {
    return _apiKey != 'YOUR_OPENAI_API_KEY_HERE' && _apiKey.isNotEmpty;
  }

  // Mock response for testing when API key is not configured
  Map<String, dynamic> getMockResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('حدث') ||
        message.contains('فعالية') ||
        message.contains('برنامج')) {
      return {
        'type': 'events',
        'message':
            'إليك اقتراح للأحداث (نسخة تجريبية - يرجى إعداد مفتاح OpenAI للحصول على ردود ذكية):',
        'events': _generateMockEvents(),
      };
    } else {
      return {
        'type': 'text',
        'message':
            'شكراً لرسالتك. هذه نسخة تجريبية. لتفعيل الذكاء الاصطناعي الكامل، يرجى إعداد مفتاح OpenAI في الخدمة.\n\nيمكنني مساعدتك في:\n• التخطيط السنوي للمسجد\n• اقتراح فعاليات دينية وتعليمية\n• تنظيم البرامج حسب الفئات العمرية\n• إدارة الأحداث والمواسم الدينية',
      };
    }
  }

  List<CalendarEvent> _generateMockEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(
        id: _eventService.generateEventId(),
        title: 'درس التفسير الأسبوعي',
        description: 'درس في تفسير القرآن الكريم',
        startTime: now.add(Duration(days: 3)).copyWith(hour: 19, minute: 0),
        endTime: now.add(Duration(days: 3)).copyWith(hour: 21, minute: 0),
        location: 'قاعة المحاضرات',
        colorIndex: 1,
      ),
      CalendarEvent(
        id: _eventService.generateEventId(),
        title: 'حلقة تحفيظ القرآن للأطفال',
        description: 'حلقة تحفيظ للأطفال من سن 6-12',
        startTime: now.add(Duration(days: 7)).copyWith(hour: 16, minute: 0),
        endTime: now.add(Duration(days: 7)).copyWith(hour: 17, minute: 30),
        location: 'قاعة الأطفال',
        colorIndex: 2,
      ),
    ];
  }
}
