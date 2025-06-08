import 'package:faxfy/feature/auth/widget/controller/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/service_locator/service_locator.dart';
import '../component/login_screen_content.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>()..getToInform(),
      child: const LoginScreenContent(),
    );
  }
}

