import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_drop_down.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class SendCreditForm extends StatefulWidget {
  final String? beneficiaryName;
  final String? beneficiaryPhone;
  final String? destination;
  final String? currency;
  final String? amount;
  final String? senderName;
  final String? senderPhone;
  final String? fees;
  final String? notes;
  final String? address;

  const SendCreditForm({
    super.key,
    this.beneficiaryName,
    this.beneficiaryPhone,
    this.destination,
    this.currency,
    this.amount,
    this.senderName,
    this.senderPhone,
    this.fees,
    this.notes,
    this.address,
  });

  @override
  State<SendCreditForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<SendCreditForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController amountController;
  late TextEditingController feesController;
  late TextEditingController notesController;

  String selectedCompany = "الأخطبــوط الذهبي داخلي";
  String? selectedCreditType;
  String? selectedCurrency;
  String? selectedDestination;
  String? selectedBox;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.amount ?? '');
    feesController = TextEditingController(text: widget.fees ?? '');
    notesController = TextEditingController(text: widget.notes ?? '');

    selectedDestination = widget.destination;
    selectedCurrency = widget.currency;
  }

  @override
  void dispose() {
    amountController.dispose();
    feesController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            buildFieldTitle(title: LocaleKeys.credits_company.tr()),
            CustomDropdown(
              menuList: [selectedCompany],
              initaValue: selectedCompany,
              labelText: LocaleKeys.credits_company.tr(),
              hintText: LocaleKeys.credits_company.tr(),
              onChanged: (value) {
                setState(() => selectedCompany = value ?? "");
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_credit_type.tr()),
            CustomDropdown(
              menuList: ['مباشر', 'اعتماد محجوز لحين التنفيذ'],
              initaValue: selectedCreditType,
              labelText: LocaleKeys.credits_credit_type.tr(),
              hintText: LocaleKeys.credits_credit_type.tr(),
              onChanged: (value) {
                setState(() => selectedCreditType = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
            CustomDropdown(
              menuList: ['USD', 'EUR', 'SYP'],
              initaValue: selectedCurrency,
              labelText: LocaleKeys.credits_currency.tr(),
              hintText: LocaleKeys.credits_currency.tr(),
              onChanged: (value) {
                setState(() => selectedCurrency = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(hint: LocaleKeys.credits_amount.tr(), controller: amountController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_box.tr()),
            CustomDropdown(
              menuList: ['USD', 'EUR', 'SYP'],
              initaValue: selectedCurrency,
              labelText: LocaleKeys.credits_box.tr(),
              hintText: LocaleKeys.credits_box.tr(),
              onChanged: (value) {
                setState(() => selectedCurrency = value);
              },
            ),
            buildFieldTitle(title: LocaleKeys.credits_fees.tr()),
            buildTextField(hint: LocaleKeys.credits_fees.tr(), controller: feesController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_notes.tr()),
            buildTextField(
              hint: LocaleKeys.credits_notes.tr(),
              controller: notesController,
              mxLine: 3,
              needValidation: false,
            ),
            SizedBox(height: 3),
            LargeButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              text: LocaleKeys.transfer_send.tr(),
              backgroundColor: context.primaryContainer,
              circularRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFieldTitle({required String title}) {
    return AppText.labelLarge(
      title,
      textAlign: TextAlign.right,
      color: context.onPrimaryColor,
      fontWeight: FontWeight.bold,
    );
  }
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
