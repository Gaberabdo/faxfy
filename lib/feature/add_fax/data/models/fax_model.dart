import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

class FaxModel extends FaxEntities {
  FaxModel({
    required super.faxType,
    required super.faxId,
    required super.index,
    required super.senderName,
    required super.subject,
    required super.faxAddress,
    required super.receiverName,
    required super.note,
    required super.toInform,
    required super.dateTime,
    required super.linkedFaxId,
    required super.followDate,
    super.edited = false,
    super.viewed = false,
  });

  @override
  String get formattedDate {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  factory FaxModel.fromJson(Map<String, dynamic> json) {
    return FaxModel(
      faxType: json['fax_type'],
      faxId: json['fax_id'],
      index: json['index'] ?? 0,
      subject: json['subject'],
      faxAddress: json['address'],
      linkedFaxId: json['linked_fax'] ?? '',
      receiverName: json['receiver'],
      senderName: json['sender'] ?? '',
      note: json['note'] ?? '',
      toInform:
          json['to_inform'] != null
              ? List<ToInformModel>.from(
                json['to_inform'].map((item) => ToInformModel.fromJson(item)),
              )
              : [],
      followDate: json['follow_date'] ?? '',
      dateTime: DateTime.parse(json['date']),
      edited: json['edited'] ?? false,
      viewed: json['viewed'],
    );
  }
}

class ToInformModel extends ToInformEntities {
  ToInformModel(
    super.username,
    super.status,
    super.note1, {
    super.note2,
    super.isSelect,
  });

  factory ToInformModel.fromJson(Map<String, dynamic> json) {
    return ToInformModel(
      json['name'],
      json['status'],
      json['note1'],
      note2: json['note2'],
      isSelect: false,
    );
  }
}
