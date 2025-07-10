import 'package:flutter/material.dart';
import 'package:golder_octopus/common/utils/number_to_arabic_words.dart';
import 'package:golder_octopus/common/widgets/app_text.dart';
import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';

class BalanceInWordsContainer extends StatelessWidget {
  final AccountStatementResponse accountStatement;
  const BalanceInWordsContainer({super.key, required this.accountStatement});
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 224, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppText.bodyLarge(
            "الرصيد كتابة ${getFinalBalance(accountStatement)}",
            textAlign: TextAlign.start,
            color: const Color.fromARGB(255, 10, 65, 160),
          ),
        ),
      ),
    );
  }
}
