import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';

class GetIndexLastFaxUseCase extends BaseUseCase<String, String> {
  final BaseAddFaxRepository baseAddFaxRepository;

  GetIndexLastFaxUseCase(this.baseAddFaxRepository);

  @override
  Future<Either<Failure, String>> call(String parameters) async {
    return await baseAddFaxRepository.getFaxIndex(parameters);
  }
}
