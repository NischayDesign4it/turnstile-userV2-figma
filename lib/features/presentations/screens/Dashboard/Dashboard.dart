import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Scaffold(
      backgroundColor: dark ? TColors.textBlack : TColors.textWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  child: Center(
                    child: Image(
                      image: AssetImage(
                          dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                    ),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSection),
              Obx(() => TileContainer(
                title: TTexts.profile,
                subTitle: TTexts.profileSubtitle,
                onTap: () => Get.to(() => ProfileScreen(dark: dark)),
                isDone: controller.isProfileDone.value,
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
              )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                title: TTexts.orientation,
                subTitle: TTexts.orientationSubtitle,
                onTap: () => Get.to(() => OrientationScreen()),
                isDone: controller.isOrientationDone.value,
              )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                title: TTexts.myComply,
                subTitle: TTexts.myComplySubtitle,
                onTap: () => Get.to(() => myComplyScreen()),
                isDone: controller.isMyComplyDone.value,
              )),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(() => TileContainer(
                title: TTexts.tagId,
                subTitle: TTexts.tagIdSubtitle,
                onTap: () => Get.to(() => TagIDScreen()),
                isDone: controller.isTagIdDone.value,
              )),
              SizedBox(height: TSizes.spaceBtwSection),
            ],
          ),
        ),
      ),
    );
  }
}
