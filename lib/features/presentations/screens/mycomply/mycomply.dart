import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import '../../../../globals.dart';
import '../../../../utils/constants/colors.dart';
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://44.214.230.69:8000/mycomply_api/'),
    );
    request.fields['email'] = loggedInUserEmail;
    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'my_comply',
        image.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        _images.clear();
        _isLoading = false;
      });
      dashboardController.completeMyComply(); // Update state
      _showDialog("Success", "Cards are uploaded successfully.", true);
      print('Images uploaded successfully');
    } else {
      setState(() {
        _isLoading = false;
      });
      _showDialog("Error", "Please upload the proper information.", false);
      print('Image upload failed');
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
                        dark: THelperFunctions.isDarkMode(
                            context))); // Navigate to DashboardScreen
                  }
                })
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
        title: Text("MyComply-Tag"),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
                child: TButton(title: 'Capture your card', onPressed: _pickImage),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 30),
                child: TButton(title: 'Upload your card', onPressed: _uploadImages),
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: TColors.primaryColorButton,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
