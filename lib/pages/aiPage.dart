import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../services/event_service.dart';
import '../services/mosque_context_service.dart';
import '../services/openai_service.dart';

class AIPage extends StatefulWidget {
  final VoidCallback? onEventsAdded;

  const AIPage({super.key, this.onEventsAdded});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الاستعانة بالذكاء الاصطناعي',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'اطلب من الذكاء الاصطناعي مساعدتك ببناء البرنامج السنوي',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'أمثلة: اقترح حدث رمضان • برنامج للأطفال • جدول شهري',
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: BotChat(onEventsAdded: widget.onEventsAdded))
        ],
      ),
    );
  }
}

class BotChat extends StatefulWidget {
  final VoidCallback? onEventsAdded;

  const BotChat({super.key, this.onEventsAdded});

  @override
  State<BotChat> createState() => _BotChatState();
}

class _BotChatState extends State<BotChat> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _showApprovalButtons = false;
  List<CalendarEvent>? _currentEventProposals;
  final EventService _eventService = EventService();
  final MosqueContextService _contextService = MosqueContextService();
  final OpenAIService _openAIService = OpenAIService();
  final ScrollController _scrollController = ScrollController();
  List<String> _contextualSuggestions = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // Load contextual suggestions
    _contextualSuggestions = await _contextService.getContextualSuggestions();

    // Send initial greeting
    final greeting = await _contextService.getPersonalizedGreeting();
    setState(() {
      _messages.add({
        'message': greeting,
        'sender': 'bot',
        'isEventProposal': false,
      });
    });
  }

  void _handleBotResponse(String userMessage) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      Map<String, dynamic> aiResponse;

      // Use OpenAI if configured, otherwise use mock responses
      if (OpenAIService.isConfigured()) {
        aiResponse = await _openAIService.sendMessage(userMessage);
      } else {
        aiResponse = _openAIService.getMockResponse(userMessage);
      }

      final responseType = aiResponse['type'] as String;
      final message = aiResponse['message'] as String;

      if (responseType == 'events' && aiResponse['events'] != null) {
        final events = aiResponse['events'] as List<CalendarEvent>;

        setState(() {
          _currentEventProposals = events;
          _messages.add({
            'message': message,
            'sender': 'bot',
            'isEventProposal': true,
            'events': events
          });
          _showApprovalButtons = true;
          _isProcessing = false;
        });
      } else {
        setState(() {
          _messages.add({
            'message': message,
            'sender': 'bot',
            'isEventProposal': false,
          });
          _showApprovalButtons = false;
          _isProcessing = false;
        });
      }
    } catch (e) {
      // Handle errors gracefully
      setState(() {
        _messages.add({
          'message':
              'عذراً، حدث خطأ في معالجة طلبك. يرجى المحاولة مرة أخرى.\n\nتفاصيل الخطأ: ${e.toString()}',
          'sender': 'bot',
          'isEventProposal': false,
        });
        _showApprovalButtons = false;
        _isProcessing = false;
      });
    }

    _scrollToBottom();
  }

  void _handleApproval(bool approved) async {
    if (_currentEventProposals == null) return;

    setState(() {
      _messages.add({
        'message':
            approved ? 'تم قبول الأحداث المقترحة!' : 'تم رفض الأحداث المقترحة.',
        'sender': 'user'
      });
      _showApprovalButtons = false;
    });

    if (approved) {
      try {
        // Load current events
        final currentEvents = await _eventService.loadEvents();

        // Add all proposed events
        for (final event in _currentEventProposals!) {
          await _eventService.addEvent(event, currentEvents);
        }

        setState(() {
          _messages.add({
            'message':
                'تم إضافة ${_currentEventProposals!.length} حدث إلى التقويم بنجاح!',
            'sender': 'bot'
          });
        });

        // Show success message and trigger calendar refresh
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'تم إضافة ${_currentEventProposals!.length} حدث إلى التقويم'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Trigger calendar refresh callback
        widget.onEventsAdded?.call();
      } catch (e) {
        setState(() {
          _messages.add(
              {'message': 'حدث خطأ أثناء إضافة الأحداث: $e', 'sender': 'bot'});
        });
      }
    }

    _currentEventProposals = null;
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && !_isProcessing) {
      final messageText = _messageController.text;
      setState(() {
        _messages.add({'message': messageText, 'sender': 'user'});
      });
      _messageController.clear();
      _handleBotResponse(messageText);
      _scrollToBottom();
    }
  }

  Widget _buildEventPreview(List<CalendarEvent> events) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFFD700), width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event, color: Color(0xFFFFD700), size: 16),
                SizedBox(width: 8),
                Text(
                  'عدد الأحداث: ${events.length}',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxHeight: events.length < 3 ? 200.0 : double.infinity,
              ),
              child: events.length <= 3
                  ? Column(
                      children: events
                          .map((event) => _buildEventItem(event))
                          .toList(),
                    )
                  : Column(
                      children: [
                        ...events
                            .take(2)
                            .map((event) => _buildEventItem(event)),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'و ${events.length - 2} حدث آخر...',
                            style: TextStyle(
                              color: Colors.white60,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'عرض جميع الأحداث',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          iconColor: Colors.white70,
                          collapsedIconColor: Colors.white70,
                          children: events
                              .skip(2)
                              .map((event) => _buildEventItem(event))
                              .toList(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(CalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (event.description.isNotEmpty)
            Text(
              event.description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white60, size: 12),
              SizedBox(width: 4),
              Text(
                '${_formatDateTime(event.startTime)}',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                ),
              ),
              if (event.location != null && event.location!.isNotEmpty) ...[
                SizedBox(width: 12),
                Icon(Icons.location_on, color: Colors.white60, size: 12),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location!,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year - $hour:$minute';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
                alignment: message['sender'] == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message['sender'] == 'user'
                        ? Colors.blue[700]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message['sender'] == 'bot')
                            const Icon(Icons.smart_toy,
                                color: Color(0xFFFFD700), size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              message['message'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      if (message['isEventProposal'] == true &&
                          message['events'] != null)
                        _buildEventPreview(
                            message['events'] as List<CalendarEvent>),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_showApprovalButtons)
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'هل تريد قبول هذه الأحداث وإضافتها إلى التقويم؟',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _handleApproval(true),
                      icon: Icon(Icons.check),
                      label: Text('قبول وإضافة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _handleApproval(false),
                      icon: Icon(Icons.close),
                      label: Text('رفض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (_contextualSuggestions.isNotEmpty &&
            !_showApprovalButtons &&
            !_isProcessing)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اقتراحات سريعة:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _contextualSuggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(
                        suggestion,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Colors.grey[700],
                      onPressed: _isProcessing
                          ? null
                          : () {
                              _messageController.text = suggestion;
                              _sendMessage();
                            },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Color(0xFFFFD700)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: _isProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFD700),
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.send, color: Color(0xFFFFD700)),
                  onPressed: _isProcessing ? null : _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
