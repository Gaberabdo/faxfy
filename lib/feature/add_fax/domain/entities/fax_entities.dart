class FaxEntities {
  final String faxType;
  final String faxId;
  final int index;
  final String subject;
  final String faxAddress;
  final String receiverName;
  final String senderName;
  final String note;
  final List<ToInformEntities> toInform;
  final String followDate;
  final DateTime dateTime;
  final String linkedFaxId;
  final bool? viewed;
  final bool? edited;


  FaxEntities({
    required this.faxType,
    required this.faxId,
    required this.index,
    required this.subject,
    required this.faxAddress,
    required this.receiverName,
    required this.senderName,
    required this.note,
    required this.toInform,
    required this.followDate,
    required this.dateTime,
    required this.linkedFaxId,
    this.viewed,
    this.edited,
  });

  String get formattedDate {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'fax_type': faxType,
      'fax_id': faxId,
      'index': index,
      'subject': subject,
      'address': faxAddress,
      'receiver': receiverName,
      'sender': senderName,
      'note': note,
      'to_inform': toInform.map((e) => e.toJson()).toList(),
      'follow_date': followDate,
      'date': formattedDate,
      'linked_fax': linkedFaxId,
    };
  }
}

class ToInformEntities {
  final String username;
  final bool status;
  String? note1;
  bool isSelect;
  String? note2;
  String? en;

  ToInformEntities(
    this.username,
    this.status,
    this.note1, {
    this.en,
    this.isSelect = false,
    this.note2,
  });

  Map<String, dynamic> toJson() {
    final data = {'name': username, 'status': status, 'note1': note1};
    if (en != null) {
      data['en'] = en;
    }
    if (note2 != null) {
      data['note2'] = note2;
    }
    return data;
  }

  @override
  String toString() => note1 ?? username;
}
