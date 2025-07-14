// To parse this JSON data, do
//
//     final receivedTransfersResponse = receivedTransfersResponseFromJson(jsonString);

import 'dart:convert';

ReceivedTransfersResponse receivedTransfersResponseFromJson(String str) =>
    ReceivedTransfersResponse.fromJson(json.decode(str));

String receivedTransfersResponseToJson(ReceivedTransfersResponse data) => json.encode(data.toJson());

class ReceivedTransfersResponse {
  int status;
  List<ReceivedTransfers> data;

  ReceivedTransfersResponse({required this.status, required this.data});

  factory ReceivedTransfersResponse.fromJson(Map<String, dynamic> json) => ReceivedTransfersResponse(
    status: json["status"],
    data: List<ReceivedTransfers>.from(json["data"].map((x) => ReceivedTransfers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class ReceivedTransfers {
  String transnum;
  String source;
  String amount;
  String currency;
  String currencyName;
  DateTime transdate;
  String notes;
  String status;

  ReceivedTransfers({
    required this.transnum,
    required this.source,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.notes,
    required this.status,
  });

  factory ReceivedTransfers.fromJson(Map<String, dynamic> json) => ReceivedTransfers(
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
