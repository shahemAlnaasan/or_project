// To parse this JSON data, do
//
//     final incomingTransferResponse = incomingTransferResponseFromJson(jsonString);

import 'dart:convert';

IncomingTransferResponse incomingTransferResponseFromJson(String str) =>
    IncomingTransferResponse.fromJson(json.decode(str));

String incomingTransferResponseToJson(IncomingTransferResponse data) => json.encode(data.toJson());

class IncomingTransferResponse {
  int status;
  List<IncomingTransfers> data;

  IncomingTransferResponse({required this.status, required this.data});

  factory IncomingTransferResponse.fromJson(Map<String, dynamic> json) => IncomingTransferResponse(
    status: json["status"],
    data: List<IncomingTransfers>.from(json["data"].map((x) => IncomingTransfers.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class IncomingTransfers {
  String transnum;
  String source;
  String amount;
  String currency;
  String currencyName;
  String benename;
  String benephone;
  String tax;
  DateTime transdate;
  String notes;
  String status;

  IncomingTransfers({
    required this.transnum,
    required this.source,
    required this.amount,
    required this.currency,
    required this.currencyName,
    required this.transdate,
    required this.notes,
    required this.status,
    required this.benename,
    required this.benephone,
    required this.tax,
  });

  factory IncomingTransfers.fromJson(Map<String, dynamic> json) => IncomingTransfers(
    transnum: json["transnum"],
    source: json["source"],
    amount: json["amount"],
    currency: json["currency"],
    currencyName: json["currency_name"],
    transdate: DateTime.parse(json["transdate"]),
    notes: json["notes"],
    status: json["status"],
    tax: json["tax"],
    benename: json["benename"],
    benephone: json["benephone"],
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
    "tax": tax,
    "benename": benename,
    "benephone": benephone,
  };
}
