import 'package:dartz/dartz.dart';
import 'package:faxfy/feature/auth/domain/base_repo/base_auth_repo.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';

import '../../../../../../core/error/failure.dart';
import '../../../../core/base_usecase/base_usecase.dart';

class LoginUseCase extends BaseUseCase<UserRoleEntities, LoginPrams> {
  final BaseAuthRepository baseAuthRepo;

  LoginUseCase(this.baseAuthRepo);

  @override
  Future<Either<Failure, UserRoleEntities>> call(LoginPrams parameters) async {
    return await baseAuthRepo.login(parameters);
  }
}
