import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

abstract class BaseAddFaxRepository {
  Future<Either<Failure, String>> addFaxOrEdit(FaxPrams prams);
  Future<Either<Failure, String>> getFaxIndex(String faxType);
  Future<Either<Failure, List<String>>> getFaxAddress();
  Future<Either<Failure, File>> getPdfFile(String faxId);
  Future<Either<Failure, List<FaxEntities>>> getFaxes(GetFaxPrams prams);
}

class FaxPrams {
  final File localPdfFile;
  final String sender;
  final String receiver;
  final String subject;
  final String date;
  final String faxType;
  final String address;
  final int index;
  final List<ToInformEntities> informList;
  String? note;
  String faxId;
  String? followDate;
  String? linkFax;

  FaxPrams(
    this.localPdfFile,
    this.sender,
    this.receiver,
    this.subject,
    this.date,
    this.followDate,
    this.faxType,
    this.address,
    this.note,
    this.faxId,
    this.informList,
    this.index,
    this.linkFax,
  );

  Map<String, dynamic> toMap() => {
    'fax_type': faxType,
    'index': index,
    'subject': subject,
    'date': date,
    'address': address,
    'to_inform': informList.map((e) => e.toJson()).toList(),
    'local_file': localPdfFile.toString(),
    'receiver': receiver,
    if (faxType == 'sader') 'sender': sender,
    if (note != null) 'note': note,
    if (faxId.isNotEmpty) 'fax_id': faxId,
    if (followDate != '') 'follow_date': followDate,
    if (linkFax != '') 'linked_fax': linkFax,
  };
}

class GetFaxPrams {
  final bool isFollow;
  final bool isToday;
  final bool isSader;
  final bool isWared;

  GetFaxPrams(this.isFollow, this.isToday, this.isSader, this.isWared);

  toMap() => {
    'is_follow': isFollow,
    'is_today': isToday,
    'is_sader': isSader,
    'is_wared': isWared,
  };
}
