import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../appConsts.dart';

class EventDialog extends StatefulWidget {
  final CalendarEvent? event; // null for new event, populated for editing
  final Function(CalendarEvent) onSave;
  final Function(String)? onDelete; // null for new events

  const EventDialog({
    Key? key,
    this.event,
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late int _selectedColorIndex;
  late bool _isAllDay;

  final List<Color> _eventColors = [
    const Color(0xFFFFD700), // Gold
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFF9800), // Orange
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFF44336), // Red
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.event != null) {
      // Edit mode
      _titleController = TextEditingController(text: widget.event!.title);
      _descriptionController =
          TextEditingController(text: widget.event!.description);
      _locationController =
          TextEditingController(text: widget.event!.location ?? '');
      _startDate = widget.event!.startTime;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
      _endDate = widget.event!.endTime;
      _endTime = TimeOfDay.fromDateTime(widget.event!.endTime);
      _selectedColorIndex = widget.event!.colorIndex;
      _isAllDay = widget.event!.isAllDay;
    } else {
      // Create mode
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _locationController = TextEditingController();
      final now = DateTime.now();
      _startDate = now;
      _startTime = TimeOfDay.fromDateTime(now);
      _endDate = now.add(const Duration(hours: 1));
      _endTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));
      _selectedColorIndex = 0;
      _isAllDay = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConsts.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                      const SizedBox(height: 16),
                      _buildLocationField(),
                      const SizedBox(height: 16),
                      _buildAllDaySwitch(),
                      const SizedBox(height: 16),
                      _buildDateTimeFields(),
                      const SizedBox(height: 16),
                      _buildColorSelector(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.event == null ? 'إضافة حدث جديد' : 'تعديل الحدث',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConsts.secondaryColor,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'عنوان الحدث',
        labelStyle: const TextStyle(color: AppConsts.secondaryColor),
        filled: true,
        fillColor: AppConsts.polor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال عنوان الحدث';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      style: const TextStyle(color: Colors.white),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'وصف الحدث',
        labelStyle: const TextStyle(color: AppConsts.secondaryColor),
        filled: true,
        fillColor: AppConsts.polor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'مكان الحدث',
        labelStyle: const TextStyle(color: AppConsts.secondaryColor),
        filled: true,
        fillColor: AppConsts.polor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAllDaySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'طوال اليوم',
          style: TextStyle(color: AppConsts.secondaryColor, fontSize: 16),
        ),
        Switch(
          value: _isAllDay,
          onChanged: (value) => setState(() => _isAllDay = value),
          activeColor: AppConsts.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildDateTimeFields() {
    return Column(
      children: [
        _buildDateTimeRow('تاريخ البداية', _startDate, _startTime, true),
        const SizedBox(height: 12),
        _buildDateTimeRow('تاريخ النهاية', _endDate, _endTime, false),
      ],
    );
  }

  Widget _buildDateTimeRow(
      String label, DateTime date, TimeOfDay time, bool isStart) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style:
                const TextStyle(color: AppConsts.secondaryColor, fontSize: 16),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(isStart),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppConsts.polor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!_isAllDay)
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(isStart),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppConsts.polor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'لون الحدث',
          style: TextStyle(color: AppConsts.secondaryColor, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(_eventColors.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => _selectedColorIndex = index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _eventColors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColorIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: _selectedColorIndex == index
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.event != null && widget.onDelete != null)
          ElevatedButton.icon(
            onPressed: () {
              _showDeleteConfirmation();
            },
            icon: const Icon(Icons.delete),
            label: const Text('حذف'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ElevatedButton.icon(
          onPressed: _saveEvent,
          icon: const Icon(Icons.save),
          label: Text(widget.event == null ? 'إضافة' : 'حفظ'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConsts.secondaryColor,
            foregroundColor: AppConsts.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConsts.secondaryColor,
              onPrimary: AppConsts.primaryColor,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // If start date is after end date, update end date
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate.add(const Duration(hours: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConsts.secondaryColor,
              onPrimary: AppConsts.primaryColor,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _isAllDay ? 0 : _startTime.hour,
        _isAllDay ? 0 : _startTime.minute,
      );

      final endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _isAllDay ? 23 : _endTime.hour,
        _isAllDay ? 59 : _endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تاريخ النهاية يجب أن يكون بعد تاريخ البداية'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final event = CalendarEvent(
        id: widget.event?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        startTime: startDateTime,
        endTime: endDateTime,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        colorIndex: _selectedColorIndex,
        isAllDay: _isAllDay,
      );

      widget.onSave(event);
      Navigator.of(context).pop();
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConsts.primaryColor,
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(color: AppConsts.secondaryColor),
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذا الحدث؟',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete!(widget.event!.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
