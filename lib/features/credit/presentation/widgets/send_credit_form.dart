import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/features/credit/presentation/pages/credit_receipt_screen.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/state_managment/bloc_state.dart';
import '../../../../common/utils/device_info.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/custom_drop_down.dart';
import '../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/large_button.dart';
import '../../../../common/widgets/toast_dialog.dart';
import '../../../account_statement/data/models/currencies_response.dart';
import '../../data/models/get_companies_response.dart';
import '../../data/models/get_credit_targets_response.dart';
import '../../domain/use_cases/get_credit_targets_usecase.dart';
import '../../domain/use_cases/get_credit_tax_usecase.dart';
import '../../domain/use_cases/new_credit_usecase.dart';
import '../bloc/credit_bloc.dart';
import 'dialog/confirm_credit_dialog.dart';
import '../../../transfer/domain/use_cases/trans_details_usecase.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

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
  SendCreditFormState createState() => SendCreditFormState();
}

class SendCreditFormState extends State<SendCreditForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController amountController;
  late TextEditingController feesController;
  late TextEditingController notesController;

  List<Company> companies = [];
  Company? selectedCompany;
  String? selectedCreditType;
  List<Cur> currencies = [];
  Cur? selectedCurrency;
  List<Target> boxes = [];
  Target? selectedBox;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.amount ?? '');
    feesController = TextEditingController(text: widget.fees ?? '0');
    notesController = TextEditingController(text: widget.notes ?? '');
  }

  @override
  void dispose() {
    amountController.dispose();
    feesController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

  void checkRequiredFieldsFilled(BuildContext context) {
    if (selectedCompany != null && selectedCurrency != null && amountController.text.trim().isNotEmpty) {
      final GetCreditTaxParams params = GetCreditTaxParams(
        amount: int.parse(amountController.text.trim()),
        currency: selectedCurrency!.currency,
        type: selectedCompany!.id,
      );
      context.read<CreditBloc>().add(GetCreditTaxEvent(params: params));
    } else {
      setState(() {
        feesController.text = "0";
      });
    }
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
        return ConfirmCreditDialog(senderName: senderName, amount: amount, onPressed: onPressed);
      },
    );
  }

  void resetForm(BuildContext context) {
    setState(() {
      companies = [];
      selectedCompany = null;
      selectedCreditType = null;
      currencies = [];
      selectedCurrency = null;
      amountController.clear();
      feesController.text = "0";
      notesController.clear();
      boxes = [];
      selectedBox = null;
      selectedCurrency = null;
    });
    context.read<CreditBloc>()
      ..add(GetCompaniesEvent())
      ..add(GetCurrenciesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.newCreditStatus != curr.newCreditStatus,
          listener: (context, state) async {
            if (state.newCreditStatus == Status.failure) {
              ToastificationDialog.showToast(
                msg: state.errorMessage!,
                context: context,
                type: ToastificationType.error,
              );
            }
            if (state.newCreditStatus == Status.success && state.newCreditResponse != null) {
              ToastificationDialog.showToast(
                msg: "تم ارسال الحوالة",
                context: context,
                type: ToastificationType.success,
                autoCloseDuration: Duration(seconds: 15),
              );
              TransDetailsParams params = TransDetailsParams(transNum: state.newCreditResponse!.transnum);
              context.read<CreditBloc>().add(GetNewCreditDetailsEvent(params: params));
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.getCompaniesStatus != curr.getCompaniesStatus,
          listener: (context, state) async {
            if (state.getCompaniesStatus == Status.success && state.getCompaniesResponse != null) {
              setState(() {
                companies = state.getCompaniesResponse!.companies;
                selectedCompany = state.getCompaniesResponse!.companies.firstWhere(
                  (company) => company.name == "الايهم داخلي",
                );
              });
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.getCurreciesStatus != curr.getCurreciesStatus,
          listener: (context, state) async {
            if (state.getCurreciesStatus == Status.success && state.currenciesResponse != null) {
              context.read<CreditBloc>().add(GetSenderCursEvent());
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.getSenderCursStatus != curr.getSenderCursStatus,
          listener: (context, state) async {
            if (state.getSenderCursStatus == Status.success && state.getSenderCursResponse != null) {
              final rawCurs = state.getSenderCursResponse!.data.curs;
              final allowedSymbols = rawCurs.split(',').where((e) => e.isNotEmpty).map((e) => e.toLowerCase()).toSet();

              final allCurrencies = state.currenciesResponse?.curs ?? [];

              final matchingCurrencies =
                  allCurrencies.where((cur) => allowedSymbols.contains(cur.currency.toLowerCase())).toList();

              setState(() {
                currencies = matchingCurrencies;
              });
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.getCreditTaxStatus != curr.getCreditTaxStatus,
          listener: (context, state) async {
            if (state.getCreditTaxStatus == Status.success && state.getCreditTaxResponse != null) {
              setState(() {
                feesController.text = state.getCreditTaxResponse!.tax.toString();
              });
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.getCreditTargetsStatus != curr.getCreditTargetsStatus,
          listener: (context, state) async {
            if (state.getCreditTargetsStatus == Status.success && state.getCreditTargetsResponse != null) {
              setState(() {
                boxes = state.getCreditTargetsResponse!.targets;
              });
            }
          },
        ),
        BlocListener<CreditBloc, CreditState>(
          listenWhen: (prev, curr) => prev.newCreditDetailsStatus != curr.newCreditDetailsStatus,
          listener: (context, state) async {
            if (state.newCreditDetailsStatus == Status.success && state.creditDetailsResponse != null) {
              log("newCreditDetailsStatus workes");
              await Future.delayed(Duration(seconds: 2));
              ToastificationDialog.dismiss();
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => CreditReceiptScreen(transDetailsResponse: state.creditDetailsResponse!),
                ),
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              buildFieldTitle(title: LocaleKeys.credits_company.tr()),
              CustomDropdown<Company>(
                menuList: companies,
                enableSearch: true,
                menuMaxHeight: 250,
                singleSelectValidator: (value) => singleSelectValidator(value),
                initaValue: selectedCompany,
                compareFn: (a, b) => a.id == b.id,
                labelText: LocaleKeys.credits_company.tr(),
                hintText: LocaleKeys.credits_company.tr(),
                itemAsString: (company) => company.name,
                onChanged: (company) {
                  setState(() {
                    selectedCompany = company!;
                    checkRequiredFieldsFilled(context);
                  });
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_credit_type.tr()),
              CustomDropdown(
                menuList: ['مباشر', 'اعتماد محجوز لحين التنفيذ'],
                initaValue: "مباشر",
                labelText: LocaleKeys.credits_credit_type.tr(),
                hintText: LocaleKeys.credits_credit_type.tr(),
                onChanged: (value) {
                  setState(() => selectedCreditType = value);
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
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
                    checkRequiredFieldsFilled(context);
                  });
                },
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_amount.tr()),
              buildTextField(
                hint: LocaleKeys.credits_amount.tr(),
                keyboardType: TextInputType.number,
                controller: amountController,
                onChanged: (p0) => checkRequiredFieldsFilled(context),
              ),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_box.tr()),
              CustomDropdown<Target>(
                menuList: boxes,
                enableSearch: true,
                menuMaxHeight: 250,
                singleSelectValidator: (value) => singleSelectValidator(value),
                initaValue: selectedBox,
                compareFn: (a, b) => a.cid == b.cid,
                labelText: LocaleKeys.credits_box.tr(),
                hintText: LocaleKeys.credits_box.tr(),
                itemAsString: (box) => box.cn,
                onChangedSearch: (p0) {
                  if (selectedCompany != null) {
                    if (p0.length >= 3) {
                      GetCreditTargetsParams params = GetCreditTargetsParams(company: selectedCompany!.id, name: p0);
                      context.read<CreditBloc>().add(GetCreditTargetsEvent(params: params));
                    }
                  } else {
                    ToastificationDialog.showToast(
                      msg: "ًالرجاء اختيار شركة اولاً",
                      context: context,
                      type: ToastificationType.warning,
                    );
                  }
                },
                onChanged: (box) {
                  setState(() {
                    selectedBox = box;
                  });
                },
              ),
              buildFieldTitle(title: LocaleKeys.credits_fees.tr()),
              buildTextField(hint: LocaleKeys.credits_fees.tr(), controller: feesController, readOnly: true),
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_notes.tr()),
              buildTextField(
                hint: LocaleKeys.credits_notes.tr(),
                controller: notesController,
                mxLine: 3,
                needValidation: false,
              ),
              SizedBox(height: 3),
              BlocBuilder<CreditBloc, CreditState>(
                builder: (context, state) {
                  return LargeButton(
                    onPressed:
                        state.newCreditStatus == Status.loading
                            ? () {}
                            : () async {
                              final blocContext = context;

                              if (_formKey.currentState!.validate()) {
                                if (feesController.text.trim().isEmpty || int.tryParse(feesController.text) == 0) {
                                  ToastificationDialog.showToast(
                                    msg: "لايمكن ان تكون الاجور 0",
                                    context: context,
                                    type: ToastificationType.error,
                                  );
                                } else {
                                  _showDetailsDialog(
                                    blocContext,
                                    senderName: "${selectedBox!.cn} ${selectedCurrency!.currencyName}",
                                    amount: amountController.text,
                                    onPressed: () async {
                                      final String deviceType = await DeviceInfo.deviceType();
                                      final String? deviceIp = await DeviceInfo.getDeviceIp();
                                      // ignore: unused_local_variable
                                      final NewCreditParams params = NewCreditParams(
                                        company: selectedCompany!.id,
                                        amount: amountController.text.trim(),
                                        currency: selectedCurrency!.currency,
                                        targetId: selectedBox!.cid,
                                        targetName: selectedBox!.cn,
                                        ipInfo: deviceIp ?? "",
                                        deviceInfo: deviceType,
                                      );
                                      // ignore: use_build_context_synchronously
                                      blocContext.read<CreditBloc>().add(NewCreditEvent(params: params));
                                      await Future.delayed(Duration(seconds: 1));
                                      // ignore: use_build_context_synchronously
                                      resetForm(blocContext);
                                    },
                                  );
                                }
                              }
                            },
                    text: LocaleKeys.transfer_send.tr(),
                    backgroundColor: context.primaryContainer,
                    circularRadius: 12,
                    child: state.newCreditStatus == Status.loading ? CustomProgressIndecator() : null,
                  );
                },
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
  void Function(String)? onChanged,
  bool needValidation = true,
  TextInputType? keyboardType,
  FocusNode? focusNode,
  FocusNode? focusOn,
}) {
  return CustomTextField(
    onTap: onTap,
    readOnly: readOnly,
    mxLine: mxLine,
    onChanged: onChanged,
    controller: controller,
    hint: hint,
    keyboardType: keyboardType,
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
