import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/state_managment/bloc_state.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_drop_down.dart';
import '../../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../core/di/injection.dart';
import '../../../../account_statement/data/models/currencies_response.dart';
import '../../../data/models/get_trans_targets_response.dart';
import '../../../domain/use_cases/get_target_info_usecase.dart';
import '../../../domain/use_cases/get_tax_usecase.dart';
import '../../bloc/transfer_bloc.dart';
import '../../../../../generated/locale_keys.g.dart';

class ReservedTransferForm extends StatefulWidget {
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

  const ReservedTransferForm({
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
  State<ReservedTransferForm> createState() => _ReservedTransferFormState();
}

class _ReservedTransferFormState extends State<ReservedTransferForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController beneficiaryNameController = TextEditingController();
  late TextEditingController beneficiaryPhoneController = TextEditingController();
  late TextEditingController amountController = TextEditingController();
  late TextEditingController senderNameController = TextEditingController();
  late TextEditingController senderPhoneController = TextEditingController();
  late TextEditingController feesController = TextEditingController(text: "0");
  late TextEditingController totalController = TextEditingController(text: "0");

  String? selectedDestination;
  Map<String, Target> targetsMap = {};
  Target? selectedTarget;
  CurrenciesResponse? currenciesResponse;
  List<Cur> filteredCurrencies = [];
  Cur? selectedCurrency;
  String? singleSelectValidator(value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

  @override
  void dispose() {
    beneficiaryNameController.dispose();
    beneficiaryPhoneController.dispose();
    amountController.dispose();
    senderNameController.dispose();
    senderPhoneController.dispose();
    feesController.dispose();
    totalController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransferBloc>(),
      child: BlocListener<TransferBloc, TransferState>(
        listener: (context, state) {
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
              // addressController.text = state.getTargetInfoResponse!.data.address;
              currenciesResponse = state.currenciesResponse;
              filteredCurrencies = matchingCurrencies;
              if (!matchingCurrencies.contains(selectedCurrency)) {
                selectedCurrency = null;
              }
            });
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
                buildFieldTitle(title: LocaleKeys.transfer_branch.tr()),
                Builder(
                  builder: (context) {
                    return CustomDropdown<Target>(
                      menuList: targetsMap.values.toList(),
                      singleSelectValidator: (value) => singleSelectValidator(value),
                      enableSearch: true,
                      menuMaxHeight: 250,
                      initaValue: selectedTarget,
                      compareFn: (a, b) => a.cid == b.cid,
                      labelText: LocaleKeys.transfer_branch.tr(),
                      hintText: LocaleKeys.transfer_branch.tr(),
                      itemAsString: (target) => target.cn,
                      onChanged: (value) {
                        setState(() {
                          selectedTarget = value;
                          selectedDestination = value?.cn;
                        });
                        final String cid =
                            selectedTarget!.cid.contains('-')
                                ? selectedTarget!.cid.split('-').first
                                : selectedTarget!.cid;
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
                buildTextField(hint: LocaleKeys.transfer_sender_phone.tr(), controller: senderPhoneController),

                buildFieldTitle(title: LocaleKeys.transfer_beneficiary_name.tr()),
                buildTextField(hint: LocaleKeys.transfer_beneficiary_name.tr(), controller: beneficiaryNameController),
                SizedBox(height: 3),
                buildFieldTitle(title: LocaleKeys.transfer_beneficiary_phone.tr()),
                buildTextField(
                  hint: LocaleKeys.transfer_beneficiary_phone.tr(),
                  controller: beneficiaryPhoneController,
                ),
                SizedBox(height: 3),
                buildFieldTitle(title: LocaleKeys.transfer_fees.tr()),
                buildTextField(hint: LocaleKeys.transfer_fees.tr(), controller: feesController, readOnly: true),
                SizedBox(height: 3),
                buildFieldTitle(title: LocaleKeys.transfer_total.tr()),
                buildTextField(hint: LocaleKeys.transfer_total.tr(), controller: feesController, readOnly: true),
                SizedBox(height: 3),
                buildFieldTitle(title: LocaleKeys.transfer_address.tr()),
                buildTextField(
                  hint: LocaleKeys.transfer_address.tr(),
                  controller: totalController,
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
                                if (_formKey.currentState!.validate()) {
                                  // final String deviceType = await DeviceInfo.deviceType();
                                  // final String? deviceIp = await DeviceInfo.getDeviceIp();
                                  // bool isTargetGlobal = selectedTarget!.cid.contains('-');
                                  // final NewTransferParams params = NewTransferParams(
                                  //   target: isTargetGlobal ? 0 : int.parse(selectedTarget!.cid),
                                  //   rcvname: beneficiaryNameController.text,
                                  //   rcvphone: beneficiaryPhoneController.text,
                                  //   amount: int.parse(amountController.text),
                                  //   currency: selectedCurrency!.currency,
                                  //   notes: notesController.text,
                                  //   sender: senderNameController.text,
                                  //   ipInfo: deviceIp ?? "",
                                  //   deviceInfo: deviceType,
                                  //   api: selectedTarget!.api,
                                  //   apiInfo: isTargetGlobal ? selectedTarget!.cid : "",
                                  // );
                                  // context.read<TransferBloc>().add(NewTransferEvent(params: params));
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
