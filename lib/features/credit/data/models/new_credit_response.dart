// To parse this JSON data, do
//
//     final newCreditResponse = newCreditResponseFromJson(jsonString);

import 'dart:convert';

NewCreditResponse newCreditResponseFromJson(String str) => NewCreditResponse.fromJson(json.decode(str));

String newCreditResponseToJson(NewCreditResponse data) => json.encode(data.toJson());

class NewCreditResponse {
  int status;
  String transnum;
  String password;
  String externalNum;

  NewCreditResponse({required this.status, required this.transnum, required this.password, required this.externalNum});

  factory NewCreditResponse.fromJson(Map<String, dynamic> json) => NewCreditResponse(
    status: json["status"],
    transnum: json["transnum"],
    password: json["password"],
    externalNum: json["external_num"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "transnum": transnum,
    "password": password,
    "external_num": externalNum,
  };
}
