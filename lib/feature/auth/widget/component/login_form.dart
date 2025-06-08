import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/widget/component/search_username_login.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_cubit.dart';
import 'package:faxfy/feature/auth/widget/controller/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../../view_fax/widgets/component/search_info.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final String? errorMessage =
            state is LoginFailure ? state.errorMessage : null;
        final bool isLoading = state is LoginLoading;

        return Column(
          children: [
            // Error message
            if (errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Login form
            Form(
              key: loginCubit.formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username field
                  const Text(
                    'اسم المستخدم',
                    style: TextStyle(
                      color: Color(0xFF1E2756),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),

                  buildFormFieldSearchEntityLogin(
                    inputType: TextInputType.text,
                    controller: loginCubit.usernameController,
                    validator: "الرجاء إدخال اسم المستخدم",
                    hint: 'أدخل اسم المستخدم',
                    address: loginCubit.toInform,
                    setState: () => setState(() {}),
                    isEnglish: false,
                    context: context,
                    onEnValueSelected: (value) {
                      setState(() {
                        loginCubit.usernameController.text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  const Text(
                    'كلمة المرور',
                    style: TextStyle(
                      color: Color(0xFF1E2756),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: loginCubit.passwordController,
                    obscureText: loginCubit.obscurePassword,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontColor: const Color(0xFF1E2756),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      border: _borderStyle(),
                      contentPadding: const EdgeInsets.all(0),
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: FontStyleThame.textStyle(
                        context: context,
                        fontColor: const Color(0xFF1E2756),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: _borderStyle(),
                      focusedBorder: _borderStyle(),
                      errorBorder: _borderStyle(),
                      disabledBorder: _borderStyle(),
                      focusedErrorBorder: _borderStyle(),
                      hintText: 'أدخل كلمة المرور',
                      prefixIcon: const Icon(
                        IconlyLight.lock,
                        color: Color(0xFF1E2756),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginCubit.obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF1E2756),
                        ),
                        onPressed: () => loginCubit.togglePasswordVisibility(),
                      ),
                      hintTextDirection: TextDirection.rtl,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () => loginCubit.login(
                                loginCubit.usernameController.text,
                                loginCubit.passwordController.text,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8C942),
                        foregroundColor: const Color(0xFF1E2756),
                        disabledBackgroundColor: const Color(
                          0xFFF8C942,
                        ).withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1E2756),
                                  strokeWidth: 3,
                                ),
                              )
                              : const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _borderStyle() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  );
}
