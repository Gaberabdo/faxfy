import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/widget/screens/login_screen.dart';
import '../../controller/home_cubit.dart';
import '../component/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),

      child: const HomeContent(),
    );
  }
}
