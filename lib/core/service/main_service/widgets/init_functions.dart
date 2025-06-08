import 'package:faxfy/core/service/local_notifications/notification_initializer.dart';
import 'package:faxfy/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faxfy/core/utils/export_path/export_files.dart';

class InitFunctions {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    ConfigModel.setEnvironment(Environment.test);
    Bloc.observer = MyBlocObserver();
    await ServiceLocator().init();
    // await initNotifications();
    await CacheHelper.init();
    await DioFinalHelper.init();
    initWindowsNotification();
  }
}
