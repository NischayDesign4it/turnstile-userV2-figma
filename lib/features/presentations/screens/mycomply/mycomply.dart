// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:iconsax/iconsax.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// // import 'package:turnstileuser_v2/common/TButton.dart';
// // import '../../../../globals.dart';
// // import '../../../../utils/constants/colors.dart';
// // import '../../../../utils/constants/text_strings.dart';
// // import '../../../../utils/helpers/Thelper_functions.dart';
// // import '../Dashboard/Dashboard.dart';
// // import '../../controller/Dashboard_controller.dart';
// //
// // class myComplyScreen extends StatefulWidget {
// //   const myComplyScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<myComplyScreen> createState() => _myComplyScreenState();
// // }
// //
// // class _myComplyScreenState extends State<myComplyScreen> {
// //   final List<XFile> _images = [];
// //   final ImagePicker _picker = ImagePicker();
// //   bool _isLoading = false;
// //   final DashboardController dashboardController = Get.find<DashboardController>();
// //
// //   // TextEditingControllers for the extracted data
// //   final TextEditingController _dateController = TextEditingController();
// //   final TextEditingController _idController = TextEditingController();
// //
// //   Future<void> _pickImage() async {
// //     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
// //     if (image != null) {
// //       setState(() {
// //         _images.add(image);
// //       });
// //       await _performOCR(image);
// //     }
// //   }
// //
// //
// //   Future<void> _performOCR(XFile image) async {
// //     final inputImage = InputImage.fromFilePath(image.path);
// //     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
// //
// //     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
// //
// //     // Regular expressions to match "EXPIRY: MM/DD/YYYY" and "ID: ABCD123456"
// //     final expiryDateRegex = RegExp(r'\bEXPIRY:\s*(\d{2}/\d{2}/\d{4})\b');
// //     final idRegex = RegExp(r'\bID:\s*([A-Z0-9]{10})\b');
// //
// //     String? extractedDate;
// //     String? extractedId;
// //
// //     for (TextBlock block in recognizedText.blocks) {
// //       for (TextLine line in block.lines) {
// //         if (extractedDate == null) {
// //           final expiryMatch = expiryDateRegex.firstMatch(line.text);
// //           if (expiryMatch != null) {
// //             extractedDate = expiryMatch.group(1); // Extract just the date part
// //           }
// //         }
// //
// //         if (extractedId == null) {
// //           final idMatch = idRegex.firstMatch(line.text);
// //           if (idMatch != null) {
// //             extractedId = idMatch.group(1); // Extract just the ID part
// //           }
// //         }
// //
// //         if (extractedDate != null && extractedId != null) break;
// //       }
// //       if (extractedDate != null && extractedId != null) break;
// //     }
// //
// //     setState(() {
// //       _dateController.text = extractedDate ?? '';
// //       _idController.text = extractedId ?? '';
// //     });
// //
// //     textRecognizer.close();
// //   }
// //
// //
// //
// //   void _showConfirmationDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text("Confirm Submission"),
// //           content: Text(
// //             "Are you sure you want to submit these details?\n\n"
// //                 "Expiry Date: ${_dateController.text}\n"
// //                 "ID: ${_idController.text}",
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text("Cancel"),
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close the dialog
// //               },
// //             ),
// //             TextButton(
// //               child: Text("Submit"),
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close the dialog
// //                 _uploadImages(); // Proceed with the image upload
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //
// //   Future<void> _uploadImages() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     // MultipartRequest for image and data upload
// //     var request = http.MultipartRequest(
// //       'POST',
// //       Uri.parse('http://44.214.230.69:8000/mycomply_api/'),
// //     );
// //
// //     // Add fields to request
// //     request.fields['email'] = loggedInUserEmail;
// //     request.fields['mycompany_id'] = _idController.text; // Corrected field
// //     request.fields['expiry_date'] = _dateController.text; // Corrected field
// //
// //     // Add image files to request
// //     for (var image in _images) {
// //       request.files.add(await http.MultipartFile.fromPath(
// //         'my_comply',
// //         image.path,
// //       ));
// //     }
// //
// //     // Send the request and handle the response
// //     var response = await request.send();
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         _images.clear();
// //         _isLoading = false;
// //       });
// //       dashboardController.completeMyComply(); // Update state
// //       _showDialog("Success", "Cards are uploaded successfully.", true);
// //       print('Images uploaded successfully');
// //     } else {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       _showDialog("Error", "Please upload the proper information.", false);
// //       print('Image upload failed: ${response.statusCode}');
// //     }
// //   }
// //
// //
// //   void _showDialog(String title, String content, bool success) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(title),
// //           content: Text(content),
// //           actions: <Widget>[
// //             TButton(
// //               title: "OK",
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 if (success) {
// //                   Get.offAll(() => DashboardScreen(
// //                       dark: THelperFunctions.isDarkMode(
// //                           context))); // Navigate to DashboardScreen
// //                 }
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   // Future<void> _uploadImages() async {
// //   //   setState(() {
// //   //     _isLoading = true;
// //   //   });
// //   //
// //   //   var request = http.MultipartRequest(
// //   //     'POST',
// //   //     Uri.parse('http://44.214.230.69:8000/mycomply_api/'),
// //   //   );
// //   //   request.fields['email'] = loggedInUserEmail;
// //   //   request.fields['mycompany_id'] = _dateController.text;
// //   //   request.fields['expiry_date'] = _idController.text;
// //   //
// //   //   for (var image in _images) {
// //   //     request.files.add(await http.MultipartFile.fromPath(
// //   //       'my_comply',
// //   //       image.path,
// //   //     ));
// //   //   }
// //   //
// //   //   var response = await request.send();
// //   //   if (response.statusCode == 200) {
// //   //     setState(() {
// //   //       _images.clear();
// //   //       _isLoading = false;
// //   //     });
// //   //     dashboardController.completeMyComply(); // Update state
// //   //     _showDialog("Success", "Cards are uploaded successfully.", true);
// //   //     print('Images uploaded successfully');
// //   //   } else {
// //   //     setState(() {
// //   //       _isLoading = false;
// //   //     });
// //   //     _showDialog("Error", "Please upload the proper information.", false);
// //   //     print('Image upload failed');
// //   //   }
// //   // }
// //
// //   // void _showDialog(String title, String content, bool success) {
// //   //   showDialog(
// //   //     context: context,
// //   //     builder: (BuildContext context) {
// //   //       return AlertDialog(
// //   //         title: Text(title),
// //   //         content: Text(content),
// //   //         actions: <Widget>[
// //   //           TButton(
// //   //               title: "OK",
// //   //               onPressed: () {
// //   //                 Navigator.of(context).pop();
// //   //                 if (success) {
// //   //                   Get.offAll(() => DashboardScreen(
// //   //                       dark: THelperFunctions.isDarkMode(
// //   //                           context))); // Navigate to DashboardScreen
// //   //                 }
// //   //               })
// //   //         ],
// //   //       );
// //   //     },
// //   //   );
// //   // }
// //
// //   void _removeImage(int index) {
// //     setState(() {
// //       _images.removeAt(index);
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dark = THelperFunctions.isDarkMode(context);
// //
// //     return Scaffold(
// //       backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
// //       appBar: AppBar(
// //         title: Text(TTexts.myComply),
// //         backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
// //       ),
// //       body: Stack(
// //         children: [
// //           Column(
// //             children: [
// //               if (_dateController.text.isNotEmpty)
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: TextFormField(
// //                     controller: _dateController,
// //                     cursorColor: TColors.textBlack,
// //                     style: TextStyle(color: TColors.textBlack),
// //                     decoration: InputDecoration(
// //                       hintText: "Expiry Date",
// //                       contentPadding: EdgeInsets.symmetric(vertical: 12),
// //                       prefixIcon: Icon(Iconsax.calendar_edit),
// //                       filled: true,
// //                       border: OutlineInputBorder(
// //                         borderSide: BorderSide.none,
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               if (_idController.text.isNotEmpty)
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: TextFormField(
// //                     controller: _idController,
// //                     cursorColor: TColors.textBlack,
// //                     style: TextStyle(color: TColors.textBlack),
// //                     decoration: InputDecoration(
// //                       hintText: "ID",
// //                       contentPadding: EdgeInsets.symmetric(vertical: 12),
// //                       prefixIcon: Icon(Iconsax.tag),
// //                       filled: true,
// //                       border: OutlineInputBorder(
// //                         borderSide: BorderSide.none,
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               Expanded(
// //                 child: GridView.builder(
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 3,
// //                   ),
// //                   itemCount: _images.length,
// //                   itemBuilder: (context, index) {
// //                     return Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: Stack(
// //                         children: [
// //                           Image.file(
// //                             File(_images[index].path),
// //                             fit: BoxFit.cover,
// //                             width: double.infinity,
// //                             height: double.infinity,
// //                           ),
// //                           Positioned(
// //                             top: -13,
// //                             right: -13,
// //                             child: IconButton(
// //                               icon: Icon(Icons.cancel, color: Colors.white),
// //                               onPressed: () => _removeImage(index),
// //                             ),
// //                           )
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
// //                 child: TButton(title: 'Capture your card', onPressed: _pickImage),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 30),
// //                 child: TButton(title: 'Upload your card', onPressed: _uploadImages),
// //               ),
// //             ],
// //           ),
// //           if (_isLoading)
// //             Center(
// //               child: CircularProgressIndicator(
// //                 color: TColors.primaryColorButton,
// //                 backgroundColor: Colors.transparent,
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax/iconsax.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:turnstileuser_v2/common/TButton.dart';
// import '../../../../globals.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/text_strings.dart';
// import '../../../../utils/helpers/Thelper_functions.dart';
// import '../Dashboard/Dashboard.dart';
// import '../../controller/Dashboard_controller.dart';
//
// class myComplyScreen extends StatefulWidget {
//   const myComplyScreen({Key? key}) : super(key: key);
//
//   @override
//   State<myComplyScreen> createState() => _myComplyScreenState();
// }
//
// class _myComplyScreenState extends State<myComplyScreen> {
//   final List<XFile> _images = [];
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//   final DashboardController dashboardController = Get.find<DashboardController>();
//
//   // TextEditingControllers for the extracted data
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();
//
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         _images.add(image);
//       });
//       await _performOCR(image);
//     }
//   }
//
//   Future<void> _performOCR(XFile image) async {
//     final inputImage = InputImage.fromFilePath(image.path);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//
//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//     // Regular expressions to match "EXPIRY: MM/DD/YYYY" and "ID: ABCD123456"
//     final expiryDateRegex = RegExp(r'\bEXPIRY:\s*(\d{2}/\d{2}/\d{4})\b');
//     final idRegex = RegExp(r'\bID:\s*([A-Z0-9]{10})\b');
//
//     String? extractedDate;
//     String? extractedId;
//
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         if (extractedDate == null) {
//           final expiryMatch = expiryDateRegex.firstMatch(line.text);
//           if (expiryMatch != null) {
//             extractedDate = expiryMatch.group(1); // Extract just the date part
//           }
//         }
//
//         if (extractedId == null) {
//           final idMatch = idRegex.firstMatch(line.text);
//           if (idMatch != null) {
//             extractedId = idMatch.group(1); // Extract just the ID part
//           }
//         }
//
//         if (extractedDate != null && extractedId != null) break;
//       }
//       if (extractedDate != null && extractedId != null) break;
//     }
//
//     setState(() {
//       _dateController.text = extractedDate ?? '';
//       _idController.text = extractedId ?? '';
//     });
//
//     textRecognizer.close();
//   }
//
//   void _showConfirmationDialog() {
//     if (_dateController.text.isEmpty || _idController.text.isEmpty || _images.isEmpty) {
//       _showDialog(
//         "Error",
//         "Please capture you card closely. So that all fields are captured\n\n"
//             "${_dateController.text.isEmpty ? "Expiry Date is missing.\n" : ""}"
//             "${_idController.text.isEmpty ? "ID is missing.\n" : ""}"
//             "${_images.isEmpty ? "Card image is missing." : ""}",
//         false,
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Confirm Submission"),
//             content: Text(
//               "Are you sure you want to submit these details?\n\n"
//                   "Expiry Date: ${_dateController.text}\n"
//                   "ID: ${_idController.text}",
//             ),
//             actions: <Widget>[
//               TButton(title: "Cancel", onPressed: (){
//                 Navigator.of(context).pop();}),
//               SizedBox(height: TSizes.xs),
//               TButton(title: "Submit", onPressed: (){
//                 Navigator.of(context).pop();
//                 _uploadImages();
//               })
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   Future<void> _uploadImages() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     // MultipartRequest for image and data upload
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://44.214.230.69:8000/mycomply_api/'),
//     );
//
//     // Add fields to request
//     request.fields['email'] = loggedInUserEmail;
//     request.fields['mycompany_id'] = _idController.text; // Corrected field
//     request.fields['expiry_date'] = _dateController.text; // Corrected field
//
//     // Add image files to request
//     for (var image in _images) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'my_comply',
//         image.path,
//       ));
//     }
//
//     // Send the request and handle the response
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       setState(() {
//         _images.clear();
//         _isLoading = false;
//       });
//       dashboardController.completeMyComply(); // Update state
//       _showDialog("Success", "Cards are uploaded successfully.", true);
//       print('Images uploaded successfully');
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       _showDialog("Error", "Please upload the proper information.", false);
//       print('Image upload failed: ${response.statusCode}');
//     }
//   }
//
//   void _showDialog(String title, String content, bool success) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: <Widget>[
//             TButton(
//               title: "OK",
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (success) {
//                   Get.offAll(() => DashboardScreen(
//                       dark: THelperFunctions.isDarkMode(context))); // Navigate to DashboardScreen
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _removeImage(int index) {
//     setState(() {
//       _images.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return Scaffold(
//       backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
//       appBar: AppBar(
//         title: Text(TTexts.myComply),
//         backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               if (_dateController.text.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _dateController,
//                     cursorColor: TColors.textBlack,
//                     style: TextStyle(color: TColors.textBlack),
//                     decoration: InputDecoration(
//                       hintText: "Expiry Date",
//                       contentPadding: EdgeInsets.symmetric(vertical: 12),
//                       prefixIcon: Icon(Iconsax.calendar_edit),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//               if (_idController.text.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: _idController,
//                     cursorColor: TColors.textBlack,
//                     style: TextStyle(color: TColors.textBlack),
//                     decoration: InputDecoration(
//                       hintText: "ID",
//                       contentPadding: EdgeInsets.symmetric(vertical: 12),
//                       prefixIcon: Icon(Iconsax.tag),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide.none,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                   ),
//                   itemCount: _images.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Stack(
//                         children: [
//                           Image.file(
//                             File(_images[index].path),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                           ),
//                           Positioned(
//                             top: -13,
//                             right: -13,
//                             child: IconButton(
//                               icon: Icon(Icons.cancel, color: Colors.white),
//                               onPressed: () => _removeImage(index),
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
//                 child: TButton(title: 'Capture your card', onPressed: _pickImage),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 30),
//                 child: TButton(
//                   title: 'Upload your card',
//                   onPressed: _showConfirmationDialog, // Updated to use confirmation dialog
//                 ),
//               ),
//             ],
//           ),
//           if (_isLoading)
//             Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
//


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import '../../../../globals.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../Dashboard/Dashboard.dart';
import '../../controller/Dashboard_controller.dart';

class myComplyScreen extends StatefulWidget {
  const myComplyScreen({Key? key}) : super(key: key);

  @override
  State<myComplyScreen> createState() => _myComplyScreenState();
}

class _myComplyScreenState extends State<myComplyScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final DashboardController dashboardController = Get.find<DashboardController>();

  // TextEditingControllers for the extracted data
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Check if the image is of good quality
      final imageFile = File(image.path);
      final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());

      if (decodedImage.width < 600 || decodedImage.height < 400) {
        _showDialog("Image Quality", "Please capture the card closer and make sure it's in focus.", false);
        return;
      }

      setState(() {
        _images.add(image);
      });
      await _performOCR(image);
    }
  }

  Future<void> _performOCR(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Improved regular expressions
    final expiryDateRegex = RegExp(r'\bEXPIR(Y|ATION)[:\s]*(\d{2}/\d{2}/\d{4})\b', caseSensitive: false);
    final idRegex = RegExp(r'\bID[:\s]*([A-Z0-9]+)\b');

    String? extractedDate;
    String? extractedId;

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (extractedDate == null) {
          final expiryMatch = expiryDateRegex.firstMatch(line.text);
          if (expiryMatch != null) {
            extractedDate = expiryMatch.group(2); // Extract date part
          }
        }

        if (extractedId == null) {
          final idMatch = idRegex.firstMatch(line.text);
          if (idMatch != null) {
            extractedId = idMatch.group(1); // Extract ID part
          }
        }

        if (extractedDate != null && extractedId != null) break;
      }
      if (extractedDate != null && extractedId != null) break;
    }

    setState(() {
      _dateController.text = extractedDate ?? '';
      _idController.text = extractedId ?? '';
    });

    textRecognizer.close();
  }

  void _showConfirmationDialog() {
    if (_dateController.text.isEmpty || _idController.text.isEmpty || _images.isEmpty) {
      _showDialog(
        "Error",
        "Please capture your card clearly:\n"
            "${_dateController.text.isEmpty ? "- Expiry Date is missing.\n" : ""}"
            "${_idController.text.isEmpty ? "- ID is missing.\n" : ""}"
            "${_images.isEmpty ? "- Card image is missing." : ""}",
        false,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Submission"),
            content: Text(
              "Are you sure you want to submit these details?\n\n"
                  "Expiry Date: ${_dateController.text}\n"
                  "ID: ${_idController.text}",
            ),
            actions: <Widget>[
              TButton(title: "Submit", onPressed: () {
                Navigator.of(context).pop();
                _uploadImages();
              }),
              SizedBox(height: TSizes.xs),
              TButton(title: "Cancel", onPressed: () {
                Navigator.of(context).pop();
              }),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    // MultipartRequest for image and data upload
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://44.214.230.69:8000/mycomply_api/'),
    );

    // Add fields to request
    request.fields['email'] = loggedInUserEmail;
    request.fields['mycompany_id'] = _idController.text;
    request.fields['expiry_date'] = _dateController.text;

    // Add image files to request
    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'my_comply',
        image.path,
      ));
    }

    // Send the request and handle the response
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        _images.clear();
        _isLoading = false;
      });
      dashboardController.completeMyComply();
      _showDialog("Success", "Cards uploaded successfully.", true);
      print('Images uploaded successfully');
    } else {
      setState(() {
        _isLoading = false;
      });
      _showDialog("Error", "Failed to upload. Please try again.", false);
      print('Image upload failed: ${response.statusCode}');
    }
  }

  void _showDialog(String title, String content, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TButton(
              title: "OK",
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                  Get.offAll(() => DashboardScreen(
                      dark: THelperFunctions.isDarkMode(context)));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        title: Text(TTexts.myComply),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_dateController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _dateController,
                    cursorColor: TColors.textBlack,
                    style: TextStyle(color: TColors.textBlack),
                    decoration: InputDecoration(
                      hintText: "Expiry Date",
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      prefixIcon: Icon(Iconsax.calendar_edit),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (_idController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _idController,
                    cursorColor: TColors.textBlack,
                    style: TextStyle(color: TColors.textBlack),
                    decoration: InputDecoration(
                      hintText: "ID",
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      prefixIcon: Icon(Iconsax.tag),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Image.file(
                            File(_images[index].path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: -13,
                            right: -13,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.white),
                              onPressed: () => _removeImage(index),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (!_isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
                  child: TButton(
                    title: "Capture your Card",
                    onPressed: _pickImage,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 30),
                child: TButton(
                  title: "Upload your card",
                  onPressed: _showConfirmationDialog,
                ),
              ),
            ],
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
