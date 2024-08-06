import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../globals.dart';

class DashboardController extends GetxController {
  var isProfileDone = false.obs;
  var isFaceDone = false.obs;
  var isOrientationDone = false.obs;
  var isMyComplyDone = false.obs;
  var isTagIdDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkProfileCompletion(loggedInUserEmail); // Call this method when the controller is initialized
  }

  void completeProfile() {
    isProfileDone.value = true;
  }

  void completeFace() {
    isFaceDone.value = true;
  }

  void completeOrientation() {
    isOrientationDone.value = true;
  }

  void completeMyComply() {
    isMyComplyDone.value = true;
  }

  void completeTagId() {
    isTagIdDone.value = true;
  }

  Future<void> checkProfileCompletion(String loggedInUserEmail) async {
    final String apiUrl = 'http://44.214.230.69:8000/get_user_data/'; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': loggedInUserEmail,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);


        // Reset all values before checking the response
        isProfileDone.value = false;
        isFaceDone.value = false;
        isOrientationDone.value = false;
        isMyComplyDone.value = false;
        isTagIdDone.value = false;

        // Check for non-null and non-empty values
        if (responseData['name'] != null && responseData['name'].toString().isNotEmpty &&
            responseData['company_name'] != null && responseData['company_name'].toString().isNotEmpty &&
            responseData['job_role'] != null && responseData['job_role'].toString().isNotEmpty &&
            responseData['mycompany_id'] != null && responseData['mycompany_id'].toString().isNotEmpty &&
            responseData['job_location'] != null && responseData['job_location'].toString().isNotEmpty) {
          completeProfile();
        }
        if (responseData['facial_data'] != null && responseData['facial_data'].toString().isNotEmpty) {
          completeFace();
        }
        if (responseData['orientation'] != null && responseData['orientation'].toString().isNotEmpty) {
          completeOrientation();
        }
        if (responseData['my_comply'] != null && responseData['my_comply'].toString().isNotEmpty) {
          completeMyComply();
        }
        if (responseData['tag_id'] != null && responseData['tag_id'].toString().isNotEmpty) {
          completeTagId();
        }
      } else {
        print('Failed to check profile completion. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during profile completion check: $e');
    }
  }
}
