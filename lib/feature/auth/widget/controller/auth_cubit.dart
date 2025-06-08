import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:faxfy/feature/auth/domain/base_repo/base_auth_repo.dart';
import 'package:faxfy/feature/auth/domain/usecase/login_use_case.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/export_path/export_files.dart';
import 'auth_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginUseCase) : super(LoginInitial());

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  final LoginUseCase loginUseCase;

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(TogglePasswordVisibility());
  }

  Future<void> login(usernameController, passwordController) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(LoginLoading());
    final result = await loginUseCase(
      LoginPrams(username: usernameController, password: passwordController),
    );
    result.fold(
      (error) {
        emit(LoginFailure(error.message));
      },
      (success) {
        emit(LoginSuccess(success));
      },
    );
  }

  List<dynamic> toInform = [];
  Future<void> getToInform() async {
    emit(GetToInformLoading());
    try {
      final response = await DioFinalHelper.getData(
        method: getToInformEndPoint,
      );
      print('*******************************');

      print(response);
      print('*******************************');
      toInform = List<String>.from(response.data);

      emit(GetToInformSuccess());
    } on DioException catch (e) {
      print('*******************************');

      print(e.toString());
      print('*******************************');
      emit(GetToInformFailure());
    }
  }
}
