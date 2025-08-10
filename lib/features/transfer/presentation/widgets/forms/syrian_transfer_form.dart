import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_prices_response.dart';
import 'package:golder_octopus/features/transfer/data/models/get_sy_targets_response.dart';
import 'package:golder_octopus/features/transfer/presentation/bloc/transfer_bloc.dart';
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

  GetSyPricesResponse? getSyPricesResponse;
  GetSyTargetsResponse? getSyTargetsResponse;

  List<Target> targets = [];
  Target? selectedTarget;

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

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

  void resetForm() {
    setState(() {
      beneficiaryNameController.clear();
      beneficiaryPhoneController.clear();
      amountController.clear();
      feesController.text = "0";
      notesController.clear();
      addressController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state.getSyPricesStatus == Status.failure) {
          ToastificationDialog.showToast(
            msg: state.errorMessage ?? "error",
            context: context,
            type: ToastificationType.error,
          );
        }
        if (state.getSyPricesStatus == Status.success && state.getSyPricesResponse != null) {
          setState(() {
            getSyPricesResponse = state.getSyPricesResponse;
          });
        }
        if (state.getSyTargetsStatus == Status.success && state.getSyTargetsResponse != null) {
          setState(() {
            getSyTargetsResponse = state.getSyTargetsResponse;
            targets = getSyTargetsResponse?.targets.values.toList() ?? [];
          });
        }
        if (state.newSyTransferStatus == Status.success && state.newSyTransferResponse != null) {}
      },
      child: SingleChildScrollView(
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
                  });
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.transfer_transfer_currency.tr()),
              // CustomDropdown<Price>(
              //   menuList: prices,
              //   singleSelectValidator: (value) => singleSelectValidator(value),
              //   enableSearch: true,
              //   menuMaxHeight: 250,
              //   initaValue: selectedTarget,
              //   compareFn: (a, b) => a.name == b.name,
              //   labelText: LocaleKeys.transfer_destination.tr(),
              //   hintText: LocaleKeys.transfer_destination.tr(),
              //   itemAsString: (price) => price.name,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedTarget = value!;
              //     });
              //   },
              // ),
              // // CustomDropdown(
              // //   menuList: ['USD', 'EUR', 'SYP'],
              // //   initaValue: selectedCurrency,
              // //   labelText: LocaleKeys.transfer_transfer_currency.tr(),
              // //   hintText: LocaleKeys.transfer_transfer_currency.tr(),
              // //   onChanged: (value) {
              // //     setState(() => selectedCurrency = value);
              // //   },
              // // ),
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
