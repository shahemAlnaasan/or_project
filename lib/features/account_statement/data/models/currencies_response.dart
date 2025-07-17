// To parse this JSON data, do
//
//     final currenciesResponse = currenciesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

CurrenciesResponse currenciesResponseFromJson(String str) => CurrenciesResponse.fromJson(json.decode(str));

String currenciesResponseToJson(CurrenciesResponse data) => json.encode(data.toJson());

class CurrenciesResponse extends HiveObject {
  int status;
  List<Cur> curs;

  CurrenciesResponse({required this.status, required this.curs});

  factory CurrenciesResponse.fromJson(Map<String, dynamic> json) =>
      CurrenciesResponse(status: json["status"], curs: List<Cur>.from(json["curs"].map((x) => Cur.fromJson(x))));

  Map<String, dynamic> toJson() => {"status": status, "curs": List<dynamic>.from(curs.map((x) => x.toJson()))};
}

class Cur extends HiveObject {
  String currency;
  String currencyName;
  String op;
  String price;
  String? currencyImg;

  Cur({
    required this.currency,
    required this.currencyName,
    required this.op,
    required this.price,
    required this.currencyImg,
  });

  factory Cur.fromJson(Map<String, dynamic> json) => Cur(
    currency: json["currency"],
    currencyName: json["currency_name"],
    op: json["op"],
    price: json["price"],
    currencyImg: json["currency_img"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "currency_name": currencyName,
    "op": op,
    "price": price,
    "currency_img": currencyImg,
  };
}
