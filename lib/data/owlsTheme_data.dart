import 'package:flutter/material.dart';

import '../constants.dart';

class OwlsThemeData {
  static ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: primary,
    primaryColorLight: primaryLight,
    primaryColorDark: primary,
  );

  static ExpansionTileThemeData tileThemeData = const ExpansionTileThemeData(
    collapsedShape: Border(
      top: BorderSide(
        color: Colors.transparent,
      ),
    ),
    shape: Border(
      top: BorderSide(
        color: Colors.transparent,
      ),
      bottom: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );

  static ThemeData color = ThemeData(hoverColor: Colors.grey.shade200);
}
