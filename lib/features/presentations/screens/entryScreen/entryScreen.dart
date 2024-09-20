import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../utils/constants/colors.dart';
import '../../../authentications/screens/Login/Login.dart';
import '../../../authentications/screens/Signup/signup.dart';


class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/logo/Banner.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 108.0),
                  child: Image.asset(
                    'assets/logo/Logo.png',
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Revolutionize Site Security with \nOur Patented Dual-Validation \nTurnstile System",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "The First in the Market to Pair MyComply Cards with \nFacial Recognition for Authentic Access",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Center buttons horizontally
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => LoginScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColorButton,
                        ),
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                            color: TColors.textWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Space between buttons
                    SizedBox(
                      width: 170,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () =>
                            Get.to(() => SignupScreen()),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 2,
                            color: TColors.primaryColorButton,
                          ),
                        ),
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: TColors.primaryColorButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
