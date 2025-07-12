import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/custom_drop_down.dart';
import 'package:golder_octopus/common/widgets/custom_progress_indecator.dart';
import 'package:golder_octopus/common/widgets/custom_text_field.dart';
import 'package:golder_octopus/common/widgets/date_dropdown_field.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/account_statement/domain/use_cases/account_statement_usecase.dart';
import 'package:golder_octopus/features/account_statement/presentation/bloc/account_statement_bloc.dart';
import 'package:golder_octopus/features/home/presentation/widgets/currency_balance_container.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

enum PredefinedDateRange { none, today, thisMonth, thisYear, all }

class AccountStatementForm extends StatefulWidget {
  final AccountStatementResponse accountStatement;
  final List<Statment> statments;
  final CurrencyType? currencyType;
  final CurrenciesResponse? currenciesResponse;
  const AccountStatementForm({
    super.key,
    this.currencyType,
    required this.accountStatement,
    required this.statments,
    required this.currenciesResponse,
  });

  @override
  State<AccountStatementForm> createState() => _NewTransferFormState();
}

class _NewTransferFormState extends State<AccountStatementForm> {
  final _formKey = GlobalKey<FormState>();
  final currencyFallBack = Cur(currency: '', currencyName: '', op: '', price: '', currencyImg: null);
  late final Map<PredefinedDateRange, String> predefinedDateOptions;
  PredefinedDateRange selectedRange = PredefinedDateRange.none;
  String? selectedCurrency;
  List<String> selectCurrency = [];
  Map<String, String> currencyNameToCode = {};

  DateTime? fromDate = DateTime.now().subtract(Duration(days: 5));
  DateTime? toDate = DateTime.now();
  String? getCurrencyLabel(CurrencyType? type) {
    final curs = widget.currenciesResponse?.curs ?? [];

    switch (type) {
      case CurrencyType.euro:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'eur', orElse: () => currencyFallBack).currencyName;

      case CurrencyType.turkish:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'tl', orElse: () => currencyFallBack).currencyName;

      case CurrencyType.dolar:
        return curs.firstWhere((c) => c.currency.toLowerCase() == 'usd', orElse: () => currencyFallBack).currencyName;

      default:
        return null;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    super.initState();

    final curs = widget.currenciesResponse?.curs ?? [];
    selectCurrency = curs.map((e) => e.currencyName).toList();
    currencyNameToCode = {for (var cur in curs) cur.currencyName: cur.currency};

    selectedCurrency = getCurrencyLabel(widget.currencyType); // optional fallback

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
        toDate = DateTime(now.year, now.month + 1, 0);
        break;
      case PredefinedDateRange.thisYear:
        fromDate = DateTime(now.year, 1, 1);
        toDate = DateTime(now.year, 12, 31);
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            SizedBox(height: 3),
            buildFieldTitle(title: LocaleKeys.credits_currency.tr()),
            CustomDropdown(
              menuList: selectCurrency,
              initaValue: selectedCurrency,
              labelText: LocaleKeys.credits_currency.tr(),
              hintText: LocaleKeys.credits_currency.tr(),
              onChanged: (value) {
                setState(() => selectedCurrency = value);
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
                            state.status == AcccountStmtStatus.loading
                                ? () {}
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    final params = AccountStatementParams(
                                      startDate: formatDate(fromDate),
                                      endDate: formatDate(toDate),
                                      currency: currencyNameToCode[selectedCurrency] ?? '',
                                    );
                                    context.read<AccountStatementBloc>().add(GetAccountStatementEvent(params: params));
                                  }
                                },
                        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        text: LocaleKeys.home_account_statement.tr(),
                        backgroundColor: context.primaryContainer,
                        circularRadius: 12,
                        child: state.status == AcccountStmtStatus.loading ? CustomProgressIndecator() : null,
                      ),
                    ),
                  ],
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
