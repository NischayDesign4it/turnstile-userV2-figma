import 'package:flutter/material.dart';
import '../../../../utils/constants/images_strings.dart';
import '../../../../utils/constants/sizes.dart';


class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
    required this.dark, required this.title, required this.subTitle,
  });

  final bool dark;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            height: 50,
            image:
            AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo)),
        SizedBox(height: TSizes.md),
        Text(title,
            style: Theme.of(context).textTheme.headlineLarge),
        SizedBox(height: TSizes.sm),
        Text(subTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
