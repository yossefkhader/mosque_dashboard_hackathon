import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../appConsts.dart';
import '../models/calendar_event.dart';
import '../services/event_service.dart';
import '../widgets/event_dialog.dart';

class CalendarPage extends StatefulWidget {
  final Function(VoidCallback)? onRefreshRequested;

  const CalendarPage({super.key, this.onRefreshRequested});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final EventService _eventService = EventService();
  List<CalendarEvent> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    // Register refresh callback with parent
    widget.onRefreshRequested?.call(_loadEvents);
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventService.loadEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل الأحداث: $e'),
          backgroundColor: AppConsts.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تقويم المسجد',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConsts.secondaryColor,
                ),
              ),
              FloatingActionButton(
                onPressed: _showAddEventDialog,
                backgroundColor: AppConsts.secondaryColor,
                foregroundColor: AppConsts.primaryColor,
                mini: true,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppConsts.secondaryColor),
                    ),
                  )
                : SfCalendar(
                    view: CalendarView.month,
                    allowedViews: [
                      CalendarView.month,
                      CalendarView.week,
                      CalendarView.day,
                      CalendarView.schedule,
                    ],
                    showNavigationArrow: true,
                    showDatePickerButton: true,
                    showTodayButton: true,
                    minDate: DateTime.now().subtract(Duration(days: 365 * 2)),
                    maxDate: DateTime.now().add(Duration(days: 365 * 2)),
                    todayTextStyle: AppConsts.secondTitleTextStyle,
                    todayHighlightColor: AppConsts.secondaryColor,
                    cellBorderColor: Colors.white,
                    backgroundColor: AppConsts.primaryColor,
                    selectionDecoration: _selectionDecoration(),
                    monthViewSettings: _monthView(),
                    headerStyle: _headerStyle(),
                    viewHeaderStyle: _viewHeaderStyle(),
                    timeSlotViewSettings: _timeTlotViewSettings(),
                    dataSource: _EventDataSource(_events),
                    onTap: _onCalendarTap,
                    allowAppointmentResize: true,
                    allowDragAndDrop: true,
                    onAppointmentResizeEnd: _onAppointmentResizeEnd,
                    timeZone: 'Israel Standard Time',
                  ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _selectionDecoration() => BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppConsts.secondaryColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      );

  MonthViewSettings _monthView() => MonthViewSettings(
          monthCellStyle: MonthCellStyle(
        textStyle: AppConsts.bodyTextStyle,
        trailingDatesBackgroundColor: Color.fromARGB(255, 37, 63, 40),
        leadingDatesBackgroundColor: Color.fromARGB(255, 37, 63, 40),
        trailingDatesTextStyle: AppConsts.trailingTextStyle,
        leadingDatesTextStyle: AppConsts.trailingTextStyle,
      ));

  CalendarHeaderStyle _headerStyle() => CalendarHeaderStyle(
        textAlign: TextAlign.center,
        backgroundColor: AppConsts.primaryColor,
        textStyle: TextStyle(
            fontStyle: FontStyle.normal,
            color: Color(0xFFffeaea),
            fontWeight: FontWeight.w500),
      );

  ViewHeaderStyle _viewHeaderStyle() => ViewHeaderStyle(
      dayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      dateTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.w500));

  TimeSlotViewSettings _timeTlotViewSettings() => TimeSlotViewSettings(
      timeInterval: Duration(hours: 2),
      timeFormat: 'HH:mm', //24h format
      timeTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ));

  // Event management methods
  void _onCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      // Tap on event - show edit dialog
      final Appointment appointment = details.appointments!.first;
      final event =
          _events.firstWhere((e) => e.id == appointment.id.toString());
      _showEditEventDialog(event);
    } else if (details.targetElement == CalendarElement.calendarCell) {
      // Tap on empty cell - show add dialog with selected date
      _showAddEventDialog(selectedDate: details.date);
    }
  }

  void _onAppointmentResizeEnd(AppointmentResizeEndDetails details) {
    final appointment = details.appointment!;
    final event = _events.firstWhere((e) => e.id == appointment.id.toString());
    final updatedEvent = event.copyWith(
      startTime: appointment.startTime,
      endTime: appointment.endTime,
    );
    _updateEvent(updatedEvent);
  }

  void _showAddEventDialog({DateTime? selectedDate}) {
    CalendarEvent? newEvent;
    if (selectedDate != null) {
      newEvent = CalendarEvent(
        id: _eventService.generateEventId(),
        title: '',
        description: '',
        startTime: selectedDate,
        endTime: selectedDate.add(const Duration(hours: 1)),
      );
    }

    showDialog(
      context: context,
      builder: (context) => EventDialog(
        event: newEvent,
        onSave: _addEvent,
      ),
    );
  }

  void _showEditEventDialog(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => EventDialog(
        event: event,
        onSave: _updateEvent,
        onDelete: _deleteEvent,
      ),
    );
  }

  Future<void> _addEvent(CalendarEvent event) async {
    try {
      await _eventService.addEvent(event, _events);
      setState(() {
        _events.add(event);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إضافة الحدث بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إضافة الحدث: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateEvent(CalendarEvent updatedEvent) async {
    try {
      await _eventService.updateEvent(updatedEvent, _events);
      setState(() {
        final index = _events.indexWhere((e) => e.id == updatedEvent.id);
        if (index != -1) {
          _events[index] = updatedEvent;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الحدث بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث الحدث: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId, _events);
      setState(() {
        _events.removeWhere((e) => e.id == eventId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الحدث بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حذف الحدث: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Event data source for Syncfusion Calendar
class _EventDataSource extends CalendarDataSource {
  _EventDataSource(List<CalendarEvent> events) {
    appointments = events.map((event) => event.toAppointment()).toList();
  }
}
