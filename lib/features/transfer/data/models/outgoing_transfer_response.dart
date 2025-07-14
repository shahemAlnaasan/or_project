// To parse this JSON data, do
//
//     final outgoingTransferResponse = outgoingTransferResponseFromJson(jsonString);

import 'dart:convert';

OutgoingTransferResponse outgoingTransferResponseFromJson(String str) =>
    OutgoingTransferResponse.fromJson(json.decode(str));

String outgoingTransferResponseToJson(OutgoingTransferResponse data) => json.encode(data.toJson());

class OutgoingTransferResponse {
  int status;
  List<OutgoingTransfers> data;

  OutgoingTransferResponse({required this.status, required this.data});

  factory OutgoingTransferResponse.fromJson(Map<String, dynamic> json) => OutgoingTransferResponse(
    status: json["status"],
    data: List<OutgoingTransfers>.from(json["data"].map((x) => OutgoingTransfers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class OutgoingTransfers {
  String transnum;
  String target;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String apiInfo;
  String status;

  OutgoingTransfers({
    required this.transnum,
    required this.target,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.apiInfo,
    required this.status,
  });

  factory OutgoingTransfers.fromJson(Map<String, dynamic> json) => OutgoingTransfers(
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
