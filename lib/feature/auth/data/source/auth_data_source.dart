import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/data/models/user_model.dart';
import 'package:faxfy/feature/auth/domain/base_repo/base_auth_repo.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserRoleModel> loginAuthDataSource(LoginPrams parameters);
}

class AuthRemoteDataSource extends BaseAuthRemoteDataSource {
  @override
  Future<UserRoleModel> loginAuthDataSource(LoginPrams parameters) async {
    try {
      var data = FormData.fromMap({
        'username': parameters.username,
        'password': parameters.password,
      });

      Response response = await DioFinalHelper.postData(
        method: loginEndPoint,
        data: data,
      );
      final setCookie = response.headers.map['set-cookie'];

      print(response.data);
      print(response.headers);
      print(setCookie);
      print(response.headers['set-cookie']);
      CacheHelper.saveData(
        'token',
        response.headers['set-cookie']!.first.split(';')[0],
      );
      CacheHelper.saveData('username', parameters.username);
      CacheHelper.saveData('password', parameters.password);
      var model = UserRoleModel.fromJson(response);

      CacheHelper.saveData(
        'role',
        jsonEncode(model.role.map((role) => role.name).toList()),
      );

      return model;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
}
