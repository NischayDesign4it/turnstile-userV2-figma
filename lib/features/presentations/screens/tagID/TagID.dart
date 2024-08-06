import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import '../../../../globals.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../../controller/Dashboard_controller.dart';
import '../Dashboard/Dashboard.dart';
import '../QR/QRScreen.dart';

class TagIDScreen extends StatefulWidget {
  final String? tag_id;

  TagIDScreen({super.key, this.tag_id});

  Future<void> postData(String tagId, String email, BuildContext context) async {
    final url = Uri.parse('http://44.214.230.69:8000/post_tagid/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tag_id': tagId,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, show success pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Data uploaded successfully."),
            actions: <Widget>[

              TButton(
                  title: "OK",
                  onPressed: () {
                    Get.find<DashboardController>().completeTagId();
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
      // If the server does not return a 200 OK response, show failure pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to upload data."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  State<TagIDScreen> createState() => _TagIDScreenState();
}

class _TagIDScreenState extends State<TagIDScreen> {
  late TextEditingController _tag_idController;

  @override
  void initState() {
    super.initState();
    _tag_idController = TextEditingController(text: widget.tag_id ?? '');
  }

  @override
  void dispose() {
    _tag_idController.dispose();
    super.dispose();
  }

  Future<void> _navigateAndScanQr(BuildContext context) async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrScanner(title: TTexts.myTagIdTitle, subtitle: TTexts.qrSubTitle,)),
    );

    if (scannedData != null) {
      setState(() {
        _tag_idController.text = scannedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      appBar: AppBar(
        title: Text("TAG-ID"),
        backgroundColor: dark ? TColors.textBlack : TColors.textWhite,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Iconsax.tag),
                SizedBox(width: 5), // Add space between icon and text
                Text(TTexts.tagId),
              ],
            ),
            SizedBox(height: TSizes.xs),
            TextFormField(
                controller: _tag_idController,
                cursorColor: TColors.textBlack,
                style: TextStyle(color: TColors.textBlack),
                decoration: InputDecoration(
                  hintText: TTexts.tagId, // Add a hint text for the description
                  hintStyle: TextStyle(color: TColors.textBlack.withOpacity(0.5)), // Hint text style
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12, // Increased vertical padding
                    horizontal: 15,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

            SizedBox(height: 20),
            TButton(title: "QR", onPressed: (){_navigateAndScanQr(context);}),
            SizedBox(height: 10),
            TButton(title: "Submit", onPressed: () async {
              await widget.postData(_tag_idController.text, loggedInUserEmail, context);
            },),
          ],
        ),
      ),
    );
  }
}
