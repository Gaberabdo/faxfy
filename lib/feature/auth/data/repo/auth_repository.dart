import 'package:dartz/dartz.dart';
import 'package:faxfy/core/error/failure.dart';
import 'package:faxfy/feature/auth/data/source/auth_data_source.dart';
import 'package:faxfy/feature/auth/domain/base_repo/base_auth_repo.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
export 'package:faxfy/feature/auth/domain/base_repo/base_auth_repo.dart';

import '../../../../core/error/exception.dart';

class AuthRepository extends BaseAuthRepository {
  final BaseAuthRemoteDataSource baseAuthRemoteDataSource;

  AuthRepository(this.baseAuthRemoteDataSource);

  @override
  Future<Either<Failure, UserRoleEntities>> login(LoginPrams prams) async {
    try {
      final result = await baseAuthRemoteDataSource.loginAuthDataSource(prams);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

}
