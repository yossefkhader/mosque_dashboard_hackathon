import 'package:flutter/material.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool _isAnnual = true;

  final List<bool> _selectedType = [true, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Form(
        key: _formKey,
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
              child: Text(
                'اطلب من الذكاء الاصطناعي مساعدتك ببناء البرنامج السنوي',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              isSelected: _selectedType,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < _selectedType.length; i++) {
                    _selectedType[i] = i == index;
                  } 
                  _isAnnual = !_isAnnual;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('برنامج لحدث فردي', style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('برنامج سنوي', style: TextStyle(fontSize: 16)),
                ),
                
              ],
            ),
            const SizedBox(height: 20),
            _isAnnual ?  Expanded(child: BotChat()) : Expanded(child: Container(color: Colors.red,))

          ],
        )
      ),
    );
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print("hih");
    } else {
      print("byb");
    }
  }
}

class BotChat extends StatefulWidget {
  const BotChat({super.key});

  @override
  State<BotChat> createState() => _BotChatState();
}

class _BotChatState extends State<BotChat> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _showApprovalButtons = false;
  Map<String, dynamic>? _currentProposal;

  void _handleBotResponse(String userMessage) {
    // Simulate bot response with JSON data
    final Map<String, dynamic> proposal = {
      'eventName': 'مثال لحدث',
      'date': '2024-01-01',
      'budget': 1000,
      'activities': ['فعالية 1', 'فعالية 2']
    };
    
    setState(() {
      _currentProposal = proposal;
      _messages.add({
        'message': 'هذا الاقتراح\n' +
                   'الحدث: ${proposal['eventName']}\n' +
                   'التاريخ: ${proposal['date']}\n' +
                   'الميزانية: \$${proposal['budget']}\n' +
                   'الفعاليات: ${proposal['activities'].join(", ")}',
        'sender': 'bot',
        'isJson': true
      });
      _showApprovalButtons = true;
    });
  }

  void _handleApproval(bool approved) {
    setState(() {
      _messages.add({
        'message': approved ? 'Proposal approved!' : 'Proposal rejected.',
        'sender': 'user'
      });
      _showApprovalButtons = false;
      _currentProposal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
                alignment: message['sender'] == 'user' 
                    ? Alignment.centerRight 
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message['sender'] == 'user' ? Colors.blue[700] : Colors.grey[800],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message['sender'] == 'bot')
                        const Icon(Icons.smart_toy, color: Color(0xFFFFD700), size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message['message'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_showApprovalButtons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _handleApproval(true),
                child: const Text('Approve'),
              ),
              ElevatedButton(
                onPressed: () => _handleApproval(false),
                child: const Text('Reject'),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    setState(() {
                      _messages.add({
                        'message': _messageController.text,
                        'sender': 'user'
                      });
                      _handleBotResponse(_messageController.text);
                      _messageController.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}