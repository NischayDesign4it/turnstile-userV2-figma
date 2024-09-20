import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:turnstileuser_v2/common/TButton.dart';
import 'package:turnstileuser_v2/globals.dart';
import 'package:turnstileuser_v2/utils/constants/colors.dart';
import 'package:turnstileuser_v2/utils/constants/text_strings.dart';
import 'package:turnstileuser_v2/utils/constants/sizes.dart';
import '../../../../../utils/helpers/Thelper_functions.dart';
import '../../../controller/Dashboard_controller.dart';
import '../../Dashboard/Dashboard.dart';

class CustomShapeBorder extends ShapeBorder {
  final double borderRadius;

  const CustomShapeBorder({this.borderRadius = 8});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return CustomShapeBorder(borderRadius: borderRadius * t);
  }
}

class FaceEnrollDialog extends StatefulWidget {
  const FaceEnrollDialog({super.key});

  @override
  _FaceEnrollDialogState createState() => _FaceEnrollDialogState();
}

class _FaceEnrollDialogState extends State<FaceEnrollDialog> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _isProcessing = true; // Show loading indicator
      });

      // Process images in parallel
      final futures = pickedFiles.map((pickedFile) async {
        final originalImage =
            img.decodeImage(File(pickedFile.path).readAsBytesSync());
        if (originalImage != null) {
          debugPrint(
              'Original image dimensions: ${originalImage.width}x${originalImage.height} pixels');
          final resizedImage = await _resizeImage(File(pickedFile.path));
          final resizedImageDimensions = img.decodeImage(resizedImage);
          if (resizedImageDimensions != null) {
            debugPrint(
                'Resized image dimensions: ${resizedImageDimensions.width}x${resizedImageDimensions.height} pixels');
          }
          return XFile.fromData(resizedImage, path: pickedFile.path);
        }
        return null;
      }).toList();

      final results = await Future.wait(futures);

      setState(() {
        _images.addAll(results.whereType<XFile>());
        _isProcessing = false; // Hide loading indicator
      });

      // Navigate to SelectedImagesScreen
      Get.to(() => SelectedImagesScreen(images: _images));
    }
  }

  Future<Uint8List> _resizeImage(File file) async {
    final image = img.decodeImage(file.readAsBytesSync());
    final resizedImage =
        img.copyResize(image!, width: 480); // Resize to 480 pixels wide
    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  void _showSelectedImages() {
    if (_images.isNotEmpty) {
      Get.to(() => SelectedImagesScreen(images: _images));
    } else {
      Get.snackbar('No Images', 'Please select or take at least one image.',
          colorText: TColors.textWhite, backgroundColor: TColors.textBlack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
      content: SizedBox(
        width: 500,
        height: 280,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(TTexts.faceEnroll,
                      style: TextStyle(fontSize: TSizes.md)),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    await Get.to(() => CameraScreen(
                          onImagesCaptured: (List<XFile> files) {
                            setState(() {
                              _images.addAll(files);
                            });
                            _showSelectedImages();
                          },
                        ));
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        color: TColors.inputBg,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.camera, color: TColors.textBlack),
                        SizedBox(height: TSizes.sm),
                        Text(TTexts.takeImage,
                            style: TextStyle(color: TColors.textBlack)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        color: TColors.inputBg,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.image, color: TColors.textBlack),
                        SizedBox(height: TSizes.sm),
                        Text(TTexts.tookImage,
                            style: TextStyle(color: TColors.textBlack)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwSection),
            TButton(title: "Show Selection", onPressed: _showSelectedImages)
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final Function(List<XFile>) onImagesCaptured;

  const CameraScreen({required this.onImagesCaptured, Key? key})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  List<XFile> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.high,
    );
    await _cameraController?.initialize();
    setState(() {});
  }

  // Future<void> _initializeCamera() async {
  //   try {
  //     _cameras = await availableCameras();
  //
  //     // Check if any camera is available
  //     if (_cameras == null || _cameras!.isEmpty) {
  //       throw Exception('No cameras found on the device.');
  //     }
  //
  //     // Try to get the front camera, or fallback to the first available one
  //     CameraDescription selectedCamera = _cameras!.firstWhere(
  //       (camera) => camera.lensDirection == CameraLensDirection.front,
  //       orElse: () => _cameras!.first, // Fallback to the first available camera
  //     );
  //
  //     _cameraController = CameraController(
  //       selectedCamera,
  //       ResolutionPreset.high,
  //     );
  //     await _cameraController?.initialize();
  //     setState(() {});
  //   } catch (e) {
  //     // Handle errors here
  //     print('Error initializing camera: $e');
  //     Get.snackbar(
  //         'Camera Error', 'Failed to initialize the camera. Please try again.',
  //         colorText: TColors.textWhite, backgroundColor: TColors.textBlack);
  //   }
  // }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final pickedFile = await _cameraController?.takePicture();
    if (pickedFile != null) {
      final resizedImage = await _resizeImage(File(pickedFile.path));
      setState(() {
        _capturedImages
            .add(XFile.fromData(resizedImage, path: pickedFile.path));
      });
    }
  }

  Future<Uint8List> _resizeImage(File file) async {
    final image = img.decodeImage(file.readAsBytesSync());
    final resizedImage =
        img.copyResize(image!, width: 480); // Resize to 480 pixels wide
    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera')),
        body: Center(
            child: CircularProgressIndicator(
          color: TColors.primaryColorButton,
        )),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: CameraPreview(_cameraController!),
          ),
          CustomPaint(
            painter: FaceShapePainter(),
            child: Container(),
          ),
          Positioned(
              left: 50,
              top: 50,
              child: Text(
                "Note: Please click atleast 3 images",
                style: TextStyle(
                    fontSize: 18,
                    color: TColors.textWhite,
                    fontWeight: FontWeight.bold),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Images Captured: ${_capturedImages.length}',
                    style: TextStyle(
                        fontSize: 18,
                        color: TColors.primaryColorButton,
                        fontWeight: FontWeight.bold),
                  ),
                  FloatingActionButton(
                    backgroundColor: TColors.primaryColorButton,
                    child: Icon(Iconsax.camera, color: TColors.textWhite),
                    onPressed: _takePhoto,
                    shape: CircleBorder(),
                  ),
                  FloatingActionButton(
                    backgroundColor: TColors.primaryColorButton,
                    child: Text(
                      "Done",
                      style: TextStyle(color: TColors.textWhite),
                    ),
                    onPressed: () {
                      widget.onImagesCaptured(_capturedImages);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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

class FaceShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TColors.primaryColorButton
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(
      size.width * 0.1, // Adjust the position and size as needed
      size.height * 0.1,
      size.width * 0.8,
      size.height * 0.6,
    );

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SelectedImagesScreen extends StatefulWidget {
  final List<XFile> images;

  SelectedImagesScreen({required this.images});

  @override
  _SelectedImagesScreenState createState() => _SelectedImagesScreenState();
}

class _SelectedImagesScreenState extends State<SelectedImagesScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  bool _isLoading = false;


  Future<void> _uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://44.214.230.69:8000/face_api/'),
      );
      request.fields['email'] = loggedInUserEmail; // Replace with actual user email

      for (var image in widget.images) {
        request.files.add(await http.MultipartFile.fromPath(
          'facial_data',
          image.path,
        ));
      }

      var response = await request.send();

      // Read the response data
      var responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        setState(() {
          widget.images.clear();
          _isLoading = false;
        });
        dashboardController.completeFace();
        _showDialog("Success", "Images are uploaded successfully.", true);
        print('Images uploaded successfully');
      } else {
        setState(() {
          _isLoading = false;
        });
        _showDialog("Error", "Please upload the proper information.", false);
        print('Image upload failed: ${responseData.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showDialog("Error", "Something went wrong. Please try again.", false);
      print('Image upload failed with exception: $e');
    }
  }


  void _removeImage(int index) {
    setState(() {
      widget.images.removeAt(index);
    });
  }

  void _showDialog(String title, String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TButton(
                title: "OK",
                onPressed: () {
                  Navigator.of(context).pop();
                  if (success) {
                    Get.offAll(() => DashboardScreen(
                        dark: THelperFunctions.isDarkMode(context)));
                  }
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        title: Text('Selected Images'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: TColors.primaryColorButton,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              File(widget.images[index].path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TButton(
                    title: 'Upload Images',
                    onPressed: _uploadImages,
                  ),
                ),
              ],
            ),
    );
  }
}
