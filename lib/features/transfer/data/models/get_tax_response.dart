// To parse this JSON data, do
//
//     final getTaxResponse = getTaxResponseFromJson(jsonString);

import 'dart:convert';

GetTaxResponse getTaxResponseFromJson(String str) => GetTaxResponse.fromJson(json.decode(str));

String getTaxResponseToJson(GetTaxResponse data) => json.encode(data.toJson());

class GetTaxResponse {
  int status;
  Data data;

  GetTaxResponse({required this.status, required this.data});

  factory GetTaxResponse.fromJson(Map<String, dynamic> json) =>
      GetTaxResponse(status: json["status"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  double tax;
  String intax;
  int extax;
  String error;

  Data({required this.tax, required this.intax, required this.extax, required this.error});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(tax: json["tax"]?.toDouble(), intax: json["intax"], extax: json["extax"], error: json["error"]);

  Map<String, dynamic> toJson() => {"tax": tax, "intax": intax, "extax": extax, "error": error};
}
