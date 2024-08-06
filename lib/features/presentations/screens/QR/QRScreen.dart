import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class QrScanner extends StatefulWidget {
  final String title;
  final String subtitle;

  QrScanner({required this.title, required this.subtitle});

  @override
  State<QrScanner> createState() => _QrScannerState();
}


class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.pop(context, scanData.code); // Pass the scanned data back
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // QR scanner view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Additional UI elements
          Positioned(
            top: 20,
            right: -10, // Adjust as needed
            child: Container(
              width: 100,
              height: 100,
              color: Colors.transparent,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the scanner
                  },
                  child: Icon(
                    Iconsax.close_circle,
                    color: TColors.textWhite,
                  ),
                ),
              ),
            ),
          ),
          // Center container with dotted border and text
          Positioned(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    dashPattern: [6, 3],
                    color: Colors.white,
                    strokeWidth: 2,
                    child: Container(
                      height: 300,
                      width: 300,
                      color: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems), // Space between container and text
                  Text(
                    widget.title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems / 2), // Space between container and text

                  Text(
                    widget.subtitle,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
