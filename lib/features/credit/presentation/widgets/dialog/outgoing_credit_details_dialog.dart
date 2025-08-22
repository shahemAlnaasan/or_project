import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/extentions/navigation_extensions.dart';
import '../../../../../common/extentions/size_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../../transfer/data/models/trans_details_response.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class OutgoingCreditDetailsDialog extends StatelessWidget {
  final TransDetailsResponse transDetailsResponse;
  const OutgoingCreditDetailsDialog({super.key, required this.transDetailsResponse});
  String getTransStatus(int status) {
    switch (status) {
      case 1:
        return "غير مسلمة";
      case 2:
        return "مسلمة";
      case 3:
        return "محذوفة";
      case 4:
        return "محجوزة";
      case 5:
        return "مجمدة";
      default:
        return "غير مسلمة";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Data transDetails = transDetailsResponse.data;
    final companyName = "شركة الأخطبـــــوط الذهــبــي";

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
                label: LocaleKeys.transfer_transmitting_center.tr(),
                value: transDetails.srcName,
                context: context,
              ),
              _infoRow(label: LocaleKeys.transfer_destination.tr(), value: transDetails.targetName, context: context),
              _infoRow(label: LocaleKeys.transfer_money_amount.tr(), value: transDetails.amount, context: context),
              _infoRow(label: LocaleKeys.credits_fees_money.tr(), value: transDetails.fee, context: context),
              _infoRow(
                label: LocaleKeys.transfer_date_of_transfer.tr(),
                value: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.tryParse(transDetails.transdate)!),
                context: context,
              ),
              _infoRow(label: LocaleKeys.credits_credit_number.tr(), value: transDetails.transnum, context: context),
              _infoRow(label: LocaleKeys.credits_notes.tr(), value: transDetails.notes, context: context),
              _infoRow(label: LocaleKeys.credits_secret_number.tr(), value: transDetails.password, context: context),
              _infoRow(
                label: LocaleKeys.credits_status.tr(),
                value: getTransStatus(int.parse(transDetails.status)),
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
                      "نسخ",
                      Icons.copy,
                      Color(0xffcc5a56),
                      onPressed: () {
                        final data = '''
$companyName  
مصدر الاعتماد  :${transDetails.srcName}  
وجهة الاعتماد  :${transDetails.targetName}  
المبلغ   :${transDetails.amount} ${transDetails.currencyName}  
العمولة   :${transDetails.fee} ${transDetails.currencyName}  
تاريخ   :${transDetails.transdate}  
رقم الاعتماد    :${transDetails.transnum}  
ملاحظات    :${transDetails.notes}  
الرقم السري    :${transDetails.password}  
الحالة  :  ${getTransStatus(int.parse(transDetails.status))}    
''';
                        Clipboard.setData(ClipboardData(text: data));
                        ToastificationDialog.showToast(
                          msg: LocaleKeys.transfer_copied_to_clipboard.tr(),
                          context: context,
                          type: ToastificationType.success,
                        );
                        log(transDetails.transnum);
                      },
                    ),
                    _dialogButton(context, "حسنا", Icons.check, Color(0xff71cbaf), onPressed: () => context.pop()),
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
  BuildContext context,
  String label,
  IconData icon,
  Color color, {
  required void Function()? onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    icon: Icon(icon, size: 18, color: context.onPrimaryColor),
    label: AppText.labelLarge(label, color: context.onPrimaryColor, fontWeight: FontWeight.bold),
  );
}
