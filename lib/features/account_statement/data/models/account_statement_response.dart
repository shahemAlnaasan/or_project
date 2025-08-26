// To parse this JSON data, do
//
//     final accountStatementResponse = accountStatementResponseFromJson(jsonString);

import 'dart:convert';

AccountStatementResponse accountStatementResponseFromJson(String str) =>
    AccountStatementResponse.fromJson(json.decode(str));

String accountStatementResponseToJson(AccountStatementResponse data) => json.encode(data.toJson());

class AccountStatementResponse {
  CurrentAcc currentAcc;
  String currency;
  String currencyName;
  String currencySuffix;
  String centerName;
  String centerCity;
  String centerBox;
  List<Statment> statment;
  double lastAccount;
  int outNum;
  int inNum;
  double outTotal;
  double inTotal;

  AccountStatementResponse({
    required this.currentAcc,
    required this.currency,
    required this.currencyName,
    required this.currencySuffix,
    required this.centerName,
    required this.centerCity,
    required this.centerBox,
    required this.statment,
    required this.lastAccount,
    required this.outNum,
    required this.inNum,
    required this.outTotal,
    required this.inTotal,
  });

  factory AccountStatementResponse.fromJson(Map<String, dynamic> json) => AccountStatementResponse(
    currentAcc: CurrentAcc.fromJson(json["cuurent_acc"]),
    currency: json["currency"] ?? "",
    currencyName: json["currency_name"] ?? "",
    currencySuffix: json["currency_suffix"] ?? "",
    centerName: json["center_name"],
    centerCity: json["center_city"],
    centerBox: json["center_box"],
    statment: json["statment"] != null ? List<Statment>.from(json["statment"].map((x) => Statment.fromJson(x))) : [],
    lastAccount: json["last_account"]?.toDouble() ?? 0.0,
    outNum: json["out_num"] ?? 0,
    inNum: json["in_num"] ?? 0,
    outTotal: json["out_total"]?.toDouble() ?? 0.0,
    inTotal: json["in_total"]?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "cuurent_acc": currentAcc.toJson(),
    "currency": currency,
    "currency_name": currencyName,
    "currency_suffix": currencySuffix,
    "center_name": centerName,
    "center_city": centerCity,
    "center_box": centerBox,
    "statment": List<dynamic>.from(statment.map((x) => x.toJson())),
    "last_account": lastAccount,
    "out_num": outNum,
    "in_num": inNum,
    "out_total": outTotal,
    "in_total": inTotal,
  };
  AccountStatementResponse copyWith({
    CurrentAcc? currentAcc,
    String? currency,
    String? currencyName,
    String? currencySuffix,
    String? centerName,
    String? centerCity,
    String? centerBox,
    List<Statment>? statment,
    double? lastAccount,
    int? outNum,
    int? inNum,
    double? outTotal,
    double? inTotal,
  }) {
    return AccountStatementResponse(
      currentAcc: currentAcc ?? this.currentAcc,
      currency: currency ?? this.currency,
      currencyName: currencyName ?? this.currencyName,
      currencySuffix: currencySuffix ?? this.currencySuffix,
      centerName: centerName ?? this.centerName,
      centerCity: centerCity ?? this.centerCity,
      centerBox: centerBox ?? this.centerBox,
      statment: statment ?? this.statment,
      lastAccount: lastAccount ?? this.lastAccount,
      outNum: outNum ?? this.outNum,
      inNum: inNum ?? this.inNum,
      outTotal: outTotal ?? this.outTotal,
      inTotal: inTotal ?? this.inTotal,
    );
  }
}

class CurrentAcc {
  List<CurrentAccount> currentAccount;

  CurrentAcc({required this.currentAccount});

  factory CurrentAcc.fromJson(Map<String, dynamic> json) => CurrentAcc(
    currentAccount: List<CurrentAccount>.from(json["current_account"].map((x) => CurrentAccount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"current_account": List<dynamic>.from(currentAccount.map((x) => x.toJson()))};
}

class CurrentAccount {
  double amount;
  String currency;
  String currencyName;

  CurrentAccount({required this.amount, required this.currency, required this.currencyName});

  factory CurrentAccount.fromJson(Map<String, dynamic> json) {
    return CurrentAccount(
      amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
      currency: json["currency"] ?? "",
      currencyName: json["currency_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {"amount": amount, "currency": currency, "currency_name": currencyName};
}

class Statment {
  DateTime date;
  String type;
  String transnum;
  String? notes;
  double amount;
  double account;
  String statmentClass;

  Statment({
    required this.date,
    required this.type,
    required this.transnum,
    this.notes,
    required this.amount,
    required this.account,
    required this.statmentClass,
  });

  factory Statment.fromJson(Map<String, dynamic> json) => Statment(
    date: DateTime.parse(json["date"]),
    type: json["type"],
    transnum: json["transnum"],
    notes: json["notes"] ?? " ",
    amount: _parseToDouble(json["amount"]),
    account: _parseToDouble(json["account"]),
    statmentClass: json["class"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "type": type,
    "transnum": transnum,
    "notes": notes,
    "amount": amount,
    "account": account,
    "class": statmentClass,
  };
}

double _parseToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  throw FormatException("Invalid number: $value");
}
