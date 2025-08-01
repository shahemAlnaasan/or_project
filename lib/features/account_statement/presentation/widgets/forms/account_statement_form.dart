import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/extentions/colors_extension.dart';
import '../../../../../common/state_managment/bloc_state.dart';
import '../../../../../common/widgets/app_text.dart';
import '../../../../../common/widgets/custom_drop_down.dart';
import '../../../../../common/widgets/custom_progress_indecator.dart';
import '../../../../../common/widgets/custom_text_field.dart';
import '../../../../../common/widgets/date_dropdown_field.dart';
import '../../../../../common/widgets/large_button.dart';
import '../../../../../common/widgets/toast_dialog.dart';
import '../../../data/models/account_statement_response.dart';
import '../../../data/models/currencies_response.dart';
import '../../../domain/use_cases/account_statement_usecase.dart';
import '../../bloc/account_statement_bloc.dart';
import '../../../../home/presentation/widgets/currency_balance_container.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

enum PredefinedDateRange { none, today, thisMonth, thisYear, all }

class AccountStatementForm extends StatefulWidget {
  final AccountStatementResponse accountStatement;
  final List<Statment> statments;
  final CurrencyType? currencyType;

  const AccountStatementForm({super.key, this.currencyType, required this.accountStatement, required this.statments});

  @override
  State<AccountStatementForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<AccountStatementForm> {
  final _formKey = GlobalKey<FormState>();
  final currencyFallBack = Cur(currency: '', currencyName: '', op: '', price: '', currencyImg: null);
  late final Map<PredefinedDateRange, String> predefinedDateOptions;
  PredefinedDateRange selectedRange = PredefinedDateRange.none;
  List<Cur> currencies = [];
  Cur? selectedCurrency;

  Map<String, String> currencyNameToCode = {};

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate = DateTime.now();
  Cur? getCurrencyLabel({required CurrencyType? type, required List<Cur> curs}) {
    switch (type) {
      case CurrencyType.euro:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'eur', orElse: () => currencyFallBack);

      case CurrencyType.turkish:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'tl', orElse: () => currencyFallBack);

      case CurrencyType.dolar:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'usd', orElse: () => currencyFallBack);

      default:
        return null;
    }
  }

  String? singleSelectValidator(value) {
    if (value == null) {
      return LocaleKeys.transfer_this_field_cant_be_empty.tr();
    }
    return null;
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    super.initState();

    predefinedDateOptions = {
      PredefinedDateRange.none: LocaleKeys.account_statement_select_date.tr(),
      PredefinedDateRange.today: LocaleKeys.account_statement_only_today.tr(),
      PredefinedDateRange.thisMonth: LocaleKeys.account_statement_only_this_month.tr(),
      PredefinedDateRange.thisYear: LocaleKeys.account_statement_only_this_year.tr(),
      PredefinedDateRange.all: LocaleKeys.account_statement_all.tr(),
    };
  }

  void setDate(PredefinedDateRange range) {
    final now = DateTime.now();
    switch (range) {
      case PredefinedDateRange.today:
        fromDate = DateTime(now.year, now.month, now.day);
        toDate = DateTime(now.year, now.month, now.day);
        break;
      case PredefinedDateRange.thisMonth:
        fromDate = DateTime(now.year, now.month, 1);
        toDate = now;
        break;
      case PredefinedDateRange.thisYear:
        fromDate = DateTime(now.year, 1, 1);
        toDate = now;
        break;
      case PredefinedDateRange.all:
        fromDate = DateTime(2000);
        toDate = now;
        break;
      case PredefinedDateRange.none:
        // keep manual pickers
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountStatementBloc, AccountStatementState>(
      listener: (context, state) {
        if (state.getCurreciesStatus == Status.success && state.currenciesResponse != null) {
          setState(() {
            currencies = state.currenciesResponse!.curs;
            selectedCurrency = getCurrencyLabel(type: widget.currencyType, curs: currencies);
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
              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
              CustomDropdown<Cur>(
                menuList: currencies,
                singleSelectValidator: (value) => singleSelectValidator(value),
                initaValue: selectedCurrency,
                compareFn: (a, b) => a.currency == b.currency,
                labelText: LocaleKeys.credits_currency.tr(),
                hintText: LocaleKeys.credits_currency.tr(),
                itemAsString: (cur) => cur.currencyName,
                onChanged: (cur) {
                  setState(() {
                    selectedCurrency = cur;
                  });
                },
              ),

              SizedBox(height: 3),
              buildFieldTitle(title: LocaleKeys.account_statement_choose_date.tr()),
              CustomDropdown(
                menuList: predefinedDateOptions.values.toList(),
                initaValue: predefinedDateOptions[selectedRange],
                labelText: LocaleKeys.account_statement_choose_date.tr(),
                hintText: LocaleKeys.account_statement_choose_date.tr(),
                onChanged: (value) {
                  final range = predefinedDateOptions.entries.firstWhere((entry) => entry.value == value).key;
                  setState(() {
                    selectedRange = range;
                    setDate(range);
                  });
                },
              ),

              if (selectedRange == PredefinedDateRange.none) ...[
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bodyMedium(LocaleKeys.transfer_from_date.tr()),
                    DateDropdownField(selectedDate: fromDate, onChanged: (picked) => setState(() => fromDate = picked)),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bodyMedium(LocaleKeys.transfer_to_date.tr()),
                    DateDropdownField(selectedDate: toDate, onChanged: (picked) => setState(() => toDate = picked)),
                  ],
                ),
              ],
              SizedBox(height: 10),
              BlocBuilder<AccountStatementBloc, AccountStatementState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: LargeButton(
                          onPressed:
                              state.accountStatmentStatus == Status.loading
                                  ? () {}
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      final params = AccountStatementParams(
                                        startDate: formatDate(fromDate),
                                        endDate: formatDate(toDate),
                                        currency: selectedCurrency!.currency,
                                      );
                                      context.read<AccountStatementBloc>().add(
                                        GetAccountStatementEvent(params: params),
                                      );
                                    } else {
                                      ToastificationDialog.showToast(
                                        msg: "الرجاء اختيار العملة",
                                        context: context,
                                        type: ToastificationType.error,
                                      );
                                    }
                                  },
                          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          text: LocaleKeys.home_account_statement.tr(),
                          backgroundColor: context.primaryContainer,
                          circularRadius: 12,
                          child: state.accountStatmentStatus == Status.loading ? CustomProgressIndecator() : null,
                        ),
                      ),
                    ],
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
