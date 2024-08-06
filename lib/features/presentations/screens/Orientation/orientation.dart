import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import 'package:get/get.dart';
import '../../../../globals.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../../controller/Dashboard_controller.dart';
import '../Dashboard/Dashboard.dart';

class OrientationScreen extends StatefulWidget {
  OrientationScreen({Key? key}) : super(key: key);

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  String _localFilePath = '';
  bool _isLoading = true;
  bool _isUploading = false;
  String? _errorMessage;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    _fetchAndSavePdf();
  }

  Future<void> _fetchAndSavePdf() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://44.214.230.69:8000/get_orientation_api/'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;
        if (jsonResponse.isNotEmpty) {
          jsonResponse.sort((a, b) {
            final int idA = a['id'] as int;
            final int idB = b['id'] as int;
            return idB.compareTo(idA);
          });

          final pdfUrl = jsonResponse[0]['attachments'] as String;
          await _downloadAndSavePdf(pdfUrl);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No PDF URL found in the response';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch PDF URL: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch PDF URL: $e';
      });
    }
  }

  Future<void> _downloadAndSavePdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/downloaded.pdf');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          _localFilePath = file.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to download PDF: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to download PDF: $e';
      });
    }
  }

  Future<void> _signAndUploadPdf() async {
    setState(() {
      _isUploading = true;
    });
    try {
      final Uint8List signatureBytes =
          await _signatureController.toPngBytes() ?? Uint8List(0);
      if (signatureBytes.isEmpty) {
        throw Exception("Signature is empty");
      }

      final dir = await getApplicationDocumentsDirectory();
      final document =
          pdf.PdfDocument(inputBytes: File(_localFilePath).readAsBytesSync());

      final int lastIndex = document.pages.count - 1;
      final PdfPage lastPage = document.pages[lastIndex];

      final PdfBitmap signatureImage = pdf.PdfBitmap(signatureBytes);
      lastPage.graphics.drawImage(
        signatureImage,
        Rect.fromLTWH(150, 500, 100, 70),
      );

      final signedPdfPath = '${dir.path}/signed_document.pdf';
      File(signedPdfPath).writeAsBytesSync(document.saveSync());

      await _uploadSignedPdf(signedPdfPath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign and upload PDF: $e')),
      );
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadSignedPdf(String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://44.214.230.69:8000/post_orientation/'),
      );
      request.fields['email'] = loggedInUserEmail;
      request.files
          .add(await http.MultipartFile.fromPath('orientation', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        _signatureController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("PDF uploaded successfully"),
              actions: [

                TButton(
                    title: "OK",
                    onPressed: () {
                      Get.find<DashboardController>().completeOrientation();
                      Navigator.of(context).pop();
                      Get.offAll(() => DashboardScreen(
                          dark: THelperFunctions.isDarkMode(
                              context))); // Navigate to DashboardScreen
                    })
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload PDF')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload PDF: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // Stop upload loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ORIENTATION"),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator(
            color: TColors.primaryColorButton,
          ))
              : _localFilePath.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: PDFView(
                            filePath: _localFilePath,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Add your signature and upload the document.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        Signature(
                          controller: _signatureController,
                          height: 150,
                          backgroundColor: Colors.grey[200]!,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TButton(
                                title: "Clear",
                                onPressed: () {
                                  _signatureController.clear();
                                },
                              ),
                              SizedBox(height: 10),
                              TButton(
                                title: "Sign & Upload",
                                onPressed: _signAndUploadPdf,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Contact to your administration for documents"),
                          ElevatedButton(
                            onPressed: () {
                              _signatureController.clear();
                              _fetchAndSavePdf(); // Retry fetching PDF
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
          if (_isUploading)
            Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: TColors.primaryColorButton,

                ),
              ),
            ),
        ],
      ),
    );
  }
}
