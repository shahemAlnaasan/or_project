import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/large_button.dart';
import '../../../../generated/locale_keys.g.dart';

class ShearBondForm extends StatefulWidget {
  final GetPricesResponse? getPricesResponse;
  const ShearBondForm({super.key, required this.getPricesResponse});

  @override
  State<ShearBondForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<ShearBondForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fromAmountController;
  late TextEditingController toAmountController;
  late TextEditingController cutPriceController;

  List<Currency> filteredFromCurrencies = [];
  Currency? selectedFromCurrency;
  List<Currency> filteredToCurrencies = [];
  Currency? selectedToCurrency;

  @override
  void initState() {
    super.initState();
    fromAmountController = TextEditingController(text: '0');
    toAmountController = TextEditingController(text: '0');
    cutPriceController = TextEditingController(text: '0');

    filteredFromCurrencies = widget.getPricesResponse?.curs ?? [];
    filteredToCurrencies = widget.getPricesResponse?.curs ?? [];
  }

  @override
  void dispose() {
    fromAmountController.dispose();
    toAmountController.dispose();
    cutPriceController.dispose();

    super.dispose();
  }

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
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
            CustomDropdown<Currency>(
              menuList: filteredFromCurrencies,
              singleSelectValidator: (value) => singleSelectValidator(value),
              initaValue: selectedFromCurrency,
              compareFn: (a, b) => a.id == b.id,
              labelText: "--من--",
              hintText: "--من--",
              itemAsString: (cur) => cur.name,
              onChanged: (cur) {
                setState(() {
                  selectedFromCurrency = cur;
                });
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(hint: LocaleKeys.credits_amount.tr(), controller: fromAmountController),
            SizedBox(height: 3),
            buildFieldTitle(title: "--من--"),
            buildFieldTitle(title: LocaleKeys.exchange_price.tr()),
            buildTextField(hint: LocaleKeys.exchange_price.tr(), controller: cutPriceController, readOnly: true),
            SizedBox(height: 3),
            Center(child: buildFieldTitle(title: "لكم / شراء", color: Colors.blueAccent)),
            buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
            CustomDropdown<Currency>(
              menuList: filteredToCurrencies,
              singleSelectValidator: (value) => singleSelectValidator(value),
              initaValue: selectedToCurrency,
              compareFn: (a, b) => a.id == b.id,
              labelText: "--الى--",
              hintText: "--الى--",
              itemAsString: (cur) => cur.name,
              onChanged: (cur) {
                setState(() {
                  selectedFromCurrency = cur;
                });
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(hint: LocaleKeys.credits_amount.tr(), controller: toAmountController),
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
