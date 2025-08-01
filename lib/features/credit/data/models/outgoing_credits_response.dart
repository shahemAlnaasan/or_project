// To parse this JSON data, do
//
//     final outgoingCreditsResponse = outgoingCreditsResponseFromJson(jsonString);

import 'dart:convert';

List<OutgoingCreditResponse> outgoingCreditsResponseFromJson(String str) =>
    List<OutgoingCreditResponse>.from(json.decode(str).map((x) => OutgoingCreditResponse.fromJson(x)));

String outgoingCreditsResponseToJson(List<OutgoingCreditResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OutgoingCreditResponse {
  String transnum;
  String target;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String apiInfo;
  String status;

  OutgoingCreditResponse({
    required this.transnum,
    required this.target,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.apiInfo,
    required this.status,
  });

  factory OutgoingCreditResponse.fromJson(Map<String, dynamic> json) => OutgoingCreditResponse(
    transnum: json["transnum"],
    target: json["target"],
    amount: json["amount"],
    currency: json["currency"],
    currencyName: json["currency_name"],
    transdate: DateTime.parse(json["transdate"]),
    apiInfo: json["api_info"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "transnum": transnum,
    "target": target,
    "amount": amount,
    "currency": currency,
    "currency_name": currencyName,
    "transdate": transdate.toIso8601String(),
    "api_info": apiInfo,
    "status": status,
  };
}
