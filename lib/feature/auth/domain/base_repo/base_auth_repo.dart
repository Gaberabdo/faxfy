import 'package:dartz/dartz.dart';
import 'package:faxfy/core/error/failure.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, UserRoleEntities>> login(LoginPrams prams);
}

class LoginPrams {
  final String username;
  final String password;

  LoginPrams({required this.username, required this.password});

  Map<String, String> toMap() => {'username': username, 'password': password};
}
