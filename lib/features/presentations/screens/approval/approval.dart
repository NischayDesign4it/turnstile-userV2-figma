import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/TButton.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';

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

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      contentPadding: EdgeInsets.only(top: 10, left: 15, right: 15),
      content: SizedBox(
        width: 500,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    TTexts.orientation,
                    style: TextStyle(fontSize: TSizes.md),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            Flexible(
              child: Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "I hereby declare and understand and have provided accurate information",
                      style: TextStyle(fontSize: TSizes.md),
                      overflow: TextOverflow.visible, // Handle overflow
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            TButton(title: TTexts.submit, onPressed: () {  },)
          ],

        ),
      ),
    );
  }
}
