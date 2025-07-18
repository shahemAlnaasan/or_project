import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/transfer/data/models/received_transfer_response.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/transfer_receipt_screen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class ReceivedTransferDetailsDialog extends StatelessWidget {
  final ReceivedTransfers receivedTransfers;
  const ReceivedTransferDetailsDialog({super.key, required this.receivedTransfers});

  @override
  Widget build(BuildContext context) {
    // Extracted values
    final companyName = "شركة الأخطبـــــوط الذهــبــي";
    final senderCenter = "شهم";
    final destination = "ابراهيم كلي";
    final amount = "1,000 دولار";
    final fee = "7 دولار";
    final transferDate = "2025-06-23 20:27:04";
    final transferNumber = "BR23066215948";
    final senderName = "شهم - 4665656";
    final beneficiaryName = "بتنيتنيق";
    final beneficiaryPhone = "626262626";
    final notes = "";
    final secretCode = "26465";
    final status = "غير مستلمة";
    final deliveryDate = "";
    final destinationAddress = "كلي / جانب الدوار الشهداء";
    final destinationPhone = "03625145120085120201230";

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
              _infoRow(label: LocaleKeys.transfer_transmitting_center.tr(), value: senderCenter, context: context),
              _infoRow(label: LocaleKeys.transfer_destination.tr(), value: destination, context: context),
              _infoRow(label: LocaleKeys.transfer_amount.tr(), value: amount, context: context),
              _infoRow(label: LocaleKeys.transfer_fees.tr(), value: fee, context: context),
              _infoRow(label: LocaleKeys.transfer_date_of_transfer.tr(), value: transferDate, context: context),
              _infoRow(label: LocaleKeys.transfer_transfer_number.tr(), value: transferNumber, context: context),
              _infoRow(label: LocaleKeys.transfer_sender_name.tr(), value: senderName, context: context),
              _infoRow(label: LocaleKeys.transfer_beneficiary_name.tr(), value: beneficiaryName, context: context),
              _infoRow(label: LocaleKeys.transfer_beneficiary_phone.tr(), value: beneficiaryPhone, context: context),
              _infoRow(label: LocaleKeys.transfer_notes.tr(), value: notes, context: context),
              _infoRow(label: LocaleKeys.transfer_secret_number.tr(), value: secretCode, context: context),
              _infoRow(label: LocaleKeys.transfer_status.tr(), value: status, context: context),
              _infoRow(label: LocaleKeys.transfer_delivery_date.tr(), value: deliveryDate, context: context),
              _infoRow(
                label: LocaleKeys.transfer_destination_address.tr(),
                value: destinationAddress,
                context: context,
              ),
              _infoRow(label: LocaleKeys.transfer_destination_phone.tr(), value: destinationPhone, context: context),
              const SizedBox(height: 16),

              // Buttons
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _dialogButton(context, "تعديل", Icons.edit, Color(0xffa992e8), onPressed: () {}),
                    _dialogButton(context, "إلغاء", Icons.delete, Color(0xff71cbaf), onPressed: () {}),
                    _dialogButton(
                      context,
                      "نسخ",
                      Icons.copy,
                      Color(0xffcc5a56),
                      onPressed: () {
                        final data = '''
$companyName  
المبلغ  :$amount
العمولة  :$fee
تاريخ التحويل   :$transferDate
رقم الحوالة   :$transferNumber
اسم المستفيد   :$beneficiaryName
الملاحظات    :$notes
الرقم السري    :$secretCode
الحالة  :  $status  
''';
                        Clipboard.setData(ClipboardData(text: data));
                        ToastificationDialog.showToast(
                          msg: LocaleKeys.transfer_copied_to_clipboard.tr(),
                          context: context,
                          type: ToastificationType.success,
                        );
                      },
                    ),
                    _dialogButton(
                      context,
                      "إشعار",
                      Icons.notifications,
                      Color(0xff79bdd8),
                      onPressed:
                          () => context.push(
                            TransferReceiptScreen(
                              data: {
                                "ref": "BR23066215948",
                                "date": "2025-06-23",
                                "destination": "إدلب - 109",
                                "source": "999",
                                "secret": "26465",
                                "phone": "626262626",
                                "receiver": "بيتتيت",
                                "amount": "1,000",
                                "address": "إدلب، إبراهيم كلي، جانب دوار الشهداء",
                              },
                            ),
                          ),
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
