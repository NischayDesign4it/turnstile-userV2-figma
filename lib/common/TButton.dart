import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';


class TButton extends StatelessWidget {
  const TButton({
    super.key, required this.title, required this.onPressed,
  });
  final String title;
  final VoidCallback onPressed;



  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primaryColorButton,

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          onPressed: onPressed,
          child:
          Text(title,
            style: TextStyle(color: Colors.white),
          )

      ),
    );
  }
}
