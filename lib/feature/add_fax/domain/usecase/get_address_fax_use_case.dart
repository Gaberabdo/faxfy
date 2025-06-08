import 'package:dartz/dartz.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/add_fax/domain/base_repo/base_add_fax_repo.dart';

class GetAddressFaxUseCase extends BaseUseCase<List<String>, NoParameters> {
  final BaseAddFaxRepository baseAddFaxRepository;

  GetAddressFaxUseCase(this.baseAddFaxRepository);

  @override
  Future<Either<Failure, List<String>>> call(NoParameters p) async {
    return await baseAddFaxRepository.getFaxAddress();
  }
}
