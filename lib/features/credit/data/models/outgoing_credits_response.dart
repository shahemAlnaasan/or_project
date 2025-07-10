// To parse this JSON data, do
//
//     final outgoingCreditsResponse = outgoingCreditsResponseFromJson(jsonString);

import 'dart:convert';

List<OutgoingCreditsResponse> outgoingCreditsResponseFromJson(String str) =>
    List<OutgoingCreditsResponse>.from(json.decode(str).map((x) => OutgoingCreditsResponse.fromJson(x)));

String outgoingCreditsResponseToJson(List<OutgoingCreditsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OutgoingCreditsResponse {
  String transnum;
  String target;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String apiInfo;
  String status;

  OutgoingCreditsResponse({
    required this.transnum,
    required this.target,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.apiInfo,
    required this.status,
  });

  factory OutgoingCreditsResponse.fromJson(Map<String, dynamic> json) => OutgoingCreditsResponse(
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
