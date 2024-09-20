import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:turnstileuser_v2/common/TButton.dart';
import 'package:turnstileuser_v2/features/authentications/screens/Login/Login.dart';
import 'package:turnstileuser_v2/features/presentations/screens/cameraScreen/face_enroll/FaceEnroll.dart';
import 'package:turnstileuser_v2/utils/constants/colors.dart';
import 'package:turnstileuser_v2/utils/constants/sizes.dart';
import '../../../../utils/constants/images_strings.dart';
import '../../../../utils/constants/spacing_styles.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/Thelper_functions.dart';
import '../../controller/Dashboard_controller.dart';
import '../Orientation/orientation.dart';
import '../Profile/profile.dart';
import '../mycomply/mycomply.dart';
import '../tagID/TagID.dart';
import 'TileContainer.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    Get.put<DashboardController>(DashboardController(), permanent: true);

    final DashboardController controller = Get.find<DashboardController>();

    // Function to calculate the completion percentage
    double _calculateCompletionPercentage() {
      int totalSteps = 5;
      int completedSteps = 0;

      if (controller.isProfileDone.value) completedSteps++;
      if (controller.isFaceDone.value) completedSteps++;
      if (controller.isOrientationDone.value) completedSteps++;
      if (controller.isMyComplyDone.value) completedSteps++;
      if (controller.isTagIdDone.value) completedSteps++;

      return completedSteps / totalSteps;
    }

    // Function to handle Save button press
    void onSavePressed() {
      if (_calculateCompletionPercentage() == 1.0 &&
          controller.isCheckboxEnabled.value) {
        // Show success dialog
        Get.defaultDialog(
          title: "Success",
          content: Text("You have successfully registered."),
          confirm: TButton(
            title: "OK",
            onPressed: () {
              Get.back();
              Get.to(() => LoginScreen());
            },
          ),
        );
      } else {
        // Show error dialog
        Get.defaultDialog(
          title: "Incomplete Information",
          content: Text(
              "Please complete all the steps and check the checkbox before saving."),
          confirm: TButton(
            title: "OK",
            onPressed: () {
              Get.back(); // Close the dialog
            },
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                child: Center(
                  child: Image(
                    image: AssetImage(
                        dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSection),
              Text(
                "Please fill your details down below...",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => LinearPercentIndicator(
                animation: true,
                width: 280,
                lineHeight: 14.0,
                percent: _calculateCompletionPercentage(),
                backgroundColor: TColors.grey,
                progressColor: TColors.primaryColorButton,
                trailing: Text(
                    "${(_calculateCompletionPercentage() * 100).toInt()}%"),
              )),

              SizedBox(height: TSizes.spaceBtwSection / 2),
              Obx(() => TileContainer(
                    title: TTexts.profile,
                    subTitle: TTexts.profileSubtitle,
                    onTap: () => Get.to(() => ProfileScreen(dark: dark)),
                    isDone: controller.isProfileDone.value,
                    isPending: !controller.isProfileDone.value,
                  )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                    title: TTexts.face,
                    subTitle: TTexts.faceSubtitle,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FaceEnrollDialog();
                        },
                      );
                    },
                    isDone: controller.isFaceDone.value,
                    isPending: !controller.isFaceDone.value,
                  )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                    title: TTexts.orientation,
                    subTitle: TTexts.orientationSubtitle,
                    onTap: () => Get.to(() => OrientationScreen()),
                    isDone: controller.isOrientationDone.value,
                    isPending: !controller.isOrientationDone.value,
                  )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                    title: TTexts.myComply,
                    subTitle: TTexts.myComplySubtitle,
                    onTap: () => Get.to(() => myComplyScreen()),
                    isDone: controller.isMyComplyDone.value,
                    isPending: !controller.isMyComplyDone.value,
                  )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                    title: TTexts.tagId,
                    subTitle: TTexts.tagIdSubtitle,
                    onTap: () => Get.to(() => TagIDScreen()),
                    isDone: controller.isTagIdDone.value,
                    isPending: !controller.isTagIdDone.value,
                  )),
              Obx(() => CheckboxListTile(
                    title: Text(
                      "Make sure you fill all the information above. Press the button to save.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w600),
                    ),
                    value: controller.isCheckboxEnabled.value,
                    onChanged: (bool? value) {
                      if (value != null) {
                        controller.isCheckboxEnabled.value = value;
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: TColors.primaryColorButton,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.standard,
                  )),
              SizedBox(height: TSizes.spaceBtwSection / 2),
              TButton(title: TTexts.save, onPressed: onSavePressed ),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              TButton(title: "Log Out", onPressed: () {
                Get.to(() => LoginScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }
}


