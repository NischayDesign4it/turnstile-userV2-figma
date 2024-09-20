import 'package:flutter/material.dart';
import 'package:turnstileuser_v2/features/authentications/screens/Login/TFormDivider.dart';
import 'package:turnstileuser_v2/features/authentications/screens/Signup/signupForm.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/spacing_styles.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../Login/TSocialButton.dart';
import '../Login/login_header.dart';



class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});


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
              TLoginHeader(dark: dark, title: TTexts.createAcc, subTitle: TTexts.loginSubTitle),
              TSignupForm(),
              TDivider(dark: dark),
              SizedBox(height: TSizes.spaceBtwItems),

              TSepcialButton(dark: dark,)



            ],
          ),
        ),


    );
  }
}
