import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';

class TileContainer extends StatelessWidget {
  const TileContainer({
    super.key, required this.title, required this.subTitle, required this.onTap, this.isDone = false,
  });

  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              color: TColors.inputBg,
              borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isDone)
                            Container(
                              margin: EdgeInsets.only(left: 8.0),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: TColors.primaryColorButton,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        subTitle,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  Icon(Iconsax.direct_right, color: TColors.textBlack,), // Your suffix icon
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


