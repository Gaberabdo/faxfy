import 'package:flutter/material.dart';

class AppointmentModel {
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final String? location;
  final String? notes;
  final Color color;

  AppointmentModel({
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.location,
    this.notes,
    required this.color,
  });

  // Create a copy of the appointment with some fields changed
  AppointmentModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    String? subject,
    String? location,
    String? notes,
    Color? color,
  }) {
    return AppointmentModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      color: color ?? this.color,
    );
  }
}
