import 'package:flutter/material.dart';

import '../../../service/main_service/controller/main_cubit/main_cubit.dart';

class FontStyleThame {
  static TextStyle textStyle({
    double fontSize = 20,
    Color? fontColor,
    FontWeight? fontWeight,
    required context,
  }) {
    return TextStyle(
      fontFamily: 'Amiri',

      color:
          fontColor ??
          (MainCubit.get(context).isDark ? Colors.white : Colors.black),
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}
