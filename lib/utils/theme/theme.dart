import 'package:flutter/material.dart';
import 'package:turnstileuser_v2/utils/theme/text_theme.dart';
import 'package:turnstileuser_v2/utils/theme/textfield_theme.dart';

import '../constants/colors.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: TColors.background,
    textTheme: TTextTheme.lightTextTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.DarkTextTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,


  );
}
