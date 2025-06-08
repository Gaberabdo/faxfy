import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/usecase/get_all_fax_use_case.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/dio.dart';
import '../../../core/network/end-points.dart';
import '../../add_fax/domain/entities/fax_entities.dart';
part 'fax_system_state.dart';

class FaxSystemCubit extends Cubit<FaxSystemState> {
  FaxSystemCubit(this.getAllFaxUseCase) : super(const FaxSystemInitial()) {
    _loadUserData();
  }

  static FaxSystemCubit get(context) => BlocProvider.of(context);

  final GetAllFaxUseCase getAllFaxUseCase;

  DateTime? startDate;
  DateTime? endDate;

  void filterByDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return;
    }
    emit(FaxSystemLoading());
    try {
      startDate = start;
      endDate = end;

      filteredFaxes =
          allFaxes.where((fax) {
            final faxDate = DateTime.parse(fax.dateTime.toString());
            return faxDate.isAfter(start.subtract(const Duration(days: 1))) &&
                faxDate.isBefore(end.add(const Duration(days: 1)));
          }).toList();

      emit(FaxSystemLoaded(faxes: filteredFaxes));
    } catch (e) {
      emit(FaxSystemError('حدث خطأ أثناء تصفية التاريخ: ${e.toString()}'));
    }
  }

  void initializeDateFilter(
    start,
    end, {
    required bool isFollow,
    required bool isToday,
    required bool isSader,
    required bool isWared,
  }) {
    print('initializeDateFilter');
    emit(FaxSystemLoading());
    getFaxes(
      isFollow: isFollow,
      isToday: isToday,
      isSader: isSader,
      isWared: isWared,
    ).then((value) {
      filterByDateRange(start, end);
    });
  }

  void resetDateFilter() {
    emit(FaxSystemLoading());
    try {
      startDate = null;
      endDate = null;
      filteredFaxes = List.from(allFaxes);
      emit(FaxSystemLoaded(faxes: filteredFaxes));
    } catch (e) {
      emit(FaxSystemError('حدث خطأ أثناء إعادة ضبط التصفية: ${e.toString()}'));
    }
  }

  // Modify your searchFax method to respect date filters
  void searchFax(String query) {
    emit(FaxSystemLoading(searchQuery: query));
    try {
      List<FaxEntities> baseList = List.from(allFaxes);

      // Apply date filter if active
      if (startDate != null && endDate != null) {
        baseList =
            baseList.where((fax) {
              final faxDate = DateTime.parse(fax.dateTime.toString());
              return faxDate.isAfter(
                    startDate!.subtract(const Duration(days: 1)),
                  ) &&
                  faxDate.isBefore(endDate!.add(const Duration(days: 1)));
            }).toList();
      }

      if (query.trim().isEmpty) {
        filteredFaxes = baseList;
      } else {
        final q = query.toLowerCase();
        filteredFaxes =
            baseList.where((fax) {
              return fax.faxAddress.toLowerCase().contains(q) ||
                  fax.index.toString().toLowerCase().contains(q) ||
                  fax.faxType.toLowerCase().contains(q) ||
                  fax.subject.toLowerCase().contains(q) ||
                  fax.formattedDate.contains(q);
            }).toList();
      }
      emit(FaxSystemLoaded(faxes: filteredFaxes));
    } catch (e) {
      emit(FaxSystemError('حدث خطأ أثناء البحث: ${e.toString()}'));
    }
  }

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

  // Add these methods to your FaxSystemCubit class
  void deleteFax(String faxId, String faxType) async {
    try {
      final response = await DioFinalHelper.postData(
        method: deleteFaxEndPoint,
        data: FormData.fromMap({'fax_id': faxId}),
      );
      if (response.statusCode == 200) {
        getFaxes(
          isFollow: faxType == 'follow',
          isToday: faxType == 'elyom',
          isSader: faxType == 'sader',
          isWared: faxType == 'wared',
        );
      }
    } on DioException catch (e) {
      emit(FaxSystemError(e.toString()));
    }
  }

  List<Roles> roles = [];

  Future<void> _loadUserData() async {
    CacheHelper.getData('username');
    String? raw = CacheHelper.getData('role');
    if (raw != null) {
      List<String> roleStrings = List<String>.from(jsonDecode(raw));
      roles = roleStrings.map((e) => Roles.values.byName(e)).toList();
    }
    emit(FaxSystemLoading());
  }
}
