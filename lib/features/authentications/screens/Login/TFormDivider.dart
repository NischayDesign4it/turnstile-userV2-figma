import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';


class TDivider extends StatelessWidget {
  const TDivider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey, thickness: 2.0, indent: 20, endIndent: 5)),
        Text("OR", style: Theme.of(context).textTheme.labelMedium),
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey, thickness: 2.0, indent: 5, endIndent: 20)),

      ],
    );
  }
}
