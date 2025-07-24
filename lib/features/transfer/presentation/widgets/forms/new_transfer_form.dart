import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/utils/device_info.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_drop_down.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_trans_targets_response.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_target_info_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/get_tax_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/new_transfer_usecase.dart';
import 'package:golder_octopus/features/transfer/domain/use_cases/trans_details_usecase.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:golder_octopus/features/transfer/presentation/pages/outgoing_transfer_receipt_screen.dart';
import 'package:golder_octopus/features/transfer/presentation/widgets/dialogs/confirm_transfer_dialog.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class NewTransferForm extends StatefulWidget {
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

  const NewTransferForm({
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
  NewTransferFormState createState() => NewTransferFormState();
}

class NewTransferFormState extends State<NewTransferForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController beneficiaryNameController;
  late TextEditingController beneficiaryPhoneController;
  late TextEditingController amountController;
  late TextEditingController senderNameController;
  late TextEditingController senderPhoneController;
  late TextEditingController feesController;
  late TextEditingController notesController;
  late TextEditingController addressController;

  String? selectedDestination;
  Map<String, Target> targetsMap = {};
  Target? selectedTarget;
  CurrenciesResponse? currenciesResponse;
  List<Cur> filteredCurrencies = [];
  Cur? selectedCurrency;
  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
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

  @override
  void initState() {
    super.initState();
    beneficiaryNameController = TextEditingController(text: widget.beneficiaryName ?? '');
    beneficiaryPhoneController = TextEditingController(text: widget.beneficiaryPhone ?? '');
    amountController = TextEditingController(text: widget.amount ?? '');
    senderNameController = TextEditingController(text: widget.senderName ?? '');
    senderPhoneController = TextEditingController(text: widget.senderPhone ?? '');
    feesController = TextEditingController(text: widget.fees ?? "0");
    notesController = TextEditingController(text: widget.notes ?? '');
    addressController = TextEditingController(text: widget.address ?? '');

    selectedDestination = widget.destination;
    // selectedCurrency = widget.currency;
  }

  @override
  void dispose() {
    beneficiaryNameController.dispose();
    beneficiaryPhoneController.dispose();
    amountController.dispose();
    senderNameController.dispose();
    senderPhoneController.dispose();
    feesController.dispose();
    notesController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void checkRequiredFieldsFilled(BuildContext context) {
    if (selectedTarget != null && selectedCurrency != null && amountController.text.trim().isNotEmpty) {
      final GetTaxParams params = GetTaxParams(
        target: selectedTarget!.cid.contains('-') ? "" : selectedTarget!.cid,
        amount: amountController.text,
        currency: selectedCurrency!.currency,
        rcvamount: amountController.text,
        rcvcurrency: selectedCurrency!.currency,
        api: selectedTarget!.api,
        rate: "1",
        apiInfo: selectedTarget!.cid.contains('-') ? selectedTarget!.cid : "",
      );
      context.read<TransferBloc>().add(GetTaxEvent(params: params));
    } else {
      setState(() {
        feesController.text = "0";
      });
    }
  }

  void resetForm() {
    setState(() {
      beneficiaryNameController.clear();
      beneficiaryPhoneController.clear();
      amountController.clear();
      senderNameController.clear();
      senderPhoneController.clear();
      feesController.text = "0";
      notesController.clear();
      addressController.clear();
      selectedTarget = null;
      selectedDestination = null;
      selectedCurrency = null;
      filteredCurrencies.clear();
      currenciesResponse = null;
    });
    context.read<TransferBloc>().add(GetTransTargetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listener: (context, state) async {
        if (state.newTransferStatus == Status.success) {
          TransDetailsParams params = TransDetailsParams(transNum: state.newTransResponse!.transnum);
          context.read<TransferBloc>().add(GetTransDetailsEvent(params: params));
          ToastificationDialog.showToast(
            msg: "تم ارسال الحوالة",
            context: context,
            type: ToastificationType.success,
            autoCloseDuration: Duration(seconds: 10),
          );
        }
        if (state.transDetailsStatus == Status.success && state.transDetailsResponse != null) {
          await Future.delayed(Duration(seconds: 2));
          ToastificationDialog.dismiss();
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => OutgoingTransferReceiptScreen(transDetailsResponse: state.transDetailsResponse!),
            ),
          );
        }
        if (state.newTransferStatus == Status.failure) {
          ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.success);
        }
        if (state.getTransTargetsStatus == Status.success && state.getTransTargetsResponse != null) {
          setState(() {
            targetsMap = state.getTransTargetsResponse!.data;
          });
        }
        if (state.getTaxStatus == Status.success && state.getTaxResponse != null) {
          setState(() {
            feesController.text = state.getTaxResponse!.data.tax.toString();
          });
        }
        if (state.getTargetInfoStatus == Status.success && state.getTargetInfoResponse != null) {
          final rawCurs = state.getTargetInfoResponse!.data.curs;
          final allowedSymbols = rawCurs.split(',').where((e) => e.isNotEmpty).map((e) => e.toLowerCase()).toSet();

          final allCurrencies = state.currenciesResponse?.curs ?? [];

          final matchingCurrencies =
              allCurrencies.where((cur) => allowedSymbols.contains(cur.currency.toLowerCase())).toList();

          setState(() {
            addressController.text = state.getTargetInfoResponse!.data.address;
            currenciesResponse = state.currenciesResponse;
            filteredCurrencies = matchingCurrencies;
            if (!matchingCurrencies.contains(selectedCurrency)) {
              selectedCurrency = null;
            }
          });
        }
      },
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
            buildTextField(
              hint: LocaleKeys.transfer_beneficiary_phone.tr(),
              controller: beneficiaryPhoneController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_destination.tr()),
            Builder(
              builder: (context) {
                return CustomDropdown<Target>(
                  menuList: targetsMap.values.toList(),
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
                      selectedTarget = value;
                      selectedDestination = value?.cn;
                    });
                    final String cid =
                        selectedTarget!.cid.contains('-') ? selectedTarget!.cid.split('-').first : selectedTarget!.cid;
                    final GetTargetInfoParams params = GetTargetInfoParams(id: cid, api: selectedTarget!.api);
                    context.read<TransferBloc>().add(GetTargetInfoEvent(params: params));
                    selectedCurrency = null;
                    checkRequiredFieldsFilled(context);
                  },
                );
              },
            ),

            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_transfer_currency.tr()),
            Builder(
              builder: (context) {
                return CustomDropdown<Cur>(
                  menuList: filteredCurrencies,
                  singleSelectValidator: (value) => singleSelectValidator(value),
                  initaValue: selectedCurrency,
                  compareFn: (a, b) => a.currency == b.currency,
                  labelText: LocaleKeys.transfer_transfer_currency.tr(),
                  hintText: LocaleKeys.transfer_transfer_currency.tr(),
                  itemAsString: (cur) => cur.currencyName,
                  onChanged: (cur) {
                    setState(() {
                      selectedCurrency = cur;
                      checkRequiredFieldsFilled(context);
                    });
                  },
                );
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_money_amount.tr()),
            Builder(
              builder: (context) {
                return buildTextField(
                  hint: LocaleKeys.transfer_money_amount.tr(),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) => checkRequiredFieldsFilled(context),
                );
              },
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_sender_name.tr()),
            buildTextField(hint: LocaleKeys.transfer_sender_name.tr(), controller: senderNameController),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_sender_phone.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_sender_phone.tr(),
              controller: senderPhoneController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_fees.tr()),
            buildTextField(hint: LocaleKeys.transfer_fees.tr(), controller: feesController, readOnly: true),
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.transfer_notes.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_notes.tr(),
              controller: notesController,
              mxLine: 3,
              needValidation: false,
            ),
            buildFieldTitle(title: LocaleKeys.transfer_address.tr()),
            buildTextField(
              hint: LocaleKeys.transfer_address.tr(),
              controller: addressController,
              mxLine: 3,
              readOnly: true,
            ),
            SizedBox(height: 3),
            BlocBuilder<TransferBloc, TransferState>(
              builder: (context, state) {
                return LargeButton(
                  onPressed:
                      state.newTransferStatus == Status.loading
                          ? () {}
                          : () async {
                            final blocContext = context;

                            if (_formKey.currentState!.validate()) {
                              if (feesController.text.trim().isEmpty || feesController.text == "0") {
                                ToastificationDialog.showToast(
                                  msg: "لايمكن ان تكون الاجور 0",
                                  context: context,
                                  type: ToastificationType.error,
                                );
                              } else {
                                _showDetailsDialog(
                                  context,
                                  senderName: "${senderNameController.text} ${selectedCurrency!.currency}",
                                  amount: amountController.text,
                                  onPressed: () async {
                                    final String deviceType = await DeviceInfo.deviceType();
                                    final String? deviceIp = await DeviceInfo.getDeviceIp();
                                    bool isTargetGlobal = selectedTarget!.cid.contains('-');
                                    final NewTransferParams params = NewTransferParams(
                                      target: isTargetGlobal ? 0 : int.parse(selectedTarget!.cid),
                                      rcvname: beneficiaryNameController.text,
                                      rcvphone: beneficiaryPhoneController.text,
                                      amount: int.parse(amountController.text),
                                      currency: selectedCurrency!.currency,
                                      notes: notesController.text,
                                      sender: senderNameController.text,
                                      ipInfo: deviceIp ?? "",
                                      deviceInfo: deviceType,
                                      api: selectedTarget!.api,
                                      apiInfo: isTargetGlobal ? selectedTarget!.cid : "",
                                    );
                                    // ignore: use_build_context_synchronously
                                    blocContext.read<TransferBloc>().add(NewTransferEvent(params: params));
                                  },
                                );
                              }
                            }
                          },
                  text: LocaleKeys.transfer_send.tr(),
                  backgroundColor: context.primaryContainer,
                  circularRadius: 12,
                  child: state.newTransferStatus == Status.loading ? CustomProgressIndecator() : null,
                );
              },
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
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    onChanged: onChanged,
    keyboardType: keyboardType,
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
