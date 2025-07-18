import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golder_octopus/common/consts/model_usage.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/common/extentions/size_extension.dart';
import 'package:golder_octopus/common/state_managment/bloc_state.dart';
import 'package:golder_octopus/common/utils/number_to_arabic_words.dart';
import 'package:golder_octopus/common/utils/pdf_generator.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/common/widgets/large_button.dart';
import 'package:golder_octopus/common/widgets/toast_dialog.dart';
import 'package:golder_octopus/core/di/injection.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/features/account_statement/data/models/currencies_response.dart';
import 'package:golder_octopus/features/account_statement/presentation/bloc/account_statement_bloc.dart';
import 'package:golder_octopus/features/account_statement/presentation/widgets/forms/account_statement_form.dart';
import 'package:golder_octopus/features/account_statement/presentation/widgets/account_statement_table.dart';
import 'package:golder_octopus/features/account_statement/presentation/widgets/balance_in_words_container.dart';
import 'package:golder_octopus/features/account_statement/presentation/widgets/statement_info_card.dart';
import 'package:golder_octopus/features/home/presentation/widgets/currency_balance_container.dart';
import 'package:golder_octopus/generated/assets.gen.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';
import 'package:toastification/toastification.dart';

class AccountStatementScreen extends StatefulWidget {
  final CurrencyType? currencyType;

  const AccountStatementScreen({super.key, this.currencyType});

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  AccountStatementResponse accountStatementResponse = ModelUsage().accountStatementResponse;
  final TextEditingController searchController = TextEditingController();
  CurrenciesResponse? currenciesResponse;
  String _searchQuery = "";

  List<Statment> get filteredList {
    if (_searchQuery.isEmpty) return accountStatementResponse.statment;

    return accountStatementResponse.statment.where((item) {
      final query = _searchQuery.toLowerCase();

      final notes = item.notes?.toLowerCase() ?? '';
      final transNum = item.transnum.toLowerCase();
      final date = item.date.toString().toLowerCase();
      final amount = item.amount.toString().toLowerCase();
      final type = item.type.toLowerCase();

      return notes.contains(query) ||
          transNum.contains(query) ||
          type.contains(query) ||
          date.contains(query) ||
          amount.contains(query);
    }).toList();
  }

  String getAccountStatementBalanceText(AccountStatementResponse accountStatement) {
    final matching = accountStatement.currentAcc.currentAccount.firstWhere(
      (e) => e.currency == accountStatement.currency,
      orElse: () => CurrentAccount(amount: 0, currency: '', currencyName: ''),
    );

    if (matching.amount > 0) {
      return '${matching.currencyName} مدين لنا';
    } else if (matching.amount < 0) {
      return '${matching.currencyName} دائن علينا';
    } else {
      return 'لا يوجد رصيد';
    }
  }

  String getFinalBalance(AccountStatementResponse accountStatement) {
    final matching = accountStatement.currentAcc.currentAccount.firstWhere(
      (e) => e.currency == accountStatement.currency,
      orElse: () => CurrentAccount(amount: 0, currency: '', currencyName: ''),
    );
    String dibtOrCredit = getAccountStatementBalanceText(accountStatement);
    String balanceInWords = NumberToArabicWords.convertToWords(matching.amount.toInt().abs());

    return "$balanceInWords $dibtOrCredit";
  }

  Future<void> print({
    required AccountStatementResponse accountStatement,
    required List<Statment> statments,
    required String fromDate,
    required String toDate,
    required String balanceInWords,
  }) async {
    log("print statment length${statments.length} $statments");
    await PdfGenerator.generateStatementPdf(
      accountStatement: accountStatement,
      statments: statments,
      fromDate: fromDate,
      toDate: toDate,
      balanceInWords: balanceInWords,
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final query = searchController.text.trim().toLowerCase();
      setState(() => _searchQuery = query);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountStatementBloc>()..add(GetCurrenciesEvent()),
      child: BlocListener<AccountStatementBloc, AccountStatementState>(
        listener: (context, state) {
          if (state.status == AcccountStmtStatus.failure) {
            ToastificationDialog.showToast(msg: state.errorMessage!, context: context, type: ToastificationType.error);
          }
          if (state.getCurreciesStatus == Status.success) {
            setState(() {
              currenciesResponse = state.currenciesResponse;
            });
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 75),
              width: context.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.displaySmall(
                    LocaleKeys.home_account_statement.tr(),
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  AccountStatementForm(
                    currencyType: widget.currencyType,
                    accountStatement: accountStatementResponse,
                    statments: filteredList,
                    currenciesResponse: currenciesResponse,
                  ),

                  BlocBuilder<AccountStatementBloc, AccountStatementState>(
                    builder: (context, state) {
                      if (state.status == AcccountStmtStatus.success) {
                        accountStatementResponse = state.accountStatement!;
                        return Column(
                          children: [
                            LargeButton(
                              onPressed: () async {
                                await print(
                                  accountStatement: state.accountStatement!,
                                  statments: filteredList,
                                  fromDate: state.fromDate!,
                                  toDate: state.toDate!,
                                  balanceInWords: getFinalBalance(state.accountStatement!),
                                );
                              },
                              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              icon: Assets.images.printer.path,
                              text: LocaleKeys.account_statement_print.tr(),
                              backgroundColor: context.primaryContainer,
                              circularRadius: 12,
                            ),

                            SizedBox(height: 10),
                            StatementInfoCard(
                              accountStatement: state.accountStatement!,
                              fromDate: state.fromDate!,
                              toDate: state.toDate!,
                            ),
                            SizedBox(height: 20),
                            AccountStatementTable(
                              searchController: searchController,
                              statments: filteredList,
                              inTotal: state.accountStatement!.inTotal,
                              outTotal: state.accountStatement!.outTotal,
                            ),
                            SizedBox(height: 20),
                            BalanceInWordsContainer(accountStatement: state.accountStatement!),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    AppText.titleLarge(
                                      "الرصيد السابق ",
                                      textAlign: TextAlign.start,
                                      color: context.onPrimaryColor,
                                    ),
                                    AppText.titleLarge(
                                      " ${state.accountStatement!.lastAccount}",
                                      textAlign: TextAlign.start,
                                      color: context.onPrimaryColor,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
