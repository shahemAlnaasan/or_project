import 'package:golder_octopus/features/transfer/data/models/new_trans_response.dart';
import 'package:golder_octopus/features/transfer/data/models/trans_details_response.dart';

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

  NewTransResponse newTransResponse = NewTransResponse(
    status: 1,
    transnum: "transnum",
    password: "password",
    tax: "tax",
    taxcurrency: "taxcurrency",
  );

  TransDetailsResponse transDetailsResponse = TransDetailsResponse(
    status: 1,
    data: Data(
      transnum: "transnum",
      password: "password",
      transdate: DateTime.now(),
      rcvdate: DateTime.now(),
      srcName: "srcName",
      srcBox: "srcBox",
      targetName: "targetName",
      targetAddress: "targetAddress",
      targetBox: "targetBox",
      currencyId: "currencyId",
      currencyName: "currencyName",
      amount: "100",
      status: "status",
      notes: "notes",
      benifName: "benifName",
      benifPhone: "benifPhone",
      api: "api",
      apiTransnum: "apiTransnum",
      apiInfo: "apiInfo",
      fee: "fee",
      company: "company",
      header: "header",
    ),
  );
}
