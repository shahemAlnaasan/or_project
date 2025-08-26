// To parse this JSON data, do
//
//     final getCompaniesResponse = getCompaniesResponseFromJson(jsonString);

import 'dart:convert';

GetCompaniesResponse getCompaniesResponseFromJson(String str) => GetCompaniesResponse.fromJson(json.decode(str));

String getCompaniesResponseToJson(GetCompaniesResponse data) => json.encode(data.toJson());

class GetCompaniesResponse {
  int status;
  List<Company> companies;

  GetCompaniesResponse({required this.status, required this.companies});

  factory GetCompaniesResponse.fromJson(Map<String, dynamic> json) => GetCompaniesResponse(
    status: json["status"],
    companies: List<Company>.from(json["companies"].map((x) => Company.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "companies": List<dynamic>.from(companies.map((x) => x.toJson())),
  };
}

class Company {
  String id;
  String name;
  String? img;

  Company({required this.id, required this.name, required this.img});

  factory Company.fromJson(Map<String, dynamic> json) =>
      Company(id: json["id"], name: json["name"], img: json["img"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name, "img": img};
}
