// To parse this JSON data, do
//
//     final getTransTargetsResponse = getTransTargetsResponseFromJson(jsonString);

import 'dart:convert';

GetTransTargetsResponse getTransTargetsResponseFromJson(String str) =>
    GetTransTargetsResponse.fromJson(json.decode(str));

String getTransTargetsResponseToJson(GetTransTargetsResponse data) => json.encode(data.toJson());

class GetTransTargetsResponse {
  int status;
  Map<String, Target> data;

  GetTransTargetsResponse({required this.status, required this.data});

  factory GetTransTargetsResponse.fromJson(Map<String, dynamic> json) => GetTransTargetsResponse(
    status: json["status"],
    data: Map.from(json["data"]).map((k, v) => MapEntry<String, Target>(k, Target.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Target {
  String cid;
  String cn;
  String api;

  Target({required this.cid, required this.cn, required this.api});

  factory Target.fromJson(Map<String, dynamic> json) => Target(cid: json["CID"], cn: json["CN"], api: json["api"]);

  Map<String, dynamic> toJson() => {"CID": cid, "CN": cn, "api": api};
}
