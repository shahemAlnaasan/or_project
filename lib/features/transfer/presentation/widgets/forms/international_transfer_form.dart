import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_drop_down.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class InternationalTransferForm extends StatefulWidget {
  final String? beneficiaryName;
  final String? beneficiaryPhone;
  final String? destination;
  final String? currency;
  final String? amount;
  final String? receivedAmount;
  final String? exchange;
  final String? fees;
  final String? notes;
  final String? address;

  const InternationalTransferForm({
    super.key,
    this.beneficiaryName,
    this.beneficiaryPhone,
    this.destination,
    this.currency,
    this.amount,
    this.receivedAmount,
    this.exchange,
    this.fees,
    this.notes,
    this.address,
  });

  @override
  State<InternationalTransferForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<InternationalTransferForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController beneficiaryNameController;
  late TextEditingController beneficiaryPhoneController;
  late TextEditingController amountController;
  late TextEditingController receivedAmountController;
  late TextEditingController exchangeController;
  late TextEditingController feesController;
  late TextEditingController notesController;
  late TextEditingController addressController;

  String? selectedDestination;
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    beneficiaryNameController = TextEditingController(text: widget.beneficiaryName ?? '');
    beneficiaryPhoneController = TextEditingController(text: widget.beneficiaryPhone ?? '');
    receivedAmountController = TextEditingController(text: widget.receivedAmount ?? '');
    exchangeController = TextEditingController(text: widget.exchange ?? '');
    amountController = TextEditingController(text: widget.amount ?? '');
    feesController = TextEditingController(text: widget.fees ?? '');
    notesController = TextEditingController(text: widget.notes ?? '');
    addressController = TextEditingController(text: widget.address ?? '');

    selectedDestination = widget.destination;
    selectedCurrency = widget.currency;
  }

  @override
  void dispose() {
    beneficiaryNameController.dispose();
    beneficiaryPhoneController.dispose();
    amountController.dispose();
    feesController.dispose();
    notesController.dispose();
    addressController.dispose();
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
            buildFieldTitle(title: LocaleKeys.transfer_beneficiary_name.tr()),
            buildTextField(hint: LocaleKeys.transfer_beneficiary_name.tr(), controller: beneficiaryNameController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_beneficiary_phone.tr()),
            buildTextField(hint: LocaleKeys.transfer_beneficiary_phone.tr(), controller: beneficiaryPhoneController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_destination.tr()),
            CustomDropdown(
              menuList: ['Syria', 'Lebanon', 'Iraq'],
              initaValue: selectedDestination,
              labelText: LocaleKeys.transfer_destination.tr(),
              hintText: LocaleKeys.transfer_destination.tr(),
              onChanged: (value) {
                setState(() => selectedDestination = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_transfer_currency.tr()),
            CustomDropdown(
              menuList: ['USD', 'EUR', 'SYP'],
              initaValue: selectedCurrency,
              labelText: LocaleKeys.transfer_transfer_currency.tr(),
              hintText: LocaleKeys.transfer_transfer_currency.tr(),
              onChanged: (value) {
                setState(() => selectedCurrency = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_money_amount.tr()),
            buildTextField(hint: LocaleKeys.transfer_money_amount.tr(), controller: amountController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_recived_amount.tr()),
            buildTextField(hint: LocaleKeys.transfer_recived_amount.tr(), controller: receivedAmountController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_excange.tr()),
            buildTextField(hint: LocaleKeys.transfer_excange.tr(), controller: exchangeController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_fees.tr()),
            buildTextField(hint: LocaleKeys.transfer_fees.tr(), controller: feesController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_address.tr()),
            buildTextField(hint: LocaleKeys.transfer_address.tr(), controller: addressController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_notes.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_notes.tr(),
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
