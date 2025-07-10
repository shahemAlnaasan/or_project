// To parse this JSON data, do
//
//     final verifyLoginResponse = verifyLoginResponseFromJson(jsonString);

import 'dart:convert';

VerifyLoginResponse verifyLoginResponseFromJson(String str) => VerifyLoginResponse.fromJson(json.decode(str));

String verifyLoginResponseToJson(VerifyLoginResponse data) => json.encode(data.toJson());

class VerifyLoginResponse {
  String status;
  String id;
  String type;
  String permission;
  Info info;
  String message;
  String token;
  String systemActive;

  VerifyLoginResponse({
    required this.status,
    required this.id,
    required this.type,
    required this.permission,
    required this.info,
    required this.message,
    required this.token,
    required this.systemActive,
  });

  factory VerifyLoginResponse.fromJson(Map<String, dynamic> json) => VerifyLoginResponse(
    status: json["status"],
    id: json["id"],
    type: json["type"],
    permission: json["permission"],
    info: Info.fromJson(json["info"]),
    message: json["message"],
    token: json["token"],
    systemActive: json["system_active"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
    "type": type,
    "permission": permission,
    "info": info.toJson(),
    "message": message,
    "token": token,
    "system_active": systemActive,
  };
}

class Info {
  String name;
  String phone;
  String address;
  String box;

  Info({required this.name, required this.phone, required this.address, required this.box});

  factory Info.fromJson(Map<String, dynamic> json) =>
      Info(name: json["name"], phone: json["phone"], address: json["address"], box: json["box"]);

  Map<String, dynamic> toJson() => {"name": name, "phone": phone, "address": address, "box": box};
}
