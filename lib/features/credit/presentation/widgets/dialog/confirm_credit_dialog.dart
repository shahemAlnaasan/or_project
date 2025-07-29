import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';

class ConfirmCreditDialog extends StatelessWidget {
  final String senderName;
  final String amount;
  final void Function()? onPressed;
  const ConfirmCreditDialog({super.key, required this.senderName, required this.amount, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.warning_amber_rounded, size: 80, color: context.primaryContainer)),
            SizedBox(height: 20),
            Center(
              child: AppText.displaySmall(
                "هل أنت متأكد ؟؟",
                fontWeight: FontWeight.bold,
                color: context.onPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppText.bodyMedium(
                "ارسال مبلغ $amount الى $senderName ؟",
                fontWeight: FontWeight.bold,
                color: context.onPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("إلغاء", style: TextStyle(color: context.onPrimaryColor, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryContainer,
                      textStyle: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      onPressed;
                    },
                    child: const Text("تأكيد"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Text("$title:", style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 5, child: Text(value, textAlign: TextAlign.right)),
      ],
    ),
  );
}
