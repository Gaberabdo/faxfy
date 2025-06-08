import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  final List<FaxEntities> faxes;

  MeetingDataSource(this.faxes) {
    appointments = faxes.map(_mapFaxToAppointment).toList();
  }

  Appointment _mapFaxToAppointment(FaxEntities fax) {
    return Appointment(
      startTime: DateTime.parse(fax.followDate.toString()),
      endTime: _calculateEndTime(fax.dateTime),
      subject: fax.subject,
      notes: _buildNotes(fax),
      location: fax.faxAddress,
      id: fax.faxId,
      color: _getColorForType(fax.faxType),
    );
  }

  DateTime _calculateEndTime(DateTime startTime) {
    return startTime.add(const Duration(hours: 1)); // أو حسب نوع الفاكس
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'urgent':
        return Colors.redAccent;
      case 'normal':
        return Colors.blueAccent;
      case 'followup':
        return Colors.orange;
      default:
        return Colors.lightBlue;
    }
  }

  String _buildNotes(FaxEntities fax) {
    return '''
المرسل: ${fax.senderName ?? "غير معروف"}
المستلم: ${fax.receiverName}
ملاحظة: ${fax.note}
تاريخ المتابعة: ${fax.followDate ?? "لا يوجد"}
    ''';
  }
}
