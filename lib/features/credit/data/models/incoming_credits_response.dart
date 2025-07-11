// To parse this JSON data, do
//
//     final incomingCreditsResponse = incomingCreditsResponseFromJson(jsonString);

import 'dart:convert';

IncomingCreditsResponse incomingCreditsResponseFromJson(String str) =>
    IncomingCreditsResponse.fromJson(json.decode(str));

String incomingCreditsResponseToJson(IncomingCreditsResponse data) => json.encode(data.toJson());

class IncomingCreditsResponse {
  String transnum;
  String source;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String notes;
  String status;

  IncomingCreditsResponse({
    required this.transnum,
    required this.source,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.notes,
    required this.status,
  });

  factory IncomingCreditsResponse.fromJson(Map<String, dynamic> json) => IncomingCreditsResponse(
    transnum: json["transnum"],
    source: json["source"],
    amount: json["amount"],
    currency: json["currency"],
    currencyName: json["currency_name"],
    transdate: DateTime.parse(json["transdate"]),
    notes: json["notes"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "transnum": transnum,
    "source": source,
    "amount": amount,
    "currency": currency,
    "currency_name": currencyName,
    "transdate": transdate.toIso8601String(),
    "notes": notes,
    "status": status,
  };
}
