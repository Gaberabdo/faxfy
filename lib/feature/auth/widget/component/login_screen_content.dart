import 'dart:convert';

import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_cubit.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_state.dart';
import 'package:faxfy/feature/layout/widget/component/moving_text.dart';
import 'package:faxfy/feature/layout/widget/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'login_form.dart';

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            MainCubit.get(context).loadUserData();
            MainCubit.get(context).connectToSocket();
            navigateAndFinish(context, HomeScreen());
          }
        },
        child: Stack(
          children: [
            PositionedDirectional(
              start: -400,
              child: SvgPicture.asset('assets/images/background.svg'),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF8C942),
                        width: 4,
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'تسجيل الدخول إلى منظومة فاكسات',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF1E2756),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Login form
                        const LoginForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: MovingText(),
    );
  }
}
