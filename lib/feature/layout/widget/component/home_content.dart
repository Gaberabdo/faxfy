import 'package:faxfy/core/utils/export_path/export_files.dart';
import 'package:faxfy/feature/auth/domain/entities/user_entites.dart';
import 'package:faxfy/feature/auth/widget/screens/login_screen.dart';
import 'package:faxfy/feature/layout/widget/component/moving_text.dart';
import 'package:faxfy/feature/view_fax/widgets/screens/view_details_fax.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';

import '../../../add_fax/widgets/screens/add_fax_type.dart';
import '../../../calendar/widgets/screens/calendar_screen.dart';
import '../../../fax_details/widget/screens/fax_system_screen.dart';
import '../../controller/home_cubit.dart';
import 'home_animation_manager.dart';
import 'menu_item.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  final HomeAnimationManager _animationManager = HomeAnimationManager();

  @override
  void initState() {
    super.initState();
    _animationManager.initAnimations(this);

    _animationManager.startAnimations();
  }

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeLogoutSuccess) {
          navigateAndFinish(context, const LoginScreen());
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          floatingActionButton:
              cubit.roles.contains(Roles.write)
                  ? FloatingActionButton(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder:
                            (context) => SizedBox(
                              height: 300,
                              width: 300,
                              child: const AddFaxTypeDialog(),
                            ),
                      );
                    },
                    backgroundColor: const Color(0xFFF5B93F),
                    child: const Icon(Icons.add, color: Colors.white),
                  )
                  : null,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // Network graphics
                PositionedDirectional(
                  child: SvgPicture.asset(
                    'assets/images/background.svg',
                    height: 1150,
                  ),
                ),

                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      // User info and logout
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          final String username =
                              state is HomeLoaded ? state.username : '';
                          final bool isLoggingOut =
                              state is HomeLogoutInProgress;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    isLoggingOut
                                        ? null
                                        : () => context
                                            .read<HomeCubit>()
                                            .logout(context),
                                icon:
                                    isLoggingOut
                                        ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF1E2756),
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Icon(
                                          IconlyLight.logout,
                                          color: Color(0xFF1E2756),
                                        ),
                                label: const Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(color: Color(0xFF1E2756)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.secondColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      IconlyBold.profile,
                                      color: ColorManager.secondColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // Logo with animation
                      AnimatedBuilder(
                        animation: _animationManager.logoAnimationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              _animationManager.logoAnimation.value,
                            ),
                            child: Opacity(
                              opacity:
                                  _animationManager
                                      .logoAnimationController
                                      .value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),

                      // Title with animation
                      AnimatedBuilder(
                        animation: _animationManager.titleAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity:
                                _animationManager.titleOpacityAnimation.value,
                            child: Transform.scale(
                              scale:
                                  _animationManager.titleScaleAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              'منظومة فاكسات',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: ColorManager.secondColor,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: ColorManager.secondColor,
                                    blurRadius: 80,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'مجموعة الأنشاءات الخطية رقم 2',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: ColorManager.secondColor,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: ColorManager.secondColor,
                                    blurRadius: 80,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 38),

                      // Menu container with animation
                      AnimatedBuilder(
                        animation: _animationManager.menuAnimationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              _animationManager.menuAnimation.value,
                            ),
                            child: Opacity(
                              opacity:
                                  _animationManager
                                      .menuAnimationController
                                      .value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: ColorManager.secondColor,
                              width: 4,
                            ),
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              MenuItem(
                                index: 0,
                                title: 'فاكسات اليوم',
                                icon: Icons.access_time,
                                animation:
                                    _animationManager.menuItemAnimations[0],
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    const AllFaxScreen(faxType: 'elyom',start:null,end: null,),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              MenuItem(
                                index: 1,
                                title: 'فاكسات الوارد',
                                icon: IconlyLight.paper_download,
                                animation:
                                    _animationManager.menuItemAnimations[1],
                                onTap: () {
                                  navigateToScreen(
                                    context,
                                    const AllFaxScreen(faxType: 'wared',start:null,end: null,),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              if (cubit.roles.contains(Roles.edit))
                                MenuItem(
                                  index: 2,
                                  title: 'فاكسات الصادر',
                                  icon: IconlyLight.paper_upload,
                                  animation:
                                      _animationManager.menuItemAnimations[2],
                                  onTap: () {
                                    navigateToScreen(
                                      context,
                                      const AllFaxScreen(faxType: 'sader',start:null,end: null,),
                                    );
                                  },
                                ),
                              const SizedBox(height: 16),

                              if (cubit.roles.contains(Roles.follow))
                                MenuItem(
                                  index: 3,
                                  title: 'فاكسات المتابعة',
                                  icon: IconlyLight.calendar,
                                  animation:
                                      _animationManager.menuItemAnimations[3],
                                  onTap: () {
                                    navigateToScreen(
                                      context,
                                      const CalendarScreen(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: MovingText(),

        );
      },
    );
  }
}
