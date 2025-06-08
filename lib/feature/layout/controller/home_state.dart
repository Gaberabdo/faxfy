part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final String username;
  
  HomeLoaded({required this.username});
}

class HomeLogoutInProgress extends HomeState {}

class HomeLogoutSuccess extends HomeState {}
class LoginLoading extends HomeState {}

class LoginSuccess extends HomeState {}

class LoginFailure extends HomeState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}