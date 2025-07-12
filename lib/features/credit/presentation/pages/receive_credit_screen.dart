import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class ReceiveCreditScreen extends StatefulWidget {
  const ReceiveCreditScreen({super.key});

  @override
  State<ReceiveCreditScreen> createState() => _ReceiveCreditScreenState();
}

class _ReceiveCreditScreenState extends State<ReceiveCreditScreen> {
  bool checkBoxValue = false;

  final TextEditingController secretFormController = TextEditingController();
  String textOne =
      "أي عمل يوز USDT لمبلغ أكبر من المعتاد أو بعموله وأجور أكبر من المعتاد لزبون مجهول ممكن أن يكون عمل غير شرعي الرجاء لا تدع الطمع في الأجور الجذابه أن يجرك وخذ وقتك للتأكد من صحه الاعتماد عن طريق التواصل مع الشركه أو مع المكتب المصدر قبل أن تستلم الاعتماد في حسابك لأنك ستكون مسؤول عن هذا المبلغ";
  String textTwo =
      "انتبه عند تسليم الاعتماد في حسابك فأنت تقر على مسؤوليتك على صحة هذا الاعتماد وأنك قمت بالتحقق من أن مصدر الاعتماد هو نفسه الشخص الذي اعطاك اشعار الاعتماد";
  String textThree =
      "يمنع منعًا باتًا قبول أي إعتـماد من زبون وتسليمه حوالة مقابله - خصوصا اعمال اليوز USDT- ، في حال وجود أي مخالفة لهذا الأمر سيتم حجز الاعتماد و إغلاق الصندوق فورًا";
  String textFour =
      "أؤكد على عدم قبول أي اعتماد لأعمال يوزUSDT أو لأعمال مشبوهه لزبائن خارجيين , أنا كوجهه الاعتماد مسؤول عن التحقق من مصدر الاعتماد تحت طائله حجز المبلغ";
  @override
  Widget build(BuildContext context) {
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
                    _buildRowData(lable: LocaleKeys.credits_credit_number.tr(), value: "value"),
                    _buildRowData(lable: LocaleKeys.credits_date_of_send.tr(), value: "value"),
                    SizedBox(height: 15),
                    _buildRowData(lable: LocaleKeys.credits_amount.tr(), value: "value", valueColor: Colors.red),
                    _buildRowData(lable: "", value: "value", valueColor: Colors.red),
                    _buildRowData(lable: LocaleKeys.credits_destination.tr(), value: "value"),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Color.fromARGB(98, 225, 169, 171)),
                        color: Color(0xfff3dfde),
                      ),

                      child: Column(
                        spacing: 15,
                        children: [
                          AppText.bodyMedium(
                            textOne,
                            color: Color(0xffb13e42),
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            textAlign: TextAlign.start,
                          ),
                          AppText.bodyMedium(
                            textTwo,
                            color: Color(0xffb13e42),
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            textAlign: TextAlign.start,
                          ),
                          AppText.bodyMedium(
                            textThree,
                            color: Color(0xffb13e42),
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            textAlign: TextAlign.start,
                          ),
                          AppText.bodyMedium(
                            textFour,
                            color: Color(0xffb13e42),
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    checkColor: context.onPrimaryColor,
                    fillColor: WidgetStatePropertyAll(context.primaryContainer),
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
