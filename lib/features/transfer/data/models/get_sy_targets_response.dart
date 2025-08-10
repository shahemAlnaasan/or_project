// To parse this JSON data, do
//
//     final getSyTargetsResponse = getSyTargetsResponseFromJson(jsonString);

import 'dart:convert';

GetSyTargetsResponse getSyTargetsResponseFromJson(String str) => GetSyTargetsResponse.fromJson(json.decode(str));

String getSyTargetsResponseToJson(GetSyTargetsResponse data) => json.encode(data.toJson());

class GetSyTargetsResponse {
  int status;
  Map<String, Target> targets;

  GetSyTargetsResponse({required this.status, required this.targets});

  factory GetSyTargetsResponse.fromJson(Map<String, dynamic> json) => GetSyTargetsResponse(
    status: json["status"],
    targets: Map.from(json["data"]).map((k, v) => MapEntry<String, Target>(k, Target.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": Map.from(targets).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Target {
  String cid;
  String cn;

  Target({required this.cid, required this.cn});

  factory Target.fromJson(Map<String, dynamic> json) => Target(cid: json["CID"], cn: json["CN"]);

  Map<String, dynamic> toJson() => {"CID": cid, "CN": cn};
}
