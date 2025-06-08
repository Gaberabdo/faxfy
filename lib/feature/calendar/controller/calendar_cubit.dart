import 'dart:io';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/add_or_edit_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_all_fax_use_case.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_fax_pdf_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(
    this.getFaxPdfUseCase,
    this.getAllFaxUseCase,
    this.addOrEditFaxUseCase,
  ) : super(CalenderSystemInitial());

  static CalendarCubit get(context) => BlocProvider.of(context);

  final GetAllFaxUseCase getAllFaxUseCase;

  List<FaxEntities> allFaxes = [];
  Future<void> getFaxes() async {
    emit(CalenderSystemLoading());
    final result = await getAllFaxUseCase(
      GetFaxPrams(true, false, false, false),
    );
    result.fold(
      (error) {
        emit(CalenderSystemError(error.message));
      },
      (success) {
        allFaxes = success;
        emit(CalenderSystemLoaded(calender: success));
      },
    );
  }

  File? localPdfFile;
  final GetFaxPdfUseCase getFaxPdfUseCase;

  Future<void> getPdf(id) async {
    emit(GetPdfLoading());

    final result = await getFaxPdfUseCase(id);
    result.fold(
      (error) {
        print(error);
        emit(GetPdfFailure());
      },
      (success) {
        localPdfFile = success;
        emit(GetPdfSuccess());
      },
    );
  }

  final AddOrEditFaxUseCase addOrEditFaxUseCase;
  Future<void> removeFaxToFollow(FaxEntities fax) async {
    emit(AddFaxToFollowLoading());

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
        ''
      ),
    );
    result.fold(
      (error) {
        emit(AddFaxToFollowFailure());
      },
      (success) {
        emit(AddFaxToFollowSuccess());
      },
    );
  }
}
