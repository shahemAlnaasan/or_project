// To parse this JSON data, do
//
//     final getTargetInfoResponse = getTargetInfoResponseFromJson(jsonString);

import 'dart:convert';

GetTargetInfoResponse getTargetInfoResponseFromJson(String str) => GetTargetInfoResponse.fromJson(json.decode(str));

String getTargetInfoResponseToJson(GetTargetInfoResponse data) => json.encode(data.toJson());

class GetTargetInfoResponse {
  int status;
  Data? data;

  GetTargetInfoResponse({required this.status, this.data});

  factory GetTargetInfoResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];
    return GetTargetInfoResponse(
      status: json["status"],
      data: (rawData is Map<String, dynamic>) ? Data.fromJson(rawData) : null,
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson() ?? {}};
}

class Data {
  String address;
  String phone;
  String curs;

  Data({required this.address, required this.phone, required this.curs});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(address: json["address"], phone: json["phone"], curs: json["curs"]);

  Map<String, dynamic> toJson() => {"address": address, "phone": phone, "curs": curs};
}
