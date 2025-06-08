import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';
import 'package:faxfy/feature/add_fax/domain/entities/fax_entities.dart';

class GetAllFaxUseCase extends BaseUseCase<List<FaxEntities>, GetFaxPrams> {
  final BaseAddFaxRepository baseAddFaxRepository;

  GetAllFaxUseCase(this.baseAddFaxRepository);

  @override
  Future<Either<Failure, List<FaxEntities>>> call(GetFaxPrams prams) async {
    return await baseAddFaxRepository.getFaxes(prams);
  }
}
