// To parse this JSON data, do
//
//     final newTransResponse = newTransResponseFromJson(jsonString);

import 'dart:convert';

NewTransResponse newTransResponseFromJson(String str) => NewTransResponse.fromJson(json.decode(str));

String newTransResponseToJson(NewTransResponse data) => json.encode(data.toJson());

class NewTransResponse {
  int status;
  String transnum;
  int password;
  int tax;
  String taxcurrency;

  NewTransResponse({
    required this.status,
    required this.transnum,
    required this.password,
    required this.tax,
    required this.taxcurrency,
  });

  factory NewTransResponse.fromJson(Map<String, dynamic> json) => NewTransResponse(
    status: json["status"],
    transnum: json["transnum"],
    password: json["password"],
    tax: json["tax"],
    taxcurrency: json["taxcurrency"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "transnum": transnum,
    "password": password,
    "tax": tax,
    "taxcurrency": taxcurrency,
  };
}
