import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:turnstileuser_v2/common/TButton.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/spacing_styles.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/Thelper_functions.dart';
import 'new_password.dart';
import '../../../globals.dart' as globals;



class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  final emailController = TextEditingController();

  Future<void> sendOtp(String email, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://44.214.230.69:8000/send_otp/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Handle success response
        final responseData = json.decode(response.body);
        Get.to(() => ChangePassword());
        print('OTP sent successfully: $responseData');
      } else {
        // Handle error response
        print('Failed to send OTP: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Try again"),
              content: Text("Please enter a valid email address"),
              actions: <Widget>[
                TButton(
                  title: "OK",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle network or other errors
      print('Error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      ),
      body: Padding(
        padding: TSpacingStyle.paddingWithAppHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.email,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  prefixIcon: Icon(Iconsax.direct_right),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                enabled: !isLoading, // Disable input when loading
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              isLoading
                  ? CircularProgressIndicator(
                color: TColors.primaryColorButton,
              ) // Show loading indicator
                  : TButton(
                title: "Send OTP",
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    globals.loggedInUserEmail = email;
                    sendOtp(email, context);

                    print(globals.loggedInUserEmail);
                  } else {
                    // Show an error message if email is empty
                    print("Please enter a valid email.");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

