import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import 'package:turnstileuser_v2/features/authentications/screens/Login/Login.dart';
import 'package:turnstileuser_v2/utils/constants/colors.dart';
import 'package:turnstileuser_v2/utils/constants/sizes.dart';
import 'package:turnstileuser_v2/utils/constants/text_strings.dart';
import '../../controllers/signup_Controller.dart';
import '../forgotPassword.dart';

class TSignupForm extends StatefulWidget {
  TSignupForm({Key? key}) : super(key: key);

  @override
  _TSignupFormState createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // Initial state for password visibility
  bool _rememberMe = false; // State for "Remember Me" checkbox

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _submitForm(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Example validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // Handle empty fields
      return;
    }

    final result = await TAPIService.signUp(name, email, password);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      } else {
        await prefs.remove('name');
        await prefs.remove('email');
        await prefs.remove('password');
      }

      // Navigate to login screen on successful signup
      Get.to(() => LoginScreen());
    } else {
      String errorMessage = result['error'] == 'Email already exists'
          ? 'Email already exists. Please use a different email.'
          : 'Signup failed. Please check your credentials.';

      ScaffoldMessenger.of(context).showSnackBar(
          Get.snackbar(
            'Error',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black,
            colorText: TColors.textWhite,
            duration: Duration(seconds: 3), // Adjust as per your needs
          ) as SnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSection),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              cursorColor: TColors.textBlack,
              style: TextStyle(color: TColors.textBlack),
              decoration: InputDecoration(
                hintText: TTexts.name,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(Iconsax.user),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: emailController,
              cursorColor: TColors.textBlack,
              style: TextStyle(color: TColors.textBlack),
              decoration: InputDecoration(
                hintText: TTexts.email,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                prefixIcon: Icon(Iconsax.direct_right),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: passwordController,
              cursorColor: TColors.textBlack,
              style: TextStyle(color: TColors.textBlack),
              decoration: InputDecoration(
                hintText: TTexts.password,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: GestureDetector(
                  onTap: _togglePasswordVisibility,
                  child: Icon(
                    _obscureText ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: _obscureText, // Manage password visibility
            ),
            SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return TColors.primaryColorButton; // Color when checked
                          }
                          return TColors.textWhite; // Color when unchecked
                        },
                      ),
                      checkColor: TColors.textWhite, // Color of the checkmark
                    ),
                    Text(TTexts.rememberMe),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPassword());
                  },
                  child: Text(TTexts.forgotPassword),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            TButton(
              title: TTexts.createAcc,
              onPressed: () => _submitForm(context), // Call API on button press
            ),
          ],
        ),
      ),
    );
  }
}
