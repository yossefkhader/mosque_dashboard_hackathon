import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/openai_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _prioritiesController = TextEditingController();
  final TextEditingController _audiencesController = TextEditingController();
  final TextEditingController _specialNeedsController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('mosque_context');

      if (savedData != null) {
        final data = json.decode(savedData);
        setState(() {
          _prioritiesController.text = data['priorities'] ?? '';
          _audiencesController.text = data['audiences'] ?? '';
          _specialNeedsController.text = data['specialNeeds'] ?? '';
          _capacityController.text = data['capacity'] ?? '';
          _notesController.text = data['notes'] ?? '';
          _isSaved = true;
        });
      }
    } catch (e) {
      print('Error loading saved data: $e');
    }
  }

  Future<void> _saveData() async {
    // if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'priorities': _prioritiesController.text.trim(),
        'audiences': _audiencesController.text.trim(),
        'specialNeeds': _specialNeedsController.text.trim(),
        'capacity': _capacityController.text.trim(),
        'notes': _notesController.text.trim(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mosque_context', json.encode(data));

      setState(() {
        _isSaved = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ إعدادات المسجد بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في حفظ البيانات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _prioritiesController.dispose();
    _audiencesController.dispose();
    _specialNeedsController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إعدادات المسجد',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'أجب على الأسئلة التالية لمساعدة الذكاء الاصطناعي في تقديم اقتراحات أفضل',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 20),
          _buildAIStatusCard(),
          SizedBox(height: 30),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQuestionField(
                      controller: _prioritiesController,
                      question: 'ما الأولويات الثلاث الأهم لديك؟',
                      hint: 'مثال: تحفيظ القرآن، الأسرة، الشباب',
                      maxLines: 3,
                    ),
                    SizedBox(height: 25),
                    _buildQuestionField(
                      controller: _audiencesController,
                      question: 'ما الشرائح الأساسية التي نخدمها في المسجد؟',
                      hint:
                          'أطفال، شباب، نساء، عائلات، جدد بالإسلام، كبار سن...',
                      maxLines: 3,
                    ),
                    SizedBox(height: 25),
                    _buildQuestionField(
                      controller: _specialNeedsController,
                      question: 'احتياجات خاصة يجب مراعاتها؟',
                      hint: 'إعاقة سمعية/حركية، لغة، دعم نفسي',
                      maxLines: 3,
                      required: false,
                    ),
                    SizedBox(height: 25),
                    _buildQuestionField(
                      controller: _capacityController,
                      question: 'سعة المسجد والقاعات الملحقة؟ موقف سيارات؟',
                      hint: 'مثال: 350 مصلٍ، قاعتان 80+40، 25 موقف',
                      maxLines: 3,
                    ),
                    SizedBox(height: 25),
                    _buildQuestionField(
                      controller: _notesController,
                      question: 'ملاحظات إضافية:',
                      hint: 'أي معلومات أخرى مهمة عن المسجد...',
                      maxLines: 4,
                      required: false,
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFD700),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text('جاري الحفظ...'),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_isSaved ? Icons.check : Icons.save),
                                      SizedBox(width: 8),
                                      Text(_isSaved
                                          ? 'تم الحفظ'
                                          : 'حفظ الإعدادات'),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: _clearData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.clear),
                              SizedBox(width: 8),
                              Text('مسح'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionField({
    required TextEditingController controller,
    required String question,
    required String hint,
    int maxLines = 1,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFFFD700), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          validator: null,
          onChanged: (value) {
            setState(() {
              _isSaved = false;
            });
          },
        ),
      ],
    );
  }

  void _clearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(
          'مسح البيانات',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'هل أنت متأكد من مسح جميع البيانات؟',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _prioritiesController.clear();
                _audiencesController.clear();
                _specialNeedsController.clear();
                _capacityController.clear();
                _notesController.clear();
                _isSaved = false;
              });
            },
            child: Text(
              'مسح',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIStatusCard() {
    final bool isConfigured = OpenAIService.isConfigured();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isConfigured
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        border: Border.all(
          color: isConfigured ? Colors.green : Colors.orange,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isConfigured ? Icons.check_circle : Icons.warning,
            color: isConfigured ? Colors.green : Colors.orange,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConfigured
                      ? 'الذكاء الاصطناعي متصل'
                      : 'الذكاء الاصطناعي غير متصل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isConfigured
                      ? 'تم إعداد مفتاح OpenAI بنجاح. يمكن للذكاء الاصطناعي تقديم ردود ذكية ومخصصة.'
                      : 'يجب إعداد مفتاح OpenAI في الكود للحصول على ردود ذكية. حالياً يتم استخدام ردود تجريبية.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                if (!isConfigured) ...[
                  SizedBox(height: 8),
                  Text(
                    'لإعداد OpenAI: قم بتحديث قيمة _apiKey في ملف openai_service.dart',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
