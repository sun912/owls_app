import 'package:flutter/material.dart';

import '../constants.dart';

class OwlsThemeData {
  static ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: primary,
    primaryColorLight: primaryLight,
    primaryColorDark: primary,
  );
}
