import 'package:faxfy/feature/auth/widget/screens/login_screen.dart';
import 'package:faxfy/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../feature/layout/widget/screens/home_screen.dart';
import '../../../utils/export_path/export_files.dart';
import '../../cache/cache_helper.dart';
import '../controller/main_cubit/main_cubit.dart';
import '../controller/main_cubit/main_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return MainCubit()
          ..changeAppMode(fromShared: CacheHelper.getData('isDark') ?? true)
          ..changeAppLang(
            fromSharedLang: CacheHelper.getData('language') ?? 'ar',
          )
          ..loadUserData()
          ..connectToSocket()
          ..loadFaxes();
      },
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = MainCubit.get(context);
          return MaterialApp(
            title: 'Faxify',
            darkTheme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF1E2756),
              primaryColor: const Color(0xFF1E2756),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1E2756),
                primary: const Color(0xFFF5B93F),
                secondary: const Color(0xFF8B7D2E),
              ),
              fontFamily: 'Cairo',
              useMaterial3: false,
            ),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home:
                CacheHelper.getData('role') == null
                    ? const LoginScreen()
                    : HomeScreen(),
            debugShowCheckedModeBanner: false,
            locale:
                cubit.language == 'en'
                    ? const Locale('en')
                    : const Locale('ar'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
