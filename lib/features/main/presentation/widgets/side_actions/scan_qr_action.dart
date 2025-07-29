import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/extentions/size_extension.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../../../generated/assets.gen.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide BarcodeFormat, Barcode;
import 'package:toastification/toastification.dart';

class ScanQrAction extends StatefulWidget {
  const ScanQrAction({super.key});

  @override
  State<ScanQrAction> createState() => _ScanQrActionState();
}

class _ScanQrActionState extends State<ScanQrAction> {
  String? barcode;
  final MobileScannerController controller = MobileScannerController(facing: CameraFacing.front);

  Future<void> _pickImageAndScanQR() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        setState(() => barcode = barcodes.first.rawValue);
        log(barcode.toString());
      } else {
        setState(() => barcode = 'No QR code found in image.');
      }

      barcodeScanner.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth / 1.2,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(0), bottomRight: Radius.circular(12)),
        border: Border.all(color: Colors.transparent),
        boxShadow: [BoxShadow(color: context.onPrimaryColor.withAlpha(150), blurRadius: 3, blurStyle: BlurStyle.solid)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  child: MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      barcode = capture.barcodes.first.rawValue;
                      log(barcode.toString());
                      ToastificationDialog.showToast(
                        msg: barcode.toString(),
                        context: context,
                        type: ToastificationType.success,
                      );
                    },
                  ),
                ),
                Image.asset(Assets.images.sideActions.frame.path, scale: 2, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => _pickImageAndScanQR(),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: context.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Text("اختيار ملف", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
