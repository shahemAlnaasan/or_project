// To parse this JSON data, do
//
//     final accountInfoResponse = accountInfoResponseFromJson(jsonString);

import 'dart:convert';

AccountInfoResponse accountInfoResponseFromJson(String str) => AccountInfoResponse.fromJson(json.decode(str));

String accountInfoResponseToJson(AccountInfoResponse data) => json.encode(data.toJson());

class AccountInfoResponse {
  List<Acc> accs;
  int outActions;
  int inActions;

  AccountInfoResponse({required this.accs, required this.outActions, required this.inActions});

  factory AccountInfoResponse.fromJson(Map<String, dynamic> json) => AccountInfoResponse(
    accs: List<Acc>.from(json["accs"].map((x) => Acc.fromJson(x))),
    outActions: json["out"],
    inActions: json["in"],
  );

  Map<String, dynamic> toJson() => {
    "accs": List<dynamic>.from(accs.map((x) => x.toJson())),
    "out": outActions,
    "in": inActions,
  };
}

class Acc {
  double amount;
  String currency;
  String currencyName;
  String currencyImg;
  String? suffix;

  Acc({
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.currencyImg,
    this.suffix,
  });

  factory Acc.fromJson(Map<String, dynamic> json) => Acc(
    amount: json["amount"]?.toDouble(),
    currency: json["currency"] ?? "",
    currencyName: json["currency_name"] ?? "",
    currencyImg: json["currency_img"] ?? "",
    suffix: json["suffix"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "currency_name": currencyName,
    "currency_img": currencyImg,
    "suffix": suffix,
  };
}
