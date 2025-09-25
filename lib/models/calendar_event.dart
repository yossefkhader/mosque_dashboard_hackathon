import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final int colorIndex; // Index for color selection
  final bool isAllDay;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.colorIndex = 0,
    this.isAllDay = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'colorIndex': colorIndex,
      'isAllDay': isAllDay,
    };
  }

  // Create from JSON
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      colorIndex: json['colorIndex'] ?? 0,
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  // Convert to Syncfusion Appointment
  Appointment toAppointment() {
    final colors = [
      const Color(0xFFFFD700), // Gold (default)
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFF44336), // Red
    ];

    return Appointment(
      id: id,
      startTime: startTime,
      endTime: endTime,
      subject: title,
      notes: description,
      location: location,
      color: colors[colorIndex % colors.length],
      isAllDay: isAllDay,
    );
  }

  // Create from Syncfusion Appointment
  factory CalendarEvent.fromAppointment(
      Appointment appointment, int colorIndex) {
    return CalendarEvent(
      id: appointment.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: appointment.subject,
      description: appointment.notes ?? '',
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      location: appointment.location,
      colorIndex: colorIndex,
      isAllDay: appointment.isAllDay,
    );
  }

  // Create a copy with updated fields
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    int? colorIndex,
    bool? isAllDay,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      colorIndex: colorIndex ?? this.colorIndex,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }
}
