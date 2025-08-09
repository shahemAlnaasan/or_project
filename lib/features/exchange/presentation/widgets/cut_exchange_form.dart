import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/navigation_extensions.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/utils/device_info.dart';
import 'package:golder_octopus/common/utils/number_to_arabic_words.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/exchange/data/models/get_preices_model.dart';
import 'package:golder_octopus/features/exchange/domain/use_cases/new_exchange_usecase.dart';
import 'package:golder_octopus/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/large_button.dart';
import '../../../../generated/locale_keys.g.dart';

class CutExchangeForm extends StatefulWidget {
  final GetPricesResponse? getPricesResponse;
  const CutExchangeForm({super.key, required this.getPricesResponse});

  @override
  CutExchangeFormState createState() => CutExchangeFormState();
}

class CutExchangeFormState extends State<CutExchangeForm> {
  final _formKey = GlobalKey<FormState>();

  final PriceValue fallBackPriceValue = PriceValue(curfrom: '', curto: '', price: '10', op: '', img: '', catagory: '');

  late TextEditingController fromAmountController;
  late TextEditingController toAmountController;
  late TextEditingController cutPriceController;

  List<Currency> filteredFromCurrencies = [];
  Currency? selectedFromCurrency;
  List<Currency> filteredToCurrencies = [];
  Currency? selectedToCurrency;

  void resetForm() {
    setState(() {
      fromAmountController.clear();
      toAmountController.clear();
      cutPriceController.clear();
      filteredFromCurrencies.clear();
      selectedFromCurrency = null;
      filteredToCurrencies.clear();
      selectedToCurrency = null;
    });
  }

  String getFinalBalance(String amount) {
    String balanceInWords = NumberToArabicWords.convertToWords(double.parse(amount).toInt());

    return balanceInWords;
  }

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

  PriceValue? getSelectedPriceValue() {
    if (widget.getPricesResponse == null || selectedFromCurrency == null || selectedToCurrency == null) return null;

    final directMatch = widget.getPricesResponse!.prices.values.firstWhere(
      (value) => value.curfrom == selectedFromCurrency!.id && value.curto == selectedToCurrency!.id,
      orElse: () => fallBackPriceValue,
    );

    if (directMatch.curfrom.isNotEmpty) return directMatch;
    return fallBackPriceValue;
  }

  double _calculateExchange(double input, PriceValue priceValue, {bool reverse = false}) {
    final double rate = double.tryParse(priceValue.price) ?? 0.0;
    if (rate == 0) return 0;

    if ((priceValue.op == '/' && !reverse) || (priceValue.op == '*' && reverse)) {
      return input / rate;
    } else {
      return input * rate;
    }
  }

  void setPriceField() {
    if (selectedFromCurrency != null && selectedToCurrency != null) {
      final match = getSelectedPriceValue();
      setState(() {
        cutPriceController.text = match!.price;
      });
    } else {
      setState(() {
        cutPriceController.text = "0";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fromAmountController = TextEditingController(text: '0');
    toAmountController = TextEditingController(text: '0');
    cutPriceController = TextEditingController(text: '0');
  }

  @override
  void didUpdateWidget(covariant CutExchangeForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.getPricesResponse != oldWidget.getPricesResponse && widget.getPricesResponse != null) {
      final allCurrencies = widget.getPricesResponse!.curs;
      final curfromIds = widget.getPricesResponse!.prices.values.map((price) => price.curfrom).toSet();

      setState(() {
        filteredFromCurrencies = allCurrencies.where((currency) => curfromIds.contains(currency.id)).toList();
        filteredToCurrencies = allCurrencies.where((currency) => curfromIds.contains(currency.id)).toList();
      });
    }
  }

  @override
  void dispose() {
    fromAmountController.dispose();
    toAmountController.dispose();
    cutPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExchangeBloc, ExchangeState>(
      listener: (context, state) async {
        if (state.newExchangeStatus == Status.success && state.newExchangeResponse != null) {
          ToastificationDialog.showToast(
            msg: "تمت عملية القص بنجاح",
            context: context,
            type: ToastificationType.success,
          );
          context.pop();
        }
        if (state.newExchangeStatus == Status.failure) {
          ToastificationDialog.showToast(
            msg: state.errorMessage ?? "",
            context: context,
            type: ToastificationType.success,
          );
        }
      },
      child: SingleChildScrollView(
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
                    setPriceField();
                  });
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
              buildTextField(
                hint: LocaleKeys.credits_amount.tr(),
                controller: fromAmountController,
                keyboardType: TextInputType.number,
                onChanged: (p0) {
                  final priceValue = getSelectedPriceValue();
                  if (priceValue != null && p0.isNotEmpty) {
                    final double input = double.tryParse(p0) ?? 0;
                    final converted = _calculateExchange(input, priceValue);
                    setState(() {
                      toAmountController.text = converted.toStringAsFixed(2);
                    });
                  }
                },
              ),
              buildFieldTitle(
                title:
                    "${fromAmountController.text.isNotEmpty ? getFinalBalance(fromAmountController.text) : null} ${selectedFromCurrency != null ? selectedFromCurrency!.name : "--من--"} ",
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.exchange_price.tr()),
              buildTextField(
                hint: LocaleKeys.exchange_price.tr(),
                controller: cutPriceController,
                readOnly: true,
                keyboardType: TextInputType.number,
              ),
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
                    selectedToCurrency = cur;
                    setPriceField();
                  });
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
              buildTextField(
                hint: LocaleKeys.credits_amount.tr(),
                controller: toAmountController,
                keyboardType: TextInputType.number,
                onChanged: (p0) {
                  final priceValue = getSelectedPriceValue();
                  if (priceValue != null && p0.isNotEmpty) {
                    final double input = double.tryParse(p0) ?? 0;
                    final converted = _calculateExchange(input, priceValue, reverse: true);
                    setState(() {
                      fromAmountController.text = converted.toStringAsFixed(2);
                    });
                  }
                },
              ),
              buildFieldTitle(
                title:
                    "${toAmountController.text.isNotEmpty ? getFinalBalance(toAmountController.text) : null} ${selectedToCurrency != null ? selectedToCurrency!.name : "--الى--"}",
              ),
              SizedBox(height: 3),
              LargeButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String deviceType = await DeviceInfo.deviceType();
                    final String? deviceIp = await DeviceInfo.getDeviceIp();

                    NewExchangeParams params = NewExchangeParams(
                      accfrom: double.tryParse(fromAmountController.text.trim()) ?? 0,
                      accto: double.tryParse(toAmountController.text.trim()) ?? 0,
                      cut: double.tryParse(cutPriceController.text.trim()) ?? 0,
                      currencyfrom: selectedFromCurrency!.id,
                      currencyto: selectedToCurrency!.id,
                      ipInfo: deviceIp ?? "",
                      deviceInfo: deviceType,
                    );
                    context.read<ExchangeBloc>().add(NewExchangeEvent(params: params));
                  }
                },
                text: LocaleKeys.transfer_exchange.tr(),
                backgroundColor: context.primaryContainer,
                circularRadius: 12,
              ),
            ],
          ),
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
  void Function(String)? onChanged,
  TextInputType? keyboardType,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    onChanged: onChanged,
    mxLine: mxLine,
    keyboardType: keyboardType,
    controller: controller,
    hint: hint,
    validator:
        needValidation
            ? (value) {
              if (value == null || value.isEmpty || value == "0") {
                return validatorTitle.isNotEmpty && validatorTitle != "0"
                    ? validatorTitle
                    : LocaleKeys.transfer_this_field_cant_be_empty.tr();
              }
              return null;
            }
            : null,
    sufIcon: sufIcon,
  );
}
