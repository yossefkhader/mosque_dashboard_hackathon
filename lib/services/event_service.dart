import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calendar_event.dart';

class EventService {
  static const String _storageKey = 'mosque_events';
  static const String _assetsPath = 'lib/assets/events.json';

  // Load events from local storage or assets (on first run)
  Future<List<CalendarEvent>> loadEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEvents = prefs.getString(_storageKey);

      if (storedEvents != null) {
        // Load from local storage
        final List<dynamic> jsonList = json.decode(storedEvents);
        return jsonList.map((json) => CalendarEvent.fromJson(json)).toList();
      } else {
        // First time loading - load from assets
        return await _loadFromAssets();
      }
    } catch (e) {
      print('Error loading events: $e');
      // Fallback to assets if local storage fails
      return await _loadFromAssets();
    }
  }

  // Load events from assets (initial load)
  Future<List<CalendarEvent>> _loadFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetsPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      final events =
          jsonList.map((json) => CalendarEvent.fromJson(json)).toList();

      // Save to local storage for future use
      await _saveToLocalStorage(events);
      return events;
    } catch (e) {
      print('Error loading from assets: $e');
      // Return empty list if assets file doesn't exist
      return [];
    }
  }

  // Save events to local storage
  Future<void> _saveToLocalStorage(List<CalendarEvent> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString =
          json.encode(events.map((event) => event.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving to local storage: $e');
    }
  }

  // Save all events
  Future<void> saveEvents(List<CalendarEvent> events) async {
    await _saveToLocalStorage(events);
  }

  // Add a new event
  Future<void> addEvent(
      CalendarEvent event, List<CalendarEvent> currentEvents) async {
    currentEvents.add(event);
    await _saveToLocalStorage(currentEvents);
  }

  // Update an existing event
  Future<void> updateEvent(
      CalendarEvent updatedEvent, List<CalendarEvent> currentEvents) async {
    final index =
        currentEvents.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      currentEvents[index] = updatedEvent;
      await _saveToLocalStorage(currentEvents);
    }
  }

  // Delete an event
  Future<void> deleteEvent(
      String eventId, List<CalendarEvent> currentEvents) async {
    currentEvents.removeWhere((event) => event.id == eventId);
    await _saveToLocalStorage(currentEvents);
  }

  // Generate a unique ID for new events
  String generateEventId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Import events from uploaded JSON file
  Future<List<CalendarEvent>?> importEventsFromJson(String jsonString) async {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CalendarEvent.fromJson(json)).toList();
    } catch (e) {
      print('Error importing events: $e');
      return null;
    }
  }
}
