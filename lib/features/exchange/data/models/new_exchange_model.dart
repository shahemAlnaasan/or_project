// To parse this JSON data, do
//
//     final newExchangeResponse = newExchangeResponseFromJson(jsonString);

import 'dart:convert';

NewExchangeResponse newExchangeResponseFromJson(String str) => NewExchangeResponse.fromJson(json.decode(str));

String newExchangeResponseToJson(NewExchangeResponse data) => json.encode(data.toJson());

class NewExchangeResponse {
  int status;
  String transnum;
  String message;

  NewExchangeResponse({required this.status, required this.transnum, required this.message});

  factory NewExchangeResponse.fromJson(Map<String, dynamic> json) =>
      NewExchangeResponse(status: json["status"], transnum: json["transnum"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "transnum": transnum, "message": message};
}
