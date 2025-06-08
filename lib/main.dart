import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'core/service/main_service/screens/app_view.dart';
import 'core/service/main_service/widgets/init_functions.dart';

Future<void> main() async {
  await InitFunctions.initialize();

  runApp(MyApp());
}
