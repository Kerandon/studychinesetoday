import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

final appTheme = ThemeData(
    textTheme: TextTheme(
      displaySmall: appTextStyle().copyWith(fontSize: 15, color: Colors.black),
      displayMedium: appTextStyle().copyWith(fontSize: 30, color: Colors.black),
      displayLarge: appTextStyle(),
    ),
    appBarTheme: const AppBarTheme(elevation: 0, color: AppColors.red),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 40,
    ));

TextStyle appTextStyle() {
  return TextStyle(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    color: Colors.white,
    fontSize: 40,
  );
}
