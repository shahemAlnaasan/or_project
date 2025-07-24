// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

class CreditReceiptScreen extends StatefulWidget {
  final Map<String, String> data;

  const CreditReceiptScreen({super.key, required this.data});

  @override
  State<CreditReceiptScreen> createState() => _CreditReceiptScreenState();
}

class _CreditReceiptScreenState extends State<CreditReceiptScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _downloadImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: "receipt_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true) {
        ToastificationDialog.showToast(msg: "تم التحميل بنجاح", context: context, type: ToastificationType.success);
      } else {
        throw Exception("Saving failed");
      }
    } catch (e) {
      ToastificationDialog.showToast(msg: "خطأ اثناء التحميل", context: context, type: ToastificationType.error);
    }
  }

  Future<void> _shareImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/shared_receipt.png');
      await file.writeAsBytes(pngBytes);
      final params = ShareParams(text: 'إشعار الحوالة', files: [XFile(file.path)]);

      await SharePlus.instance.share(params);
    } catch (e) {
      ToastificationDialog.showToast(msg: "خطأ اثناء المشاركة", context: context, type: ToastificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: context.screenWidth,
        child: Column(
          children: [
            // TransferReciept(globalKey: _globalKey, data: widget.data),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(label: "إغلاق", onTap: () => context.pop()),
                _buildButton(label: "مشاركة", onTap: _shareImage),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                  label: "نسخ المعلومات",
                  onTap: () {
                    final data = '''''';
                    Clipboard.setData(ClipboardData(text: data));
                    ToastificationDialog.showToast(
                      msg: LocaleKeys.transfer_copied_to_clipboard.tr(),
                      context: context,
                      type: ToastificationType.success,
                    );
                  },
                ),
                _buildButton(label: "تحميل كصورة", onTap: _downloadImage),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Color(0xff78bddc), borderRadius: BorderRadius.circular(8)),
        child: AppText.bodyMedium(label, height: 0, color: Colors.white),
      ),
    );
  }
}
