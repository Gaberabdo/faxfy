import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/add_or_edit_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_address_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_all_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_index_last_fax_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:open_file/open_file.dart' show OpenFile;

import '../../../../core/utils/export_path/export_files.dart';
import 'add_fax_state.dart';

class AddFaxCubit extends Cubit<AddFaxState> {
  AddFaxCubit(
    this.addOrEditFaxUseCase,
    this.getIndexLastFaxUseCase,
    this.getAddressFaxUseCase,
    this.getAllFaxUseCase,
  ) : super(AddFaxInitial());

  File? localPdfFile;
  int index = 0;

  final TextEditingController referenceController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController senderController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController toInformController = TextEditingController();
  final AddOrEditFaxUseCase addOrEditFaxUseCase;
  final GetIndexLastFaxUseCase getIndexLastFaxUseCase;
  final GetAddressFaxUseCase getAddressFaxUseCase;
  final GetAllFaxUseCase getAllFaxUseCase;
  List<FaxEntities> allFaxes = [];
  List<FaxEntities> filteredFaxes = [];

  Future<void> getFaxes({
    required bool isFollow,
    required bool isToday,
    required bool isSader,
    required bool isWared,
  }) async {
    emit(FaxSystemLoading());
    try {} catch (e) {
      emit(FaxSystemError(e.toString()));
    }

    final result = await getAllFaxUseCase(
      GetFaxPrams(isFollow, isToday, isSader, isWared),
    );

    result.fold(
          (error) {
        emit(FaxSystemError(error.message));
      },
          (success) {
        allFaxes = success;
        filteredFaxes = List.from(allFaxes);
        emit(FaxSystemLoaded(faxes: filteredFaxes));
      },
    );
  }
  void clear(faxType) {
    titleController.clear();
    senderController.clear();
    departmentController.clear();
    localPdfFile = null;
    isSuccess = false;
    getFaxIndex(faxType: faxType);

    emit(AddFaxInitial());
  }

  static AddFaxCubit get(context) => BlocProvider.of(context);

  Future<void> getFaxIndex({required String faxType}) async {
    emit(AddFaxIndexLoading());
    final result = await getIndexLastFaxUseCase(faxType);
    result.fold(
      (error) {
        print('error: ${error.message}');
        emit(AddOrEditFaxFailure(error.message));
      },
      (success) {
        index = int.parse(success);

        referenceController.text = index.toString();
        emit(AddFaxIndexFetched(index));
      },
    );
  }

  bool isSubmitting = false;
  bool isSuccess = false;
  String faxId = '';

  Future<void> addOrEditFax(FaxEntities fax, BuildContext context,String linkFaxId) async {
    isSubmitting = true;
    print(fax.toJson());
    print('fax.followDate: ${fax.followDate}');
    emit(AddOrEditFaxLoading());
    final result = await addOrEditFaxUseCase(
      FaxPrams(
        localPdfFile!,
        fax.senderName,
        fax.receiverName,
        fax.subject,
        fax.formattedDate,
        null,
        fax.faxType,
        fax.faxAddress,
        fax.note,
        fax.faxId,
        fax.toInform,
        fax.index,
        linkFaxId,
      ),
    );
    result.fold(
      (error) {
        isSubmitting = false;
        errorToast(context, error.message);
        emit(AddOrEditFaxFailure(error.message));
      },
      (success) {
        if (fax.faxId.isEmpty) {
          successToast(context, 'تم اضافة الفاكس بنجاح');
        } else {
          successToast(context, 'تم تعديل الفاكس بنجاح');
        }

        faxId = success;
        isSubmitting = false;
        isSuccess = true;
        emit(AddOrEditFaxSuccess(success));
      },
    );
  }

  Future getDocuments() async {
    emit(GetAddressLoading());
    final result = await getAddressFaxUseCase(const NoParameters());
    result.fold((error) => emit(GetAddressFailure(error.message)), (success) {
      emit(GetAddressSuccess(success));
    });
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
    } on DioException catch (e) {
      print(e.response!.data);
      emit(GetToInformFailure());
    }
  }
}
