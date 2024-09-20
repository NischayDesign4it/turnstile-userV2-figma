import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:turnstileuser_v2/utils/constants/sizes.dart';
import 'package:turnstileuser_v2/utils/constants/spacing_styles.dart';
import 'package:turnstileuser_v2/utils/constants/text_strings.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import 'Form.dart';
import 'TFormDivider.dart';
import 'TSocialButton.dart';
import 'login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
        body: SingleChildScrollView(
            padding: TSpacingStyle.paddingWithAppHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TLoginHeader(
                    dark: dark,
                    title: TTexts.loginTitle,
                    subTitle: TTexts.loginSubTitle),
                SizedBox(height: TSizes.spaceBtwSection),
                TLoginForm(dark: dark),
                TDivider(dark: dark),
                SizedBox(height: TSizes.spaceBtwItems),
                TSepcialButton(dark: dark),
              ],
            )));
  }
}
