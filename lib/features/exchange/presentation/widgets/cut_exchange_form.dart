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

  final PriceValue fallBackPriceValue = PriceValue(curfrom: '', curto: '', price: '0', op: '', img: '', catagory: '');

  late TextEditingController fromAmountController;
  late TextEditingController toAmountController;
  late TextEditingController cutPriceController;

  List<Currency> filteredFromCurrencies = [];
  Currency? selectedFromCurrency;
  List<Currency> filteredToCurrencies = [];
  Currency? selectedToCurrency;
  GetPricesResponse? getPricesResponse;
  bool isAutoRefreshing = false;
  String cutPrice = "0";

  void resetForm(BuildContext context) {
    setState(() {
      fromAmountController.clear();
      toAmountController.clear();
      cutPriceController.clear();
      filteredFromCurrencies.clear();
      selectedFromCurrency = null;
      filteredToCurrencies.clear();
      selectedToCurrency = null;
      getPricesResponse = null;
      isAutoRefreshing = false;
      cutPrice = '0';
    });
    context.read<ExchangeBloc>().add(GetPricesEvent());
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

  PriceValue? getSelectedPriceValue({bool reverse = false}) {
    if (widget.getPricesResponse == null || selectedFromCurrency == null || selectedToCurrency == null) return null;

    final directMatch = widget.getPricesResponse!.prices.values.firstWhere(
      (value) => value.curfrom == selectedFromCurrency!.id && value.curto == selectedToCurrency!.id,
      orElse: () => fallBackPriceValue,
    );
    if (directMatch.curfrom.isNotEmpty) return directMatch;
    return fallBackPriceValue;
  }

  String? getSelectedPriceValueOp({bool reverse = false}) {
    if (widget.getPricesResponse == null || selectedFromCurrency == null || selectedToCurrency == null) return null;
    PriceValue opPriceValue;

    if (reverse) {
      opPriceValue = widget.getPricesResponse!.prices.values.firstWhere(
        (value) => value.curfrom == selectedToCurrency!.id && value.curto == selectedFromCurrency!.id,
        orElse: () => fallBackPriceValue,
      );
    } else {
      opPriceValue = widget.getPricesResponse!.prices.values.firstWhere(
        (value) => value.curfrom == selectedFromCurrency!.id && value.curto == selectedToCurrency!.id,
        orElse: () => fallBackPriceValue,
      );
    }

    if (opPriceValue.curfrom.isNotEmpty) return opPriceValue.op;
    return fallBackPriceValue.op;
  }

  double _calculateExchange({
    required double input,
    required PriceValue priceValue,
    required String opration,
    bool reverse = false,
  }) {
    final double rate = double.tryParse(priceValue.price) ?? 0.0;
    final String op = opration;
    if (rate == 0) return 0;

    switch (op) {
      case '*':
        return input * rate;
      case '/':
        return input / rate;
      default:
        throw input / rate;
    }
  }

  void calculateAmount(String p0, bool reverse) {
    final priceValue = getSelectedPriceValue(reverse: reverse);
    final op = getSelectedPriceValueOp(reverse: reverse) ?? "";
    if (priceValue != null && p0.isNotEmpty) {
      final double input = double.tryParse(p0) ?? 0;
      final converted = _calculateExchange(input: input, priceValue: priceValue, opration: op, reverse: true);
      setState(() {
        if (reverse) {
          fromAmountController.text = converted.toStringAsFixed(2);
        } else {
          toAmountController.text = converted.toStringAsFixed(2);
        }
      });
    }
  }

  void setPriceField() {
    if (selectedFromCurrency != null && selectedToCurrency != null) {
      final match = getSelectedPriceValue();
      setState(() {
        cutPriceController.text = cutPrice;
        cutPriceController.text = _formatNumber(double.tryParse(match!.price) ?? 0);
      });
    } else {
      setState(() {
        cutPriceController.text = "0";
        cutPrice = "0";
      });
    }
  }

  String _formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  bool isEmptyOrZero(String? value) {
    if (value == null || value.trim().isEmpty) return true;
    final num? number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null || number <= 0) return true;
    return false;
  }

  void checkIfCursMatch({required bool isSelectSell}) {
    if (selectedFromCurrency?.name == selectedToCurrency?.name) {
      setState(() {
        if (isSelectSell) {
          selectedToCurrency = null;
        } else {
          selectedFromCurrency = null;
        }
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

  void _startAutoRefresh() {
    if (isAutoRefreshing) return;
    isAutoRefreshing = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      context.read<ExchangeBloc>().add(GetPricesEvent(isUpdateData: true));
      return true;
    });
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ExchangeBloc, ExchangeState>(
          listenWhen: (prev, curr) => prev.getPricesResponse != curr.getPricesResponse,
          listener: (context, state) async {
            if (state.getPricesStatus == Status.success && state.getPricesResponse != null) {
              if (!mounted) return;
              setState(() {
                getPricesResponse = state.getPricesResponse;
              });

              await Future.delayed(const Duration(seconds: 2));

              _startAutoRefresh();
            }
          },
        ),
        BlocListener<ExchangeBloc, ExchangeState>(
          listenWhen: (prev, curr) => prev.getSenderCursStatus != curr.getSenderCursStatus,
          listener: (context, state) async {
            if (state.getSenderCursStatus == Status.success && state.getSenderCursResponse != null) {
              final rawCurs = state.getSenderCursResponse!.data.curs;
              final allowedSymbols = rawCurs.split(',').where((e) => e.isNotEmpty).map((e) => e.toLowerCase()).toSet();

              final allCurrencies = state.getPricesResponse?.curs ?? [];

              final matchingCurrencies =
                  allCurrencies.where((cur) => allowedSymbols.contains(cur.id.toLowerCase())).toList();

              setState(() {
                filteredToCurrencies = matchingCurrencies;
                filteredFromCurrencies = matchingCurrencies;
              });
            }
          },
        ),
        BlocListener<ExchangeBloc, ExchangeState>(
          listenWhen: (prev, curr) => prev.newExchangeStatus != curr.newExchangeStatus,
          listener: (context, state) {
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
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Center(child: buildFieldTitle(title: "عليكم / بيع", color: Colors.blueAccent)),
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
                  if (isEmptyOrZero(fromAmountController.text)) {
                    calculateAmount(fromAmountController.text, false);
                    calculateAmount(toAmountController.text, true);
                  }
                  checkIfCursMatch(isSelectSell: true);
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
                calculateAmount(p0, false);
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
                checkIfCursMatch(isSelectSell: false);
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
            buildTextField(
              hint: LocaleKeys.credits_amount.tr(),
              controller: toAmountController,
              keyboardType: TextInputType.number,
              onChanged: (p0) {
                calculateAmount(p0, true);
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
                  if (isEmptyOrZero(cutPriceController.text)) {
                    ToastificationDialog.showToast(
                      msg: "لايمكن ان يكون السعر 0",
                      context: context,
                      type: ToastificationType.error,
                    );
                    return;
                  } else {
                    final String deviceType = await DeviceInfo.deviceType();
                    final String? deviceIp = await DeviceInfo.getDeviceIp();

                    NewExchangeParams params = NewExchangeParams(
                      accfrom: double.tryParse(fromAmountController.text.trim()) ?? 0,
                      accto: double.tryParse(toAmountController.text) ?? 0,
                      cut: double.tryParse(cutPrice) ?? 0,
                      currencyfrom: selectedFromCurrency!.id,
                      currencyto: selectedToCurrency!.id,
                      ipInfo: deviceIp ?? "",
                      deviceInfo: deviceType,
                    );
                    context.read<ExchangeBloc>().add(NewExchangeEvent(params: params));
                  }
                }
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
