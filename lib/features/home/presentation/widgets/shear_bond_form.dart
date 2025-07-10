import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_drop_down.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class ShearBondForm extends StatefulWidget {
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

  const ShearBondForm({
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
  State<ShearBondForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<ShearBondForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController sellAmountController;
  late TextEditingController buyAmountController;
  late TextEditingController sellPriceController;

  String? sellSelectedCurrency;
  String? buySelectedCurrency;

  @override
  void initState() {
    super.initState();
    sellAmountController = TextEditingController(text: widget.amount ?? '0');
    buyAmountController = TextEditingController(text: widget.amount ?? '0');
    sellPriceController = TextEditingController(text: widget.amount ?? '0');

    sellSelectedCurrency = widget.currency;
    buySelectedCurrency = widget.currency;
  }

  @override
  void dispose() {
    sellAmountController.dispose();
    buyAmountController.dispose();
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
            Center(child: buildFieldTitle(title: "عليكم / بيغ", color: Colors.blueAccent)),
            buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
            CustomDropdown(
              menuList: ['USD', 'EUR', 'SYP'],
              initaValue: sellSelectedCurrency,
              labelText: LocaleKeys.credits_currency.tr(),
              hintText: LocaleKeys.credits_currency.tr(),
              onChanged: (value) {
                setState(() => sellSelectedCurrency = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(hint: LocaleKeys.credits_amount.tr(), controller: sellAmountController),
            SizedBox(height: 3),
            buildFieldTitle(title: "--من--"),
            buildFieldTitle(title: LocaleKeys.exchange_price.tr()),
            buildTextField(hint: LocaleKeys.exchange_price.tr(), controller: sellPriceController, readOnly: true),
            SizedBox(height: 3),
            Center(child: buildFieldTitle(title: "لكم / شراء", color: Colors.blueAccent)),
            buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
            CustomDropdown(
              menuList: ['USD', 'EUR', 'SYP'],
              initaValue: buySelectedCurrency,
              labelText: LocaleKeys.credits_currency.tr(),
              hintText: LocaleKeys.credits_currency.tr(),
              onChanged: (value) {
                setState(() => buySelectedCurrency = value);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(hint: LocaleKeys.credits_amount.tr(), controller: buyAmountController),
            Center(child: buildFieldTitle(title: "--الى--")),
            SizedBox(height: 3),
            LargeButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              text: LocaleKeys.transfer_exchange.tr(),
              backgroundColor: context.primaryContainer,
              circularRadius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFieldTitle({required String title, Color? color}) {
    return AppText.labelLarge(
      title,
      textAlign: TextAlign.right,
      color: color ?? context.onPrimaryColor,
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
