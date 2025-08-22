// To parse this JSON data, do
//
//     final getCreditTaxResponse = getCreditTaxResponseFromJson(jsonString);

import 'dart:convert';

GetCreditTaxResponse getCreditTaxResponseFromJson(String str) => GetCreditTaxResponse.fromJson(json.decode(str));

String getCreditTaxResponseToJson(GetCreditTaxResponse data) => json.encode(data.toJson());

class GetCreditTaxResponse {
  int status;
  String tax;
  String error;

  GetCreditTaxResponse({required this.status, required this.tax, required this.error});

  factory GetCreditTaxResponse.fromJson(Map<String, dynamic> json) =>
      GetCreditTaxResponse(status: json["status"], tax: json["tax"].toString(), error: json["error"]);

  Map<String, dynamic> toJson() => {"status": status, "tax": tax, "error": error};
}
