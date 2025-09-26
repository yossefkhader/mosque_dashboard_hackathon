import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appConsts.dart';
import '../models/course.dart';
import '../services/progress_service.dart';

class LessonReaderPage extends StatefulWidget {
  final Course course;
  final String moduleId;
  final Lesson lesson;
  final Function(bool completed) onLessonCompleted;

  const LessonReaderPage({
    Key? key,
    required this.course,
    required this.moduleId,
    required this.lesson,
    required this.onLessonCompleted,
  }) : super(key: key);

  @override
  _LessonReaderPageState createState() => _LessonReaderPageState();
}

class _LessonReaderPageState extends State<LessonReaderPage> {
  final ProgressService _progressService = ProgressService.instance;
  final ScrollController _scrollController = ScrollController();

  late bool _isCompleted;
  late Map<String, bool> _checklistState;
  int? _selectedQuizAnswer;
  bool _quizSubmitted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted =
        _progressService.isLessonCompleted(widget.course.id, widget.lesson.id);
    _checklistState = _progressService.getChecklistState(widget.lesson.id);
    _selectedQuizAnswer = _progressService.getQuizAnswer(widget.lesson.id);
    _quizSubmitted = _progressService.hasAnsweredQuiz(widget.lesson.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.course.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppConsts.primaryColor,
        appBar: AppBar(
          backgroundColor: AppConsts.primaryColor,
          foregroundColor: AppConsts.secondaryColor,
          title: Text(
            widget.lesson.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _toggleCompletion,
              icon: Icon(
                _isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: _isCompleted ? Colors.green : AppConsts.secondaryColor,
              ),
              tooltip: _isCompleted ? 'إلغاء اكتمال الدرس' : 'تمييز كمكتمل',
            ),
          ],
        ),
        body: _buildLessonContent(),
        floatingActionButton: _buildCompletionFab(),
      ),
    );
  }

  Widget _buildLessonContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLessonHeader(),
          const SizedBox(height: 24),
          ..._buildContentSections(),
        ],
      ),
    );
  }

  Widget _buildLessonHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConsts.polor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConsts.secondaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.lesson.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppConsts.secondaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isCompleted
                      ? Colors.green.withOpacity(0.2)
                      : AppConsts.secondaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isCompleted ? Icons.check : Icons.circle_outlined,
                  color: _isCompleted ? Colors.green : AppConsts.secondaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          if (widget.lesson.contentIndicators.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: widget.lesson.contentIndicators.map((indicator) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConsts.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    indicator,
                    style: const TextStyle(
                      color: AppConsts.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildContentSections() {
    final sections = <Widget>[];

    if (widget.lesson.objectives?.isNotEmpty == true) {
      sections.add(_buildObjectivesSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.steps?.isNotEmpty == true) {
      sections.add(_buildStepsSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.checklist?.isNotEmpty == true) {
      sections.add(_buildChecklistSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.assignment != null) {
      sections.add(_buildAssignmentSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.links?.isNotEmpty == true) {
      sections.add(_buildLinksSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.quiz != null) {
      sections.add(_buildQuizSection());
      sections.add(const SizedBox(height: 24));
    }

    if (widget.lesson.downloadables?.isNotEmpty == true) {
      sections.add(_buildDownloadablesSection());
      sections.add(const SizedBox(height: 24));
    }

    return sections;
  }

  Widget _buildObjectivesSection() {
    return _buildSection(
      title: 'أهداف الدرس',
      icon: Icons.flag,
      child: Column(
        children: widget.lesson.objectives!.map((objective) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6, left: 8, right: 8),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppConsts.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    objective,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepsSection() {
    return _buildSection(
      title: 'خطوات التطبيق',
      icon: Icons.list_alt,
      child: Column(
        children: widget.lesson.steps!.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppConsts.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppConsts.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChecklistSection() {
    return _buildSection(
      title: 'قائمة التحقق',
      icon: Icons.checklist,
      child: Column(
        children: widget.lesson.checklist!.map((item) {
          final isChecked = _checklistState[item] ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _toggleChecklistItem(item),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppConsts.secondaryColor.withOpacity(0.1)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isChecked
                        ? AppConsts.secondaryColor.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isChecked
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color:
                          isChecked ? AppConsts.secondaryColor : Colors.white60,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: isChecked
                              ? AppConsts.secondaryColor
                              : Colors.white,
                          fontSize: 15,
                          decoration:
                              isChecked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAssignmentSection() {
    return _buildSection(
      title: 'المهمة',
      icon: Icons.assignment,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.lesson.assignment!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return _buildSection(
      title: 'روابط مفيدة',
      icon: Icons.link,
      child: Column(
        children: widget.lesson.links!.map((link) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _openUrl(link.url),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.open_in_new,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        link.label,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizSection() {
    final quiz = widget.lesson.quiz!;

    return _buildSection(
      title: 'اختبار سريع',
      icon: Icons.quiz,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Text(
              quiz.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...quiz.choices.asMap().entries.map((entry) {
            final index = entry.key;
            final choice = entry.value;
            final isSelected = _selectedQuizAnswer == index;
            final isCorrect = index == quiz.answerIndex;
            final showResult = _quizSubmitted;

            Color backgroundColor;
            Color borderColor;
            Color textColor = Colors.white;

            if (showResult) {
              if (isCorrect) {
                backgroundColor = Colors.green.withOpacity(0.2);
                borderColor = Colors.green;
                textColor = Colors.green;
              } else if (isSelected && !isCorrect) {
                backgroundColor = Colors.red.withOpacity(0.2);
                borderColor = Colors.red;
                textColor = Colors.red;
              } else {
                backgroundColor = Colors.white.withOpacity(0.05);
                borderColor = Colors.white.withOpacity(0.2);
                textColor = Colors.white60;
              }
            } else {
              if (isSelected) {
                backgroundColor = AppConsts.secondaryColor.withOpacity(0.2);
                borderColor = AppConsts.secondaryColor;
                textColor = AppConsts.secondaryColor;
              } else {
                backgroundColor = Colors.white.withOpacity(0.05);
                borderColor = Colors.white.withOpacity(0.2);
              }
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: showResult ? null : () => _selectQuizAnswer(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: textColor),
                          color: isSelected ? textColor : Colors.transparent,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: showResult && isCorrect
                                    ? Colors.white
                                    : AppConsts.primaryColor,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          choice,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (showResult && isCorrect)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (!_quizSubmitted && _selectedQuizAnswer != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConsts.secondaryColor,
                  foregroundColor: AppConsts.primaryColor,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('إرسال الإجابة'),
              ),
            ),
          ],
          if (_quizSubmitted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_selectedQuizAnswer == quiz.answerIndex
                        ? Colors.green
                        : Colors.orange)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (_selectedQuizAnswer == quiz.answerIndex
                          ? Colors.green
                          : Colors.orange)
                      .withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedQuizAnswer == quiz.answerIndex
                        ? Icons.check_circle
                        : Icons.info,
                    color: _selectedQuizAnswer == quiz.answerIndex
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedQuizAnswer == quiz.answerIndex
                          ? 'إجابة صحيحة! أحسنت.'
                          : 'تم حفظ إجابتك. الإجابة الصحيحة هي: ${quiz.choices[quiz.answerIndex]}',
                      style: TextStyle(
                        color: _selectedQuizAnswer == quiz.answerIndex
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDownloadablesSection() {
    return _buildSection(
      title: 'ملفات للتحميل',
      icon: Icons.download,
      child: Column(
        children: widget.lesson.downloadables!.map((downloadable) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _downloadFile(downloadable),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getFileIcon(downloadable.type),
                      color: Colors.teal,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            downloadable.filename,
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getFileTypeDescription(downloadable.type),
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConsts.secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppConsts.secondaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppConsts.secondaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget? _buildCompletionFab() {
    return FloatingActionButton.extended(
      onPressed: _toggleCompletion,
      backgroundColor: _isCompleted ? Colors.green : AppConsts.secondaryColor,
      foregroundColor: Colors.white,
      icon: Icon(_isCompleted ? Icons.check_circle : Icons.circle_outlined),
      label: Text(_isCompleted ? 'مكتمل' : 'تمييز كمكتمل'),
    );
  }

  void _toggleCompletion() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    widget.onLessonCompleted(_isCompleted);
  }

  void _toggleChecklistItem(String item) {
    setState(() {
      _checklistState[item] = !(_checklistState[item] ?? false);
    });
    _progressService.setChecklistItem(
        widget.lesson.id, item, _checklistState[item]!);
    _progressService.saveChecklistState();
  }

  void _selectQuizAnswer(int answerIndex) {
    setState(() {
      _selectedQuizAnswer = answerIndex;
    });
  }

  void _submitQuiz() {
    if (_selectedQuizAnswer != null) {
      setState(() {
        _quizSubmitted = true;
      });
      _progressService.saveQuizAnswer(widget.lesson.id, _selectedQuizAnswer!);
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorMessage('لا يمكن فتح الرابط: $url');
      }
    } catch (e) {
      _showErrorMessage('خطأ في فتح الرابط: $e');
    }
  }

  void _downloadFile(Downloadable downloadable) {
    try {
      // Create file content
      final content = downloadable.content;
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create and trigger download
      html.AnchorElement(href: url)
        ..setAttribute('download', downloadable.filename)
        ..click();

      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل ${downloadable.filename}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorMessage('خطأ في تحميل الملف: $e');
    }
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'csv-template':
        return Icons.table_chart;
      case 'text-template':
        return Icons.text_snippet;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.file_present;
    }
  }

  String _getFileTypeDescription(String type) {
    switch (type.toLowerCase()) {
      case 'csv-template':
        return 'قالب جدول بيانات';
      case 'text-template':
        return 'قالب نصي';
      case 'pdf':
        return 'ملف PDF';
      default:
        return 'ملف';
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
