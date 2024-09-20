import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/images_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../../../presentations/screens/Dashboard/Dashboard.dart';
import 'package:turnstileuser_v2/globals.dart' as globals;

class TSepcialButton extends StatelessWidget {
  TSepcialButton({
    super.key,
    required this.dark,
  });

  final bool dark;
  final _secureStorage = FlutterSecureStorage();

  // Google Sign-In
  Future<void> signIn() async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      final response = await handleGoogleSignIn(user.displayName, user.email);
      if (response != null) {
        print('Success: $response');
        globals.loggedInUserEmail = user.email;
        Get.to(() => DashboardScreen(dark: dark));
        print(globals.loggedInUserEmail);
      } else {
        print('Failed to sign in with Google.');
      }
    } else {
      print('Failed to retrieve Google user.');
    }
  }

  // Google Sign-In API Call
  Future<String?> handleGoogleSignIn(String? displayName, String email) async {
    final url = Uri.parse('http://44.214.230.69:8000/google_login/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'display_name': displayName,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }

  Future<void> handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      String? userId = credential.userIdentifier;
      String? email = credential.email;
      String? firstName = credential.givenName;
      String? familyName = credential.familyName;

      if (userId != null) {
        // Check if the user exists in the database
        bool userExists = await checkUserExists(userId);

        if (userExists) {
          print("Login successful for user: $userId");
          Get.to(() => DashboardScreen(dark: dark));
        } else {
          // User does not exist, create a new user
          if (email != null && firstName != null && familyName != null) {
            await createNewUser(userId, firstName, familyName, email);
            globals.loggedInUserEmail = email;
            print("New user created: $userId");
            Get.to(() => DashboardScreen(dark: dark));
          } else {
            print("User data is incomplete for new account creation.");
          }
        }
      }
    } catch (e) {
      print("Error during Apple Sign-In: $e");
    }
  }

// Function to check if the user exists
  Future<bool> checkUserExists(String userId) async {
    final url = Uri.parse(
        'http://44.214.230.69:8000/apple_check/'); // Replace with your Django API endpoint
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userIdentifier': userId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Extract the email from the response if it exists and store it in globals
      if (responseData.containsKey('email') && responseData['email'] != null) {
        globals.loggedInUserEmail = responseData['email'];
        print('Email set to global: ${globals.loggedInUserEmail}');
      } else {
        print('Email not provided in the response.');
      }
      return responseData['exists'] == true;
    } else {
      print("Failed to check user: ${response.statusCode}");
      return false;
    }
  }

// Function to create a new user
  Future<void> createNewUser(
      String userId, String firstName, String familyName, String email) async {
    final url = Uri.parse('http://44.214.230.69:8000/apple_create/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userIdentifier': userId,
        'first_name': firstName,
        'family_name': familyName,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print("User created successfully: ${response.body}");
    } else {
      print("Failed to create user: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: signIn,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: TColors.grey),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage(TImages.google),
                    ),
                  ),
                  Text(
                    TTexts.googleSignIn,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: TSizes.spaceBtwItems / 2),
          GestureDetector(
            // onTap: () async {
            //   final credential = await SignInWithApple.getAppleIDCredential(
            //     scopes: [
            //       AppleIDAuthorizationScopes.email,
            //       AppleIDAuthorizationScopes.fullName,
            //     ],
            //   );
            //   print(credential.userIdentifier);
            //   print(credential.email);
            //   print(credential.familyName);
            //
            // },
            onTap: handleAppleSignIn,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: TColors.grey),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage(TImages.apple),
                    ),
                  ),
                  Text(
                    TTexts.appleSignIn,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}
