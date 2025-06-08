import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';

class GetFaxPdfUseCase extends BaseUseCase<File, String> {
  final BaseAddFaxRepository baseAddFaxRepository;

  GetFaxPdfUseCase(this.baseAddFaxRepository);

  @override
  Future<Either<Failure, File>> call(String parameters) async {
    return await baseAddFaxRepository.getPdfFile(parameters);
  }
}
