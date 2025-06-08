import 'package:faxfy/core/service/cache/cache_helper.dart';
import 'package:flutter/material.dart';

class HomeAnimationManager {
  late AnimationController logoAnimationController;
  late AnimationController titleAnimationController;
  late AnimationController menuAnimationController;
  late AnimationController networkAnimationController;

  late Animation<double> logoAnimation;
  late Animation<double> titleScaleAnimation;
  late Animation<double> titleOpacityAnimation;
  late Animation<double> menuAnimation;
  late Animation<double> networkOpacityAnimation;

  final List<AnimationController> menuItemControllers = [];
  final List<Animation<Offset>> menuItemAnimations = [];

  void initAnimations(TickerProvider vsync) {
    CacheHelper.saveData('isFirst', true);
    // Logo animation
    logoAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    logoAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(parent: logoAnimationController, curve: Curves.easeOut),
    );

    // Title animation
    titleAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    titleScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: titleAnimationController, curve: Curves.easeOut),
    );
    titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: titleAnimationController, curve: Curves.easeIn),
    );

    // Menu animation
    menuAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    menuAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: menuAnimationController, curve: Curves.easeOut),
    );

    // Network animation
    networkAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );
    networkOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: networkAnimationController, curve: Curves.easeIn),
    );

    // Menu item animations
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 500),
      );

      final animation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      menuItemControllers.add(controller);
      menuItemAnimations.add(animation);
    }
  }

  void startAnimations() {
    logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      titleAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      menuAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      networkAnimationController.forward();

      // Staggered menu item animations
      for (int i = 0; i < menuItemControllers.length; i++) {
        Future.delayed(Duration(milliseconds: 200 * i), () {
          menuItemControllers[i].forward();
        });
      }
    });
  }

  void dispose() {
    logoAnimationController.dispose();
    titleAnimationController.dispose();
    menuAnimationController.dispose();
    networkAnimationController.dispose();

    for (var controller in menuItemControllers) {
      controller.dispose();
    }
  }
}
