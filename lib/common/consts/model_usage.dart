import 'package:golder_octopus/features/account_statement/data/models/account_statement_response.dart';

class ModelUsage {
  final AccountStatementResponse accountStatementResponse = AccountStatementResponse(
    currentAcc: CurrentAcc(currentAccount: [CurrentAccount(amount: 0, currency: "", currencyName: "")]),
    currency: "",
    currencyName: "",
    currencySuffix: "",
    centerName: "",
    centerCity: "",
    centerBox: "",
    statment: [
      Statment(
        date: DateTime.now().subtract(Duration(days: 5)),
        type: "",
        transnum: "",
        amount: 0,
        account: 0,
        statmentClass: "",
      ),
    ],
    lastAccount: 0,
    outNum: 0,
    inNum: 0,
    outTotal: 0,
    inTotal: 0,
  );
}
