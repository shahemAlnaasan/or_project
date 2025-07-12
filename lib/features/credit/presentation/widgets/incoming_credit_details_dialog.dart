import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/credit/data/models/incoming_credits_response.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class IncomingCreditDetailsDialog extends StatelessWidget {
  final IncomingCreditsResponse incomingCreditsResponse;
  const IncomingCreditDetailsDialog({super.key, required this.incomingCreditsResponse});

  String getCreditStatus(String status) {
    switch (status) {
      case "1":
        return "غير مستلم";
      case "2":
        return "مستلم";
      case "3":
        return "محذوف";
      case "4":
        return "محجوز";
      case "5":
        return "مجمد";

      default:
        return "غير مستلمة";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: context.screenWidth,
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: context.primaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.transfer_outgoing_transfer.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: context.onPrimaryColor, fontSize: 22),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(Icons.close, color: context.onPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info rows using variables
              _infoRow(
                label: LocaleKeys.credits_credit_source.tr(),
                value: incomingCreditsResponse.source,
                context: context,
              ),
              _infoRow(
                label: LocaleKeys.credits_credit_destination.tr(),
                value: incomingCreditsResponse.source,
                context: context,
              ),
              _infoRow(label: LocaleKeys.credits_amount.tr(), value: incomingCreditsResponse.source, context: context),
              _infoRow(
                label: LocaleKeys.credits_transfer_date.tr(),
                value: incomingCreditsResponse.source,
                context: context,
              ),
              _infoRow(
                label: LocaleKeys.credits_credit_number.tr(),
                value: incomingCreditsResponse.source,
                context: context,
              ),
              _infoRow(label: LocaleKeys.credits_notes.tr(), value: incomingCreditsResponse.source, context: context),
              _infoRow(
                label: LocaleKeys.credits_status.tr(),
                value: getCreditStatus(incomingCreditsResponse.status),
                context: context,
              ),
              const SizedBox(height: 16),

              // Buttons
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _dialogButton(
                      context,
                      label: "حسنا",
                      color: const Color.fromARGB(255, 106, 222, 222),
                      onPressed: () => context.pop(),
                    ),
                    _dialogButton(
                      context,
                      label: "نسخ",
                      icon: Icons.copy,
                      color: Color(0xffcc5a56),
                      onPressed: () {
                        final data = '''
${incomingCreditsResponse.source}  
المبلغ  :${incomingCreditsResponse.source}  
العمولة  :${incomingCreditsResponse.source}  
تاريخ التحويل   :${incomingCreditsResponse.source}  
رقم الحوالة   :${incomingCreditsResponse.source}  
اسم المستفيد   :${incomingCreditsResponse.source}  
الملاحظات    :${incomingCreditsResponse.source}  
الرقم السري    :${incomingCreditsResponse.source}  
الحالة  :  ${incomingCreditsResponse.source}    
''';
                        Clipboard.setData(ClipboardData(text: data));
                        ToastificationDialog.showToast(
                          msg: LocaleKeys.transfer_copied_to_clipboard.tr(),
                          context: context,
                          type: ToastificationType.success,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoRow({required String label, required String value, required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: AppText.bodyLarge(
      "$label: $value",
      // textDirection: TextDirection.rtl,
      color: context.onPrimaryColor,
    ),
  );
}

Widget _dialogButton(
  BuildContext context, {
  required String label,
  IconData? icon,
  required Color color,
  required void Function()? onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: icon != null ? Icon(icon, size: 18, color: context.onPrimaryColor) : null,
    label: AppText.labelLarge(label, color: context.onPrimaryColor, fontWeight: FontWeight.bold),
  );
}
