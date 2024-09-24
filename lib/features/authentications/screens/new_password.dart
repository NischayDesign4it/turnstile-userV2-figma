import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/spacing_styles.dart';
import '../../../utils/helpers/Thelper_functions.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;

import 'Login/Login.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  bool otpVerified = false;
  bool isLoading = false;
  String globalEmail = globals.loggedInUserEmail;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        title: Text("Set your new password"),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      ),
      body: Padding(
        padding: TSpacingStyle.paddingWithAppHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!otpVerified)
              // OTP input
                TextFormField(
                  controller: otpController,
                  cursorColor: TColors.textBlack,
                  style: TextStyle(color: TColors.textBlack),
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: Icon(Iconsax.direct_right),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              else
              // New password input
                TextFormField(
                  controller: passwordController,
                  cursorColor: TColors.textBlack,
                  obscureText: true,
                  style: TextStyle(color: TColors.textBlack),
                  decoration: InputDecoration(
                    hintText: "Enter New Password",
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: Icon(Iconsax.lock),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              SizedBox(height: TSizes.spaceBtwItems),
              isLoading
                  ? CircularProgressIndicator(
                color: TColors.primaryColorButton,
              ) // Show loading indicator when waiting for API
                  : TButton(
                  title: otpVerified ? "Change Password" : "Verify OTP",
                  onPressed: () async {
                    if (!otpVerified) {
                      // Verify OTP entered by the user
                      bool isValidOtp = await verifyOtp(otpController.text);
                      if (isValidOtp) {
                        setState(() {
                          otpVerified = true; // If OTP is valid, move to password input
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Try again"),
                              content: Text("Please enter a valid OTP"),
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
                    } else {
                      // Change password once OTP is verified
                      await changePassword();
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  // API call to verify the OTP
  Future<bool> verifyOtp(String otp) async {
    setState(() {
      isLoading = true; // Show loading while verifying OTP
    });


    final url = Uri.parse('http://44.214.230.69:8000/verify_otp/');

    // Send the request with email and otp as form data
    final response = await http.post(
      url,
      body: {
        'email': globalEmail, // Use the global email
        'otp': otp, // User-entered OTP
        // No need to send 'new_password' for OTP verification at this stage
      },
    );

    setState(() {
      isLoading = false; // Stop loading spinner
    });

    if (response.statusCode == 200) {
      // Assuming the OTP is verified successfully
      return true;
    } else {
      // Handle failure, e.g., invalid OTP
      return false;
    }
  }

  // API call to reset the password
  Future<void> changePassword() async {
    setState(() {
      isLoading = true; // Show loading spinner during API call
    });

    // Replace with your actual API URL
    final url = Uri.parse('http://44.214.230.69:8000/reset_password/');

    // Send the request with email, otp, and new password as form data
    final response = await http.post(
      url,
      body: {
        'email': globalEmail, // Use the global email
        'otp': otpController.text, // Pass the entered OTP
        'new_password': passwordController.text, // User-entered new password
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Password Changed Succesfully"),
            actions: <Widget>[
              TButton(
                title: "OK",
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(() => LoginScreen());
                },
              ),
            ],
          );
        },
      );
      // Optionally, navigate to login or dashboard screen
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Try again"),
            content: Text("Failed to change the password"),
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

    setState(() {
      isLoading = false; // Stop loading spinner
    });
  }
}
