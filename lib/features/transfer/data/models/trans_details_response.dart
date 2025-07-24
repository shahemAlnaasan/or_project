// To parse this JSON data, do
//
//     final transDetailsResponse = transDetailsResponseFromJson(jsonString);

import 'dart:convert';

TransDetailsResponse transDetailsResponseFromJson(String str) => TransDetailsResponse.fromJson(json.decode(str));

String transDetailsResponseToJson(TransDetailsResponse data) => json.encode(data.toJson());

class TransDetailsResponse {
  int status;
  Data data;

  TransDetailsResponse({required this.status, required this.data});

  factory TransDetailsResponse.fromJson(Map<String, dynamic> json) =>
      TransDetailsResponse(status: json["status"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  String transnum;
  String password;
  DateTime transdate;
  DateTime? rcvdate;
  String srcName;
  String srcBox;
  String targetName;
  String targetAddress;
  String targetBox;
  String currencyId;
  String currencyName;
  String amount;
  String status;
  String notes;
  String benifName;
  String benifPhone;
  String api;
  String apiTransnum;
  String apiInfo;
  String fee;
  String company;
  String header;

  Data({
    required this.transnum,
    required this.password,
    required this.transdate,
    required this.rcvdate,
    required this.srcName,
    required this.srcBox,
    required this.targetName,
    required this.targetAddress,
    required this.targetBox,
    required this.currencyId,
    required this.currencyName,
    required this.amount,
    required this.status,
    required this.notes,
    required this.benifName,
    required this.benifPhone,
    required this.api,
    required this.apiTransnum,
    required this.apiInfo,
    required this.fee,
    required this.company,
    required this.header,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transnum: json["transnum"] ?? "",
    password: json["password"] ?? "",
    transdate: DateTime.parse(json["transdate"] ?? ""),
    rcvdate: json["rcvdate"],
    srcName: json["src_name"] ?? "",
    srcBox: json["src_box"] ?? "",
    targetName: json["target_name"] ?? "",
    targetAddress: json["target_address"] ?? "",
    targetBox: json["target_box"] ?? "",
    currencyId: json["currency_id"] ?? "",
    currencyName: json["currency_name"] ?? "",
    amount: json["amount"] ?? "",
    status: json["status"] ?? "",
    notes: json["notes"] ?? "",
    benifName: json["benif_name"] ?? "",
    benifPhone: json["benif_phone"] ?? "",
    api: json["api"] ?? "",
    apiTransnum: json["api_transnum"] ?? "",
    apiInfo: json["api_info"] ?? "",
    fee: json["fee"] ?? "",
    company: json["company"] ?? "",
    header: json["header"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "transnum": transnum,
    "password": password,
    "transdate": transdate.toIso8601String(),
    "rcvdate": rcvdate,
    "src_name": srcName,
    "src_box": srcBox,
    "target_name": targetName,
    "target_address": targetAddress,
    "target_box": targetBox,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "amount": amount,
    "status": status,
    "notes": notes,
    "benif_name": benifName,
    "benif_phone": benifPhone,
    "api": api,
    "api_transnum": apiTransnum,
    "api_info": apiInfo,
    "fee": fee,
    "company": company,
    "header": header,
  };
}
