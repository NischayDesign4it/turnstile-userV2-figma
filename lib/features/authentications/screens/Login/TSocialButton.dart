import 'package:flutter/material.dart';
import 'package:turnstileuser_v2/utils/constants/text_strings.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/images_strings.dart';
import '../../../../utils/constants/sizes.dart';





class TSepcialButton extends StatelessWidget {
  const TSepcialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    width: TSizes.iconMd,
                    height: TSizes.iconMd,
                    image: AssetImage(TImages.google),
                  ),
                ),
                Text(
                  TTexts.googleSignIn,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: TSizes.spaceBtwItems /2),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image(
                    width: TSizes.iconMd,
                    height: TSizes.iconMd,
                    image: AssetImage(TImages.apple),
                  ),
                ),
                Text(
                  TTexts.appleSignIn,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }
}
