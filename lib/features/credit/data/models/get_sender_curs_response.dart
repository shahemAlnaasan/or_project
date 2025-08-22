// To parse this JSON data, do
//
//     final getSenderCursResponse = getSenderCursResponseFromJson(jsonString);

import 'dart:convert';

GetSenderCursResponse getSenderCursResponseFromJson(String str) => GetSenderCursResponse.fromJson(json.decode(str));

String getSenderCursResponseToJson(GetSenderCursResponse data) => json.encode(data.toJson());

class GetSenderCursResponse {
  int status;
  Data data;

  GetSenderCursResponse({required this.status, required this.data});

  factory GetSenderCursResponse.fromJson(Map<String, dynamic> json) =>
      GetSenderCursResponse(status: json["status"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  String curs;

  Data({required this.curs});

  factory Data.fromJson(Map<String, dynamic> json) => Data(curs: json["curs"]);

  Map<String, dynamic> toJson() => {"curs": curs};
}
