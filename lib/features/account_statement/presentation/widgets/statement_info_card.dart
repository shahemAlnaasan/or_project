import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golder_octopus/common/extentions/colors_extension.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';
import 'package:golder_octopus/generated/locale_keys.g.dart';

class StatementInfoCard extends StatelessWidget {
  final AccountStatementResponse accountStatement;
  final String fromDate;
  final String toDate;
  const StatementInfoCard({super.key, required this.accountStatement, required this.fromDate, required this.toDate});

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 14);
    final redStyle = textStyle.copyWith(color: Colors.red);
    final blueStyle = textStyle.copyWith(color: Colors.blue);
    const divider = Divider(thickness: 1);

    String getAccountStatementBalanceText(AccountStatementResponse accountStatement) {
      final matching = accountStatement.currentAcc.currentAccount.firstWhere(
        (e) => e.currency == accountStatement.currency,
        orElse: () => CurrentAccount(amount: 0, currency: '', currencyName: ''),
      );

      if (matching.amount > 0) {
        return 'مدين لنا ${matching.amount.toStringAsFixed(2)} ${matching.currencyName}';
      } else if (matching.amount < 0) {
        return 'دائن علينا ${matching.amount.abs().toStringAsFixed(2)} ${matching.currencyName}';
      } else {
        return 'لا يوجد رصيد';
      }
    }

    Widget buildRow({
      required String label1,
      required String value1,
      required String label2,
      required String value2,
      Color? lable1Color,
      Color? lable2Color,

      TextStyle? style1,
      TextStyle? style2,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lable1Color ?? context.onPrimaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(child: Text(value1, style: style1 ?? textStyle)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    label2,
                    style: TextStyle(fontWeight: FontWeight.bold, color: lable2Color ?? context.onPrimaryColor),
                  ),
                ),
                Expanded(child: Text(value2, style: style2 ?? textStyle)),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildRow(
            label1: LocaleKeys.account_statement_center_name.tr(),
            value1: accountStatement.centerName,
            label2: LocaleKeys.account_statement_statement_type.tr(),
            value2: "كشف حساب اعتبارا من تاريخ $fromDate",
          ),
          divider,
          buildRow(
            label1: LocaleKeys.account_statement_account.tr(),
            value1: 'حساب ${accountStatement.currencyName}',
            label2: LocaleKeys.account_statement_current_account.tr(),
            value2: getAccountStatementBalanceText(accountStatement),
          ),
          divider,
          buildRow(
            label1: LocaleKeys.account_statement_from_date.tr(),
            value1: fromDate,
            label2: LocaleKeys.account_statement_to_date.tr(),
            value2: toDate,
          ),
          divider,
          buildRow(
            label1: LocaleKeys.account_statement_total_transfers.tr(),
            value1: "${accountStatement.inNum + accountStatement.outNum}",
            label2: LocaleKeys.account_statement_box_number.tr(),
            value2: accountStatement.centerBox,
          ),
          divider,
          buildRow(
            label1: LocaleKeys.account_statement_outgoing_transfers_number.tr(),
            value1: accountStatement.outNum.toString(),
            label2: LocaleKeys.account_statement_incoming_transfers_number.tr(),
            value2: accountStatement.inNum.toString(),
            style1: redStyle,
            style2: blueStyle,
            lable1Color: Colors.red,
            lable2Color: Colors.blue,
          ),
          divider,
          buildRow(
            label1: LocaleKeys.account_statement_total_on_us.tr(),
            value1: accountStatement.inTotal.toString(),
            label2: LocaleKeys.account_statement_total_for_us.tr(),
            value2: accountStatement.outTotal.toString(),
            style1: redStyle,
            style2: blueStyle,
            lable1Color: Colors.red,
            lable2Color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
