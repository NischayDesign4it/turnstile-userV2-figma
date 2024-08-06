import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turnstileuser_v2/features/authentications/screens/Login/Login.dart';
import 'package:turnstileuser_v2/utils/theme/theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
