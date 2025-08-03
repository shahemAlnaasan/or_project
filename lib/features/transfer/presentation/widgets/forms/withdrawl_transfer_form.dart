import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../generated/locale_keys.g.dart';

class WithdrawlTransferForm extends StatefulWidget {
  const WithdrawlTransferForm({super.key});

  @override
  State<WithdrawlTransferForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<WithdrawlTransferForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController notifiNumberController = TextEditingController();
  final TextEditingController secretNumberController = TextEditingController();

  final FocusNode notifiNumberNode = FocusNode();
  final FocusNode secretNumberNode = FocusNode();
  final String info = "يمكنكم سحب الحركات التي قيمتها اقل من 500\$ ومتوجهه الى نفس المدينة";
  @override
  void dispose() {
    notifiNumberController.dispose();
    secretNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.blue.withAlpha(40), borderRadius: BorderRadius.circular(8)),
            child: AppText.bodyMedium(
              info,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),

          buildTextField(
            hint: LocaleKeys.transfer_notification_number.tr(),
            controller: notifiNumberController,
            focusNode: notifiNumberNode,
            focusOn: secretNumberNode,
          ),
          SizedBox(height: 10),
          buildTextField(
            hint: LocaleKeys.transfer_secret_number.tr(),
            controller: secretNumberController,
            focusNode: secretNumberNode,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LargeButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  text: LocaleKeys.transfer_search.tr(),
                  backgroundColor: context.primaryContainer,
                  circularRadius: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFieldTitle({required String title}) {
    return AppText.bodyMedium(
      title,
      textAlign: TextAlign.right,
      color: context.onPrimaryColor,
      fontWeight: FontWeight.w300,
    );
  }
}

Widget buildTextField({
  required String hint,
  required TextEditingController controller,
  String validatorTitle = "",
  int mxLine = 1,
  Widget? sufIcon,
  Widget? preIcon,
  bool? readOnly,
  dynamic Function()? onTap,
  bool needValidation = true,
  bool obSecure = false,
  FocusNode? focusNode,
  FocusNode? focusOn,
}) {
  return CustomTextField(
    obSecure: obSecure,
    preIcon: preIcon,
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    controller: controller,
    hint: hint,
    focusNode: focusNode,
    focusOn: focusOn,
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
