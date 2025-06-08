import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

class AddOrEditFaxUseCase extends BaseUseCase<String, FaxPrams> {
  final BaseAddFaxRepository baseAddFaxRepository;

  AddOrEditFaxUseCase(this.baseAddFaxRepository);

  @override
  Future<Either<Failure, String>> call(FaxPrams parameters) async {
    return await baseAddFaxRepository.addFaxOrEdit(parameters);
  }
}
