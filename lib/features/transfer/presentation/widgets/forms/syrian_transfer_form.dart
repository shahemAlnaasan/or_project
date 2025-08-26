// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_targets_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_target_info_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_tax_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/new_sy_transfer_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/outgoing_transfer_receipt_screen.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/dialogs/confirm_transfer_dialog.dart';
import 'package:toastification/toastification.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_drop_down.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../generated/locale_keys.g.dart';

class SyrianTransferForm extends StatefulWidget {
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

  const SyrianTransferForm({
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
  SyrianTransferFormState createState() => SyrianTransferFormState();
}

class SyrianTransferFormState extends State<SyrianTransferForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController beneficiaryNameController;
  late TextEditingController beneficiaryPhoneController;
  late TextEditingController amountController;
  late TextEditingController receivedAmountController;
  late TextEditingController exchangeController;
  late TextEditingController feesController;
  late TextEditingController notesController;
  late TextEditingController addressController;

  FocusNode beneficiaryNameNode = FocusNode();
  FocusNode beneficiaryPhoneNode = FocusNode();
  FocusNode amountNode = FocusNode();
  FocusNode receivedAmountNode = FocusNode();
  FocusNode exchangeNode = FocusNode();
  FocusNode feesNode = FocusNode();
  FocusNode notesNode = FocusNode();
  FocusNode addressNode = FocusNode();

  GetSyPricesResponse? getSyPricesResponse;
  GetSyTargetsResponse? getSyTargetsResponse;

  List<Target> targets = [];
  Target? selectedTarget;

  List<Cur> currencies = [];
  Cur? selectedCurrency;

  String recievedAmount = "0";

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

  void setAmountsAndExchangePriceAndFees(BuildContext context, {bool reverse = false}) {
    checkRequiredFieldsFilled(context);
    if (selectedTarget != null &&
        selectedCurrency != null &&
        amountController.text.trim().isNotEmpty &&
        getSyPricesResponse != null) {
      final entry = getSyPricesResponse!.prices.entries.firstWhere(
        (target) => target.key.toString() == selectedTarget!.cid.toString(),
        orElse: () => MapEntry("", Price(name: "", priceUsd: "0", priceEur: "0", priceTl: "0")),
      );

      final Price selectedTargetPrices = entry.value;

      String priceStr = "";
      if (selectedCurrency!.currency == "tl") {
        priceStr = selectedTargetPrices.priceTl;
      } else if (selectedCurrency!.currency == "eur") {
        priceStr = selectedTargetPrices.priceEur;
      } else if (selectedCurrency!.currency == "usd") {
        priceStr = selectedTargetPrices.priceUsd;
      }

      double price = double.tryParse(priceStr.replaceAll(',', '')) ?? 0.0;

      if (reverse) {
        setState(() {
          double recievedAmount = double.tryParse(receivedAmountController.text) ?? 0.0;
          amountController.text = _formatNumber((recievedAmount / price));
        });
      } else {
        setState(() {
          double amount = double.tryParse(amountController.text) ?? 0.0;
          recievedAmount = (amount * price).toString();
          receivedAmountController.text = _formatNumber((amount * price));
        });
      }

      exchangeController.text = price.toStringAsFixed(0);
    } else {
      if (reverse) {
        amountController.clear();
      } else {
        receivedAmountController.clear();
      }
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

  void _showDetailsDialog(
    BuildContext context, {
    required String senderName,
    required String amount,
    required void Function()? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmTransferDialog(senderName: senderName, amount: amount, onPressed: onPressed);
      },
    );
  }

  void checkRequiredFieldsFilled(BuildContext context) {
    if (selectedTarget != null && selectedCurrency != null && amountController.text.trim().isNotEmpty) {
      final GetTaxParams params = GetTaxParams(
        target: selectedTarget!.cid,
        amount: amountController.text,
        currency: selectedCurrency!.currency,
        rcvamount: amountController.text,
        rcvcurrency: selectedCurrency!.currency,
        api: "false",
        rate: "1",
        apiInfo: "",
      );
      context.read<TransferBloc>().add(GetSyTaxEvent(params: params));
    } else {
      setState(() {
        feesController.text = "0";
      });
    }
  }

  bool _submitForm(BuildContext context) {
    final formState = _formKey.currentState;
    if (formState == null) return false;

    if (!formState.validate()) {
      final firstInvalid = [beneficiaryNameNode, beneficiaryPhoneNode, amountNode, receivedAmountNode].firstWhere(
        (node) => !node.hasFocus && node.context != null && (Form.of(node.context!).validate() == false),
        orElse: () => beneficiaryNameNode,
      );

      // Scroll to it
      Scrollable.ensureVisible(
        firstInvalid.context!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    beneficiaryNameController = TextEditingController(text: widget.beneficiaryName ?? '');
    beneficiaryPhoneController = TextEditingController(text: widget.beneficiaryPhone ?? '');
    receivedAmountController = TextEditingController(text: widget.receivedAmount ?? '');
    exchangeController = TextEditingController(text: widget.exchange ?? '');
    amountController = TextEditingController(text: widget.amount ?? '');
    feesController = TextEditingController(text: widget.fees ?? '0');
    notesController = TextEditingController(text: widget.notes ?? '');
    addressController = TextEditingController(text: widget.address ?? '');
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

  void resetForm(BuildContext context) {
    setState(() {
      beneficiaryNameController.clear();
      beneficiaryPhoneController.clear();
      amountController.clear();
      receivedAmountController.clear();
      exchangeController.clear();
      feesController.text = "0";
      notesController.clear();
      addressController.clear();
      getSyPricesResponse = null;
      getSyTargetsResponse = null;
      targets = [];
      selectedTarget = null;
      currencies = [];
      selectedCurrency = null;
    });
    context.read<TransferBloc>()
      ..add(GetSyTargetsEvent())
      ..add(GetSyPricesEvent())
      ..add(GetCurrenciesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.getSyPricesStatus != curr.getSyPricesStatus,
          listener: (context, state) {
            if (state.getSyPricesStatus == Status.success && state.getSyPricesResponse != null) {
              setState(() {
                getSyPricesResponse = state.getSyPricesResponse;
              });
            }
          },
        ),
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.getSyTargetsStatus != curr.getSyTargetsStatus,
          listener: (context, state) {
            if (state.getSyTargetsStatus == Status.success && state.getSyTargetsResponse != null) {
              setState(() {
                getSyTargetsResponse = state.getSyTargetsResponse;
                targets = getSyTargetsResponse?.targets.values.toList() ?? [];
              });
            }
          },
        ),
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.getSyTaxStatus != curr.getSyTaxStatus,
          listener: (context, state) {
            if (state.getSyTaxStatus == Status.success && state.getSyTaxResponse != null) {
              setState(() {
                feesController.text = state.getSyTaxResponse!.data.tax.toString();
              });
            }
          },
        ),
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.getCurreciesStatus != curr.getCurreciesStatus,
          listener: (context, state) {
            if (state.getCurreciesStatus == Status.success && state.currenciesResponse != null) {
              setState(() {
                currencies =
                    state.currenciesResponse!.curs
                        .where(
                          (cur) =>
                              cur.currency == "usd" ||
                              cur.currency == "eur" ||
                              cur.currency == "tl" ||
                              cur.currency == "يورو" ||
                              cur.currency == "ليرة تركية" ||
                              cur.currency == "ليرة سورية",
                        )
                        .toList();
              });
            }
          },
        ),
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.newSyTransferStatus != curr.newSyTransferStatus,
          listener: (context, state) {
            if (state.newSyTransferStatus == Status.success && state.newSyTransferResponse != null) {
              ToastificationDialog.showToast(
                msg: "تم ارسال الحوالة",
                context: context,
                type: ToastificationType.success,
                autoCloseDuration: Duration(seconds: 15),
              );
              TransDetailsParams params = TransDetailsParams(transNum: state.newTransResponse!.transnum);
              context.read<TransferBloc>().add(GetTransDetailsEvent(params: params));
            }
            if (state.newSyTransferStatus == Status.failure) {
              ToastificationDialog.showToast(
                msg: state.errorMessage!,
                context: context,
                type: ToastificationType.success,
              );
            }
          },
        ),
        BlocListener<TransferBloc, TransferState>(
          listenWhen: (prev, curr) => prev.transDetailsStatus != curr.transDetailsStatus,
          listener: (context, state) async {
            final blocContext = context;

            if (state.transDetailsStatus == Status.success && state.transDetailsResponse != null) {
              await Future.delayed(Duration(seconds: 1));
              ToastificationDialog.dismiss();
              Navigator.of(blocContext, rootNavigator: true).push(
                MaterialPageRoute(
                  builder:
                      (context) => OutgoingTransferReceiptScreen(transDetailsResponse: state.transDetailsResponse!),
                ),
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
            buildFieldTitle(title: LocaleKeys.transfer_beneficiary_name.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_beneficiary_name.tr(),
              controller: beneficiaryNameController,
              focusNode: beneficiaryNameNode,
              focusOn: beneficiaryPhoneNode,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_beneficiary_phone.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_beneficiary_phone.tr(),
              controller: beneficiaryPhoneController,
              focusNode: beneficiaryPhoneNode,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_destination.tr()),
            CustomDropdown<Target>(
              menuList: targets,
              singleSelectValidator: (value) => singleSelectValidator(value),
              enableSearch: true,
              menuMaxHeight: 250,
              initaValue: selectedTarget,
              compareFn: (a, b) => a.cid == b.cid,
              labelText: LocaleKeys.transfer_destination.tr(),
              hintText: LocaleKeys.transfer_destination.tr(),
              itemAsString: (target) => target.cn,
              onChanged: (value) {
                setState(() {
                  selectedTarget = value!;
                  setAmountsAndExchangePriceAndFees(context);
                });
                final String cid = selectedTarget!.cid;
                final GetTargetInfoParams params = GetTargetInfoParams(id: cid, api: "false");
                context.read<TransferBloc>().add(GetTargetInfoEvent(params: params));
                selectedCurrency = null;
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_transfer_currency.tr()),
            CustomDropdown<Cur>(
              menuList: currencies,
              singleSelectValidator: (value) => singleSelectValidator(value),
              initaValue: selectedCurrency,
              compareFn: (a, b) => a.currency == b.currency,
              labelText: LocaleKeys.transfer_transfer_currency.tr(),
              hintText: LocaleKeys.transfer_transfer_currency.tr(),
              itemAsString: (cur) => cur.currencyName,
              onChanged: (cur) {
                setState(() {
                  selectedCurrency = cur;
                  setAmountsAndExchangePriceAndFees(context);
                });
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_money_amount.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_money_amount.tr(),
              controller: amountController,
              onChanged: (p0) => setAmountsAndExchangePriceAndFees(context),
              keyboardType: TextInputType.number,
              focusNode: amountNode,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_recived_amount.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_recived_amount.tr(),
              controller: receivedAmountController,
              onChanged: (p0) => setAmountsAndExchangePriceAndFees(context, reverse: true),
              keyboardType: TextInputType.number,
              focusNode: receivedAmountNode,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_excange.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_excange.tr(),
              controller: exchangeController,
              readOnly: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_fees.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_fees.tr(),
              controller: feesController,
              readOnly: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_address.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_address.tr(),
              controller: addressController,
              mxLine: 3,
              readOnly: true,
            ),
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
              onPressed: () async {
                final blocContext = context;

                if (_submitForm(context)) {
                  if (isEmptyOrZero(amountController.text) ||
                      isEmptyOrZero(receivedAmountController.text) ||
                      isEmptyOrZero(exchangeController.text)) {
                    ToastificationDialog.showToast(
                      msg: "خطأ في ادخال البيانات",
                      context: context,
                      type: ToastificationType.error,
                    );
                    return;
                  }
                  if (isEmptyOrZero(feesController.text)) {
                    ToastificationDialog.showToast(
                      msg: "لايمكن ان تكون الاجور 0",
                      context: context,
                      type: ToastificationType.error,
                    );
                  } else {
                    _showDetailsDialog(
                      context,
                      senderName: beneficiaryNameController.text,
                      amount: "${amountController.text} ${selectedCurrency!.currencyName}",
                      onPressed: () async {
                        NewSyTransferParams params = NewSyTransferParams(
                          target: int.tryParse(selectedTarget!.cid) ?? 0,
                          rcvname: beneficiaryNameController.text,
                          rcvphone: beneficiaryPhoneController.text,
                          amount: double.tryParse(amountController.text) ?? 0,
                          currency: selectedCurrency!.currency,
                          amountSy: double.tryParse(recievedAmount) ?? 0,
                          isSy: "true",
                          cut: int.tryParse(exchangeController.text) ?? 0,
                          api: "false",
                        );
                        context.read<TransferBloc>().add(NewSyTransferEvent(params: params));
                        await Future.delayed(Duration(seconds: 1));
                        resetForm(blocContext);
                      },
                    );
                  }
                }
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
  void Function(String)? onChanged,
  String validatorTitle = "",
  int mxLine = 1,
  Widget? sufIcon,
  bool? readOnly,
  dynamic Function()? onTap,
  TextInputType? keyboardType,
  bool needValidation = true,
  FocusNode? focusNode,
  FocusNode? focusOn,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    onChanged: onChanged,
    keyboardType: keyboardType,
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
