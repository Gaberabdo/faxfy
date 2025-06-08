import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faxfy/feature/add_fax/data/source/add_fax_data_source.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

import '../../../../core/utils/export_path/export_files.dart';

class AddFaxRepo extends BaseAddFaxRepository {
  final BaseAddFaxRemoteDataSource baseAddFaxRemoteDataSource;

  AddFaxRepo(this.baseAddFaxRemoteDataSource);

  @override
  Future<Either<Failure, String>> addFaxOrEdit(FaxPrams prams) async {
    try {
      final result = await baseAddFaxRemoteDataSource.addOrEditFax(prams);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, String>> getFaxIndex(String faxType) async {
    try {
      final result = await baseAddFaxRemoteDataSource.getFaxIndex(faxType);

      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFaxAddress() async {
    try {
      final result = await baseAddFaxRemoteDataSource.getAddress();

      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, List<FaxEntities>>> getFaxes(GetFaxPrams prams) async {
    try {
      final result = await baseAddFaxRemoteDataSource.getFaxes(prams);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

  @override
  Future<Either<Failure, File>> getPdfFile(String faxId) async {
    try {
      final result = await baseAddFaxRemoteDataSource.getPdfFile(faxId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }
}
