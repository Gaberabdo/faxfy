
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserRoleEntities userRoleEntities;

  LoginSuccess(this.userRoleEntities);
}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}
class TogglePasswordVisibility extends LoginState{}

class GetToInformLoading extends LoginState {}
class GetToInformSuccess extends LoginState {}
class GetToInformFailure extends LoginState {}
