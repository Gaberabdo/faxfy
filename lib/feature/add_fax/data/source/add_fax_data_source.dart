import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/data/models/fax_model.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:http_parser/http_parser.dart';

abstract class BaseAddFaxRemoteDataSource {
  Future<String> addOrEditFax(FaxPrams parameters);
  Future<String> getFaxIndex(String faxType);
  Future<List<String>> getAddress();
  Future<File> getPdfFile(String faxId);
  Future<List<FaxModel>> getFaxes(GetFaxPrams prams);
}

class AddOrEditFaxRemoteDataSource extends BaseAddFaxRemoteDataSource {
  @override
  Future<String> addOrEditFax(FaxPrams parameters) async {
    print('***********************************');

    print(parameters.toMap());
    print('***********************************');

    try {
      final formData = FormData.fromMap({
        'fax_data': jsonEncode(parameters.toMap()),
        'fax_pdf': await MultipartFile.fromFile(
          parameters.localPdfFile.path,
          filename: parameters.localPdfFile.path.split('/').last,
          contentType: MediaType('application', 'pdf'),
        ),
      });

      final response = await DioFinalHelper.postData(
        method: parameters.faxId.isNotEmpty ? editFaxEndPoint : addFaxEndPoint,
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<String> getFaxIndex(String faxType) async {
    try {
      final response = await DioFinalHelper.postData(
        method: newFaxIndexEndPoint,
        data: FormData.fromMap({'fax_type': faxType}),
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<String>> getAddress() async {
    try {
      final response = await DioFinalHelper.getData(method: getAddressEndPoint);
      print(response.data);
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<FaxModel>> getFaxes(GetFaxPrams prams) async {
    try {
      final response = await DioFinalHelper.getData(method: getFaxEndPoint);
      List<FaxModel> allFaxes =
          (response.data as List)
              .map((item) => FaxModel.fromJson(item))
              .toList();

      if (prams.isFollow) {
        allFaxes =
            allFaxes.where((fax) => fax.followDate.isNotEmpty).toList()
              ..sort((a, b) => b.followDate.compareTo(a.followDate));
      }

      if (prams.isSader) {
        allFaxes = allFaxes.where((fax) => fax.faxType == 'sader').toList();
      }

      if (prams.isWared) {
        allFaxes = allFaxes.where((fax) => fax.faxType == 'wared').toList();
      }

      if (prams.isToday) {
        final today = DateTime.now();
        allFaxes =
            allFaxes.where((fax) {
              final faxDate = DateTime.parse(fax.dateTime.toString());
              return faxDate.year == today.year &&
                  faxDate.month == today.month &&
                  faxDate.day == today.day;
            }).toList();
      }

      return allFaxes;
    } on DioException catch (e) {
      print(e.response);

      print(e.response!.data);
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<File> getPdfFile(String faxId) async {
    try {
      final response = await DioFinalHelper.getDataPdf(
        method: getFaxPdfEndPoint(faxId),
      );
      return File(response);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
