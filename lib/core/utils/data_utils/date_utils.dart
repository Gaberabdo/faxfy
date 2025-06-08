import 'package:flutter/material.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  static Future<DateTime?> showAppDatePicker(
    BuildContext context, {
    required DateTime initialDate,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ar', ''),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E2756),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E2756),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> showAppTimePicker(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E2756),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E2756),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
