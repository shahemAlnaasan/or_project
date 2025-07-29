import '../../features/account_statement/data/models/account_statement_response.dart';
import '../../features/home/data/models/account_info_response.dart';

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

  final List<Acc> acc = [
    Acc(amount: 0, currency: "eur", currencyName: "يورو", currencyImg: "currencyImg"),
    Acc(amount: 0, currency: "usd", currencyName: "دولار", currencyImg: "currencyImg"),
    Acc(amount: 0, currency: "tl", currencyName: "ليرة تركية", currencyImg: "currencyImg"),
    Acc(amount: 0, currency: "", currencyName: "مقوم", currencyImg: "currencyImg"),
  ];
}
