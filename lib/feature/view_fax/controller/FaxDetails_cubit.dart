import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:faxfy/core/network/end-points.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/data/models/fax_model.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/add_or_edit_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_fax_pdf_use_case.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/network/dio.dart';
import '../../../core/service/global_widget/toast.dart';
import 'package:http_parser/http_parser.dart';
part 'FaxDetails_state.dart';

class FaxDetailsCubit extends Cubit<FaxDetailsState> {
  FaxDetailsCubit(this.getFaxPdfUseCase, this.addOrEditFaxUseCase)
    : super(FaxDetailsInitial());
  static FaxDetailsCubit get(context) => BlocProvider.of(context);
  String? file;

  File? localPdfFile;
  final GetFaxPdfUseCase getFaxPdfUseCase;
  final AddOrEditFaxUseCase addOrEditFaxUseCase;

  Future<void> getPdf(id) async {
    emit(GetPdfLoading());

    final result = await getFaxPdfUseCase(id);
    result.fold(
      (error) {
        emit(GetPdfFailure());
      },
      (success) {
        localPdfFile = success;
        emit(GetPdfSuccess());
      },
    );
  }

  bool isSubmitting = false;
  bool isSuccess = false;

  Future<void> addToFollowOrEditFax(
    FaxEntities fax,
    BuildContext context,
  ) async {
    isSubmitting = true;
    emit(AddOrEditFaxLoading());

    final result = await addOrEditFaxUseCase(
      FaxPrams(
        localPdfFile!,
        fax.senderName,
        fax.receiverName,
        fax.subject,
        fax.formattedDate,
        fax.followDate,
        fax.faxType,
        fax.faxAddress,
        fax.note,
        fax.faxId,
        fax.toInform,
        fax.index,
        fax.linkedFaxId,
      ),
    );
    result.fold(
      (error) {
        isSubmitting = false;
        print('error: ${error.message}');
        errorToast(context, error.message);

        emit(AddOrEditFaxFailure(error.message));
      },
      (success) {
        isSubmitting = false;
        isSuccess = true;
        if (!MainCubit.get(context).roles.contains(Roles.write)) {
          printCover(faxId: fax.faxId);
        }
        emit(AddOrEditFaxSuccess(success));
      },
    );
  }

  Future<void> printCover({required String faxId}) async {
    try {
      await DioFinalHelper.postData(
        method: printCoverEndPoint,
        data: FormData.fromMap({'fax_id': faxId}),
      );
    } catch (e) {
      print(e);
    }
  }

  List<FaxModel> allFaxes = [];
  Future<void> loadFaxes(String faxId) async {
    try {
      final response = await DioFinalHelper.postData(
        method: getLinkFaxEndPoint,
        data: FormData.fromMap({'fax_id': faxId}),
      );
      allFaxes =
          (response.data as List)
              .map((item) => FaxModel.fromJson(item))
              .toList();
      print('----------------------------');
      emit(GetPdfSuccess());

    } on DioException catch (e) {
      print(e.response!.data);
    }
  }

  List<String> toInform = [];
  Future<void> getToInform() async {
    emit(GetToInformLoading());
    try {
      final response = await DioFinalHelper.getData(
        method: getToInformEndPoint,
      );
      toInform = List<String>.from(response.data);

      emit(GetToInformSuccess());
    } catch (e) {
      emit(GetToInformFailure());
    }
  }
}
