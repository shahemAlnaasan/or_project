// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_ce/hive.dart';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel extends HiveObject {
  final String status;
  final String id;
  final String message;
  final String? systemActive;
  final String? trust;
  final String? authkey;
  final String? name;

  LoginResponseModel({
    required this.status,
    required this.id,
    required this.message,
    this.systemActive,
    this.trust,
    this.authkey,
    this.name,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json["status"].toString(),
      id: json["id"].toString(),
      message: json["message"],
      systemActive: json["system_active"],
      trust: json["trust"],
      authkey: json["key"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
    "message": message,
    "system_active": systemActive,
    "trust": trust,
    "key": authkey,
    "name": name,
  };
}
