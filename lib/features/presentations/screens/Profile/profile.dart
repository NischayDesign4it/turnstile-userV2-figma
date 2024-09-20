// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:turnstileuser_v2/common/TButton.dart';
// import 'package:turnstileuser_v2/utils/constants/sizes.dart';
// import 'package:http/http.dart' as http;
// import '../../../../globals.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/text_strings.dart';
// import '../../../../utils/helpers/Thelper_functions.dart';
// import '../../controller/Dashboard_controller.dart';
// import '../Dashboard/Dashboard.dart';
//
// class ProfileScreen extends StatefulWidget {
//   ProfileScreen({Key? key, required this.dark}) : super(key: key);
//
//   final bool dark;
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController companyNameController = TextEditingController();
//   final TextEditingController companyIdController = TextEditingController();
//   final TextEditingController jobRoleController = TextEditingController();
//   final TextEditingController jobLocationController = TextEditingController();
//
//   File? _selectedImage;
//   final picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _selectedImage = File(pickedFile.path);
//       }
//     });
//   }
//
//   Future<void> workerRegister(BuildContext context, String name, String companyName, String jobRole, String myCompanyId, String jobLocation) async {
//     final String apiUrl = 'http://44.214.230.69:8000/user_profile_api/';
//
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       if (_selectedImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('picture', _selectedImage!.path));
//       }
//
//       request.fields['name'] = name;
//       request.fields['company_name'] = companyName;
//       request.fields['job_role'] = jobRole;
//       request.fields['mycompany_id'] = myCompanyId;
//       request.fields['job_location'] = jobLocation;
//       request.fields['email'] = loggedInUserEmail;
//
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         print('Registration response: $responseData');
//
//         // Check if the response indicates successful registration
//         if (responseData == responseData) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Upload Successful'),
//                 content: Text('The details have been uploaded successfully.'),
//                 actions: [
//                   TButton(
//                     title: "OK",
//                     onPressed: () {
//                       Get.find<DashboardController>().completeProfile();
//                       Navigator.of(context).pop();
//                       Get.offAll(() => DashboardScreen(
//                         dark: THelperFunctions.isDarkMode(context),
//                       )); // Navigate to DashboardScreen
//                     },
//                   )
//                 ],
//               );
//             },
//           );
//           nameController.clear();
//           companyIdController.clear();
//           companyNameController.clear();
//           jobLocationController.clear();
//           jobRoleController.clear();
//           setState(() {
//             _selectedImage = null;
//           });
//         } else {
//           // Handle registration failure
//           print('Registration failed. Message: ${responseData['message']}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Incorrect details. Please try again.'),
//               duration: Duration(seconds: 3),
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       } else {
//         // Handle other HTTP status codes
//         print('Registration failed. Status code: ${response.statusCode}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('An error occurred. Please try again later.'),
//             duration: Duration(seconds: 3),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle exceptions
//       print('Error during registration: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'An error occurred. Please try again later.',
//             style: TextStyle(color: Colors.white),
//           ),
//           duration: Duration(seconds: 3),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return Scaffold(
//       backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
//       appBar: AppBar(
//         backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
//         title: Text(
//           TTexts.myDetail,
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.md),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile Image with Border
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: TColors.primaryColorBorder, // Border color
//                         width: 2, // Border width
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[200],
//                       backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
//                       child: _selectedImage == null ? Icon(Iconsax.user, size: 40) : null,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.md),
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     height: 40,
//                     width: 150,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Iconsax.camera, color: Colors.black),
//                         SizedBox(width: 5),
//                         Text("Change Image", style: TextStyle(color: Colors.black)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.defaultSpace),
//
//               // Full Name
//               Row(
//                 children: [
//                   Icon(Iconsax.user),
//                   SizedBox(width: 5),
//                   Text(TTexts.name),
//                 ],
//               ),
//               SizedBox(height: TSizes.xs),
//               TextFormField(
//                 controller: nameController,
//                 cursorColor: TColors.textBlack,
//                 style: TextStyle(color: TColors.textBlack),
//                 decoration: InputDecoration(
//                   hintText: TTexts.name,
//                   hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 15,
//                   ),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.spaceBtwItems),
//
//               // Company Name
//               Row(
//                 children: [
//                   Icon(Iconsax.building),
//                   SizedBox(width: 5),
//                   Text(TTexts.companyName),
//                 ],
//               ),
//               SizedBox(height: TSizes.xs),
//               TextFormField(
//                 controller: companyNameController,
//                 cursorColor: TColors.textBlack,
//                 style: TextStyle(color: TColors.textBlack),
//                 decoration: InputDecoration(
//                   hintText: TTexts.companyName,
//                   hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 15,
//                   ),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.spaceBtwItems),
//
//               // Worker ID
//               Row(
//                 children: [
//                   Icon(Iconsax.user_tag),
//                   SizedBox(width: 5),
//                   Text(TTexts.workerID),
//                 ],
//               ),
//               SizedBox(height: TSizes.xs),
//               TextFormField(
//                 controller: companyIdController,
//                 cursorColor: TColors.textBlack,
//                 style: TextStyle(color: TColors.textBlack),
//                 decoration: InputDecoration(
//                   hintText: TTexts.workerID,
//                   hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 15,
//                   ),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.spaceBtwItems),
//
//               // Job Role
//               Row(
//                 children: [
//                   Icon(Iconsax.user_square),
//                   SizedBox(width: 5),
//                   Text(TTexts.jobRole),
//                 ],
//               ),
//               SizedBox(height: TSizes.xs),
//               TextFormField(
//                 controller: jobRoleController,
//                 cursorColor: TColors.textBlack,
//                 style: TextStyle(color: TColors.textBlack),
//                 decoration: InputDecoration(
//                   hintText: TTexts.jobRole,
//                   hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 15,
//                   ),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.spaceBtwItems),
//
//               // Job Location
//               Row(
//                 children: [
//                   Icon(Iconsax.user_square),
//                   SizedBox(width: 5),
//                   Text(TTexts.jobLocation),
//                 ],
//               ),
//               SizedBox(height: TSizes.xs),
//               TextFormField(
//                 controller: jobLocationController,
//                 cursorColor: TColors.textBlack,
//                 style: TextStyle(color: TColors.textBlack),
//                 decoration: InputDecoration(
//                   hintText: TTexts.jobLocation,
//                   hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 15,
//                   ),
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: TSizes.spaceBtwSection),
//
//               Padding(
//                 padding: const EdgeInsets.only(bottom: TSizes.lg),
//                 child: TButton(
//                   title: TTexts.save,
//                   onPressed: () {
//                     workerRegister(
//                       context,
//                       nameController.text,
//                       companyNameController.text,
//                       jobRoleController.text,
//                       companyIdController.text,
//                       jobLocationController.text,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import 'package:turnstileuser_v2/utils/constants/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../../globals.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../../controller/Dashboard_controller.dart';
import '../Dashboard/Dashboard.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.dark}) : super(key: key);

  final bool dark;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  // final TextEditingController companyIdController = TextEditingController();
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController jobLocationController = TextEditingController();

  File? _selectedImage;
  final picker = ImagePicker();

  List<String> departments = [];
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final String apiUrl = 'http://44.214.230.69:8000/get_active_inactive/';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          departments = data.map((project) => project['name'] as String).toList();
        });
      } else {
        print('Failed to load departments');
      }
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> workerRegister(BuildContext context, String name, String companyName, String jobRole, String jobLocation) async {
    final String apiUrl = 'http://44.214.230.69:8000/user_profile_api/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('picture', _selectedImage!.path));
      }

      request.fields['name'] = name;
      request.fields['company_name'] = companyName;
      request.fields['job_role'] = jobRole;
      // request.fields['mycompany_id'] = myCompanyId;
      request.fields['job_location'] = jobLocation;
      request.fields['email'] = loggedInUserEmail;
      if (selectedDepartment != null) {
        request.fields['site'] = selectedDepartment!;
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Registration response: $responseData');

        // Check if the response indicates successful registration
        if (responseData == responseData) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Upload Successful'),
                content: Text('The details have been uploaded successfully.'),
                actions: [
                  TButton(
                    title: "OK",
                    onPressed: () {
                      Get.find<DashboardController>().completeProfile();
                      Navigator.of(context).pop();
                      Get.offAll(() => DashboardScreen(
                        dark: THelperFunctions.isDarkMode(context),
                      )); // Navigate to DashboardScreen
                    },
                  )
                ],
              );
            },
          );
          nameController.clear();
          // companyIdController.clear();
          companyNameController.clear();
          jobLocationController.clear();
          jobRoleController.clear();
          setState(() {
            _selectedImage = null;
          });
        } else {
          // Handle registration failure
          print('Registration failed. Message: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect details. Please try again.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Handle other HTTP status codes
        print('Registration failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
        title: Text(
          TTexts.myDetail,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image with Border
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: TColors.primaryColorBorder, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null ? Icon(Iconsax.user, size: 40) : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: TSizes.md),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.camera, color: Colors.black),
                        SizedBox(width: 5),
                        Text("Change Image", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: TSizes.defaultSpace),

              // Full Name
              Row(
                children: [
                  Icon(Iconsax.user),
                  SizedBox(width: 5),
                  Text(TTexts.name),
                ],
              ),
              SizedBox(height: TSizes.xs),
              TextFormField(
                controller: nameController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.name,
                  hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              // Company Name
              Row(
                children: [
                  Icon(Iconsax.building),
                  SizedBox(width: 5),
                  Text(TTexts.companyName),
                ],
              ),
              SizedBox(height: TSizes.xs),
              TextFormField(
                controller: companyNameController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.companyName,
                  hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              // Worker ID
              // Row(
              //   children: [
              //     Icon(Iconsax.user_tag),
              //     SizedBox(width: 5),
              //     Text(TTexts.workerID),
              //   ],
              // ),
              // SizedBox(height: TSizes.xs),
              // TextFormField(
              //   controller: companyIdController,
              //   cursorColor: TColors.textBlack,
              //   style: TextStyle(color: TColors.textBlack),
              //   decoration: InputDecoration(
              //     hintText: TTexts.workerID,
              //     hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
              //     contentPadding: EdgeInsets.symmetric(
              //       vertical: 12,
              //       horizontal: 15,
              //     ),
              //     filled: true,
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide.none,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              // SizedBox(height: TSizes.spaceBtwItems),

              // Job Role
              Row(
                children: [
                  Icon(Iconsax.user_square),
                  SizedBox(width: 5),
                  Text(TTexts.jobRole),
                ],
              ),
              SizedBox(height: TSizes.xs),
              TextFormField(
                controller: jobRoleController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.jobRole,
                  hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              // Job Location
              Row(
                children: [
                  Icon(Iconsax.user_square),
                  SizedBox(width: 5),
                  Text(TTexts.jobLocation),
                ],
              ),
              SizedBox(height: TSizes.xs),
              TextFormField(
                controller: jobLocationController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.jobLocation,
                  hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSection),

              // Department Dropdown
              Row(
                children: [
                  Icon(Iconsax.building_3),
                  SizedBox(width: 5),
                  Text('Sites'),
                ],
              ),
              SizedBox(height: TSizes.xs),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                hint: Text('Select Site'),
                onChanged: (newValue) {
                  setState(() {
                    selectedDepartment = newValue;
                  });
                },
                items: departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSection),

              Padding(
                padding: const EdgeInsets.only(bottom: TSizes.lg),
                child: TButton(
                  title: TTexts.save,
                  onPressed: () {
                    workerRegister(
                      context,
                      nameController.text,
                      companyNameController.text,
                      jobRoleController.text,
                      // companyIdController.text,
                      jobLocationController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
