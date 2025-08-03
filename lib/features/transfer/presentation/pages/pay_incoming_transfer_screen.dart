import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/extentions/size_extension.dart';
import '../../../../common/utils/number_to_arabic_words.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/large_button.dart';
import '../../../transfer/data/models/trans_details_response.dart';
import '../../../../generated/locale_keys.g.dart';

class PayIncomingTransferScreen extends StatefulWidget {
  final TransDetailsResponse transDetailsResponse;
  const PayIncomingTransferScreen({super.key, required this.transDetailsResponse});

  @override
  State<PayIncomingTransferScreen> createState() => _PayIncomingTransferScreenState();
}

class _PayIncomingTransferScreenState extends State<PayIncomingTransferScreen> {
  bool checkBoxValue = false;

  final TextEditingController secretFormController = TextEditingController();
  String getFinalBalance(String amount) {
    String balanceInWords = NumberToArabicWords.convertToWords(double.parse(amount).toInt());

    return balanceInWords;
  }

  @override
  Widget build(BuildContext context) {
    final Data transDetails = widget.transDetailsResponse.data;
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: Container(
          width: context.screenWidth,
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: AppText.displaySmall(
                  LocaleKeys.credits_receive_credit.tr(),
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: context.primaryColor),

                child: Column(
                  children: [
                    _buildRowData(lable: LocaleKeys.transfer_transaction_number.tr(), value: transDetails.transnum),
                    _buildRowData(
                      lable: LocaleKeys.credits_date_of_send.tr(),
                      value: DateFormat('yyyy-MM-dd HH:mm:ss').format(transDetails.transdate),
                    ),
                    SizedBox(height: 15),
                    _buildRowData(
                      lable: LocaleKeys.credits_amount.tr(),
                      value: "${transDetails.amount} ${transDetails.currencyName}",
                      valueColor: Colors.green,
                    ),
                    _buildRowData(
                      lable: "",
                      value: "${getFinalBalance(transDetails.amount)} ${transDetails.currencyName}",
                      valueColor: Colors.green,
                    ),
                    SizedBox(height: 15),

                    _buildRowData(
                      lable: LocaleKeys.transfer_fees.tr(),
                      value: "${transDetails.fee} ${transDetails.currencyName}",
                    ),
                    _buildRowData(lable: LocaleKeys.transfer_received_to.tr(), value: transDetails.targetName),
                    SizedBox(height: 15),

                    _buildRowData(lable: LocaleKeys.transfer_beneficiary_name.tr(), value: transDetails.benifName),
                    _buildRowData(lable: LocaleKeys.transfer_beneficiary_phone.tr(), value: transDetails.benifPhone),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    checkColor: context.primaryContainer,
                    fillColor: WidgetStatePropertyAll(context.primaryColor),
                    value: checkBoxValue,
                    onChanged: (val) {
                      setState(() {
                        checkBoxValue = val!;
                      });
                    },
                  ),
                  Flexible(
                    child: AppText.bodyMedium(
                      LocaleKeys.credits_accept_all_terms.tr(),
                      color: context.onPrimaryColor,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              buildFieldTitle(title: LocaleKeys.credits_secret_number.tr()),
              SizedBox(height: 3),
              buildTextField(hint: "", controller: secretFormController),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LargeButton(
                  onPressed: () {},
                  text: "استلام الاعتماد",
                  circularRadius: 12,
                  backgroundColor: context.primaryContainer,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowData({required String lable, required String value, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText.bodyMedium(
            lable,
            fontWeight: FontWeight.bold,
            color: context.onPrimaryColor,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: AppText.bodyMedium(
            value,
            fontWeight: FontWeight.bold,
            color: valueColor ?? context.onPrimaryColor,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget buildFieldTitle({required String title}) {
    return Align(
      alignment: Alignment.centerRight,
      child: AppText.labelLarge(
        title,
        textAlign: TextAlign.right,
        color: context.onPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    String validatorTitle = "",
    int mxLine = 1,
    Widget? sufIcon,
    bool? readOnly,
    dynamic Function()? onTap,
    bool needValidation = true,
  }) {
    return CustomTextField(
      onTap: onTap,
      readOnly: readOnly,
      mxLine: mxLine,
      controller: controller,
      hint: hint,
      validator:
          needValidation
              ? (value) {
                if (value == null || value.isEmpty) {
                  return validatorTitle.isNotEmpty ? validatorTitle : LocaleKeys.transfer_this_field_cant_be_empty.tr();
                }
                return null;
              }
              : null,
      sufIcon: sufIcon,
    );
  }
}
