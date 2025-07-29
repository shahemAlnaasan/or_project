// To parse this JSON data, do
//
//     final getCreditTargetsResponse = getCreditTargetsResponseFromJson(jsonString);

import 'dart:convert';

GetCreditTargetsResponse getCreditTargetsResponseFromJson(String str) =>
    GetCreditTargetsResponse.fromJson(json.decode(str));

String getCreditTargetsResponseToJson(GetCreditTargetsResponse data) => json.encode(data.toJson());

class GetCreditTargetsResponse {
  int status;
  List<Target> targets;

  GetCreditTargetsResponse({required this.status, required this.targets});

  factory GetCreditTargetsResponse.fromJson(Map<String, dynamic> json) => GetCreditTargetsResponse(
    status: json["status"],
    targets: List<Target>.from(json["targets"].map((x) => Target.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"status": status, "targets": List<dynamic>.from(targets.map((x) => x.toJson()))};
}

class Target {
  String cid;
  String cn;

  Target({required this.cid, required this.cn});

  factory Target.fromJson(Map<String, dynamic> json) => Target(cid: json["CID"], cn: json["CN"]);

  Map<String, dynamic> toJson() => {"CID": cid, "CN": cn};
}
