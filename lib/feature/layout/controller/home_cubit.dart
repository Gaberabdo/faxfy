import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
import 'package:faxfy/feature/auth/widget/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/service/cache/cache_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    _loadUserData();
  }
  static HomeCubit get(context) => BlocProvider.of(context);

  List<Roles> roles = [];

  Future<void> _loadUserData() async {
    CacheHelper.getData('username');
    String? raw = CacheHelper.getData('role');
    if (raw != null) {
      List<String> roleStrings = List<String>.from(jsonDecode(raw));
      roles = roleStrings.map((e) => Roles.values.byName(e)).toList();
    }
    emit(HomeLoaded(username: CacheHelper.getData('username')));
  }

  Future<void> logout(context) async {
    emit(HomeLogoutInProgress());

    try {
      // Simulate API call for logout

      CacheHelper.clearData();
      navigateAndFinish(context, LoginScreen());
      emit(HomeLogoutSuccess());
    } catch (e) {
      // If logout fails, go back to loaded state
      emit(HomeLoaded(username: 'المستخدم'));
    }
  }
}
