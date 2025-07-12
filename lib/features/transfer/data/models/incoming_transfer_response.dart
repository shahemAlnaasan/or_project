// To parse this JSON data, do
//
//     final incomingTransferResponse = incomingTransferResponseFromJson(jsonString);

import 'dart:convert';

IncomingTransferResponse incomingTransferResponseFromJson(String str) =>
    IncomingTransferResponse.fromJson(json.decode(str));

String incomingTransferResponseToJson(IncomingTransferResponse data) => json.encode(data.toJson());

class IncomingTransferResponse {
  int status;
  List<Datum> data;

  IncomingTransferResponse({required this.status, required this.data});

  factory IncomingTransferResponse.fromJson(Map<String, dynamic> json) => IncomingTransferResponse(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class Datum {
  String transnum;
  String source;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String notes;
  String status;

  Datum({
    required this.transnum,
    required this.source,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.notes,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
